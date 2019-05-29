local BaseCell = autoImport("BaseCell")
ItemTipModelCell = class("ItemTipModelCell", BaseCell)
autoImport("FashionPreviewTip")
autoImport("Table_ItemBeTransformedWay")
autoImport("CardNCell")
ItemTipModelCell.CardNCellResPath = ResourcePathHelper.UICell("CardNCell")
local tempV3 = LuaVector3()
local tempTable = {}
ItemTipModelCell.ModelPos = {
  [1] = {
    position = LuaVector3(-0.31, 0.53, 3.89),
    rotation = LuaQuaternion.Euler(-4.400024, -32.29996, 3.200009)
  },
  [2] = {
    position = LuaVector3(-1.91, 0.45, 3.31),
    rotation = LuaQuaternion.Euler(0.8500001, -0.3200073, -2.090027)
  }
}
function ItemTipModelCell:Init()
  self.itemmodel = self:FindGO("PlayerModelContainer")
  self.itemmodeltexture = self:FindComponent("ModelTexture", UITexture, self.itemmodel)
  self.adventureValueCard = self:FindComponent("adventureValueCard", UILabel)
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.modelHodler = self:FindGO("PlayerModelContainer")
  self.cardHodler = self:FindGO("CardCellHolder")
  self.ItemName = self:FindComponent("ItemName", UILabel)
  local modelBg = self:FindGO("ModelBg")
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  self.fixedAttrLabel = self:FindComponent("fixedAttrLabel", UILabel)
  self.LockReward = self:FindComponent("LockReward", UILabel)
  self.LockReward.text = ZhString.MonsterTip_LockReward
  local UnlockReward = self:FindGO("UnlockReward")
  self:Hide(UnlockReward)
  local adventureValueCt = self:FindGO("adventureValueCt")
  self:Hide(adventureValueCt)
  self.adventureValueCt = self:FindGO("adventureValueCt")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  self:InitAttriContext()
  self:initDropRelate()
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.center = self:FindGO("Center")
  self.BottomGrid = self:FindComponent("Bottom", UIGrid)
  self.userdata = Game.Myself.data.userdata
end
function ItemTipModelCell:initDropRelate()
  local dropContainer = self:FindGO("DropContainer")
  self.getPathBtn = self:FindGO("getPathBtn")
  self.MakeHeadDress = self:FindGO("MakeHeadDress")
  local label = self:FindComponent("Label", UILabel, self.MakeHeadDress)
  label.text = ZhString.ItemScoreTip_MakeHeadDress
  self.RedTip = self:FindGO("RedTip")
  self:Show(self.getPathBtn)
  local btnText = self:FindComponent("Label", UILabel, self.getPathBtn)
  btnText.text = ZhString.ItemScoreTip_GetPathDes
  self.bottomCt = self:FindGO("BottomCt")
  self:AddClickEvent(self.getPathBtn, function(go)
    if self.data and self.data.staticData then
      if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
        self.gainwayCtl:OnExit()
        self.gainwayCtl = nil
      else
        self.gainwayCtl = GainWayTip.new(dropContainer)
        self.gainwayCtl:SetData(self.data.staticData.id)
      end
    end
  end)
  self:AddClickEvent(self.MakeHeadDress, function(go)
    if self.data and self.data.staticData then
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "PicTipPopUp",
        data = self.data
      })
    end
  end)
  self.wearBtn = self:FindGO("wearBtn")
  self:AddClickEvent(self.wearBtn, function()
    if self.sfp then
      self.sfp:OnExit()
    end
    local sex = MyselfProxy.Instance:GetMySex()
    local partBody = ItemUtil.getFashionItemRoleBodyPart(self.data.staticId, sex == 1)
    if partBody then
      self.sfp = FashionPreviewTip.new(dropContainer)
      self.sfp:SetData(partBody.id)
    end
  end)
  self.PackageBtn = self:FindGO("PackageBtn")
  self.PackageLabel = self:FindComponent("Label", UILabel, self.PackageBtn)
  self:AddClickEvent(self.PackageBtn, function(go)
    if self.data and self.data.staticData then
      if self.data.store then
        ServiceSceneManualProxy.Instance:CallGetManualCmd(self.data.type, self.data.staticId)
      else
        local card = self.data.type == SceneManual_pb.EMANUALTYPE_CARD
        if card then
          if not BagProxy.Instance:GetItemByStaticID(self.data.staticId) then
            MsgManager.ShowMsgByIDTable(570, {
              self.data.staticId
            })
          else
            local itemData = BagProxy.Instance:GetItemByStaticIDWithoutCard(self.data.staticId)
            if not itemData then
              MsgManager.ShowMsgByIDTable(549)
            else
              ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemData.id)
            end
          end
        else
          if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
            local itemData = BagProxy.Instance:GetItemByStaticID(self.data.staticId)
            if not itemData then
              MsgManager.ShowMsgByIDTable(570, {
                self.data.staticId
              })
            else
              ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemData.id)
            end
            return
          end
          local datas = AdventureDataProxy.Instance:GetFashionEquipByStaticNormal(self.data)
          if not self.data.equipInfo.equipData.GroupID and not BagProxy.Instance:GetItemByStaticID(self.data.staticId) then
            MsgManager.ShowMsgByIDTable(570, {
              self.data.staticId
            })
          elseif not datas or #datas == 0 then
            MsgManager.ShowMsgByIDTable(570, {
              self.data.staticId
            })
          else
            local itemDatas = AdventureDataProxy.Instance:GetFashionEquipByStatic(self.data)
            if not itemDatas or #itemDatas == 0 then
              MsgManager.ShowMsgByIDTable(549)
            else
              local itemData = itemDatas[1]
              ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemData.id)
            end
          end
        end
      end
    end
  end)
