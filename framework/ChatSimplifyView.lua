ChatSimplifyView = class("ChatSimplifyView", SubView)
local dotNormal = Color(1, 1, 1, 0.5)
function ChatSimplifyView:Init(initParama)
  self.gameObject = initParama.gameObject
  self:FindObj()
  self:AddEvt()
  self:AddViewEvt()
  self:InitShow(initParama)
end
function ChatSimplifyView:FindObj()
  self.chatGrid = self:FindGO("ChatGrid"):GetComponent(UIGrid)
  self.chatCenterOnChild = self.chatGrid.gameObject:GetComponent("UICenterOnChild")
end
function ChatSimplifyView:AddEvt()
  function self.chatCenterOnChild.onCenter(centeredObject)
    self.lastDotSp.color = dotNormal
    for i = 1, #self.chatCtl:GetCells() do
      local cell = self.chatCtl:GetCells()[i]
      if cell.gameObject == centeredObject then
        local dot = self.chatInfoList[cell.data].dot
        ColorUtil.WhiteUIWidget(dot)
        self.lastDotSp = dot
        ChatRoomProxy.Instance:SetCurrentChatChannel(cell.data)
        return
      end
    end
  end
end
function ChatSimplifyView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.ChatCmdChatRetCmd, self.UpdateChatRoom)
  self:AddListenEvt(ChatRoomEvent.ChangeChannel, self.ChangeChannel)
  self:AddListenEvt(ChatRoomEvent.SystemMessage, self.UpdateChatRoom)
end
function ChatSimplifyView:InitShow(initParama)
  self.chatInfoList = {}
  self.chatCtl = UIGridListCtrl.new(self.chatGrid, initParama.chatCellCtrl, initParama.chatCellPfb)
  self:UpdateChat()
  for i = 1, #self.chatCtl:GetCells() do
    local cell = self.chatCtl:GetCells()[i]
    local channel = GameConfig.ChatRoom.MainView[i]
    if channel then
      if self.chatInfoList[channel] == nil then
        self.chatInfoList[channel] = {}
      end
      self.chatInfoList[channel].cell = cell
    end
  end
  local dotTable = self:FindGO("DotTable"):GetComponent(UITable)
  local dotAll = self:FindGO("ChatDotCell1"):GetComponent(UISprite)
  self.chatInfoList[ChatChannelEnum.All].dot = dotAll
  for i = 2, #GameConfig.ChatRoom.MainView do
    local name = "ChatDotCell"
    local dot = self:LoadCellPfb(name, name .. i, dotTable.gameObject)
    local dotSprite = dot:GetComponent(UISprite)
    local channel = GameConfig.ChatRoom.MainView[i]
    self.chatInfoList[channel].dot = dotSprite
  end
  dotTable:Reposition()
  ColorUtil.WhiteUIWidget(dotAll)
  self.lastDotSp = dotAll
end
function ChatSimplifyView:UpdateChat()
  self.chatCtl:ResetDatas(GameConfig.ChatRoom.MainView)
end
function ChatSimplifyView:UpdateChatRoom(note)
  if note then
    local data = note.body
    if data then
      self:UpdateChatByChannel(data:GetChannel())
    end
  end
end
function ChatSimplifyView:UpdateChatByChannel(channel)
  local cellList = self.chatCtl:GetCells()
  cellList[1]:SetData(GameConfig.ChatRoom.MainView[1])
  for i = 1, #cellList do
    local cell = cellList[i]
    if cell.data and cell.data == channel then
      cell:Update()
    end
  end
end
function ChatSimplifyView:ChangeChannel()
  local channel = ChatRoomProxy.Instance:GetScrollScreenChannel()
  local cell = self:GetCellByChannel(channel)
  if cell then
    self.chatCenterOnChild:CenterOn(cell.trans)
  end
end
function ChatSimplifyView:GetCellByChannel(channel)
  if self.chatInfoList[channel] then
    return self.chatInfoList[channel].cell
  end
  return nil
end
function ChatSimplifyView:LoadCellPfb(cellPfb, cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPfb))
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.name = cName
  return cellpfb
end
