EquipUpgradePopUp = class("EquipUpgradePopUp", BaseView);

EquipUpgradePopUp.ViewType = UIViewType.PopUpLayer

autoImport("EquipUpgradeMaterialTipCell");

function EquipUpgradePopUp:Init()
	self:InitView();
	self:MapEvent();
end

function EquipUpgradePopUp:InitView()
	local grid = self:FindComponent("MaterialGrid", UIGrid);
	self.materialCtl = UIGridListCtrl.new(grid, EquipUpgradeMaterialTipCell, "EquipUpgradeMaterialTipCell");
	self.materialCtl:SetAddCellHandler(self.AddCellFunc, self);
	
	self.costZeny = self:FindComponent("CostZeny", UILabel);

	local confirmButton = self:FindGO("ConfirmButton");
	self.confirmLabel = self:FindComponent("Label", UILabel, confirmButton);
	self:AddClickEvent(confirmButton, function (go)
		FunctionSecurity.Me():LevelUpEquip(function ()
			self:DoConfirm();
		end)
	end);
	local cancelButton = self:FindGO("CancelButton");
	self:AddClickEvent(cancelButton, function (go)
		self:DoCancel();
	end);
end

function EquipUpgradePopUp:AddCellFunc(cell)
	cell:SetUpgradeEquipId(self.equipItem and self.equipItem.id);
end

local _lackItems = {};
local _costEquips = {};

function EquipUpgradePopUp:DoConfirm()
	if(#_lackItems > 0)then
		if(QuickBuyProxy.Instance:TryOpenView(_lackItems))then
			return;
		end
	end

	local needReocver, tipEquips = FunctionItemFunc.RecoverEquips(_costEquips);
	if(needReocver)then
		return;
	end

	if(#tipEquips > 0)then
		MsgManager.ConfirmMsgByID(247, function ()
			ServiceItemProxy.Instance:CallEquipExchangeItemCmd(self.equipItem.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP);
			self:CloseSelf();
		end, nil, nil, tipEquips[1].equipInfo.refinelv)
		return;
	end

	local nowEquiplv = self.equipItem.equipInfo.equiplv;
	local productid = self.equipItem.equipInfo.upgradeData.Product;
	if(nowEquiplv >= self.equipItem.equipInfo.upgrade_MaxLv)then
		MsgManager.ConfirmMsgByID(25402, function ()
			ServiceItemProxy.Instance:CallEquipExchangeItemCmd(self.equipItem.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP);
			self:CloseSelf();
		end, nil, nil, Table_Item[productid].NameZh);
		return;
	end

	ServiceItemProxy.Instance:CallEquipExchangeItemCmd(self.equipItem.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP);
	self:CloseSelf();
end

function EquipUpgradePopUp:DoCancel()
	self:CloseSelf();
end

function EquipUpgradePopUp:UpdateMakeInfo()
	if(self.equipItem == nil)then
		return;
	end


	local equipInfo = self.equipItem.equipInfo;
	if(equipInfo == nil)then
		return;
	end

	local upgradeData = equipInfo.upgradeData;
	if(upgradeData == nil)then
		return;
	end

	local equiplv = equipInfo.equiplv;
	local materialsKey = "Material_" .. (equiplv+1);
	local cost = upgradeData[materialsKey];

	TableUtility.ArrayClear(_costEquips);
	if(cost)then
		local costs = {};

		local upgrade_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade);

		for i=1,#cost do
			local id = cost[i].id;
			if(id ~= 100)then
				if(ItemData.CheckIsEquip(id))then
					local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(
										id, cost[i].num, true, nil, 
										upgrade_checkBagTypes);
					for j=1,#equips do
						table.insert(_costEquips, equips[j])
					end
				end
				table.insert(costs, cost[i]);
			else
				self.costZeny.text = cost[i].num;
			end
		end

		self.materialCtl:ResetDatas(costs);
	end

	TableUtility.ArrayClear(_lackItems);
	local cells = self.materialCtl:GetCells();
	for i=1, #cells do
		local lackitemid ,lacknum = cells[i]:GetLackMaterials();
		if(lackitemid and lacknum)then
			table.insert(_lackItems, {id = lackitemid, count = lacknum});
		end
	end
	if(#_lackItems > 0)then
		self.confirmLabel.text = ZhString.EquipUpgradePopUp_QuickBuy;
	else
		self.confirmLabel.text = ZhString.EquipUpgradePopUp_Upgrade;
	end
end

function EquipUpgradePopUp:MapEvent()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMakeInfo);
end

function EquipUpgradePopUp:OnEnter()
	EquipUpgradePopUp.super.OnEnter(self);

	local viewdata = self.viewdata and self.viewdata.viewdata;
	self.equipItem = viewdata and viewdata.equipItem;
	self:UpdateMakeInfo();
end

function EquipUpgradePopUp:OnExit()
	EquipUpgradePopUp.super.OnExit(self);
end