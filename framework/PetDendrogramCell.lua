local BaseCell = autoImport("BaseCell")
PetDendrogramCell = class("PetDendrogramCell", BaseCell)
PetDendrogramCell.CellResID = ResourcePathHelper.UICell("PetComposePreviewCell")
function PetDendrogramCell:Init()
  self:InitView()
  self:AddCellClickEvent()
end
function PetDendrogramCell:InitView()
  self.pos = self:FindGO("Item")
  self.icon = self:FindComponent("Icon", UISprite)
  self.plus = self:FindGO("Plus")
  self.friendlyImg = self:FindGO("FriendlyImg")
  self.lvLabel = self:FindComponent("LvLab", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
end
function PetDendrogramCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.pos)
    if "PetComposeDendrogram" == data.__cname then
      local obj = self:CreatSubTree()
      if obj then
        IconManager:SetNpcMonsterIconByID(data.rootId, self.icon)
        self.subTree = PetComposePreviewCell.new(obj, data.rootId, data.needRecursive)
      end
    elseif "DendrogramPart" == data.__cname then
      IconManager:SetNpcMonsterIconByID(data.root, self.icon)
      self:SetFriendLvl()
      if data.needRecursive then
        ColorUtil.WhiteUIWidget(self.icon)
        self:Hide(self.plus)
      elseif nil == PetComposeProxy.Instance:GetComposeGuid(data.index) then
        ColorUtil.ShaderLightGrayUIWidget(self.icon)
        self:Show(self.plus)
      else
        ColorUtil.WhiteUIWidget(self.icon)
        self:Hide(self.plus)
      end
    end
  else
    self:Hide(self.pos)
  end
end
function PetDendrogramCell:SetFriendLvl()
  if self.data.needRecursive then
    self:Hide(self.lvLabel)
    self:Hide(self.friendlyImg)
  elseif self.data.rootCsv.friendlv then
    self:Show(self.lvLabel)
    self:Show(self.friendlyImg)
    self.lvLabel.text = string.format("Lv.%s", self.data.rootCsv.friendlv)
  else
    self:Hide(self.lvLabel)
    self:Hide(self.friendlyImg)
  end
end
function PetDendrogramCell:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.PetFuse, self.effectContainer, false)
end
local tempVector3 = LuaVector3.zero
function PetDendrogramCell:CreatSubTree()
  if self.icon then
    local subTree = self:CreateObj(PetDendrogramCell.CellResID, self.icon.gameObject)
    tempVector3:Set(0, -288, 0)
    subTree.transform.localPosition = tempVector3
    return subTree
  end
  errorLog("PetDendrogramCell cannot find icon component")
  return nil
end
