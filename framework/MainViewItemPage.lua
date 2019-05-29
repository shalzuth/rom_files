MainViewItemPage = class("MainViewItemPage", SubView)
autoImport("QuickItemCell")
autoImport("QuestPackagePart")
autoImport("FoodPackagePart")
autoImport("PetPackagePart")
MainViewItemPage.ButterflyWingId = 50001
MainViewItemPage.PetAdventureItemId = 5504
function MainViewItemPage:Init()
  self:AddViewInterests()
  self:InitUI()
end
function MainViewItemPage:InitUI()
  self.grid = self:FindComponent("ItemGrid", UIGridEx)
  function self.grid.onReposition()
    self.grid.gameObject:SetActive(false)
    self.grid.gameObject:SetActive(true)
  end
  self.quickItemCells = {}
  for i = 1, 5 do
    local obj = self:LoadPreferb("cell/QuickItemCell", self.grid.gameObject)
    obj.name = "QuickItemCell" .. i
    self.quickItemCells[i] = QuickItemCell.new(obj)
    self.quickItemCells[i]:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  end
  self:UpdateQuickItems()
  self.phaseItemSkillEffect = self:FindGO("PhaseItemSkillEffect")
end
function MainViewItemPage:GetQuestPackageBord()
  if self.questPackageBord == nil then
    local frontPanel = self:FindGO("ThefrontPanel")
    self.questPackageBord = QuestPackagePart.new()
    self.questPackageBord:CreateSelf(frontPanel.gameObject)
    self.questPackageBord:Hide()
  end
  return self.questPackageBord
end
function MainViewItemPage:GetFoodPackageBord()
  if self.foodPackageBord == nil then
    local frontPanel = self:FindGO("ThefrontPanel")
    self.foodPackageBord = FoodPackagePart.new()
    self.foodPackageBord:CreateSelf(frontPanel.gameObject)
    self.foodPackageBord:Hide()
  end
  return self.foodPackageBord
end
function MainViewItemPage:GetPetPackageBord()
  if self.petPackageBord == nil then
    local frontPanel = self:FindGO("ThefrontPanel")
    self.petPackageBord = PetPackagePart.new()
    self.petPackageBord:CreateSelf(frontPanel.gameObject)
  end
  return self.petPackageBord
end
function MainViewItemPage:OnEnter()
  MainViewItemPage.super.OnEnter(self)
  self:HandleHpSpChange()
end
function MainViewItemPage:ClickItem(cellCtl)
  local data = cellCtl.data
  if data and data.num > 0 and 0 >= data.cdTime then
    if data.staticData.id == 5045 then
      local ctrl = self:GetQuestPackageBord()
      ctrl:UpdateInfo()
      ctrl:Show()
      local x, y, z = LuaGameObject.GetPosition(cellCtl.gameObject.transform)
      ctrl:SetPos(x, y, z)
      ctrl:SetLocalOffset(-257.1, 214, 0)
      return
    end
    if data.staticData.id == 5640 then
      local ctrl = self:GetPetPackageBord()
      ctrl:UpdateInfo()
      ctrl:Show()
      local x, y, z = LuaGameObject.GetPosition(cellCtl.gameObject.transform)
      ctrl:SetPos(x, y, z)
      ctrl:SetLocalOffset(-257.1, 214, 0)
      return
    end
    if data.staticData.id == 5047 then
      local ctrl = self:GetFoodPackageBord()
      ctrl:UpdateInfo()
      ctrl:Show()
      local x, y, z = LuaGameObject.GetPosition(cellCtl.gameObject.transform)
      ctrl:SetPos(x, y, z)
      ctrl:SetLocalOffset(-257.1, 214, 0)
      return
    end
    local source
    if BagProxy.Instance.roleEquip:GetItemByGuid(data.id) ~= nil then
      source = FunctionItemFunc_Source.RoleEquipBag
    end
    local func
    if data:IsFashion() then
      func = ItemUtil.getFashionDefaultEquipFunc(data)
    else
      func = FunctionItemFunc.Me():GetItemDefaultFunc(data, source)
    end
    if func then
      func(data)
    end
  end
