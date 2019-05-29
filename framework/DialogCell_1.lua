local BaseCell = autoImport("BaseCell")
DialogCell = class("DialogCell", BaseCell)
function DialogCell:Init()
  self:FindObjs()
end
function DialogCell:FindObjs()
  self.namelabel = self:FindGO("NpcNameLabel"):GetComponent(UILabel)
  self.contentlabel = self:FindGO("DialogContent"):GetComponent(UILabel)
  self.continue = self:FindGO("continueSymbol")
  self.viceContentLabel = self:FindComponent("DialogViceContent", UILabel)
  local bgClick = self:FindGO("BgClick")
  if bgClick then
    local bgSprite = bgClick:GetComponent(UISprite)
    bgSprite.height = GameObjectUtil.Instance:GetUIActiveHeight(bgClick)
    self:SetEvent(bgClick, function(go)
      self:ClickCell()
    end, {hideClickSound = true})
  end
end
function DialogCell:ClickCell()
  if self.leftStr == nil then
    self:PassEvent(MouseEvent.MouseClick)
    return
  end
  if self.cpyData == nil then
    self.cpyData = {}
  else
    TableUtility.TableClear(self.cpyData)
  end
  for k, v in pairs(self.data) do
    self.cpyData[k] = v
  end
  self.cpyData.Text = self.leftStr
  self:SetData(self.cpyData)
end
function DialogCell:SetData(dialogData, params)
  self.data = dialogData
  if dialogData then
    local speakerID = dialogData.Speaker or 0
    if speakerID == 0 then
      self.namelabel.text = Game.Myself.data.name
      speakerID = Game.Myself.data.id
    elseif Table_Npc[dialogData.Speaker] then
      self.namelabel.text = Table_Npc[dialogData.Speaker].NameZh
      speakerID = dialogData.Speaker
    elseif Table_Monster[dialogData.Speaker] then
      self.namelabel.text = Table_Monster[dialogData.Speaker].NameZh
      speakerID = dialogData.Speaker
    end
    if speakerID then
      if dialogData.Emoji and dialogData.Emoji ~= 0 then
        self:PlayEmoji(speakerID, dialogData.Emoji)
      end
      if dialogData.Action and dialogData.Action.actionid then
        self:PlayAction(speakerID, dialogData.Action.actionid, dialogData.Action.num)
      end
      if dialogData.Voice and dialogData.Voice ~= "" then
        AudioUtil.PlayNpcVisitVocal(dialogData.Voice)
      end
    end
    local context = self:GetDialogText(dialogData)
    if context == "" then
      self:Hide(self.gameObject)
    else
      self:Show(self.gameObject)
      if params and #params > 0 then
        for k, v in pairs(params) do
          if string.match(v, "\227\128\129") then
            local t = StringUtil.Split(v, "\227\128\129")
            for k, v in pairs(t) do
              t[k] = OverSea.LangManager.Instance():GetLangByKey(v)
            end
            params[k] = table.concat(t, "\227\128\129")
          end
        end
        context = self:_ReplaceQuestParams(context, params)
      end
      self:SetContext(context)
      if dialogData.Speaker == 1024 and dialogData.id == 2251 then
        OverSeas_TW.OverSeasManager.GetInstance():TrackEvent("k5g4pt")
      end
      if not dialogData.NoSpeak then
        self:PlayerSpeak(speakerID, context)
      end
    end
    if self.viceContentLabel then
      if dialogData.ViceText then
        self.viceContentLabel.text = dialogData.ViceText
        self.viceContentLabel.gameObject:SetActive(true)
      else
        self.viceContentLabel.gameObject:SetActive(false)
      end
    end
  end
end
local _Dialog_ReplaceParam = Dialog_ReplaceParam
function DialogCell:GetDialogText(dialogData)
  local out_text = MsgParserProxy.Instance:TryParse(dialogData.Text or "")
  if dialogData.id == nil or _Dialog_ReplaceParam == nil then
    return out_text
  end
  local cfg = _Dialog_ReplaceParam[dialogData.id]
  if cfg == nil then
    return out_text
  end
  local params = {}
  for i = 1, #cfg do
    table.insert(params, self:ParseReplaceParam(cfg[i]))
  end
  return string.format(out_text, unpack(params))
end
local ReplaceParam_FuncMap = {}
local DialogParamType_StoragePrice = DialogParamType and DialogParamType.StoragePrice or "111"
ReplaceParam_FuncMap[DialogParamType_StoragePrice] = function()
  local isFree = ActivityEventProxy.Instance:IsStorageFree()
  if isFree then
    return 0
  end
  local free_actid = GameConfig.System.warehouse_free_activityid
  if free_actid then
    local running = FunctionActivity.Me():IsActivityRunning(free_actid)
    if running then
      return 0
    end
  end
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.GuildDonate)
  return GameConfig.System.warehouseZeny
end
function DialogCell:ParseReplaceParam(param)
  local func = ReplaceParam_FuncMap[param]
  if func then
    return ReplaceParam_FuncMap[param]()
  end
  return ""
end
local QuestParamPattern = "%[QuestParam%]"
function DialogCell:_ReplaceQuestParams(text, params)
  local resultStr = string.gsub(text, QuestParamPattern, function()
    return table.remove(params, 1) or ""
  end)
  return resultStr
end
function DialogCell:SetContext(text)
  self.contentlabel.text = text
  local newText = self.contentlabel.text
  local bWrap, leftStr = OverseaHostHelper:GetWrapLeftStringTextLua(self.contentlabel, newText)
  if not bWrap then
    self.leftStr = leftStr
  else
    self.leftStr = nil
  end
end
function DialogCell:GetNearNpc(id)
  local myPos = Game.Myself:GetPosition()
  return NSceneNpcProxy.Instance:FindNearestNpc(myPos, id)
end
function DialogCell:PlayerSpeak(id, text)
  local role = self:GetNearNpc(id)
  if role then
    role:GetSceneUI().roleTopUI:Speak(text)
  end
end
function DialogCell:PlayEmoji(id, emojiId)
  local role = self:GetNearNpc(id)
  if role then
    role:GetSceneUI().roleTopUI:PlayEmojiById(emojiId)
  end
end
function DialogCell:PlayAction(id, actionId, num)
  local role = self:GetNearNpc(id)
  if role then
    num = num or 1
    local actionName = Table_ActionAnime[actionId] and Table_ActionAnime[actionId].Name
    role:Client_PlayAction(actionName, nil, false)
  end
end
function DialogCell:Set_UpdateSetTextCall(updateSetTextCall, updateSetTextCallParam)
  local remove, text = updateSetTextCall(updateSetTextCallParam)
  self:SetContext(text)
  if not remove then
    self.updateSetTextCall = updateSetTextCall
    self.updateSetTextCallParam = updateSetTextCallParam
    self.updateSetTick = TimeTickManager.Me():CreateTick(0, 1000, self._updateSetTick, self)
  end
end
function DialogCell:_updateSetTick()
  if self.updateSetTextCall then
    local remove, text = self.updateSetTextCall(self.updateSetTextCallParam)
    self:SetContext(text)
    if remove then
      self:RemoveUpdateSetTick()
    end
  end
end
function DialogCell:RemoveUpdateSetTick()
  if self.updateSetTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateSetTick = nil
  end
end
function DialogCell:OnExit()
  self:RemoveUpdateSetTick()
end
