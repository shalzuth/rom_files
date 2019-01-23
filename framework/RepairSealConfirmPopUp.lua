RepairSealConfirmPopUp = class("RepairSealConfirmPopUp", BaseView);

RepairSealConfirmPopUp.ViewType = UIViewType.PopUpLayer

local RepairSeal_CostId = 5522

function RepairSealConfirmPopUp:Init()
	self:InitPopUp();
end

function RepairSealConfirmPopUp:InitPopUp()
	self.quickButton = self:FindGO("QuickButton");
	self.quickButton_Sp = self.quickButton:GetComponent(UISprite);
	self.quickButton_Collider = self.quickButton:GetComponent(BoxCollider);
	self.quickButton_Label = self:FindComponent("Label", UILabel, self.quickButton);
	self:AddClickEvent(self.quickButton, function (go)
		self:DoQuick();
	end);

	self.confirmButton = self:FindGO("ConfirmButton");
	self:AddClickEvent(self.confirmButton, function (go)
		self:DoConfirm();
	end);

	self.item_icon = self:FindComponent("Icon", UISprite);
	self.item_num = self:FindComponent("num", UILabel);
end

function RepairSealConfirmPopUp:UpdateInfo()
	local nowMapId = Game.MapManager:GetMapID();
	local nowSealItem = SealProxy.Instance:GetSealItem(nowMapId, self.sealid)
	local mapId = nowSealItem.mapid;

	self.leftnum = 0;

	local qfitemid = GameConfig.Seal.quickfinish_cost or 5522;
	if(type(qfitemid) == "table")then
		for i=1,#qfitemid do
			local  qMapId= qfitemid[i][2];
			if(qMapId == 0 or qMapId == mapId)then
				local leftnum = BagProxy.Instance:GetItemNumByStaticID(qfitemid[i][1]);
				if(leftnum > 0)then
					self.costItemId = qfitemid[i][1];
					self.leftnum = leftnum;
					break;
				end
			end
		end

		if(self.costItemId == nil)then
			local leftnum = BagProxy.Instance:GetItemNumByStaticID(5522);
			if(leftnum > 0)then
				self.costItemId = 5522;
				self.leftnum = leftnum;
			end
		end

		if(self.costItemId ~= nil)then
			local sData = Table_Item[self.costItemId];
			IconManager:SetItemIcon(sData.Icon, self.item_icon);
			self.itemName = sData.NameZh;
		end
	end
	if(self.itemName == nil)then
		self.itemName = Table_Item[5522].NameZh;
	end

	self.item_num.text = 1;

	if(self.leftnum > 0)then
		-- self:ActiveQuickButton(true);
		self.item_num.color = ColorUtil.NGUIWhite;
	else
		-- self:ActiveQuickButton(false);
		self.item_num.color = ColorUtil.NGUILabelRed;
	end

	-- self:ActiveQuickButton(leftnum > 0);
end

function RepairSealConfirmPopUp:ActiveQuickButton(b)
	if(b)then
		self.quickButton_Sp.color = ColorUtil.NGUIWhite;
		self.quickButton_Collider.enabled = true;
		self.quickButton_Label.effectColor = ColorUtil.NGUILabelBlueBlack;
	else
		self.quickButton_Sp.color = ColorUtil.NGUIShaderGray;
		self.quickButton_Collider.enabled = false;
		self.quickButton_Label.effectColor = ColorUtil.NGUIGray;
	end
end

function RepairSealConfirmPopUp:DoQuick()
	if(self.leftnum <= 0)then
		MsgManager.ShowMsgByIDTable(3405, { self.itemName });
		return;
	end

	ServiceSceneSealProxy.Instance:CallBeginSeal(self.sealid, SceneSeal_pb.EFINISHTYPE_QUICK);

	self:CloseSelf();
end

function RepairSealConfirmPopUp:DoConfirm()
	ServiceSceneSealProxy.Instance:CallBeginSeal(self.sealid, SceneSeal_pb.EFINISHTYPE_NORMAL);
	self:CloseSelf();
end

function RepairSealConfirmPopUp:OnEnter()
	RepairSealConfirmPopUp.super.OnEnter(self);

	self.sealid = self.viewdata.viewdata.sealid;
	self:UpdateInfo();
end

function RepairSealConfirmPopUp:OnExit()
	RepairSealConfirmPopUp.super.OnExit(self);
end