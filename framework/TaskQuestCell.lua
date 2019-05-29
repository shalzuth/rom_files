local baseCell = autoImport("BaseCell")
autoImport("QuestData")
TaskQuestCell = class("TaskQuestCell", baseCell)
TaskQuestCell.FilterQuestStepType = {
  QuestDataStepType.QuestDataStepType_VISIT,
  QuestDataStepType.QuestDataStepType_KILL,
  QuestDataStepType.QuestDataStepType_COLLECT,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_GATHER,
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_SELFIE
}
local tempVector3 = LuaVector3.zero
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull
Color_disLabel = Color(0.8470588235294118, 0.7843137254901961, 0.615686274509804, 1)
Color_Desc = Color(0.803921568627451, 0.803921568627451, 0.803921568627451, 1)
TaskQuestCell.TraceBackgroundColor = {
  [6] = Color(0.6980392156862745, 0.03529411764705882, 0 / 255.0, 0.3),
  [5] = Color(0 / 255.0, 0.2549019607843137, 0.6980392156862745, 0.3),
  [1] = Color(0.6980392156862745, 0.03529411764705882, 0 / 255.0, 0.3),
  [2] = Color(0.21176470588235294, 0.5058823529411764, 0.6980392156862745, 0.2),
  [4] = Color(0.6431372549019608, 0.21176470588235294, 0.6980392156862745, 0.15),
  [3] = Color(0.21176470588235294, 0.6980392156862745, 0.24313725490196078, 0.15)
}
function TaskQuestCell:Init()
  self:initView()
  self:initData()
  self:initColor()
  OverseaHostHelper:FixLabelOverV1(self.disLabel, 3, 150)
  self.disLabel.spacingY = 1
  self.disLabel.fontSize = 17
end
function TaskQuestCell:initData()
  self.questType = -1
  self.isSelected = true
  self.bgSizeChanged = false
  self:setIsSelected(false)
  self:setIsOngoing(false)
  self.type = nil
  self.titleBg = nil
  self.iconStr = nil
  self.thumbBgStr = nil
  self.thumbStr = nil
end
function TaskQuestCell:AddLongPress()
  local long = self.bgSprite.gameObject:GetComponent(UILongPress)
  if long then
    function long.pressEvent(obj, isPress)
      if not self.data or self.data.type == QuestDataType.QuestDataType_SEALTR or self.data.type == QuestDataType.QuestDataType_ITEMTR or self.data.type == QuestDataType.QuestDataType_HelpTeamQuest or self.data.type == QuestDataType.QuestDataType_INVADE or self.data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
        return
      end
      if isPress then
        TipsView.Me():ShowStickTip(QuestDetailTip, self.data, NGUIUtil.AnchorSide.TopLeft, self.bgSprite, {0, 0})
      else
        TipsView.Me():HideTip(QuestDetailTip)
      end
    end
  end
end
function TaskQuestCell:initColor()
  self.desc.richLabel.color = Color_Desc
  self.disLabel.color = Color_disLabel
end
function TaskQuestCell:ChangeScale()
  if GameConfig and GameConfig.Quest and GameConfig.Quest.CircleScale then
    self.icon.transform.localScale = Vector3(GameConfig.Quest.CircleScale, GameConfig.Quest.CircleScale, GameConfig.Quest.CircleScale)
  end
