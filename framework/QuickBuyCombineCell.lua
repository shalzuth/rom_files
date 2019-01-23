autoImport("QuickBuyCell")

local baseCell = autoImport("BaseCell")
QuickBuyCombineCell = class("QuickBuyCombineCell",baseCell)

function QuickBuyCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function QuickBuyCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = QuickBuyCell.new(go)
	end
end

function QuickBuyCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function QuickBuyCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function QuickBuyCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function QuickBuyCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end