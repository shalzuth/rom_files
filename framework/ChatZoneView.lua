autoImport("WrapScrollViewHelper")
autoImport("ChatRoomCombineCell")
ChatZoneView = class("ChatZoneView", SubView)
function ChatZoneView:OnEnter()
  self.super.OnEnter(self)
  self:ResetNewMessage()
  self.ContentTable:SetActive(true)
end
function ChatZoneView:OnExit()
  self.ContentTable:SetActive(false)
  ChatZoneView.super.OnExit(self)
end
function ChatZoneView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function ChatZoneView:FindObjs()
  self.ChatZone = self.container.ChatZone
  self.ContentScrollView = self:FindGO("ContentScrollView", self.ChatZone):GetComponent(UIScrollView)
  self.ContentPanel = self.ContentScrollView.gameObject:GetComponent(UIPanel)
  self.ContentTable = self:FindGO("ContentTable", self.ChatZone)
  self.MemberContainer = self:FindGO("MemberContainer", self.ChatZone)
  self.Title = self:FindGO("Title"):GetComponent(UILabel)
  self.CloseBtn = self:FindGO("CloseBtn", self.ChatZone)
  self.NewMessage = self:FindGO("NewMessageBg", self.ChatZone)
  self.NewMessageLabel = self:FindGO("NewMessageLabel", self.NewMessage):GetComponent(UILabel)
end
function ChatZoneView:AddEvts()
  self:AddClickEvent(self.CloseBtn, function(g)
    self:OnButtonCloseClick(g)
  end)
  self:AddClickEvent(self.NewMessage, function(g)
    self:HandleNewMessage()
  end)
end
function ChatZoneView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ChatRoomEnterChatRoom, self.OnReceiveEnter)
  self:AddListenEvt(ServiceEvent.ChatRoomExitChatRoom, self.OnReceiveExistChatZoom)
  self:AddListenEvt(ServiceEvent.ChatRoomRoomMemberUpdate, self.OnReceiveMembersUpdate)
  self:AddListenEvt(ServiceEvent.ChatRoomKickChatMember, self.OnReceiveBeKicked)
  self:AddListenEvt(ServiceEvent.ChatRoomChatRoomTip, self.OnReceiveTip)
end
local config = {}
function ChatZoneView:InitShow()
  self.curChannel = ChatChannelEnum.Zone
  self.TitleSL = SpriteLabel.new(self.Title.gameObject, nil, 30, 36, true)
  self.funkey = {}
  self.itemContent = WrapScrollViewHelper.new(ChatRoomCombineCell, ChatRoomPage.rid, self.ContentScrollView.gameObject, self.ContentTable, 10, function()
    if self.itemContent:GetIsMoveToFirst() then
      self:ResetNewMessage()
    else
      self.isLock = true
    end
  end)
  self.itemContent:AddEventListener(ChatRoomEvent.SelectHead, self.container.HandleClickHead, self)
  TableUtility.ArrayClear(config)
  config.wrapObj = self.MemberContainer
  config.cellName = "ChatNameCell"
  config.control = ChatNameCell
  config.dir = 1
  self.itemWrapName = WrapCellHelper.new(config)
  self.itemWrapName:AddEventListener(MouseEvent.MouseClick, self.HandleClickName, self)
  self:ResetNewMessage()
  self:UpdateChat()
end
function ChatZoneView:UpdateChat()
  local zoneInfo = ChatZoomProxy.Instance:CachedZoomInfo()
  if zoneInfo then
    self.ChatZone:SetActive(true)
    self:SetTitle(zoneInfo)
    self.itemContent:UpdateInfo(ChatZoomProxy.Instance:Message(), self.isLock)
    self.itemWrapName:UpdateInfo(ChatZoomProxy.Instance:GetMembers())
  else
    self.ChatZone:SetActive(false)
  end
end
function ChatZoneView:OnReceiveEnter(data)
  if self.container.CurrentState ~= ChatRoomEnum.CHATZONE then
    self.container:SwitchValue(ChatRoomEnum.CHATZONE)
  else
    self:UpdateChat()
  end
  self.container:ShowFade(false)
end
function ChatZoneView:OnReceiveChatMessage(data)
  if data == nil then
    return
  end
  if data.body:GetChannel() == self.curChannel then
    ChatZoomProxy.Instance:InQueueInputMessage(data.body)
    if self.isLock then
      if data.body:GetId() == Game.Myself.data.id then
        self.isLock = false
        self.unRead = 0
        self.itemContent:ResetPosition(ChatZoomProxy.Instance:Message())
      else
        self.unRead = self.unRead + 1
        self.itemContent:UpdateInfo(ChatZoomProxy.Instance:Message(), self.isLock)
      end
    else
      self.itemContent:UpdateInfo(ChatZoomProxy.Instance:Message(), self.isLock)
    end
    if self.unRead > 0 then
      self:ShowNewMessage()
    else
      self.NewMessage:SetActive(false)
    end
  end
