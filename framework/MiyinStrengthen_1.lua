autoImport("ItemCell")
autoImport("ItemFun")
autoImport("FunctionMiyinStrengthen")
MiyinStrengthen = class("MiyinStrengthen", SubView)
MiyinStrengthen.PfbPath = "part/MiyinStrengthen"
function MiyinStrengthen:Init()
  self:Listen()
end
function MiyinStrengthen:InitUI()
  self.contaienr = self:FindGO("MiyinStrengthenParent")
  self.gameObject = self:LoadPreferb(MiyinStrengthen.PfbPath, self.contaienr, true)
  self.gameObject.transform.localPosition = Vector3.zero
  self:CollectGO()
  self:AddButtonClickEvent()
  self:RegisterItemViewClickEvent()
end
function MiyinStrengthen:CollectGO()
  self.previewCell = self:FindGO("ItemCell", self.leftContent)
  self.itemPreviewCell = ItemCell.new(self.previewCell)
  self.goNowLevel = self:FindGO("Now")
  self.labNowLevelValue = self:FindGO("LevelValue", self.goNowLevel):GetComponent(UILabel)
  self.labNowAttributeTitle = self:FindGO("AttributeTitle", self.goNowLevel):GetComponent(UILabel)
  self.labNowAttributeValue = self:FindGO("AttributeValue", self.goNowLevel):GetComponent(UILabel)
  self.goNextLevel = self:FindGO("Next")
  self.labnextLevelTitle = self:FindGO("LevelTitle", self.goNextLevel):GetComponent(UILabel)
  self.labNextLevelValue = self:FindGO("LevelValue", self.goNextLevel):GetComponent(UILabel)
  self.labNextAttributeTitle = self:FindGO("AttributeTitle", self.goNextLevel):GetComponent(UILabel)
  self.labNextAttributeValue = self:FindGO("AttributeValue", self.goNextLevel):GetComponent(UILabel)
  self.goMaxLevel = self:FindGO("Max")
  self.labMaxLabel = self.goMaxLevel:GetComponent(UILabel)
  self.labEquipName = self:FindGO("EquipName", self.leftContent):GetComponent(UILabel)
  self.goCost = self:FindGO("CostDesc")
  self.labCost = self:FindGO("Cost", self.leftContent):GetComponent(UILabel)
  self.goMiyinCost = self:FindGO("Miyin", self.goCost)
  self.labMiyinCost = self:FindGO("Count", self.goMiyinCost):GetComponent(UILabel)
  self.strengthOneBtn = self:FindGO("StrengthOneBtn")
  self.goLevelChangeEmpty = self:FindGO("LevelChangeEmpty")
  self.goNow = self:FindGO("Now")
  self.goNext = self:FindGO("Next")
  self.spUpgradeSymbol = self:FindGO("UpgradeSp"):GetComponent(UISprite)
  self.goItemName = self:FindGO("CurrentEquipName")
  local go = self:FindGO("Sprite", self.goLevelChangeEmpty)
  go:SetActive(false)
  go = self:FindGO("TipLabel", self.goLevelChangeEmpty)
  go:SetActive(false)
  local lbl = self.goLevelChangeEmpty:GetComponent(UILabel)
  lbl.text = OverSea.LangManager.Instance():GetLangByKey("\232\175\183\231\130\185\229\135\187\226\128\156      \226\128\157"):gsub("      ", "+") .. OverSea.LangManager.Instance():GetLangByKey("\233\128\137\230\139\169\230\137\128\233\156\128\231\188\157\231\186\171\229\138\160\229\155\186\231\154\132\232\163\133\229\164\135")
  lbl.overflowMethod = 2
  lbl.width = 462
  lbl.transform.localPosition = Vector3(-93, -178)
end
function MiyinStrengthen:AddButtonClickEvent()
  self:AddClickEvent(self.strengthOneBtn, function(go)
    self:OnButtonStrengthOnceClick()
  end)
end
function MiyinStrengthen:RegisterItemViewClickEvent()
  self.goBC = self:FindGO("BC", self.contaienr)
  self:AddClickEvent(self.goBC, function(go)
    self:OnClickForViewItem(go)
  end)
end
function MiyinStrengthen:Listen()
  self:AddListenEvt(ServiceEvent.ItemEquipStrength, self.StrengthHandler)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnReceiveEquipUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnReceiveItemUpdate)
end
function MiyinStrengthen:GetItemDataFromPartIndex(index)
  local equipsData = BagProxy.Instance.roleEquip.siteMap
  return equipsData[index]
end
function MiyinStrengthen:GetItemData()
  return self.itemData
