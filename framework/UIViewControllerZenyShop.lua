autoImport('UIListItemCtrlLuckyBag')
autoImport('UIListItemViewControllerZenyShopItem')
autoImport('UIModelZenyShop')
autoImport('UIModelMonthlyVIP')
autoImport('UISubViewControllerMonthlyVIP')
autoImport('UISubViewControllerZenyList')
autoImport('UISubViewControllerGachaCoin')
autoImport('UISubViewControllerZenyShopItem')
autoImport('FuncZenyShop')

UIViewControllerZenyShop = class('UIViewControllerZenyShop', ContainerView)

UIViewControllerZenyShop.ViewType = UIViewType.NormalLayer

local reusableArray = {}

UIViewControllerZenyShop.instance = nil

function UIViewControllerZenyShop:Init()
	UIViewControllerZenyShop.instance = self

	-- UIModelZenyShop.Ins():RequestQueryShopItem()
	self:GetGameObjects()
	self:RegisterButtonClickEvent()
	self:BGAdapt()
	self:LoadView()
	self.zenyController = self:AddSubView('UISubViewControllerZenyList', UISubViewControllerZenyList)
	self.monthlyVIPController = self:AddSubView('UISubViewControllerMonthlyVIP', UISubViewControllerMonthlyVIP)
	self.gachaCoinController = self:AddSubView('UISubViewControllerGachaCoin', UISubViewControllerGachaCoin)
	self.itemController = self:AddSubView('UISubViewControllerZenyShopItem', UISubViewControllerZenyShopItem)

	local goodsType = self.viewdata.view.tab
	goodsType = (goodsType == PanelConfig.ZenyShop.tab) and PanelConfig.ZenyShopGachaCoin.tab or goodsType
	local goSelection = self:FindGO(tostring(goodsType), self.goSelections)
	if goodsType == PanelConfig.ZenyShopMonthlyVIP.tab then
		self:SwitchToMonthlyVIP(goSelection)
	elseif goodsType == PanelConfig.ZenyShopGachaCoin.tab then
		self:SwitchToGachaCoin(goSelection)
	elseif goodsType == PanelConfig.ZenyShopItem.tab then
		self:SwitchToItem(goSelection)
	elseif goodsType == PanelConfig.ZenyShop.tab then
		self:SwitchToZeny(goSelection)
	end
	-- self:RegisterZenyIconTargetPosition()
	-- self:SetZenyIconRoot()
	-- self:SetZenyIconCount()
	self:ListenServerResponse()
end

function UIViewControllerZenyShop:OnExit()
	UIViewControllerZenyShop.super.OnExit(self)

	UIViewControllerZenyShop.instance = nil
end

function UIViewControllerZenyShop:GetGameObjects()
	self.goBTNBack = self:FindGO('BTN_Back', self.gameObject)
	self.goZenyBalance = self:FindGO('ZenyBalance', self.gameObject)
	self.goLabZenyBalance = self:FindGO('Lab', self.goZenyBalance)
	self.labZenyBalance = self.goLabZenyBalance:GetComponent(UILabel)
	self.spZeny = self:FindGO('Icon', self.goZenyBalance):GetComponent(UISprite)
	IconManager:SetItemIcon('item_100', self.spZeny)
	self.goGachaCoinBalance = self:FindGO('GachaCoinBalance', self.gameObject)
	self.goLabGachaCoinBalance = self:FindGO('Lab', self.goGachaCoinBalance)
	self.labGachaCoinBalance = self.goLabGachaCoinBalance:GetComponent(UILabel)
	self.spGachaCoin = self:FindGO('Icon', self.goGachaCoinBalance):GetComponent(UISprite)
	IconManager:SetItemIcon('item_151', self.spGachaCoin)
	self.goZenyIconRoots = self:FindGO('ZenyIconRoots', self.gameObject)
	self.goRootTemplate = self:FindGO('RootTemplate', self.gameObject)
	self.goPanelDynamicNPC = self:FindGO('PanelDynamicNPC', self.gameObject)
	self.goDynamicNPC = self:FindGO('DynamicNPC', self.goPanelDynamicNPC)
	self.texDynamicNPC = self.goDynamicNPC:GetComponent(UITexture)
	self.widgetTipRelative = self:FindGO('TipRelativeWidget', self.gameObject):GetComponent(UIWidget)
	self.goBG = self:FindGO('BG', self.gameObject)
	self.texBG = self.goBG:GetComponent(UITexture)
	self.goTip = self:FindGO('Tip', self.gameObject)
	self.spFrame = self:FindGO('Frame', self.goTip):GetComponent(UISprite)
	self.goSelections = self:FindGO('Selections')
	self.goSelectionTemplate = self:FindGO('Selection', self.goSelections)

	-- todo xde 隐藏“适度娱乐，理性消费”label
	self.tipsLabel = self:FindGO('GameObject', self.gameObject)
	self.tipsLabel:SetActive(false)
