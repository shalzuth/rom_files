EquipComposeCell = class("EquipComposeCell", ItemCell)
local SCALE_SIZE = 0.85
local PACKAGE_CFG = GameConfig.PackageMaterialCheck.equipcompose
function EquipComposeCell:Init()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.needChoose = self:FindGO("NeedChoose")
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = Vector3.zero
  obj.transform.localScale = Vector3.one * SCALE_SIZE
  EquipComposeCell.super.Init(self)
  self:AddCellClickEvent()
end
function EquipComposeCell:SetData(data)
  EquipComposeCell.super.SetData(self, data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    local equiplv = data.equipLvLimited
    if equiplv and equiplv > 0 then
      self:SetActive(self.equiplv, true)
      self.equiplv.text = StringUtil.IntToRoman(equiplv)
    end
    local curData = EquipComposeProxy.Instance:GetCurData()
    local choosed = 0 ~= curData:GetChooseMat(data.staticData.id)
    if self.needChoose then
      self.needChoose:SetActive(not choosed)
    end
    if choosed then
      ColorUtil.WhiteUIWidget(self.icon)
    else
      ColorUtil.ShaderGrayUIWidget(self.icon)
    end
    local own = BagProxy.Instance:GetItemNumByStaticID(data.staticData.id, PACKAGE_CFG)
    if not self.numLab then
      return
    end
    if own < data.num then
      ColorUtil.RedLabel(self.numLab)
    else
      ColorUtil.BlackLabel(self.numLab)
    end
  else
    self:Hide(self.gameObject)
  end
end
