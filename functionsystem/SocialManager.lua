autoImport("SocialData")

SocialManager = class("SocialManager")

SocialManager.PbRelation = {
	Friend = SessionSociality_pb.ESOCIALRELATION_FRIEND,
	Merry = SessionSociality_pb.ESOCIALRELATION_MERRY,
	Chat = SessionSociality_pb.ESOCIALRELATION_CHAT,
	Team = SessionSociality_pb.ESOCIALRELATION_TEAM,
	Apply = SessionSociality_pb.ESOCIALRELATION_APPLY,
	Black = SessionSociality_pb.ESOCIALRELATION_BLACK,
	BlackForever = SessionSociality_pb.ESOCIALRELATION_BLACK_FOREVER,
	Tutor = SessionSociality_pb.ESOCIALRELATION_TUTOR,
	TutorApply = SessionSociality_pb.ESOCIALRELATION_TUTOR_APPLY,
	Student = SessionSociality_pb.ESOCIALRELATION_STUDENT,
	StudentApply = SessionSociality_pb.ESOCIALRELATION_STUDENT_APPLY,
	StudentRecent = SessionSociality_pb.ESOCIALRELATION_STUDENT_RECENT,
	TutorClassmate = SessionSociality_pb.ESOCIALRELATION_TUTOR_CLASSMATE,
	Contract = SessionSociality_pb.ESOCIALRELATION_RECALL,
}

SocialManager.SocialRelation = {
	Friend = 1,
	Merry = 2,
	Chat = 3,
	Team = 4,
	Apply = 5,
	Black = 6,
	BlackForever = 7,
	Tutor = 8,
	TutorApply = 9,
	Student = 10,
	StudentApply = 11,
	StudentRecent = 12,
	TutorClassmate = 14,
	Contract = 15,
}

function SocialManager:ctor()
	self.dataMap = {}
	self.relationhandler = {}

	local relation = self.SocialRelation
	self.relationhandler[ relation.Friend ] = { self._FriendAdd, self._FriendRemove }
	self.relationhandler[ relation.Chat ] = { self._ChatAdd, self._ChatRemove }
	self.relationhandler[ relation.Team ] = { self._TeamAdd, self._TeamRemove }
	self.relationhandler[ relation.Apply ] = { self._ApplyAdd, self._ApplyRemove }
	self.relationhandler[ relation.Black ] = { self._BlackAdd, self._BlackRemove }
	self.relationhandler[ relation.BlackForever ] = { self._BlackForeverAdd, self._BlackForeverRemove }
	self.relationhandler[ relation.Tutor ] = { self._TutorAdd, self._TutorRemove, nil, self._preAddTutor }
	self.relationhandler[ relation.TutorApply ] = { self._TutorApplyAdd, self._TutorApplyRemove }
	self.relationhandler[ relation.Student ] = { self._StudentAdd, self._StudentRemove, nil, self._preAddStudent }
	self.relationhandler[ relation.StudentApply ] = { self._TutorApplyAdd, self._TutorApplyRemove }
	self.relationhandler[ relation.StudentRecent ] = { self._StudentRecentAdd, self._StudentRecentRemove }
	self.relationhandler[ relation.TutorClassmate ] = { self._TutorClassmateAdd, self._TutorClassmateRemove }
	self.relationhandler[ relation.Contract ] = { self._ContractAdd, self._ContractRemove, self._ContractAddResult }

	self.relationCount = 15
end

function SocialManager:Add(serverData)
	local data = SocialData.CreateAsTable(serverData)
	self.dataMap[serverData.guid] = data

	local relation = data.relation
	local relationhandler,handler

	if relation == nil then
		helplog("SocialManager Add: relation = nil")
		return
	end

	for i=1,self.relationCount do
		relationhandler = self.relationhandler[i]
		if relationhandler and BitUtil.band(relation, i) ~= 0 then
			handler = relationhandler[1]
			if handler then
				--handler add
				handler(self, data)
			end
		end
	end
end

function SocialManager:Remove(guid)
	if self.dataMap[guid] then

		local relation = self.dataMap[guid].relation
		local relationhandler,handler

		for i=1,self.relationCount do
			relationhandler = self.relationhandler[i]
			if relationhandler and BitUtil.band(relation, i) ~= 0 then
				handler = relationhandler[2]
				if handler then
					--handler remove
					handler(self, guid)
				end
			end
		end

		self.dataMap[guid]:Destroy()
		self.dataMap[guid] = nil
	end
end

