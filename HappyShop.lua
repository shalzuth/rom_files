autoImport("ShopItemCell")
autoImport("HappyShopBuyItemCell")

HappyShop = class("HappyShop",ContainerView)

HappyShop.ViewType = UIViewType.NormalLayer

ShopInfoType = {
	MyProfession = "MyProfession",
	All = "All"
}

function HappyShop:GetShowHideMode()
	return PanelShowHideMode.MoveOutAndMoveIn
end

function HappyShop:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function HappyShop:FindObjs()
	self.moneySprite = {}
	self.moneySprite[1] = self:FindGO("goldIcon"):GetComponent(UISprite)
	self.moneySprite[2] = self:FindGO("silversIcon"):GetComponent(UISprite)
	self.moneyLabel = {}
	self.moneyLabel[1] = self:FindGO("gold"):GetComponent(UILabel)
	self.moneyLabel[2] = self:FindGO("silvers"):GetComponent(UILabel)

	self.LeftStick=self:FindGO("LeftStick"):GetComponent(UISprite)
	self.ItemScrollView=self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
	self.myProfessionBtn = self:FindGO("MyProfessionBtn"):GetComponent(UIToggle)
	self.myProfessionLabel = self:FindGO("MyProfessionLabel"):GetComponent(UILabel)
	self.allBtn = self:FindGO("AllBtn")
	self.allLabel = self:FindGO("AllLabel"):GetComponent(UILabel)
	self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
	self.skipBtn.gameObject:SetActive(HappyShopProxy.Instance:IsShowSkip()) 
	self.toggleRoot = self:FindGO("ToggleRoot")
	self.descLab = self:FindGO("desc"):GetComponent(UILabel)

	self:InitBuyItemCell()
end

function HappyShop:InitBuyItemCell()
	local go = self:LoadCellPfb("HappyShopBuyItemCell")
	self.buyCell = HappyShopBuyItemCell.new(go)
	self.CloseWhenClickOtherPlace = self.buyCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
end

function HappyShop:AddEvts()

	self:AddOrRemoveGuideId(self.buyCell.countPlusBg.gameObject,16)

	self:AddOrRemoveGuideId(self.buyCell.confirmButton.gameObject,17)

	self.ItemScrollView.onDragStarted = function ()
		self.selectGo=nil
		self.buyCell.gameObject:SetActive(false)
		TipsView.Me():HideCurrent();
	end

	self:AddClickEvent(self.skipBtn.gameObject, function ()
		self:OnClickSkip()
	end)

	self.CloseWhenClickOtherPlace.callBack=function ()
		if(self.selectGo)then
			local size = NGUIMath.CalculateAbsoluteWidgetBounds(self.selectGo.transform);
			if(self.uiCamera==nil)then
				self.uiCamera = NGUITools.FindCameraForLayer(self.selectGo.layer);
			end
			local pos=self.uiCamera:ScreenToWorldPoint(Input.mousePosition)
			if(not size:Contains(Vector3(pos.x,pos.y,pos.z)))then
				self.selectGo=nil
			elseif not self.buyCell.gameObject.activeSelf then
				self.buyCell.gameObject:SetActive(true)
			end
		end
	end

	if self.myProfessionBtn then
		self:AddClickEvent(self.myProfessionBtn.gameObject,function (g)
			self:ClickMyProfession(g)
		end)
	end

	if self.allBtn then
		self:AddClickEvent(self.allBtn,function (g)
			self:ClickAll(g)
		end)
	end
end

function HappyShop:OnClickSkip()
	local skipType = HappyShopProxy.Instance.aniConfig[2]
	if(skipType)then
		TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn , NGUIUtil.AnchorSide.Top, {120,50})
	end
end

function HappyShop:AddViewEvts()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
	self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
	self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
	self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvShopDataUpdate)
	self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopInfo)

	self:AddListenEvt(ServiceEvent.SessionShopQueryShopSoldCountCmd, self.HandleShopSoldCountCmd)
	self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvUpdateShopConfig)

	self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateMoney)
end

function HappyShop:InitShow()
	self:InitShopInfo()

	self.tipData = {}
	self.tipData.funcConfig = {}
end

function HappyShop:InitUI()
	EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.RecvItemGetCount, self)

	self:InitScreen()
	self:InitLeftUpIcon()
	self:UpdateShopInfo(true)
	self:UpdateMoney()

	self.buyCell.gameObject:SetActive(false)
end

function HappyShop:InitShopInfo()

	local itemContainer=self:FindGO("shop_itemContainer")
	local wrapConfig = {
		wrapObj = itemContainer, 
		pfbNum = 10, 
		cellName = "ShopItemCell", 
		control = ShopItemCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick , self.HandleClickItem , self)
	self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
	self.descLab.text=HappyShopProxy.Instance.desc
