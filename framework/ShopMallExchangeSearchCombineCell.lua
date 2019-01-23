autoImport("ShopMallExchangeSearchCell")

local baseCell = autoImport("BaseCell")
ShopMallExchangeSearchCombineCell = class("ShopMallExchangeSearchCombineCell",baseCell)

function ShopMallExchangeSearchCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function ShopMallExchangeSearchCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = ShopMallExchangeSearchCell.new(go)
	end
end

function ShopMallExchangeSearchCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function ShopMallExchangeSearchCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function ShopMallExchangeSearchCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function ShopMallExchangeSearchCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end