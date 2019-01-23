SocialData = reusableClass("SocialData")
SocialData.PoolSize = 50

function SocialData:SetData(data)
	if data then
		self.guid = data.guid
		self.accid = data.accid
		self.level = data.level
		self.portrait = data.portrait
		self.hairID = data.hair
		self.haircolor = data.haircolor
		self.bodyID = data.body
		self.headID = data.head
		self.faceID = data.face
		self.mouthID = data.mouth
		self.eyeID = data.eye
		self.frame = data.frame
		self.offlinetime = data.offlinetime or 0
		self.relation = data.relation
		self.profession = data.profession
		self.gender = data.gender
		self.name = data.name
		self.guildname = data.guildname
		self.guildportrait = data.guildportrait
		self.adventureLv = data.adventurelv
		self.adventureExp = data.adventureexp
		self.appellation = data.appellation
		self.mapid = data.mapid
		self.blink = data.blink or false
		self.zoneid = data.zoneid
		self:SetCreatetime(data.createtime)
		self.profic = data.profic
		self.recall = data.recall	--是否被召回
		self.canRecall = data.canrecall	--是否可召回（是否是双向好友）

		self:SetChatData(data)
	end
end

function SocialData:SetCreatetime(createtime)
	if createtime then
		self.createtime = createtime
		self.createtimeList = string.split(createtime , ":")

		for i=1,#self.createtimeList do
			self.createtimeList[i] = tonumber(self.createtimeList[i])
		end
	end
end

function SocialData:GetCreatetime(relation)
	if relation and self.createtimeList then
		return self.createtimeList[relation] or 0
	end

	return 0
end

function SocialData:AddRelation(relation)
	if self.relation and relation then
		self.relation = self.relation + relation
	end
end

function SocialData:GetUIId()
	local limitNum = math.floor( math.pow(10, 12) )
	return math.floor(self.guid % limitNum)
end

function SocialData:IsOnline()
	return self.offlinetime == 0
end

function SocialData:IsChat()
	return BitUtil.band(self.relation, SocialManager.SocialRelation.Chat) ~= 0
end

function SocialData:IsForeverBlack()
	return BitUtil.band(self.relation, SocialManager.SocialRelation.BlackForever) ~= 0
end

function SocialData:IsTutorApply()
	return BitUtil.band(self.relation, SocialManager.SocialRelation.TutorApply) ~= 0
end

function SocialData:CheckCanRecall()
	if not FriendProxy.Instance:CheckRecallActivity() then
		return false
	end

	if self.level < GameConfig.Recall.BaseLv then
		return false
	end

	local offlinetime = self.offlinetime
	if offlinetime == 0 then
		return false
	end

	if not self.canRecall then
		return false
	end

	local sec = ServerTime.CurServerTime()/1000 - offlinetime
	if sec < GameConfig.Recall.OfflineTime then
		return false
	end

	return true
end

--chat
function SocialData:SetChatData(data)
	if data.guid then
		self.id = data.guid
	end
	if data.id then
		self.id = data.id	--聊天框id
	end
	if data.unreadCount then
		self.unreadCount = data.unreadCount	--未读数量
	end
end

function SocialData:SetDataByChatMessageData(chatId,data)
	self.guid = chatId
	self.id = chatId
	self.name = data:GetName()
	self.hairID = data:GetHair()
	self.haircolor = data:GetHaircolor()
	self.bodyID = data:GetBody()
	self.headID = data:GetHead()
	self.faceID = data:GetFace()
	self.mouthID = data:GetMouth()
	self.eyeID = data:GetEye()
	self.profession = data:GetProfession()
	self.gender = data:GetGender()
	self.guildname = data:GetGuildname()
	self.rolejob = data:GetProfession()	--用于聊天室
	self.level = data:GetLevel()
	self.appellation = data:GetAppellation()
	self.blink = data:GetBlink()
	self.portrait = data:GetPortrait()
	self.relation = 0
	self.offlinetime = 0
end

function SocialData:SetDataByPlayerTipData(data)
	self.guid = data.id
	self.id = data.id
	self.name = data.name or ""
	local iconData = data.headData.iconData
	self.portrait = iconData.icon or 0
	self.hairID = iconData.hairID or 0
	self.haircolor = iconData.haircolor or 0
	self.bodyID = iconData.bodyID or 0
	self.gender = iconData.gender or 0
	self.guildname = data.guildname or ""
	self.level = data.level or 0
	self.appellation = data.appellation or 0
	self.blink = iconData.blink or false
	self.relation = 0
	self.offlinetime = 0
end

function SocialData:ResetUnreadCount()
	self.unreadCount = 0
end

function SocialData:AddUnreadCount()
	if self.unreadCount == nil then
		self.unreadCount = 0
	end
	self.unreadCount = self.unreadCount + 1
end

function SocialData:SetUnreadCount(count)
	self.unreadCount = count
end

function SocialData:Clear()
	self.accid = nil
	self.level = nil
	self.portrait = nil
	self.hairID = nil
	self.haircolor = nil
	self.bodyID = nil
	self.headID = nil
	self.faceID = nil
	self.mouthID = nil
	self.eyeID = nil
	self.frame = nil
	self.offlinetime = nil
	self.profession = nil
	self.gender = nil
	self.name = nil
	self.guildname = nil
	self.guildportrait = nil
	self.adventureLv = nil
	self.adventureExp = nil
	self.appellation = nil
	self.mapid = nil
	self.blink = nil
	self.zoneid = nil
	self.createtime = nil
	self.createtimeList = nil
	self.profic = nil
	--chat
	self.id = nil
	self.rolejob = nil
end

-- override begin
function SocialData:DoConstruct(asArray, serverData)
	SocialData.super.DoConstruct(self,asArray,serverData)
	self:SetData(serverData)
end

function SocialData:DoDeconstruct(asArray)
	SocialData.super.DoDeconstruct(self,asArray)

	self.guid = nil
	self.relation = nil
	self.unreadCount = nil
	self:Clear()
end
-- override end