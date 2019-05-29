local BaseCell = autoImport("BaseCell")
GuildActivityCell = class("GuildActivityCell", BaseCell)
GuildActivityCellEvent = {
  TraceRoad = "GuildActivityCellEvent_TraceRoad",
  ClickHelp = "GuildActivityCellEvent_ClickHelp"
}
local GUILD_CHALLENGE_REWARD = SceneTip_pb.EREDSYS_GUILD_CHALLENGE_REWARD or 42
local tempArgs = {}
function GuildActivityCell:Init()
  self.name = self:FindComponent("Name", UILabel)
  self.desc = self:FindComponent("Tip", UILabel)
  self.headIcon = self:FindComponent("HeadIcon", UISprite)
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("Label", UILabel, self.multiplySymbol.gameObject)
  self.transButton = self:FindGO("TransButton")
  self.transButton_label = self:FindComponent("Label", UILabel, self.transButton)
  self:AddClickEvent(self.transButton, function(go)
    self:DoTrace()
  end)
  self.helpButton = self:FindGO("DescButton")
  self:AddClickEvent(self.helpButton, function(go)
    self:PassEvent(GuildActivityCellEvent.ClickHelp, self.data)
  end)
end
function GuildActivityCell:DoTrace()
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
  elseif self.data then
    if self.data.PanelId then
      self:sendNotification(UIEvent.JumpPanel, {
        view = self.data.PanelId
      })
    else
      local currentRaidID = SceneProxy.Instance:GetCurRaidID()
      local raidData = currentRaidID and Table_MapRaid[currentRaidID]
      if raidData and raidData.Type == 10 then
        TableUtility.TableClear(tempArgs)
        tempArgs.npcUID = self.data.UniqueID
        local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc)
        if cmd then
          Game.Myself:Client_SetMissionCommand(cmd)
        end
        self:PassEvent(GuildActivityCellEvent.TraceRoad)
      else
        ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
      end
    end
  end
end
function GuildActivityCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.name.text = data.Name
    self.desc.text = data.Content
    IconManager:SetUIIcon(data.Icon, self.headIcon)
    self.headIcon:MakePixelPerfect()
    if data.PanelId then
      self.transButton_label.text = ZhString.GuildActivityCell_Show
    elseif data.UniqueID then
      self.transButton_label.text = ZhString.GuildActivityCell_Go
    end
    if data.id == 7 then
      local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.GuildDonate)
      local discount = rewardInfo and rewardInfo:GetMultiple() or 1
      if discount <= 1 then
        self.multiplySymbol:SetActive(false)
      else
        self.multiplySymbol:SetActive(true)
        self.multiplySymbol_label.text = "*" .. math.floor(discount)
      end
    else
      self.multiplySymbol:SetActive(false)
    end
    self.helpButton:SetActive(data.HelpID ~= nil)
    self:RegistRedTip()
  else
    self.gameObject:SetActive(false)
  end
end
function GuildActivityCell:RegistRedTip()
  self:UnRegisteRedTip()
  if self.data == nil then
    return
  end
  if self.data.PanelId and self.data.PanelId == PanelConfig.GuildChallengeTaskPopUp.id then
    self.red_registe = true
    RedTipProxy.Instance:RegisterUI(GUILD_CHALLENGE_REWARD, self.transButton, 10, {-7, -7})
  end
end
function GuildActivityCell:UnRegisteRedTip()
  if self.red_registe then
    RedTipProxy.Instance:UnRegisterUI(GUILD_CHALLENGE_REWARD, self.transButton)
  end
  self.red_registe = false
end
function GuildActivityCell:OnRemove()
  self:UnRegisteRedTip()
end
