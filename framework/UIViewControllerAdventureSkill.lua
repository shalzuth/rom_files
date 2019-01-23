autoImport("UIModelAdventureSkill")
autoImport("UIListItemViewControllerAdventureSkill")
autoImport("AdventureSkillTip")
autoImport('UIViewAdventureSkillDetail')
autoImport('FuncAdventureSkill')

local UIViewControllerAdventureSkill = class("UIViewControllerAdventureSkill", BaseView)
UIViewControllerAdventureSkill.ViewType = UIViewType.NormalLayer

function UIViewControllerAdventureSkill:Init()
	self:RequestQueryShopItem(FuncAdventureSkill.iShopType, FuncAdventureSkill.Instance().iSerialNumber)

	self:GetGameObjects()
	self:RegisterButtonClickEvent()
	self:GetModelSet()
	self:LoadView()
	self:Tutorial()
	self:ListenServerResponse()
	self:ListenEvent()
end

function UIViewControllerAdventureSkill:OnEnter()
	UIViewControllerAdventureSkill.super.OnEnter(self);
	self:FocusOnNPC()
end

function UIViewControllerAdventureSkill:OnExit()
	UIViewControllerAdventureSkill.super.OnExit(self);
	self:CancelFocusOnNPC()
end

function UIViewControllerAdventureSkill:GetGameObjects()
	if self.getGameObjectsComplete == true then return end
	self.bg = self:FindGO("Bottom"):GetComponent(UISprite)
	self.goSkillsList = self:FindGO("SkillsList")
	self.goSkillPoint = self:FindGO("AdventureSkillPoint", self.goSkillsList)
	self.goSkillPointValue = self:FindGO("Value", goSkillPoint)
	self.labSkillPointValue = self.goSkillPointValue:GetComponent(UILabel)
	self.goSkillsListRoot = self:FindGO("Root", self.goSkillsList)
	self.uiGridSkillsList = self.goSkillsListRoot:GetComponent(UIGrid)
	self.goButtonClose = self:FindGO("ButtonClose")
	self.uiGridList = UIGridListCtrl.new(self.uiGridSkillsList, UIListItemViewControllerAdventureSkill, "UIListItemAdventureSkill")
	self.uiGridList:AddEventListener(MouseEvent.MouseClick,self.ShowTipHandler,self)
	self.goCurrency = self:FindGO("Currency")
	self.goCurrencyValue = self:FindGO("Lab", self.goCurrency)
	self.labCurrencyValue = self.goCurrencyValue:GetComponent(UILabel)
	self.getGameObjectsComplete = true
end

function UIViewControllerAdventureSkill:GetModelSet()
	print('UIViewControllerAdventureSkill:GetModelSet')
	self.skillPoint = AdventureDataProxy.Instance:getSkillPoint()
	self.skillPoint = self.skillPoint or 0
	self.skillShopItemsData = UIModelAdventureSkill.Instance():GetSkillShopItemsDataHaveNotLearn_PreSkillBeLearned()
	-- UIModelAdventureSkill.Instance():SortFromUnlockToLock(self.skillShopItemsData)
	UIModelAdventureSkill.Instance():SortBaseFieldShopOrder(self.skillShopItemsData)
end

function UIViewControllerAdventureSkill:LoadView()
	self.labSkillPointValue.text = tostring(self.skillPoint)
	self:LoadScrollView()
	self.labCurrencyValue.text = tostring(MyselfProxy.Instance:GetROB())
	-- todo xde 显示数字中的逗号
	self.labCurrencyValue.text = FuncZenyShop.FormatMilComma(MyselfProxy.Instance:GetROB())
end

function UIViewControllerAdventureSkill:LoadScrollView()
	self.uiGridList:ResetDatas(self.skillShopItemsData)
	self.listItemsViewController = self.uiGridList:GetCells()
end

function UIViewControllerAdventureSkill:ListenServerResponse()
	self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.OnReceiveLearnSkill)
	self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnReceiveQueryShopConfigCmd)
end

function UIViewControllerAdventureSkill:ListenEvent()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.OnReceiveEventMyDataChange)
end

function UIViewControllerAdventureSkill:OnReceiveLearnSkill(data)
	if data == nil then return end
	local learnedNewlySkillShopItems = {}
	table.insert(learnedNewlySkillShopItems, data.body.id)
	for i = 1, #learnedNewlySkillShopItems do
		local skillShopItemID = learnedNewlySkillShopItems[i]
		UIModelAdventureSkill.Instance():RemoveFromTabSkillShopItemsHaveNotLearn(skillShopItemID)
	end
	self:GetModelSet()
	self:LoadView()
	self:CloseDetail()
