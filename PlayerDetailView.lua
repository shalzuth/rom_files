PlayerDetailView = class("PlayerDetailView", ContainerView)

PlayerDetailView.ViewType = UIViewType.CheckLayer

autoImport("SimplePlayer");
autoImport("MyselfEquipItemCell");
autoImport("PlayerAttriButeView");
autoImport("PackageEquipPage");

PlayerDetailView.State = {
	None = "PlayerDetailView_State_None",
	Equip = "PlayerDetailView_State_Equip",
	Attri = "PlayerDetailView_State_Attri",
	Fashion = "PlayerDetailView_State_Fashion"
}
PlayerDetailView.TabName = {
	EquipTab = ZhString.PlayerDetailView_EquipTabName,
	AttriTab = ZhString.PlayerDetailView_AttriTabName,
	FashionTab = ZhString.PlayerDetailView_FashionTabName
}
PlayerDetailView.LongPressEvent = "PlayerDetailView_LongPress"

local tempV3 = LuaVector3();

function PlayerDetailView:Init()
	self:InitUI();
end

function PlayerDetailView:TransEquipGrid(grid, width)
	local equipGrid = {};
	equipGrid.grid = grid;
	equipGrid.transform = grid.transform;
	equipGrid.gameObject = grid.gameObject;
	equipGrid.Reposition = function (equipGrid_self)
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
				tempV3:Set(width, -488);
				cell13.transform.localPosition = tempV3;
			end
			local cell14 = equipGrid_self.transform:GetChild(13);
			if(cell14)then
				tempV3:Set(width * 2, -488);
				cell14.transform.localPosition = tempV3;
			end
		end
	end
	return equipGrid;
end

local fashion_reposition = function (fashionGrid_self)
	local childCount = fashionGrid_self.transform.childCount;
	fashionGrid_self.grid.cellHeight = childCount > 6 and 582/math.ceil(childCount/2) or 195.6;
	fashionGrid_self.grid:Reposition();
end

function PlayerDetailView:GetFashionGrid()
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
	fashionGrid.comp.onEnable = function () fashionGrid.Reposition(fashionGrid) end

	return fashionGrid;
end

function PlayerDetailView:InitUI()
	self.roleBord = self:FindGO("RoleBord")
	self.roleTex = self:FindComponent("RoleTexture", UITexture);

	self.myEquips = self:FindGO("MyEquips");
	self.roleEquips = self:FindGO("RoleEquips");

	local myGrid = self:FindComponent("MyEquipGrid", UIGrid);
	self.myEquipGrid = self:TransEquipGrid(myGrid, 144);
	local playerGrid = self:FindComponent("PlayerEquipGrid", UIGrid);
	self.playerEquipGrid = self:TransEquipGrid(playerGrid, 129);

	self.myRoleEquip, self.playerRoleEquip = {}, {};
	for i = 1,14 do
		local myObj = self:LoadPreferb("cell/RoleEquipItemCell", self.myEquipGrid);
		myObj.name = "RoleEquipItemCell"..i;

		local playerObj = self:LoadPreferb("cell/RoleEquipItemCell", self.playerEquipGrid);
		playerObj.name = "RoleEquipItemCell"..i;

		self.myRoleEquip[i] = MyselfEquipItemCell.new(myObj, i);
		self.myRoleEquip[i]:AddEventListener(MouseEvent.MouseClick, self.ClickMyEquip, self);

		self.playerRoleEquip[i] = MyselfEquipItemCell.new(playerObj, i);
		self.playerRoleEquip[i]:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerEquip, self);
	end

	self.myEquipGrid:Reposition();
	self.playerEquipGrid:Reposition();

	self.myAttriHolder = self:FindGO("attrViewHolder");
	self.playerAttriHolder = self:FindGO("PlayerAttriViewHolder");

	self.roleFashions = self:FindGO("RoleFashions")

	self.roleInfo = self:FindGO("RoleInfo");
	self.playerName = self:FindComponent("Name", UILabel, self.roleInfo);
	self.partnerName = self:FindComponent("PartnerName", UILabel, self.roleInfo);
	-- self.playerGuildName = self:FindComponent("GuildName", UILabel, roleInfo);
	-- self.playerGuildIcon = self:FindComponent("GuildIcon", UISprite, roleInfo);

	self.normalStick = self:FindComponent("NormalStick", UISprite);
	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self:InitTabEvent();

	self.leftState = PlayerDetailView.State.None;
	self.rightState = PlayerDetailView.State.Equip;
	self:UpdateLeftState();
	self:UpdateRightState();
	self:SetCurrentTabIconColor(self.equipTab);

	self.myBaseAttriView = self:AddSubView("BaseAttributeView", BaseAttributeView);
	self.playerAttriView = self:AddSubView("PlayerAttriButeView", PlayerAttriButeView);
