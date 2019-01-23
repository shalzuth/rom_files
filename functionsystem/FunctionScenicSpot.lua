
FunctionScenicSpot = class("FunctionScenicSpot")

FunctionScenicSpot.Event = {
	StateChanged = {}, -- data.validScenicSpots
	ScenicSpotInvalidated = {}, -- data.invalidSceneSpot
}
local tempVector3 = LuaVector3.zero

function FunctionScenicSpot.Me()
	if nil == FunctionScenicSpot.me then
		FunctionScenicSpot.me = FunctionScenicSpot.new()
	end
	return FunctionScenicSpot.me
end

function FunctionScenicSpot:ctor()
	self:Reset()
end

function FunctionScenicSpot:Reset()
	self.deltaTime = 0

	return true
end

function FunctionScenicSpot:GetAllScenicSpot()
	return self.scenicSpots
end

function FunctionScenicSpot:GetScenicSpots(ssID)
	if nil == self.scenicSpots then
		return nil
	end
	return self.scenicSpots[ssID]
end

function FunctionScenicSpot:GetScenicSpot(ssID)
	if nil == self.scenicSpots then
		return nil
	end

	local spot =  self.scenicSpots[ssID]
	if(spot and not spot.ID and spot[1])then
		self:UpdateScenicCreaturePos(spot[1])
		return spot[1]
	end
	return spot
end

function FunctionScenicSpot:RemoveScenicSpot(ssID)
	if nil == self.scenicSpots then
		return nil
	end

	local ss = self.scenicSpots[ssID]
	self.scenicSpots[ssID] = nil
	return ss
end

function FunctionScenicSpot:AddCreatureScenicSpot(guid,ssID)
	local creature = SceneCreatureProxy.FindCreature(guid)
	if(not creature) then
		return
	end
	self.scenicSpots = self.scenicSpots or {}
	local ss = self.scenicSpots[ssID]
	if(ss)then
		for i=1,#ss do
			local single = ss[i]
			if(single.guid == guid)then
				return
			end
		end
	else
		ss = {}
	end

	local epTransform = creature.assetRole:GetEP(RoleDefines_EP.Top)
	local data = {ID = ssID,position = LuaVector3.zero,guid = guid}
	if(epTransform)then
		data.position = LuaVector3(LuaGameObject.GetPosition(epTransform))
	end
	ss[#ss +1] = data
	self.scenicSpots[ssID] = ss
	return data
end

local tempArray = {}
function FunctionScenicSpot:RemoveCreatureScenicSpot(guid,ssID)
	if nil == self.scenicSpots then
		return nil
	end
	local removeData = nil
	if(ssID)then
		local ss = self.scenicSpots[ssID]
		if(not ss)then
			return
		end
		for i=1,#ss do
			local single = ss[i]
			if(single.guid == guid)then
				table.remove(ss,i)
				removeData = single
				if(#ss == 0)then
					self.scenicSpots[ssID] = nil
				end
				break
			end
		end
		if(removeData)then
			self:Notify(MiniMapEvent.CreatureScenicRemove,removeData)
		end
		return
	end

	for k,v in pairs(self.scenicSpots) do
		if(not v.ID)then
			for i=1,#v do
				local single = v[i]
				if(single.guid == guid)then
					ssID = single.ID
					removeData = single
					table.remove(v,i)
					if(#v == 0)then
						self.scenicSpots[single.ID] = nil
					end
					break
				end
			end
		end
	end
	if(removeData)then
		self:Notify(MiniMapEvent.CreatureScenicRemove,removeData)
	end
end

function FunctionScenicSpot:GetNearestScenicSpot(originPos, camera)
	if nil == self.scenicSpots then
		return nil
	end
	local nearestScenicSpot = nil
	local minDistance = 9999999
	for k,v in pairs(self.scenicSpots) do
		local ss = v
		-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] position=(%f,%f,%f)", 
		-- 			ss.ID, ss.position.x, ss.position.y, ss.position.z))
		local distance = -1
		if(v.ID)then
			if nil ~= camera then
				local viewport = camera:WorldToViewportPoint(ss.position)
				-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] viewPort=(%f,%f,%f)", 
				-- 		ss.ID, viewport.x, viewport.y, viewport.z))
				if 0 < viewport.x and 1 > viewport.x
					and 0 < viewport.y and 1 > viewport.y
					and camera.nearClipPlane < viewport.z and camera.farClipPlane > viewport.z then
					distance = viewport.z
				end
			else
				distance = LuaVector3.Distance(ss.position, originPos)
			end
			-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] distance=%f", 
			-- 			ss.ID, distance))
			if 0 < distance and distance < minDistance then
				minDistance = distance
				nearestScenicSpot = ss
				-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] minDistance=%f", 
				-- 		ss.ID, minDistance))
			end
		else
			
			for i=1,#v do
				local single = v[i]
				self:UpdateScenicCreaturePos(single)
				if nil ~= camera then
					local viewport = camera:WorldToViewportPoint(single.position)
					-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] viewPort=(%f,%f,%f)", 
					-- 		ss.ID, viewport.x, viewport.y, viewport.z))
					if 0 < viewport.x and 1 > viewport.x
						and 0 < viewport.y and 1 > viewport.y
						and camera.nearClipPlane < viewport.z and camera.farClipPlane > viewport.z then
						distance = viewport.z
					end
				else
					distance = LuaVector3.Distance(single.position, originPos)
				end
				-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] distance=%f", 
				-- 			ss.ID, distance))
				if 0 < distance and distance < minDistance then
					minDistance = distance
					nearestScenicSpot = single
					-- print(string.format("<color=yellow>GetNearestScenicSpot: </color>[%d] minDistance=%f", 
					-- 		ss.ID, minDistance))
				end
			end
		end
	end

	return nearestScenicSpot