end
function TaskQuestCell:initView()
  self.progress = self:FindGO("progress")
  if self.progress then
    self.slWidget = self.progress:GetComponent(UIWidget)
    self.progress = self.progress:GetComponent(UISlider)
    self.thumb = self:FindComponent("thumb", UISprite)
    self.thumbCt = self:FindGO("thumbCt")
    self.thumbBg = self:FindComponent("bg", UISprite, self.thumbCt)
    self.foreBg = self:FindComponent("forebg", UISprite, self.progress.gameObject)
    self.progressBg = self:FindComponent("bg", UISprite, self.progress.gameObject)
  end
  self.titleBgCt = self:FindGO("titleBgCt")
  self.content = self:FindGO("content")
  self.TitleCt = self:FindGO("TitleCt", self.content)
  self.TitleBackground = self:FindGO("TitleBackground", self.TitleCt)
  if self.TitleBackground then
    self.TitleBackground_UISprite = self.TitleBackground:GetComponent(UISprite)
  else
    helplog("if  self.TitleBackground then")
  end
  self.TitleIcon = self:FindGO("TitleIcon")
  if self.TitleIcon then
    self.TitleIcon_UISprite = self.TitleIcon:GetComponent(UISprite)
  end
  self.title = self:FindComponent("Title", UILabel)
  self.desc = self:FindComponent("Desc", UIRichLabel)
  self.desc = SpriteLabel.new(self.desc, nil, 20, 20)
  self.icon = self:FindComponent("Icon", UISprite)
  self:ChangeScale()
  self.bgSprite = self:FindComponent("bg", UISprite)
  self.disLabel = self:FindComponent("currentDisLb", UILabel)
  self.mainQuestSymbol = self:FindGO("mainQuestSymbol")
  local click = function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end
  self:SetEvent(self.bgSprite.gameObject, click)
  self.animSp = self:FindComponent("ShowAnimSp", UISprite)
  self.closeTrace = self:FindGO("CloseTrace")
  function click(obj)
    if self.data.type == QuestDataType.QuestDataType_ITEMTR then
      self:sendNotification(MainViewEvent.CancelItemTrace, {
        self.data.id
      })
    elseif self.data.type == QuestDataType.QuestDataType_HelpTeamQuest then
      self:sendNotification(QuestEvent.RemoveHelpQuest, {
        self.data.id
      })
    else
      QuestProxy.Instance:RemoveTraceCell(self.data.type, self.data.id)
    end
  end
  if self.closeTrace then
    self:SetEvent(self.closeTrace, click)
  end
  self.selectorSp = self:FindGO("selector"):GetComponent(UISprite)
  local press = function(obj, isPress)
    self:setIsSelected(isPress)
  end
  self:AddPressEvent(self.bgSprite.gameObject, press)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  function objLua.onEnable()
    if QuestProxy.Instance:checkIsShowDirAndDis(self.data) then
      self:resetBgSize(true)
    else
      self:resetBgSize(false)
    end
  end
  self.disObj = self.disLabel.gameObject
  self.disObjTrans = self.disObj.transform
  self.richObjTrans = self.desc.richLabel.gameObject.transform
  self.progressObj = self.progress.gameObject
  self:AddLongPress()
end
function TaskQuestCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.selectorSp.color = Color(1, 1, 1, 1)
    else
      self.selectorSp.color = Color(1, 1, 1, 0.00392156862745098)
    end
  end
end
function TaskQuestCell:ShowAnimSp()
  if self.animSp then
    self:Show(self.animSp.gameObject)
  end
end
function TaskQuestCell:HideAnimSp()
  if self.animSp then
    self:Hide(self.animSp.gameObject)
  end
end
function TaskQuestCell:setISShowDir(value)
  self.isShowDir = value
  if value then
    self:Show(self.icon.gameObject)
    if self.data.type == QuestDataType.QuestDataType_HelpTeamQuest then
      self:SetMyIconByServer("Rewardtask_icon_team")
    else
      self:SetMyIconByServer("icon_39")
    end
    self:ChangeScale()
  else
    self:Hide(self.icon.gameObject)
    local disStr = self:GetShowMap()
    self.disLabel.text = disStr
  end
end
function TaskQuestCell:GetIsShowDir()
  return self.isShowDir
end
function TaskQuestCell:GetShowMap(data)
  data = data or self.data
  local tarMap = data.map
  tarMap = tarMap or Game.MapManager:GetMapID()
  local mapData = Table_Map[tarMap]
  local toMap = "..."
  if mapData then
    toMap = mapData.CallZh
  end
  local disStr = string.format(ZhString.TaskQuestCell_Dis, tostring(toMap))
  return disStr
end
function TaskQuestCell:checkShowDisAndIcon(data)
  if QuestProxy.Instance:checkIsShowDirAndDis(data) then
    self:Hide(self.icon.gameObject)
    self:Show(self.disLabel.gameObject)
    local disStr = self:GetShowMap(data)
    self.disLabel.text = disStr
    self:resetBgSize(true)
    self.icon.width = 30
    self.icon.height = 27
  else
    if (data.type == QuestDataType.QuestDataType_INVADE or data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO) and data.icon then
      if self.iconStr ~= data.icon then
        self:Show(self.icon.gameObject)
        self:SetMyIconByServer(data.icon)
        self.icon:MakePixelPerfect()
      end
    else
      self:Hide(self.icon.gameObject)
    end
    self:Hide(self.disLabel.gameObject)
    self:resetBgSize(false)
  end
end
function TaskQuestCell:setIsOngoing(isOngoing)
  if self.isOngoing ~= isOngoing then
    self.isOngoing = isOngoing
    if isOngoing then
      self.title.color = Color(1, 0.7725490196078432, 0.0784313725490196, 1)
    else
      self.title.color = Color(1, 1, 1, 1)
    end
  end
