autoImport("AuguryChatData")

AuguryProxy = class('AuguryProxy', pm.Proxy)
AuguryProxy.Instance = nil;
AuguryProxy.NAME = "AuguryProxy"

function AuguryProxy:ctor(proxyName, data)
	self.proxyName = proxyName or AuguryProxy.NAME
	if(AuguryProxy.Instance == nil) then
		AuguryProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function AuguryProxy:Init()
	self.chatContent = {}

	self.isInAugury = false
end

function AuguryProxy:RecvAuguryChat(data)
	local chatData = AuguryChatData.new(data)
	TableUtility.ArrayPushBack( self.chatContent , chatData )
end

function AuguryProxy:RecvAuguryTitle(data)
	self.questionId = data.titleid
	self:SetAugury(data)
end

function AuguryProxy:RemoveAuguryChat()
	table.remove( self.chatContent , 1 )
end

function AuguryProxy:GetAuguryChat()
	return self.chatContent
end

function AuguryProxy:GetQuestionId()
	return self.questionId
end

function AuguryProxy:SetInAugury(isIn)
	self.isInAugury = isIn
end

function AuguryProxy:GetInAugury()
	return self.isInAugury
end

function AuguryProxy:SetNpcId(npcId)
	self.npcId = npcId
end

function AuguryProxy:GetNpcId()
	return self.npcId
end

function AuguryProxy:SetAugury(data)
	self.auguryType = data.type
	self.subTableId = data.subtableid
end

function AuguryProxy:GetTable()
	if self.auguryType then
		local config = GameConfig.Augury.Config[self.auguryType]
		if config then
			if self.auguryType == SceneAugury_pb.EAUGURYTYPE_STAR_GUIDE and self.subTableId ~= nil then
				local table = config.tbname.."_"..self.subTableId
				return _G[table] or autoImport(table)
			end

			return config.tb
		end
	end

	return nil
end