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
	
	--todo xde
	local bg = self:FindGO("Bg"):GetComponent(UISprite)
	local skipSet = self:FindGO('SkipSet'):GetComponent(UILabel)
	skipSet.pivot = UIWidget.Pivot.Right
	OverseaHostHelper:FixLabelOverV1(skipSet, 2, 100)
	OverseaHostHelper:FixAnchor(bg.leftAnchor,skipSet.transform,0,-40)
	
end

function SkipAnimationTip:AddEvts()
	self.closecomp.callBack = function (go)
		self:CloseSelf()
	end
	EventDelegate.Add(self.skipToggle.onChange, function ()
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
end