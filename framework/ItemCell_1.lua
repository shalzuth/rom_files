autoImport("BaseCDCell")
autoImport("ItemCardCell")
autoImport("PortraitFrameCell")
ItemCell = class("ItemCell", BaseCDCell)
ItemCell.Config = {
  PicId = 50,
  PetPicId = 51,
  ChipId = 110
}
local EquipLv_SpriteMap = {
  [1] = "equip_icon_1",
  [2] = "equip_icon_2",
  [3] = "equip_icon_3"
}
local tempV3 = LuaVector3()
local CELL_PART_PATH_PREFIX = "GUI/v1/cell/ItemCellParts/ItemCell_"
function ItemCell:LoadCellPart(key, parent, minDepth)
  local go = self:LoadPreferb_ByFullPath(CELL_PART_PATH_PREFIX .. key, parent)
  if go == nil then
    return
  end
  if self.minDepth then
    local ws = UIUtil.GetAllComponentInChildren(go, UIWidget)
    if ws then
      for i = 1, #ws do
        ws[i].depth = ws[i].depth + self.minDepth
      end
    end
  end
  return go
end
function ItemCell:Init()
  ItemCell.super.Init(self)
  self:InitItemCell()
end
function ItemCell:SetDefaultBgSprite(atlas, spriteName)
  self.DefaultBg_atlas = atlas
  self.DefaultBg_spriteName = spriteName
end
function ItemCell:InitItemCell()
  self.item = self:FindGO("Item")
  self.empty = self:FindGO("Empty")
  self.empty_hideIcon = self:FindGO("HideIconSymbol", self.empty)
  self.normalItem = self:FindGO("NormalItem")
  self.iconGO = self:FindGO("Icon_Sprite", self.normalItem)
  self.iconTrans = self.iconGO and self.iconGO.transform
  self.icon = self.iconGO and self.iconGO:GetComponent(UISprite)
  self.newTag = self:FindGO("NewTag", self.normalItem)
  self.invalid = self:FindGO("Invalid", self.normalItem)
  self.nameLab = self:FindComponent("ItemName", UILabel)
  self.coldDown = self:FindComponent("ColdDown", UISprite, self.item)
  self.numHide = false
end
function ItemCell:InitCardSlot()
  if not self.initCardSlot then
    self.initCardSlot = true
  end
end
function ItemCell:RemoveUnuseObj(key)
  if not self:ObjIsNil(self[key]) then
    GameObject.DestroyImmediate(self[key])
    self[key] = nil
  end
end
function ItemCell:SetData(data)
  self.data = data
  local cellGO = self.item or self.gameObject
  if data == nil or data.staticData == nil then
    if self.empty then
      self:SetGOActive(self.empty, true)
      if self.empty_hideIcon and self.empty_hideIcon.activeSelf then
        self:SetGOActive(self.empty_hideIcon, false)
      end
    end
    if cellGO then
      self:SetGOActive(cellGO, false)
    end
    return
  end
  if cellGO then
    self:SetGOActive(cellGO, true)
  end
  if self.empty then
    self:SetGOActive(self.empty, false)
  end
  self:UpdateNumLabel(data.num or 0)
  self:ActiveNewTag(data:IsNew())
  self:SetCardInfo(data)
  if self.nameLab then
    self.nameLab.text = self.data:GetName()
  end
  if self.isCard then
    return
  end
  local itemType = self.data and self.data.staticData and self.data.staticData.Type
  if self.iconGO then
    local setSuc = false
    if itemType == 1200 then
      setSuc = IconManager:SetFaceIcon(data.staticData.Icon, self.icon)
      setSuc = setSuc or IconManager:SetFaceIcon("boli", self.icon)
      tempV3:Set(0.71, 0.71, 0.71)
    else
      local sIcon = data.petEggInfo and data.petEggInfo:PetMountCanEquip() and GameConfig.Pet.PetMountIcon[data.staticData.id] or data.staticData.Icon
      setSuc = IconManager:SetItemIcon(sIcon, self.icon)
      setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.icon)
      tempV3:Set(1, 1, 1)
    end
    if setSuc then
      self:SetGOActive(self.iconGO, true)
      self.icon:MakePixelPerfect()
      self.iconTrans.localScale = tempV3
    else
      self:SetGOActive(self.iconGO, false)
    end
  end
  self:SetActiveSymbol(data.isactive == true)
  self:SetPic(itemType)
  self:SetQuestIcon(itemType)
  self:SetFunctionTip(itemType)
  self:SetShopCorner(itemType)
  self:SetPetFlag(itemType)
  self:SetUseItemInvalid(data)
  self:SetFoodStars(data)
  self:SetLimitTimeCorner(data)
  self:SetEquipInfo(data)
