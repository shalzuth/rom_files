PlayerBottomView = class("PlayerBottomView", SubView)
autoImport("GuildPictureManager")
function PlayerBottomView:Init()
  self:initData()
  self:AddViewEvents()
end
function PlayerBottomView:initData()
  self.selectedRoleId = nil
end
function PlayerBottomView:AddViewEvents()
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.HandlerSelectTargetChange)
  self:AddListenEvt(ServiceEvent.UserEventDamageNpcUserEvent, self.HandlerHit)
  self:AddListenEvt(MyselfEvent.BeHited, self.HandlerBeHit)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildInfoNtf, self.HandlerPlayerFactionChange)
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.HandlerMemberDataChange)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.HandlerMemberDataChange)
  self:AddListenEvt(SetEvent.ShowOtherName, self.HandleSettingMask)
  self:AddListenEvt(SceneUIEvent.SceneUIEnable, self.HandleSceneUIEnable)
  self:AddListenEvt(SceneUIEvent.SceneUIDisable, self.HandleSceneUIDisable)
  self:AddListenEvt(SceneUIEvent.RemoveMonsterNamePre, self.RemoveMonsterNamePre)
  self:AddListenEvt(SceneUIEvent.AddMonsterNamePre, self.AddMonsterNamePre)
  self:AddListenEvt(CreatureEvent.Name_Change, self.HandlerName_Change)
  self:AddListenEvt(GuildPictureManager.ThumbnailDownloadCompleteCallback, self.HandleGuildIconDownloadComplete)
end
function PlayerBottomView:AddMonsterNamePre(note)
  local questData = note.body
  local groupID = questData.params.groupId
  local npcID = questData.params.monster
  local npcUID = questData.params.uniqueid
  local targets
  if npcID then
    targets = NSceneNpcProxy.Instance:FindNpcs(npcID)
  end
  if not targets and groupID then
    targets = NSceneNpcProxy.Instance:FindNpcsByGroupID(groupID)
  end
  if not targets and npcUID then
    targets = NSceneNpcProxy.Instance:FindNpcByUniqueId(npcUID)
  end
  if not targets then
    return
  end
  for i = 1, #targets do
    local creature = targets[i]
    local sceneUI = creature:GetSceneUI()
    if sceneUI and sceneUI.roleBottomUI then
      sceneUI.roleBottomUI:SetQuestPrefixVisible(creature, true)
    end
  end
end
function PlayerBottomView:RemoveMonsterNamePre(note)
  local questData = note.body
  local groupID = questData.params.groupId
  local npcID = questData.params.monster
  local npcUID = questData.params.uniqueid
  local targets
  if npcID then
    targets = NSceneNpcProxy.Instance:FindNpcs(npcID)
  end
  if not targets and groupID then
    targets = NSceneNpcProxy.Instance:FindNpcsByGroupID(groupID)
  end
  if not targets and npcUID then
    targets = NSceneNpcProxy.Instance:FindNpcByUniqueId(npcUID)
  end
  if not targets then
    return
  end
  for i = 1, #targets do
    local creature = targets[i]
    local sceneUI = creature:GetSceneUI()
    if sceneUI and sceneUI.roleBottomUI then
      sceneUI.roleBottomUI:SetQuestPrefixVisible(creature, false)
    end
  end
end
function PlayerBottomView:HandlerSelectTargetChange(note)
  local creature = note.body
  if not creature or not creature.data.id then
    local id
  end
  if self.selectedRoleId ~= nil and self.selectedRoleId ~= id then
    local creature = self:getCreature(self.selectedRoleId)
    if not creature or not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      sceneUI.roleBottomUI:SetIsSelected(false, creature)
    end
    self.selectedRoleId = nil
  end
  local creature = self:getCreature(id)
  if not creature or not creature:GetSceneUI() then
    local sceneUI
  end
  if sceneUI then
    sceneUI.roleBottomUI:SetIsSelected(true, creature)
    self.selectedRoleId = id
  end
end
function PlayerBottomView:HandlerPlayerFactionChange(note)
  local data = note.body
  if data then
    local id = data.charid
    local creature = self:getCreature(id)
    if not creature or not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      sceneUI.roleBottomUI:HandlerPlayerFactionChange(creature)
    end
  end
end
function PlayerBottomView:HandlerName_Change(note)
  local creature = note.body
  if creature then
    if not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      sceneUI.roleBottomUI:HandleChangeTitle(creature)
    end
  end
end
function PlayerBottomView:HandleSettingMask()
  SceneCreatureProxy.ForEachCreature(self.HandleSettingMaskCreature)
end
function PlayerBottomView.HandleSettingMaskCreature(creature)
  if creature then
    creature:HandleSettingMask()
  end
end
function PlayerBottomView:HandlerMemberDataChange(note)
  local data = note.body
  if data then
    if not data or not data.id then
      local id
    end
    local creature = self:getCreature(id)
    if not creature or not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      sceneUI.roleBottomUI:HandlerMemberDataChange(creature)
    end
  end
end
function PlayerBottomView:HandlerBeHit(note)
  if LowBloodBlinkView.Instance then
    LowBloodBlinkView.ShowLowBloodBlinkWhenHit()
  end
end
function PlayerBottomView:HandlerHit(note)
  local data = note.body
  local id = data.npcguid
  local userid = data.userid
  local creature = self:getCreature(id)
  if not creature or not creature:GetSceneUI() then
    local sceneUI
  end
  if sceneUI then
    sceneUI.roleBottomUI:SetIsBeHit(true, creature)
  end
end
function PlayerBottomView:getCreature(guid)
  if not guid then
    return
  end
  return SceneCreatureProxy.FindCreature(guid)
end
function PlayerBottomView:HandleSceneUIEnable()
  local uiCm = NGUIUtil:GetCameraByLayername("SceneUI")
  uiCm.enabled = true
end
function PlayerBottomView:HandleSceneUIDisable()
  local uiCm = NGUIUtil:GetCameraByLayername("SceneUI")
  uiCm.enabled = false
end
local tempArray = {}
function PlayerBottomView:HandleGuildIconDownloadComplete(note)
  local data = note.body
  local guild = data.guild
  local index = data.index
  local time = data.time
  NSceneUserProxy.Instance:FindCreateByGuild(guild, tempArray)
  GuildPictureManager.Instance():log("PlayerBottomView HandleGuildIconDownloadComplete", guild, index, time)
  if tempArray and #tempArray > 0 then
    for i = 1, #tempArray do
      local creature = tempArray[i]
      if not creature or not creature:GetSceneUI() then
        local sceneUI
      end
      if sceneUI then
        sceneUI.roleBottomUI:HandlerPlayerFactionChange(creature)
      end
    end
  end
  TableUtility.ArrayClear(tempArray)
end
