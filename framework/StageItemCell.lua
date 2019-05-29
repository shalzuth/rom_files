autoImport("BaseItemCell")
StageItemCell = class("StageItemCell", ItemCell)
function StageItemCell:Init()
  self.super.Init(self)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.iconColor = self:FindGO("iconColor"):GetComponent(GradientUISprite)
  self:AddCellClickEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      if self.dType == "hairColor" then
        return
      end
      local data = {
        itemdata = self.data,
        funcConfig = {},
        noSelfClose = false,
        hideGetPath = true
      }
      TipManager.Instance:ShowItemFloatTip(data, self.icon, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
  end
end
function StageItemCell:SetData(data)
  self:SetMydata(data)
  self:UpdateChoose()
end
function StageItemCell:SetMydata(data)
  self.data = data
  local cellGO = self.item or self.gameObject
  if type(data) ~= "number" and (data == nil or data.staticData == nil) then
    if self.empty then
      self.empty:SetActive(true)
      if self.empty_hideIcon and self.empty_hideIcon.activeSelf then
        self.empty_hideIcon:SetActive(false)
      end
    end
    if cellGO then
      cellGO:SetActive(false)
    end
    return
  end
  if cellGO then
    cellGO:SetActive(true)
  end
  if type(data) == "number" then
    self.id = data
    self:Hide(self.icon)
    self:Show(self.iconColor)
    local hairColorData = Table_HairColor[data]
    if hairColorData then
      local topColor = hairColorData.ColorH
      local buttomColor = hairColorData.ColorD
      if topColor then
        local result, value = ColorUtil.TryParseHexString(topColor)
        if result then
          self.iconColor.gradientTop = value
        end
      end
      if buttomColor then
        local result, value = ColorUtil.TryParseHexString(buttomColor)
        if result then
          self.iconColor.gradientBottom = value
        end
      end
      self.dType = "hairColor"
    end
    return
  else
    self.id = data.staticData.id
    self.dType = data.staticData.Type
  end
  if self.icon then
    self.icon.color = LuaColor.white
    local setSuc, scale = false, Vector3.one
    self:Hide(self.iconColor)
    if self.dType == 821 or self.dType == 822 then
      local hairstyleID = ShopDressingProxy.Instance:GetHairStyleIDByItemID(self.id)
      local hairTableData = Table_HairStyle[hairstyleID]
      if hairTableData and hairTableData.Icon then
        setSuc = IconManager:SetHairStyleIcon(hairTableData.Icon, self.icon)
      end
    elseif self.dType == 823 or self.dType == 824 then
      local csvData = Table_Eye[self.id]
      if csvData and csvData.Icon then
        setSuc = IconManager:SetHairStyleIcon(csvData.Icon, self.icon)
        local csvColor = csvData.EyeColor
        if csvColor and #csvColor > 0 then
          local hasColor = false
          hasColor, eyeColor = ColorUtil.TryParseFromNumber(csvColor[1])
          self.icon.color = eyeColor
        end
      end
    else
      setSuc = IconManager:SetItemIcon(data.staticData.Icon, self.icon)
      if not setSuc then
        setSuc = IconManager:SetItemIcon("item_45001", self.icon)
        redlog("self.id", self.id)
      end
      self.icon.transform.localScale = Vector3.one
    end
    if setSuc then
      self.icon.gameObject:SetActive(true)
      self.icon:MakePixelPerfect()
      self.icon.transform.localScale = scale
    else
      self.icon.gameObject:SetActive(false)
    end
  end
  if self.nameLab then
    self.nameLab.text = self.data:GetName()
  end
end
function StageItemCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function StageItemCell:UpdateChoose()
  if self.chooseSymbol then
    if self.chooseId and self.id and self.id == self.chooseId then
      self.chooseSymbol:SetActive(true)
    else
      self.chooseSymbol:SetActive(false)
    end
  end
end
function StageItemCell:SetGrey()
  if self.dType == "eyeColor" then
    if self.iconColor then
      self.iconColor.gradientTop = ColorUtil.NGUIBlack
      self.iconColor.gradientBottom = ColorUtil.NGUIWhite
    end
  elseif self.icon then
    self.icon.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
  end
end
function StageItemCell:DeGrey()
  if self.dType == "eyeColor" then
    local hairColorData = Table_HairColor[self.id]
    if hairColorData then
      local topColor = hairColorData.ColorH
      local buttomColor = hairColorData.ColorD
      if topColor then
        local result, value = ColorUtil.TryParseHexString(topColor)
        if result then
          self.iconColor.gradientTop = value
        end
      end
      if buttomColor then
        local result, value = ColorUtil.TryParseHexString(buttomColor)
        if result then
          self.iconColor.gradientBottom = value
        end
      end
    end
  elseif self.dType == 823 or self.dType == 824 then
    local csvData = Table_Eye[self.id]
    if csvData and csvData.Icon then
      local csvColor = csvData.EyeColor
      if csvColor and #csvColor > 0 then
        local hasColor = false
        hasColor, eyeColor = ColorUtil.TryParseFromNumber(csvColor[1])
        self.icon.color = eyeColor
      end
    end
  elseif self.icon then
    self.icon.color = Color(1, 1, 1)
  end
end
