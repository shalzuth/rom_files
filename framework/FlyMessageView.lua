autoImport("BarrageView")
autoImport("FunctionMaskWord")
autoImport("BarrageFrameCell")
FlyMessageView = class("FlyMessageView", SubView)
local COLOR_SELECTION_ICON_PREFIX = "photo_icon_"
function FlyMessageView:Init()
  if not self.beAwake then
    self:Awake()
  end
  self:Start()
end
function FlyMessageView:Awake()
  self.state = true
  self.transFlyingMessage = self:FindGO("FlyingMessage").transform
  self.transFlyingMessageSwitch = self:FindGO("FlyingMessageSwitch").transform
  self:AddClickEvent(self.transFlyingMessageSwitch.gameObject, function()
    self:OnButtonFlyingMessageSwitchClick()
  end)
  self.transBtnSend = self:FindGO("BtnSend").transform
  self:AddClickEvent(self.transBtnSend.gameObject, function()
    local str = self.uiInputFlyingMessage.value
    if str == "" then
      MsgManager.ShowMsgByIDTable(807)
      return
    end
    if #str > GameConfig.Barrage.MessageCountMax then
      MsgManager.ShowMsgByIDTable(25822)
      return
    end
    if self.frameID then
      local frameData = Table_BarrageFrame[self.frameID]
      if frameData.CostItem and frameData.CostItem ~= 0 and BagProxy.Instance:GetItemNumByStaticID(frameData.CostItem) < frameData.CostItemNum then
        local itemData = Table_Item[frameData.CostItem]
        MsgManager.ShowMsgByID(25824, itemData and itemData.NameZh)
        return
      end
    end
    self.uiInputFlyingMessage.value = ""
    local color = FunctionBarrage.Me():GetColorByName(self:CurrentColorName())
    local colorMsg = {
      r = math.floor(color.r * 255),
      g = math.floor(color.g * 255),
      b = math.floor(color.b * 255)
    }
    local percent = FunctionBarrage.Me():GetPercent()
    local pos = {
      x = math.floor(percent * 1000)
    }
    local speed = math.random(GameConfig.Barrage.SpeedMin, GameConfig.Barrage.SpeedMax)
    ServiceChatCmdProxy.Instance:CallBarrageMsgChatCmd(str, pos, colorMsg, speed, nil, self.frameID ~= 1 and self.frameID or nil)
  end)
  self.transInputField = self:FindGO("InputField", self.transFlyingMessage.gameObject)
  self.uiInputFlyingMessage = self.transInputField:GetComponent(UIInput)
  self.objColorSelection = self:FindGO("ColorSelection")
  self:AddClickEvent(self.objColorSelection, function()
    self:OnButtonColorSelectionClick()
  end)
  self.spBeSelected = self:FindGO("BeSelected", self.objColorSelection):GetComponent(UISprite)
  self.objArrowColor = self:FindGO("arrow", self.objColorSelection)
  self.objLockColor = self:FindGO("lock", self.objColorSelection)
  self.objSelColorBoard = self:FindGO("SelColorBoard")
  self.transFlyingMessageColors = self:FindGO("GridColors", self.objColorSelection).transform
  for i = 0, self.transFlyingMessageColors.childCount - 1 do
    local transChild = self.transFlyingMessageColors:GetChild(i)
    self:AddClickEvent(transChild.gameObject, function(go)
      self:OnColorButtonClick(go)
    end)
  end
  self.objFrameSelection = self:FindGO("FrameSelection")
  self:AddClickEvent(self.objFrameSelection, function()
    self:OnButtonFrameSelectionClick()
  end)
  self.labFrameSelected = self:FindComponent("labSelFrameTxt", UILabel, self.objFrameSelection)
  self.objSelFrameBoard = self:FindGO("SelFrameBoard", self.objFrameSelection)
  self.listFrames = UIGridListCtrl.new(self:FindComponent("GridFrames", UIGrid, self.objSelFrameBoard), BarrageFrameCell, "BarrageFrameCell")
  self.listFrames:AddEventListener(MouseEvent.MouseClick, self.OnFrameButtonClick, self)
  self.transBG = self:FindGO("ViewBG", self.transFlyingMessage.gameObject).transform
  self.spBG = self.transBG.gameObject:GetComponent(UISprite)
  self:FoldView()
  self:ListenEvent()
  self.beAwake = true
