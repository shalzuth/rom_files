ServiceSkillAutoProxy = class('ServiceSkillAutoProxy', ServiceProxy)

ServiceSkillAutoProxy.Instance = nil

ServiceSkillAutoProxy.NAME = 'ServiceSkillAutoProxy'

function ServiceSkillAutoProxy:ctor(proxyName)
	if ServiceSkillAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSkillAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSkillAutoProxy.Instance = self
	end
end

function ServiceSkillAutoProxy:Init()
end

function ServiceSkillAutoProxy:onRegister()
	self:Listen(7, 1, function (data)
		self:RecvReqSkillData(data) 
	end)
	self:Listen(7, 2, function (data)
		self:RecvSkillUpdate(data) 
	end)
	self:Listen(7, 3, function (data)
		self:RecvLevelupSkill(data) 
	end)
	self:Listen(7, 4, function (data)
		self:RecvEquipSkill(data) 
	end)
	self:Listen(7, 5, function (data)
		self:RecvResetSkill(data) 
	end)
	self:Listen(7, 6, function (data)
		self:RecvSkillValidPos(data) 
	end)
	self:Listen(7, 7, function (data)
		self:RecvChangeSkillCmd(data) 
	end)
	self:Listen(7, 8, function (data)
		self:RecvUpSkillInfoSkillCmd(data) 
	end)
	self:Listen(7, 9, function (data)
		self:RecvSelectRuneSkillCmd(data) 
	end)
	self:Listen(7, 10, function (data)
		self:RecvMarkSkillNpcSkillCmd(data) 
	end)
	self:Listen(7, 11, function (data)
		self:RecvTriggerSkillNpcSkillCmd(data) 
	end)
	self:Listen(7, 12, function (data)
		self:RecvSkillOptionSkillCmd(data) 
	end)
	self:Listen(7, 13, function (data)
		self:RecvDynamicSkillCmd(data) 
	end)
	self:Listen(7, 14, function (data)
		self:RecvUpdateDynamicSkillCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSkillAutoProxy:CallReqSkillData(data) 
	local msg = SceneSkill_pb.ReqSkillData()
	if( data ~= nil )then
		for i=1,#data do 
			table.insert(msg.data, data[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallSkillUpdate(update, del) 
	local msg = SceneSkill_pb.SkillUpdate()
	if( update ~= nil )then
		for i=1,#update do 
			table.insert(msg.update, update[i])
		end
	end
	if( del ~= nil )then
		for i=1,#del do 
			table.insert(msg.del, del[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallLevelupSkill(type, skillids) 
	local msg = SceneSkill_pb.LevelupSkill()
	if(type ~= nil )then
		msg.type = type
	end
	if( skillids ~= nil )then
		for i=1,#skillids do 
			table.insert(msg.skillids, skillids[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallEquipSkill(skillid, pos, sourceid, efrom, eto, beingid) 
	local msg = SceneSkill_pb.EquipSkill()
	if(skillid ~= nil )then
		msg.skillid = skillid
	end
	if(pos ~= nil )then
		msg.pos = pos
	end
	if(sourceid ~= nil )then
		msg.sourceid = sourceid
	end
	if(efrom ~= nil )then
		msg.efrom = efrom
	end
	if(eto ~= nil )then
		msg.eto = eto
	end
	if(beingid ~= nil )then
		msg.beingid = beingid
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallResetSkill() 
	local msg = SceneSkill_pb.ResetSkill()
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallSkillValidPos(shortcuts) 
	local msg = SceneSkill_pb.SkillValidPos()
	if( shortcuts ~= nil )then
		for i=1,#shortcuts do 
			table.insert(msg.shortcuts, shortcuts[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallChangeSkillCmd(skillid, type, isadd, key) 
	local msg = SceneSkill_pb.ChangeSkillCmd()
	if(skillid ~= nil )then
		msg.skillid = skillid
	end
	if(type ~= nil )then
		msg.type = type
	end
	if(isadd ~= nil )then
		msg.isadd = isadd
	end
	if(key ~= nil )then
		msg.key = key
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallUpSkillInfoSkillCmd(specinfo) 
	local msg = SceneSkill_pb.UpSkillInfoSkillCmd()
	if( specinfo ~= nil )then
		for i=1,#specinfo do 
			table.insert(msg.specinfo, specinfo[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallSelectRuneSkillCmd(skillid, runespecid, selectswitch, beingid) 
	local msg = SceneSkill_pb.SelectRuneSkillCmd()
	msg.skillid = skillid
	if(runespecid ~= nil )then
		msg.runespecid = runespecid
	end
	if(selectswitch ~= nil )then
		msg.selectswitch = selectswitch
	end
	if(beingid ~= nil )then
		msg.beingid = beingid
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallMarkSkillNpcSkillCmd(npcguid, skillid) 
	local msg = SceneSkill_pb.MarkSkillNpcSkillCmd()
	msg.npcguid = npcguid
	msg.skillid = skillid
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallTriggerSkillNpcSkillCmd(npcguid, etype) 
	local msg = SceneSkill_pb.TriggerSkillNpcSkillCmd()
	msg.npcguid = npcguid
	if(etype ~= nil )then
		msg.etype = etype
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallSkillOptionSkillCmd(set_opt, all_opts) 
	local msg = SceneSkill_pb.SkillOptionSkillCmd()
	msg.set_opt.opt = set_opt.opt
	if(set_opt ~= nil )then
		if(set_opt.value ~= nil )then
			msg.set_opt.value = set_opt.value
		end
	end
	if( all_opts ~= nil )then
		for i=1,#all_opts do 
			table.insert(msg.all_opts, all_opts[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallDynamicSkillCmd(skills) 
	local msg = SceneSkill_pb.DynamicSkillCmd()
	if( skills ~= nil )then
		for i=1,#skills do 
			table.insert(msg.skills, skills[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSkillAutoProxy:CallUpdateDynamicSkillCmd(update, del) 
	local msg = SceneSkill_pb.UpdateDynamicSkillCmd()
	if( update ~= nil )then
		for i=1,#update do 
			table.insert(msg.update, update[i])
		end
	end
	if( del ~= nil )then
		for i=1,#del do 
			table.insert(msg.del, del[i])
		end
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSkillAutoProxy:RecvReqSkillData(data) 
	self:Notify(ServiceEvent.SkillReqSkillData, data)
end

function ServiceSkillAutoProxy:RecvSkillUpdate(data) 
	self:Notify(ServiceEvent.SkillSkillUpdate, data)
end

function ServiceSkillAutoProxy:RecvLevelupSkill(data) 
	self:Notify(ServiceEvent.SkillLevelupSkill, data)
end

function ServiceSkillAutoProxy:RecvEquipSkill(data) 
	self:Notify(ServiceEvent.SkillEquipSkill, data)
end

function ServiceSkillAutoProxy:RecvResetSkill(data) 
	self:Notify(ServiceEvent.SkillResetSkill, data)
end

function ServiceSkillAutoProxy:RecvSkillValidPos(data) 
	self:Notify(ServiceEvent.SkillSkillValidPos, data)
end

function ServiceSkillAutoProxy:RecvChangeSkillCmd(data) 
	self:Notify(ServiceEvent.SkillChangeSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvUpSkillInfoSkillCmd(data) 
	self:Notify(ServiceEvent.SkillUpSkillInfoSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSelectRuneSkillCmd(data) 
	self:Notify(ServiceEvent.SkillSelectRuneSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvMarkSkillNpcSkillCmd(data) 
	self:Notify(ServiceEvent.SkillMarkSkillNpcSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvTriggerSkillNpcSkillCmd(data) 
	self:Notify(ServiceEvent.SkillTriggerSkillNpcSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSkillOptionSkillCmd(data) 
	self:Notify(ServiceEvent.SkillSkillOptionSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvDynamicSkillCmd(data) 
	self:Notify(ServiceEvent.SkillDynamicSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvUpdateDynamicSkillCmd(data) 
	self:Notify(ServiceEvent.SkillUpdateDynamicSkillCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SkillReqSkillData = "ServiceEvent_SkillReqSkillData"
ServiceEvent.SkillSkillUpdate = "ServiceEvent_SkillSkillUpdate"
ServiceEvent.SkillLevelupSkill = "ServiceEvent_SkillLevelupSkill"
ServiceEvent.SkillEquipSkill = "ServiceEvent_SkillEquipSkill"
ServiceEvent.SkillResetSkill = "ServiceEvent_SkillResetSkill"
ServiceEvent.SkillSkillValidPos = "ServiceEvent_SkillSkillValidPos"
ServiceEvent.SkillChangeSkillCmd = "ServiceEvent_SkillChangeSkillCmd"
ServiceEvent.SkillUpSkillInfoSkillCmd = "ServiceEvent_SkillUpSkillInfoSkillCmd"
ServiceEvent.SkillSelectRuneSkillCmd = "ServiceEvent_SkillSelectRuneSkillCmd"
ServiceEvent.SkillMarkSkillNpcSkillCmd = "ServiceEvent_SkillMarkSkillNpcSkillCmd"
ServiceEvent.SkillTriggerSkillNpcSkillCmd = "ServiceEvent_SkillTriggerSkillNpcSkillCmd"
ServiceEvent.SkillSkillOptionSkillCmd = "ServiceEvent_SkillSkillOptionSkillCmd"
ServiceEvent.SkillDynamicSkillCmd = "ServiceEvent_SkillDynamicSkillCmd"
ServiceEvent.SkillUpdateDynamicSkillCmd = "ServiceEvent_SkillUpdateDynamicSkillCmd"
