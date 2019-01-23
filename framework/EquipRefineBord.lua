autoImport("CoreView");
EquipRefineBord = class("EquipRefineBord", CoreView)

autoImport("EquipRepairMatCell");
autoImport("BaseItemCell");
autoImport("MaterialItemCell");

EquipRefineBord_RefineMode = 
{
	Normal = 1,
	Safe = 2,
}

EquipRefineBord_Event = {
	ClickAddEquipButton = "EquipRefineBord_Event_ClickAddEquipButton",
	ClickTargetCell = "EquipRefineBord_Event_ClickTargetCell",
	DoRefine = "EquipRefineBord_Event_DoRefine",
	DoRepair = "EquipRefineBord_Event_DoRepair",
}

EquipRefineBord.DefineColor = {
	SelectedButtonColor_Normal = LuaColor(179/255,217/255,241/255,1),
	SelectedTextColor_Normal = LuaColor(30/255,80/255,188/255,1),
	SelectedButtonColor_Safe = LuaColor(1,232/255,140/255,1),
	SelectedTextColor_Safe = LuaColor(195/255,120/255,42/255,1),
	
	EffectRefineBtnColor_Normal = LuaColor(9/255,27/255,90/255,1),
	EffectRefineBtnColor_Safe = LuaColor(199/255,108/255,32/255,1),

	White = LuaColor.white,
	Black = LuaColor.black,
}

local SAFEREFINE_MAX_LEVEL = 0;
for lv,_ in pairs(GameConfig.SafeRefineEquipCostLottery)do
	SAFEREFINE_MAX_LEVEL = math.max(lv, SAFEREFINE_MAX_LEVEL);
end

local DEFAULT_MATERIAL_SEARCH_BAGTYPES;
local REFINE_MATERIAL_SEARCH_BAGTYPES;
local REPAIR_MATERIAL_SEARCH_BAGTYPES;
local REPAIR_MATERIAL_CFG;

function EquipRefineBord:ctor(go)
	EquipRefineBord.super.ctor(self, go)

	DEFAULT_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default or {1, 9};
	REFINE_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.refine or DEFAULT_MATERIAL_SEARCH_BAGTYPES;
	REPAIR_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.repair or DEFAULT_MATERIAL_SEARCH_BAGTYPES;
	REPAIR_MATERIAL_CFG = GameConfig.Lottery.repair_material

	self:Init();
end

function EquipRefineBord:Init()
	self:InitData();
	self:InitBord();
	self:InitChooseBords();
	ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
end

function EquipRefineBord:InitData()
	self.refineMode = EquipRefineBord_RefineMode.Normal;
	self.maxRefineLv = 0;
	self.refine_MaterialIsFull = false;
	self.refine_cost_Rob = 0;
	self.refine_lackMats = {};
	self.islottery = false;

	self.refine_npcguid = nil;

	self.safeRefine_selectEquipIds = {};

	self.repair_matdata = nil;
end

