SceneData = class("SceneData")

SceneData.LoadMode = {
	Default = 1,
	Illustration = 2,
	NewExplore = 3,
	QuickLoadWithoutProgress = 4,
}

SceneData.MapFeature = {
	--变身后的玩家可以在该地图PK
	TransformAtk = 0,
}

function SceneData.MapIDIsPVPMap(mapID)
	return Table_Map[mapID].PVPmap == 1
end

function SceneData:ctor(ChangeSceneUserCmd)
	self:Reset(ChangeSceneUserCmd)
end

function SceneData:ParseServerData(serverData)
	local pos
	if(serverData.pos) then
		pos = {}
		pos.x,pos.y,pos.z = serverData.pos.x,serverData.pos.y,serverData.pos.z
	end
	local invisiblexit= {}
	if(serverData.invisiblexit) then
		for i=1,#serverData.invisiblexit do
			invisiblexit[i] = serverData.invisiblexit[i]
		end
	end
	return {
		mapID = serverData.mapID,
		mapName = serverData.mapName,
		dmapID = serverData.dmapID,
		preview = serverData.preview,
		pos = pos,
		invisiblexit = invisiblexit,
		imageid = serverData.imageid
	}
end

function SceneData:Reset( ChangeSceneUserCmd )
	self.serverData = self:ParseServerData(ChangeSceneUserCmd)
	self.mapID = ChangeSceneUserCmd.mapID
	self.mapStaticData = Table_Map[self.mapID]
	--副本地图id，为0则代表在非副本地图中
	self.dungeonMapId = ChangeSceneUserCmd.dmapID
	self.mapName = "Scene"..self:GetData().NameEn
	self.mapNameZH = ChangeSceneUserCmd.mapName
	self.invisiblexit = self.serverData.invisiblexit
	self.loadMode = SceneData.LoadMode.Default
	self.preview = ChangeSceneUserCmd.preview
	self.imageid = ChangeSceneUserCmd.imageid;
	-- self.loadMode = SceneData.LoadMode.Illustration
	self.loaded = false
	self.param = nil
end

function SceneData:SetIllustrationLoadMode(pic)
	self.loadMode = SceneData.LoadMode.Illustration
	self.param = pic
end

function SceneData:SetNewExploreMapArea(mapData)
	self.loadMode = SceneData.LoadMode.NewExplore
	self.param = mapData
end

-- -1 代表无限速
function SceneData:SetQuickLoadWithoutProgress(limitTime)
	self.loadMode = SceneData.LoadMode.QuickLoadWithoutProgress
	self.param = limitTime
end

function SceneData:GetData()
	return self.mapStaticData
end

function SceneData:GetBundleName()
	if(string.find(self.mapName , "___")) then
		return string.gsub(self.mapName,"___(%w+)","")
	end
	return self.mapName
end

function SceneData:IsPvPMap()
	return SceneData.MapIDIsPVPMap(self.mapID)
end

function SceneData:IsInDungeonMap()
	return self.dungeonMapId ~= 0
end

function SceneData:IsSameMapOrRaid(id)
	return self.mapID == id or self.dungeonMapId ==id
end

function SceneData:CanTransformAtk()
	local feature = self.mapStaticData.MapCompositeFunction
	if(feature and BitUtil.valid(feature,SceneData.MapFeature.TransformAtk)) then
		return (BitUtil.band(feature,SceneData.MapFeature.TransformAtk)>0)
	end
	return false
end
-- return Prop