FunctionDonateItem = class("FunctionDonateItem")

FunctionDonateItem.IntervalTime = 600000;

local curServerTime = nil;

function FunctionDonateItem.Me()
	if nil == FunctionDonateItem.me then
		FunctionDonateItem.me = FunctionDonateItem.new()
	end
	return FunctionDonateItem.me
end

function FunctionDonateItem:ctor()
	self.detailInfoMap = {};

	curServerTime = ServerTime.CurServerTime;

end

function FunctionDonateItem:SetDetailInfo(configid, con, asset)
	local cacheInfo = self.detailInfoMap[ configid ];

	if(cacheInfo == nil)then
		cacheInfo = {};
		cacheInfo.reqTime = curServerTime();

		self.detailInfoMap[configid] = cacheInfo;
	end

	if(cacheInfo.con == nil)then
		cacheInfo.con = {};
	else
		TableUtility.ArrayClear(cacheInfo.con);
	end
	for i=1,#con do
		local citem = {};
		citem[1] = con[i].id;
		citem[2] = con[i].num;
		table.insert(cacheInfo.con, citem);
	end

	if(cacheInfo.asset == nil)then
		cacheInfo.asset = {};
	else
		TableUtility.ArrayClear(cacheInfo.asset);
	end
	for i=1,#asset do
		local citem = {};
		citem[1] = asset[i].id;
		citem[2] = asset[i].num;
		table.insert(cacheInfo.asset, citem);
	end
end

function FunctionDonateItem:GetDetailInfo(configid)
	if(configid == nil)then
		return;
	end

	local cacheInfo = self.detailInfoMap[ configid ];
	if(cacheInfo == nil)then
		-- TODO call Server
		cacheInfo = {};
		cacheInfo.reqTime = curServerTime();

		ServiceGuildCmdProxy.Instance:CallApplyRewardConGuildCmd(configid) 
	else
		local reqTime = cacheInfo.reqTime;
		if(curServerTime() - reqTime >= self.IntervalTime)then
			cacheInfo.reqTime = curServerTime();
			-- TODO call Server
			ServiceGuildCmdProxy.Instance:CallApplyRewardConGuildCmd(configid) 
		end
		return cacheInfo;
	end
end