end
function ItemTipModelCell:SetUnlockCondition()
  local str = AdventureDataProxy.getUnlockCondition(self.data)
  self.lockTipLabel.text = str
  local size = 190
  if not self.data.cardInfo then
    size = 340
  end
  if size <= self.lockTipLabel.width then
    self.lockTipLabel.overflowMethod = 1
    self.lockTipLabel.width = size
    UIUtil.WrapLabel(self.lockTipLabel)
  else
    self.lockTipLabel.overflowMethod = 2
  end
end
function ItemTipModelCell:SetUnlockReward()
  local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
  local rewardStr = AdventureDataProxy.Instance:getUnlockRewardStr(self.data.staticData)
  local fixedAttrLabelText = unlockCondition
  if unlockCondition and unlockCondition ~= "" then
    if rewardStr and rewardStr ~= "" then
      fixedAttrLabelText = string.format("%s,%s", unlockCondition, rewardStr)
    end
    self.fixedAttrLabel.text = fixedAttrLabelText
  end
end
function ItemTipModelCell:updateWidgetColor()
  local UnlockReward = self:FindGO("UnlockReward")
  if not self.isUnlock then
    local childs = GameObjectUtil.Instance:GetAllComponentsInChildren(UnlockReward, UILabel, true)
    for i = 1, #childs do
      local obj = childs[i]
      ColorUtil.GrayUIWidget(obj)
    end
    childs = GameObjectUtil.Instance:GetAllComponentsInChildren(UnlockReward, UISprite, true)
    for i = 1, #childs do
      local obj = childs[i]
      ColorUtil.ShaderGrayUIWidget(obj)
    end
  else
    local childs = GameObjectUtil.Instance:GetAllComponentsInChildren(UnlockReward, UILabel, true)
    for i = 1, #childs do
      local obj = childs[i]
      ColorUtil.BlackLabel(obj)
    end
    self.LockReward.color = LuaColor(1, 0.3843137254901961, 0.17254901960784313, 1)
  end
end
function ItemTipModelCell:adjustCardViewLockView()
  self:Hide(self.wearBtn)
  self:Hide(self.MakeHeadDress)
  self.BottomGrid:Reposition()
  local pos = self.scrollView.transform.localPosition
  if self.scrollView.panel then
    local clip = self.scrollView.panel.baseClipRegion
    self.scrollView.panel.baseClipRegion = Vector4(clip.x, clip.y, 464, 114)
    self.scrollView.panel.clipOffset = Vector2(0, 0)
  end
  self.scrollView.transform.localPosition = Vector3(pos.x, -36, pos.z)
  local sbg = self:FindComponent("SpriteBg", UISprite)
  sbg.width = 270
  local pos = self.bottomCt.transform.localPosition
  self.bottomCt.transform.localPosition = Vector3(pos.x, -373.3, pos.y)
  pos = self.getPathBtn.transform.localPosition
  self.getPathBtn.transform.localPosition = Vector3(102, -61, 0)
  NGUITools.AddWidgetCollider(self.center, true)
