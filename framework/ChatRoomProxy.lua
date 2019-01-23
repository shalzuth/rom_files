-- errorLog
autoImport("SocialData")
autoImport("ChatMessageData")
autoImport("PresetMsgData")
autoImport("PermissionUtil")

ChatRoomProxy = class('ChatRoomProxy', pm.Proxy)
ChatRoomProxy.Instance = nil;
ChatRoomProxy.NAME = "ChatRoomProxy"

ChatChannelEnum = {
	All = GameConfig.ChatRoom.MainView[1],
	Current = ChatCmd_pb.ECHAT_CHANNEL_ROUND,
	Team = ChatCmd_pb.ECHAT_CHANNEL_TEAM,
	Guild = ChatCmd_pb.ECHAT_CHANNEL_GUILD,
	Private = ChatCmd_pb.ECHAT_CHANNEL_FRIEND,
	World = ChatCmd_pb.ECHAT_CHANNEL_WORLD,
	System = ChatCmd_pb.ECHAT_CHANNEL_SYS,
	Zone = ChatCmd_pb.ECHAT_CHANNEL_ROOM,
	Chat = ChatCmd_pb.ECHAT_CHANNEL_CHAT,
}

ChatTypeEnum = {
	MySelfMessage = "MySelfMessage", 
	SomeoneMessage = "SomeoneMessage", 
	SystemMessage = "SystemMessage"
}

ChatRoleEnum = {
	Pet = 1,
	Npc = 2,
}

BarrageStateEnum = {
	Off = 0,
	On = 1
}

ChatRoomProxy.ItemCodeString = "{il="
ChatRoomProxy.ItemCode = "({il=(.-)})"
ChatRoomProxy.ItemNormal = "({(.-)})"
ChatRoomProxy.ItemCodeSymbol = ";"
ChatRoomProxy.ItemNormalLabel = "{%s}"
ChatRoomProxy.ItemBBCodeLabel = "[c][1F74BF]{[url=%s][u]%s[/u][/url]}[-][/c]"
ChatRoomProxy.TutorCodeString = "{ft="
ChatRoomProxy.TutorCode = "({ft=(.-)})"
ChatRoomProxy.TreasureCodeString = "{ts="
ChatRoomProxy.TreasureCode = "({ts=(.-)})"

function ChatRoomProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ChatRoomProxy.NAME
	if(ChatRoomProxy.Instance == nil) then
		ChatRoomProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
	self:AddEvts()
end

function ChatRoomProxy:Init()
	self.channelNames={ZhString.Chat_current,ZhString.Chat_team,ZhString.Chat_guild,ZhString.Chat_friend,ZhString.Chat_world
							,ZhString.Chat_map,ZhString.Chat_system}
	self.channelColor={"[A2D9FF]","[1ED2F8]","[3FB953]","[F43DFF]","[E59118]","[D8000D]","[FCDD4F]"}
	self.speechMaxNums = 50
	self.presetTextMaxNums=50
	self.chatContents={[ChatChannelEnum.Current]={},[ChatChannelEnum.Team]={},[ChatChannelEnum.Guild]={},
							[ChatChannelEnum.Private]={},[ChatChannelEnum.World]={},
								[ChatChannelEnum.System]={},}
	self.scrollScreenMaxNums=20
	self.scrollScreenContents={}
	self.privateChatList = {}
	self.privateChatContent = {}
	self.textEmojiData={}
	self.presetTextData={}
	self.itemDataList = {}
	self.autoSpeech = {}
	self.privateChatSpeech = {}
	self.barrageState = {[ChatChannelEnum.Team]=BarrageStateEnum.On , [ChatChannelEnum.Guild]=BarrageStateEnum.On, [ChatChannelEnum.Chat]=BarrageStateEnum.On}
	self.barrageContent = {}
	self.itemInfo = {}
	self.isEditorPresetText=false
	self.isInitialize=false
	self.curChatId = 0
	self.curPrivateChatId = 0	--用于记录当前选中的私聊框
	self:ResetAutoSpeechChannel()

	self.localTable = {}
	self.localData = {}
end

