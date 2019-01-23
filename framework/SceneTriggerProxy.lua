autoImport("SceneObjectProxy")
SceneTriggerProxy = class('SceneTriggerProxy', SceneObjectProxy)

SceneTriggerProxy.Instance = nil;

SceneTriggerProxy.NAME = "SceneTriggerProxy"

-- autoImport("Table_RoleData")

function SceneTriggerProxy:ctor(proxyName, data)
	self:Reset()
	self.addMode = SceneObjectProxy.AddMode.Normal
	self.proxyName = proxyName or SceneTriggerProxy.NAME
	SceneTriggerProxy.Instance = self
	if data ~= nil then
		self:setData(data)
	end
	self.typeFunc = {}
	self.typeFunc[SceneMap_pb.EACTTYPE_PURIFY] = self.SpawnPurify
	self.typeFunc[SceneMap_pb.EACTTYPE_SEAL] = self.RepairSeal;
	self.typeFunc[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.SceneEvent;
	self.typeFunc[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.GvgDroiyan_FightForArea_Handle
end

function SceneTriggerProxy:Reset()
	self.userMap = {}
end

function SceneTriggerProxy:onRegister()
end

function SceneTriggerProxy:onRemove()
end

function SceneTriggerProxy:PureAddSome(datas)
	printRed("PureAddSome");
	for i=1,#datas do 
		self:Add(datas[i])
	end
end

function SceneTriggerProxy:Add(data)
	if(self:Find(data.id)==nil) then
		local func = self.typeFunc[data.type]
		if(func) then
			local trigger = func(self,data)
			self.userMap[trigger.id] = trigger
			Game.AreaTrigger_Common:AddCheck(trigger)
			-- print("add trigger range:",data.range)
		end
	end
end

-- 净化
function SceneTriggerProxy:SpawnPurify(data)
	local skillID = 20001001
	local pos = PosUtil.DevideVector3( data.pos.x,data.pos.y,data.pos.z )
	local skill = SkillProxy.Instance:GetLearnedSkillWithSameSort(skillID)
	FunctionPurify.Me():StartDarkCover(data.masterid)
	local result = ReusableTable.CreateTable()
	result.id = data.id
	result.pos = pos
	result.reachDis=data.range
	result.type = data.type
	result.serverData = data
	result.data = {id=skill.id, dis = data.range, skill = skillID}
	result.params = {data.actvalue}
	result.master = data.masterid
	return result;
end

function SceneTriggerProxy:RepairSeal(data)
	local pos = PosUtil.DevideVector3( data.pos.x,data.pos.y,data.pos.z )
	local result = ReusableTable.CreateTable()
	result.id = data.id
	result.pos = pos
	result.reachDis = data.range
	result.type = data.type
	result.serverData = data
	return result;
end

function SceneTriggerProxy:SceneEvent(data)
	local pos = PosUtil.DevideVector3( data.pos.x, data.pos.y, data.pos.z )
	local result = ReusableTable.CreateTable()
	result.id = data.id
	result.pos = LuaVector3(data.pos.x, data.pos.y, data.pos.z);
	result.reachDis = data.range
	result.type = data.type
	result.serverData = data
	return result;
end

function SceneTriggerProxy:GvgDroiyan_FightForArea_Handle(data)
	local pos = PosUtil.DevideVector3( data.pos.x, data.pos.y, data.pos.z )
	local result = ReusableTable.CreateTable()
	result.id = data.id
	result.pos = LuaVector3(data.pos.x, data.pos.y, data.pos.z);
	result.reachDis = data.range
	result.type = data.type
	result.serverData = data
	return result;
end

function SceneTriggerProxy:Remove(guid)
	local trigger = self:Find(guid)
	if(trigger~=nil) then
		print("移除mapact",guid)
		self.userMap[guid] = nil
		local areaTrigger = Game.AreaTrigger_Common
		if(areaTrigger) then
			local removed = areaTrigger:RemoveCheck(guid)
			if(removed) then
				ReusableTable.DestroyAndClearTable(removed)
			end
		end
	end
end

function SceneTriggerProxy:Clear()
	local areaTrigger = Game.AreaTrigger_Common
	if(areaTrigger) then
		local removed
		for k,v in pairs(self.userMap) do
			removed = areaTrigger:RemoveCheck(k)
			if(removed) then
				ReusableTable.DestroyAndClearTable(removed)
			end
		end
	end
	self:Reset()
end