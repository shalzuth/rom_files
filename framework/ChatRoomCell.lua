-- errorLog
autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
local tempVector3 = LuaVector3.zero
ChatRoomCell = reusableClass("ChatRoomCell",baseCell)
ChatRoomCell.PoolSize = 60

local localData = {}
local size = Vector2(0,0,0)
local pos = LuaVector3.zero

function ChatRoomCell:Construct(asArray, args)
	self._alive = true
	self:DoConstruct(asArray, args)
end

function ChatRoomCell:Deconstruct()
	self._alive = false

	self.data = nil
	self.voiceid = nil
	self.voicetime = nil

	Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatRoomCell:Alive()
	return self._alive
end

-- override begin
function ChatRoomCell:DoConstruct(asArray, args)
	self.parent = args

	if self.gameObject == nil then
		self:CreateSelf(self.parent)
		self:FindObjs()
		self:AddEvts()
		self:InitShow()
	else
		self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject,self.parent)
	end
end

function ChatRoomCell:Finalize()
	ChatRoomCell.super.ClearEvent(self)

	GameObject.Destroy(self.gameObject)
end

function ChatRoomCell:ClearEvent()

end
-- override end

-- virtual begin
function ChatRoomCell:CreateSelf(parent)
end
-- virtual end

function ChatRoomCell:FindObjs()
	local headContainer = self:FindGO("HeadContainer")
	-- local headIconGo = self:FindGO("HeadIconCell")
	-- if headIconGo == nil then
		self.headIcon = HeadIconCell.new()
		self.headIcon:CreateSelf(headContainer)
	-- else
	-- 	self.headIcon = HeadIconCell.new(headIconGo)
	-- end
	self.headIcon.gameObject:AddComponent(UIDragScrollView)
	self.headIcon:SetScale(0.68)
	self.headIcon:SetMinDepth(2)

	self.chatContent = self:FindGO("chatContent"):GetComponent(UILabel)
	self.clickUrl = self.chatContent.gameObject:GetComponent(UILabelClickUrl)
	self.contentSpriteBg = self:FindGO("contentSpriteBg"):GetComponent(UISprite)
	self.speechBg = self:FindGO("speechBg")
	self.speechTime = self:FindGO("speechTime"):GetComponent(UILabel)
	self.voiceTween = self:FindGO("voice"):GetComponent(TweenColor)

	self.selfName = self:FindGO("name"):GetComponent(UILabel)
	self.adventure = self:FindGO("adventure"):GetComponent(UILabel)
	self.currentChannel = self:FindGO("currentChannel"):GetComponent(UILabel)
	self.contentPos = LuaVector3.zero

	self.top = self:FindGO("Top"):GetComponent(UIWidget)

	self.Voice = self:FindGO("Voice")
end

function ChatRoomCell:AddEvts()
	self:SetEvent(self.headIcon.clickObj.gameObject, function ()
		self:PassEvent(ChatRoomEvent.SelectHead, self)
	end)

	self.clickUrl.callback = function (url)
		local split = string.split(url, ChatRoomProxy.ItemCodeSymbol)
		local splitLength = #split
		if splitLength == 2 then
			if split[1] == "treasure" then
				ServiceGuildCmdProxy.Instance:CallQueryTreasureResultGuildCmd(tonumber(split[2]))
			else
				ServiceChatCmdProxy.Instance:CallQueryItemData(split[1])
			end
		elseif splitLength == 1 then
			if self.data ~= nil then
				local temp = ReusableTable.CreateTable()
				temp.data = self.data
				temp.url = url
				TipManager.Instance:ShowTutorFindTip(temp, self.headIcon.clickObj , NGUIUtil.AnchorSide.Right, {260,-200})
				ReusableTable.DestroyAndClearTable(temp)
			end
		end
	end

	self:AddClickEvent(self.speechBg,function (g)
		self:PlaySpeech()
	end)
end

function ChatRoomCell:InitShow()
	pos:Set(LuaGameObject.GetLocalPosition(self.gameObject.transform))

	self.contentPos:Set(LuaGameObject.GetLocalPosition(self.chatContent.transform))
	self.contentPos:Set(self.contentPos.x , -16 , 0)

	self.contentWidth = 260
	self.voiceTween.enabled = false

	self.chatContent.width = self.contentWidth
	self.chatContent.overflowMethod = 3

	-- self.localData = {}
end

