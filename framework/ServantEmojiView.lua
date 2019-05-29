ServantEmojiView = class("ServantEmojiView", ContainerView)
ServantEmojiView.ViewType = UIViewType.ChatLayer
autoImport("UIEmojiCell")
function ServantEmojiView:Init()
  self:InitView()
  self:MapViewInterest()
end
function ServantEmojiView:InitView()
  self.bord = self:FindGO("Bord")
  local emojiGrid = self:FindComponent("EmojiGrid", UIGrid)
  self.emojiCtl = UIGridListCtrl.new(emojiGrid, UIEmojiCell, "UIEmojiCell")
  self.emojiCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
end
function ServantEmojiView:ClickCell(cellctl)
  if cellctl.type == UIEmojiType.Action then
    local sdata = Table_ActionAnime[cellctl.id]
    self:PlayAction(sdata.Name)
  elseif cellctl.type == UIEmojiType.Emoji then
    local roleid = self.servantId
    self:sendNotification(EmojiEvent.PlayEmoji, {
      roleid = roleid,
      emoji = cellctl.id
    })
  end
end
function ServantEmojiView:OnEnter()
  ServantEmojiView.super.OnEnter(self)
  self:UpdateData()
end
function ServantEmojiView:UpdateData()
  if not self.data then
    self.data = {}
  else
    TableUtility.ArrayClear(self.data)
  end
  local actionList = GameConfig.Servant.ActionAnimeList
  for i = 1, #actionList do
    local actionData = Table_ActionAnime[actionList[i]]
    if actionData then
      local actionCellData = {}
      actionCellData.type = UIEmojiType.Action
      actionCellData.id = actionData.id
      actionCellData.name = actionData.Name
      table.insert(self.data, actionCellData)
    end
  end
  local emojiMap = GameConfig.Servant.ExpressionList
  if emojiMap then
    for _, expressData in pairs(Table_Expression) do
      if expressData.Type == "1" or expressData.Type == "2" and emojiMap[expressData.id] then
        local emojiCellData = {}
        emojiCellData.type = UIEmojiType.Emoji
        emojiCellData.id = expressData.id
        emojiCellData.name = expressData.NameEn
        table.insert(self.data, emojiCellData)
      end
    end
  end
  table.sort(self.data, function(a, b)
    if a.type ~= b.type then
      return a.type < b.type
    end
    return a.id < b.id
  end)
  self.emojiCtl:ResetDatas(self.data)
  self.servant = self.viewdata.npc
  self.servantId = self.viewdata.npcId
end
function ServantEmojiView:MapViewInterest()
end
function ServantEmojiView:OnExit()
  local cells = self.emojiCtl:GetCells()
  for i = 1, #cells do
    cells[i]:OnRemove()
  end
  ServantEmojiView.super.OnExit(self)
end
function ServantEmojiView:PlayAction(actionName)
  local animParams = Asset_Role.GetPlayActionParams(actionName, nil, 1)
  animParams[5] = true
  animParams[6] = true
  if self.servant then
    self.servant:PlayActionRaw(animParams, true)
  end
end
