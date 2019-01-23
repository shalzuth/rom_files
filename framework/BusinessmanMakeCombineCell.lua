autoImport("BusinessmanMakeCell")

local baseCell = autoImport("BaseCell")
BusinessmanMakeCombineCell = class("BusinessmanMakeCombineCell",baseCell)

function BusinessmanMakeCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function BusinessmanMakeCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = BusinessmanMakeCell.new(go)
	end
end

function BusinessmanMakeCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function BusinessmanMakeCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function BusinessmanMakeCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function BusinessmanMakeCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end