function ChatRoomProxy:AddEvts()
	local eventManager = EventManager.Me()
	eventManager:AddEventListener(AppStateEvent.Quit, self.SaveChat , self)
	eventManager:AddEventListener(AppStateEvent.BackToLogo, self.SaveChat , self)
	eventManager:AddEventListener(AppStateEvent.Pause, self.SaveChatContent , self)
	eventManager:AddEventListener(AppStateEvent.Focus, self.SaveChatContent , self)
end

--接收聊天信息
function ChatRoomProxy:RecvChatMessage(data)
	local chat = ChatMessageData.CreateAsArray(data)

	local channel = chat:GetChannel()

	self:HandleItemCode(chat)
	self:HandleSpeech(chat,channel)

	self:UpdateChatContents(chat,channel)
	self:UpdatePrivateChatContents(chat,channel)
	self:UpdateScrollScreenContents(chat,channel)
	self:UpdateKeywordContents(chat,channel)
	self:UpdateBarrageContents(chat,channel)

	return chat
end

--处理点击道具
function ChatRoomProxy:HandleItemCode(data)
	local str = data:GetStr()
	if data and str then
		str = self:TryParseItemCodeToNormal(str, true)
		str = self:TryParseTutorCodeToNormal(str)
		str = self:TryParseTreasureCodeToNormal(str)
		data:SetStr(str)
	end
end

--处理语音
function ChatRoomProxy:HandleSpeech(data,channel)
	local voiceid = data:GetVoiceid()
	if data and channel and voiceid and voiceid ~= 0 then
		--处理自动播放语音
		if self:IsAutoSpeech(channel) and #self.autoSpeech <= self.speechMaxNums then
			table.insert(self.autoSpeech,voiceid)

			if #self.autoSpeech == 1 and FunctionChatSpeech.Me():GetAudioController() ~= nil and (not FunctionChatSpeech.Me():GetAudioController():IsPlaying()) then
				self:CallFirstSpeech()
			end
		end
		--记录私聊语音id
		if channel == ChatChannelEnum.Private then
			if #self.privateChatSpeech >= GameConfig.ChatRoom.PrivateVoice then
				table.remove(self.privateChatSpeech , 1)
			end
			table.insert(self.privateChatSpeech,voiceid)
		end
	end
end

function ChatRoomProxy:UpdateChatContents(data,channel)
	local temp = self.chatContents[channel]
	if temp then
		if #temp >= GameConfig.ChatRoom.ChatMaxCount[channel] then
			ReusableObject.Destroy(temp[1])
			table.remove(temp,1)
		end
		table.insert(temp,data)
	end
end

function ChatRoomProxy:UpdatePrivateChatContents(data,channel)
	if channel == ChatChannelEnum.Private then

		local chatId = data:GetChatId()
		local cellType = data:GetCellType()

		--添加名字列表
		if self.privateChatList[chatId] == nil then
			Game.SocialManager:AddDataByChatMessage(chatId, data)

			local tempArray = ReusableTable.CreateArray()
			tempArray[1] = chatId
			ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
			ReusableTable.DestroyArray(tempArray)
		end
		self:AddUnreadCount(chatId)

		--添加聊天内容
		if self.privateChatContent[chatId] == nil then
			self.privateChatContent[chatId] = {}
		end
		if self:IsLoadedLocalFile(chatId) then
			table.insert(self.privateChatContent[chatId] ,data)
		end

		self:ShowRedTip(data)
	
		if cellType and cellType == ChatTypeEnum.SystemMessage then
			return
		end
		FunctionChatIO.Me():AddSaveCache(chatId,data)
	end
end

