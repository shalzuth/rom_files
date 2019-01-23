local AniName = {
		Enter = "appear",
		Combo = "combo",
		-- Exit = "disappear",
	}

UICombo = class("UICombo", CoreView)

function UICombo:ctor(go)
	UICombo.super.ctor(self, go);
	self:Init();
	self:FindObjs();
end

function UICombo:Init()
	self:FindObjs()
end

function UICombo:FindObjs()
	self.normalWidget = self:FindGO("Normal")
	self.enhanceWidget = self:FindGO("Enhance")
	self.normalNum = self:FindComponent("NormalNum",UILabel);
	self.enhanceNum = self:FindComponent("EnhanceNum",UILabel);
	self.animator=self.gameObject:GetComponent(Animator);
end

function UICombo:PlayAni(num)
	if(num==0)then
		ComboCtl.Instance:Clear()
	elseif(num==1)then
		self.animator:Play (AniName.Enter, -1, 0)
		self:SetComboNum(num)
	elseif(num>1)then
		self.animator:Play (AniName.Combo, -1, 0)
		self:SetComboNum(num)
	end
end

function UICombo:SetComboNum(num)
	if(num>2)then
		self:Show(self.enhanceWidget)
		self:Hide(self.normalWidget)
		self.enhanceNum.text=num
	else
		self:Hide(self.enhanceWidget)
		self:Show(self.normalWidget)
		self.normalNum.text=num
	end
end

function UICombo:OnExit()
	ComboCtl.Instance:Clear()
end






