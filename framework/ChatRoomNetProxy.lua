ChatRoomNetProxy = class('ChatRoomNetProxy', pm.Proxy)
ChatRoomNetProxy.Instance = nil;
ChatRoomNetProxy.NAME = "ChatRoomNetProxy"

ChatRoomNet = {}
ChatRoomNet.Id1 = 99
ChatRoomNet.ChatUserCmdId2 = 1
ChatRoomNet.QueryVoiceUserCmdId2 = 2

function ChatRoomNetProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ChatRoomNetProxy.NAME
	if(ChatRoomNetProxy.Instance == nil) then
		ChatRoomNetProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
	self:AddEvts()
end

function ChatRoomNetProxy:Init()
	-- body
end

function ChatRoomNetProxy:AddEvts()
	-- NetProtocol.AddListener(ChatRoomNet.Id1, ChatRoomNet.QueryVoiceUserCmdId2, function (id1,id2,dataBytes)
	-- 	local data = self:RecvQueryVoiceUserCmd(dataBytes)
	-- 	ChatRoomProxy.Instance:RecvChatSpeech(data)
	-- 	self:Notify(ServiceEvent.NUserQueryVoiceUserCmd, data)
	-- end)
end

function ChatRoomNetProxy:CallChatUserCmd(channel, str, desID, voice, voicetime)
	if desID == nil then
		desID = 0
	end
	if voicetime == nil then
		voicetime = 0
	end

	local byteStream = ByteStream()
	byteStream:WriteNetwork_16(channel)
	byteStream:WriteNetwork_string(str)
	byteStream:WriteNetwork_64(desID)
	if voice then
		byteStream:WriteNetwork_array_8(voice)
	else
		byteStream:WriteNetwork_32(0)
	end
	byteStream:WriteNetwork_32(voicetime)

	local bytes = byteStream.data
	local bytesLen = byteStream.dataLen
	stack("byteStream.data : "..bytesLen)

	NetManager.GameSend(ChatRoomNet.Id1, ChatRoomNet.ChatUserCmdId2, bytes, 0, bytesLen)
end

function ChatRoomNetProxy:RecvQueryVoiceUserCmd(dataBytes)
	local byteStream = ByteStream(dataBytes)

	local data = {}
	data.voiceid = byteStream:ReadNetwork_32()
	data.voice = byteStream:ReadNetwork_array_8()

	return data
end