end
function ItemCell:ActiveNewTag(b)
  if self.newTag == nil then
    return
  end
  self.newTag:SetActive(b)
end
function ItemCell:SetActiveSymbol(active)
  if not active then
    if self.activeSymbol then
      self.activeSymbol:SetActive(false)
    end
    return
  end
  if self.activeSymbol == nil then
    self.activeSymbol = self:LoadCellPart("ActiveSymbol", self.item)
  end
  self.activeSymbol:SetActive(true)
end
local Config_QuestItemIcon = GameConfig.QuestItemIcon
function ItemCell:SetQuestIcon(itemType)
  if Config_QuestItemIcon == nil or itemType == nil then
    return
  end
  local iconName = Config_QuestItemIcon[itemType]
  if iconName == nil then
    if self.questFlagIconGO then
      self.questFlagIconGO:SetActive(false)
    end
    return
  end
  if self.questFlagIconGO == nil then
    self.questFlagIconGO = self:LoadCellPart("QuestFlagIcon", self.normalItem)
    self.questFlagIcon = self:FindGO("QuestFlagIcon", self.questFlagIconGO):GetComponent(UISprite)
  end
  self.questFlagIconGO:SetActive(true)
  IconManager:SetUIIcon(iconName, self.questFlagIcon)
end
function ItemCell:SetPic(itemType)
  local isPic = itemType == self.Config.PicId or itemType == self.Config.PetPicId
  if not isPic then
    if self.bg_inited and self.bg then
      local spName = self.DefaultBg_spriteName or "com_icon_bottom3"
      if self.bg.spriteName ~= spName then
        self.bg.atlas = self.DefaultBg_atlas or RO.AtlasMap.GetAtlas("NewCom")
        self.bg.spriteName = spName
      end
    end
    return
  end
  IconManager:SetUIIcon("icon_34", self:GetBgSprite())
end
function ItemCell:GetBgSprite()
  if not self.bg_inited then
    self.bg_inited = true
    self.bg = self:FindComponent("Background", UISprite, self.normalItem)
  end
  return self.bg
end
local _AdventureDataProxy
function ItemCell:SetCardInfo(data)
  local dType = data.staticData.Type
  if _AdventureDataProxy == nil then
    _AdventureDataProxy = AdventureDataProxy.Instance
  end
  self.isCard = _AdventureDataProxy:isCard(dType)
  if self.normalItem then
    self.normalItem:SetActive(not self.isCard)
  end
  if not self.isCard then
    if self.cardItem then
      self.cardItem:SetData(nil)
    end
    return
  end
  if not self.cardItem then
    local cardobj = self:LoadPreferb("cell/ItemCardCell", self.item or self.gameObject)
    self.cardItem = ItemCardCell.new(cardobj)
  end
  self.cardItem:SetData(data)
end
function ItemCell:SetFunctionTip(itemType)
  if itemType ~= 65 then
    if self.functionTip then
      self.functionTip:SetActive(false)
    end
    return
  end
  if self.functionTip == nil then
    self.functionTip = self:LoadCellPart("FunctionTip", self.normalItem)
  end
  self.functionTip:SetActive(true)
end
function ItemCell:SetShopCorner(itemType)
  if itemType ~= 61 then
    if self.shopCorner then
      self.shopCorner:SetActive(false)
    end
    return
  end
  if self.shopCorner == nil then
    self.shopCorner = self:LoadCellPart("ShopCorner", self.normalItem)
  end
  self.shopCorner:SetActive(true)
end
function ItemCell:SetPetFlag(itemType)
  if itemType ~= 51 and itemType ~= 52 then
    if self.petFlag then
      self.petFlag:SetActive(false)
    end
    return
  end
  if self.petFlag == nil then
    self.petFlag = self:LoadCellPart("PetFlag", self.normalItem)
  end
  self.petFlag:SetActive(true)
