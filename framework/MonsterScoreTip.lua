autoImport("BaseTip")
MonsterScoreTip = class("MonsterScoreTip", BaseView)
autoImport("TipLabelCell")
autoImport("Table_MonsterOrigin")
autoImport("UIModelShowConfig")
autoImport("AdvTipRewardCell")
autoImport("AdventureAppendCell")
autoImport("AdventureBaseAttrCell")
autoImport("AdventureDropCell")
MonsterScoreTip.QualityMap = {
  Monster = "com_tips_1",
  MINI = "com_tips_4",
  MVP = "com_tips_5"
}
local tempVector3 = LuaVector3.zero
function MonsterScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("MonsterScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = Vector3.zero
  self:Init()
end
function MonsterScoreTip:adjustPanelDepth(startDepth)
  local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end
function MonsterScoreTip:Init()
  self.monstername = self:FindComponent("MonsterName", UILabel)
  self.qualitybg = self:FindComponent("QualityBg", UISprite)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.photosprite = self:FindComponent("PhotoSprite", UISprite)
  self.cardsprite = self:FindComponent("CardSprite", UISprite)
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.unlockBord = self:FindGO("UnLockBord")
  self.locksymbol = self:FindGO("Lock")
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell")
  grid = self:FindComponent("BaseAttrGrid", UIGrid)
  local monsterBord = self:FindGO("MonsterSpecial")
  self.mclabel = TipLabelCell.new(self:FindGO("TipLabelCell", monsterBord))
  local modelBg = self:FindGO("ModelBg")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  self.monsterSpecial = self:FindGO("MonsterSpecial")
  self.chatacterBtn = self:FindGO("ChatacterBtn")
  local btnText = self:FindComponent("Label", UILabel, self.chatacterBtn)
  btnText.text = ZhString.MonsterTip_CharacteristicDetail
  OverseaHostHelper:FixLabelOverV1(btnText, 3, 80)
  self:AddClickEvent(self.chatacterBtn, function(go)
    if self.data.attrUnlock then
      self.monsterSpecial:SetActive(not self.monsterSpecial.activeSelf)
    else
    end
  end)
  local appTb = self:FindComponent("AppendTable", UITable)
  self.appCtl = UIGridListCtrl.new(appTb, AdventureAppendCell, "AdventureAppendCell")
  self.baseAttrCt = self:FindGO("BaseAttrCt")
  self.baseAttrCtTitle = self:FindComponent("title", UILabel, self.baseAttrCt)
  self.baseAttrCtTitle.text = ZhString.MonsterTip_PropertyTitle
  self.baseAttrCtGrid = self:FindComponent("Grid", UIGrid, self.baseAttrCt)
  self.baseAttrCtGrid = UIGridListCtrl.new(self.baseAttrCtGrid, AdventureBaseAttrCell, "AdventureBaseAttrCell")
  self.featureCt = self:FindGO("FeatureCt")
  local featureTitle = self:FindComponent("title", UILabel, self.featureCt)
  featureTitle.text = ZhString.MonsterTip_SpecialTitle
  self.fallCt = self:FindGO("FallCt")
  self.fallCtTitle = self:FindComponent("title", UILabel, self.fallCt)
  self.fallCtTitle.text = ZhString.MonsterTip_DropTitle
  self.fallCtGrid = self:FindComponent("Grid", UIGrid, self.fallCt)
  self.fallCtGrid = UIGridListCtrl.new(self.fallCtGrid, AdventureDropCell, "AdventureDropCell")
  self.EmptyDropLabel = self:FindComponent("EmptyDrop", UILabel)
  self.EmptyDropLabel.text = ZhString.MonsterTip_WDBossDropTitle
  local monoComp = self.gameObject:GetComponent(RelateGameObjectActive)
  if monoComp then
    function monoComp.enable_Call()
      self:OnEnable()
    end
    function monoComp.disable_Call()
      self:OnDisable()
    end
  end
  self:initLockBord()
  self.MonstPro = self:FindComponent("MonstPro", UISprite)
  self.UnlockReward = self:FindGO("UnlockReward")
  self:Hide(self.EmptyDropLabel.gameObject)
end
function MonsterScoreTip:adjustLockRewardPos()
  self:Hide(self.UnlockReward)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.UnlockReward.transform)
  local pos = self.UnlockReward.transform.localPosition
  local y = pos.y - bound.size.y
  self.table.transform.localPosition = Vector3(pos.x, y, pos.z)