end
function FlyMessageView:Start()
  self.state = true
  self.switchFlyingMessage = false
  self.spBeSelected.spriteName = COLOR_SELECTION_ICON_PREFIX .. self:CurrentColorName()
  self:SetCurrentFrame(self:CurrentFrameID())
end
function FlyMessageView:StartRecieveBarrage()
  self.switchFlyingMessage = false
  self:OnButtonFlyingMessageSwitchClick()
end
function FlyMessageView:ListenEvent()
  EventManager.Me():AddEventListener(ServiceEvent.ChatCmdBarrageMsgChatCmd, self.OnReceiveFlyingMessage, self)
end
function FlyMessageView:CancelListenEvent()
  EventManager.Me():RemoveEventListener(ServiceEvent.ChatCmdBarrageMsgChatCmd, self.OnReceiveFlyingMessage, self)
end
function FlyMessageView:OnButtonColorSelectionClick()
  if self.isOpenColorSel then
    self.objSelColorBoard:SetActive(false)
    self.isOpenColorSel = false
  else
    self.objSelFrameBoard:SetActive(false)
    self.objSelColorBoard:SetActive(true)
    self.isOpenColorSel = true
    for i = 0, self.transFlyingMessageColors.childCount - 1 do
      local transChild = self.transFlyingMessageColors:GetChild(i)
      transChild:Find("Select").gameObject:SetActive(transChild.name == self.colorName)
    end
  end
end
function FlyMessageView:OnColorButtonClick(go)
  self.objSelColorBoard:SetActive(false)
  self.isOpenColorSel = false
  self:SetCurrentColor(go.name)
end
function FlyMessageView:SetCurrentColor(colorName)
  self.colorName = colorName
  self.spBeSelected.spriteName = COLOR_SELECTION_ICON_PREFIX .. self:CurrentColorName()
  self.labFrameSelected.color = FunctionBarrage.Me():GetColorByName(colorName)
  PlayerPrefs.SetString("Flying_Message_Color_Name", self:CurrentColorName())
  PlayerPrefs.Save()
end
function FlyMessageView:OnButtonFrameSelectionClick()
  self.isOpenFrameSel = not self.isOpenFrameSel
  self.objSelFrameBoard:SetActive(self.isOpenFrameSel)
  if self.isOpenFrameSel then
    self.objSelColorBoard:SetActive(false)
    self.listFrames:ResetDatas(TableUtil.HashToArray(Table_BarrageFrame))
    local cells = self.listFrames:GetCells()
    for i = 1, #cells do
      cells[i]:SetCurFrame(self.frameID)
    end
  end
end
function FlyMessageView:OnFrameButtonClick(frameData)
  self.isOpenFrameSel = false
  self.objSelFrameBoard:SetActive(false)
  self:SetCurrentFrame(frameData.id)
end
function FlyMessageView:SetCurrentFrame(frameID)
  self.frameID = frameID
  PlayerPrefs.SetInt("Flying_Message_Frame_ID", self.frameID)
  PlayerPrefs.Save()
  FunctionBarrage.Me():CreateFrame(self.labFrameSelected.gameObject, self.frameID)
  local colorLimit = Table_BarrageFrame[self.frameID].FontColorLimit
  local haveLimit = colorLimit ~= nil and colorLimit ~= ""
  self.objColorSelection:GetComponent(Collider).enabled = not haveLimit
  self.objArrowColor:SetActive(not haveLimit)
  self.objLockColor:SetActive(haveLimit)
  if haveLimit then
    self:SetCurrentColor(colorLimit)
  else
    self.labFrameSelected.color = FunctionBarrage.Me():GetColorByName(self:CurrentColorName())
  end
