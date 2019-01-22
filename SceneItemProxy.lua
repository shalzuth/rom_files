autoImport("SceneObjectProxy")
autoImport("SceneDropItem")
SceneItemProxy = class('SceneItemProxy',SceneObjectProxy)

SceneItemProxy.Instance = nil;

SceneItemProxy.NAME = "SceneItemProxy"

--???????????????????????????????????????????????????????????????????????????

function SceneItemProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneItemProxy.NAME
	self.userMap = {}
	self.addMode = SceneObjectProxy.AddMode.Normal
	if(SceneItemProxy.Instance == nil) then
		SceneItemProxy.Instance = self
	end
	self:InitConfig()
	self.tmp = {}
	self.maxTime = GameConfig.SceneDropItem.disappeartime * 1000 * 1.5
	self.poringFightMaxTime = 5 * 60 * 1000
	TimeTickManager.Me():CreateTick(0,2000,self.Tick,self)
end

function SceneItemProxy:Tick(deltaTime)
	local isPoringFight = Game.MapManager:IsPVPMode_PoringFight()
	for k,v in pairs(self.tmp)do
		v = v + deltaTime
		self.tmp[k] = v
		if(v>=self.maxTime) then
			if(not isPoringFight or v>=self.poringFightMaxTime) then
				local item = self.userMap[k]
				if(item~=nil) then
					-- Debug.LogFormat("<color=red> ???????????????30????????????????????????????????? {0} </color>",k)
					self:SetRemoveFlag(k)
				else
					self.tmp[k] = nil
				end
			end
		end
	end
end

function SceneItemProxy:InitConfig()
	self.typeConfig = {}
	for k,v in pairs(GameConfig.SceneDropItem) do
		if(type(v)=="table") then
			local types = v.Types
			if(types~=nil) then
				for i=1,#types do
					self.typeConfig[types[i]] = v
				end
			end
		end
	end
end

function SceneItemProxy:Add(data)
	local item = self.userMap[data.guid]
	if(item==nil) then
		local staticData = Table_Item[data.id]
		if(not staticData) then
			error(string.format("???????????????????????????%s,???????????????",data.id))
		end
		item = SceneDropItem.CreateAsTable()
		self.tmp[data.guid] = 0
		item:ResetData(data.guid,staticData,Table_Equip[data.id],data.time,data.pos,data.owners,self.typeConfig[staticData.Type],data.sourceid, data.refinelv)
		-- item = SceneDropItem.new(data.guid,staticData,Table_Equip[data.id],data.time,data.pos,data.owners,self.typeConfig[staticData.Type],data.sourceid)
		if(#data.owners==0 or (Game.Myself~=nil and TableUtil.ArrayIndexOf(data.owners,Game.Myself.data.id)>0)) then
			item.iCanPickUp = true
		end
		self.userMap[data.guid] = item
	else
		item = nil
	end
	if(item and FunctionPurify.Me():MonsterNeedPurify(item.sourceID)) then
		FunctionPurify.Me():AddDrops(item)
		item = nil
	end
	return item
end

function SceneItemProxy:PureAddSome(datas)
	local items = {}
	local item
	for i=1,#datas do
		item = self:Add(datas[i])
		if(item~=nil) then
			items[#items+1] = item
		end
	end
	return items
	-- print("SceneDropItemProxy PureAddSome")
end

function SceneItemProxy:DropItems(datas)
	local items = self:AddSome(datas)
	FunctionSceneItemCommand.Me():DropItems(items)
end

function SceneItemProxy:RefreshAdd(datas)
end

function SceneItemProxy:Remove(guid)
	local item = self.userMap[guid]
	if(item ~=nil) then
		item:DestroyUI()
		self.userMap[guid] = nil
	end
	self.tmp[guid] = nil
	return item
end

function SceneItemProxy:SetRemoveFlags(guids)
	for i=1,#guids do
		self:SetRemoveFlag(guids[i])
	end
	-- FunctionSceneItemCommand.Me():SetRemoveFlags(guids)
end

function SceneItemProxy:SetRemoveFlag(guid)
	if(self:Remove(guid)~=nil) then
		-- print("remove item:"..guid)
		FunctionSceneItemCommand.Me():SetRemoveFlag(guid)
	end
	-- FunctionSceneItemCommand.Me():SetRemoveFlags(guids)
end

function SceneItemProxy:RemoveSome(guids)
	-- local items = SceneDropItemProxy.super.RemoveSome(self,guids)
	-- DropSceneItemCommand.Me():RemoveItems(items)
end

function SceneItemProxy:Clear()
	-- local items = {}
	-- for _, o in pairs(self.userMap) do
	-- 	o:Destroy()
	-- 	items[#items+1] = o
 -- 	end
 	self.tmp = {}
 	self.userMap = {}
 	FunctionSceneItemCommand.Me():Clear()
 	-- GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,roles)
end