end
function ItemCell:SetLimitTimeCorner(data)
  local existTimeType = data and data.staticData and data.staticData.ExistTimeType
  if existTimeType ~= 1 and existTimeType ~= 2 and existTimeType ~= 3 then
    if self.limitTimeCorner then
      self.limitTimeCorner:SetActive(false)
    end
    return
  end
  if self.limitTimeCorner == nil then
    self.limitTimeCorner = self:LoadCellPart("LimitTimeCorner", self.normalItem)
  end
  self.limitTimeCorner:SetActive(true)
end
function ItemCell:SetFoodStars(data)
  local foodSData = data and data:GetFoodSData()
  if foodSData == nil then
    if self.foodStars then
      self.foodStars[0]:SetActive(false)
    end
    return
  end
  if not self.foodStars_Init then
    self.foodStars_Init = true
    self.foodStars = {}
    self.foodStars[0] = self:LoadCellPart("FoodStars", self.normalItem)
    for i = 1, 5 do
      self.foodStars[-i] = self:FindGO(tostring(i), self.foodStars[0])
      self.foodStars[i] = self.foodStars[-1 * i]:GetComponent(UISprite)
    end
  end
  local cookHard = foodSData.CookHard
  if cookHard == nil or cookHard <= 0 then
    self.foodStars[0]:SetActive(false)
    return
  end
  self.foodStars[0]:SetActive(true)
  local num = math.floor(cookHard / 2)
  for i = 1, 5 do
    if i <= num then
      self.foodStars[-i]:SetActive(true)
      self.foodStars[i].spriteName = "food_icon_08"
    elseif i == num + 1 and cookHard % 2 == 1 then
      self.foodStars[-i]:SetActive(true)
      self.foodStars[i].spriteName = "food_icon_09"
    else
      self.foodStars[-i]:SetActive(false)
    end
  end
end
function ItemCell:SetEquipInfo(data)
  local equipInfo = data.equipInfo
  if equipInfo == nil then
    if self.equip_Inited then
      self:UpdateEquipInfo(data)
    end
    return
  end
  self:InitEquipPart()
  self:UpdateEquipInfo(data)
end
function ItemCell:InitEquipPart()
  if self.equip_Inited then
    return
  end
  self.equip_Inited = true
  self.equipGO = self:LoadCellPart("Equip", self.normalItem)
  local attrGO = self:FindGO("AttrGrid", self.equipGO)
  if attrGO then
    self.attrGrid = attrGO:GetComponent(UIGrid)
    local strenglvGO = self:FindGO("StrengLv", attrGO)
    self.strenglv = strenglvGO:GetComponent(UILabel)
    local refinelvGO = self:FindGO("RefineLv", attrGO)
    self.refinelv = refinelvGO:GetComponent(UILabel)
    local equiplvGO = self:FindGO("EquipLv", attrGO)
    self.equiplv = equiplvGO:GetComponent(UILabel)
  end
  self.damageSymbol = self:FindGO("Break", self.equipGO)
  self.bebreaked = self:FindComponent("BeBreaked", UISprite, self.equipGO)
  self.bebreakedbg = self:FindGO("BeBreakedBG", self.equipGO)
  self.bebreakedbg:SetActive(false)
  local bebreakedtext = self:FindGO("BeBreakedText", self.equipGO)
  self.bebreakedlabel = bebreakedtext:GetComponent(UILabel)
  self.bebreakedlabel.text = ZhString.ItemIcon_Repair
  self.cardSlotGO = self:FindGO("CardSlot", self.equipGO)
  local slotCpy = self:FindGO("CardEquip1", self.cardSlotGO)
  self.cardSlotSymbols = {}
  for i = 1, 5 do
    local cardGO
    if i == 1 then
      cardGO = slotCpy
    else
      cardGO = self:FindGO("CardEquip" .. i, self.cardSlotGO)
      if not cardGO then
        cardGO = self:CopyGameObject(slotCpy, self.cardSlotGO)
        cardGO.name = "CardEquip" .. i
      end
    end
    local cardSp = cardGO:GetComponent(UISprite)
    self.cardSlotSymbols[-i] = cardGO
    self.cardSlotSymbols[i] = cardSp
  end