end
function ItemTipModelCell:ResetLabelInfo()
  local lockTipLabel = self:FindGO("LockTipLabel", obj):GetComponent("UILabel")
  if self.data.cardInfo then
    OverseaHostHelper:FixLabelOverV1(lockTipLabel, 2, 300)
    lockTipLabel.transform.localPosition = Vector3(10, 24, 0)
  else
    OverseaHostHelper:FixLabelOverV1(lockTipLabel, 0, 300)
  end
end
function ItemTipModelCell:adjustModelViewLockView()
  if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
    self:Hide(self.wearBtn)
    self:Hide(self.MakeHeadDress)
  else
    self:Show(self.wearBtn)
  end
  local staticData = Table_ItemBeTransformedWay[self.data.staticId]
  if staticData and self.data.tabData.id ~= 1045 and self.data.type ~= SceneManual_pb.EMANUALTYPE_TOY then
    self:Show(self.MakeHeadDress)
  else
    self:Hide(self.MakeHeadDress)
  end
  self.BottomGrid:Reposition()
  local pos = self.scrollView.transform.localPosition
  if self.scrollView.panel then
    local clip = self.scrollView.panel.baseClipRegion
    self.scrollView.panel.baseClipRegion = Vector4(clip.x, clip.y, 463.9, 242.85)
    self.scrollView.panel.clipOffset = Vector2(0, 0)
  end
  self.scrollView.transform.localPosition = Vector3(pos.x, 33, pos.z)
  self:Hide(self.adventureValueCard.gameObject.transform.parent)
  local sbg = self:FindComponent("SpriteBg", UISprite)
  sbg.width = 448
  local pos = self.bottomCt.transform.localPosition
  self.bottomCt.transform.localPosition = Vector3(pos.x, -241.4, pos.y)
  pos = self.getPathBtn.transform.localPosition
  self.getPathBtn.transform.localPosition = Vector3(182, -45.9, 0)
  NGUITools.AddWidgetCollider(self.center, true)
  local islock = not self.data.store and self.data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY
  self:Hide(self.RedTip)
end
function ItemTipModelCell:initData()
  local pos = self.table.transform.localPosition
  self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
  if self.data.cardInfo then
    if self.cardCell then
      self.cardCell:SetData()
    end
    self:Show(self.cardHodler)
    self:Hide(self.modelHodler)
    self:initCardCell()
    self:adjustCardViewLockView()
  elseif self.data.tabData.id == 1045 then
    self:Hide(self.cardHodler)
    self:Show(self.modelHodler)
    self:removeCardCell()
    self:adjustModelViewLockView()
  elseif BagProxy.fashionType[self.data.staticData.Type] or self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
    self:Hide(self.cardHodler)
    self:Show(self.modelHodler)
    self:removeCardCell()
    self:adjustModelViewLockView()
  end
  if self.getPathBtn and self.data.staticData then
    local gainData = GainWayTipProxy.Instance:GetDataByStaticID(self.data.staticData.id)
    self.getPathBtn:SetActive(gainData ~= nil)
  end
  local value = 0
  if self.data and self.data.staticData and self.data.staticData.AdventureValue then
    value = self.data.staticData.AdventureValue
  end
  self.adventureValueCard.text = value
  self.adventureValue.text = value
  UIMultiModelUtil.Instance:RemoveModels()
  self.model = nil
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
end
function ItemTipModelCell:initCardCell()
  local obj = self:FindGO("CardNCell")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ItemTipModelCell.CardNCellResPath, self.cardHodler)
    obj.transform.localPosition = Vector3.zero
    obj.transform.localScale = Vector3.one
    obj.name = "CardNCell"
  end
  self.cardCell = CardNCell.new(obj)
  self.cardCell:SetData(self.itemData)
  self.cardCell:Hide(self.cardCell.useButton.gameObject)
end
function ItemTipModelCell:removeCardCell()
  if self.cardCell then
    Game.GOLuaPoolManager:AddToUIPool(ItemTipModelCell.CardNCellResPath, self.cardCell.gameObject)
    self.cardCell = nil
  end
end
function ItemTipModelCell:InitAttriContext()
  self.table = self:FindComponent("AttriTable", UITable)
  local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
  local tip = self:FindGO("TipLabelCell", self.table.gameObject)
  self.tipLabel = TipLabelCell.new(tip)
  self:Hide(self.tipLabel.gameObject)
  self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "AdventureTipLabelCell")
