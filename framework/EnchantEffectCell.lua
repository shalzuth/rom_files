autoImport("EnchantInfoLabelCell")
EnchantEffectCell = class("EnchantEffectCell", EnchantInfoLabelCell)
EnchantEffectState = {
  Bad,
  Normal,
  Good
}
EnchantCombineColor = Color(0.7411764705882353, 0.611764705882353, 0.8117647058823529)
function EnchantEffectCell:Init()
  EnchantEffectCell.super.Init(self)
  self.goodSymbol = self:FindComponent("GoodSymbol", UISprite)
  self.combineSymbol = self:FindGO("CombineSymbol")
  self.line = self:FindGO("Line")
end
function EnchantEffectCell:SetData(data)
  self.data = data
  if data then
    self:Show()
    if data.type == EnchantEffectType.Combine then
      self:SetCombine()
    elseif data.type == EnchantEffectType.Enchant then
      self:SetEnchantEffect()
    end
    self.line:SetActive(data.showline == true)
  else
    self:Hide()
  end
end
function EnchantEffectCell:SetEnchantEffect()
  self.name.color = Color(0.10196078431372549, 0.10196078431372549, 0.10196078431372549)
  self.combineSymbol:SetActive(false)
  local enchantAttri = self.data.enchantAttri
  local maxStr = enchantAttri.isMax and "  (max)" or ""
  if enchantAttri.propVO.isPercent then
    self.value.text = string.format("+%s%%%s", tostring(enchantAttri.value), maxStr)
  else
    self.value.text = string.format("+%s%s", tostring(enchantAttri.value), maxStr)
  end
  self:SetName(enchantAttri.name, 280)
  if self.data.withGoodTip == true then
    self:SetGoodOrBad()
  else
    self.goodSymbol.gameObject:SetActive(false)
  end
end
function EnchantEffectCell:SetCombine()
  if self.data.isWork then
    self.name.color = EnchantCombineColor
    self.combineSymbol:SetActive(true)
  else
    self.name.color = Color(0.611764705882353, 0.611764705882353, 0.611764705882353)
    self.combineSymbol:SetActive(false)
  end
  self:SetName(self.data.combineTip, 440)
  self.value.text = ""
end
function EnchantEffectCell:SetGoodOrBad(isGood)
  local enchantAttri = self.data.enchantAttri
  if enchantAttri.Quality == EnchantAttriQuality.Good then
    self.goodSymbol.gameObject:SetActive(true)
    self.goodSymbol.spriteName = "enchant_success"
  elseif enchantAttri.Quality == EnchantAttriQuality.Bad then
    self.goodSymbol.gameObject:SetActive(true)
    self.goodSymbol.spriteName = "enchant_fail"
  else
    self.goodSymbol.gameObject:SetActive(false)
  end
end
local tempV3 = LuaVector3()
function EnchantEffectCell:SetName(text, width)
  self.name.text = text
  self.name.overflowMethod = 2
  self.name:ProcessText()
  if width <= self.name.width then
    self.name.width = width
    self.name.overflowMethod = 0
    self.name:ProcessText()
  end
  tempV3:Set(-39, 0)
  self.name.transform.localPosition = tempV3
  tempV3:Set(-39 + self.name.width + 80, 0)
  self.value.transform.localPosition = tempV3
end