end
function MonsterScoreTip:initLockBord()
  local obj = self:FindGO("LockBord")
  self.lockBord = self:FindGO("LockBordHolder")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    obj.name = "LockBord"
  end
  obj.transform.localPosition = Vector3.zero
  obj.transform.localScale = Vector3.one
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  local LockTitle = self:FindComponent("LockTitle", UILabel)
  LockTitle.text = ZhString.MonsterTip_LockTitle
  local LockReward = self:FindComponent("LockReward", UILabel)
  LockReward.text = ZhString.MonsterTip_LockReward
  self.fixedAttrLabel = self:FindComponent("fixedAttrLabel", UILabel)
  local fixLabelCt = self:FindComponent("fixLabelCt", UILabel)
  fixLabelCt.text = ZhString.MonsterTip_FixAttrCt
  self.FixAttrCt = self:FindGO("FixAttrCt")
  self:Hide(self.FixAttrCt)
  local grid = self:FindComponent("LockInfoGrid", UIGrid)
  self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell")
  self.modelBottombg = self:FindGO("modelBottombg")
end
function MonsterScoreTip:SetData(monsterData)
  self.data = monsterData
  self:initData()
  self:SetLockState()
  self:UpdateTopInfo()
  self:UpdateAttriText()
  self:UpdateAppendData()
  self:UpdateFeatureData()
  self:adjustPanelDepth(4)
  self:adjustLockRewardPos()
end
function MonsterScoreTip:UpdateFeatureData()
  local originActive = self.monsterSpecial.activeSelf
  if not originActive then
    self:Show(self.monsterSpecial)
  end
  local sdata = self.data.staticData
  local attrs = {}
  local propMap = UserProxy.Instance.creatureProps
  local templab
  for i = 1, #GameConfig.MonsterShowType do
    local key = GameConfig.MonsterShowType[i]
    if key == "Hp" then
      templab = {}
      templab.name = "HP"
      templab.value = sdata[key]
      table.insert(attrs, templab)
    elseif key == "Level" then
      templab = {}
      templab.name = ZhString.MonsterTip_Characteristic_Level
      templab.value = sdata[key]
      table.insert(attrs, templab)
    elseif key == "Race" then
      templab = {}
      templab.name = ZhString.MonsterTip_Characteristic_Race
      templab.value = GameConfig.MonsterAttr.Race[sdata[key]]
      table.insert(attrs, templab)
    elseif key == "Shape" then
      templab = {}
      templab.name = ZhString.MonsterTip_Characteristic_Shape
      templab.value = GameConfig.MonsterAttr.Body[sdata[key]]
      table.insert(attrs, templab)
    elseif sdata[key] then
      local prop = propMap[key]
      if prop then
        templab = {}
        templab.name = prop.displayName
        templab.value = sdata[key]
        table.insert(attrs, templab)
      end
    end
  end
  self.baseAttrCtGrid:ResetDatas(attrs)
  self.baseAttrCtGrid:Layout()
  if sdata.Behaviors then
    local showDatas = self:GetMCharacteristicDatas(sdata.Behaviors)
    local cTip = ZhString.MonsterTip_None
    if #showDatas > 0 then
      cTip = ""
      local bordInfo = {}
      bordInfo.hideline = true
      bordInfo.label = {}
      for i = 1, #showDatas do
        cTip = cTip .. showDatas[i].NameZh
        if i < #showDatas then
          cTip = cTip .. "\n"
        end
        local templabel = showDatas[i].NameZh .. ":" .. showDatas[i].Desc
        table.insert(bordInfo.label, templabel)
      end
      self.mclabel:SetData(bordInfo)
      self:Show(self.featureCt)
    else
      self:Hide(self.featureCt)
    end
  end
  if self.dropItems and 0 < #self.dropItems then
    self:Hide(self.EmptyDropLabel.gameObject)
    self.fallCtGrid:ResetDatas(self.dropItems)
  else
    self.fallCtGrid:ResetDatas({})
    local bossData = Table_Boss[self.data.staticId]
    if bossData and bossData.Type == 4 then
      self:Show(self.EmptyDropLabel.gameObject)
    end
  end
  local trans = self.baseAttrCt.transform
  local bound = NGUIMath.CalculateRelativeWidgetBounds(trans, false)
  local pos = trans.localPosition
  pos = Vector3(pos.x, pos.y - bound.size.y, pos.z)
  if self.featureCt.activeSelf then
    trans = self.featureCt.transform
    trans.localPosition = pos
    bound = NGUIMath.CalculateRelativeWidgetBounds(trans, false)
    pos = Vector3(pos.x, pos.y - bound.size.y - 5, pos.z)
  end
  trans = self.fallCt.transform
  trans.localPosition = pos
  if not originActive or not self.data.attrUnlock then
    self:Hide(self.monsterSpecial)
  end
