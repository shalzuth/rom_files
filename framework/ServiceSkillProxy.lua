autoImport('ServiceSkillAutoProxy')
ServiceSkillProxy = class('ServiceSkillProxy', ServiceSkillAutoProxy)
ServiceSkillProxy.Instance = nil
ServiceSkillProxy.NAME = 'ServiceSkillProxy'

function ServiceSkillProxy:ctor(proxyName)
	if ServiceSkillProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSkillProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSkillProxy.Instance = self
	end
end

function ServiceSkillProxy:CallReqSkillData() 
	local msg = SceneSkill_pb.ReqSkillData()
	self:SendProto(msg)
end

function ServiceSkillProxy:RecvSkillValidPos(data)
	ShortCutProxy.Instance:UnLockSkillShortCuts(data)
	self:Notify(ServiceEvent.SkillSkillValidPos, data)
end

function ServiceSkillProxy:RecvChangeSkillCmd(data)
	local skillBuffs = MyselfProxy.Instance.myself.skillBuffs
	if(data.isadd ==0) then --移除
		skillBuffs:Remove(data.skillid,data.type,BuffConfig.changeskill,data.key)
		print("移除一层skill buff "..data.skillid)
	elseif(data.isadd==1) then --添加
		skillBuffs:Add(data.skillid,data.type,BuffConfig.changeskill,data.key)
		print("增加一层skill buff ")
	end
	-- local owner = skillBuffs:GetOwner(data.type)
	-- local skillparam = owner:GetParamsByType(BuffConfig.changeskill)[data.key]
	-- if(skillparam) then
	-- 	TabelUtil.Print(skillparam)
	-- else
	-- 	print("nil")
	-- end
	self:Notify(ServiceEvent.SkillChangeSkillCmd, data)
end

function ServiceSkillProxy:TakeOffSkill(skillid,sourceid,efrom,beingID)
	self:CallEquipSkill(skillid,0,sourceid,efrom,SceneSkill_pb.ESKILLSHORTCUT_MIN,beingID)
end

function ServiceSkillProxy:RecvUpSkillInfoSkillCmd(data) 
	SkillProxy.Instance:Server_UpdateDynamicSkillInfos(data)
	self:Notify(ServiceEvent.SkillUpSkillInfoSkillCmd, data)
end

function ServiceSkillProxy:RecvMarkSkillNpcSkillCmd(data) 
	local npc = NSceneNpcProxy.Instance:Find(data.npcguid)
	if(npc==nil) then
		npc = NScenePetProxy.Instance:Find(data.npcguid)
	end
	if(npc) then
		npc:SetSkillNpc(Table_Skill[data.skillid])
	end
	-- self:Notify(ServiceEvent.SkillMarkSkillNpcSkillCmd, data)
end

function ServiceSkillProxy:RecvTriggerSkillNpcSkillCmd(data) 
	if(data.etype == SceneSkill_pb.ETRIGTSKILL_BTRANS) then
		Game.AreaTrigger_Skill:SkillTransport_ResumeSyncMove(true)
	end
end

function ServiceSkillProxy:RecvSkillOptionSkillCmd(data)
	Game.SkillOptionManager:RecvServerOpts(data.all_opts)
	self:Notify(ServiceEvent.SkillSkillOptionSkillCmd, data)
end

function ServiceSkillProxy:RecvDynamicSkillCmd(data) 
	SkillProxy.Instance:UpdateTransformedSkills(data.skills)
	self:Notify(ServiceEvent.SkillDynamicSkillCmd, data)
end

function ServiceSkillProxy:RecvUpdateDynamicSkillCmd(data) 
	SkillProxy.Instance:UpdateTransformedSkills(data.update,data.del)
	self:Notify(ServiceEvent.SkillUpdateDynamicSkillCmd, data)
end