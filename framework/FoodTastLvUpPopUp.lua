FoodTastLvUpPopUp = class("FoodTastLvUpPopUp", BaseView);

FoodTastLvUpPopUp.ViewType = UIViewType.PopUpLayer

autoImport("HeadIconCell");

function FoodTastLvUpPopUp:Init()
	self:InitView();
end

function FoodTastLvUpPopUp:InitView()
	self.titleText = self:FindComponent("TitleText", UILabel);
	self.confirmButton = self:FindGO("ConfirmButton");
	self.desc1 = self:FindComponent("Desc1", UILabel);
	self.desc2 = self:FindComponent("Desc2", UILabel);

	self.headIconCell = HeadIconCell.new(self.headHolder);

	local headHolder = self:FindGO("HeadHolder");
	self.headIconCell = HeadIconCell.new();
	self.headIconCell:CreateSelf(headHolder);
	self.headIconCell:SetMinDepth(3);
	self.headIconCell:HideFrame();
end

function FoodTastLvUpPopUp:UpdateInfo()
	local userdata = Game.Myself.data.userdata;
	local iconData = {};
	iconData.type = HeadImageIconType.Avatar;
	iconData.id = Game.Myself.data.id;
	iconData.hairID = userdata:Get(UDEnum.HAIR);
	iconData.haircolor = userdata:Get(UDEnum.HAIRCOLOR);
	iconData.gender = userdata:Get(UDEnum.SEX);
	local classid = userdata:Get(UDEnum.PROFESSION);
	local classData = Table_Class[classid];
	iconData.bodyID = iconData.gender == 1 and classData.MaleBody or classData.FemaleBody;
	iconData.headID = 400146;
	iconData.eyeID = userdata:Get(UDEnum.EYE);
	self.headIconCell:SetData(iconData);

	local tasteData = Table_TasterLevel[ self.tasterlv ];
	local titleName = Table_Appellation[ tasteData.Title ].Name;
	self.titleText.text = titleName;
	self.desc1.text = string.format(ZhString.FoodTastLvUpPopUp_TitleTip, titleName);
	self.desc2.text = string.format(ZhString.FoodTastLvUpPopUp_TitleTip2, tasteData.AddBuffs);

end

function FoodTastLvUpPopUp:OnEnter()
	FoodTastLvUpPopUp.super.OnEnter(self);

	self.tasterlv = self.viewdata.tasterlv;
	self:UpdateInfo();
end

function FoodTastLvUpPopUp:OnExit()
	FoodTastLvUpPopUp.super.OnExit(self);

end