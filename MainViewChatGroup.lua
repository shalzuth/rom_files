autoImport("MainViewChatCell")

local baseCell = autoImport("BaseCell")
MainViewChatGroup = class("MainViewChatGroup",baseCell)

MainViewChatGroup.rid = ResourcePathHelper.UICell("MainViewChatCell")

MainViewChatGroup.LevelCount = {
	[1] = 3,
	[2] = 5,
	[3] = 18,
}

function MainViewChatGroup:Init()
	self:FindObjs()
	self:InitShow()
end

function MainViewChatGroup:FindObjs()
	self.table = self:FindGO("Table"):GetComponent(UITable)
	self.emptyTip = self:FindGO("EmptyTip"):GetComponent(UILabel)
end

function MainViewChatGroup:InitShow()
	self.chatCellList = {}

	self:SetTweenLevel(1)
end

function MainViewChatGroup:SetData(channel)
	-- printData('ZhString.Chat_ScrollScreenEmpty', ZhString.Chat_ScrollScreenEmpty)
	self.data = channel
	local channelName = ChatRoomProxy.Instance.channelNames[channel]
	if channelName then
		self.emptyString = string.format(ZhString.Chat_ScrollScreenEmpty , channelName)
		--[[ todo xde ?????? key ????????????????????????
		if (ZhString.Chat_ScrollScreenEmpty == OverSea.LangManager.Instance():GetLangByKey(ZhString.Chat_ScrollScreenEmpty)) then
			local tmp = OverSea.LangManager.Instance():GetLangByKey(ZhString.Chat_ScrollScreenEmpty:gsub("%s+", ""))
			printData('tmp', tmp)
			self.emptyString = string.format(tmp , channelName)
			-- printData('msm', self.emptyString)
		end
		--]]
	else
		self.emptyString=  ""
	end

	self:Update()
end

function MainViewChatGroup:Update()
	local _ChatRoomProxy = ChatRoomProxy.Instance
	local datas = _ChatRoomProxy:GetMessagesByChannel(self.data)
	if datas == nil then
		datas = _ChatRoomProxy:GetScrollScreenContents()
	end

	local isEmpty = true
	local index = 0
	local dataIndex = #datas

	while index < self.LevelCount[self.tweenLevel] do	
		local data = datas[dataIndex]
		dataIndex = dataIndex - 1
		if data then
			local cellType = data:GetCellType()
			local channel = data:GetChannel()

			if cellType and cellType == ChatTypeEnum.SystemMessage 
				and channel ~= ChatChannelEnum.System then
				
			else
				isEmpty = false

				index = index + 1
				self.chatCellList[index]:SetData(data:GetMainViewText())
			end
		else
			index = index + 1
			self.chatCellList[index]:SetData("")
		end
	end

	if isEmpty then
		self.emptyTip.text = self.emptyString
	else
		self.emptyTip.text = ""
		self:Refresh()
	end
end

function MainViewChatGroup:SetTweenLevel(tweenLevel)
	if self.tweenLevel ~= tweenLevel then
		self.tweenLevel = tweenLevel

		local cellCount = #self.chatCellList
		if cellCount < self.LevelCount[tweenLevel] then

			local tableObj = self.table.gameObject
			for i=cellCount+1, self.LevelCount[tweenLevel] do
				local obj = self:CreateObj(self.rid, tableObj)
				obj.name = "MainViewChatCell"..i
				local cell = MainViewChatCell.new(obj)
				self.chatCellList[i] = cell
			end
		end

		self:SetData(self.data)
	end
end

function MainViewChatGroup:Refresh()
	self.table:Reposition()
end