end
function ItemCell:UpdateEquipInfo(data)
  local equipInfo = data.equipInfo
  if equipInfo == nil then
    self.equipGO:SetActive(false)
    return
  end
  self.equipGO:SetActive(true)
  local st = equipInfo.site
  local st = st and st[1]
  if st then
    if st > 7 and st < 13 then
      st = 6
    end
    if st == 5 then
      st = 6 or st
    end
    if st == 1 then
      st = 7 or st
    end
    self.bebreaked.spriteName = "bag_equip_break" .. tostring(st)
  else
    self.bebreaked.spriteName = ""
  end
  if equipInfo.strengthlv > 0 then
    self.strenglv.gameObject:SetActive(true)
    self.strenglv.text = equipInfo.strengthlv
  else
    self.strenglv.gameObject:SetActive(false)
  end
  if equipInfo and 0 < equipInfo.refinelv then
    self.refinelv.gameObject:SetActive(true)
    self.refinelv.text = string.format("+%d", equipInfo.refinelv)
  else
    self.refinelv.gameObject:SetActive(false)
  end
  self.damageSymbol:SetActive(equipInfo.damage == true)
  local equiplv = data.equipInfo.equiplv
  if equiplv > 0 then
    self.equiplv.gameObject:SetActive(true)
    self.equiplv.text = StringUtil.IntToRoman(equiplv)
  else
    local artifact_lv = equipInfo.artifact_lv
    if artifact_lv and artifact_lv > 0 then
      self.equiplv.gameObject:SetActive(true)
      self.equiplv.text = StringUtil.IntToRoman(artifact_lv)
    else
      self.equiplv.gameObject:SetActive(false)
    end
  end
  local slotNum = data.cardSlotNum or 0
  local replaceCount = data.replaceCount or 0
  if equipInfo and (slotNum > 0 or replaceCount > 0) then
    self.cardSlotGO:SetActive(true)
    local cardDatas = data.equipedCardInfo or {}
    local symbols = self.cardSlotSymbols
    local count = 1
    for i = 1, #symbols do
      if i <= slotNum then
        symbols[-i]:SetActive(true)
        local spriteName = cardDatas[i] and string.format("card_icon_%02d", cardDatas[i].staticData.Quality) or "card_icon_0"
        symbols[i].spriteName = spriteName
        count = count + 1
      elseif i <= slotNum + replaceCount then
        symbols[-i]:SetActive(true)
        symbols[i].spriteName = "card_icon_lock"
        count = count + 1
      else
        symbols[-i]:SetActive(false)
      end
    end
    for i = 1, count do
      tempV3:Set(-10 * (count - 1 - i), 0, 0)
      symbols[i].transform.localPosition = tempV3
    end
  else
    self.cardSlotGO:SetActive(false)
  end
  if self.attrGrid then
    self.attrGrid:Reposition()
  end
end
function ItemCell:SetUseItemInvalid(data)
  if self.invalid == nil then
    return
  end
  if data.IsUseItem and data:IsUseItem() then
    local itemType = data.staticData.Type
    local couldUse = ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(itemType)
    if couldUse == true then
      self.invalid:SetActive(data:IsLimitUse())
    else
      self.invalid:SetActive(true)
    end
  else
    self.invalid:SetActive(false)
  end
end
function ItemCell:SetIconGrey(b)
  local data = self.data
  if data and data.staticData then
    local isCard = AdventureDataProxy.Instance:isCard(data.staticData.Type)
    if isCard then
      self:SetCardGrey(b)
    elseif self.icon then
      if not b or not Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941) then
      end
      self.icon.color = Color(1, 1, 1)
    end
  end
end
function ItemCell:SetIconDark(b)
  if self.icon then
    if not b or not Color(0.39215686274509803, 0.39215686274509803, 0.39215686274509803) then
    end
    self.icon.color = Color(1, 1, 1)
  end
end
function ItemCell:ShowMask()
  if self.spMask then
    self.spMask.enabled = true
  end
end
function ItemCell:HideMask()
  if self.spMask then
    self.spMask.enabled = false
  end