end

function HappyShop:InitScreen()
	if HappyShopProxy.Instance:GetScreen() then
		self.infoType = ShopInfoType.MyProfession
		self.toggleRoot:SetActive(true)
		
		self.myProfessionBtn.value = true
		self.myProfessionLabel.color = ColorUtil.TitleBlue
		self.allLabel.color = ColorUtil.TitleGray
	else
		self.infoType = ShopInfoType.All
		self.toggleRoot:SetActive(false)
	end
end

function HappyShop:InitLeftUpIcon()
	local _HappyShopProxy = HappyShopProxy
	local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
	if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild then
		for i=1,#self.moneySprite do
			self.moneySprite[i].gameObject:SetActive(false)
		end
		return
	end

	local moneyTypes = _HappyShopProxy.Instance:GetMoneyType()
	if moneyTypes then
		for i=1,#self.moneySprite do
			local moneyId = moneyTypes[i]
			if moneyId then
				local item = Table_Item[moneyId]
				if item then
					IconManager:SetItemIcon(item.Icon, self.moneySprite[i])
					self.moneySprite[i].gameObject:SetActive(true)					
				end
			else
				self.moneySprite[i].gameObject:SetActive(false)
			end
		end
	end
end

function HappyShop:HandleClickItem(cellctl)

	if self.currentItem ~= cellctl then
		if self.currentItem then
			self.currentItem:SetChoose(false)
		end
		cellctl:SetChoose(true)
		self.currentItem = cellctl
	end

	local id = cellctl.data
	local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
	local go = cellctl.gameObject;

	if(self.selectGo==go)then
		self.selectGo=nil
		return
	end
	self.selectGo=go;

	if data then
		if data:GetLock() then
			FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID , true)
			self.buyCell.gameObject:SetActive(false)
			return
		end

		local _HappyShopProxy = HappyShopProxy
		local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
		if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
			MsgManager.ShowMsgByID(3808)
			self.buyCell.gameObject:SetActive(false)
			return
		end

		HappyShopProxy.Instance:SetSelectId(id)
		self:UpdateBuyItemInfo(data)
	end
end

function HappyShop:HandleClickIconSprite(cellctl)
	local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(cellctl.data)
	self:ShowHappyItemTip(data)

	self.buyCell.gameObject:SetActive(false)
	self.selectGo=nil
end

function HappyShop:ShowHappyItemTip(data)
	if data.goodsID then
		self.tipData.itemdata = data:GetItemData()
		self:ShowItemTip(self.tipData, self.LeftStick)
	else
		errorLog("HappyShop ShowItemTip data.goodsID == nil")
	end
end

function HappyShop:OnEnter()
	HappyShop.super.OnEnter(self);
	self:handleCameraQuestStart()
	self:InitUI()
	self:HandleSpecial(true)
end

function HappyShop:OnExit()
	self:CameraReset()
	HappyShopProxy.Instance:SetSelectId(nil)
	HappyShopProxy.Instance:RemoveLeanTween()
	self.buyCell:Exit()
	TipsView.Me():HideCurrent()
	EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.RecvItemGetCount, self)

	if(self.needUpdateSold)then
		self.needUpdateSold = false;
		ServiceMatchCCmdProxy.Instance:CallOpenGlobalShopPanelCCmd(false) 
	end
	self:HandleSpecial(false)

	HappyShop.super.OnExit(self)
end

-- ??????????????????????????????????????????
local shopCameraConfig = 
{
	BAR=923,			-- ???????????????
	VENDING_MACHINE=924,-- ???????????????
}

function HappyShop:handleCameraQuestStart()
	local npcdata = HappyShopProxy.Instance:GetNPC()
	if(npcdata)then
		local isSpecial = true
		local shopType,viewPort,rotation
		shopType=HappyShopProxy.Instance.shopType
		if(shopType==shopCameraConfig.VENDING_MACHINE)then
			viewPort = CameraConfig.Vending_Machine_ViewPort
			rotation = CameraConfig.Vending_Machine_Rotation
		elseif(shopType==shopCameraConfig.BAR)then
			viewPort = CameraConfig.Bar_ViewPort
			rotation = CameraConfig.Bar_Rotation
		else
			isSpecial=false
			viewPort = CameraConfig.HappyShop_ViewPort
			rotation = CameraConfig.HappyShop_Rotation
		end
		if(isSpecial)then
			self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform,viewPort,rotation)
		else
			self:CameraFaceTo(npcdata.assetRole.completeTransform,viewPort,rotation)
		end
	end