end

function UIViewControllerZenyShop:RegisterButtonClickEvent()
	self:AddClickEvent(self.goBTNBack, function ()
		self:OnClickForButtonBack()
	end)
end

function UIViewControllerZenyShop:GetMonthCardConfigure()
	local year = UIModelMonthlyVIP.YearOfServer(-18000)
	local month = UIModelMonthlyVIP.MonthOfServer(-18000)
	for _, v in pairs(Table_MonthCard) do
		if v.Year == year and v.Month == month then
			return v
		end
	end
	return nil
end

function UIViewControllerZenyShop:LoadView()
	self:LoadZenyBalanceView()
	if self.goSelections.transform.childCount <= 1 then
		local functionCount = 0
		local functions = GameConfig.ZenyShop.Functions
		for i = 1, #functions do
			local tab = functions[i].Tab
			local isForbid = false
			if tab == PanelConfig.ZenyShop.tab then
				isForbid = GameConfig.SystemForbid.ZenyPurchase
			elseif tab == PanelConfig.ZenyShopMonthlyVIP.tab then
				isForbid = GameConfig.SystemForbid.CardPurchase
			elseif tab == PanelConfig.ZenyShopGachaCoin.tab then
				isForbid = GameConfig.SystemForbid.GoldPurchase
			elseif tab == PanelConfig.ZenyShopItem.tab then
				isForbid = GameConfig.SystemForbid.ItemPurchase
			end
			if not isForbid then
				functionCount = functionCount + 1

				local functionName = functions[i].Title
				local goSelection = GameObject.Instantiate(self.goSelectionTemplate)
				goSelection.transform:SetParent(self.goSelections.transform, false)
				goSelection.name = tab
				goSelection:SetActive(true)
				self:AddClickEvent(goSelection, function ()
					self:OnClickForButtonSelection(goSelection)
				end)
				local labTitle = self:FindGO('Title', goSelection):GetComponent(UILabel)
				labTitle.text = functionName
			end
		end
		self.goSelections:GetComponent(UIGrid).repositionNow = true

		local widthOfTipFrame = self.spFrame.width
		widthOfTipFrame = widthOfTipFrame + functionCount * 180
		self.spFrame.width = widthOfTipFrame
	end
	local monthCardConfigure = self:GetMonthCardConfigure()
	-- todo xde 防止月卡一张都没
	if monthCardConfigure ~= nil then
		PictureManager.Instance:SetZenyShopNPC(monthCardConfigure.NpcPicture, self.texDynamicNPC)
	else
		PictureManager.Instance:SetZenyShopNPC("Kapla", self.texDynamicNPC)
	end
end

function UIViewControllerZenyShop:LoadZenyBalanceView()
	local milCommaBalance = FuncZenyShop.FormatMilComma(MyselfProxy.Instance:GetROB())
	if milCommaBalance then
		self.labZenyBalance.text = milCommaBalance
	end
	milCommaBalance = FuncZenyShop.FormatMilComma(MyselfProxy.Instance:GetLottery())
	if milCommaBalance then
		self.labGachaCoinBalance.text = milCommaBalance
	end
end

function UIViewControllerZenyShop:OnClickForButtonBack()
	-- local zenyBalance = MyselfProxy.Instance:GetROB() or 0
	-- local digitsValue = {}
	-- local isBreak = false
	-- local digit = 10
	-- while not isBreak do
	-- 	local quotient = math.CalculateQuotient(zenyBalance, digit)
	-- 	local remainder = math.CalculateRemainder(zenyBalance, digit)
	-- 	table.insert(digitsValue, remainder)
	-- 	if quotient == 0 then
	-- 		break
	-- 	else
	-- 		zenyBalance = quotient
	-- 	end
	-- end
	-- for k, v in pairs(digitsValue) do
	-- 	if k > 0 and k < 7 then
	-- 		if v == 1 then
	-- 			self:CachePurchasedItem(k)
	-- 		end
	-- 	end
	-- end
	if self.zenyController ~= nil then
		local purchasedShopItems = self.zenyController:GetCachedPurchaseItem()
		if purchasedShopItems ~= nil then
			self:ShowAnimationConfirmView()
		end
	end

	self:CloseSelf()
end

