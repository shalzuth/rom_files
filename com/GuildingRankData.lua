GuildingRankData = class("GuildingRankData")

function GuildingRankData:ctor()
end

function GuildingRankData:Server_SetData(serverdata)
	local myGuildData = GuildProxy.Instance.myGuildData
	if(myGuildData)then
		local memberData = myGuildData:GetMemberByGuid(serverdata.charid)
		if(memberData)then
			self.name = memberData.name
			self.gender = memberData.gender
		end
	end
	self.submitCountTotal = serverdata.submitcounttotal
	self.submitTime = serverdata.submittime
end