end
function ItemTipModelCell:SetData(data)
  self.data = data
  if self.gainwayCtl then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
  if data then
    self:initData()
    self.gameObject:SetActive(true)
    self:UpdateTopModel(true, true, true)
    self:UpdateTopInfo()
    self:UpdateAttriContext()
    self:SetUnlockCondition()
    self:UpdateStoreState()
    self:SetUnlockReward()
  else
    self.gameObject:SetActive(false)
  end
end
function ItemTipModelCell:UpdateStoreState()
  if self.data.cardInfo then
    if self.data.store then
      self.PackageLabel.text = ZhString.AdventurePanel_CardOutAdventurePackage
    else
      self.PackageLabel.text = ZhString.AdventurePanel_CardIntoAdventurePackage
    end
  elseif self.data.store then
    if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
      self.PackageLabel.text = ZhString.AdventurePanel_ToyOutAdventurePackage
    else
      self.PackageLabel.text = ZhString.AdventurePanel_ItemOutAdventurePackage
    end
  elseif self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
    self.PackageLabel.text = ZhString.AdventurePanel_ToyIntoAdventurePackage
  else
    self.PackageLabel.text = ZhString.AdventurePanel_ItemIntoAdventurePackage
  end
end
function ItemTipModelCell:FormatBufferStr(bufferId)
  local str = ItemUtil.getBufferDescById(bufferId)
  return str
end
function ItemTipModelCell:GetItemDetail()
  local temp = {}
  local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
  local intoPackageRewardStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(self.data.staticData)
  local propertyUnlock = string.format(ZhString.ItemTip_UnlockProperyRewardTip, self.data:GetName())
  if intoPackageRewardStr and intoPackageRewardStr ~= "" then
    propertyUnlock = propertyUnlock .. "," .. intoPackageRewardStr
  end
  temp.label = {}
  if not self.data.store then
    propertyUnlock = "[c][808080ff]" .. propertyUnlock .. "[-][/c]"
  end
  table.insert(temp.label, propertyUnlock)
  local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
  local rewardStr = AdventureDataProxy.Instance:getUnlockRewardStr(self.data.staticData)
  local fixedAttrLabelText = unlockCondition
  if unlockCondition and unlockCondition ~= "" then
    if rewardStr and rewardStr ~= "" then
      fixedAttrLabelText = string.format("%s,%s", unlockCondition, rewardStr)
    end
    if not self.isUnlock and rewardStr and rewardStr ~= "" then
      fixedAttrLabelText = "[c][808080ff]" .. fixedAttrLabelText .. "[-][/c]"
    end
    table.insert(temp.label, fixedAttrLabelText)
  end
  temp.hideline = true
  if not self.data.store and not self.isUnlock then
    temp.tiplabel = "[c][808080ff]" .. ZhString.MonsterTip_LockProperyReward .. "[-][/c]"
  else
    temp.tiplabel = ZhString.MonsterTip_LockProperyReward
  end
  return temp
end
function ItemTipModelCell:GetEquipProp()
  local equipInfo = self.data.equipInfo
  if equipInfo and self.data.type ~= SceneManual_pb.EMANUALTYPE_TOY then
    local uniqueEffect = equipInfo:GetUniqueEffect()
    if uniqueEffect and #uniqueEffect > 0 then
      local special = {}
      special.label = {}
      special.hideline = true
      local label = ""
      for i = 1, #uniqueEffect do
        local id = uniqueEffect[i].id
        label = label .. self:FormatBufferStr(id) .. "\n"
      end
      if label ~= "" then
        label = string.sub(label, 1, -2)
        table.insert(special.label, label)
        return special
      end
    end
  end
end
function ItemTipModelCell:GetItemDesc()
  local sData = self.data.staticData
  if not self.data.cardInfo and sData.Desc ~= "" and self.isUnlock then
    local desc = {}
    desc.label = sData.Desc
    desc.hideline = true
    return desc
  end
