autoImport("PresetTextCell")
local baseCell = autoImport("BaseCell")
PresetTextCombineCell = class("PresetTextCombineCell",baseCell)

function PresetTextCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function PresetTextCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = PresetTextCell.new(go)
	end
end

function PresetTextCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function PresetTextCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function PresetTextCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function PresetTextCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
	end
end