function UIViewControllerZenyShop:OnClickForButtonSelection(go)
	local goName = tonumber(go.name)
	if goName == PanelConfig.ZenyShopMonthlyVIP.tab then
		self:SwitchToMonthlyVIP(go)
	elseif goName == PanelConfig.ZenyShopGachaCoin.tab then
		self:SwitchToGachaCoin(go)
	elseif goName == PanelConfig.ZenyShopItem.tab then
		self:SwitchToItem(go)
	elseif goName == PanelConfig.ZenyShop.tab then
		self:SwitchToZeny(go)
	end
	if self.currentSubViewCtrl ~= nil then
		if self.currentSubViewCtrl == subViewController then
			return
		else
			self.currentSubViewCtrl.gameObject:SetActive(false)
		end
	end
	self.currentSubViewCtrl = subViewController
	local tab = goName
	self.goZenyBalance:SetActive(tab == PanelConfig.ZenyShop.tab or tab == PanelConfig.ZenyShopMonthlyVIP.tab)
	self.goGachaCoinBalance:SetActive(tab == PanelConfig.ZenyShopGachaCoin.tab or tab == PanelConfig.ZenyShopItem.tab)
-- todo xde
--	self:ChangeSelection(self.sSpBGSelection[tab], self.sLabTitleSelection[tab])
end

function UIViewControllerZenyShop:ListenServerResponse()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.OnReceiveEventMyDataChange)
	self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, nil)
	self:AddListenEvt(ServiceEvent.ItemGetCountItemCmd, nil)
	self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, nil)
end

function UIViewControllerZenyShop:OnReceiveEventMyDataChange(data)
	self:LoadZenyBalanceView()
end

function UIViewControllerZenyShop:RegisterZenyIconTargetPosition()
	if self.itemsController then
		for _, v in pairs(self.itemsController) do
			local itemController = v
			itemController:RegisterZenyIconTargetPosition(self.goZenyBalance.transform.position)
		end
	end
end

function UIViewControllerZenyShop:SetZenyIconRoot(trans)
	if self.itemsController then
		for _, v in pairs(self.itemsController) do
			local itemController = v

			local goCopyRootTemplate = GameObject.Instantiate(self.goRootTemplate)
			local transCopyRootTemplate = goCopyRootTemplate.transform
			transCopyRootTemplate:SetParent(self.goZenyIconRoots.transform)
			local pos = transCopyRootTemplate.localPosition
			pos.x = 0; pos.y = 0; pos.z = 0
			transCopyRootTemplate.localPosition = pos
			local rotation = transCopyRootTemplate.localRotation
			local eulerAngles = rotation.eulerAngles
			eulerAngles.x = 0; eulerAngles.y = 0; eulerAngles.z = 0
			rotation.eulerAngles = eulerAngles
			transCopyRootTemplate.localRotation = rotation
			local scale = transCopyRootTemplate.localScale
			scale.x = 1; scale.y = 1; scale.z = 1
			transCopyRootTemplate.localScale = scale

			itemController:SetZenyIconRoot(transCopyRootTemplate)
		end
	end
end

function UIViewControllerZenyShop:SetZenyIconCount()
	if self.itemsController then
		for _, v in pairs(self.itemsController) do
			local itemController = v
			itemController:SetZenyIconCount()
		end
	end
end

function UIViewControllerZenyShop:SwitchToZeny(go_selection)
	if not self.zenyController.isInit then
		self.zenyController:MyInit()
	end
	self.zenyController.gameObject:SetActive(true)
	if self.monthlyVIPController.isInit then
		self.monthlyVIPController.gameObject:SetActive(false)
	end
	if self.gachaCoinController.isInit then
		self.gachaCoinController.gameObject:SetActive(false)
	end
	if self.itemController.isInit then
		self.itemController.gameObject:SetActive(false)
	end

	self.goZenyBalance:SetActive(true)
	self.goGachaCoinBalance:SetActive(false)

	if self.spBGBTNChargeSelection == nil then
		self.spBGBTNChargeSelection = self:FindGO('BG', go_selection):GetComponent(UISprite)
	end
	if self.labTitleBTNChargeSelection == nil then
		self.labTitleBTNChargeSelection = self:FindGO('Title', go_selection):GetComponent(UILabel)
	end
	self:ChangeSelection(self.spBGBTNChargeSelection, self.labTitleBTNChargeSelection)
end

function UIViewControllerZenyShop:SwitchToMonthlyVIP(go_selection)
	if not self.monthlyVIPController.isInit then
		self.monthlyVIPController:MyInit()
	end
	self.monthlyVIPController.gameObject:SetActive(true)
	if self.zenyController.isInit then
		self.zenyController.gameObject:SetActive(false)
	end
	if self.gachaCoinController.isInit then
		self.gachaCoinController.gameObject:SetActive(false)
	end
	if self.itemController.isInit then
		self.itemController.gameObject:SetActive(false)
	end

	self.goZenyBalance:SetActive(true)
	-- todo xde 因为统一货币，不显示zeny
	self.goZenyBalance:SetActive(false)
	self.goGachaCoinBalance:SetActive(false)

	if self.spBGBTNMonthlyVIPSelection == nil then
		self.spBGBTNMonthlyVIPSelection = self:FindGO('BG', go_selection):GetComponent(UISprite)
	end
	if self.labTitleBTNMonthlyVIPSelection == nil then
		self.labTitleBTNMonthlyVIPSelection = self:FindGO('Title', go_selection):GetComponent(UILabel)
	end
	self:ChangeSelection(self.spBGBTNMonthlyVIPSelection, self.labTitleBTNMonthlyVIPSelection)
