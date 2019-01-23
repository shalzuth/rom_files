autoImport("ShopDressingView")
EyeLensesView = class("EyeLensesView",ShopDressingView)
EyeLensesView.ViewType = UIViewType.NormalLayer
autoImport("EyeLensesPage")

EyeLensesView.LongPressEvent = "EyeLensesView_LongPress"

local shoptype = ShopDressingProxy.Instance:GetShopType()
local shopID = ShopDressingProxy.Instance:GetShopId()

function EyeLensesView:FindObjs()
	self.super.FindObjs(self)
	self.toggleLab = self:FindGO("toggleLab"):GetComponent(UILabel)
	self.toggleObj = self.toggleLab.gameObject.transform.parent.gameObject
	self.headgearToggle = self:FindGO("headgearToggle"):GetComponent(UIToggle)
	self.facegearToggle = self:FindGO("facegearToggle"):GetComponent(UIToggle)
	self.HideHeadgearLabel = self:FindGO("HideHeadgearLabel"):GetComponent(UILabel)
	self.HideFacegearLabel = self:FindGO("HideFacegearLabel"):GetComponent(UILabel)
end

function EyeLensesView:InitUIView()
	self.super.InitUIView(self)
	self.EyeLensesPage = self:AddSubView("EyeLensesPage" ,EyeLensesPage);
	self.toggleLab.text = ZhString.EyeLensesView_title; 
	self.HideHeadgearLabel.text = ZhString.HairDressingView_HideHeadgear;
	self.HideFacegearLabel.text = ZhString.EyeLensesView_hideFacegear

	-- Switch icon or text for TabNameTip
	local iconActive, nameLabelActive
	if not GameConfig.SystemForbid.TabNameTip then -- 显示图标和气泡
		iconActive=true;nameLabelActive=false;
	else -- 不显示图标和气泡
		iconActive=false;nameLabelActive=true;
	end
	local icon = GameObjectUtil.Instance:DeepFindChild(self.toggleObj, "Icon")
	icon:SetActive(iconActive)
	self.toggleLab.gameObject:SetActive(nameLabelActive)
end

function EyeLensesView:AddEvts()
	self.super.AddEvts(self)
	self:AddClickEvent(self.headgearToggle.gameObject,function (g)
		self:ClickGearToggle()
	end)
	self:AddClickEvent(self.facegearToggle.gameObject,function (g)
		self:ClickGearToggle()
	end)

	-- LongPress for TabNameTip
	local toggleLongPress = self.toggleObj:GetComponent(UILongPress)
	toggleLongPress.pressEvent = function (obj, state)
		self:PassEvent(EyeLensesView.LongPressEvent, {state, obj.gameObject});
	end
	self:AddEventListener(EyeLensesView.LongPressEvent, self.HandleLongPress, self)
end

function EyeLensesView:ClickGearToggle()
	self:RefreshModel();
end

function EyeLensesView:ClickReplaceBtn()
	local queryData = ShopDressingProxy.Instance:GetQueryData()
	shoptype = ShopDressingProxy.Instance:GetShopType()
	shopID = ShopDressingProxy.Instance:GetShopId()

	if(queryData.type~=ShopDressingProxy.DressingType.EYE) then return end 
	if(not queryData.id) then  return end 
	local choosedata = ShopDressingProxy.Instance.chooseData;
	if(nil == choosedata)then
		return
	end
	if(ShopDressingProxy.Instance:bSameItem(ShopDressingProxy.DressingType.EYE))then
		MsgManager.FloatMsgTableParam(nil,ZhString.EyeLensesView_sameEyeLenses)
		return;
	end
	local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(shoptype,shopID,choosedata.id)
	if(tempcsv:CheckCanRemove())then
		MsgManager.FloatMsgTableParam(nil,ZhString.HappyShop_overtime)
		return
	end

	local eyeID = tempcsv.goodsID;
	if(not eyeID or not ShopDressingProxy.Instance:bActived(eyeID,ShopDressingProxy.DressingType.EYE))then
		local lockmsg = tempcsv:GetQuestLockDes()
		if(lockmsg)then
			MsgManager.FloatMsgTableParam(nil,lockmsg)
		end
		return
	end
	local moneyID = choosedata.ItemID;
	local itemNum = choosedata.ItemCount*choosedata.Discount*0.01;
	local curMoney=ShopDressingProxy.Instance:GetCurMoneyByID(moneyID);
	if(curMoney<itemNum)then
		MsgManager.FloatMsgTableParam(nil,ZhString.HappyShop_silverNotEnough)
		return;
	end
	ShopDressingProxy.Instance:CallReplaceDressing(queryData.id);
end

function EyeLensesView:RefreshLensesROB(constID,costCount,eyeId)
	self:Show(self.chargeNum)
	self:RefreshMoney();

	self.chargeNum.text = costCount;
	self.chargeTitle.text = ZhString.HairdressingView_cost;
	local curCount = ShopDressingProxy.Instance:GetCurMoneyByID(constID);
	if(curCount>=costCount)then
		self.chargeNum.color = ColorUtil.ButtonLabelBlue;
	else
		ColorUtil.RedLabel(self.chargeWidget)
	end
	local flag = (curCount >= costCount) and ShopDressingProxy.Instance:bActived(eyeId,ShopDressingProxy.DressingType.EYE)
	self:SetReplaceBtnState(flag)
	local itemStaticData = Table_Item[constID]
	if(itemStaticData and itemStaticData.Icon) then
		IconManager:SetItemIcon(itemStaticData.Icon,self.itemIcon)
	end
	self:Show(self.itemIcon)
end

function EyeLensesView:RecvUseDressing(note)
	local id=note.body.id;
	local usetype=note.body.type;
	if(ShopDressingProxy.DressingType.EYE == usetype) then
		ShopDressingProxy.Instance.originalEye=id;
	end
	self:RefreshModel();
end

function EyeLensesView:OnEnter()
	self.super.OnEnter(self)
	self:RefreshModel()
	local myTrans = Game.Myself.assetRole.completeTransform;
	if(myTrans)then
		local viewPort = CameraConfig.EyeLense_ViewPort
		local rotation = CameraConfig.EyeLense_Rotation
		self:CameraFaceTo(myTrans, viewPort, rotation);
	end
end

function EyeLensesView:HandleLongPress(param)
	local isPressing, go = param[1], param[2];

	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local backgroundSp = GameObjectUtil.Instance:DeepFindChild(self.toggleObj, "Background"):GetComponent(UISprite)
			TipManager.Instance:TryShowHorizontalTabNameTip(ZhString.EyeLensesView_title,
					backgroundSp, NGUIUtil.AnchorSide.Left)
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end