end
function ItemTipModelCell:GetItemUnlock()
  local advReward, advRDatas = self.data.staticData.AdventureReward, {}
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {}
    if not self.isUnlock then
      temp.label = "[c][808080ff]" .. AdventureDataProxy.getUnlockCondition(self.data) .. "\239\188\140" .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue .. "[-][/c]"
      temp.tiplabel = "[c][808080ff]" .. ZhString.MonsterTip_LockReward .. "[-][/c]"
    else
      temp.label = AdventureDataProxy.getUnlockCondition(self.data) .. "\239\188\140" .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue .. "[-][/c]"
      temp.tiplabel = ZhString.MonsterTip_LockReward
    end
    temp.hideline = true
    return temp
  end
end
function ItemTipModelCell:getMakeMaterial()
  if not self.data.cardInfo and Table_ItemBeTransformedWay[self.data.staticId] and Table_ItemBeTransformedWay[self.data.staticId].composeWay then
    local cid = Table_ItemBeTransformedWay[self.data.staticId].composeWay
    local composeData = Table_Compose[cid]
    if composeData then
      local costItem = composeData.BeCostItem
      local temp = {}
      temp.hideline = true
      temp.tiplabel = ZhString.MonsterTip_MakeMaterial
      temp.label = {}
      for i = 1, #costItem do
        local itemId = costItem[i].id
        local need = costItem[i].num
        local itemData = Table_Item[itemId]
        if itemData then
          local str = "%s    %s/%s"
          local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.adventureProduce)
          local itemDatas = BagProxy.Instance:GetMaterialItems_ByItemId(itemId, bagtype)
          local exsitNum = 0
          if itemDatas and #itemDatas > 0 then
            for j = 1, #itemDatas do
              local single = itemDatas[j]
              exsitNum = exsitNum + single.num
            end
          end
          str = string.format(str, itemData.NameZh, exsitNum, need)
          table.insert(temp.label, str)
        end
      end
      if #temp.label > 0 then
        return temp
      end
    end
  end
end
function ItemTipModelCell:UpdateAttriContext()
  self.attriCtl:ResetDatas()
  local contextDatas = {}
  local sData = self.data.staticData
  local equipProp = self:GetEquipProp()
  if equipProp then
    table.insert(contextDatas, equipProp)
  end
  local desc = self:GetItemDesc()
  if desc then
    table.insert(contextDatas, desc)
  end
  local detailProp = self:GetItemDetail()
  if detailProp then
    table.insert(contextDatas, detailProp)
  end
  local unlockProp = self:GetItemUnlock()
  if unlockProp then
    table.insert(contextDatas, unlockProp)
  end
  local makeMaterial = self:getMakeMaterial()
  if makeMaterial then
    table.insert(contextDatas, makeMaterial)
  end
  self.attriCtl:ResetDatas(contextDatas)
end
function ItemTipModelCell:UpdateTopInfo(data)
  local data = data or self.data
  if data then
    local qInt = data.staticData.Quality
    if self.equipTip then
      self.equipTip:SetActive(data.equiped == 1)
    end
    if self.getPathBtn and data.staticData then
      local gainData = GainWayTipProxy.Instance:GetDataByStaticID(data.staticData.id)
      self.getPathBtn:SetActive(gainData ~= nil)
    end
    self.ItemName.text = data:GetName()
  end
end
function ItemTipModelCell:UpdateTopModel(show3Dmodel, showScore, showCard)
  local data = self.data
  if data then
    local nextPos = Vector3(0, -200, 0)
    if show3Dmodel then
      self.show3Dmodel = self:Show3DModel()
      if not self.show3Dmodel then
        nextPos = self:Show2DCell(showCard)
      end
    else
      nextPos = self:Show2DCell(showCard)
    end
  end
end
function ItemTipModelCell:ResetTopCell()
  if self.cardCell then
    self.cardCell.gameObject:SetActive(false)
  end
  self.itemmodel:SetActive(false)
end
function ItemTipModelCell:Show2DCell(showCard)
  local nextPos = Vector3.zero
  local cardInfo = self.data.cardInfo
  if cardInfo and self.cardCell and showCard then
    self.cardCell.gameObject:SetActive(true)
    self.cardCell:SetData(self.data)
    nextPos = Vector3(0, -310, 0)
    self.showCard = true
  end
  return nextPos
