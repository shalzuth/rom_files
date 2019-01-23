PackageEquipPage = class("PackageEquipPage", SubView)

PackageEquipPage.EquipConfig = {
	[1] = SceneItem_pb.EEQUIPPOS_SHIELD,
	[2] = SceneItem_pb.EEQUIPPOS_ARMOUR,
	[3] = SceneItem_pb.EEQUIPPOS_ROBE,
	[4] = SceneItem_pb.EEQUIPPOS_SHOES,
	[5] = SceneItem_pb.EEQUIPPOS_ACCESSORY1,
	[6] = SceneItem_pb.EEQUIPPOS_ACCESSORY2,
	[7] = SceneItem_pb.EEQUIPPOS_WEAPON,
	[8] = SceneItem_pb.EEQUIPPOS_HEAD,
	[9] = SceneItem_pb.EEQUIPPOS_FACE,
	[10] = SceneItem_pb.EEQUIPTYPE_MOUTH,
	[11] = SceneItem_pb.EEQUIPPOS_BACK,
	[12] = SceneItem_pb.EEQUIPPOS_TAIL,
	[13] = SceneItem_pb.EEQUIPPOS_MOUNT,
	[14] = SceneItem_pb.EEQUIPPOS_BARROW or 14,
	[15] = SceneItem_pb.EEQUIPPOS_ARTIFACT,
	[16] = SceneItem_pb.EEQUIPPOS_ARTIFACT_HEAD,
	[17] = SceneItem_pb.EEQUIPPOS_ARTIFACT_BACK,
}

PackageEquip_FashionParts = 
{
	2,7,8,1,9,10,11,12,13,
}
	
if(GameConfig.SystemForbid.FashionPart)then
	PackageEquip_FashionParts = 
	{
		8,7,9,1,10,11,12,
	}
end

PackageEquip_ShowShieldPart_Class = 
{
	72,73,74,
}


autoImport("MyselfEquipItemCell")

local tempV3 = LuaVector3();
local tempRot = LuaQuaternion();

local EQUIP_MAXINDEX = nil;

function PackageEquipPage:Init()
	EQUIP_MAXINDEX = #PackageEquipPage.EquipConfig;

	self:AddViewInterest();
	self:InitUI();
end


local equipgrid_reposition = function (equipGrid_self)
	equipGrid_self.grid:Reposition();

	local childCount = equipGrid_self.transform.childCount;
	if(childCount == 13)then
		local cell13 = equipGrid_self.transform:GetChild(12);
		if(cell13)then
			tempV3:Set(216, -488);
			cell13.transform.localPosition = tempV3;
		end
	elseif(childCount == 14)then
		local cell13 = equipGrid_self.transform:GetChild(12);
		if(cell13)then
			tempV3:Set(144, -488);
			cell13.transform.localPosition = tempV3;
		end
		local cell14 = equipGrid_self.transform:GetChild(13);
		if(cell14)then
			tempV3:Set(288, -488);
			cell14.transform.localPosition = tempV3;
		end
	end
end
function PackageEquipPage:GetEquipGrid()
	local grid = self:FindComponent("EquipGrid", UIGrid);
	local equipGrid = {};
	equipGrid.grid = grid;
	equipGrid.transform = grid.transform;
	equipGrid.gameObject = grid.gameObject;
	equipGrid.Reposition = equipgrid_reposition;

	equipGrid.comp = equipGrid.gameObject:GetComponent(GameObjectForLua);
	if(not equipGrid.comp)then
		equipGrid.comp = equipGrid.gameObject:AddComponent(GameObjectForLua);
	end
	equipGrid.comp.onEnable = function ()
		equipGrid.Reposition(equipGrid);
	end

	return equipGrid;
end
local fashion_reposition = function (fashionGrid_self)
	local childCount = fashionGrid_self.transform.childCount;
	if(childCount > 6)then
		fashionGrid_self.grid.cellHeight = 582/math.ceil(childCount/2);
	else
		fashionGrid_self.grid.cellHeight = 195.6;
	end

	fashionGrid_self.grid:Reposition();
end
function PackageEquipPage:GetFashionGrid()
	local grid = self:FindComponent("FashionGrid", UIGrid);

	local fashionGrid = {};
	fashionGrid.grid = grid;
	fashionGrid.transform = grid.transform;
	fashionGrid.gameObject = grid.gameObject;
	fashionGrid.Reposition = fashion_reposition;

	fashionGrid.comp = fashionGrid.gameObject:GetComponent(GameObjectForLua);
	if(not fashionGrid.comp)then
		fashionGrid.comp = fashionGrid.gameObject:AddComponent(GameObjectForLua);
	end
	fashionGrid.comp.onEnable = function ()
		fashionGrid.Reposition(fashionGrid);
	end

	return fashionGrid;