end

function UIViewControllerZenyShop:SwitchToGachaCoin(go_selection)
	if not self.gachaCoinController.isInit then
		self.gachaCoinController:MyInit()
	end
	self.gachaCoinController.gameObject:SetActive(true)
	if self.zenyController.isInit then
		self.zenyController.gameObject:SetActive(false)
	end
	if self.monthlyVIPController.isInit then
		self.monthlyVIPController.gameObject:SetActive(false)
	end
	if self.itemController.isInit then
		self.itemController.gameObject:SetActive(false)
	end

	self.goZenyBalance:SetActive(false)
	self.goGachaCoinBalance:SetActive(true)

	if self.spBGBTNGachaCoinSelection == nil then
		self.spBGBTNGachaCoinSelection = self:FindGO('BG', go_selection):GetComponent(UISprite)
	end
	if self.labTitleBTNGachaCoinSelection == nil then
		self.labTitleBTNGachaCoinSelection = self:FindGO('Title', go_selection):GetComponent(UILabel)
	end
	self:ChangeSelection(self.spBGBTNGachaCoinSelection, self.labTitleBTNGachaCoinSelection)
end

function UIViewControllerZenyShop:SwitchToItem(go_selection)
	if not self.itemController.isInit then
		self.itemController:MyInit()
	end
	self.itemController.gameObject:SetActive(true)
	self.itemController:ReInit()
	if self.zenyController.isInit then
		self.zenyController.gameObject:SetActive(false)
	end
	if self.monthlyVIPController.isInit then
		self.monthlyVIPController.gameObject:SetActive(false)
	end
	if self.gachaCoinController.isInit then
		self.gachaCoinController.gameObject:SetActive(false)
	end

	self.goZenyBalance:SetActive(false)
	self.goGachaCoinBalance:SetActive(true)

	if self.spBGBTNLuckyBagSelection == nil then
		self.spBGBTNLuckyBagSelection = self:FindGO('BG', go_selection):GetComponent(UISprite)
	end
	if self.labTitleBTNLuckyBagSelection == nil then
		self.labTitleBTNLuckyBagSelection = self:FindGO('Title', go_selection):GetComponent(UILabel)
	end
	self:ChangeSelection(self.spBGBTNLuckyBagSelection, self.labTitleBTNLuckyBagSelection)
end

local gColorNormal = Color32(62, 89, 167, 255)
local gColorSelected = Color32(182, 113, 42, 255)
function UIViewControllerZenyShop:ChangeSelection(sp_frame, lab_title)
	sp_frame.spriteName = 'recharge_btn_1'
	if self.spBGCurrentSelection ~= nil and self.spBGCurrentSelection ~= sp_frame then
		self.spBGCurrentSelection.spriteName = 'recharge_btn_2'
	end
	self.spBGCurrentSelection = sp_frame
	lab_title.color = gColorSelected
	if self.labTitleCurrentSelection ~= nil and self.labTitleCurrentSelection ~= lab_title then
		self.labTitleCurrentSelection.color = gColorNormal
	end
	self.labTitleCurrentSelection = lab_title
end

function UIViewControllerZenyShop:ShowAnimationConfirmView()
	MsgManager.ConfirmMsgByID(201, function ()
		self:OnAnimationConfirm()
	end, function ()
		self:OnAnimationCancel()
	end)
end

function UIViewControllerZenyShop:OnAnimationConfirm()
	local purchasedShopItems = self.zenyController:GetCachedPurchaseItem()
	self:RequestStartAnimation(purchasedShopItems)
end

function UIViewControllerZenyShop:OnAnimationCancel()

end

function UIViewControllerZenyShop:RequestStartAnimation(purchaseShopItems)
	ServiceNUserProxy.Instance:CallChargePlayUserCmd(purchaseShopItems)
end

function UIViewControllerZenyShop:BGAdapt()
	if not ApplicationInfo.IsIphoneX() then
		self.texBG.leftAnchor.target = nil
		self.texBG.rightAnchor.target = nil
		self.texBG.topAnchor.target = nil
		self.texBG.bottomAnchor.target = nil
		self.texBG.width = 1288
	end
end

function UIViewControllerZenyShop:OnEnter()
	UIViewControllerZenyShop.super.OnEnter(self);
	helplog("UIViewControllerZenyShop OnEnter");
	ServiceUserEventProxy.Instance:CallQueryChargeCnt();

	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(false);
end

function UIViewControllerZenyShop:OnExit()
	UIViewControllerZenyShop.super.OnExit(self);

	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(true);
end