end
function MainViewItemPage:KeyBoardUseItemHandler(index)
  if index > 0 and index <= #self.quickItemCells then
    local cell = self.quickItemCells[index]
    if cell then
      self:ClickItem(cell)
    end
  end
end
function MainViewItemPage:UpdateQuickItems()
  local quickItemDatas = ShortCutProxy.Instance:GetShorCutItem()
  local hpTipItems = GameConfig.QuickItemTip.HpItemIds
  local tempHpMap = {}
  for i = 1, #hpTipItems do
    tempHpMap[hpTipItems[i]] = 1
  end
  local spTipItems = GameConfig.QuickItemTip.SpItemIds
  local tempSpMap = {}
  for i = 1, #spTipItems do
    tempSpMap[spTipItems[i]] = 1
  end
  local bwingGuideCell
  self.hpCells, self.spCells = {}, {}
  for i = 1, 5 do
    local data = quickItemDatas[i]
    if data and data.staticData and data.num > 0 then
      if tempHpMap[data.staticData.id] then
        self.hpCells[i] = self.quickItemCells[i]
      end
      if tempSpMap[data.staticData.id] then
        self.spCells[i] = self.quickItemCells[i]
      end
      if not bwingGuideCell and data.staticData.id == MainViewItemPage.ButterflyWingId then
        bwingGuideCell = self.quickItemCells[i]
      end
      if data.staticData.id == MainViewItemPage.PetAdventureItemId then
        self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PET_ADVENTURE, self.quickItemCells[i].icon.gameObject, 42)
      end
    end
    self.quickItemCells[i]:SetData(quickItemDatas[i])
  end
  self.grid.enabled = true
  function self.grid.onReposition()
    if self.setButterFlyGuild then
      self.setButterFlyGuild = false
      if bwingGuideCell then
        local obj = bwingGuideCell.gameObject
        local stick = obj:GetComponentInChildren(UISprite)
        if stick then
          TipManager.Instance:ShowBubbleTipById(BubbleID.ButterflyWingGuildId, stick, NGUIUtil.AnchorSide.Top)
        end
      end
    end
    for i = 1, #self.quickItemCells do
      local item = self.quickItemCells[i]
      if item.gameObject.activeSelf then
        item.gameObject:SetActive(false)
        item.gameObject:SetActive(true)
      end
    end
  end
end
function MainViewItemPage:AddViewInterests()
  self:AddListenEvt(GuideEvent.ShowBubble, self.HandleButterflyWingGuild)
  self:AddListenEvt(MyselfEvent.ResetHpShortCut, self.UpdateQuickItems)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateQuickItems)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.UpdateQuickItems)
  self:AddListenEvt(MyselfEvent.MyPropChange, self.HandleHpSpChange)
  self:AddDispatcherEvt("CJKeyBoardUseItemEvent", self.KeyBoardUseItemHandler)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HideItemGrid)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.ShowItemGrid)
  self:AddListenEvt(PVEEvent.Altman_Launch, self.HideItemGrid)
  self:AddListenEvt(PVEEvent.Altman_Shutdown, self.ShowItemGrid)
  self:AddListenEvt(HotKeyEvent.UseShortCutItem, self.HandleShortCutItem)
  self:AddListenEvt(SkillEvent.SkillSelectPhaseStateChange, self.HandlePhaseItemSkillEffect)