function EquipRefineBord:InitBord()
	self.title = self:FindGO("Title");

	-- Item Cell
	self.itemName = self:FindComponent("ItemName", UILabel);

	local targetCellGO = self:FindGO("TargetCell")
	self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), targetCellGO);
	self.targetCell = BaseItemCell.new(targetCellGO);
	self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self);
	self.targetCell:RemoveUnuseObj("empty");
	-- Item Cell


	-- empty Bord
	self.emptyBord = self:FindGO("EmptyBord");
	self.emptyBord_TipS1 = self:FindGO("EmptyTip_Style1", self.emptyBord);
	self.emptyBord_TipS2 = self:FindGO("EmptyTip_Style2", self.emptyBord);
	self.addEquipButton = self:FindGO("AddEquipButton", self.emptyBord);
	self:AddClickEvent(self.addEquipButton, function (go)
		self:ClickAddEquipButton();
	end);
	-- empty Bord


	-- refine Bord
	self.refineBord = self:FindGO("RefineBord");
	
	--todo xde
	self.currentRefineLevels = self:FindGO("Label",self:FindGO("currentRefineLevels")):GetComponent(UILabel)
	self.nextRefineLevel = self:FindGO("Label",self:FindGO("NowEffect")):GetComponent(UILabel)

	self.nowEffect1 = self:FindComponent("NowEffect", UILabel, self.refineBord)
	self.nowEffect2 = self:FindComponent("Label", UILabel, self.nowEffect1.gameObject);
	self.nextEffect1 = self:FindComponent("NextEffect", UILabel, self.refineBord)
	self.nextEffect2 = self:FindComponent("Label", UILabel, self.nextEffect1.gameObject);

	self.successProbability = self:FindComponent("successProbability", UILabel, self.refineBord)

	local refineModeBt = self:FindGO("RefineModeCt", self.refineBord);
	self.safeModeSp = self:FindGO("SafeModeSp",refineModeBt)
	self.safeModeLabel = self:FindComponent("SafeModeLabel",UILabel,refineModeBt)
	self.normalModeSp = self:FindGO("NormalModeSp",refineModeBt)
	self.normalModeLabel = self:FindComponent("NormalModeLabel",UILabel,refineModeBt)

	self:AddClickEvent(refineModeBt, function ()
		if(self.refineMode == EquipRefineBord_RefineMode.Safe)then
			self:ChangeRefineMode(EquipRefineBord_RefineMode.Normal)
		elseif(self.refineMode == EquipRefineBord_RefineMode.Normal)then
			self:ChangeRefineMode(EquipRefineBord_RefineMode.Safe)
		end
	end)

	self.refineUnFull = self:FindGO("RefineUnFull", self.refineBord);
	local refineGrid = self:FindComponent("RefineMatGrid", UIGrid, self.refineBord);
	self.refineMatCtl = UIGridListCtrl.new(refineGrid, MaterialItemCell, "MaterialItemCell");
	self.refineMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRefineMatItem, self);

	self.refineTipCt = self:FindGO("RefineTipCt", self.refineBord)
	self.refineModelTip = self:FindComponent("RefineModelTip", UILabel, self.refineTipCt);

	self.refineFull = self:FindGO("RefineFull", self.refineBord)
	self.refineFull_label = self.refineFull:GetComponent(UILabel);

	self.refineButton = self:FindGO("RefineBtn", self.refineBord);
	self.refineButton_Collider = self.refineButton:GetComponent(BoxCollider);
	self.refineButton_Sp = self.refineButton:GetComponent(UISprite);
	self.refineButton_Label = self:FindComponent("Label", UILabel, self.refineButton);
	self:AddClickEvent(self.refineButton,function ()
		self:ClickRefine()
	end)

	self.safeRefineButton = self:FindGO("SafeRefineBtn", self.refineBord)
	self.safeRefineButton_Collider = self.safeRefineButton:GetComponent(BoxCollider);
	self.safeRefineButton_Sp = self.safeRefineButton:GetComponent(UISprite);
	self.safeRefineButton_Label = self:FindComponent("Label", UILabel, self.safeRefineButton);
	self:AddClickEvent(self.safeRefineButton,function ()
		self:ClickRefine()
	end)
	-- refine Bord


	-- repair Bord
	self.repairBord = self:FindGO("RepairBord")
	self.damageTip = self:FindComponent("DamageTip", UILabel, self.repairBord);

	local matGO = self:FindGO("MatGO", self.repairBord)
	local matItemGO = self:FindGO("MatItem", matGO);
	self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), matItemGO);
	self.repair_matCell = EquipRepairMatCell.new(matItemGO)
	self.repair_matCell:AddEventListener(MouseEvent.MouseClick, self.ClickRepairMatCell, self);
	self.repair_matItemName = self:FindComponent("MatItemName", UILabel, matItemGO) 

	local repairButton = self:FindGO("RepairBtn");
	self:AddClickEvent(repairButton, function ()
		self:ClickRepair()
	end);
	-- repair Bord

	self.tipStick = self:FindComponent("TipStick", UIWidget);


	self.repairTipBord = self:FindGO("RepairTipBord");
	self.repairTip_Label = self:FindComponent("RepairTip", UILabel, self.repairTipBord);
end

function EquipRefineBord:ClickAddEquipButton()
	self:PassEvent(EquipRefineBord_Event.ClickAddEquipButton, self);
end

function EquipRefineBord:ClickTargetCell(cellctl)
	self:PassEvent(EquipRefineBord_Event.ClickTargetCell, self);
end

function EquipRefineBord:ChangeRefineMode(refineMode)
	local nowData = self.itemData;
	if(nowData == nil)then
		return;
	end

	self.refineMode = refineMode;

	self:UpdateRefineTip();
	self:UpdateRefineMaterials();

	self:UpdateRefineModeUI();
end

