autoImport("CardRandomMakeCell")

local baseCell = autoImport("BaseCell")
CardRandomMakeCombineCell = class("CardRandomMakeCombineCell",baseCell)

function CardRandomMakeCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function CardRandomMakeCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = CardRandomMakeCell.new(go)
	end
end

function CardRandomMakeCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function CardRandomMakeCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function CardRandomMakeCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function CardRandomMakeCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
	end
end