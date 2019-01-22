HireCatPopUp = class("HireCatPopUp", BaseView);

HireCatPopUp.ViewType = UIViewType.NormalLayer

function HireCatPopUp:Init()
	self.continueButton = self:FindGO("ContinueBtn");
	-- todo xde prefab ???????????????
	if self.continueButton == nil then
		helplog("msm")
		self.continueButton = self:FindGO("ConfirmBtn");
	else
		helplog("ztm")
	end
	local continueButton_Label = self:FindComponent("Label", UILabel, self.continueButton);
	continueButton_Label.text = ZhString.HireCatPopUp_Hire;

	self:AddClickEvent(self.continueButton, function (go)
		self:DoHire();
	end);

	local closeButton = self:FindGO("CloseButton");
	local closeButton_Label = self:FindComponent("Label", UILabel, closeButton);
	closeButton_Label.text = ZhString.HireCatPopUp_Cancel;

	local hire_1 = self:FindGO("HireDayTog_1");
	self.hireDay_1_TipLabel = self:FindComponent("TipLabel", UILabel, hire_1);
	self.hireDay_1_Label = self:FindComponent("Label", UILabel, hire_1);

	self.hireDay_1_TipLabel.text = string.format(ZhString.HireCatPopUp_HireDay, 1);
	self.hireDay_1_Label.text = 0;
	self.hireDay_1_Tog = self:FindComponent("Tog_1", UIToggle, hire_1);

	local hire_7 = self:FindGO("HireDayTog_7");
	self.hireDay_7_TipLabel = self:FindComponent("TipLabel", UILabel, hire_7);
	self.hireDay_7_Label = self:FindComponent("Label", UILabel, hire_7);

	self.hireDay_7_TipLabel.text = string.format(ZhString.HireCatPopUp_HireDay, 7);
	self.hireDay_7_Label.text = 0;
	self.hireDay_7_Tog = self:FindComponent("Tog_7", UIToggle, hire_7);

	self.modelContainer = self:FindComponent("ModelContainer", ChangeRqByTex);

	self:MapEvent();
end

function HireCatPopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.QuestQueryOtherData, self.UpdateHirePrice);
end

function HireCatPopUp:UpdateHirePrice(note)
	local data = note.body;

	local dataType = data.type;
	if(dataType == SceneQuest_pb.EOTHERDATA_CAT)then
		local ddata = data.data;
		local dayType = ddata.param2;
		local price = ddata.param3;

		if(dayType == 1)then
			self.hireDay_1_price = price;
			self.hireDay_1_Label.text = price;
		elseif(dayType == 2)then
			self.hireDay_7_price = price;
			self.hireDay_7_Label.text = price;
		end
	end
end

function HireCatPopUp:DoHire()
	local hireDay, hirePrice = nil, nil;
	if(self.hireDay_1_Tog.value)then
		hirePrice = self.hireDay_1_price;
		hireDay = ScenePet_pb.EEMPLOYTYPE_DAY;
	else
		hirePrice = self.hireDay_7_price;
		hireDay = ScenePet_pb.EEMPLOYTYPE_WEEK;
	end

	local userdata = Game.Myself and Game.Myself.data.userdata;
	if(userdata)then
		local num = userdata:Get(UDEnum.SILVER) or 0;
		if(num < hirePrice)then
			MsgManager.ShowMsgByIDTable(1);
			return;
		end
	end

	-- TODO Server
	ServiceScenePetProxy.Instance:CallHireCatPetCmd(self.catid, hireDay)

	self:CloseSelf();
end

local tempRot = LuaQuaternion();
local tempV3 = LuaVector3();
function HireCatPopUp:RefreshMonsterModel(mid)
	self:DestroyRoleModel();
	self.role = Asset_RoleUtility.CreateMonsterRole(mid);
	self.role:SetParent(self.modelContainer.transform, false);
	self.role:SetLayer( self.modelContainer.gameObject.layer );

	self.role:SetPosition(LuaGeometry.Const_V3_zero);
	tempV3:Set(0,180,0);
	tempRot.eulerAngles = tempV3;
	self.role:SetRotation(tempRot);
	self.role:SetScale(150);
	self.role:PlayAction_AttackIdle();
end

function HireCatPopUp:DestroyRoleModel()
	if(self.role)then
		self.role:Destroy();
		self.role = nil;
	end
end

function HireCatPopUp:OnEnter()
	HireCatPopUp.super.OnEnter(self);

	self.catid = self.viewdata and self.viewdata.catid;
	if(self.catid)then
		local catData = Table_MercenaryCat[self.catid];
		if(catData)then
			self:RefreshMonsterModel(catData.MonsterID);
		end
	end

	self.hireDay_1_price = 0;
	self.hireDay_7_price = 0;

	ServiceQuestProxy.Instance:CallQueryCatPrice(self.catid, 1)
	ServiceQuestProxy.Instance:CallQueryCatPrice(self.catid, 2)
end

function HireCatPopUp:OnExit()
	HireCatPopUp.super.OnExit(self);

	self:DestroyRoleModel();
end