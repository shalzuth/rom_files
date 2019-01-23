FunctionTempItem = class("FunctionTempItem")

FunctionTempItem.WarnningMin = 60 * 24;

function FunctionTempItem.Me()
	if nil == FunctionTempItem.me then
		FunctionTempItem.me = FunctionTempItem.new()
	end
	return FunctionTempItem.me
end

function FunctionTempItem:ctor()
	self.tempItemCount = 0;
	self.tempItemMap = {};
end

function FunctionTempItem:CheckItemInDelCD(itemguid)
	if(itemguid ~= nil)then
		return self.tempItemMap[itemguid] ~= nil;
	end
	return false;
end

function FunctionTempItem:AddTempItemDelCheck(itemguid, delTime)
	if(not self.tempItemMap[itemguid])then
		self.tempItemCount = self.tempItemCount + 1;
	end
	self.tempItemMap[itemguid] = delTime;

	self:CheckTempItemDelTime();
end

function FunctionTempItem:RemoveTempItemDelCheck(itemguid)
	if(self.tempItemMap[itemguid])then
		self.tempItemCount = self.tempItemCount - 1;
	end
	self.tempItemMap[itemguid] = nil;

	self:CheckTempItemDelTime();
end

function FunctionTempItem:CheckTempItemDelTime()
	if(self.tempItemCount > 0)then
		if(not self.timeTick)then
			self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTempItemDelTime, self, 1)
		end
	else
		if(self.timeTick)then
			TimeTickManager.Me():ClearTick(self, 1)
			self.timeTick = nil;
		end
	end
end

function FunctionTempItem:RefreshTempItemDelTime()
	local curServerTime = ServerTime.CurServerTime()/1000;

	for itemguid, delTime in pairs(self.tempItemMap)do
		local leftTotalSec = delTime - curServerTime;
		if(leftTotalSec <= 0)then
			self:RemoveTempItemDelCheck(itemguid);
		else
			if(leftTotalSec <= FunctionTempItem.WarnningMin * 60)then
				local itemData = BagProxy.Instance:GetItemByGuid(itemguid, BagProxy.BagType.Temp);
				if(itemData and not itemData:GetDelWarningState())then
					itemData:SetDelWarningState(true);
					GameFacade.Instance:sendNotification(TempItemEvent.TempWarnning, itemguid);
				end
			end
		end
	end
end