end

function PlayerDetailView:InitFashionCtl(playerPro)
	local shieldShow = TableUtility.ArrayFindIndex(PackageEquip_ShowShieldPart_Class, playerPro) ~= 0
	if (nil ~= self.shieldShow and shieldShow == self.shieldShow) then return end
	self.shieldShow = shieldShow

	local fashionGrid = self:GetFashionGrid();
	if (fashionGrid.transform.childCount > 0) then
		for i = fashionGrid.transform.childCount - 1, 0, -1 do
			local go = fashionGrid.transform:GetChild(i);
			if (go) then
				GameObject.DestroyImmediate(go.gameObject);
			end
		end
	end

	self.fashionEquips = {};
	for i = 1, #PackageEquip_FashionParts do
		local index = PackageEquip_FashionParts[i];
		if (index ~= 1 or shieldShow) then
			local obj = self:LoadPreferb("cell/RoleEquipItemCell", fashionGrid);
			obj.name = "FashionEquipItemCell" .. index;
			self.fashionEquips[index] = MyselfEquipItemCell.new(obj, index, true);
			self.fashionEquips[index]:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerEquip, self);
		end
	end
	fashionGrid:Reposition();
end

function PlayerDetailView:ClickMyEquip(cellCtl)
	self:ClickEquip(cellCtl, true);
end

function PlayerDetailView:ClickPlayerEquip(cellCtl)
	self:ClickEquip(cellCtl, false);
end

function PlayerDetailView:ClickEquip(cellCtl, isClickMyself)
	if(cellCtl~=nil and self.chooseEquip~=cellCtl)then
		local data = cellCtl.data;
		if(data)then
			local offset = isClickMyself and {190, 0} or {-190, 0};
			self:ShowPlayerEquipTip(data, cellCtl.gameObject, offset, isClickMyself);
			self.chooseSymbol.transform:SetParent(cellCtl.gameObject.transform, false);
			self.chooseSymbol.transform.localPosition = Vector3.zero;
			self.chooseSymbol:SetActive(true);
		else
			self:CancelChoose();
			self:ShowItemTip();
		end

		self.chooseEquip = cellCtl;
	else
		self:CancelChoose();
		self:ShowItemTip();
	end
end

function PlayerDetailView:ShowPlayerEquipTip(data, ignoreBound, offset, isClickMyself)
	local callback = function ()
		self:CancelChoose();
	end
	local sdata = {
		itemdata = data,
		ignoreBounds = {ignoreBound},
		callback = callback,
	};
	
	local itemtip = self:ShowItemTip(sdata, self.normalStick, nil, offset);

	local compareData = nil;
	if(isClickMyself)then
		compareData = self.playerEquipDatas[data.index];
	else
		compareData = BagProxy.Instance.roleEquip:GetEquipBySite(data.index);
	end

	if(itemtip)then
		if(compareData and self.rightState ~= PlayerDetailView.State.Fashion)then
			local cell = itemtip:GetCell(1);
			if(cell)then
				local compareFunc = function (data)
					self.leftState = PlayerDetailView.State.Equip;
					self:UpdateLeftState();
					self:CancelChoose();

					local sdata = {};
					if(isClickMyself)then
						sdata.itemdata = compareData;
						sdata.compdata1 = data;
					else
						sdata.itemdata = data;
						sdata.compdata1 = compareData;
					end
					self:ShowItemTip(sdata, self.normalStick, nil, {0,0});
				end
				cell:AddTipFunc(ZhString.PlayerDetailView_CompareTip, compareFunc, data, true);
			end
		end

		itemtip:HideEquipedSymbol();
	end
