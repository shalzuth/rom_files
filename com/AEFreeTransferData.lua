AEFreeTransferData = class("AEFreeTransferData")

function AEFreeTransferData:ctor(data)
	self.mapids = {}
	self.teammapids = {}

	self:SetData(data)
end

function AEFreeTransferData:SetData(data)
	if data ~= nil then
		self.allfree = data.allfree
		self.teamallfree = data.teamallfree
		TableUtility.TableClear(self.mapids)
		for i=1,#data.mapids do
			local id = data.mapids[i]
			self.mapids[id] = id
			redlog("set mapid",id)
		end

		for i=1,#data.teammapids do
			local id = data.teammapids[i]
			self.teammapids[id] = id
		end

		self.storefree = data.storefree;
	end
end

--设置活动开始和结束时间
function AEFreeTransferData:SetTime(data)
	self.beginTime = data.begintime
	self.endTime = data.endtime
end

function AEFreeTransferData:IsExist(mapid,Ftype)
	if Ftype == UIMapMapList.E_TransmitType.Team then
		return self.teammapids[mapid] ~= nil
	end
	if Ftype == UIMapMapList.E_TransmitType.Single then
		return self.mapids[mapid] ~= nil
	end
end

--判断是否在活动时间内
function AEFreeTransferData:IsInActivity()
	if self.beginTime ~= nil and self.endTime ~= nil then
		local server = ServerTime.CurServerTime()/1000
		return server >= self.beginTime and server <= self.endTime
	else
		return false
	end
end

function AEFreeTransferData:IsFreeTransferMap(mapid,Ftype)
	if self:IsInActivity() then
		if Ftype == UIMapMapList.E_TransmitType.Team and self.teamallfree then
			return true
		end
		if Ftype == UIMapMapList.E_TransmitType.Single and self.allfree then
			return true
		end
		return self:IsExist(mapid,Ftype)
	end
	return false
end

function AEFreeTransferData:IsStorageFree()
	if self:IsInActivity() then
			return self.storefree
	end		
end