end
local buildingType = 4
function MiyinStrengthen:UpdateInfo()
  local itemData = self:GetItemData()
  if itemData ~= nil then
    self.itemPreviewCell:SetData(itemData)
    local equipInfo = itemData.equipInfo
    local levelMax = GuildBuildingProxy.Instance:GetStrengthMaxLvl()
    local currentLv = equipInfo.strengthlv2
    local strLevelValue = currentLv .. "/" .. levelMax
    self.labNowLevelValue.text = strLevelValue
    local strAttributeName
    local separator = ":"
    local iAttributeValue = 0
    local attrDetail = ItemFun.calcStrengthAttr(itemData.staticData.Quality, itemData.equipInfo.equipData.EquipType, currentLv)
    local attrID
    for k, v in pairs(attrDetail) do
      attrID = k
      iAttributeValue = v
      break
    end
    self.attrID = attrID
    strAttributeName = Table_RoleData[attrID].PropName
    self.labNowAttributeTitle.text = strAttributeName .. separator
    self.labNowAttributeValue.text = iAttributeValue
    local levelIsReachMax = levelMax <= currentLv
    if levelIsReachMax then
      self.levelReachMax = true
      self.labnextLevelTitle.enabled = false
      self.labNextLevelValue.enabled = false
      self.labNextAttributeTitle.enabled = false
      self.labNextAttributeValue.enabled = false
      self.goMaxLevel:SetActive(true)
    else
      self.levelReachMax = false
      self.labnextLevelTitle.enabled = true
      self.labNextLevelValue.enabled = true
      self.labNextAttributeTitle.enabled = true
      self.labNextAttributeValue.enabled = true
      self.goMaxLevel:SetActive(false)
      local iUpgradeAttrValue = 0
      local nextLv = currentLv + 1
      self.upgradeLevel = nextLv
      attrDetail = ItemFun.calcStrengthAttr(itemData.staticData.Quality, itemData.equipInfo.equipData.EquipType, nextLv)
      for k, v in pairs(attrDetail) do
        attrID = k
        iUpgradeAttrValue = v
        break
      end
      self.labNextLevelValue.text = nextLv
      strAttributeName = Table_RoleData[attrID].PropName
      self.labNextAttributeTitle.text = strAttributeName .. separator
      self.labNextAttributeValue.text = iUpgradeAttrValue
    end
    self.labEquipName.text = itemData:GetName()
    if levelIsReachMax then
      self.goCost:SetActive(false)
    else
      self.goCost:SetActive(true)
    end
  end
end
function MiyinStrengthen:OnButtonStrengthOnceClick()
  if self.buildingIsPlayingStrengthenAnim then
    return
  end
  local itemData = self:GetItemData()
  if itemData == nil then
    MsgManager.ShowMsgByIDTable(216)
    return
  end
  if self.levelReachMax then
    MsgManager.ShowMsgByIDTable(210)
    return
  end
  local enough, need = self:CheckCost()
  if not enough then
    MsgManager.ShowMsgByIDTable(1)
  end
  local enough, need = self:CheckCost_Miyin()
  if not enough then
    local needItemsList = ReusableTable.CreateArray()
    local needItem = ReusableTable.CreateTable()
    needItem.id = 5030
    needItem.count = need
    TableUtility.ArrayPushBack(needItemsList, needItem)
    QuickBuyProxy.Instance:TryOpenView(needItemsList)
    ReusableTable.DestroyArray(needItemsList)
  end
  ServiceItemProxy.Instance:CallEquipStrength(itemData.id, 1, nil, nil, nil, nil, nil, SceneItem_pb.ESTRENGTHTYPE_GUILD)
  self.buildingIsPlayingStrengthenAnim = true
  LeanTween.delayedCall(GameConfig.EquipRefine.delay_time / 1000, function()
    self.buildingIsPlayingStrengthenAnim = false
  end)
end
function MiyinStrengthen:CheckCost()
  local itemData = self:GetItemData()
  if itemData ~= nil then
    return CostUtil.CheckMiyinStrengthCost_Zeny(itemData.staticData, self.upgradeLevel)
  end
  return false, 0, 0
end
function MiyinStrengthen:CheckCost_Miyin()
  local itemData = self:GetItemData()
  if itemData ~= nil then
    return CostUtil.CheckMiyinStrengthCost_Miyin(itemData.staticData, self.upgradeLevel)
  end
  return false, 0, 0
end
function MiyinStrengthen:UpdateCost()
  local itemData = self:GetItemData()
  if itemData == nil then
    return
  end
  if not self.levelReachMax then
    local enough, need = self:CheckCost()
    need = need or 0
    need = math.floor(need)
    self.labCost.text = need
    if enough then
      self.labCost.color = Color(0.4, 0.4, 0.4, 1)
    else
      self.labCost.color = Color(1, 0, 0, 1)
    end
    enough, need = self:CheckCost_Miyin()
    need = need or 0
    need = math.floor(need)
    self.labMiyinCost.text = need
    if enough then
      self.labMiyinCost.color = Color(0.4, 0.4, 0.4, 1)
    else
      self.labMiyinCost.color = Color(1, 0, 0, 1)
    end
  end