end
function TaskQuestCell:AdjustRelatedComp(data)
  if data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and self.type ~= data.type then
    local name = data.traceTitle
    local desStr = data:parseTranceInfo()
    self.title.pivot = UIWidget.Pivot.Left
    tempVector3:Set(getlocalPos(self.title.transform))
    tempVector3:Set(41.5, tempVector3.y, tempVector3.z)
    self.title.transform.localPosition = tempVector3
    tempVector3:Set(getlocalPos(self.icon.transform))
    tempVector3:Set(22, tempVector3.y, tempVector3.z)
    self.icon.transform.localPosition = tempVector3
    tempVector3:Set(getlocalPos(self.desc.richLabel.transform))
    tempVector3:Set(45.6, tempVector3.y, tempVector3.z)
    self.desc.richLabel.transform.localPosition = tempVector3
    self.desc.richLabel.width = 154
    self:Hide(self.titleBgCt.gameObject)
  end
  if self.progress and data.type ~= QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and data.type ~= QuestDataType.QuestDataType_INVADE and self.type ~= data.type then
    self:Hide(self.progress.gameObject)
    self:Hide(self.thumbCt.gameObject)
  end
  if self.closeTrace then
    if data.type ~= QuestDataType.QuestDataType_HelpTeamQuest and data.type ~= QuestDataType.QuestDataType_ITEMTR then
      if self.type ~= data.type then
        self:Hide(self.closeTrace)
      end
    elseif self.type ~= data.type then
      self:Show(self.closeTrace)
    end
  end
end
function TaskQuestCell:SetData(data)
  if data == nil then
    return
  end
  self.disLabel.text = ""
  self:Hide(self.TitleIcon)
  self.IconFromServer = nil
  self.ColorFromServer = nil
  local name = data.traceTitle
  local desStr = data:parseTranceInfo()
  self:AdjustRelatedComp(data)
  self:setIsOngoing(false)
  local disY = 0
  local distPos = 0
  if data.type == QuestDataType.QuestDataType_DAILY then
    local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
    local ratio = "0%"
    local exp = "0"
    if dailyData then
      ratio = dailyData.param4 * 100
      ratio = ratio .. "%"
      exp = dailyData.param3
    end
    name = string.format(name, ratio)
    desStr = string.format(desStr, exp)
  elseif data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
    self:UpActivityTraceView(data)
  elseif data.type == QuestDataType.QuestDataType_INVADE then
    self:UpInvadeTraceView(data)
  end
  if self.mainQuestSymbol and data.type == QuestDataType.QuestDataType_MAIN and MyselfProxy.Instance:RoleLevel() >= 80 then
    self:Show(self.mainQuestSymbol)
  else
    self:Hide(self.mainQuestSymbol)
  end
  self:Show(self.icon.gameObject)
  self.title.text = name
  if StringUtil.ChLength(name) > 18 then
    self.title.fontSize = 18
  else
    self.title.fontSize = 20
  end
  self.title.fontSize = self.title.fontSize - 3
  UIUtil.WrapLabel(self.title)
  desStr = desStr or ""
  self.desc:SetText(desStr)
  self:checkShowDisAndIcon(data)
  self.data = data
  self.titleBg = data.titleBg
  self.iconStr = data.icon
  if data.staticData and data.staticData.IconFromServer then
    self.IconFromServer = data.staticData.IconFromServer
  end
  if data.staticData and data.staticData.ColorFromServer then
    self.ColorFromServer = data.staticData.ColorFromServer
  end
  self.thumbBgStr = data.thumbBg
  self.thumbStr = data.thumb
  self.type = data.type
  self:initColor()
  self:SeperateQuestDataType(data.type)
  self:ShowTaskIcon()
  self:ShowTaskBackGround()
end
function TaskQuestCell:GetIconFromSever()
  return self.IconFromServer or 0