end

function PackageEquipPage:InitCtls()
	local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
	if(self.roleEquips and self.fashionEquips)then
		local cachePro = self.cachePro;
		if(cachePro ~= nil and cachePro == myPro)then
			return;
		end
	end
	self.cachePro = myPro;

	self:InitEquipCtl();
	self:InitFashionCtl();
	self:InitArtifactEquips();
end


function PackageEquipPage:InitEquipCtl()
	local equipGrid = self:GetEquipGrid();
	if(equipGrid.transform.childCount > 0)then
		for i=equipGrid.transform.childCount-1,0,-1 do
			local go = equipGrid.transform:GetChild(i);
			if(go and go ~= self.chooseSymbol)then
				GameObject.DestroyImmediate(go.gameObject);
			end
		end
	end

	self.roleEquips = {};
	local profession = MyselfProxy.Instance:GetMyProfession()
	local canEquipCar = Table_Class[profession].Type == 6;
	for i = 1,14 do
		if(i ~= 14 or canEquipCar)then
			local obj = nil;
			obj = self:LoadPreferb("cell/RoleEquipItemCell", equipGrid);
			obj.name = "RoleEquipItemCell"..i;
			
			self.roleEquips[i] = MyselfEquipItemCell.new(obj, i);
			self.roleEquips[i]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self);
			self.roleEquips[i]:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickEqip, self);
		end
	end

	equipGrid:Reposition();
end

local ArtifactEquipConfig = 
{
	[7] = 15,
	[8] = 16,
	[11] = 17,
}
function PackageEquipPage:InitArtifactEquips()
	for k,v in pairs(ArtifactEquipConfig)do
		local cell = self.roleEquips[k];

		local go = self:FindGO("ArtifactEquipCell", cell.gameObject);
		if(go == nil)then
			go = self:LoadPreferb("cell/ArtifactEquipCell", cell.gameObject);
			go.name = "ArtifactEquipCell";
		end

		local equipGO = self:FindGO("RoleEquipItemCell", go);
		local roleEquipCell = MyselfEquipItemCell.new(equipGO, v);
		roleEquipCell:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self);
		roleEquipCell:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickEqip, self);
		self.roleEquips[v] = roleEquipCell;
	end
end

function PackageEquipPage:InitFashionCtl()
	local fashionGrid = self:GetFashionGrid();
	if(fashionGrid.transform.childCount > 0)then
		for i=fashionGrid.transform.childCount-1,0,-1 do
			local go = fashionGrid.transform:GetChild(i);
			if(go)then
				GameObject.DestroyImmediate(go.gameObject);
			end
		end
	end

	self.fashionEquips = {};
	for i=1,#PackageEquip_FashionParts do
		local index = PackageEquip_FashionParts[i];
		local canShow = false;
		if(index == 1)then
			if(TableUtility.ArrayFindIndex(PackageEquip_ShowShieldPart_Class, self.cachePro) ~= 0)then
				canShow = true;
			end
		else
			canShow = true;
		end
		if(canShow)then
			local obj = self:LoadPreferb("cell/RoleEquipItemCell", fashionGrid);
			obj.name = "FashionEquipItemCell"..index;
			self.fashionEquips[index] = MyselfEquipItemCell.new(obj, index, true);
			self.fashionEquips[index]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self);
			self.fashionEquips[index]:AddEventListener(MouseEvent.DoubleClick, self.DoubleClickEqip, self);
		end
	end
	fashionGrid:Reposition();
end


function PackageEquipPage:InitUI()
	self.chooseSymbol = self:FindGO("EquipChoose");
	self.normalStick = self.container.normalStick;
end

function PackageEquipPage:OnEnter()
	PackageEquipPage.super.OnEnter(self);

	self:InitCtls();
	self:UpdateEquip();
end

function PackageEquipPage:ShowEquipInfo(b)
	for i = 1, #self.roleEquips do
		local cell = self.roleEquips[i];
		cell:ShowStrentlv(b);
	end
end

