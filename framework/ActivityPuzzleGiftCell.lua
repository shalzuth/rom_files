local BaseCell = autoImport("BaseCell")
ActivityPuzzleGiftCell = class("ActivityPuzzleGiftCell", BaseCell)
function ActivityPuzzleGiftCell:Init()
  ActivityPuzzleGiftCell.super.Init(self)
  self:FindObjs()
end
function ActivityPuzzleGiftCell:FindObjs()
  self.giftPoint = self:FindComponent("GiftPoint", UILabel)
  self.giftParent = self:FindGO("GiftParent")
  self.giftButton = self:FindGO("GiftButton")
  self.giftButtonSprite = self:FindComponent("GiftButtonSprite", UISprite)
  self.lightsp = self:FindComponent("LightSprite", UISprite)
  self.stick = self:FindComponent("Stick", UIWidget)
  self.giftShakeTween = self:FindComponent("GiftButton", TweenRotation)
  self:AddButtonEvent("GiftButton", function(obj)
    if self.giftShakeTween.enabled then
      ServicePuzzleCmdProxy.Instance:CallActivePuzzleCmd(self.data.ActivityID, self.data.PuzzleID)
    else
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end
function ActivityPuzzleGiftCell:SetData(data)
  self.data = data
  self.giftPoint.text = data.UnlockTime
end
function ActivityPuzzleGiftCell:UpdateGiftState(currentProgress, unitWidth)
  self.giftParent.transform.localPosition = LuaVector3(self.data.UnlockTime * unitWidth, 3.2, 0)
  local itemData = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(self.data.ActivityID, self.data.PuzzleID)
  if itemData then
    if itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE then
      IconManager:SetUIIcon("icon_2", self.giftButtonSprite)
      IconManager:SetUIIcon("icon_light", self.lightsp)
      self.lightsp.gameObject:SetActive(false)
      self.giftShakeTween.enabled = false
    elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
      IconManager:SetUIIcon("icon_1", self.giftButtonSprite)
      self.lightsp.gameObject:SetActive(true)
      self.giftShakeTween.enabled = true
    elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_UNACTIVE then
      IconManager:SetUIIcon("icon_3", self.giftButtonSprite)
      self.lightsp.gameObject:SetActive(false)
      self.giftShakeTween.enabled = false
    end
  else
    IconManager:SetUIIcon("icon_3", self.giftButtonSprite)
    self.giftShakeTween.enabled = false
  end
  self.giftButtonSprite.gameObject.transform.localScale = Vector3.one * 0.7
end
