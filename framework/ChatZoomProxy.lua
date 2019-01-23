autoImport("ChatZoneData")
autoImport("ChatZoneMemberData")
autoImport("ChatZoneSummaryData")

ChatZoomProxy = class("ChatZoomProxy", pm.Proxy)
ChatZoomProxy.Instance = nil
ChatZoomProxy.NAME = "ChatZoomProxy"

function ChatZoomProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ChatRoomProxy.NAME
	if (ChatZoomProxy.Instance == nil) then
		ChatZoomProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function ChatZoomProxy:Init()
	self.messageQueue = {}
	self.messageCount = 200
	self.currentHost = 0
end

function ChatZoomProxy:InQueueInputMessage(data)
	if data:GetId() == self:CachedZoomInfo().ownerid then
		data:SetChannelName(ZhString.Chat_owner)
	else
		data:SetChannelName(ZhString.Chat_visitor)
	end
	table.insert(self.messageQueue, data)
	local length = #self.messageQueue
	if (length > self.messageCount) then
		self.messageQueue[length]:Destroy()
		table.remove(self.messageQueue, 1)
	end
end

function ChatZoomProxy:OutQueueHeadMessage()
	
end

function ChatZoomProxy:ClearMessageQueue()
	self.messageQueue = {}
end

function ChatZoomProxy:ClearZoomInfo()
	if(self.zoomInfo) then
		self.zoomInfo:Destroy()
		self.zoomInfo = nil
	end
end

function ChatZoomProxy:InQueueTipMessage(data)
	table.insert(self.messageQueue, data)
	local length = #self.messageQueue
	if (length > self.messageCount) then
		table.remove(self.messageQueue, 1)
	end
end

function ChatZoomProxy:Message()
	-- local reverseTable = {}
	-- for i = #self.messageQueue, 1, -1 do
	-- 	table.insert(reverseTable, self.messageQueue[i])
	-- end
	-- return reverseTable
	return self.messageQueue
end

function ChatZoomProxy:CacheZoomInfo(data)
	if(self.zoomInfo==nil) then
		self.zoomInfo = ChatZoneSummaryData.CreateAsTable(data)
	else
		self.zoomInfo:Update(data)
	end
end

function ChatZoomProxy:CachedZoomInfo()
	return self.zoomInfo
end

function ChatZoomProxy:GetMembers()
	return self.zoomInfo.members
end

function ChatZoomProxy:UpdateMembers(members)
	if (members == nil or #members <= 0) then
		return
	end
	local cachedMembers = self.zoomInfo.members
	for i = 1, #members do
		local member = members[i]
		local isCached = false
		for j = 1, #cachedMembers do
			local cachedMember = cachedMembers[j]
			if (cachedMember.id == member.id) then
				isCached = true
				if (member.job == SceneChatRoom_pb.ECHATROOM_OWNER) then
					self.zoomInfo.ownerid = member.id

					local data = cachedMembers[j]

					table.remove(cachedMembers, j)

					data:SetData(member)
					data:SetOwner(member.id)
					table.insert(cachedMembers, 1, data)
				else
					cachedMembers[j]:SetData(member)
					cachedMembers[j]:SetOwner(nil)
				end
			end
		end
		if (isCached == false) then
			local data = ChatZoneMemberData.CreateAsTable(member)
			data:SetOwner(self.zoomInfo.ownerid)
			table.insert(cachedMembers, data)
		end
	end
end

function ChatZoomProxy:DeleteMembers(members)
	if (members == nil or #members <= 0) then
		return
	end
	local cachedMembers = self.zoomInfo.members
	for i = 1, #members do
		local member = members[i]
		local isCached = false
		for j = #cachedMembers,1,-1  do
			local cachedMember = cachedMembers[j]
			if (cachedMember.id == member) then
				isCached = true
				cachedMembers[j]:Destroy()
				table.remove(cachedMembers, j)
			end
		end
	end
end

function ChatZoomProxy:CacheCurrentHost(host)
	self.currentHost = host
end

function ChatZoomProxy:CachedCurrentHost()
	return self.currentHost
end

function ChatZoomProxy:SelfID()
	return Game.Myself.data.id
end

function ChatZoomProxy:SelfIsHost()
	return self:SelfID() == self:CachedZoomInfo().ownerid
end

function ChatZoomProxy:SomeoneIsInZoom(id)
	local zoomInfo = self:CachedZoomInfo()
	if (zoomInfo == nil) then
		return false
	end
	local members = zoomInfo.members
	for k, v in ipairs(members) do
		if (v.id == id) then
			return true
		end
	end
	return false
end

function ChatZoomProxy:IsInChatZone()
	return self:CachedZoomInfo() ~= nil
end