function ChatRoomProxy:UpdateScrollScreenContents(data,channel)
	local cellType = data:GetCellType()
	if cellType and cellType == ChatTypeEnum.SystemMessage 
		and channel ~= ChatChannelEnum.System then
		return
	end

	if(self.chatContents[channel])then
		if(#self.scrollScreenContents>=self.scrollScreenMaxNums)then
			table.remove(self.scrollScreenContents,1)
		end
		table.insert(self.scrollScreenContents ,data)
	end
end

function ChatRoomProxy:UpdateKeywordContents(data,channel)
	local cellType = data:GetCellType()
	if cellType and cellType == ChatTypeEnum.SystemMessage then
		return
	end

	local index = self:IsKeyword(data:GetStr(),channel)
	if index ~= -1 then
		self:AddKeywordEffect(index,data)
	end
end

function ChatRoomProxy:UpdateBarrageContents(data,channel)
	local cellType = data:GetCellType()
	if cellType and cellType == ChatTypeEnum.SystemMessage then
		return
	end

	local state = self:GetBarrageState(channel)
	if state == BarrageStateEnum.On then
		table.insert(self.barrageContent , data)
		ChatRoomProxy.GetChatBarrageViewInstance():AddBarrage()
	end
end

function ChatRoomProxy.GetChatBarrageViewInstance()
	if ChatRoomProxy.ChatBarrageViewInstance == nil then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ChatBarrageView})
	end
	return ChatRoomProxy.ChatBarrageViewInstance
end

function ChatRoomProxy:LoadDataByPlayerTip(data)
	if data.id and data.id ~= 0 and self.privateChatList[data.id] == nil then
		Game.SocialManager:AddDataByPlayerTip(data)
	end
end

-- 读取本地聊天记录
function ChatRoomProxy:LoadLocalDataById(chatId)
	if not self:IsLoadedLocalFile(chatId) then
		FunctionChatIO.Me():SaveChatContent()

		local datas = FunctionChatIO.Me():ReadChatContentById(chatId)
		if datas and #datas > 0 then
			if self.privateChatContent[chatId] == nil then
				self.privateChatContent[chatId] = {}
			end

			for i=1,#datas do
				TableUtility.TableClear(self.localData)
				self.localData.chatId = chatId
				self.localData.str = datas[i].str
				self.localData.id = datas[i].id
				self.localData.time = datas[i].time
				self.localData.voiceid = datas[i].audioId
				self.localData.voicetime = datas[i].audioLength
				self.localData.channel = ChatChannelEnum.Private

				if #self.privateChatContent[chatId] >= GameConfig.ChatRoom.ChatMaxCount[ChatChannelEnum.Private] then
					ReusableObject.Destroy(self.privateChatContent[chatId][1])
					table.remove(self.privateChatContent[chatId] , 1)
				end
				
				table.insert(self.privateChatContent[chatId], ChatMessageData.CreateAsArray(self.localData) )
			end
		end
	end
end

function ChatRoomProxy:SaveChat()
	FunctionChatIO.Me():SaveChatContent()
	FunctionChatIO.Me():SaveChatList(self.privateChatList)
end

-- 保存聊天记录到本地
function ChatRoomProxy:SaveChatContent(note)
	if note.data then
		FunctionChatIO.Me():SaveChatContent()
	end
end

function ChatRoomProxy:GetScrollScreenContents()
	return self.scrollScreenContents
end

function ChatRoomProxy:GetMessagesByChannel(channel)
	if(channel)then
		return self.chatContents[channel]
	end
	return nil
end

function ChatRoomProxy:GetPrivateMessagesByGuid(chatId)
	if chatId then
		if self.privateChatContent[chatId] == nil then
			self.privateChatContent[chatId] = {}
		end
		return self.privateChatContent[chatId]
	end
	return nil
end

function ChatRoomProxy:InitTextEmoji()
	for k,v in pairs(Table_ChatEmoji) do
		if v.Type == 1 then
			table.insert( self.textEmojiData , v.id )
		end
	end
	table.sort(self.textEmojiData,function(l,r)
		return l < r
	end)
end

function ChatRoomProxy:InitPresetText()
	for k,v in pairs(Table_ChatEmoji) do
		if v.Type == 2 then
			table.insert( self.presetTextData , PresetMsgData.new(v.Emoji) )
		end
	end
end

function ChatRoomProxy:RecvPresetMsgCmd(data)
	if self.isInitialize then
		return
	end

	self:InitTextEmoji()
	if #data.msgs > 0 then
		for i=1,#data.msgs do
			table.insert( self.presetTextData , PresetMsgData.new(data.msgs[i]) )
		end
	else
		self:InitPresetText()
	end
	self.isInitialize=true