end
function ItemCell:SetMinDepth(minDepth)
  self.minDepth = minDepth
end
function ItemCell:SetCardGrey(b)
  if self.cardItem then
    self.cardItem:SetCardGrey(b)
  end
end
function ItemCell:ShowNum()
  self.numHide = false
end
function ItemCell:HideNum()
  self.numHide = true
end
function ItemCell:HideIcon()
  if self.item then
    self.item:SetActive(false)
  end
  if self.empty then
    self.empty:SetActive(true)
  end
  if self.empty_hideIcon then
    self.empty_hideIcon:SetActive(true)
  end
end
local BagType_SymbolMap = {
  [BagProxy.BagType.PersonalStorage] = "com_icon_Corner_warehouse",
  [BagProxy.BagType.Barrow] = "com_icon_Corner_wheelbarrow",
  [BagProxy.BagType.Temp] = "com_icon_Corner_temporarybag"
}
function ItemCell:UpdateBagType()
  if not self.init_bagtype then
    self.init_bagtype = true
    self.bagTypes = self:FindGO("BagTypes")
    self.bagTypes_Sp = self.bagTypes and self.bagTypes:GetComponent(UISprite)
  end
  if self.bagTypes == nil then
    return
  end
  local data = self.data
  if data and data.bagtype then
    if BagType_SymbolMap[data.bagtype] then
      self.bagTypes:SetActive(true)
      self.bagTypes_Sp.spriteName = BagType_SymbolMap[data.bagtype]
    else
      self.bagTypes:SetActive(false)
    end
  else
    self.bagTypes:SetActive(false)
  end
end
local equipUpgrade_RefreshBagType
function ItemCell:UpdateEquipUpgradeTip()
  if self.upgradeTip == nil then
    self.upgradeTip = self:FindGO("UpgradeTip")
  end
  if self.upgradeTip == nil then
    return
  end
  self.upgradeTip:SetActive(false)
  local bagtype, equipInfo
  if type(self.data) == "table" then
    bagtype = self.data.bagtype
    equipInfo = self.data.equipInfo
  end
  if equipUpgrade_RefreshBagType == nil then
    equipUpgrade_RefreshBagType = BagProxy.EquipUpgrade_RefreshBagType
  end
  if bagtype == nil or equipUpgrade_RefreshBagType[bagtype] == nil then
    return
  end
  if equipInfo == nil then
    return
  end
  if not equipInfo:CheckCanUpgradeSuccess(true) then
    return
  end
  self.upgradeTip:SetActive(true)
end
function ItemCell:UpdateNumLabel(scount, x, y, z)
  local needHide = false
  if type(scount) == "number" and scount <= 1 then
    needHide = true
  end
  if self.numHide or needHide then
    if self.numLab_Inited and self.numLab then
      self.numLab.text = ""
    end
    return
  end
  if not self.numLab_Inited then
    self.numLab_Inited = true
    self.numLabGO = self:FindGO("NumLabel", self.item)
    if self.numLabGO then
      self.numLabTrans = self.numLabGO.transform
      self.numLab = self.numLabGO:GetComponent(UILabel)
    end
  end
  if not self.numLabGO then
    return
  end
  self.numLab.text = scount
  if x and y and z then
    tempV3:Set(x, y, z)
  else
    tempV3:Set(35, -37, 0)
  end
  self.numLabTrans.localPosition = tempV3
end
function ItemCell:UpdateMyselfInfo(data)
  if self.invalid == nil then
    return
  end
  data = data or self.data
  if data == nil then
    self.invalid:SetActive(false)
    return
  end
  if data and data.IsJobLimit and data:IsJobLimit() then
    self.invalid:SetActive(true)
    return
  end
  if data.IsUseItem and data:IsUseItem() then
    return
  end
  if data.equipInfo then
    local isValid = true
    if BagProxy.BagType.RoleEquip == data.bagType or BagProxy.BagType.RoleFashionEquip == data.bagType then
      isValid = data:CanIOffEquip()
    else
      isValid = data.staticData.Type == 101 and true or data:CanEquip()
    end
    self:SetActive(self.invalid, not isValid)
  else
    self:SetActive(self.invalid, false)
  end
end
