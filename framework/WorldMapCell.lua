local BaseCell = autoImport("BaseCell")
WorldMapCell = class("WorldMapCell", BaseCell)
local EffectPath = ResourcePathHelper.EffectUI("71MapIndicates")
function WorldMapCell:Init()
  self.name = self:FindComponent("Name", UILabel)
  self.lvname = self:FindComponent("Level", UILabel)
  self:AddCellClickEvent()
end
function WorldMapCell:SetData(data)
  if data == nil then
    return
  end
  self.data = data
  self.name.text = data.NameZh
  if data.LvRange and data.LvRange[2] then
    self.lvname.text = string.format(ZhString.WorldMapMenuCell_LvTip, data.LvRange[1], data.LvRange[2])
  else
    self.lvname.text = ""
  end
  self:UpdateEffect()
end
function WorldMapCell:UpdateEffect()
  local matched = false
  local guideMapId, symbolType = FunctionGuide.Me():GetGuildMapId()
  if guideMapId == nil or self.data == nil or self.data.id ~= guideMapId then
    if self.effectGO ~= nil then
      self.effectGO:SetActive(false)
    end
    return
  end
  if self.effectGO == nil then
    self.effectGO = self:FindGO("Effect")
    local effectContainer = self:FindGO("EffectContainer", self.effectGO)
    self.effectContainer_ChangeRq = effectContainer:GetComponent(ChangeRqByTex)
    Game.AssetManager_UI:CreateAsset(EffectPath, effectContainer)
  end
  if self.symbolEffect then
    GameObject.Destroy(self.symbolEffect)
    self.symbolEffect = nil
  end
  local config = QuestSymbolConfig[symbolType]
  local effectId = config and config.UISymbol
  if effectId then
    self.symbolEffect = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIEffect(effectId), self.effectGO.transform)
  end
  self.effectGO:SetActive(true)
  self.effectContainer_ChangeRq.excute = false
end
function WorldMapCell:SetChoose(obj)
  if obj == nil then
    return
  end
  obj.transform:SetParent(self.trans, true)
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
end