end

function PlayerDetailView:CancelChoose()
	self.chooseEquip = nil;
	self.chooseSymbol.transform:SetParent(self.trans, false);
	self.chooseSymbol:SetActive(false);
end

function PlayerDetailView:InitTabEvent()
	self.leftequipInfoTab = self:FindGO("EquipInfoTab");
	self:AddClickEvent(self.leftequipInfoTab, function (go)
		if(self.leftState == PlayerDetailView.State.Equip)then
			self.leftState = PlayerDetailView.State.None;
		else
			self.leftState = PlayerDetailView.State.Equip;
		end
		self:UpdateLeftState();
	end);

	self.rightattrInfoTab = self:FindGO("AttrInfoTab");
	self:AddClickEvent(self.rightattrInfoTab, function (go)
		if(self.leftState == PlayerDetailView.State.Attri)then
			self.leftState = PlayerDetailView.State.None;
		else
			self.leftState = PlayerDetailView.State.Attri;
		end
		self:UpdateLeftState();
	end);

	self.equipTab = self:FindGO("EquipTab");	
	self.attriTab = self:FindGO("AttriTab");
	self.fashionTab = self:FindGO("FashionTab");
	self:AddClickEvent(self.equipTab, function (go)
		self.leftState = PlayerDetailView.State.Equip;
		self.rightState = PlayerDetailView.State.Equip;
		self:UpdateLeftState();
		self:UpdateRightState();
		self:SetCurrentTabIconColor(go);
	end);
	self:AddClickEvent(self.attriTab, function (go)
		self.leftState = PlayerDetailView.State.Attri;
		self.rightState = PlayerDetailView.State.Attri;
		self:UpdateLeftState();
		self:UpdateRightState();
		self:SetCurrentTabIconColor(go);
	end);
	self:AddClickEvent(self.fashionTab, function (go)
		self.leftState = PlayerDetailView.State.Fashion;
		self.rightState = PlayerDetailView.State.Fashion;
		self:UpdateLeftState();
		self:UpdateRightState();
		self:SetCurrentTabIconColor(go);
	end);

	-- LongPress for TabNameTip
	local equipLongPress = self.equipTab:GetComponent(UILongPress)
	local attriLongPress = self.attriTab:GetComponent(UILongPress)
	local fashionLongPress = self.fashionTab:GetComponent(UILongPress)
	local longPressEvent = function (obj, state)
		self:PassEvent(PlayerDetailView.LongPressEvent, {state, obj.gameObject});
	end
	equipLongPress.pressEvent = longPressEvent
	attriLongPress.pressEvent = longPressEvent
	fashionLongPress.pressEvent = longPressEvent
	self:AddEventListener(PlayerDetailView.LongPressEvent, self.HandleLongPress, self)

	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- ?????????????????????
		iconActive=true;nameLabelActive=false;
	else -- ????????????????????????
		iconActive=false;nameLabelActive=true;
	end
	self.tabIconSpList = {}
	local tabList = {self.equipTab, self.attriTab, self.fashionTab}
	for i,v in ipairs(tabList) do
		local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
		icon:SetActive(iconActive)
		self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
		local label = GameObjectUtil.Instance:DeepFindChild(v, "Label")
		label:SetActive(nameLabelActive)
	end
end

