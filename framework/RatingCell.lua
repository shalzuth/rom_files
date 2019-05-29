autoImport("BaseCell")
autoImport("ColliderItemCell")
RatingCell = class("RatingCell", BaseCell)
local RewardStatus = {
  None = SceneUser2_pb.EREWEARD_STATUS_MIN,
  CanGet = SceneUser2_pb.EREWEARD_STATUS_CAN_GET,
  Get = SceneUser2_pb.EREWEARD_STATUS_GET
}
function RatingCell:Init()
  self.medal = self:FindGO("medal"):GetComponent(UIMultiSprite)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.rewardItem = self:FindGO("rewardItem"):GetComponent(UIButton)
  self.receiveLabel = self:FindGO("receiveLabel"):GetComponent(UILabel)
  self.time = self:FindGO("completeTime"):GetComponent(UILabel)
  self.rewardsp = self:FindGO("buttonsp"):GetComponent(UISprite)
  self:AddEvent()
end
function RatingCell:AddEvent()
  self:AddButtonEvent("rewardItem", function(obj)
    if self.status and self.status == RewardStatus.CanGet then
      ServiceNUserProxy.Instance:CallAltmanRewardUserCmd(nil, nil, self.rewardid)
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RatingRewardPreview,
      viewdata = self.id
    })
  end)
end
function RatingCell:SetData(data)
  if data then
    self.id = data.id
    self.medal.CurrentState = data.id - 1
    self.rewardid = data.reward
    self.status = DungeonProxy.Instance:GetRewardStatus(self.rewardid)
    self.title.text = data.title
    self.time.text = string.format(ZhString.EVA_CompleteTime, data.time)
    IconManager:SetItemIcon(data.rewardicon, self.rewardsp)
    if not self.status then
      self.rewardItem.enabled = true
      self.rewardItem.gameObject:SetActive(true)
      self.receiveLabel.gameObject:SetActive(false)
      self.rewardsp.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    elseif self.status == RewardStatus.Get then
      self.rewardItem.gameObject:SetActive(false)
      self.receiveLabel.text = ZhString.EVA_ReceivedReward
      self.receiveLabel.gameObject:SetActive(true)
      self.rewardsp.color = Color(1, 1, 1)
    elseif self.status == RewardStatus.CanGet then
      self.rewardItem.enabled = true
      self.rewardItem.gameObject:SetActive(true)
      self.receiveLabel.gameObject:SetActive(false)
      self.rewardsp.color = Color(1, 1, 1)
    elseif self.status == RewardStatus.None then
      self.rewardItem.enabled = true
      self.rewardItem.gameObject:SetActive(true)
      self.receiveLabel.gameObject:SetActive(false)
      self.rewardsp.color = Color(1, 1, 1)
    end
  end
end
function RatingCell:ClickItem(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    callback = callback,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipstick, NGUIUtil.AnchorSide.Left, {-212, 0})
end
