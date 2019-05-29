autoImport("SocialBaseCell")
local baseCell = autoImport("BaseCell")
RecallFriendCell = class("RecallFriendCell", SocialBaseCell)
function RecallFriendCell:FindObjs()
  RecallFriendCell.super.FindObjs(self)
  self.offlinetime = self:FindGO("Offlinetime"):GetComponent(UILabel)
  self.offlineTip = self:FindGO("OfflineTip"):GetComponent(UILabel)
  self.recallBtn = self:FindGO("RecallBtn"):GetComponent(UISprite)
  self.recallBtnLabel = self:FindGO("Label", self.recallBtn.gameObject):GetComponent(UILabel)
end
function RecallFriendCell:InitShow()
  RecallFriendCell.super.InitShow(self)
  self:AddClickEvent(self.recallBtn.gameObject, function()
    self:Recall()
  end)
  self.offlinetime.gameObject:SetActive(false)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 60000, self.RefreshOfflinetime, self)
end
function RecallFriendCell:SetData(data)
  data = FriendProxy.Instance:GetFriendById(data)
  RecallFriendCell.super.SetData(self, data)
  if data then
    if data.offlinetime == 0 then
      self.offlinetime.gameObject:SetActive(false)
      self.headIcon:SetActive(true, true)
      self.offlineTip.text = data.zoneid and MyselfProxy.Instance:GetZoneId() ~= data.zoneid and "" or ZhString.Friend_MapOnline
    else
      self.offlinetime.gameObject:SetActive(true)
      self.headIcon:SetActive(false, true)
      self.offlineTip.text = ZhString.Friend_MapOffline
    end
    self:RefreshOfflinetime()
    if data.waitRecall then
      ColorUtil.ShaderGrayUIWidget(self.recallBtn)
      self.recallBtnLabel.text = ZhString.Friend_RecalledLabel
      self.recallBtnLabel.effectStyle = UILabel.Effect.None
    else
      ColorUtil.WhiteUIWidget(self.recallBtn)
      self.recallBtnLabel.text = ZhString.Friend_RecallLabel
      self.recallBtnLabel.effectStyle = UILabel.Effect.Outline
    end
  end
end
function RecallFriendCell:RefreshOfflinetime()
  if self.data and self.data.offlinetime ~= 0 then
    self.offlinetime.text = ClientTimeUtil.GetFormatOfflineTimeStr(self.data.offlinetime)
  end
end
function RecallFriendCell:OnRemove()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self)
  end
end
function RecallFriendCell:Recall()
  if self.data ~= nil then
    if self.data.waitRecall then
      return
    end
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
function RecallFriendCell:JumpShareView()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RecallShareView,
    viewdata = self.data
  })
end
