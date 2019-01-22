autoImport('BarrageView')
autoImport('FunctionMaskWord')

FlyMessageView = class("FlyMessageView",SubView)

local COLOR_SELECTION_ICON_PREFIX = "photo_icon_"

function FlyMessageView:Init()
	-- if (FMEmission.Ins():IsPronteraSouthGate()) then
	-- else
	-- end
	if not self.beAwake then
		self:Awake()
	end
	self:Start()
end

function FlyMessageView:Awake()
	-- true means openning flying message
	self.state = false

	-- <region start> get gameObject reference
	self.transFlyingMessage = self:FindGO("FlyingMessage").transform
	self.transFlyingMessageSwitch = self:FindGO("FlyingMessageSwitch").transform
	self:AddClickEvent(self.transFlyingMessageSwitch.gameObject, function ()
		self:OnButtonFlyingMessageSwitchClick()
	end)
	self.transBtnSend = self:FindGO("BtnSend").transform
	self:AddClickEvent(self.transBtnSend.gameObject, function ()
		local str = self.uiInputFlyingMessage.value
		if str == "" then
			MsgManager.ShowMsgByIDTable(807)
			return
		end
		-- if FunctionMaskWord.Me():CheckMaskWord(str, FunctionMaskWord.MaskWordType.Chat) then
		-- 	str = FunctionMaskWord.Me():ReplaceMaskWord(str, FunctionMaskWord.MaskWordType.Chat)
		-- end
		self.uiInputFlyingMessage.value = ""
		--local pos = FMEmission.Ins():PosOfSend()
		local color = self:CurrentColor()
		local colorMsg = {["r"] = math.floor(color.r * 255), ["g"] = math.floor(color.g * 255), ["b"] = math.floor(color.b * 255)}
		local percent = FunctionBarrage.Me():GetPercent()
		local pos = {x = math.floor(percent * 1000)}
		local speed = math.random(GameConfig.Barrage.SpeedMin, GameConfig.Barrage.SpeedMax)
		ServiceChatCmdProxy.Instance:CallBarrageMsgChatCmd(str, pos, colorMsg, speed)
	end)
	self.transInputField = self:FindGO("InputField", self.transFlyingMessage.gameObject)
	self.uiInputFlyingMessage = self.transInputField:GetComponent(UIInput)
	self.transFlyingMessageColorSelection = self:FindGO("ColorSelection").transform
	self:AddClickEvent(self.transFlyingMessageColorSelection.gameObject, function ()
		self:OnButtonColorSelectionClick()
	end)
	self.spBeSelected = self:FindGO("BeSelected", self.transFlyingMessageColorSelection.gameObject):GetComponent(UISprite)
	self.uiPlyAnimColorSel = self.gameObject:GetComponent("UIPlayAnimation")
	self.transFlyingMessageColors = self:FindGO("Colors", self.transFlyingMessageColorSelection.gameObject).transform
	local colorsCount = self.transFlyingMessageColors.childCount
	for i = 0, colorsCount - 1 do
		local transChild = self.transFlyingMessageColors:GetChild(i)
		self:AddClickEvent(transChild.gameObject, function (go)
			self:OnColorButtonClick(go)
		end)
	end
	EventDelegate.Set(self.uiPlyAnimColorSel.onFinished, function ()
		if self:IsFoldColorSelections() then
			self:HideColors()
			self.colorSelectionsIsFolded = true
		else
			self.colorSelectionsIsExpanded = true
		end
	end)
	self.transBG = self:FindGO("ViewBG", self.transFlyingMessage.gameObject).transform
	self.spBG = self.transBG.gameObject:GetComponent(UISprite)
	-- <region end> get gameObject reference

	self:FoldView()
	self:ListenEvent()
	self.beAwake = true
end

function FlyMessageView:Start()
	self.switchFlyingMessage = false
	if self.state then
		self.state = false
		self:FoldView()
	end

	self.spBeSelected.spriteName = COLOR_SELECTION_ICON_PREFIX .. self:CurrentColorName()
	local color = self:CurrentColor()
	self.uiInputFlyingMessage.activeTextColor = color
end

function FlyMessageView:ListenEvent()
	EventManager.Me():AddEventListener(ServiceEvent.ChatCmdBarrageMsgChatCmd, self.OnReceiveFlyingMessage, self)
end

function FlyMessageView:CancelListenEvent()
	EventManager.Me():RemoveEventListener(ServiceEvent.ChatCmdBarrageMsgChatCmd, self.OnReceiveFlyingMessage, self)
end

-- <region start>button event
function FlyMessageView:OnButtonColorSelectionClick()
	if (self.isOpenColorSel) then
		self:FoldColorSelections()
		self.isOpenColorSel = false
	else
		self:ExpandColorSelections()
		self.isOpenColorSel = true
	end
end

function FlyMessageView:OnColorButtonClick(go)
	self:FoldColorSelections()
	self.isOpenColorSel = false
	local colorName = ""
	if (go.name == "Red") then
		colorName = "yellow"
	elseif (go.name == "Purple") then
		colorName = "purple"
	elseif (go.name == "White") then
		colorName = "red"
	elseif (go.name == "Yellow") then
		colorName = "pink"
	elseif (go.name == "Green") then
		colorName = "white"
	elseif (go.name == "Blue") then
		colorName = "blue"
	elseif (go.name == "Pink") then
		colorName = "green"
	end
	self.colorName = colorName
	self.spBeSelected.spriteName = COLOR_SELECTION_ICON_PREFIX .. self:CurrentColorName()
	local color = self:CurrentColor()
	self.uiInputFlyingMessage.activeTextColor = color
	PlayerPrefs.SetString("Flying_Message_Color_Name", self:CurrentColorName())
	PlayerPrefs.Save()
