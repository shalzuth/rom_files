autoImport("ChangeHeadCell")

local baseCell = autoImport("BaseCell")
ChangeHeadCombineCell = class("ChangeHeadCombineCell",baseCell)

function ChangeHeadCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function ChangeHeadCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = ChangeHeadCell.new(go)
	end
end

function ChangeHeadCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function ChangeHeadCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function ChangeHeadCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function ChangeHeadCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell.gameObject:SetActive( cData ~= nil )
		cell:SetData(cData)
	end
end