end

function ChatRoomProxy:AddPrivateChatList(socialData)
	local id = socialData.guid
	self.privateChatList[id] = socialData

	local localChatList = FunctionChatIO.Me():ReadChatListById(id)
	if localChatList then
		socialData:SetUnreadCount(localChatList.unreadCount)
	end	
end

function ChatRoomProxy:RemovePrivateChatList(guid)
	self.privateChatList[guid] = nil
end

function ChatRoomProxy:RemovePrivateChat(index)
	local list = self:GetPrivateChatList(true)

	if index > 0 and index <= #list then
		ServiceSessionSocialityProxy.Instance:CallRemoveRelation(list[index].id, SocialManager.PbRelation.Chat)
		self.privateChatList[list[index].id] = nil
	end
end

function ChatRoomProxy:GetPrivateChatList(isSort)
	ServiceSessionSocialityProxy.Instance:CallQuerySocialData()

	TableUtility.TableClear(self.localTable)
	for k,v in pairs(self.privateChatList) do
		if v ~= nil then
			table.insert(self.localTable, v)
		end
	end
	if isSort then
		local relation = SocialManager.SocialRelation.Chat
		table.sort(self.localTable,function(l,r)
			return l:GetCreatetime(relation) > r:GetCreatetime(relation)
		end)
	end
	return self.localTable
end

function ChatRoomProxy:AddUnreadCount(chatId)
	if self.privateChatList[chatId] then
		self.privateChatList[chatId]:AddUnreadCount()
	else
		print("ChatRoomProxy AddUnreadCount : AddUnreadCount can not find "..chatId)
	end
end

function ChatRoomProxy:ResetUnreadCount(chatId)
	if chatId == nil or chatId == 0 then
		return
	end
	if self.privateChatList[chatId] then
		self.privateChatList[chatId]:ResetUnreadCount()
	else
		print("ResetUnreadCount can not find "..chatId)
	end
end

function ChatRoomProxy:IsClearUnreadCount()
	local count = 0
	for k,v in pairs(self.privateChatList) do
		if v.unreadCount then
			count = count + v.unreadCount

			if count ~= 0 then
				return false
			end
		end
	end

	return true
end

function ChatRoomProxy:IsLoadedLocalFile(chatId)
	if FunctionChatIO.Me().isLoadedContent[chatId] then
		return FunctionChatIO.Me().isLoadedContent[chatId]
	end
	return false
end

function ChatRoomProxy:CanPrivateTalk()
	return #self:GetPrivateChatList() > 0
end

function ChatRoomProxy:AddSystemMessage(channelId,content,params,removeTime)

	local tryParse, isError
	if params then
		tryParse, isError = MsgParserProxy.Instance:TryParse(content,unpack(params))
	end
	if EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name and isError then
		return
	end

	TableUtility.TableClear(self.localTable)

	self.localTable.channel = channelId
	self.localTable.str = tryParse or content
	self.localTable.str = MsgParserProxy.Instance:ReplaceIconInfo(self.localTable.str)
	self.localTable.cellType = ChatTypeEnum.SystemMessage
	self.localTable.removeTime = removeTime

	local chat = self:RecvChatMessage(self.localTable)
	GameFacade.Instance:sendNotification(ChatRoomEvent.SystemMessage , chat)
end

function ChatRoomProxy:SetCurrentPrivateChatId(id)
	self.curPrivateChatId = id
end

function ChatRoomProxy:GetCurrentPrivateChatId()
	return self.curPrivateChatId
end

function ChatRoomProxy:SetCurrentChatChannel(channel)
	self.curChatChannel = channel
end

function ChatRoomProxy:GetChatRoomChannel()
	if self.curChatChannel == nil or self.curChatChannel == ChatChannelEnum.All then
		self.curChatChannel = ChatChannelEnum.System
	end
	return self.curChatChannel
end

function ChatRoomProxy:GetScrollScreenChannel()
	if self.curChatChannel == nil or not self:IsScrollScreenChannel(self.curChatChannel) then
		self.curChatChannel = ChatChannelEnum.All
	end

	return self.curChatChannel
