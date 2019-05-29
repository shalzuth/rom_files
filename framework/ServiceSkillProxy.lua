autoImport("ServiceSkillAutoProxy")
ServiceSkillProxy = class("ServiceSkillProxy", ServiceSkillAutoProxy)
ServiceSkillProxy.Instance = nil
ServiceSkillProxy.NAME = "ServiceSkillProxy"
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
function ServiceSkillProxy:CallSyncDestPosSkillCmd(skillid, pos)
  local tempPos = LuaVector3()
  ProtolUtility.C2S_Vector3(pos, tempPos)
  ServiceSkillProxy.super.CallSyncDestPosSkillCmd(self, skillid, tempPos)
  tempPos:Destroy()
end
function ServiceSkillProxy:RecvSkillValidPos(data)
  ShortCutProxy.Instance:UnLockSkillShortCuts(data)
  self:Notify(ServiceEvent.SkillSkillValidPos, data)
end
function ServiceSkillProxy:RecvChangeSkillCmd(data)
  local skillBuffs = MyselfProxy.Instance.myself.skillBuffs
  if data.isadd == 0 then
    skillBuffs:Remove(data.skillid, data.type, BuffConfig.changeskill, data.key)
  elseif data.isadd == 1 then
    skillBuffs:Add(data.skillid, data.type, BuffConfig.changeskill, data.key)
  end
  self:Notify(ServiceEvent.SkillChangeSkillCmd, data)
end
function ServiceSkillProxy:TakeOffSkill(skillid, sourceid, efrom, beingID)
  self:CallEquipSkill(skillid, 0, sourceid, efrom, SceneSkill_pb.ESKILLSHORTCUT_MIN, beingID)
end
function ServiceSkillProxy:RecvUpSkillInfoSkillCmd(data)
  SkillProxy.Instance:Server_UpdateDynamicSkillInfos(data)
  self:Notify(ServiceEvent.SkillUpSkillInfoSkillCmd, data)
end
function ServiceSkillProxy:RecvMarkSkillNpcSkillCmd(data)
  local npc = NSceneNpcProxy.Instance:Find(data.npcguid)
  if npc == nil then
    npc = NScenePetProxy.Instance:Find(data.npcguid)
  end
  if npc then
    npc:SetSkillNpc(Table_Skill[data.skillid])
  end
end
function ServiceSkillProxy:RecvTriggerSkillNpcSkillCmd(data)
  if data.etype == SceneSkill_pb.ETRIGTSKILL_BTRANS then
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
  SkillProxy.Instance:UpdateTransformedSkills(data.update, data.del)
  self:Notify(ServiceEvent.SkillUpdateDynamicSkillCmd, data)
end
function ServiceSkillProxy:RecvMultiSkillOptionSyncSkillCmd(data)
  Game.SkillOptionManager:RecvMultiSkillOptionSyncSkillCmd(data)
  EventManager.Me():PassEvent(ServiceEvent.SkillMultiSkillOptionSyncSkillCmd, data)
end
function ServiceSkillProxy:CallMultiSkillOptionUpdateSkillCmd(opt, value, values)
  local data = ReusableTable.CreateTable()
  data.opt = opt
  data.value = value
  data.values = values
  ServiceSkillProxy.super.CallMultiSkillOptionUpdateSkillCmd(self, data)
  ReusableTable.DestroyAndClearTable(data)
end
function ServiceSkillProxy:RecvMultiSkillOptionUpdateSkillCmd(data)
  Game.SkillOptionManager:RecvMultiSkillOptionUpdateSkillCmd(data)
  EventManager.Me():PassEvent(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, data)
end
