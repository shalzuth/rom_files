autoImport("FriendBaseCell")
local baseCell = autoImport("BaseCell")
FriendInfoCell = class("FriendInfoCell", FriendBaseCell)
local BlueColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
function FriendInfoCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:InitShow()
  OverseaHostHelper:FixLabelOverV1(self.GuildName, 3, 170)
end
function FriendInfoCell:FindObjs()
  FriendInfoCell.super.FindObjs(self)
  self.GuildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildIconGO = self.GuildIcon.gameObject
  self.GuildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.recallBtn = self:FindGO("RecallBtn"):GetComponent(UISprite)
  self.recallBtnGO = self.recallBtn.gameObject
end
function FriendInfoCell:AddButtonEvt()
  self:AddClickEvent(self.recallBtnGO, function()
    self:Recall()
  end)
end
function FriendInfoCell:SetData(data)
  FriendInfoCell.super.SetData(self, data)
  if data then
    if data.guildname ~= "" then
      self.guildIconGO:SetActive(true)
      self.GuildName.text = data.guildname
      self.GuildName.color = BlueColor
      local guildportrait = tonumber(data.guildportrait) or 1
      guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
      IconManager:SetGuildIcon(guildportrait, self.GuildIcon)
    else
      self.guildIconGO:SetActive(false)
      self.GuildName.text = ZhString.Friend_EmptyGuild
      ColorUtil.GrayUIWidget(self.GuildName)
    end
    local canRecall = data:CheckCanRecall()
    self.recallBtnGO:SetActive(canRecall)
    if canRecall then
      self:SetRecall(data.recall)
    end
  end
end
function FriendInfoCell:SetRecall(bRecall)
  if bRecall then
    ColorUtil.DeepGrayUIWidget(self.recallBtn)
  else
    ColorUtil.WhiteUIWidget(self.recallBtn)
  end
end
function FriendInfoCell:Recall()
  if self.data ~= nil then
    if self.data.recall then
      MsgManager.ShowMsgByID(3620)
      return
    end
    if #FriendProxy.Instance:GetContractData() > GameConfig.Recall.max_recall_count then
      MsgManager.ConfirmMsgByID(3621, function()
        self:JumpShareView()
      end)
    else
      self:JumpShareView()
    end
  end
end
function FriendInfoCell:JumpShareView()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RecallShareView,
    viewdata = self.data
  })
end