end

function ChatRoomProxy:IsScrollScreenChannel(channel)
	for i=1,#GameConfig.ChatRoom.MainView do
		if channel == GameConfig.ChatRoom.MainView[i] then
			return true
		end
	end
	return false
end

function ChatRoomProxy:IsKeyword(word,channel)
	for k,v in pairs(Table_KeywordAnimation) do
		if v.Keyword then
			if string.find(word , v.Keyword) then
				if v.Type then
					local channelType = string.split(v.Type , ",")
					for i=1,#channelType do
						if tonumber(channelType[i]) == channel then
							return k
						end
					end	
				else
					errorLog("ChatRoomProxy IsKeyword : Type = nil")
				end
			end
		else
			errorLog("ChatRoomProxy IsKeyword : Keyword = nil")
		end
	end

	return -1
end

function ChatRoomProxy:AddKeywordEffect(index,message)
	local data = Table_KeywordAnimation[index]
	if data then
		GameFacade.Instance:sendNotification(ChatRoomEvent.KeywordEffect , { data = data , message = message } )
	else
		errorLog(string.format("ChatRoomProxy AddKeywordEffect : Table_KeywordAnimation[%s] is nil",tostring(index)))
	end
end

--包括装备和背包
function ChatRoomProxy:GetChatItemInfo()

	TableUtility.TableClear(self.itemInfo)
	
	local items = BagProxy.Instance.roleEquip:GetItems()
	for _, item in pairs(items) do
		table.insert(self.itemInfo , item)
	end
	local bag = BagProxy.Instance.bagData:GetItems()
	for i=1,#bag do
		table.insert(self.itemInfo , bag[i])
	end

	return self.itemInfo
end

local concatTable = {}
--将itemdata数据转换成固定格式{il=itemGuid;itemId}
function ChatRoomProxy:TryParseItemData(itemData)

	if itemData == nil then
		return ""
	end

	local result = "{il=%s}"
	local default = "0"
	local content = ""
	local temp = ""
	TableUtility.ArrayClear(concatTable)

	--记录item guid
	if itemData.id then
		temp = tostring(itemData.id)
	else
		temp = default
	end
	concatTable[1] = temp

	--记录item id
	if itemData.staticData and itemData.staticData.id then
		temp = tostring(itemData.staticData.id)
	else
		temp = default
	end
	concatTable[2] = ChatRoomProxy.ItemCodeSymbol..temp
	content = table.concat(concatTable)

	return string.format(result,content)
end

--将item data 转换成[itemName]样式
function ChatRoomProxy:TryParseItemDataToNormal(itemData)
	if itemData then
		if itemData.staticData and itemData.staticData.NameZh then
			return string.format(ChatRoomProxy.ItemNormalLabel,itemData.staticData.NameZh)
		end
	end

	return nil
end

--将content中的item code转换成[itemName]，isBBCode决定是否有下划线，超链接样式
function ChatRoomProxy:TryParseItemCodeToNormal(content,isBBCode)

	if content == nil or type(content) == "table" then
		return content
	end

	if string.find(content , ChatRoomProxy.ItemCodeString) == nil then
		return content
	end
	
	TableUtility.TableClear(self.localTable)
	for str,code in string.gmatch(content, ChatRoomProxy.ItemCode) do
		local data = {}
		data.str = str
		data.code = code
		table.insert(self.localTable , data)
	end

	local result = ChatRoomProxy.ItemNormalLabel
	if isBBCode then
		result = ChatRoomProxy.ItemBBCodeLabel
	end

	for i=1,#self.localTable do
		local str = self.localTable[i].str
		local code = self.localTable[i].code
		local split = string.split(content , str)

		if #split > 1 then
			local codeSplit = string.split(code,ChatRoomProxy.ItemCodeSymbol)
			
			if #codeSplit == 2 then
				local itemData = Table_Item[tonumber(codeSplit[2])]
				local temp = nil
				
				if itemData then			
					if isBBCode then
						temp = string.format(result,code,itemData.NameZh)
					else
						temp = string.format(result,itemData.NameZh)
					end
				end
				
				if temp then
					TableUtility.ArrayClear(concatTable)
					concatTable[1] = split[1]
					for i=2,#split do
						concatTable[i] = temp..split[i]
					end
					content = table.concat(concatTable)
				end
			end
		end
	end

	return content