end

function FunctionScenicSpot:UpdateScenicCreaturePos(senicData)
	local creature = SceneCreatureProxy.FindCreature(senicData.guid)
	if(not creature) then
		return
	end

	local epTransform = creature.assetRole:GetEP(RoleDefines_EP.Top)
	if(epTransform)then
		tempVector3:Set(LuaGameObject.GetPosition(epTransform))
		if(senicData.position and tempVector3:Equal(senicData.position) )then
			return 
		end
		senicData.position = LuaVector3(LuaGameObject.GetPosition(epTransform))
		return true
	end
end

function FunctionScenicSpot:ResetValidScenicSpots(validScenicSpotIDs)
	if not self:Reset() then
		return false
	end

	local validScenicSpots = {}

	-- use MapNum begin
	-- local scenicSpotsIDs = Table_Map[SceneProxy.Instance:GetCurMapID()].ScenicSpots
	-- if nil == scenicSpotsIDs then
	-- 	return false
	-- end

	-- for i=1, #validScenicSpotIDs do
	-- 	local ssID = scenicSpotsIDs[validScenicSpotIDs[i]]
	-- 	if nil ~= ssID then
	-- 		local info = Table_Viewspot[ssID]
	-- 		if nil ~= info then
	-- 			local coordinate = info.Coordinate

	-- 			local ss = {}
	-- 			ss.ID = ssID
	-- 			ss.position = TableUtil.Array2Vector3(coordinate)
	-- 			validScenicSpots[ssID] = ss
	-- 		end
	-- 	end
	-- end
	-- self.scenicSpots = validScenicSpots
	-- use MapNum end

	-- use id begin
	for i=1, #validScenicSpotIDs do
		local ssID = validScenicSpotIDs[i].sceneryid
		-- print(string.format("<color=yellow>FunctionScenicSpot: </color>valid id=%d", ssID))
		if nil ~= ssID then
			local info = Table_Viewspot[ssID]
			if nil ~= info then
				local coordinate = info.Coordinate

				local ss = {}
				ss.ID = ssID
				ss.position = LuaVector3(coordinate[1],coordinate[2],coordinate[3])
				validScenicSpots[ssID] = ss
				-- print(string.format("<color=yellow>FunctionScenicSpot: </color>[%d] position=(%f,%f,%f)", 
				-- 	ssID, ss.position.x, ss.position.y, ss.position.z))
			end
		end
	end
	if(not self.scenicSpots)then
		self.scenicSpots = validScenicSpots
	else
		for k,v in pairs(self.scenicSpots) do
			if(not v.ID)then
				local ss = validScenicSpots[k] or {}
				for i=1,#v do
					local single = v[i]
					ss[#ss+1] = v[i]
				end
				validScenicSpots[k] = ss
			end
		end
		self.scenicSpots = validScenicSpots
	end

	local data = {}
	data.validScenicSpots = validScenicSpots
	self:Notify(FunctionScenicSpot.Event.StateChanged, data)
	return true
end

function FunctionScenicSpot:InvalidateScenicSpot(data)
	-- local ss = self:RemoveScenicSpot(scenicSpotID)
	-- self:Notify(FunctionScenicSpot.Event.ScenicSpotInvalidated, {invalidSceneSpot=ss})
	
	-- use MapNum begin
	-- ServiceNUserProxy.Instance:CallSceneryUserCmd(nil, {[1]=Table_Viewspot[scenicSpotID].MapNum})
	-- use MapNum end

	-- use id begin
	ServiceNUserProxy.Instance:CallSceneryUserCmd(nil, {[1]=data})
	-- use id end
	return true
end

function FunctionScenicSpot:Update(time, deltaTime)
	if(self.deltaTime < 1 and deltaTime)then
		self.deltaTime = self.deltaTime +deltaTime
		return
	end
	-- helplog("time:"..tostring(time).." deltaTime:"..tostring(deltaTime))
	
	self.deltaTime = 0
	if(not self.scenicSpots)then
		return
	end
	local changeList = {}
	for k,v in pairs(self.scenicSpots) do
		local ss = v
		if(not v.ID)then
			for i=1,#v do
				local single = v[i]
				local changed = self:UpdateScenicCreaturePos(single)				
				if(changed)then
					changeList[#changeList+1] = single
				end
			end
		end
	end
	if(#changeList>0)then
		self:Notify(MiniMapEvent.CreatureScenicChange,changeList)
	end
end

function FunctionScenicSpot:Notify(event, data)
	if nil == GameFacade then
		return
	end
	GameFacade.Instance:sendNotification(event, data)
end