end
function MiyinStrengthen:StrengthHandler(note)
  self:RefreshSelf()
  note = note.body
  local pos = self.previewCell.transform.position
  local strengthenCount = note.count
  if strengthenCount > 0 then
    local growLv = note.newlv - note.oldlv
    local itemData = self:GetItemData()
    local strAttributeName = Table_RoleData[self.attrID].PropName
    local addEffect = strAttributeName .. " +" .. self:CaculateDeltaAdditionalAttrValue(note.oldlv, note.newlv)
    if 0 < note.cricount then
      self:PlayUIEffect(EffectMap.UI.upgrade_surprised, self.itemPreviewCell.gameObject, true, MiyinStrengthen.Upgrade_surprisedEffectHandle, self)
    else
      self:PlayUIEffect(EffectMap.UI.upgrade_success, self.itemPreviewCell.gameObject, true, MiyinStrengthen.Upgrade_successEffectHandle, self)
    end
    if note.result == SceneItem_pb.ESTRENGTHRESULT_NOMATERIAL then
      if 0 < note.cricount then
        MsgManager.ShowEightTypeMsgByIDTable(214, {
          note.count,
          note.cricount,
          addEffect
        }, pos, {0, 10})
      else
        MsgManager.ShowEightTypeMsgByIDTable(215, {
          note.count,
          addEffect
        }, pos, {0, 10})
      end
    elseif note.destcount == 1 then
      if 0 < note.cricount then
        MsgManager.ShowEightTypeMsgByIDTable(212, {
          note.count,
          note.cricount,
          addEffect
        }, pos, {0, 10})
      else
        MsgManager.ShowEightTypeMsgByIDTable(211, {growLv, addEffect}, pos, {0, 10})
      end
    elseif 0 < note.cricount then
      MsgManager.ShowEightTypeMsgByIDTable(212, {
        note.count,
        note.cricount,
        addEffect
      }, pos, {0, 10})
    else
      MsgManager.ShowEightTypeMsgByIDTable(213, {
        note.count,
        addEffect
      }, pos, {0, 10})
    end
  end
end
function MiyinStrengthen.Upgrade_surprisedEffectHandle(effectHandle, owner)
  NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end
function MiyinStrengthen.Upgrade_successEffectHandle(effectHandle, owner)
  NGUIUtil.ChangeRenderQ(effectHandle.gameObject, 3100)
end
function MiyinStrengthen:Show()
  if not self.init then
    self.init = true
    self:InitUI()
  end
  self:UpdateCost()
  self.gameObject:SetActive(true)
end
function MiyinStrengthen:Hide()
  if self.init then
    self.gameObject:SetActive(false)
  end
end
function MiyinStrengthen:Refresh(item_data)
  if item_data ~= nil then
    self:SetNormal()
    self.itemData = item_data
    self:UpdateInfo()
    self:UpdateCost()
  end
end
function MiyinStrengthen:RefreshSelf()
  if self.itemData then
    self:Refresh(self.itemData)
  end
end
function MiyinStrengthen:SetEmpty()
  self.goNow:SetActive(false)
  self.goNext:SetActive(false)
  self.goMaxLevel:SetActive(false)
  self.spUpgradeSymbol.enabled = false
  self.goLevelChangeEmpty:SetActive(true)
  self.labCost.text = ""
  self.goItemName:SetActive(false)
  self.goCost:SetActive(false)
  self.strengthOneBtn:SetActive(false)
  self.itemPreviewCell:SetData(nil)
end
function MiyinStrengthen:SetNormal()
  self.goNow:SetActive(true)
  self.goNext:SetActive(true)
  self.goMaxLevel:SetActive(true)
  self.spUpgradeSymbol.enabled = true
  self.goLevelChangeEmpty:SetActive(false)
  self.goItemName:SetActive(true)
  self.goCost:SetActive(true)
  self.strengthOneBtn:SetActive(true)
end
function MiyinStrengthen:OnReceiveEquipUpdate()
  self:RefreshSelf()
end
function MiyinStrengthen:OnReceiveItemUpdate()
  self:UpdateCost()
  self:RefreshSelf()
end
function MiyinStrengthen:OnExit()
  self.super.OnExit(self)
end
function MiyinStrengthen:OnClickForViewItem(go)
  UIViewControllerMiyinStrengthen.instance:LoadView_EquipChooseBoard()
end
function MiyinStrengthen:CaculateDeltaAdditionalAttrValue(lv, upgrade_lv)
  local additionalAttrValue
  local itemData = self:GetItemData()
  local additionalAttrs = ItemFun.calcStrengthAttr(itemData.staticData.Quality, itemData.equipInfo.equipData.EquipType, lv)
  for _, v in pairs(additionalAttrs) do
    additionalAttrValue = v
    break
  end
  local upgradeAdditionalAttrValue
  additionalAttrs = ItemFun.calcStrengthAttr(itemData.staticData.Quality, itemData.equipInfo.equipData.EquipType, upgrade_lv)
  for _, v in pairs(additionalAttrs) do
    upgradeAdditionalAttrValue = v
    break
  end
  return upgradeAdditionalAttrValue - additionalAttrValue
end