end

--将content中的[XXX]转换成item data
function ChatRoomProxy:TryParseItemCodeToItemData(content)

	if content == nil then
		return nil
	end

	--检查用户输入 "{il=" 转成 "{ il="，用于防止用户主动输入item code
	content = string.gsub(content,"{il=","{ il=")

	for str,name in string.gmatch(content, ChatRoomProxy.ItemNormal) do
		local data = self:GetItemData(name)

		--若data == nil则［xxx］被修改过
		if data ~= nil then
			local code = self:TryParseItemData(data)
			local split = string.split(content,str)
			if #split > 1 then
				TableUtility.ArrayClear(concatTable)
				concatTable[1] = split[1]
				for i=2,#split do
					if i == 2 then
						concatTable[i] = code..split[i]
					else
						concatTable[i] = str..split[i]
					end
				end
				content = table.concat(concatTable)
			end
		end
	end

	return content
end

function ChatRoomProxy:GetItemData(name)
	local index = 0
	local itemData = nil

	for i=1,#self.itemDataList do
		local data = self.itemDataList[i]
		if data.staticData and data.staticData.NameZh then
			if name == data.staticData.NameZh then
				itemData = data
				index = i
				break
			end
		end
	end

	if index ~= 0 then
		table.remove(self.itemDataList,index)
	end

	return itemData
end

function ChatRoomProxy:AddItemData(data)
	table.insert(self.itemDataList,data)
end

function ChatRoomProxy:GetItemDataList()
	return self.itemDataList
end

function ChatRoomProxy:ResetItemDataList()
	TableUtility.TableClear(self.itemDataList)
end

--初始化自动播放语音的频道
function ChatRoomProxy:ResetAutoSpeechChannel()
	self.autoSpeechChannel = {}

	local setting = FunctionPerformanceSetting.Me():GetSetting()
	for k,v in pairs(setting.autoPlayChatChannel) do
		table.insert(self.autoSpeechChannel , tonumber(v))
	end
end

--判断是否是自动播放语音的频道
function ChatRoomProxy:IsAutoSpeech(channel)
	for i=1,#self.autoSpeechChannel do
		if channel == self.autoSpeechChannel[i] then
			return true
		end
	end
	return false
end

function ChatRoomProxy:AutoSpeechFinish()
	if #self.autoSpeech > 0 then
		table.remove(self.autoSpeech , 1)
	end
	LogUtility.Info("AutoSpeechFinish")
	self:CallFirstSpeech()
end

function ChatRoomProxy:CallFirstSpeech()
	if #self.autoSpeech > 0 then
		ServiceChatCmdProxy.Instance:CallQueryVoiceUserCmd(self.autoSpeech[1])
		-- ChatRoomNetProxy.Instance:CallQueryVoiceUserCmd(self.autoSpeech[1])
	else
		FunctionChatSpeech.Me():GetAudioController():Stop()
	end
end

function ChatRoomProxy:ResetAutoSpeech()
	TableUtility.TableClear(self.autoSpeech)
end

function ChatRoomProxy:IsPrivateSpeech(voiceid)
	for i=1,#self.privateChatSpeech do
		if voiceid == self.privateChatSpeech[i] then
			return true
		end
	end
	return false
end

function ChatRoomProxy:RecvChatSpeech(data)
	local path
	if self:IsPrivateSpeech(data.voiceid) then
		local bytes = Slua.ToBytes(data.voice)
		path = FunctionChatIO.Me():SavePrivateChatSpeech(data.voiceid , bytes)
	else
		local bytes = Slua.ToBytes(data.voice)
		path = FunctionChatIO.Me():SaveChatSpeech(data.voiceid , bytes)
	end
	return path
end

function ChatRoomProxy:SetBarrageState(channel,state)
	self.barrageState[channel] = state
end