end
function MonsterScoreTip:initData()
  self.dropItems = {}
  local sdata = self.data.staticData
  if sdata then
    local dropItems = ItemUtil.GetDeath_Drops(sdata.id)
    if dropItems then
      for i = 1, #dropItems do
        local single = dropItems[i]
        local id = single.itemData.id
        if id ~= 100 and id ~= 105 then
          self.dropItems[#self.dropItems + 1] = single
          local cardData = Table_Card[id]
          if cardData then
            self.dropCardId = id
          end
        end
      end
    end
    if sdata.Nature then
      local result = IconManager:SetUIIcon(sdata.Nature, self.MonstPro)
      if not result then
        self:Hide(self.MonstPro.gameObject)
      else
        self:Show(self.MonstPro.gameObject)
      end
    else
      self:Hide(self.MonstPro.gameObject)
    end
  end
end
function MonsterScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    if not self.data.AdventureValue or self.data.AdventureValue > 0 then
    else
    end
    local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data, true)
    self.lockTipLabel.text = unlockCondition
    self:UpdateAdvReward()
    local UnlockReward = self:FindGO("UnlockReward")
    if self.isUnlock then
      self:Hide(UnlockReward)
    end
  end
  if self.data.attrUnlock then
    self:SetTextureWhite(self.chatacterBtn)
    self.photosprite.color = Color(1, 1, 1, 1)
  else
    self:SetTextureColor(self.chatacterBtn, Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569))
    self.photosprite.color = Color(1, 1, 1, 0.4)
  end
  local hasCard = AdventureDataProxy.Instance:checkHasMonsterDropCard(self.dropCardId)
  if hasCard then
    self.cardsprite.color = Color(1, 1, 1, 1)
  else
    self.cardsprite.color = Color(1, 1, 1, 0.4)
  end
  self.lockBord.gameObject:SetActive(not self.isUnlock)
  if not self.isUnlock then
    self.monstername.text = "????"
    self:Hide(self.modelBottombg)
  else
    self:Show(self.modelBottombg)
  end
  return self.isUnlock
end
function MonsterScoreTip:UpdateAdvReward()
  self.advRewardCtl:ResetDatas({})
  local value = 0
  if self.data and self.data.staticData and self.data.staticData.AdventureValue then
    value = self.data.staticData.AdventureValue
  end
  self.adventureValue.text = value
end
function MonsterScoreTip:UpdateTopInfo()
  local data = self.data
  local sdata = data and data.staticData
  if sdata then
    self.monstername.text = sdata.NameZh
  end
end
function MonsterScoreTip:Show3DModel()
  local data = self.data
  local monsterData = data and data.staticData
  if monsterData then
    UIModelUtil.Instance:ResetTexture(self.modeltexture)
    self.model = UIModelUtil.Instance:SetMonsterModelTexture(self.modeltexture, monsterData.id)
    local showPos = monsterData.LoadShowPose
    if showPos and #showPos == 3 then
      tempVector3:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
      self.model:SetPosition(tempVector3)
    end
    self.model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
    local size = monsterData.LoadShowSize or 1
    self.model:SetScale(size)
    local bossData = Table_Boss[self.data.staticId]
    if bossData and bossData.Type == 3 then
      UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing_1")
    else
      UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing")
    end
  end
  return false
end
function MonsterScoreTip:ShowScore()
end
function MonsterScoreTip:GetMonsterDetail()
  local rewards = AdventureDataProxy.Instance:getAppendRewardByTargetId(self.data.staticId, "selfie")
  if not self.data.attrUnlock and rewards and #rewards > 0 then
    local items = ItemUtil.GetRewardItemIdsByTeamId(rewards[1])
    local unlocktip = {}
    if not self.isUnlock then
      unlocktip.tiplabel = "[c][808080ff]" .. ZhString.MonsterTip_MonstDetail .. "[-][/c]"
      unlocktip.label = "[c][808080ff]" .. string.format(ZhString.MonsterTip_UnLockMonstDetail, self.data.staticData.NameZh) .. "{uiicon=Adventure_icon_05}x" .. items[1].num .. "[-][/c]"
    else
      unlocktip.tiplabel = ZhString.MonsterTip_MonstDetail
      unlocktip.label = string.format(ZhString.MonsterTip_UnLockMonstDetail, self.data.staticData.NameZh) .. "{uiicon=Adventure_icon_05}x" .. items[1].num
    end
    unlocktip.hideline = true
    unlocktip.tiplabel = ZhString.MonsterTip_MonstDetail
    unlocktip.label = string.format(ZhString.MonsterTip_UnLockMonstDetail, self.data.staticData.NameZh) .. "{uiicon=Adventure_icon_05}x" .. items[1].num
    return unlocktip
  end
end
function MonsterScoreTip:GetMonsterDes()
  if self.isUnlock then
    local desc = {}
    desc.label = self.data.staticData.Desc
    desc.hideline = true
    return desc
  end