end
function MainViewItemPage:HandleButterflyWingGuild(note)
  local guildid = note.body
  if guildid == BubbleID.ButterflyWingGuildId then
    do
      local deltaTime, lastTime = 0, nil
      TimeTickManager.Me():CreateTick(0, 33, function(self)
        if lastTime then
          deltaTime = deltaTime + (RealTime.time - lastTime)
          if deltaTime > 1 then
            TimeTickManager.Me():ClearTick(self, 1)
          end
        end
        lastTime = RealTime.time
        local bfItem = BagProxy.Instance:GetItemByStaticID(MainViewItemPage.ButterflyWingId)
        if bfItem then
          self.setButterFlyGuild = true
          local key = {
            guid = bfItem.id,
            type = bfItem.staticData.id,
            pos = 2
          }
          ServiceNUserProxy.Instance:CallPutShortcut(key)
          TimeTickManager.Me():ClearTick(self, 1)
        end
      end, self, 1)
    end
  else
  end
end
function MainViewItemPage:HandleHpSpChange(note)
  local roleLv = MyselfProxy.Instance:RoleLevel()
  if roleLv <= GameConfig.QuickItemTip.Level then
    local props = Game.Myself.data.props
    local hp = props.Hp:GetValue()
    local maxhp = math.max(props.MaxHp:GetValue(), 1)
    local hpTipPct = GameConfig.QuickItemTip.HpPct / 100
    for i, cell in pairs(self.hpCells) do
      cell:ActiveTip(hpTipPct > hp / maxhp)
    end
    local mp = props.Sp:GetValue()
    local maxMp = math.max(props.MaxSp:GetValue(), 1)
    local spTipPct = GameConfig.QuickItemTip.SpPct / 100
    for i, cell in pairs(self.spCells) do
      cell:ActiveTip(spTipPct > mp / maxMp)
    end
  else
    for i, cell in pairs(self.hpCells) do
      cell:ActiveTip(false)
    end
    for i, cell in pairs(self.spCells) do
      cell:ActiveTip(false)
    end
  end
end
function MainViewItemPage:HideItemGrid(note)
  self.grid.gameObject:SetActive(false)
end
function MainViewItemPage:ShowItemGrid(note)
  self.grid.gameObject:SetActive(true)
end
function MainViewItemPage:HandleShortCutItem(note)
  local param = note.body
  if param.index then
    local cell = self.quickItemCells[param.index]
    if cell then
      self:ClickItem(cell)
    end
  end
end
function MainViewItemPage:HandlePhaseItemSkillEffect()
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID <= 0 then
    self:HidePhaseItemSkillEffect()
  else
    local skillCostItemId = self:GetSkillCostItemId(skillID)
    if skillCostItemId then
      self:ShowPhaseItemSkillEffect(skillCostItemId)
    end
  end
end
function MainViewItemPage:ShowPhaseItemSkillEffect(itemId)
  local cell = self:GetQuickItemCell(itemId)
  if not cell then
    return
  end
  if not self.phaseEffectCtrl then
    self.phaseEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillsPlay, self.phaseItemSkillEffect.transform)
  end
  local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseItemSkillEffect.transform, cell.gameObject.transform, Space.World)
  self.phaseEffectCtrl:ResetLocalPositionXYZ(x, y, z)
end
function MainViewItemPage:HidePhaseItemSkillEffect()
  if self.phaseEffectCtrl then
    self.phaseEffectCtrl:Destroy()
    self.phaseEffectCtrl = nil
  end
end
function MainViewItemPage:GetSkillCostItemId(skillId)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillId)
  if not skillInfo then
    return nil
  end
  local skillCost = SkillProxy.Instance:GetOriginSpecialCost(skillInfo.staticData)
  if not skillCost or not next(skillCost) then
    return nil
  end
  local itemCost
  for i = 1, #skillCost do
    itemCost = skillCost[i]
    if itemCost.itemID then
      return itemCost.itemID
    end
  end
  return nil
end
function MainViewItemPage:GetQuickItemCell(itemId)
  if itemId then
    for _, cell in pairs(self.quickItemCells) do
      if cell.data and cell.data.staticData.id == itemId then
        return cell
      end
    end
  end
  return nil
end
