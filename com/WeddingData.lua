WeddingData = class("WeddingData");

function WeddingData:ctor(staticData)
	self.staticId = staticData.id;
end

function WeddingData:Server_Update(server_data)

	self.husband = server_data.husband;
	self.wife = server_data.wife;

	self.zoneid = server_data.zoneid % 10000;

	self.weddingtime = server_data.weddingtime;
	self.photoidx = server_data.photoidx;
	self.phototime = server_data.phototime;
	self.myname = server_data.myname;
	self.partnername = server_data.partnername;
	self.id = server_data.id;

	self.starttime = server_data.starttime;
	self.endtime = server_data.endtime;
end

function WeddingData:CheckInWeddingTime()
	if(self.zoneid)then
		local zoneid = MyselfProxy.Instance:GetZoneId();
		if(zoneid ~= self.zoneid)then
			return false;
		end
	end

	if(self.weddingtime)then
		local nowtime = os.date("*t", ServerTime.CurServerTime()/1000);
		local weddingtime = os.date("*t", self.starttime);

		return nowtime.year == weddingtime.year and 
				nowtime.month == weddingtime.month and 
				nowtime.day == weddingtime.day and 
				nowtime.hour == weddingtime.hour
	end
end