function PlayerDetailView:UpdateLeftState()
	if(self.leftState == PlayerDetailView.State.Equip)then
		self.leftequipInfoTab.transform.localRotation = Quaternion.Euler(0,180,0);
		self.rightattrInfoTab.transform.localRotation = Quaternion.identity;

		self.myEquips.gameObject:SetActive(true);
		self.myAttriHolder:SetActive(false);

	elseif(self.leftState == PlayerDetailView.State.Attri)then
		self.rightattrInfoTab.transform.localRotation = Quaternion.Euler(0,180,0);
		self.leftequipInfoTab.transform.localRotation = Quaternion.identity;

		self.myEquips.gameObject:SetActive(false);
		self.myAttriHolder:SetActive(true);
		self.myBaseAttriView:showMySelf();
	else
		self.rightattrInfoTab.transform.localRotation = Quaternion.identity;;
		self.leftequipInfoTab.transform.localRotation = Quaternion.identity;

		self.myEquips.gameObject:SetActive(false);
		self.myAttriHolder:SetActive(false);
	end
end

function PlayerDetailView:UpdateRightState()
	self.roleInfo:SetActive(self.rightState == PlayerDetailView.State.Equip or 
		self.rightState == PlayerDetailView.State.Fashion)
	self.roleBord:SetActive(self.rightState == PlayerDetailView.State.Equip or 
		self.rightState == PlayerDetailView.State.Fashion)
	self.roleEquips:SetActive(self.rightState == PlayerDetailView.State.Equip);
	self.playerAttriHolder:SetActive(self.rightState == PlayerDetailView.State.Attri);
	self.roleFashions:SetActive(self.rightState == PlayerDetailView.State.Fashion)
end

function PlayerDetailView:ResetTabIconColor()
	for i,v in ipairs(self.tabIconSpList) do
		v.color = ColorUtil.TabColor_White
	end
end

function PlayerDetailView:SetCurrentTabIconColor(currentTabGo)
	self:ResetTabIconColor()
	if not currentTabGo then return end
	local iconSp = GameObjectUtil.Instance:DeepFindChild(currentTabGo, "Icon"):GetComponent(UISprite);
	if not iconSp then return end
	iconSp.color = ColorUtil.TabColor_DeepBlue
end

function PlayerDetailView:SetPlayerModelTex( )
	if(self.playerData)then
		local parts = Asset_Role.CreatePartArray();

		local userdata = self.playerData.userdata;
		local partIndex = Asset_Role.PartIndex;
		local partIndexEx = Asset_Role.PartIndexEx;
		parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0;
		parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0;
		parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0;
		parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0;
		parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0;
		parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0;
		parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0;
		parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0;
		parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0;
		parts[partIndex.Mount] = 0
		parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0;

		parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0;
		parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0;
		parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0;
		parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0;

		UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, parts, UIModelCameraTrans.Team)

		Asset_Role.DestroyPartArray(parts);
	end
end

function PlayerDetailView:UpdatePlayerRoleEquips()
	local equipdata = self.playerEquipDatas;
	if(self.playerRoleEquip)then
		for i=1,#self.playerRoleEquip do
			local equipCell = self.playerRoleEquip[i];
			equipCell:SetData(equipdata[i]);
		end
	end
end

function PlayerDetailView:UpdateRoleInfo()
	local str = self.playerData.name;
	local guildData = self.playerData:GetGuildData();
	if(guildData)then
		str = string.format("%s<%s>", str, guildData.name)
	end
	self.playerName.text = str;
	----[[ todo xde ?????????????????????
	self.playerName.text = AppendSpace2Str(str)
	--]]

	local partner = self.playerData_partner;

	if(partner and partner~="")then
		self.partnerName.gameObject:SetActive(true);
		self.partnerName.text = string.format(ZhString.PlayerDetailView_PartnerName, partner);
	else
		self.partnerName.gameObject:SetActive(false);
	end
end

function PlayerDetailView:UpdateMyRoleEquips()
	-- ??????????????????
	local equipdata = BagProxy.Instance.roleEquip.siteMap;
	for i = 1,#self.myRoleEquip do
		self.myRoleEquip[i]:SetData(equipdata[i]);
	end
end

