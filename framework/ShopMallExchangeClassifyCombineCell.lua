autoImport("ShopMallExchangeClassifyCell")

local baseCell = autoImport("BaseCell")
ShopMallExchangeClassifyCombineCell = class("ShopMallExchangeClassifyCombineCell",baseCell)

function ShopMallExchangeClassifyCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function ShopMallExchangeClassifyCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = ShopMallExchangeClassifyCell.new(go)
	end
end

function ShopMallExchangeClassifyCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function ShopMallExchangeClassifyCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function ShopMallExchangeClassifyCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function ShopMallExchangeClassifyCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end