end
function ChatZoneView:OnReceiveExistChatZoom(data)
  if data == nil then
    return
  end
  self.ChatZone:SetActive(false)
  self.container:SwitchLastState()
  self.container:ShowFade(true)
end
function ChatZoneView:OnReceiveMembersUpdate(data)
  if data == nil then
    return
  end
  self.itemWrapName:UpdateInfo(ChatZoomProxy.Instance:GetMembers())
  local zoomInfo = ChatZoomProxy.Instance:CachedZoomInfo()
  self:SetTitle(zoomInfo)
  if TipsView.Me().currentTip ~= nil then
    for i = 1, #data.body.updates do
      local member = data.body.updates[i]
      if member.id == self.tipID then
        self:ShowTip(member)
      end
    end
    for i = 1, #data.body.deletes do
      local member = data.body.deletes[i]
      if member == self.tipID then
        self:HideTip()
      end
    end
  end
end
function ChatZoneView:ShowTip(data)
  local playerData = PlayerTipData.new()
  playerData:SetByChatZoneMemberData(data)
  TableUtility.ArrayClear(self.funkey)
  if ChatZoomProxy.Instance:SelfIsHost() then
    if data.id ~= ChatZoomProxy.Instance:SelfID() then
      self.funkey = {
        "InviteMember",
        "KickChatMember",
        "ExchangeRoomOwner"
      }
    end
  elseif data.id ~= ChatZoomProxy.Instance:SelfID() then
    self.funkey = {
      "InviteMember"
    }
  end
  FunctionPlayerTip.Me():CloseTip()
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.Title, NGUIUtil.AnchorSide.Left, {-50, 0})
  local tipData = {
    playerData = playerData,
    funckeys = self.funkey
  }
  playerTip:SetData(tipData)
end
function ChatZoneView:HideTip()
  FunctionPlayerTip.Me():CloseTip()
end
function ChatZoneView:OnReceiveBeKicked(data)
  if data == nil then
    return
  end
  self.ChatZone:SetActive(false)
  self.container:SwitchLastState()
  self.container:ShowFade(true)
end
function ChatZoneView:OnReceiveTip(data)
  if data == nil then
    return
  end
  local tipInfoFromData = data.body
  ChatZoomProxy.Instance:InQueueTipMessage(ChatZoneData.new(tipInfoFromData))
  self.itemContent:UpdateInfo(ChatZoomProxy.Instance:Message(), self.isLock)
end
function ChatZoneView:OnButtonCloseClick()
  local data = ChatZoomProxy.Instance:CachedZoomInfo()
  ServiceChatRoomProxy.Instance:CallExitChatRoom(data.roomid, Game.Myself.data.id)
end
function ChatZoneView:HandleNewMessage()
  self:ResetNewMessage()
  self.itemContent:ResetPosition(ChatZoomProxy.Instance:Message())
end
function ChatZoneView:ResetNewMessage()
  self.isLock = false
  self.unRead = 0
  if self.NewMessage.activeSelf then
    self.NewMessage:SetActive(false)
  end
end
function ChatZoneView:ShowNewMessage()
  if not self.NewMessage.activeSelf then
    self.NewMessage:SetActive(true)
  end
  self.NewMessageLabel.text = tostring(self.unRead) .. ZhString.Chat_newMessage
end
function ChatZoneView:SendMessage(content, voice, voicetime)
  if ChatZoomProxy.Instance:IsInChatZone() then
    ServiceChatCmdProxy.Instance:CallChatCmd(self.curChannel, content, nil, voice, voicetime)
  else
    MsgManager.ShowMsgByIDTable(41)
  end
end
function ChatZoneView:HandleClickName(ctrl)
  if ctrl.data then
    if ctrl.data.id == Game.Myself.data.id then
      return
    end
    self:ShowTip(ctrl.data)
  end
end
function ChatZoneView:SetTitle(zoneInfo)
  self.TitleSL:Reset()
  local iconName = 70
  if zoneInfo.roomtype == SceneChatRoom_pb.ECHATROOMTYPE_PUBLIC then
    iconName = 69
  end
  local iconInfo = string.format("{uiicon=%s}", tostring(iconName))
  local title = iconInfo .. " " .. zoneInfo.name .. "(" .. #zoneInfo.members .. "/" .. zoneInfo.maxnum .. ")"
  self.TitleSL:SetText(title, true)
end
function ChatZoneView:HandleKeywordEffect(note)
  local datas = note.body
  if self.container.CurrentState ~= ChatRoomEnum.CHATZONE then
    return
  end
  if datas.message:GetChannel() ~= self.curChannel then
    return
  end
  self.container:AddKeywordEffect(datas.data)
end
function ChatZoneView:ResetTalk()
  self.container:SetVisible(true)
  ChatRoomProxy.Instance:SetCurrentChatChannel()
end
function ChatZoneView:ShowView(isShow)
  self.ChatZone:SetActive(isShow)
  self.container.ContentScrollView.gameObject:SetActive(isShow)
end