end

function FlyMessageView:OnButtonFlyingMessageSwitchClick()
	self.switchFlyingMessage = not self.switchFlyingMessage
	if self.switchFlyingMessage then
		ServiceChatCmdProxy.Instance:CallBarrageChatCmd(ChatCmd_pb.EBARRAGE_OPEN)
		--SceneUIManager.Instance:ShowFlyingMessage()
		FunctionBarrage.Me():Launch(GameConfig.Barrage.SpeedMin)
		self:ExpandView()
	else
		ServiceChatCmdProxy.Instance:CallBarrageChatCmd(ChatCmd_pb.EBARRAGE_CLOSE)
		--SceneUIManager.Instance:HideFlyingMessage()
		FunctionBarrage.Me():ShutDown()
		self:FoldView()
	end
end
-- <region end>button event

function FlyMessageView:GenerateID()
	self.count = self.count or 0
	self.count = self.count + 1
	return self.count
end

-- <region start>server message handler
function FlyMessageView:OnReceiveFlyingMessage(data)
	--print("FUN >>> FlyMessageView:OnReceiveFlyingMessage")
	if (data == nil) then
		return
	end
	local msg = data
	local str = msg.str
	-- self:Launch(str, msg.clr, pos)
	local speed = msg.speed
	speed = speed or 30
	speedForPixels = BarrageView.activeWidth * speed/360
	local color = msg.clr
	local params = {text = str, speed = speedForPixels, color = Color(color.r / 255, color.g / 255, color.b / 255, 1), fontSize = 24, duration = 360 / speed, percent = msg.msgpos.x / 1000}
	FunctionBarrage.Me():AddText(params)
end
-- <region end>server message handler

function FlyMessageView:ExpandColorSelections()
	self.transFlyingMessageColors.gameObject:SetActive(true)
	self.uiPlyAnimColorSel.clipName = "PhotographColorOp"
	self.forward = true
	self.uiPlyAnimColorSel:Play(self.forward)
end

function FlyMessageView:FoldColorSelections()
	self.uiPlyAnimColorSel.clipName = "PhotographColorOp"
	self.forward = false
	self.uiPlyAnimColorSel:Play(self.forward)
end

function FlyMessageView:IsFoldColorSelections()
	return not self.forward
end

function FlyMessageView:HideColors()
	self.transFlyingMessageColors.gameObject:SetActive(false)
end

function FlyMessageView:ExpandView()
	local atlas = RO.AtlasMap.GetAtlas("NewUI1")
	self.spBG.atlas = atlas
	self.spBG.spriteName = "photo_bg_2"
	self.centerType = E_UIBasicSprite_Type.Sliced
	self.spBG.width = 603
	self.spBG.height = 106
	local localPos = self.transBG.localPosition
	localPos.y = 0
	self.transBG.localPosition = localPos

	self.transInputField.gameObject:SetActive(true)
	self.transFlyingMessageColorSelection.gameObject:SetActive(true)
	self.transFlyingMessageColors.gameObject:SetActive(false)
	self.transBtnSend.gameObject:SetActive(true)
end

function FlyMessageView:FoldView()
	local atlas = RO.AtlasMap.GetAtlas("NewCom")
	self.spBG.atlas = atlas
	self.spBG.spriteName = "com_bg_4s_bottom"
	self.centerType = E_UIBasicSprite_Type.Simple
	self.spBG.width = 108
	self.spBG.height = 108
	local localPos = self.transBG.localPosition
	localPos.x = -324
	localPos.y = -9
	self.transBG.localPosition = localPos

	self.transInputField.gameObject:SetActive(false)
	self.transFlyingMessageColorSelection.gameObject:SetActive(false)
	self.transFlyingMessageColors.gameObject:SetActive(false)
	self.transBtnSend.gameObject:SetActive(false)
end

function FlyMessageView:CurrentColorName()
	if not self.colorName then
		if PlayerPrefs.HasKey("Flying_Message_Color_Name") then
			self.colorName = PlayerPrefs.GetString("Flying_Message_Color_Name")
		else
			self.colorName = "white"
		end
	end
	return self.colorName
end

function FlyMessageView:CurrentColor()
	local colorName = self:CurrentColorName()
	local color = nil
	if (colorName == "white") then
		color = Color(173/255, 173/255, 173/255)
	elseif (colorName == "green") then
		color = Color(0/255, 255/255, 0/255)
	elseif (colorName == "blue") then
		color = Color(0/255, 0/255, 255/255)
	elseif (colorName == "red") then
		color = Color(255/255, 0/255, 0/255)
	elseif (colorName == "yellow") then
		color = Color(255/255, 255/255, 0/255)
	elseif (colorName == "pink") then
		color = Color(255/255, 105/255, 180/255)
	elseif (colorName == "purple") then
		color = Color(138/255, 43/255, 226/255)
	end
	return color
end

function FlyMessageView:CloseUIWidgets()
	self.transFlyingMessage.gameObject:SetActive(false)
end

function FlyMessageView:OpenUIWidgets()
	self.transFlyingMessage.gameObject:SetActive(true)
end

function FlyMessageView:OnExit()
	self:CancelListenEvent()
end