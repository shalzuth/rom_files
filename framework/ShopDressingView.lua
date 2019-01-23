ShopDressingView = class("ShopDressingView",ContainerView)
ShopDressingView.ViewType = UIViewType.NormalLayer

local UI_FLITER = GameConfig.DressingFilter or {11,12};

function ShopDressingView:Init()
	self:FindObjs();
	self:InitUIView();
	self:AddEvts();
end

function ShopDressingView:FindObjs()
	self.chargeTitle = self:FindGO("chargeTitle"):GetComponent(UILabel)
	self.chargeNum = self:FindGO("chargeNum"):GetComponent(UILabel)
	self.chargeWidget = self:FindGO("chargeNum"):GetComponent(UIWidget)
	self.itemIcon = self:FindGO("itemIcon"):GetComponent(UISprite)
	self.earningLabel = self:FindGO("earningLabel"):GetComponent(UILabel)
	self.replaceBtnLabel = self:FindGO("replaceBtnLabel"):GetComponent(UILabel)
	self.replaceBtn = self:FindGO("replaceBtn")
	self.replaceBtnSprite = self.replaceBtn:GetComponent(UISprite)
	self.touchZone = self:FindGO("touchZone")
end

function ShopDressingView:InitUIView()
	self.replaceBtnLabelColor = self.replaceBtnLabel.effectColor
	self.replaceBtnLabel.text = ZhString.HairDressingView_Replace; 
	self.chargeTitle.text = ZhString.HairdressingView_cost;
end

function ShopDressingView:AddEvts()
	self:AddClickEvent(self.replaceBtn,function (g)
		self:ClickReplaceBtn()
	end)
	self:AddListenEvt(MyselfEvent.MyDataChange,self.RefreshMoney)
	self:AddListenEvt(ServiceEvent.NUserUseDressing,self.RecvUseDressing)
	self:AddDragEvent(self.touchZone,function ( obj,delta )
		local fakeRole = ShopDressingProxy.Instance:GetFakeRole()
		if(fakeRole)then
			fakeRole:RotateDelta(-delta.x)
		end
	end)
end

function ShopDressingView:TabChangeHandler(key)
	ShopDressingView.super.TabChangeHandler(self, key);
end

function ShopDressingView:DisableState()
	self:Hide(self.itemIcon)
	self:Hide(self.chargeNum)
	self:SetReplaceBtnState(false)
end

function ShopDressingView:RefreshMoney()
	local rob = MyselfProxy.Instance:GetROB();
	self.earningLabel.text = StringUtil.NumThousandFormat(rob)
end

function ShopDressingView:ClickReplaceBtn()
end

function ShopDressingView:SetReplaceBtnState(onoff)
	if onoff then
		self:SetTextureWhite(self.replaceBtnSprite.gameObject)
		self.replaceBtnLabel.effectColor = self.replaceBtnLabelColor
	else
		self:SetTextureGrey(self.replaceBtnSprite.gameObject)
		self.replaceBtnLabel.effectColor = ColorUtil.NGUIGray
	end
end

function ShopDressingView:RefreshModel()
	local args = ReusableTable.CreateArray()
	local shoptype = ShopDressingProxy.Instance:GetShopType()
	local shopID = ShopDressingProxy.Instance:GetShopId()
	local queryData = ShopDressingProxy.Instance:GetQueryData()
	if(queryData and queryData.id)then
		local csv = ShopProxy.Instance:GetShopItemDataByTypeId(shoptype,shopID,queryData.id)
		if(queryData.type==ShopDressingProxy.DressingType.HAIR)then
			args[1] = ShopDressingProxy.Instance:GetHairStyleIDByItemID(csv.goodsID)
			args[2] = ShopDressingProxy.Instance.originalHairColor
			args[3] = ShopDressingProxy.Instance.originalEye
			args[6] = ShopDressingProxy.Instance.originalBodyColor
			args[7] = ShopDressingProxy.Instance.originalBody
		elseif(queryData.type==ShopDressingProxy.DressingType.HAIRCOLOR) then
			args[1] = ShopDressingProxy.Instance.originalHair
			args[2] = csv.hairColorID
			args[3] = ShopDressingProxy.Instance.originalEye
			args[6] = ShopDressingProxy.Instance.originalBodyColor
			args[7] = ShopDressingProxy.Instance.originalBody
		elseif(queryData.type==ShopDressingProxy.DressingType.EYE)then
			args[1] = ShopDressingProxy.Instance.originalHair
			args[2] = ShopDressingProxy.Instance.originalHairColor
			args[3] = csv.goodsID
			args[6] = ShopDressingProxy.Instance.originalBodyColor
			args[7] = ShopDressingProxy.Instance.originalBody
		elseif(queryData.type == ShopDressingProxy.DressingType.ClothColor)then
			args[1] = ShopDressingProxy.Instance.originalHair
			args[2] = ShopDressingProxy.Instance.originalHairColor
			args[3] = ShopDressingProxy.Instance.originalEye
			args[6] = Table_Couture[csv.clothColorID].ClothColor
			args[7] = ShopDressingProxy.Instance:getBodyID()
		end
	else
		args[1] = ShopDressingProxy.Instance.originalHair
		args[2] = ShopDressingProxy.Instance.originalHairColor
		args[3] = ShopDressingProxy.Instance.originalEye
		args[6] = ShopDressingProxy.Instance.originalBodyColor
		args[7] = ShopDressingProxy.Instance.originalBody
	end
	args[8] = ShopDressingProxy.Instance.originalHead
	args[9] = ShopDressingProxy.Instance.originalFace
	args[4]= nil==self.headgearToggle and true or self.headgearToggle.value
	args[5] = nil==self.facegearToggle and true or self.facegearToggle.value
	ShopDressingProxy.Instance:FakeDressingPreview(args)
	ReusableTable.DestroyAndClearArray(args)
end


function ShopDressingView:RecvUseDressing(note)
end

function ShopDressingView:OnEnter()
	FunctionSceneFilter.Me():StartFilter(UI_FLITER);
	self:RefreshMoney();
	self:SetReplaceBtnState(false);
	ShopDressingProxy.Instance:RedressModel(true);
	ShopDressingView.super.OnEnter(self);
end

function ShopDressingView:OnExit()
	FunctionSceneFilter.Me():EndFilter(UI_FLITER);
	ShopDressingProxy.Instance:RedressModel(false);
	ShopDressingProxy.Instance:Clear();
	ShopDressingView.super.OnExit(self);
	self:CameraReset();
end



