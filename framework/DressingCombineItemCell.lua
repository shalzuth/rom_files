local baseCell = autoImport("BaseCell")
DressingCombineItemCell = class("DressingCombineItemCell",baseCell)

function DressingCombineItemCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function DressingCombineItemCell:FindObjs()
end

function DressingCombineItemCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function DressingCombineItemCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function DressingCombineItemCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function DressingCombineItemCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
	end
end