function SocialManager:PreProcess(serverData)
	local socialData = self:Find(serverData.guid)
	local relationhandler,handler

		for i=1,self.relationCount do
			relationhandler = self.relationhandler[i]
			if relationhandler then
				if socialData == nil or socialData.relation ~= serverData.relation then
					handler = relationhandler[4]
					if handler then
						handler(self, serverData)
					end
				end
			end
		end
end

function SocialManager:Update(serverData)
	local socialData = self:Find(serverData.guid)

	if socialData == nil then
		self:Add(serverData)
	else
		local lastRelation = socialData.relation
		socialData:SetData(serverData)
		self:UpdateRelation(socialData, lastRelation)
	end
end

function SocialManager:UpdateData(serverData)
	local socialData = self:Find(serverData.guid)

	if socialData then
		local item
		for i=1,#serverData.items do
			item = serverData.items[i]

			if item.type == SessionSociality_pb.ESOCIALDATA_LEVEL then
				socialData.level = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_PORTRAIT then
				socialData.portrait = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_HAIR then
				socialData.hairID = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_HAIRCOLOR then
				socialData.haircolor = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_BODY then
				socialData.bodyID = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_FRAME then
				socialData.frame = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_OFFLINETIME then
				socialData.offlinetime = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_PROFESSION then
				socialData.profession = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_ADVENTURELV then
				socialData.adventureLv = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_ADVENTUREEXP then
				socialData.adventureExp = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_APPELLATION then
				socialData.appellation = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_GENDER then
				socialData.gender = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_GUILDNAME then
				socialData.guildname = item.data
			elseif item.type == SessionSociality_pb.ESOCIALDATA_GUILDPORTRAIT then
				socialData.guildportrait = item.data
			elseif item.type == SessionSociality_pb.ESOCIALDATA_MAP then
				socialData.mapid = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_BLINK then
				socialData.blink = item.value ~= 0
			elseif item.type == SessionSociality_pb.ESOCIALDATA_ZONEID then
				socialData.zoneid = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_NAME then
				socialData.name = item.data
			elseif item.type == SessionSociality_pb.ESOCIALDATA_CREATETIME then
				socialData:SetCreatetime(item.data)
			elseif item.type == SessionSociality_pb.ESOCIALDATA_HEAD then
				socialData.headID = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_FACE then
				socialData.faceID = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_MOUTH then
				socialData.mouthID = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_EYE then
				socialData.eyeID = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_TUTOR_PROFIC then
				socialData.profic = item.value
			elseif item.type == SessionSociality_pb.ESOCIALDATA_RECALL then
				socialData.recall = item.value ~= 0
			elseif item.type == SessionSociality_pb.ESOCIALDATA_CANRECALL then
				socialData.canRecall = item.value ~= 0
			elseif item.type == SessionSociality_pb.ESOCIALDATA_RELATION then
				local lastRelation = socialData.relation
				socialData.relation = item.value
				self:UpdateRelation(socialData, lastRelation)
			end
		end
	end
end

function SocialManager:UpdateRelation(socialData, lastRelation)
	local last,current,relationhandler,handler
	-- helplog("UpdateRelation",lastRelation,socialData.relation)
	for i=1,self.relationCount do
		relationhandler = self.relationhandler[i]
		if relationhandler then
			last = BitUtil.band(lastRelation, i)
			current = BitUtil.band(socialData.relation, i)

			if last ~= current then
				if last > current then
				--remove
					handler = relationhandler[2]
					if handler then
						handler(self, socialData.guid)
					end
				else
				--add
					handler = relationhandler[1]
					if handler then
						handler(self, socialData)
					end
				end
			end
		end
	end
end

function SocialManager:Sort()
	local _FriendProxy = FriendProxy.Instance

	_FriendProxy:SortFriendData()
	_FriendProxy:SortRecentTeamMember()
	_FriendProxy:SortApplyData()
	_FriendProxy:SortBlacklistData()
	_FriendProxy:SortForeverBlacklistData()

	TutorProxy.Instance:SortApply()
end

function SocialManager:RelationResult(data)
	local relation = data.relation
	local relationhandler,handler

	for i=1,self.relationCount do
		relationhandler = self.relationhandler[i]
		if relationhandler and BitUtil.band(relation, i) ~= 0 then
			handler = relationhandler[3]
			if handler then
				handler(self, data.charid, data.success)
			end
		end
	end
end

function SocialManager:Find(guid)
	return self.dataMap[guid]
end

