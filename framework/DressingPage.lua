DressingPage = class("DressingPage", SubView)

function DressingPage:Init()
	self:FindObjs()
	self:AddEvent()
	self:InitPageView()
end

function DressingPage:AddEvent()
	self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.UpdateShop);
end

function DressingPage:UpdateShop()
	ShopDressingProxy.Instance:ResetData()
	self:InitPageView()
end

function DressingPage:FindObjs()
	self.desc = self:FindGO("desc"):GetComponent(UILabel)
	self.menuDes = self:FindGO("menuDes"):GetComponent(UILabel)
	self.itemRoot = self:FindGO("Wrap")
	
	--todo xde
	self.menuDes.overflowMethod = 3;
	self.menuDes.width = 320
end

function DressingPage:InitPageView()
end

function DressingPage:SetDes(data)
	if(data.des and data.des~="") then
		self:Show(self.desc);
		self.desc.text = data.des;
	else
		self:Hide(self.desc);
	end
end

function DressingPage:SetMenuDes(data,type)
	local bUnlock = true;
	if(type==ShopDressingProxy.DressingType.ClothColor)then
		bUnlock = ShopDressingProxy.Instance:CheckCanOpen(data.MenuID)
	else
		local id = type==ShopDressingProxy.DressingType.EYE and data.goodsID or ShopDressingProxy.Instance:GetHairStyleIDByItemID(data.goodsID)
		bUnlock = ShopDressingProxy.Instance:bActived(id,type);
	end
	if(bUnlock==false) then
		self:Show(self.menuDes);
		self.menuDes.text = data:GetMenuDes();
		
		--todo xde
		self.menuDesBg = self:FindGO("menuDesBg"):GetComponent(UISprite)
		self.menuDesBg.topAnchor.target =  self.menuDes.gameObject.transform
		self.menuDesBg.topAnchor.relative = 1
		self.menuDesBg.topAnchor.absolute = 10

		self.menuDesBg.bottomAnchor.target =  self.menuDes.gameObject.transform
		self.menuDesBg.bottomAnchor.relative = 0
		self.menuDesBg.bottomAnchor.absolute = -8
	else
		self:Hide(self.menuDes);
	end
end

function DressingPage:OnEnter()
	DressingPage.super.OnEnter(self);
	self:UpdateShop()
end

function DressingPage:OnExit()
	DressingPage.super.OnExit(self);
end