end
function MonsterScoreTip:GetMonsterUnlock()
  local advReward, advRDatas = self.data.staticData.AdventureReward, {}
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {}
    temp.hideline = true
    if self.isUnlock then
      temp.label = AdventureDataProxy.getUnlockCondition(self.data, true) .. "\239\188\140" .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue
      temp.tiplabel = ZhString.MonsterTip_LockReward
    else
      temp.label = "[c][808080ff]" .. AdventureDataProxy.getUnlockCondition(self.data, true) .. "\239\188\140" .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue .. "[-][/c]"
      temp.tiplabel = "[c][808080ff]" .. ZhString.MonsterTip_LockReward .. "[-][/c]"
    end
    return temp
  end
end
function MonsterScoreTip:GetPosition()
  local position = {}
  local posTip = ZhString.MonsterTip_None
  if Table_MonsterOrigin then
    local posConfigs = Table_MonsterOrigin[self.data.staticData.id]
    if posConfigs and #posConfigs > 0 then
      posTip = ""
      local filterMap = {}
      for i = 1, #posConfigs do
        local mapID = posConfigs[i].mapID
        if not filterMap[mapID] then
          filterMap[mapID] = true
          local mapdata = Table_Map[mapID]
          if mapdata and mapdata.Mode == 1 then
            posTip = posTip .. mapdata.NameZh
            posTip = posTip .. ZhString.Common_Comma
          end
        end
      end
      local len = StringUtil.getTextLen(posTip)
      posTip = StringUtil.getTextByIndex(posTip, 1, len - 1)
    end
  end
  position.label = posTip
  position.hideline = true
  position.tiplabel = ZhString.MonsterTip_Position
  return position
end
function MonsterScoreTip:UpdateAttriText()
  local contextData = {}
  local data = self.data
  local sdata = self.data.staticData
  if data and sdata then
    local sdata = self.data.staticData
    if sdata then
      self:Show3DModel()
      self:ShowScore()
    end
    if self.isUnlock then
      local monsterDes = self:GetMonsterDes()
      if monsterDes then
        table.insert(contextData, monsterDes)
      end
      local monsterDetail = self:GetMonsterDetail()
      if monsterDetail then
        table.insert(contextData, monsterDetail)
      end
      local unlockReward = self:GetMonsterUnlock()
      if unlockReward then
        table.insert(contextData, unlockReward)
      end
      local position = self:GetPosition()
      table.insert(contextData, position)
    else
      local monsterDes = self:GetMonsterDes()
      if monsterDes then
        table.insert(contextData, monsterDes)
      end
      local monsterDetail = self:GetMonsterDetail()
      if monsterDetail then
        table.insert(contextData, monsterDetail)
      end
      local unlockReward = self:GetMonsterUnlock()
      if unlockReward then
        table.insert(contextData, unlockReward)
      end
      local position = self:GetPosition()
      table.insert(contextData, position)
    end
  end
  self.attriCtl:ResetDatas(contextData)
end
function MonsterScoreTip:GetMCharacteristicDatas(behaviorId)
  local showResult, allReuslt = {}, {}
  local pos = 0
  while behaviorId > 0 do
    if behaviorId % 2 == 1 then
      local data = Table_MCharacteristic[math.pow(2, pos)]
      if data then
        if data.show == 1 then
          table.insert(showResult, data)
        end
        table.insert(allReuslt, data)
      end
    end
    behaviorId = math.floor(behaviorId / 2)
    pos = pos + 1
  end
  return showResult, allReuslt
end
function MonsterScoreTip:UpdateAppendData()
  if self.isUnlock then
    local trans = self.attriCtl.layoutCtrl.transform
    local bound = NGUIMath.CalculateRelativeWidgetBounds(trans, true)
    local pos = trans.localPosition
    pos = Vector3(pos.x, pos.y - bound.size.y, pos.z - 20)
    trans = self.appCtl.layoutCtrl.transform
    trans.localPosition = pos
    local appends = self.data:getNoRewardAppend()
    if #appends > 0 then
      self.appCtl:ResetDatas(appends)
    else
      self.appCtl:ResetDatas()
    end
  else
    self.appCtl:ResetDatas()
  end
end
function MonsterScoreTip:OnEnable()
end
function MonsterScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  self.mclabel:SetData(nil)
  self.baseAttrCtGrid:ResetDatas()
  self.appCtl:ResetDatas()
  self.advRewardCtl:ResetDatas()
  self.fallCtGrid:ResetDatas()
  MonsterScoreTip.super.OnExit(self)
  UIModelUtil.Instance:ResetTexture(self.modeltexture)
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
end