function SocialManager:GetName(guid)
	local socialData = self:Find(guid)
	if socialData and socialData.name ~= "" then
		return socialData.name
	end

	return ""
end

function SocialManager:Clear()
	for k,v in pairs(self.dataMap) do
		v:Clear()
	end
end

function SocialManager:AddDataByChatMessage(chatId, data)
	local socialData = self:Find(chatId)

	if socialData == nil then
		socialData = SocialData.CreateAsTable()
		socialData:SetDataByChatMessageData(chatId, data)
		self.dataMap[socialData.guid] = socialData
	end

	self:_AddChatRelation(socialData)
end

function SocialManager:AddDataByPlayerTip(data)
	local socialData = self:Find(data.id)

	if socialData == nil then
		socialData = SocialData.CreateAsTable()
		socialData:SetDataByPlayerTipData(data)
		self.dataMap[socialData.guid] = socialData
	end

	self:_AddChatRelation(socialData)
end

function SocialManager:_AddChatRelation(socialData)
	local lastRelation = socialData.relation
	if not socialData:IsChat() then
		socialData:AddRelation( SessionSociality_pb.ESOCIALRELATION_CHAT )
	end	

	self:UpdateRelation(socialData, lastRelation)
end

function SocialManager:_FriendAdd(socialData)
	FriendProxy.Instance:AddFriend(socialData)
end

function SocialManager:_FriendRemove(guid)
	FriendProxy.Instance:RemoveFriend(guid)
end

function SocialManager:_ChatAdd(socialData)
	ChatRoomProxy.Instance:AddPrivateChatList(socialData)
end

function SocialManager:_ChatRemove(guid)
	ChatRoomProxy.Instance:RemovePrivateChatList(guid)
end

function SocialManager:_TeamAdd(socialData)
	FriendProxy.Instance:AddRecentTeam(socialData)
end

function SocialManager:_TeamRemove(guid)
	FriendProxy.Instance:RemoveRecentTeam(guid)
end

function SocialManager:_ApplyAdd(socialData)
	FriendProxy.Instance:AddApply(socialData)
end

function SocialManager:_ApplyRemove(guid)
	FriendProxy.Instance:RemoveApply(guid)
end

function SocialManager:_BlackAdd(socialData)
	FriendProxy.Instance:AddBlack(socialData)
end

function SocialManager:_BlackRemove(guid)
	FriendProxy.Instance:RemoveBlack(guid)
end

function SocialManager:_BlackForeverAdd(socialData)
	FriendProxy.Instance:AddForeverBlack(socialData)
end

function SocialManager:_BlackForeverRemove(guid)
	FriendProxy.Instance:RemoveForeverBlack(guid)
end

function SocialManager:_TutorAdd(socialData)
	TutorProxy.Instance:AddTutor(socialData)
end

function SocialManager:_TutorRemove(guid)
	TutorProxy.Instance:RemoveTutor(guid)
end

function SocialManager:_preAddTutor(newSocialData)
	TutorProxy.Instance:ShowTutorUpdateMsg(newSocialData)
end

function SocialManager:_TutorApplyAdd(socialData)
	TutorProxy.Instance:AddApply(socialData)
end

function SocialManager:_TutorApplyRemove(guid)
	TutorProxy.Instance:RemoveApply(guid)
end

function SocialManager:_StudentAdd(socialData)
	TutorProxy.Instance:AddStudent(socialData)
end

function SocialManager:_StudentRemove(guid)
	TutorProxy.Instance:RemoveStudent(guid)
end

function SocialManager:_preAddStudent(socialData)
	TutorProxy.Instance:ShowStudentUpdateMsg(socialData)
end

function SocialManager:_StudentRecentAdd(socialData)
	TutorProxy.Instance:AddRecentStudent(socialData)
end

function SocialManager:_StudentRecentRemove(guid)
	TutorProxy.Instance:RemoveRecentStudent(guid)
end

function SocialManager:_TutorClassmateAdd(socialData)
	TutorProxy.Instance:AddTutorClassmate(socialData)
end

function SocialManager:_TutorClassmateRemove(guid)
	TutorProxy.Instance:RemoveTutorClassmate(guid)
end

function SocialManager:_ContractAdd(socialData)
	FriendProxy.Instance:AddContract(socialData)
end

function SocialManager:_ContractRemove(guid)
	FriendProxy.Instance:RemoveContract(guid)
end

function SocialManager:_ContractAddResult(guid, success)
	FriendProxy.Instance:AddContractResult(guid, success)
end