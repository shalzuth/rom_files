ChatZoneSummaryData = reusableClass("ChatZoneSummaryData")
ChatZoneSummaryData.PoolSize = 10

function ChatZoneSummaryData:ctor()
	self.members = {}
end

function ChatZoneSummaryData:Update(data)
	if data then
		self.ownerid = data.ownerid
		self.roomid = data.roomid
		self.name = data.name
		self.roomtype = data.roomtype
		self.maxnum = data.maxnum
		self.curnum = data.curnum
		self.pswd = data.pswd

		if data.members then
			self:ClearMembers()
			for i=1,#data.members do
				local chatdata = ChatZoneMemberData.CreateAsTable(data.members[i])
				chatdata:SetOwner(data.ownerid)
				table.insert(self.members,chatdata)		
			end
		end
	end
end

function ChatZoneSummaryData:ClearMembers()
	for i = #self.members, 1, -1  do
		self.members[i]:Destroy()
		self.members[i] = nil
	end
end

function ChatZoneSummaryData:DoConstruct(asArray, serverData)
	self.ownerid = serverData.ownerid
	self.roomid = serverData.roomid
	self.name = serverData.name
	self.roomtype = serverData.roomtype
	self.maxnum = serverData.maxnum
	self.curnum = serverData.curnum
	self.pswd = serverData.pswd

	if(#self.members~=0) then
		self:ClearMembers()
	end
	if serverData.members then
		self:ClearMembers()
		for i=1,#serverData.members do
			local chatdata = ChatZoneMemberData.CreateAsTable(serverData.members[i])
			chatdata:SetOwner(serverData.ownerid)
			table.insert(self.members,chatdata)		
		end
	end
end

function ChatZoneSummaryData:DoDeconstruct(asArray)
	self:ClearMembers()
end