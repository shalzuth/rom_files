CreateChatRoom = class("CreateChatRoom", ContainerView)

CreateChatRoom.ViewType = UIViewType.PopUpLayer;
CreateChatRoom.Icon = "69"

function CreateChatRoom:Init()
	self.uiInputName = self:FindGO("NameInput"):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(self.uiInputName, GameConfig.System.roomname_max)
    -- todo xde 先翻译后处理
	--self.uiInputName.value = Game.Myself.data.name..ZhString.Chat_zoneName
    self.uiInputName.value = Game.Myself.data.name..OverSea.LangManager.Instance():GetLangByKey(ZhString.Chat_zoneName)
	--self.uiInputName.value = self:FindGO("StrCached1"):GetComponent(UILabel).text
	self.labMemberCount = self:FindGO("LabMemberCount"):GetComponent(UILabel)
	self.memberCount = 10
	self.labMemberCount.text = "10"
	self.uiInputSecret = self:FindGO("SecretInput"):GetComponent(UIInput)

	-- todo xde 创建聊天室时，密码设定不能以-开头
	UIUtil.LimitInputCharacter(self.uiInputSecret, 6)
	EventDelegate.Set(self.uiInputSecret.onChange, function()
		self.uiInputSecret.value = self.uiInputSecret.value:gsub("-", "")
	end)

	self.uiInputSecret.value = ""

	self:AddListenEvt(ServiceEvent.ChatRoomEnterChatRoom, self.OnReceiveEnterChatZoom)
end

function CreateChatRoom:OnEnter()
	self:AddClickEvent(self:FindGO("CancelButton"), function (g)
		self:sendNotification(ChatRoomEvent.CancelCreateChatRoom)
		self:CloseSelf()
	end)
	self:AddClickEvent(self:FindGO("ConfirmButton"), function (g)
		self:OnButtonConfirmClick()
	end)
	self:AddClickEvent(self:FindGO("BtnReduce"), function (g)
		self:OnButtonReduceClick()
	end)
	self:AddClickEvent(self:FindGO("BtnAdd"), function (g)
		self:OnButtonAddClick()
	end)
	self:AddClickEvent(self:FindGO("CloseButton"),function ()
		self:sendNotification(ChatRoomEvent.CancelCreateChatRoom)
		self:CloseSelf()
	end)
end

function CreateChatRoom:OnButtonConfirmClick()
	print("FUN >>> CreateChatRoom:OnButtonConfirmClick")

	if (string.len(self.uiInputName.value) == 0) then
		MsgManager.ShowMsgByID(806)
		return
	end

	if ((string.len(self.uiInputSecret.value) ~= 6) and (string.len(self.uiInputSecret.value) ~= 0)) then
		MsgManager.ShowMsgByID(805)
		return
	end

	if ChatZoomProxy.Instance:IsInChatZone() then
		MsgManager.ShowMsgByID(813)
		return
	end

	if FunctionMaskWord.Me():CheckMaskWord(self.uiInputName.value , FunctionMaskWord.MaskWordType.SpecialSymbol|FunctionMaskWord.MaskWordType.Chat) then
		MsgManager.ShowMsgByID(2604)
		return
	end

	if Game.MapManager:IsPVPMode_GVGDetailed() then
		MsgManager.ShowMsgByID(25311)
		return
	end

	ServiceChatRoomProxy.Instance:CallCreateChatRoom(self.uiInputName.value, self.memberCount, self.uiInputSecret.value)
end

function CreateChatRoom:OnButtonReduceClick()
	if self.memberCount <= 2 then
		return
	end
	self.memberCount = self.memberCount - 1
	self.labMemberCount.text = tostring(self.memberCount)
end

function CreateChatRoom:OnButtonAddClick()
	if self.memberCount >= 10 then
		return
	end
	self.memberCount = self.memberCount + 1
	self.labMemberCount.text = tostring(self.memberCount)
end

function CreateChatRoom:OnReceiveEnterChatZoom(data)
	-- print("FUN >>> CreateChatRoom:OnReceiveEnterChatZoom")
	-- print("data following...")
	-- TableUtil.Print(data)
	if (data == nil) then
		return
	end
	self:CloseSelf()
	local zoomInfo = data.body.data
	local ownerID = zoomInfo.ownerid
	local isShow = true
	if isShow then
		local str1 = zoomInfo.name
		-- local str1Length = LuaUtils.StringLength(str1)
		-- if str1Length > 8 then
		-- 	str1 = LuaUtils.SubString(str1, 0, 7)
		-- 	str1 = str1 .. "..."
		-- end
		local str2 = "(" .. #zoomInfo.members .. "/" .. zoomInfo.maxnum .. ")"

		SceneUIManager.Instance:AddRoleTopFuncWords(Game.Myself, CreateChatRoom.Icon, {left = str1, right = str2}, nil, true, 10)
	end
end