function EquipRefineBord:UpdateRefineModeUI()
	local nowData = self.itemData;
	if(nowData == nil)then
		return;
	end

	local refineMode = self.refineMode;

	if(refineMode == EquipRefineBord_RefineMode.Normal)then
		self.normalModeSp:SetActive(true);
		self.safeModeSp:SetActive(false);

		self.safeModeLabel.color = EquipRefineBord.DefineColor.Black
		self.normalModeLabel.color = EquipRefineBord.DefineColor.SelectedTextColor_Normal	

		self:_helpActiveButton(false, 
			self.safeRefineButton_Sp, 
			self.safeRefineButton_Collider, 
			self.safeRefineButton_Label, 
			ColorUtil.ButtonLabelOrange);

		self:_helpActiveButton(true, 
			self.refineButton_Sp, 
			self.refineButton_Collider, 
			self.refineButton_Label, 
			ColorUtil.ButtonLabelBlue,
			"com_btn_1");

	elseif(refineMode == EquipRefineBord_RefineMode.Safe)then
		self.normalModeSp:SetActive(false);
		self.safeModeSp:SetActive(true);

		self.safeModeLabel.color = EquipRefineBord.DefineColor.SelectedTextColor_Safe
		self.normalModeLabel.color = EquipRefineBord.DefineColor.Black

		self:_helpActiveButton(nowData.equipInfo.refinelv < SAFEREFINE_MAX_LEVEL, 
			self.safeRefineButton_Sp, 
			self.safeRefineButton_Collider, 
			self.safeRefineButton_Label, 
			ColorUtil.ButtonLabelOrange);

		self:_helpActiveButton(false, 
			self.refineButton_Sp, 
			self.refineButton_Collider, 
			self.refineButton_Label, 
			ColorUtil.ButtonLabelBlue,
			"com_btn_1");
	end
end

function EquipRefineBord:ClickRefineMatItem(cellctl)
	if(cellctl and cellctl.data)then
		if(cellctl.data.id == MaterialItemCell.MaterialType.Material)then
			self:ShowItemInfoTip(cellctl);
		else
			self:ShowChooseRefineMaterialBord();
		end
	end
end

function EquipRefineBord:ShowItemInfoTip(cell)
	if(not self.ShowTip)then
		local callback = function ()
			self.ShowTip = false;
		end;
		local sdata = {
			itemdata = cell.data, 
			ignoreBounds = cell.gameObject,
			callback = callback,
		};
		self:ShowItemTip(sdata, self.tipStick, NGUIUtil.AnchorSide.Left, {-180,0});
	else
		self:ShowItemTip();
	end
end

function EquipRefineBord:ClickRefine()
	local nowData = self.itemData;
	if(nowData)then
		if(nowData.equipInfo.refinelv >= 4)then
			FunctionSecurity.Me():RefineEquip(function ()
				self:DoRefine(nowData);
			end, {itemData = nowData});
		else
			self:DoRefine(nowData);
		end
	else
		MsgManager.ShowMsgByIDTable(216)
	end
