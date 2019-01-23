autoImport("LotteryRecoverCell")

local baseCell = autoImport("BaseCell")
LotteryRecoverCombineCell = class("LotteryRecoverCombineCell",baseCell)

function LotteryRecoverCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function LotteryRecoverCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = LotteryRecoverCell.new(go)
	end
end

function LotteryRecoverCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function LotteryRecoverCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function LotteryRecoverCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function LotteryRecoverCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive( cData ~= nil )
	end
end