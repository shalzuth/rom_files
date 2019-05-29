autoImport("BaseTip")
SkipAnimationTip = class("SkipAnimationTip", BaseTip)
SKIPTYPE = {
  CardRandomMake = "CardRandomMake",
  CardMake = "CardMake",
  FoodMake = "FoodMake",
  LotteryHeadwear = "LotteryHeadwear",
  LotteryEquip = "LotteryEquip",
  LotteryCard = "LotteryCard",
  LotteryMagic = "LotteryMagic",
  VendingMachine = "VendingMachine",
  WelfareLotteryMachine = "WelfareLotteryMachine",
  BarCatBoss = "BarCatBoss",
  LotteryCatLitter = "LotteryCatLitter",
  CardDecompose = "CardDecompose",
  LotteryMagicSec = "LotteryMagicSec"
}
function SkipAnimationTip:OnEnter()
  SkipAnimationTip.super.OnEnter(self)
  self.gameObject:SetActive(true)
end
function SkipAnimationTip:Init()
  self:FindObjs()
  self:AddEvts()
end
function SkipAnimationTip:FindObjs()
  self.skipToggle = self:FindGO("SkipToggle"):GetComponent("UIToggle")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
end
function SkipAnimationTip:AddEvts()
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  EventDelegate.Add(self.skipToggle.onChange, function()
    self:SaveData()
  end)
end
function SkipAnimationTip:SetData(data)
  SkipAnimationTip.super.SetData(self, data)
  if data then
    self.skipType = data
    self.skipToggle.value = not LocalSaveProxy.Instance:GetSkipAnimation(self.skipType)
  end
end
function SkipAnimationTip:SaveData()
  if self.skipType then
    local value = self.skipToggle.value
    LocalSaveProxy.Instance:SetSkipAnimation(self.skipType, not value)
  end
end
function SkipAnimationTip:CloseSelf()
  TipsView.Me():HideCurrent()
end