function ChatRoomProxy:GetBarrageState(channel)
	if self.barrageState[channel] == nil then
		self.barrageState[channel] = BarrageStateEnum.Off
	end

	return self.barrageState[channel]
end

function ChatRoomProxy:GetBarrageContent()
	return self.barrageContent
end

function ChatRoomProxy:IsPlayerSpeak(channel)
	for i=1,#GameConfig.ChatRoom.PlayerSpeak do
		if channel == GameConfig.ChatRoom.PlayerSpeak[i] then
			return true
		end
	end

	return false
end

function ChatRoomProxy:IsShowRedTip(data)
	local chatId
	local myId = Game.Myself.data.id
	local targetid = data:GetTargetid()
	local id = data:GetId()

	if targetid and targetid ~= myId then
		chatId = targetid
	elseif id then
		chatId = id
	end

	if id == myId then
		return false
	elseif data:GetCellType() == ChatTypeEnum.SystemMessage then
		return false
	elseif chatId == self.curPrivateChatId then
		return false
	end

	return true
end

function ChatRoomProxy:ShowRedTip(data)
	if self:IsShowRedTip(data) then
		RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
	end
end

function ChatRoomProxy:ClearRedTip()
	if self:IsClearUnreadCount() then
		RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
	end
end

function ChatRoomProxy:CheckRedTip()
	if self:IsClearUnreadCount() then
		RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
	else
		RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
	end
end

function ChatRoomProxy:RecvGetVoiceIDChatCmd(id)
	self.voiceId = id
end

function ChatRoomProxy:GetVoiceId()
	return self.voiceId
end

function ChatRoomProxy:ResetVoiceId()
	self.voiceId = nil
end

function ChatRoomProxy:StripSymbols(content)
	if content then
		local isStripSymbols = true
		local lastContent
		while isStripSymbols do
			lastContent = content
			content = NGUIText.StripSymbols(content)

			if content == lastContent then
				isStripSymbols = false
			end
		end
	end

	return content
end

--自言自语
function ChatRoomProxy:CheckSoliloquize(channel, content, desID)
	local soliloquizeChats = GameConfig.ChatRoom.soliloquizeChats
	for i=1,#soliloquizeChats do
		if channel == soliloquizeChats[i] then
			if FunctionMaskWord.Me():CheckMaskWord(content, FunctionMaskWord.MaskWordType.Soliloquize) then

				local soliloquizeTemp = ReusableTable.CreateTable()

				soliloquizeTemp.id = Game.Myself.data.id
				soliloquizeTemp.targetid = desID
		 		soliloquizeTemp.voiceid = 0
		 		soliloquizeTemp.voicetime = 0
		 		soliloquizeTemp.channel = channel
		 		soliloquizeTemp.str = content

				self:TryCreateChatMessage(soliloquizeTemp)

				ReusableTable.DestroyAndClearTable(soliloquizeTemp)
				return true
			end		
		end
	end

	return false
end

function ChatRoomProxy:TryCreateChatMessage(data)
	local chat = self:RecvChatMessage(data)
	self:sendNotification(ServiceEvent.ChatCmdChatRetCmd, chat)
	return chat
end

function ChatRoomProxy:TryRecognizer()
	local allow = PermissionUtil.Access_RecordAudio()
	if allow == true then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.SpeechRecognizerView})
	end

	return allow
end

--寻找导师/学生
function ChatRoomProxy:AddTutor(tutorType)
	if tutorType ~= nil then
		self.tutorType = tutorType

		local str = self:GetTutorString(tutorType)
		if str ~= nil then
			return string.format(ChatRoomProxy.ItemNormalLabel, str)
		end
	end
end

function ChatRoomProxy:GetTutorString(tutorType)
	if tutorType == TutorType.Tutor then
		return ZhString.Tutor_Chat_FindTutor
	elseif tutorType == TutorType.Student then
		return ZhString.Tutor_Chat_FindStudent
	end

	return nil
end

