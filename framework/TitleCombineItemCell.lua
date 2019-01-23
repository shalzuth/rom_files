autoImport("TitleCell");
local BaseCell = autoImport("BaseCell");
TitleCombineItemCell = class("TitleCombineItemCell",BaseCell);


function TitleCombineItemCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function TitleCombineItemCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("TitleCell");
		self.childrenObjs[i] = TitleCell.new(go)
	end

end

function TitleCombineItemCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end


function TitleCombineItemCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end


function TitleCombineItemCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end


function TitleCombineItemCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
	end
end
