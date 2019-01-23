autoImport("LotteryDetailCell")

local baseCell = autoImport("BaseCell")
LotteryDetailCombineCell = class("LotteryDetailCombineCell",baseCell)

function LotteryDetailCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function LotteryDetailCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = LotteryDetailCell.new(go)
	end
end

function LotteryDetailCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function LotteryDetailCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function LotteryDetailCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function LotteryDetailCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end