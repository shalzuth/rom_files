ServiceSkillAutoProxy = class("ServiceSkillAutoProxy", ServiceProxy)
ServiceSkillAutoProxy.Instance = nil
ServiceSkillAutoProxy.NAME = "ServiceSkillAutoProxy"
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
  self:Listen(7, 1, function(data)
    self:RecvReqSkillData(data)
  end)
  self:Listen(7, 2, function(data)
    self:RecvSkillUpdate(data)
  end)
  self:Listen(7, 3, function(data)
    self:RecvLevelupSkill(data)
  end)
  self:Listen(7, 4, function(data)
    self:RecvEquipSkill(data)
  end)
  self:Listen(7, 5, function(data)
    self:RecvResetSkill(data)
  end)
  self:Listen(7, 6, function(data)
    self:RecvSkillValidPos(data)
  end)
  self:Listen(7, 7, function(data)
    self:RecvChangeSkillCmd(data)
  end)
  self:Listen(7, 8, function(data)
    self:RecvUpSkillInfoSkillCmd(data)
  end)
  self:Listen(7, 9, function(data)
    self:RecvSelectRuneSkillCmd(data)
  end)
  self:Listen(7, 10, function(data)
    self:RecvMarkSkillNpcSkillCmd(data)
  end)
  self:Listen(7, 11, function(data)
    self:RecvTriggerSkillNpcSkillCmd(data)
  end)
  self:Listen(7, 12, function(data)
    self:RecvSkillOptionSkillCmd(data)
  end)
  self:Listen(7, 13, function(data)
    self:RecvDynamicSkillCmd(data)
  end)
  self:Listen(7, 14, function(data)
    self:RecvUpdateDynamicSkillCmd(data)
  end)
  self:Listen(7, 15, function(data)
    self:RecvSyncDestPosSkillCmd(data)
  end)
  self:Listen(7, 16, function(data)
    self:RecvResetTalentSkillCmd(data)
  end)
  self:Listen(7, 17, function(data)
    self:RecvMultiSkillOptionUpdateSkillCmd(data)
  end)
  self:Listen(7, 18, function(data)
    self:RecvMultiSkillOptionSyncSkillCmd(data)
  end)
