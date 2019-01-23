ChatZoneData = class("ChatZoneData")

function ChatZoneData:ctor(data)
	self:SetData(data)	
end

function ChatZoneData:SetData(data)
	if data then
		self.tip = data.tip
		self.userid = data.userid
		self.name = data.name

		local content
		if self.tip == SceneChatRoom_pb.ECHATROOMTIP_JOIN then
			content = ZhString.Chat_join
		elseif self.tip == SceneChatRoom_pb.ECHATROOMTIP_EXIT then
			content = ZhString.Chat_exit
		elseif self.tip == SceneChatRoom_pb.ECHATROOMTIP_KICK then
			content = ZhString.Chat_kick
		elseif self.tip == SceneChatRoom_pb.ECHATROOMTIP_OWNERCHANGE then
			content = ZhString.Chat_ownerchange
		end
		self.str = self.name..content
		self.cellType = ChatTypeEnum.SystemMessage
	end
end

function ChatZoneData:GetStr()
	return self.str
end

function ChatZoneData:GetCellType()
	return self.cellType
end

function ChatZoneData:GetChannel()
	return ChatChannelEnum.Zone
end