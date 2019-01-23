autoImport("ChangeZoneCell")

local baseCell = autoImport("BaseCell")
ChangeZoneCombineCell = class("ChangeZoneCombineCell",baseCell)

function ChangeZoneCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function ChangeZoneCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = ChangeZoneCell.new(go)
	end
end

function ChangeZoneCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function ChangeZoneCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function ChangeZoneCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function ChangeZoneCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end