function PlayerDetailView:UpdatePlayerRoleFashions()
	local fashiondata = self.playerFashionDatas;
	for i = 1, #PackageEquip_FashionParts do
		local index = PackageEquip_FashionParts[i];
		if(self.fashionEquips[index])then
			self.fashionEquips[index]:SetData(fashiondata[index]);
		end
	end
end

function PlayerDetailView:CreatePlayerData( serverData )
	self:DestroyPlayerData();

	self.playerData = PlayerData.CreateAsTable( serverData )

	self.playerData.name = serverData.name;

	local datas = serverData.datas;
	if(datas)then
		for i = 1, #datas do
			local celldata = datas[i];
			if celldata ~= nil then
				self.playerData.userdata:SetByID(celldata.type, celldata.value, celldata.data)
			end
		end
	end
	
	local attrs = serverData.attrs;
	if(attrs)then
		for i = 1, #attrs do
			local cellAttri = attrs[i];
			if cellAttri ~= nil then
				self.playerData.props:SetValueById(cellAttri.type, cellAttri.value)
			end
		end
	end

	local tempArray = ReusableTable.CreateArray();
	tempArray[1] = serverData.guildid;
	tempArray[2] = serverData.guildname;
	tempArray[3] = serverData.guildportrait;
	tempArray[4] = serverData.guildjob;
	self.playerData:SetGuildData(tempArray);
	ReusableTable.DestroyArray(tempArray);

	self:InitFashionCtl(self.playerData.userdata:Get(UDEnum.PROFESSION))
end

function PlayerDetailView:DestroyPlayerData( )
	if(self.playerData)then
		self.playerData:Destroy();
		self.playerData = nil;
	end
end

function PlayerDetailView:UpdateViewInfo(dataInfo)
	if(dataInfo)then
		self:CreatePlayerData( dataInfo );

		self.playerEquipDatas = {};
		if(dataInfo.equip)then
			for i=1,#dataInfo.equip do
				local itemdata = ItemData.new();
				TableUtil.Print(dataInfo.equip[i])
				itemdata:ParseFromServerData(dataInfo.equip[i]);
				if(itemdata.index)then
					self.playerEquipDatas[itemdata.index] = itemdata;
				end
			end
		end

		self.playerFashionDatas = {};
		if(dataInfo.fashion)then
			for i=1,#dataInfo.fashion do
				local itemdata = ItemData.new();
				TableUtil.Print(dataInfo.fashion[i])
				itemdata:ParseFromServerData(dataInfo.fashion[i]);
				if(itemdata.index)then
					self.playerFashionDatas[itemdata.index] = itemdata;
				end
			end
		end

		self.playerAttriView:SetPlayer(self.playerData);
		self.playerData_partner = dataInfo.partner;
	end
	self:SetPlayerModelTex();
	self:UpdatePlayerRoleEquips();
	self:UpdatePlayerRoleFashions();
	self:UpdateRoleInfo();

	self:UpdateMyRoleEquips();
	self:CameraRotateToMe();
end

function PlayerDetailView:OnEnter()
	PlayerDetailView.super.OnEnter(self);

	local dataInfo = self.viewdata.viewdata and self.viewdata.viewdata.dataInfo;
	if(dataInfo)then
		self:UpdateViewInfo(dataInfo);
	else
		self:CloseSelf();
	end

	self.myBaseAttriView:OnEnter();
	self.myBaseAttriView:HideHelpBtn();

	self.playerAttriView:OnEnter();
	self.playerAttriView:HideHelpBtn();

end

function PlayerDetailView:OnExit()
	PlayerDetailView.super.OnExit(self);

	self:CameraReset();
	self:DestroyPlayerData();
end

function PlayerDetailView:HandleLongPress(param)
	local isPressing, go = param[1], param[2];
	
	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local backgroundSp = go:GetComponent(UISprite);
			TipManager.Instance:TryShowHorizontalTabNameTip(PlayerDetailView.TabName[go.name], backgroundSp, NGUIUtil.AnchorSide.Left)
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end
