autoImport("ColliderItemCell")
local BaseCell = autoImport("BaseCell")
AdventureZoneRewardCell = class("AdventureZoneRewardCell", BaseCell)
local ColorBtnAwardLabelEnable = LuaColor(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1)
function AdventureZoneRewardCell:Init()
  self:FindObjs()
  self:AddEvents()
end
function AdventureZoneRewardCell:FindObjs()
  self.sprAwardType = self:FindComponent("sprAwardType", UISprite)
  self.listRewards = UIGridListCtrl.new(self:FindComponent("gridRewards", UIGrid), ColliderItemCell, "AdventureZoneItemCell")
  self.objBtnGetReward = self:FindGO("BtnGetReward")
  self.sprBtnGetReward = self:FindComponent("Background", UISprite, self.objBtnGetReward)
  self.labBtnGetReward = self:FindComponent("Label", UILabel, self.objBtnGetReward)
  self.colBtnGetReward = self.objBtnGetReward:GetComponent(Collider)
end
function AdventureZoneRewardCell:AddEvents(data)
  self:AddClickEvent(self.objBtnGetReward, function()
    self:ClickBtnGetReward()
  end)
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickRewardItem, self)
end
function AdventureZoneRewardCell:SetData(data)
  self:ClearLt()
  self.data = data
  self.rewardType = data.rewardType
  self.listRewards:ResetDatas(data.rewards)
  self.sprAwardType.spriteName = "Adventure_icon_" .. (self.rewardType == AdventureZoneRewardPopUp.ERewardType.Good and "good" or "perfect")
  self.colBtnGetReward.enabled = data.canGetReward
  self.labBtnGetReward.text = data.rewardGot and ZhString.AdventureZoneRewardPopUp_HasGetAward or ZhString.AdventureZoneRewardPopUp_GetAward
  if data.canGetReward then
    self:SetTextureWhite(self.sprBtnGetReward)
    self.labBtnGetReward.effectColor = ColorBtnAwardLabelEnable
  else
    self:SetTextureGrey(self.sprBtnGetReward)
    self.labBtnGetReward.effectColor = LuaColor.gray
  end
end
function AdventureZoneRewardCell:ClickRewardItem(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end
function AdventureZoneRewardCell:ClickBtnGetReward()
  if self.disableClick then
    return
  end
  ServiceSceneManualProxy.Instance:CallNpcZoneRewardManualCmd(self.data.id, self.rewardType)
  self.disableClick = true
  self.ltDisableClick = LeanTween.delayedCall(2, function()
    self.disableClick = false
    self.ltDisableClick = nil
  end)
end
function AdventureZoneRewardCell:ClearLt()
  if self.ltDisableClick then
    self.disableClick = false
    self.ltDisableClick:cancel()
    self.ltDisableClick = nil
  end
end