function PackageEquipPage:ClickEquip(cellCtl)
	local packageView = self.container

	if packageView.equipStrengthenIsShow then
		local equipData = cellCtl.data
		if equipData then
			local index = equipData.index
			local equipInfo = equipData.equipInfo
			if cellCtl.isfashion then
				MsgManager.ShowMsgByIDTable(240)
			elseif not equipInfo:CanStrength() then
				MsgManager.ShowMsgByIDTable(243)
			elseif packageView.equipStrengthenViewController:IsCouldStrengthen(index) then
				self:SetChoose(cellCtl);
				packageView.equipStrengthenViewController:Refresh(index)
			else
				MsgManager.ShowMsgByIDTable(240)
			end
		end
	else
		if(cellCtl~=nil and self.chooseEquip~=cellCtl)then
			self:SetChoose(cellCtl);

			local data = cellCtl.data;
			if(data)then
				local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag, cellCtl.isfashion);
				local callback = function ()
					self:CancelChoose();
				end
				local sdata = {
					itemdata = data,
					funcConfig = funcs,
					ignoreBounds = {cellCtl.gameObject},
					callback = callback,
					showUpTip = true,
				};
				local itemTip = self:ShowItemTip(sdata, self.normalStick, nil, {210,0});
				if(not cellCtl:IsEffective())then
					itemTip:GetCell(1):SetNoEffectTip(true);
				end
			else
				self:ShowItemTip();
			end
		else
			self:CancelChoose();
		end
	end
end

function PackageEquipPage:SetChoose(cellCtl)
	if(cellCtl)then
		local index = cellCtl.index;
		if(type(index)=="number")then
			BagProxy.Instance:SetToEquipPos(self.EquipConfig[index]);
		else
			BagProxy.Instance:SetToEquipPos();
		end
		local go = cellCtl.gameObject;
		if(go)then
			self.chooseSymbol:SetActive(true);
			self.chooseSymbol.transform:SetParent(go.transform, false);
		else
			self.chooseSymbol:SetActive(false);
			self.chooseSymbol.transform:SetParent(go.transform, false);
			self.chooseSymbol.transform:SetParent(self.trans, false);
		end
		self.chooseEquip = cellCtl;
	else
		self.chooseSymbol:SetActive(false);
		self.chooseSymbol.transform:SetParent(self.trans, false);
		BagProxy.Instance:SetToEquipPos();
		self.chooseEquip = nil;
	end
end

function PackageEquipPage:DoubleClickEqip(cellCtl)
	local packageView = self.container
	if packageView.equipStrengthenIsShow then return end
	
	local data = cellCtl.data;
	if(data)then
		local funcs = self.container:GetDataFuncs(data, FunctionItemFunc_Source.RoleEquipBag);
		if(funcs[1])then
			local tipfunc = FunctionItemFunc.Me():GetFuncById(funcs[1]);
			if(type(tipfunc) == "function")then
				tipfunc(data);
			end
		end
	end
	self:SetChoose();
	TipManager.Instance:CloseItemTip();
end

function PackageEquipPage:UpdateEquip()
	-- 更新人物装备
	local equipdata = BagProxy.Instance.roleEquip.siteMap;
	for i = 1,EQUIP_MAXINDEX do
		if(self.roleEquips[i])then
			self.roleEquips[i]:SetData(equipdata[i]);
		end
	end
	local fashiondata = BagProxy.Instance.fashionEquipBag.siteMap;
	for i=1,#PackageEquip_FashionParts do
		local index = PackageEquip_FashionParts[i];
		if(self.fashionEquips[index])then
			self.fashionEquips[index]:SetData(fashiondata[index]);
		end
	end
end

function PackageEquipPage:SetItemDragEnabled(b)
	-- for k,v in pairs(self.roleEquips) do
	-- 	v:CanDrag(b);
	-- end
end

function PackageEquipPage:AddViewInterest()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateEquip);
	self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateEquip);
	self:AddListenEvt(ServiceEvent.ItemEquipPosDataUpdate, self.UpdateEquip);
	self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateEquip);
	self:AddListenEvt(ItemEvent.Equip, self.CancelChoose);
end

function PackageEquipPage:CancelChoose()
	self.chooseSymbol:SetActive(false);
	self.chooseSymbol.transform:SetParent(self.trans, false);
	self:ShowItemTip();
	self:SetChoose();
end

function PackageEquipPage:OnExit()
	self:CancelChoose();
	PackageEquipPage.super.OnExit(self);
end

function PackageEquipPage:AddMaskOnItems()
	local roleEquips = self.roleEquips
	if roleEquips then
		for _, roleEquip in pairs(roleEquips)do
			roleEquip:ShowMask()
		end
	end
	local fashionEquips = self.fashionEquips
	if fashionEquips then
		for _, fashionEquip in pairs(fashionEquips)do
			fashionEquip:ShowMask()
		end
	end
end

function PackageEquipPage:RemoveMaskOnItems()
	local roleEquips = self.roleEquips
	if roleEquips then
		for _, roleEquip in pairs(roleEquips)do
			roleEquip:HideMask()
		end
	end
	local fashionEquips = self.fashionEquips
	if fashionEquips then
		for _, fashionEquip in pairs(fashionEquips)do
			fashionEquip:HideMask()
		end
	end
end