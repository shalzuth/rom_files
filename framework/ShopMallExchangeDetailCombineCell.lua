autoImport("ShopMallExchangeDetailCell")

local baseCell = autoImport("BaseCell")
ShopMallExchangeDetailCombineCell = class("ShopMallExchangeDetailCombineCell",baseCell)

function ShopMallExchangeDetailCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function ShopMallExchangeDetailCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = ShopMallExchangeDetailCell.new(go)
	end
end

function ShopMallExchangeDetailCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function ShopMallExchangeDetailCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function ShopMallExchangeDetailCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function ShopMallExchangeDetailCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end

function ShopMallExchangeDetailCombineCell:OnDestroy()
	for i = 1,#self.childrenObjs do
		local cell = self.childrenObjs[i]
		cell:OnDestroy()
	end	
end