end
function TaskQuestCell:ShowTaskIcon()
  if self.IconFromServer and self.IconFromServer ~= 0 then
    if GameConfig and GameConfig.Quest and GameConfig.Quest.TraceIcon and GameConfig.Quest.TraceIcon[self.IconFromServer] then
      local atlasStr = GameConfig.Quest.TraceIcon[self.IconFromServer][2]
      local spriteNameStr = GameConfig.Quest.TraceIcon[self.IconFromServer][1]
      local iconScale = GameConfig.Quest.TraceIcon[self.IconFromServer][3]
      local needMakePixelPerfect = GameConfig.Quest.TraceIcon[self.IconFromServer][4]
      if atlasStr and spriteNameStr then
        local atlasConfigTable = UIAtlasConfig.IconAtlas[atlasStr]
        if atlasConfigTable then
          IconManager:SetIcon(spriteNameStr, self.TitleIcon_UISprite, atlasConfigTable)
          self:Show(self.TitleIcon)
          if needMakePixelPerfect then
            self.TitleIcon_UISprite:MakePixelPerfect()
          end
          if iconScale then
            self.TitleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
          elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
            self.TitleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
          end
          return
        end
        local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
        if ui1Atlas == nil then
          helplog("\232\175\183\228\187\187\229\138\161\232\191\189\232\184\170\230\161\134\231\173\150\229\136\146\231\161\174\232\174\164 \230\178\161\230\156\137\229\155\190\233\155\134\239\188\129" .. atlasStr)
          self:Hide(self.TitleIcon)
          return
        end
        self.TitleIcon_UISprite.atlas = ui1Atlas
        self.TitleIcon_UISprite.spriteName = spriteNameStr
        self:Show(self.TitleIcon)
        if needMakePixelPerfect then
          self.TitleIcon_UISprite:MakePixelPerfect()
        end
        if iconScale then
          self.TitleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
        elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
          self.TitleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
        end
        return
      else
        helplog("\233\152\178\229\190\161:\232\175\183\228\187\187\229\138\161\232\191\189\232\184\170\230\161\134\231\173\150\229\136\146\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168:\233\133\141\231\189\174\232\161\168GameConfig.Quest.TraceIcon\229\135\186\233\148\153:self.IconFromServer:" .. self.IconFromServer)
      end
    else
      helplog("\233\152\178\229\190\161:\232\175\183\228\187\187\229\138\161\232\191\189\232\184\170\230\161\134\231\173\150\229\136\146\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168:\233\133\141\231\189\174\232\161\168GameConfig.Quest.TraceIcon\229\135\186\233\148\153:self.IconFromServer:" .. self.IconFromServer)
    end
  end
  self:Hide(self.TitleIcon)
end
function TaskQuestCell:ShowTaskBackGround()
  if self.ColorFromServer and self.ColorFromServer ~= 0 then
    if GameConfig and GameConfig.Quest and GameConfig.Quest.TraceBackgroundColor and GameConfig.Quest.TraceBackgroundColor[self.ColorFromServer] then
      local ui1Atlas = RO.AtlasMap.GetAtlas("NewUI4")
      if ui1Atlas then
        self.TitleBackground_UISprite.atlas = ui1Atlas
        self.TitleBackground_UISprite.spriteName = "main_task_bg2_00"
        self.TitleBackground_UISprite.color = TaskQuestCell.TraceBackgroundColor[self.ColorFromServer]
        self:Show(self.TitleBackground)
        return
      else
        helplog("\233\152\178\229\190\161: NewUI4 \230\178\161\228\186\134")
      end
    else
      helplog("\233\152\178\229\190\161:\232\175\183\228\187\187\229\138\161\232\191\189\232\184\170\230\161\134\231\173\150\229\136\146\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168:\233\133\141\231\189\174\232\161\168 GameConfig.Quest.TraceBackgroundColor" .. self.ColorFromServer)
    end
  end
  self:Hide(self.TitleBackground)
end
function TaskQuestCell:SeperateQuestDataType(mType)
  self:Hide(self.mainQuestSymbol)
  local bShowTitleBgCt = false
  if mType == QuestDataType.QuestDataType_MAIN then
    bShowTitleBgCt = true
  elseif mType == QuestDataType.QuestDataType_BRANCH then
  elseif mType == QuestDataType.QuestDataType_DAILY then
  elseif mType == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
    bShowTitleBgCt = true
  end
  if bShowTitleBgCt then
    self:Hide(self.titleBgCt)
  else
  end
