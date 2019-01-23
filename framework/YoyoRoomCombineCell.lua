autoImport("YoyoRoomCell")
local BaseCell = autoImport("BaseCell");
YoyoRoomCombineCell = class("YoyoRoomCombineCell", BaseCell);

function YoyoRoomCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function YoyoRoomCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("YoyoRoomCell");
		self.childrenObjs[i] = YoyoRoomCell.new(go)
	end

end

function YoyoRoomCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end


function YoyoRoomCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end


function YoyoRoomCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end


function YoyoRoomCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
	end
end