end

function UIViewControllerAdventureSkill:RegisterButtonClickEvent(go)
	self:AddClickEvent(self.goButtonClose, function (go)
		self:OnButtonCloseClick()
	end)
end

function UIViewControllerAdventureSkill:OnButtonCloseClick(go)
	self:Close()
	
end

function UIViewControllerAdventureSkill:ShowTipHandler(cell)
	TipsView.Me():ShowStickTip(
		UIViewAdventureSkillDetail,
		{
			skillConf = cell.skillConf,
			skillShopItemData = cell.skillShopItemData,
			isReachEnoughAdventureLevelForLearn = cell:IsReachEnoughAdventureLevelForLearn()
		},
		NGUIUtil.AnchorSide.Left,
		self.bg,
		{2,0},
		"UIViewAdventureSkillDetail"
	)
	-- local tip = TipsView.Me().currentTip
	-- if(tip) then
	-- 	tip:SetCheckClick(self:TipClickCheck())
	-- end
end

-- function UIViewControllerAdventureSkill:TipClickCheck()
-- 	if(self.tipCheck == nil) then
-- 		self.tipCheck = function ()
-- 			local click = UICamera.selectedObject
-- 			if(click) then
-- 				local cells = self.uiGridList:GetCells()
-- 				if(self:CheckIsClickCell(cells,click)) then
-- 					return true
-- 				end
-- 			end
-- 			return false
-- 		end
-- 	end
-- 	return self.tipCheck
-- end

-- function UIViewControllerAdventureSkill:CheckIsClickCell(cells,clickedObj)
-- 	for i=1,#cells do
-- 		if(cells[i]:IsClickMe(clickedObj)) then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end

function UIViewControllerAdventureSkill:Tutorial()
	if self.listItemsViewController ~= nil and #self.listItemsViewController > 0 then
		local firstItemViewController = self.listItemsViewController[1]
		self:AddOrRemoveGuideId(firstItemViewController.gameObject)
		self:AddOrRemoveGuideId(firstItemViewController.gameObject, 36);
	end
	self:AddOrRemoveGuideId(self.goButtonClose)
	self:AddOrRemoveGuideId(self.goButtonClose, 39);
end

function UIViewControllerAdventureSkill:CloseDetail()
	TipsView.Me():HideCurrent()
end

function UIViewControllerAdventureSkill:Close()
	UIViewControllerAdventureSkill.super.CloseSelf(self)
	self:CloseDetail()
end

function UIViewControllerAdventureSkill:FocusOnNPC()
	local npcCreature = FuncAdventureSkill.Instance():GetNPCCreature()
	if npcCreature ~= nil then
		local viewPort = CameraConfig.HappyShop_ViewPort
		local rotation = CameraConfig.HappyShop_Rotation

		local transNPC = npcCreature.assetRole.completeTransform;
		self:CameraFaceTo(transNPC,viewPort,rotation)
	end
end

function UIViewControllerAdventureSkill:CancelFocusOnNPC()
	self:CameraReset()
end

function UIViewControllerAdventureSkill:OnReceiveEventMyDataChange(data)
	self:LoadView()
end

function UIViewControllerAdventureSkill:OnReceiveQueryShopConfigCmd(message)
	local idOfSkillShopItems = {}
	local shopDatas = ShopProxy.Instance:GetConfigByType(FuncAdventureSkill.iShopType)
	for k, v in pairs(shopDatas) do
		local shopID = k
		local shopData = v
		local shopItemDatas = shopData:GetGoods()
		for k, v in pairs(shopItemDatas) do
			local itemID = k
			local shopItemData = v
			if shopID == FuncAdventureSkill.Instance().iSerialNumber then
				local skillID = shopItemData.SkillID
				if skillID and skillID > 0 then
					if not FuncAdventureSkill.Instance():SkillIsHaveLearned(skillID) then
						table.insert(idOfSkillShopItems, shopItemData.id)
					end
				end
			end
		end
	end
	UIModelAdventureSkill.Instance():ClearTabSkillShopItemsHaveNotLearn()
	UIModelAdventureSkill.Instance():PadTabSkillShopItemsHaveNotLearn(idOfSkillShopItems)
	self:GetModelSet()
	self:LoadView()
end

function UIViewControllerAdventureSkill:RequestQueryShopItem(type, shop_id)
	ShopProxy.Instance:CallQueryShopConfig(type, shop_id)
end

return UIViewControllerAdventureSkill