end
function TaskQuestCell:UpActivityTraceView(data)
  if data.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO and (not self.data or self.data.type ~= data.type) then
    self.title.pivot = UIWidget.Pivot.Center
    tempVector3:Set(getlocalPos(self.title.transform))
    tempVector3:Set(118, tempVector3.y, tempVector3.z)
    self.title.transform.localPosition = tempVector3
    tempVector3:Set(getlocalPos(self.icon.transform))
    tempVector3:Set(35.44, tempVector3.y, tempVector3.z)
    self.icon.transform.localPosition = tempVector3
    tempVector3:Set(getlocalPos(self.desc.richLabel.transform))
    tempVector3:Set(14, tempVector3.y, tempVector3.z)
    self.desc.richLabel.transform.localPosition = tempVector3
    self.desc.richLabel.width = 185
  end
  if self.titleBgCt and data.titleBg and self.titleBg ~= data.titleBg then
    self:Show(self.titleBgCt)
  end
  if self.progress and data.process and not self.progressObj.activeSelf then
    self:Show(self.progress.gameObject)
    self:Show(self.thumbCt)
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
  end
  if not data.process and self.progressObj.activeSelf then
    self:Hide(self.progress.gameObject)
    self:Hide(self.thumbCt)
  end
  if self.progress and data.process then
    self.progress.value = data.process
    if data.thumb and data.thumb ~= "" or data.thumbBg and data.thumbBg ~= "" then
      if data.thumb then
        self:Show(self.thumb.gameObject)
        if data.thumb ~= self.thumbStr then
          IconManager:SetUIIcon(data.thumb, self.thumb)
          self.thumb:MakePixelPerfect()
        end
      else
        self:Hide(self.thumb.gameObject)
      end
      if data.thumbBg then
        self:Show(self.thumbBg.gameObject)
        if data.thumbBg ~= self.thumbBgStr then
          IconManager:SetUIIcon(data.thumbBg, self.thumbBg)
          self.thumbBg:MakePixelPerfect()
        end
      else
        self:Hide(self.thumbBg.gameObject)
      end
    else
      self:Hide(self.thumbCt)
    end
    if data.foreBg and data.foreBg ~= "" then
      self.foreBg.spriteName = data.foreBg
    end
    if data.progressBg and data.progressBg ~= "" then
      self.progressBg.spriteName = data.progressBg
    end
  end
end
function TaskQuestCell:UpInvadeTraceView(data)
  if self.progress and data.process and not self.progressObj.activeSelf then
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
    self:Show(self.progress.gameObject)
    self:Show(self.thumbCt)
  end
  if self.progress and data.process then
    self.progress.value = data.process
    if data.thumb then
      self:Show(self.thumb.gameObject)
      if data.thumb ~= self.thumbStr then
        IconManager:SetUIIcon(data.thumb, self.thumb)
        self.thumb:MakePixelPerfect()
      end
    else
      self:Hide(self.thumb.gameObject)
    end
    if data.thumbBg then
      self:Show(self.thumbBg.gameObject)
      if data.thumbBg ~= self.thumbBgStr then
        IconManager:SetUIIcon(data.thumbBg, self.thumbBg)
        self.thumbBg:MakePixelPerfect()
      end
    else
      self:Hide(self.thumbBg.gameObject)
    end
  end
end
function TaskQuestCell:resetBgSize(showDistance)
  self.bgSizeChanged = false
  if isNil(self.disLabel) then
    return
  end
  if isNil(self.disObj) then
    return
  end
  tempVector3:Set(getlocalPos(self.disObjTrans))
  local _, y, _ = getlocalPos(self.richObjTrans)
  local deshg = self.desc.richLabel.height
  y = y - deshg - 14
  tempVector3:Set(tempVector3.x, y, tempVector3.z)
  self.disObjTrans.localPosition = tempVector3
  local height = calSize(self.content.transform)
  height = height.size.y
  height = height + 4
  local originHeight = self.bgSprite.height
  if math.abs(originHeight - height) > 2 then
    self.bgSizeChanged = true
    if self.slWidget then
      self.slWidget:ResetAndUpdateAnchors()
    end
  end
  self.bgSprite.height = height
  height = height + 8
  self.selectorSp.height = height
  self.animSp.height = height + 4
end
function TaskQuestCell:SetMyIconByServer(OriginName)
  IconManager:SetUIIcon(OriginName, self.icon)
end
function TaskQuestCell:Update(teleData)
  if not self.disLabel then
    return
  end
  local distance = teleData.distance
  local toMap = teleData.toMap
  local disStr
  if distance then
    local str = ZhString.TaskQuestCell_Dis .. "M"
    disStr = string.format(str, tostring(distance))
  elseif toMap then
    disStr = string.format(ZhString.TaskQuestCell_Dis, tostring(toMap))
  else
    disStr = string.format(ZhString.TaskQuestCell_Dis, "...")
  end
  if disStr ~= "" then
    self.disLabel.text = disStr
    self:resetBgSize(true)
  end
end
function TaskQuestCell:OnExit()
  FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)
  self.type = nil
  self.titleBg = nil
  self.iconStr = nil
  self.thumbBgStr = nil
  self.thumbStr = nil
  self.IconFromServer = nil
  self.ColorFromServer = nil
  TaskQuestCell.super.OnExit(self)
end
function TaskQuestCell:OnRemove()
  FunctionQuestDisChecker.RemoveQuestCheck(self.data.id)
end