end
function EquipRefineBord:DoRefine(nowData)
	local equipInfo = nowData.equipInfo
	-- 精炼等级已满
	if(equipInfo.refinelv >= self.maxRefineLv) then
		MsgManager.ShowMsgByIDTable(217)
		return
	end
	-- 装备损坏
	if(equipInfo.damage)then
		MsgManager.ShowMsgByIDTable(228)
		return
	end
	-- 银币不足
	if(MyselfProxy.Instance:GetROB() < self.refine_cost_Rob)then
		MsgManager.ShowMsgByIDTable(1)
		return
	end
	-- 材料不足
	if(#self.refine_lackMats > 0)then
		if(QuickBuyProxy.Instance:TryOpenView(self.refine_lackMats))then
			return;
		end
	end
	if(not self.refine_MaterialIsFull)then
		MsgManager.ShowMsgByIDTable(8);
		return
	end

	-- 安全精炼提示：消耗装备中存在已附魔/精炼装备，是否继续？
	if(self.refineMode == EquipRefineBord_RefineMode.Safe)then
		local isRealSafe, selectSafeEquipIds;
		if(#self.safeRefine_selectEquipIds == 0)then
			selectSafeEquipIds = nil;
			isRealSafe = false;
		else
			isRealSafe = true;
			selectSafeEquipIds = self.safeRefine_selectEquipIds;

			local bagProxy = BagProxy.Instance;
			local recoverItems = {}
			for i=1,#selectSafeEquipIds do
				local item = bagProxy:GetItemByGuid(selectSafeEquipIds[i]);
				if(item)then
					table.insert(recoverItems, item);
				end
			end

			if(FunctionItemFunc.RecoverEquips(recoverItems))then
				return;
			end
		end

		local composeIDs = BlackSmithProxy.Instance:GetComposeIDsByItemData(nowData, isRealSafe)
		local composeId = composeIDs and composeIDs[1];
		ServiceItemProxy.Instance:CallEquipRefine(nowData.id, 
				composeId, 
				nil, 
				nil, 
				self.refine_npcguid,
				isRealSafe,
				selectSafeEquipIds); 

		self:PassEvent(EquipRefineBord_Event.DoRefine, self); 
	else
		ServiceItemProxy.Instance:CallEquipRefine(nowData.id, 
			self.composeID, 
			nil, 
			nil, 
			self.refine_npcguid,
			false); 

		self:PassEvent(EquipRefineBord_Event.DoRefine, self); 
	end
end

function EquipRefineBord:ClickRepairMatCell(cell)
	self:ShowChooseRepairMatBord();
end

function EquipRefineBord:ClickRepair()
	local nowData = self.itemData;

	if(nowData == nil)then
		MsgManager.ShowMsgByIDTable(224)
		return;
	end

	local matdata = self.repair_matdata;
	if(matdata == nil or matdata.id == "None")then
		local lackItem= {id = matdata.staticData.id, count = 1};
		if(QuickBuyProxy.Instance:TryOpenView({lackItem}))then
			return;
		end
	end
	-- 维修材料直接修复
	if(REPAIR_MATERIAL_CFG[matdata.staticData.id])then
		if(BagProxy.Instance:GetItemNumByStaticID(matdata.staticData.id)<=0)then
			local lackItem= {id = matdata.staticData.id, count = 1};
			if(QuickBuyProxy.Instance:TryOpenView({lackItem}))then
				return;
			end
		end
		ServiceItemProxy.Instance:CallEquipRepair(nowData.id, nil, matdata.id);
		self:PassEvent(EquipRefineBord_Event.DoRepair, self); 
		self.chooseBord:Hide();
		return
	end
	local matRefinelv = matdata.equipInfo.refinelv;
	local tipRefinelv = GameConfig.EquipRefine.repair_stuff_msg_lv or 4;
	local maxRevinelv = GameConfig.EquipRefine.repair_stuff_max_lv or 6;

	if(matRefinelv > maxRevinelv)then
		MsgManager.ShowMsgByIDTable(241);
		return;
	end

	if(FunctionItemFunc.RecoverEquips({matdata}))then
		return;
	end

	if(matRefinelv>=tipRefinelv and matRefinelv<=maxRevinelv)then
		MsgManager.ConfirmMsgByID(934,function ()
			ServiceItemProxy.Instance:CallEquipRepair(nowData.id, nil, matdata.id);
			self:PassEvent(EquipRefineBord_Event.DoRepair, self); 
			self.chooseBord:Hide();
		end , nil , nil, matRefinelv)
	else
		ServiceItemProxy.Instance:CallEquipRepair(nowData.id, nil, matdata.id);
		self:PassEvent(EquipRefineBord_Event.DoRepair, self); 
		self.chooseBord:Hide();
	end
end


function EquipRefineBord:Refresh()
	local nowData = self.itemData;

	self.targetCell:SetData(nowData);

	if(nowData ~= nil)then
		self.islottery = LotteryProxy.Instance:IsLotteryEquip(nowData.staticData.id);

		self.itemName.gameObject:SetActive(true);
		self.itemName.text = nowData:GetName();

		self.emptyBord:SetActive(false);

		if(nowData.equipInfo.damage)then
			self.refineBord:SetActive(false);
			self:UpdateRepairInfo();

			self.repairBord:SetActive(true);
		else
			self.refineBord:SetActive(true);
			self:UpdateRefineInfo();

			self.repairBord:SetActive(false);
		end
	else
		self.itemName.gameObject:SetActive(false);
		self.emptyBord:SetActive(true);

		self.refineBord:SetActive(false);
		self.repairBord:SetActive(false);
	end
end

function EquipRefineBord:_helpActiveButton(b, sp, collider, label, ori_labEffectColor, ori_spriteName)
	if(b)then
		if(ori_spriteName)then
			sp.color = ColorUtil.NGUIWhite;
			sp.spriteName = ori_spriteName;
		else
			sp.color = ColorUtil.NGUIWhite;
		end
		collider.enabled = true;
		label.effectColor = ori_labEffectColor;
	else
		sp.color = ColorUtil.NGUIShaderGray;

		if(ori_spriteName)then
			sp.color = ColorUtil.NGUIWhite;
			sp.spriteName = "com_btn_13";
		else
			sp.color = ColorUtil.NGUIShaderGray;
		end

		collider.enabled = false;
		label.effectColor = ColorUtil.NGUIGray;
	end
end

function EquipRefineBord:UpdateRefineTip()
	local nowData = self.itemData;
	if(nowData == nil)then
		self.refineTipCt.gameObject:SetActive(false);
		return;
	end

	self.refineFull:SetActive(false);

	self.refineTipCt.gameObject:SetActive(true);
	local refinelv = nowData.equipInfo.refinelv;

	local matParent = self.refineMatCtl.layoutCtrl.gameObject;
	matParent:SetActive(true);

	if(refinelv >= self.maxRefineLv)then
		self.refineFull:SetActive(true);
		self.refineFull_label.text = ZhString.EquipRefineBord_RefineTip_Full;

		self.refineModelTip.text = ZhString.EquipRefineBord_RefineTip_Full
	else
		local isNormalMode = self.refineMode == EquipRefineBord_RefineMode.Normal;

		local safeClamp_min, safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClamp(self.islottery)
		
		if(refinelv < safeClamp_min - 1 )then
			-- todo xde 精炼等级+1~+4必然成功 => 제련 레벨+1 ~ +4까지 100% 성공 需要转义百分号
			local temp = ZhString.EquipRefineBord_RefineTip_DefiniteSuccess
			temp = ZhString.EquipRefineBord_RefineTip_DefiniteSuccess:gsub("%%", "%%%%")
			self.refineModelTip.text = string.format(temp, safeClamp_min)
		elseif(refinelv >= safeClamp_min - 1 and refinelv < safeClamp_max)then
			if(isNormalMode)then
				self.refineModelTip.text = ZhString.EquipRefineBord_RefineTip_ChooseNormal
			else
				self.refineModelTip.text = ZhString.EquipRefineBord_RefineTip_ChooseNormal2
			end
		elseif(refinelv >= safeClamp_max)then
			if(isNormalMode)then
				self.refineTipCt.gameObject:SetActive(false);
			else
				matParent:SetActive(false);
				self.refineFull:SetActive(true);
				self.refineFull_label.text = string.format(ZhString.EquipRefineBord_TopSafeRefine, safeClamp_max);

				self.refineModelTip.text = ZhString.EquipRefineBord_RefineTip_ChooseNormal3
			end
		end
	end
end

function EquipRefineBord:UpdateRefineMaterials(clearSelectEquipIds)
	if(clearSelectEquipIds)then
		TableUtility.ArrayClear(self.safeRefine_selectEquipIds);
	end

	local nowData = self.itemData;

	if(nowData == nil)then
		self.refineMatCtl:ResetDatas(_EmptyTable);
		return;
	end

	local isSafeMode = self.refineMode == EquipRefineBord_RefineMode.Safe;

	local composeIDs = BlackSmithProxy.Instance:GetComposeIDsByItemData(nowData, isSafeMode)
	self.composeID = composeIDs and composeIDs[1];
	local composeData = self.composeID and Table_Compose[self.composeID];
	if(composeData == nil)then
		errorLog('Refine Not Have ComposeData');
		return;
	end

	self.refine_MaterialIsFull = true;

	self.discount = nil;

	local costItems = {};

	local safeClamp_min, safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClamp(self.islottery)
	local isRealSafe = nowData.equipInfo.refinelv >= safeClamp_min - 1;
	if(isSafeMode and isRealSafe)then
		local ds = BlackSmithProxy.Instance:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE);
		self.discount = ds and ds[2];
	else
		local ds = BlackSmithProxy.Instance:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_NORMAL_REFINE);
		self.discount = ds and ds[2];
	end

	if(self.islottery)then
		self.discount = nil;
	end

	TableUtility.ArrayClear(self.refine_lackMats);

	if(isSafeMode)then
		local refinelv = nowData.equipInfo.refinelv;

		if(refinelv >= SAFEREFINE_MAX_LEVEL)then
			self.refineMatCtl:ResetDatas(costItems);
			return;
		end

		local needNum = BlackSmithProxy.Instance:GetSafeRefineCostEquipNum(refinelv+1, self.islottery);

		if(needNum and needNum > 0)then
			if(#self.safeRefine_selectEquipIds == 0)then
				local filterFunc = function (equip)
					return equip.id ~= nowData.id
				end
				local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REFINE_MATERIAL_SEARCH_BAGTYPES);
				local fnum = math.min(#datas, needNum)
				for i=1,fnum do
					table.insert(self.safeRefine_selectEquipIds, datas[i].id);
				end
				if(needNum > #datas)then
					local vidCache = EquipRepairProxy.Instance:GetEquipVIDCache(nowData.staticData.id);
					local lackEquipId;
					if(vidCache)then
						local minSlot;
						for k,v in pairs(vidCache)do
							if(minSlot == nil or k < minSlot)then
								minSlot = k;
								lackEquipId = v.id;
							end
						end
					else
						lackEquipId = nowData.staticData.id;
					end
					local lackItem = {id = lackEquipId, count = needNum - #datas};
					table.insert(self.refine_lackMats, lackItem);
				end
			end

			local itemData = ItemData.new(MaterialItemCell.MaterialType.MaterialItem, nowData.staticData.id)
			itemData.num = #self.safeRefine_selectEquipIds;
			itemData.neednum = needNum;
			itemData.cardSlotNum = 0;
			itemData.discount = self.discount;
			table.insert(costItems, itemData);

			if(needNum > itemData.num)then
				self.refine_MaterialIsFull = false;
			end
		end
	end

	local bcItems = composeData.BeCostItem;
	for i=1,#bcItems do
		local data = bcItems[i];
		local items = BagProxy.Instance:GetMaterialItems_ByItemId(data.id, REFINE_MATERIAL_SEARCH_BAGTYPES);
		local bagNum = 0;
		for j=1,#items do
			bagNum = bagNum + items[j].num;
		end
		local itemData = ItemData.new(MaterialItemCell.MaterialType.Material, data.id);
		itemData.num = bagNum;
		itemData.neednum = data.num;
		if(isSafeMode and isRealSafe and self.discount)then
			itemData.neednum = math.floor(itemData.neednum * (self.discount/100));
			itemData.discount = self.discount;
		end
		table.insert(costItems, itemData);

		if(bagNum < itemData.neednum)then

			local lackItem = {id = data.id, count = itemData.neednum - bagNum};
			table.insert(self.refine_lackMats, lackItem);

			if(self.refine_MaterialIsFull)then
				self.refine_MaterialIsFull = false;
			end
		end
	end

	self.refine_cost_Rob = composeData.ROB
	if(self.discount)then
		self.refine_cost_Rob = math.floor(self.refine_cost_Rob * (self.discount/100));
	end

	local itemData = ItemData.new(MaterialItemCell.MaterialType.Material, 100)
	itemData.num = self.refine_cost_Rob;
	itemData.discount = self.discount;
	table.insert(costItems, itemData);				

	self.refineMatCtl:ResetDatas(costItems);
end

function EquipRefineBord:UpdateRefineInfo()
	local nowData = self.itemData;

	if(nowData == nil)then
		return;
	end

	local equipInfo = nowData.equipInfo
	local currentLv = equipInfo.refinelv
	self.maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(nowData.staticData)
	if(self.outset_maxrefine and self.outset_maxrefine < self.maxRefineLv)then
		self.maxRefineLv = self.outset_maxrefine;
	end

	self:UpdateRefineTip();
	self:UpdateRefineModeUI();

	if(currentLv >= self.maxRefineLv)then
		self.refineUnFull:SetActive(false)

		self.refineMatCtl:ResetDatas(_EmptyTable);
		return;
	end

	self.refineUnFull:SetActive(true)
	
	self.currentRefineLevels.text = string.format("+%s", currentLv); 
	self.nextRefineLevel.text = string.format("+%s", currentLv+1);

	------------ 精炼属性预览 ------------
	local refineEffect = equipInfo.equipData.RefineEffect;
	local effectName, effectAddValue = next(refineEffect);
	if(effectName and effectAddValue)then
		local proName = GameConfig.EquipEffect[effectName], effectAddValue * equipInfo.refinelv;
		local pro, isPercent = Game.Config_PropName[ effectName ], false;
		if(pro)then
			isPercent = pro.IsPercent == 1;
			if(proName == nil)then
				proName = pro.PropName;
			end
		end

		self.nowEffect1.text = proName..ZhString.EquipRefineBord_EffectSperator;
		self.nextEffect1.text = proName..ZhString.EquipRefineBord_EffectSperator;
		if(isPercent)then
			self.nowEffect2.text = string.format(" +%s%%", effectAddValue * equipInfo.refinelv * 100);
			self.nextEffect2.text = string.format(" +%s%%", effectAddValue * (equipInfo.refinelv + 1) * 100);
		else
			self.nowEffect2.text = string.format(" +%s", effectAddValue * equipInfo.refinelv);
			self.nextEffect2.text = string.format(" +%s", effectAddValue * (equipInfo.refinelv + 1));
		end
	end
	-----------------------------------------------------

	self:UpdateRefineMaterials(true);
end

local Func_GetRepairItemMat = function(quality)
	for id,cfg in pairs(REPAIR_MATERIAL_CFG) do
		for i=1,#cfg do
			if(cfg[i].quality==quality)then
				return id,cfg[i].count
			end
		end
	end
	return nil
end

function EquipRefineBord:UpdateRepairMaterial(itemData)
	local nowData = self.itemData;
	local repairItemMatID = nil
	local lotteryIDs = EnchantTransferProxy.Instance:GetLotteryIDs()

	if(itemData == nil)then
		local repairMats = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REPAIR_MATERIAL_SEARCH_BAGTYPES)
		if(0~=TableUtility.ArrayFindIndex(lotteryIDs,nowData.staticData.id))then
			repairItemMatID = Func_GetRepairItemMat(nowData.staticData.Quality)
			if(repairItemMatID)then
				local items = BagProxy.Instance:GetItemsByStaticID(repairItemMatID)
				if(items)then
					for i=1,#items do
						TableUtility.ArrayPushFront(repairMats,items[i])
					end
				end
			end
		end
		self.repair_matdata = repairMats and repairMats[1];
	else
		self.repair_matdata = itemData;
	end

	if(self.repair_matdata == nil)then
		local vidCache = EquipRepairProxy.Instance:GetEquipVIDCache(nowData.staticData.id);
		local lackEquipId;
		if(vidCache)then
			local minSlot;
			for k,v in pairs(vidCache)do
				if(minSlot == nil or k < minSlot)then
					minSlot = k;
					lackEquipId = v.id;
				end
			end
		else
			lackEquipId = nowData.staticData.id;
		end
		self.repair_matdata = ItemData.new("None", lackEquipId);
	end
	self.repair_matCell:SetData(self.repair_matdata);
	self.repair_matItemName.text = self.repair_matdata:GetName();

	self.repairTip_Label.text = string.format(ZhString.EquipRefineBord_RepairTip, string.gsub(self.itemData.staticData.NameZh, "%[%d+%]", ""));
end

function EquipRefineBord:UpdateRepairInfo()
	local nowData = self.itemData;

	local refineEffect = nowData.equipInfo.equipData.RefineEffect;
	local effectName, effectAddValue = next(refineEffect);
	if(effectName and effectAddValue)then
		local proName, addvalue = GameConfig.EquipEffect[effectName], effectAddValue * nowData.equipInfo.refinelv;
		local pro, isPercent = Game.Config_PropName[ effectName ], false;
		if(pro)then
			isPercent = pro.IsPercent == 1;
		end
		if(isPercent)then
			addvalue = addvalue * 100;
			self.damageTip.text = string.format(ZhString.EquipRefineBord_DamageTip, proName, tostring(addvalue).."%");
		else
			self.damageTip.text = string.format(ZhString.EquipRefineBord_DamageTip, proName, tostring(addvalue));
		end
	end

	self:UpdateRepairMaterial();
end



-- Other Bord Show
autoImport("EquipChooseBord")
autoImport("MaterialChooseBord")
function EquipRefineBord:InitChooseBords()
	local chooseContaienr = self:FindGO("ChooseContainer");
	self.chooseBord = EquipChooseBord.new(chooseContaienr);
	self.chooseBord:Hide();

	self.materialchooseBord = MaterialChooseBord.new(chooseContaienr);
	self.materialchooseBord:Hide();
end

function EquipRefineBord:_MaterialChooseValidFunc(data)
	-- 维修材料
	if(REPAIR_MATERIAL_CFG[data.staticData.id])then
		return true
	end
	if(data and data.equipInfo)then
		local refinelv = data.equipInfo.refinelv or 0;
		local limitlv = GameConfig.EquipRefine.repair_stuff_max_lv or 6;
		return data.equipInfo.refinelv <= limitlv;
	end
	return false;
end

function EquipRefineBord:_MaterialChooseFunc(datas)
	local needReocver, tipEquips = FunctionItemFunc.RecoverEquips(datas);

	if(tipEquips and #tipEquips > 0)then
		MsgManager.ConfirmMsgByID(247, function ()
			self:_DoMaterialChooseFunc(datas);
		end, nil, nil, tipEquips[1].equipInfo.refinelv);
	else
		self:_DoMaterialChooseFunc(datas);
	end
end
function EquipRefineBord:_DoMaterialChooseFunc(datas)
	TableUtility.ArrayClear(self.safeRefine_selectEquipIds);
	for i=1,#datas do
		table.insert(self.safeRefine_selectEquipIds, datas[i].id);
	end

	local cells = self.refineMatCtl:GetCells();
	if(cells and cells[1])then
		local data = cells[1].data;
		if(data)then
			data.num = #datas;

			cells[1]:SetData(data);

			if(data.neednum)then
				self.refine_MaterialIsFull = data.num >= data.neednum;
			end
		end
	end

	self.materialchooseBord:Hide();
end
function EquipRefineBord:ShowChooseRefineMaterialBord()
	local nowData = self.itemData;

	if(nowData == nil)then
		return;
	end

	local filterFunc = function (equip)
		return equip.id ~= nowData.id
	end
	local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REFINE_MATERIAL_SEARCH_BAGTYPES);
	self.materialchooseBord:ResetDatas(datas, true);

	local refinelv = nowData.equipInfo.refinelv;

	local needNum = BlackSmithProxy.Instance:GetSafeRefineCostEquipNum(refinelv+1, self.islottery);

	if(#datas < needNum)then
		local lackEquipId;
		local vidCache = EquipRepairProxy.Instance:GetEquipVIDCache(nowData.staticData.id);
		if(vidCache)then
			local minSlot;
			for k,v in pairs(vidCache)do
				if(minSlot == nil or k < minSlot)then
					minSlot = k;
					lackEquipId = v.id;
				end
			end
		else
			lackEquipId = nowData.staticData.id;
		end
		local lackItem = {id = lackEquipId, count = needNum-#datas};
		if(QuickBuyProxy.Instance:TryOpenView({lackItem}))then
			return;
		end
	end

	self.materialchooseBord:SetTotalNum(needNum);
	self.materialchooseBord:Show(nil, 
		self._MaterialChooseFunc, 
		self,
		self._MaterialChooseValidFunc, 
		self,
		ZhString.EquipRefineBord_InvalidRepairMatTip);

	self.materialchooseBord:SetChoose(self.safeRefine_selectEquipIds);
end

function EquipRefineBord:_RepairChooseFunc(data)
	if(nil==data or nil==data.staticData)then
		return
	end
	local isRepairItemMat=nil~=REPAIR_MATERIAL_CFG[data.staticData.id]
	if(not isRepairItemMat and nil==data.equipInfo)then
		return
	end

	local _RepairChoose_ConfirmCall = function ()
		self.chooseBord:Hide();
	end
	local _RepairChoose_CancelCall = function ()
		self.chooseBord:SetChoose(self.repair_matdata);
	end
	if(not isRepairItemMat and FunctionItemFunc.RecoverEquips({data}, _RepairChoose_ConfirmCall, _RepairChoose_CancelCall))then
		return;
	end
	helplog("EquipRefineBord _RepairChooseFunc")
	self:UpdateRepairMaterial(data);
	self.chooseBord:Hide();
end

function EquipRefineBord:ShowChooseRepairMatBord()
	local nowData = self.itemData;
	local lotteryIDs = EnchantTransferProxy.Instance:GetLotteryIDs()
	if(nowData == nil)then
		return;
	end
	local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REPAIR_MATERIAL_SEARCH_BAGTYPES);
	if(0~=TableUtility.ArrayFindIndex(lotteryIDs,nowData.staticData.id))then
		local repairMatID,num = Func_GetRepairItemMat(nowData.staticData.Quality)
		local own = BagProxy.Instance:GetItemsByStaticID(repairMatID)
		if(own)then
			-- 维修扭蛋头饰道具
			for i=1,#own do
				TableUtility.ArrayPushFront(datas,own[i])
			end
		end
	end
	if(#datas == 0)then
		local lackEquipId = self.repair_matdata.staticData.id;
		local lackItem = {id = lackEquipId, count = 1};
		if(QuickBuyProxy.Instance:TryOpenView({lackItem}))then
			return;
		end
		return;
	end
	self.chooseBord:ResetDatas(datas, true);
	self.chooseBord:Show(nil, 
		self._RepairChooseFunc,
		self,
		self._MaterialChooseValidFunc,
		self,
		ZhString.EquipRefineBord_InvalidRepairMatTip);
	self.chooseBord:SetChoose(self.repair_matdata);
	self.chooseBord:SetBordTitle(ZhString.EquipRefineBord_ChooseMat);
end
-- Other Bord Show




-- Public
function EquipRefineBord:GetNowItemData()
	return self.itemData;
end

function EquipRefineBord:ActiveTitle(b)
	self.title.gameObject:SetActive(b);
end

function EquipRefineBord:SetTargetItem(itemData)
	self.itemData = itemData;

	self:Refresh();
end

function EquipRefineBord:SetEmptyStyle(s)
	self.emptyBord_TipS1:SetActive(s == 1);
	self.emptyBord_TipS2:SetActive(s == 2);
end

function EquipRefineBord:SetNpcguid(npcguid)
	self.refine_npcguid = npcguid;
end

function EquipRefineBord:SetMaxRefineLv(maxRefinelv)
	self.outset_maxrefine = maxRefinelv;
end
-- Public