function ChatRoomCell:SetData(data)

	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data ~= nil then
		--头像
		local portrait = data:GetPortrait()
		local headData = Table_HeadImage[portrait]
		if portrait and portrait ~= 0 and headData and headData.Picture then
			self.headIcon:SetSimpleIcon(headData.Picture)
		elseif data.portraitImage then
			self.headIcon:SetSimpleIcon(data.portraitImage)
		else
			TableUtility.TableClear(localData)
			localData.hairID = data:GetHair()
			localData.haircolor = data:GetHaircolor()
			localData.bodyID = data:GetBody()
			localData.headID = data:GetHead()
			localData.faceID = data:GetFace()
			localData.mouthID = data:GetMouth()
			localData.eyeID = data:GetEye()
			localData.gender = data:GetGender()
			localData.blink = data:GetBlink()
			self.headIcon:SetData(localData)
		end

		--名字
		self.selfName.text = data:GetName()
	----[[ todo xde 不翻译玩家名字
		self.selfName.text = AppendSpace2Str(data:GetName())
		--]]

		--冒险称号
		local appellation = Table_Appellation[data:GetAppellation()]
		if appellation then
			self.adventure.text = appellation.Level
		else
			self.adventure.text = ""
		end

		--频道
		local channelName = data:GetChannelName()
		if channelName then
			self.currentChannel.text = channelName
		else
			self.currentChannel.text = ChatRoomProxy.Instance.channelNames[data:GetChannel()]
		end

		--语音内容
		local voiceOffY = 0
		self.voiceid = data:GetVoiceid()
		self.voicetime = data:GetVoicetime()
		if self.voiceid ~= 0 and self.voicetime ~= 0 then
			self.speechBg:SetActive(true)
			self.speechTime.text = string.format(ZhString.Chat_speechTime,self.voicetime)
	
			-- todo xde xunfei
			voiceOffY = 46
			local line =  self:FindGO("line",self.speechBg)
			line:SetActive(false)
			self.chatContent.gameObject:SetActive(false)
		else
			self.speechBg:SetActive(false)
		end

		--文字内容
		tempVector3:Set(0,voiceOffY,0)
		LuaVector3.Better_Sub(self.contentPos,tempVector3,tempVector3)
		self.chatContent.transform.localPosition = tempVector3
		-- self.chatContent.width = self.contentWidth
		-- self.chatContent.overflowMethod = 3

		self.chatContent.text = data:GetStr()

		-- --背景大小调整
		-- local size = nil
		if data:GetCellType() == ChatTypeEnum.MySelfMessage then
			UIUtil.FitLabelHeight( self.chatContent , self.contentWidth )
			size = self.chatContent.localSize
		else
			size = self.chatContent.printedSize
		end
		
		local sizeY = size.y
		if sizeY > 50 then
			pos:Set(pos.x, 26, pos.z)
		else
			pos:Set(pos.x, 0, pos.z)
		end
		self.gameObject.transform.localPosition = pos

		if self.voiceid ~= 0 and self.voicetime ~= 0 then
			self.contentSpriteBg.width = self.contentWidth + 45
		else
			self.contentSpriteBg.width = size.x + 45
		end
		self.contentSpriteBg.height = sizeY + 25 + voiceOffY

		local charId = self.data:GetId()
		helplog("111charId:"..charId)

		if GVoiceProxy.Instance:IsThisCharIdRealtimeVoiceAvailable(charId) then
			helplog("222")
			self.Voice.gameObject:SetActive(true)
		else
			helplog("333")
			self.Voice.gameObject:SetActive(false)
		end	

	end
end

function ChatRoomCell:PlaySpeech()
	if self.voiceid ~= 0 and self.voicetime ~= 0 then
		local bytes,path = FunctionChatIO.Me():ReadChatSpeech(self.voiceid , self.data:GetTime())
		if bytes then
			FunctionChatSpeech.Me():PlayAudioByPath(path,self.voiceid)
		else
	 		ServiceChatCmdProxy.Instance:CallQueryVoiceUserCmd(self.voiceid)
	 		-- ChatRoomNetProxy.Instance:CallQueryVoiceUserCmd(self.voiceid)
	 	end
	 	ChatRoomProxy.Instance:ResetAutoSpeech()
	end
end

function ChatRoomCell:StartVoiceTween()
	self.voiceTween.enabled = true
	self.voiceTween:ResetToBeginning()
	self.voiceTween:PlayForward()
end

function ChatRoomCell:StopVoiceTween()
	if self.voiceTween.isActiveAndEnabled then
		self.voiceTween.enabled = false
		self.voiceTween.value = self.voiceTween.from
	end
end