end

function HappyShop:UpdateShopInfo(isReset)
	local datas
	if self.infoType == ShopInfoType.MyProfession then
		datas = HappyShopProxy.Instance:GetMyProfessionItems()
	elseif self.infoType == ShopInfoType.All then
		datas = HappyShopProxy.Instance:GetShopItems()
	end

	if datas then

		self:NeedUpdateSold(datas);

		self.itemWrapHelper:UpdateInfo(datas)
		HappyShopProxy.Instance:SetSelectId(nil)
	else
		printRed("HappyShop:UpdateShopInfo : datas is nil ~")
	end

	if isReset == true then
		self.itemWrapHelper:ResetPosition()
	end
end

function HappyShop:NeedUpdateSold(datas)
	if(self.needUpdateSold == true)then
		return;
	end

	local _HappyShopProxy = HappyShopProxy.Instance;
	for i=1,#datas do
		local id = datas[i];
		local shopdata = _HappyShopProxy:GetShopItemDataByTypeId(id);
		if(shopdata and shopdata.produceNum and shopdata.produceNum > 0)then
			ServiceMatchCCmdProxy.Instance:CallOpenGlobalShopPanelCCmd(true) 
			self.needUpdateSold = true;
			return;
		end
	end
end

function HappyShop:UpdateMoney()
	local moneyTypes = HappyShopProxy.Instance:GetMoneyType()
	if moneyTypes then
		for i=1,#self.moneyLabel do
			local moneyType = moneyTypes[i]
			if moneyType then
				local money = StringUtil.NumThousandFormat( HappyShopProxy.Instance:GetItemNum(moneyTypes[i]))
				self.moneyLabel[i].text = money
			else
				self.moneyLabel[i].text = ""
			end
		end
	end
end

function HappyShop:UpdateBuyItemInfo(data)
	if (data == nil) then return end

	self.buyCell:SetData(data)
	TipsView.Me():HideCurrent()
end

function HappyShop:ClickMyProfession()
	self.myProfessionLabel.color = ColorUtil.TitleBlue
	self.allLabel.color = ColorUtil.TitleGray

	self.infoType = ShopInfoType.MyProfession
	self:UpdateShopInfo(true)
end

function HappyShop:ClickAll()
	self.myProfessionLabel.color = ColorUtil.TitleGray
	self.allLabel.color = ColorUtil.TitleBlue
	
	self.infoType = ShopInfoType.All
	self:UpdateShopInfo(true)
end

function HappyShop:RecvBuyShopItem(note)
	local success = note.body.success
	if(HappyShopProxy.Instance.aniConfig[2] and success)then
		if(HappyShopProxy.Instance.aniConfig[2]=="functional_action")then
			HappyShopProxy.Instance:PlayFunctionalAction()
		else
			HappyShopProxy.Instance:PlayAnimationEff()
		end
	end
	self:UpdateShopInfo()
end

function HappyShop:RecvQueryShopConfig(note)
	self:InitScreen()
	self:UpdateShopInfo(true)

	self.buyCell.gameObject:SetActive(false)
end

function HappyShop:RecvShopDataUpdate(note)
	local data = note.body
	if data then
		local _HappyShopProxy = HappyShopProxy.Instance
		if data.type == _HappyShopProxy:GetShopType() and data.shopid == _HappyShopProxy:GetShopId() then
			_HappyShopProxy:CallQueryShopConfig()
		end
	end
end

function HappyShop:RecvItemGetCount(note)
	local data = note.data
	if data then
		self.buyCell:SetItemGetCount(data)
	end
end

function HappyShop:RecvUpdateShopConfig(note)
	self:UpdateShopInfo(true)
	self.buyCell.gameObject:SetActive(false)
end

function HappyShop:HandleShopSoldCountCmd(note)
	local cells = self.itemWrapHelper:GetCellCtls();	
	for j=1,#cells do
		cells[j]:RefreshBuyCondition();
	end

	if(self.buyCell.gameObject.activeSelf)then
		self.buyCell:UpdateSoldCountInfo();
	end
end

function HappyShop:AddCloseButtonEvent()
	HappyShop.super.AddCloseButtonEvent(self)
	self:AddOrRemoveGuideId("CloseButton",15);
end

function HappyShop:HandleSpecial(on)
	local _HappyShopProxy = HappyShopProxy
	local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
	if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild then
		ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(on)
	end
end

function HappyShop:LoadCellPfb(cName)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
	if(cellpfb == nil) then
		error ("can not find cellpfb"..cName)
	end
	cellpfb.transform:SetParent(self.gameObject.transform,false)
	return cellpfb
end