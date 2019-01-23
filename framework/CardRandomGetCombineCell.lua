autoImport("CardRandomGetCell")

local baseCell = autoImport("BaseCell")
CardRandomGetCombineCell = class("CardRandomGetCombineCell",baseCell)

function CardRandomGetCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function CardRandomGetCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = CardRandomGetCell.new(go)
	end
end

function CardRandomGetCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function CardRandomGetCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function CardRandomGetCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function CardRandomGetCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end