--将content中的{XXX}转换成tutor code
function ChatRoomProxy:TryParseTutorContentToCode(content)

	if self.tutorType == nil then
		return content
	end

	local tip = self:GetTutorString(self.tutorType)
	if tip ~= nil then
		--检查用户输入 "{ft=" 转成 "{ ft="，用于防止用户主动输入tutor code
		content = string.gsub(content,"{ft=","{ ft=")

		for str,name in string.gmatch(content, ChatRoomProxy.ItemNormal) do
			if name == tip then
				local code = string.format("{ft=%s}", self.tutorType)
				local split = string.split(content, str)
				if #split > 1 then
					TableUtility.ArrayClear(concatTable)
					concatTable[1] = split[1]
					for i=2,#split do
						if i == 2 then
							concatTable[i] = code..split[i]
						else
							concatTable[i] = str..split[i]
						end
					end
					content = table.concat(concatTable)
				end
			end
		end
	end

	self.tutorType = nil

	return content
end

--将content中的tutor code转换成{tutor}，包含下划线，超链接样式
function ChatRoomProxy:TryParseTutorCodeToNormal(content)

	if content == nil or type(content) == "table" then
		return content
	end

	if string.find(content , self.TutorCodeString) == nil then
		return content
	end
	
	TableUtility.TableClear(self.localTable)
	for str,code in string.gmatch(content, self.TutorCode) do
		local data = {}
		data.str = str
		data.code = code
		table.insert(self.localTable , data)
	end

	for i=1,#self.localTable do
		local str = self.localTable[i].str
		local code = self.localTable[i].code
		local split = string.split(content , str)

		if #split > 1 then
			local temp = string.format(self.ItemBBCodeLabel, code, self:GetTutorString(tonumber(code)))
			
			TableUtility.ArrayClear(concatTable)
			concatTable[1] = split[1]
			for i=2,#split do
				concatTable[i] = temp..split[i]
			end
			content = table.concat(concatTable)
		end
	end

	return content
end

--将content中的treasure code转换成{treasure}，包含下划线，超链接样式
function ChatRoomProxy:TryParseTreasureCodeToNormal(content)

	if content == nil or type(content) == "table" then
		return content
	end

	if string.find(content , self.TreasureCodeString) == nil then
		return content
	end
	
	TableUtility.TableClear(self.localTable)
	for str,code in string.gmatch(content, self.TreasureCode) do
		local data = {}
		data.str = str
		data.code = code
		table.insert(self.localTable , data)
	end

	for i=1,#self.localTable do
		local str = self.localTable[i].str
		local code = self.localTable[i].code
		local split = string.split(content , str)

		if #split > 1 then
			local temp = string.format(self.ItemBBCodeLabel, code, ZhString.GuildTreasure_ChatTip)
			
			TableUtility.ArrayClear(concatTable)
			concatTable[1] = split[1]
			for i=2,#split do
				concatTable[i] = temp..split[i]
			end
			content = table.concat(concatTable)
		end
	end

	return content
end

function ChatRoomProxy:RecvNpcChatNtf(data)
	local channel = data.channel
	if channel == ChatChannelEnum.System or channel == ChatChannelEnum.Private or channel == ChatChannelEnum.Zone then
		return
	end

	local npcid = data.npcid
	local npcdata = Table_Npc[npcid]
	if npcdata then
		local chat = ReusableTable.CreateTable()

		local headData = HeadImageData.new()
		headData:TransByNpcData(npcdata)

		chat.id = data.npcguid
		chat.name = headData.name
 		chat.channel = channel
 		chat.roleType = ChatRoleEnum.Npc
 	 	chat.voiceid = 0
 		chat.voicetime = 0

 		local str = ""
 		local msg = Table_Sysmsg[data.msgid]
 		if msg ~= nil then
			str = msg.Text
 		else
 			str = data.msg
 		end
		local param = ReusableTable.CreateArray()
		for i=1,#data.params do
			TableUtility.ArrayPushBack(param, data.params[i].param)
		end
		str = MsgParserProxy.Instance:TryParse(str, unpack(param))
		ReusableTable.DestroyAndClearArray(param)

 		chat.str = str

	 	local chatData = self:TryCreateChatMessage(chat)
	 	chatData:TransByHeadImageData(headData)

		ReusableTable.DestroyAndClearTable(chat)
	end
end