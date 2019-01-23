
YoyoRoomData = class("YoyoRoomData");

function YoyoRoomData:ctor(guid)
	self.yoyoRoomData = {};
end

function YoyoRoomData:SetData(room_lists)
	-- helplog("room_lists count : "..tostring(#room_lists))
	for i=1,#room_lists do
		local roomData={}
		roomData.roomId=room_lists[i].roomid
		roomData.roomName=room_lists[i].name
		roomData.raidid=room_lists[i].raidid
		roomData.playerNum=room_lists[i].player_num
		table.insert(self.yoyoRoomData,roomData);
	end
end

function YoyoRoomData:GetyoyoRoomData()
	return self.yoyoRoomData;
end