end
function ServiceSkillAutoProxy:CallReqSkillData(data, talentdata)
  local msg = SceneSkill_pb.ReqSkillData()
  if data ~= nil then
    for i = 1, #data do
      table.insert(msg.data, data[i])
    end
  end
  if talentdata ~= nil then
    for i = 1, #talentdata do
      table.insert(msg.talentdata, talentdata[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallSkillUpdate(update, del, talent_update, talent_del)
  local msg = SceneSkill_pb.SkillUpdate()
  if update ~= nil then
    for i = 1, #update do
      table.insert(msg.update, update[i])
    end
  end
  if del ~= nil then
    for i = 1, #del do
      table.insert(msg.del, del[i])
    end
  end
  if talent_update ~= nil then
    for i = 1, #talent_update do
      table.insert(msg.talent_update, talent_update[i])
    end
  end
  if talent_del ~= nil then
    for i = 1, #talent_del do
      table.insert(msg.talent_del, talent_del[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallLevelupSkill(type, skillids)
  local msg = SceneSkill_pb.LevelupSkill()
  if type ~= nil then
    msg.type = type
  end
  if skillids ~= nil then
    for i = 1, #skillids do
      table.insert(msg.skillids, skillids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallEquipSkill(skillid, pos, sourceid, efrom, eto, beingid)
  local msg = SceneSkill_pb.EquipSkill()
  if skillid ~= nil then
    msg.skillid = skillid
  end
  if pos ~= nil then
    msg.pos = pos
  end
  if sourceid ~= nil then
    msg.sourceid = sourceid
  end
  if efrom ~= nil then
    msg.efrom = efrom
  end
  if eto ~= nil then
    msg.eto = eto
  end
  if beingid ~= nil then
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
  if shortcuts ~= nil then
    for i = 1, #shortcuts do
      table.insert(msg.shortcuts, shortcuts[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallChangeSkillCmd(skillid, type, isadd, key)
  local msg = SceneSkill_pb.ChangeSkillCmd()
  if skillid ~= nil then
    msg.skillid = skillid
  end
  if type ~= nil then
    msg.type = type
  end
  if isadd ~= nil then
    msg.isadd = isadd
  end
  if key ~= nil then
    msg.key = key
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallUpSkillInfoSkillCmd(specinfo, allskillInfo)
  local msg = SceneSkill_pb.UpSkillInfoSkillCmd()
  if specinfo ~= nil then
    for i = 1, #specinfo do
      table.insert(msg.specinfo, specinfo[i])
    end
  end
  msg.allskillInfo.id = allskillInfo.id
  if allskillInfo ~= nil and allskillInfo.attrs ~= nil then
    for i = 1, #allskillInfo.attrs do
      table.insert(msg.allskillInfo.attrs, allskillInfo.attrs[i])
    end
  end
  if allskillInfo ~= nil and allskillInfo.cost ~= nil then
    for i = 1, #allskillInfo.cost do
      table.insert(msg.allskillInfo.cost, allskillInfo.cost[i])
    end
  end
  if allskillInfo ~= nil and allskillInfo.changerange ~= nil then
    msg.allskillInfo.changerange = allskillInfo.changerange
  end
  if allskillInfo ~= nil and allskillInfo.changenum ~= nil then
    msg.allskillInfo.changenum = allskillInfo.changenum
  end
  if allskillInfo ~= nil and allskillInfo.changeready ~= nil then
    msg.allskillInfo.changeready = allskillInfo.changeready
  end
  if allskillInfo ~= nil and allskillInfo.neednoitem ~= nil then
    msg.allskillInfo.neednoitem = allskillInfo.neednoitem
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallSelectRuneSkillCmd(skillid, runespecid, selectswitch, beingid)
  local msg = SceneSkill_pb.SelectRuneSkillCmd()
  msg.skillid = skillid
  if runespecid ~= nil then
    msg.runespecid = runespecid
  end
  if selectswitch ~= nil then
    msg.selectswitch = selectswitch
  end
  if beingid ~= nil then
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
  if etype ~= nil then
    msg.etype = etype
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallSkillOptionSkillCmd(set_opt, all_opts)
  local msg = SceneSkill_pb.SkillOptionSkillCmd()
  msg.set_opt.opt = set_opt.opt
  if set_opt ~= nil and set_opt.value ~= nil then
    msg.set_opt.value = set_opt.value
  end
  if all_opts ~= nil then
    for i = 1, #all_opts do
      table.insert(msg.all_opts, all_opts[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallDynamicSkillCmd(skills)
  local msg = SceneSkill_pb.DynamicSkillCmd()
  if skills ~= nil then
    for i = 1, #skills do
      table.insert(msg.skills, skills[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallUpdateDynamicSkillCmd(update, del)
  local msg = SceneSkill_pb.UpdateDynamicSkillCmd()
  if update ~= nil then
    for i = 1, #update do
      table.insert(msg.update, update[i])
    end
  end
  if del ~= nil then
    for i = 1, #del do
      table.insert(msg.del, del[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallSyncDestPosSkillCmd(skillid, pos)
  local msg = SceneSkill_pb.SyncDestPosSkillCmd()
  if skillid ~= nil then
    msg.skillid = skillid
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallResetTalentSkillCmd()
  local msg = SceneSkill_pb.ResetTalentSkillCmd()
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallMultiSkillOptionUpdateSkillCmd(opt)
  local msg = SceneSkill_pb.MultiSkillOptionUpdateSkillCmd()
  if opt ~= nil and opt.opt ~= nil then
    msg.opt.opt = opt.opt
  end
  if opt ~= nil and opt.value ~= nil then
    msg.opt.value = opt.value
  end
  if opt ~= nil and opt.values ~= nil then
    for i = 1, #opt.values do
      table.insert(msg.opt.values, opt.values[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSkillAutoProxy:CallMultiSkillOptionSyncSkillCmd(opts)
  local msg = SceneSkill_pb.MultiSkillOptionSyncSkillCmd()
  if opts ~= nil then
    for i = 1, #opts do
      table.insert(msg.opts, opts[i])
    end
  end
  self:SendProto(msg)
end
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
function ServiceSkillAutoProxy:RecvSyncDestPosSkillCmd(data)
  self:Notify(ServiceEvent.SkillSyncDestPosSkillCmd, data)
end
function ServiceSkillAutoProxy:RecvResetTalentSkillCmd(data)
  self:Notify(ServiceEvent.SkillResetTalentSkillCmd, data)
end
function ServiceSkillAutoProxy:RecvMultiSkillOptionUpdateSkillCmd(data)
  self:Notify(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, data)
end
function ServiceSkillAutoProxy:RecvMultiSkillOptionSyncSkillCmd(data)
  self:Notify(ServiceEvent.SkillMultiSkillOptionSyncSkillCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
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
ServiceEvent.SkillSyncDestPosSkillCmd = "ServiceEvent_SkillSyncDestPosSkillCmd"
ServiceEvent.SkillResetTalentSkillCmd = "ServiceEvent_SkillResetTalentSkillCmd"
ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd = "ServiceEvent_SkillMultiSkillOptionUpdateSkillCmd"
ServiceEvent.SkillMultiSkillOptionSyncSkillCmd = "ServiceEvent_SkillMultiSkillOptionSyncSkillCmd"
