autoImport("Trap")
SceneTrapProxy = class('SceneTrapProxy', SceneObjectProxy)

SceneTrapProxy.Instance = nil;

SceneTrapProxy.NAME = "SceneTrapProxy"

--场景玩家（可见玩家）数据管理，添加、删除、查找玩家

function SceneTrapProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneTrapProxy.NAME
	self:Reset()
	self.addMode = SceneObjectProxy.AddMode.Normal
	if(SceneTrapProxy.Instance == nil) then
		SceneTrapProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end
end

function SceneTrapProxy:Reset()
	self.trapMap = {}
end

function SceneTrapProxy:Find(guid)
	-- print("try find id:"..guid.." type:"..type(guid))
	return self.trapMap[guid]
end

function SceneTrapProxy:CullingStateChange( guid,visible,distanceLevel )
	local trap = self.trapMap[guid]
	if(trap) then
		trap:CullingStateChange(visible,distanceLevel)
	end
end

function SceneTrapProxy:Add(data)
	-- LogUtility.InfoFormat("场景添加{0} 陷阱:{1},从属:{2}",
	-- 	data.id,
	-- 	data.skillID,
	-- 	data.masterid)
	if(self.trapMap[data.id] == nil) then
		local trap = Trap.CreateAsTable()
		trap:Init(data.id,data.skillID,data.masterid,data.pos)
		self.trapMap[data.id] = trap
		trap:SetRotation(data.dir)
		return trap
	end
	return nil
end

function SceneTrapProxy:PureAddSome(datas)
	for i=1,#datas do
		self:Add(datas[i])
	end
	return nil
end

function SceneTrapProxy:RefreshAdd(datas)
	return nil
end

function SceneTrapProxy:AddSome(datas)
	if(self.addMode == SceneObjectProxy.AddMode.Normal) then
		return self:PureAddSome(datas)
	elseif(self.addMode == SceneObjectProxy.AddMode.Refresh) then
		return self:RefreshAdd(datas)
	end
end

function SceneTrapProxy:Remove(guid)
	local trap = self.trapMap[guid]
	if(trap) then
		print(string.format("场景移除 陷阱:%s",guid))
		trap:Destroy()
		self.trapMap[guid] = nil
	end
	return trap
end

function SceneTrapProxy:RemoveSome(guids)
	-- local effects = {}
	if(guids ~= nil and #guids >0) then
		for i = 1, #guids do
			self:Remove(guids[i])
			-- if(self:Remove(guids[i])~=nil) then
			-- 	roles[#roles+1] = guids[i]
			-- 	-- table.insert(roles,guids[i])
			-- end
		end
	end
	-- return effects
end

function SceneTrapProxy:Clear()
	print("清空trap")
	self:ChangeAddMode(SceneObjectProxy.AddMode.Normal)
	for id, trap in pairs(self.trapMap) do
		trap:Destroy()
 	end
 	self:Reset()
 	-- GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,roles)
end