end
function ItemTipModelCell:Show3DModel()
  local data = self.data
  local nextPos = Vector3.zero
  if data and data.staticData then
    local type = data.staticData.Type
    local key = TableUtil.FindKeyByValue(GameConfig.ManualShowItemType, type)
    if key then
      if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
        self:SetNormalModel(data)
        self.itemmodel:SetActive(true)
        return true
      elseif data.equipInfo and data.equipInfo.equipData then
        local ismount = data:IsMount()
        if ismount then
          self:SetMountModel(data)
        elseif self.data.tabData.id == 1045 and data.equipInfo.equipData.GroupID then
          self:SetFashionModel(data)
        else
          self:SetNormalModel(data)
        end
        self.itemmodel:SetActive(true)
        return true
      end
    end
  end
  return false
end
function ItemTipModelCell:SetMountModel(data)
  UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
  self.model = UIModelUtil.Instance:SetMountModelTexture(self.itemmodeltexture, data.staticData.id)
  self.model:SetSacle(0.8)
end
function ItemTipModelCell:SetFashionModel(data)
  local id = data.staticId
  local args, parts = self:getArgsAndParts(true)
  local partBody = ItemUtil.getFashionItemRoleBodyPart(id, true)
  if partBody then
    parts[Asset_Role.PartIndex.Body] = partBody.Body
  end
  UIMultiModelUtil.Instance:SetModels(2, args)
  UIMultiModelUtil.Instance:PlayAction(2, "wait", true)
  Asset_Role.DestroyPartArray(parts)
  args, parts = self:getArgsAndParts(false)
  partBody = ItemUtil.getFashionItemRoleBodyPart(id)
  if partBody then
    parts[Asset_Role.PartIndex.Body] = partBody.Body
  end
  UIMultiModelUtil.Instance:SetModels(3, args)
  UIMultiModelUtil.Instance:PlayAction(3, "wait", true)
  Asset_Role.DestroyPartArray(parts)
end
function ItemTipModelCell:getArgsAndParts(isMale)
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndexEx.HairColorIndex] = self.userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndex.Eye] = self.userdata:Get(UDEnum.EYE) or 0
  parts[partIndexEx.EyeColorIndex] = self.userdata:Get(UDEnum.EYECOLOR) or 0
  TableUtility.TableClear(tempTable)
  tempTable[1] = parts
  tempTable[2] = self.itemmodeltexture
  if isMale then
    parts[partIndex.Body] = Table_Class[1].MaleBody
    parts[partIndex.Hair] = 2
    tempTable[3] = ItemTipModelCell.ModelPos[1].position
    tempTable[4] = ItemTipModelCell.ModelPos[1].rotation
  else
    parts[partIndex.Body] = Table_Class[1].FemaleBody
    parts[partIndex.Hair] = 14
    tempTable[3] = ItemTipModelCell.ModelPos[2].position
    tempTable[4] = ItemTipModelCell.ModelPos[2].rotation
  end
  tempTable[5] = 1
  return tempTable, parts
end
function ItemTipModelCell:SetNormalModel(data)
  UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
  if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
    local bodyConfig = GameConfig.AdventureToyBodyConfig[self.data.staticId]
    if not bodyConfig then
      return
    end
    local bodyID = bodyConfig[1]
    local cameraConfig = bodyConfig[2]
    self.model = UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, Asset_Role.PartIndex.Body, bodyID)
    local showPos = cameraConfig.LoadShowPose
    if showPos and #showPos == 3 then
      self.model:ResetLocalPositionXYZ(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
    end
    local size = cameraConfig.LoadShowSize or 1
    self.model:ResetLocalScaleXYZ(size, size, size)
    local yEuler = cameraConfig.LoadShowRotate or 0
    tempV3:Set(0, yEuler, 0)
    self.model:ResetLocalEulerAngles(tempV3)
    return
  end
  local sData = data.staticData
  local GroupID = data.equipInfo.equipData.GroupID
  if GroupID then
    local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
    if not equipDatas or #equipDatas == 0 then
      return
    end
    local single = equipDatas[1]
    sData = Table_Item[single.id]
  end
  local partIndex = ItemUtil.getItemRolePartIndex(sData.id)
  self.model = UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, sData.id)
  local isfashion = BagProxy.fashionType[sData.Type]
  if isfashion then
    tempV3:Set(0, 0.5, 0)
    self.model:ResetLocalPosition(tempV3)
  end
  tempV3:Set(2, 2, 2)
  self.model:ResetLocalScale(tempV3)
end
function ItemTipModelCell:OnExit()
  if self.cardCell then
    self.cardCell:SetData()
  end
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
  if self.gainwayCtl then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
  self.attriCtl:ResetDatas()
  UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
end
