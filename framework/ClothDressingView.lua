autoImport("ShopDressingView")
ClothDressingView = class("ClothDressingView",ShopDressingView)
ClothDressingView.ViewType = UIViewType.NormalLayer
autoImport("ClothDressingPage")

local shoptype = ShopDressingProxy.Instance:GetShopType()
local shopID = ShopDressingProxy.Instance:GetShopId()

function ClothDressingView:FindObjs()
	self.super.FindObjs(self)
	self.toggleLab = self:FindGO("toggleLab"):GetComponent(UILabel)
end

function ClothDressingView:InitUIView()
	self.super.InitUIView(self)
	self.ClothDressingPage = self:AddSubView("ClothDressingPage" ,ClothDressingPage);
	self.toggleLab.text = ZhString.ClothDressingView_title; 
end

function ClothDressingView:ClickReplaceBtn()
	local queryData = ShopDressingProxy.Instance:GetQueryData()
	shoptype = ShopDressingProxy.Instance:GetShopType()
	shopID = ShopDressingProxy.Instance:GetShopId()

	if(queryData.type~=ShopDressingProxy.DressingType.ClothColor) then return end 
	if(not queryData.id) then  
		return
	end 
	local choosedata = ShopDressingProxy.Instance.chooseData;
	if(nil == choosedata)then
		return
	end
	if(ShopDressingProxy.Instance:bSameItem(ShopDressingProxy.DressingType.ClothColor))then
		MsgManager.FloatMsgTableParam(nil,ZhString.ClothDressingView_same)
		return;
	end
	local tempcsv = ShopProxy.Instance:GetShopItemDataByTypeId(shoptype,shopID,choosedata.id)
	if(tempcsv:CheckCanRemove())then
		MsgManager.FloatMsgTableParam(nil,ZhString.HappyShop_overtime)
		return
	end

	if(not ShopDressingProxy.Instance:CheckCanOpen(tempcsv.MenuID))then
		local lockmsg = tempcsv:GetQuestLockDes()
		if(lockmsg)then
			MsgManager.FloatMsgTableParam(nil,lockmsg)
		end
		return
	end
	local moneyID = choosedata.ItemID;
	local itemNum = choosedata.ItemCount*choosedata.Discount*0.01;
	if(moneyID==GameConfig.MoneyId.Zeny)then
		local curMoney=ShopDressingProxy.Instance:GetCurMoneyByID(moneyID);
		if(curMoney<itemNum)then
			MsgManager.FloatMsgTableParam(nil,ZhString.HappyShop_silverNotEnough)
			return;
		end
	else
		if(BagProxy.Instance:GetItemNumByStaticID(moneyID) < itemNum)then
			local tName = Table_Item[moneyID] and Table_Item[moneyID].NameZh or ""
			MsgManager.ShowMsgByIDTable(25418,tName)
			return 
		end
	end
	ShopDressingProxy.Instance:CallReplaceDressing(queryData.id);
end

local strFormat = "%sx%s"
function ClothDressingView:RefreshROB(constID,costCount,menuid)
	self:Show(self.chargeNum)
	self:RefreshMoney();
	local itemStaticData = Table_Item[constID]
	local iconName = itemStaticData.NameZh or ""
	self.chargeNum.text = constID==GameConfig.MoneyId.Zeny and costCount or string.format(strFormat,iconName,costCount)

	local curCount = constID ==GameConfig.MoneyId.Zeny and  ShopDressingProxy.Instance:GetCurMoneyByID(constID) or BagProxy.Instance:GetItemNumByStaticID(constID)
	if(curCount>=costCount)then
		self.chargeNum.color = ColorUtil.ButtonLabelBlue;
	else
		ColorUtil.RedLabel(self.chargeWidget)
	end
	local flag = (curCount >= costCount) and ShopDressingProxy.Instance:CheckCanOpen(menuid)
	self:SetReplaceBtnState(flag)
	
	if(itemStaticData and itemStaticData.Icon) then
		IconManager:SetItemIcon(itemStaticData.Icon,self.itemIcon)
	end
	self:Show(self.itemIcon)
end

function ClothDressingView:RecvUseDressing(note)
	local id=note.body.id;
	local usetype=note.body.type;
	if(ShopDressingProxy.DressingType.ClothColor == usetype) then
		ShopDressingProxy.Instance.originalBodyColor=id;
	end
	self:RefreshModel();
end

function ClothDressingView:OnEnter()
	self.super.OnEnter(self)
	local myTrans = Game.Myself.assetRole.completeTransform;
	if(myTrans)then
		local viewPort = CameraConfig.ClothDressing_ViewPort
		local rotation = CameraConfig.ClothDressing_Rotation
		self:CameraFaceTo(myTrans, viewPort, rotation);
	end
end