end
function FlyMessageView:OnButtonFlyingMessageSwitchClick()
  self.switchFlyingMessage = not self.switchFlyingMessage
  if self.switchFlyingMessage then
    ServiceChatCmdProxy.Instance:CallBarrageChatCmd(ChatCmd_pb.EBARRAGE_OPEN)
    FunctionBarrage.Me():Launch(GameConfig.Barrage.SpeedMin)
    self:ExpandView()
  else
    ServiceChatCmdProxy.Instance:CallBarrageChatCmd(ChatCmd_pb.EBARRAGE_CLOSE)
    FunctionBarrage.Me():ShutDown()
    self:FoldView()
  end
end
function FlyMessageView:GenerateID()
  self.count = self.count or 0
  self.count = self.count + 1
  return self.count
end
function FlyMessageView:OnReceiveFlyingMessage(data)
  if data == nil then
    return
  end
  local msg = data
  local str = msg.str
  local speed = msg.speed
  speed = speed or 30
  speedForPixels = BarrageView.activeWidth * speed / 360
  local color = msg.clr
  local params = {
    text = str,
    speed = speedForPixels,
    color = Color(color.r / 255, color.g / 255, color.b / 255, 1),
    fontSize = 24,
    duration = 360 / speed,
    percent = msg.msgpos.x / 1000,
    userid = data.userid,
    frame = data.frame
  }
  FunctionBarrage.Me():AddText(params)
end
function FlyMessageView:ExpandView()
  local atlas = RO.AtlasMap.GetAtlas("NewUI1")
  self.spBG.atlas = atlas
  self.spBG.spriteName = "photo_bg_2"
  self.centerType = E_UIBasicSprite_Type.Sliced
  self.spBG.width = 905
  self.spBG.height = 112
  local localPos = self.transBG.localPosition
  localPos.x = -335
  localPos.y = 0
  self.transBG.localPosition = localPos
  self.transInputField.gameObject:SetActive(true)
  self.objSelColorBoard:SetActive(false)
  self.objColorSelection:SetActive(true)
  self.objSelFrameBoard:SetActive(false)
  self.transBtnSend.gameObject:SetActive(true)
  self.transFlyingMessageSwitch.localEulerAngles = Vector3(0, 180, 0)
end
function FlyMessageView:FoldView()
  local atlas = RO.AtlasMap.GetAtlas("NewCom")
  self.spBG.atlas = atlas
  self.spBG.spriteName = "com_bg_4s_bottom"
  self.centerType = E_UIBasicSprite_Type.Simple
  self.spBG.width = 108
  self.spBG.height = 108
  local localPos = self.transBG.localPosition
  localPos.x = -331
  localPos.y = -8
  self.transBG.localPosition = localPos
  self.transInputField.gameObject:SetActive(false)
  self.objSelColorBoard:SetActive(false)
  self.objColorSelection:SetActive(false)
  self.objSelFrameBoard:SetActive(false)
  self.objFrameSelection:SetActive(false)
  self.transBtnSend.gameObject:SetActive(false)
  self.transFlyingMessageSwitch.localEulerAngles = Vector3.zero
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
function FlyMessageView:CurrentFrameID()
  if not self.frameID then
    self.frameID = PlayerPrefs.GetInt("Flying_Message_Frame_ID", 1)
    local frameData = Table_BarrageFrame[self.frameID]
    if not BarrageProxy.Instance:IsFrameUnlocked(self.frameID) or frameData.CostItem and BagProxy.Instance:GetItemNumByStaticID(frameData.CostItem) < frameData.CostItemNum then
      self.frameID = 1
      PlayerPrefs.SetInt("Flying_Message_Frame_ID", 1)
      PlayerPrefs.Save()
    end
  end
  return self.frameID
end
function FlyMessageView:CloseUIWidgets()
  self.transFlyingMessage.gameObject:SetActive(false)
end
function FlyMessageView:OpenUIWidgets(isRight)
  self.transFlyingMessage.gameObject:SetActive(true)
end
function FlyMessageView:OnExit()
  self:CancelListenEvent()
end
