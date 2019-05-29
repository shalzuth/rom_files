autoImport("BaseTip")
PropTipHelp = class("PropTipHelp", BaseTip)
function PropTipHelp:ctor(prefabName, stick, side, offset)
  PropTipHelp.super.ctor(self, prefabName, stick.gameObject)
  self.stick = stick
  self.side = side
  self.offset = offset
  self:InitView()
end
function PropTipHelp:InitView()
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
  local title = self:FindComponent("title", UILabel)
  title.text = ZhString.Charactor_Help_Title
  local FormLabelCt = self:FindComponent("FormLabelCt", UILabel)
  FormLabelCt.text = ZhString.Charactor_Help_FormLabelCt
  local FormUnit = self:FindComponent("FormUnit", UILabel)
  FormUnit.text = ZhString.Charactor_Help_FormUnit
  local FormName = self:FindComponent("FormName", UILabel)
  FormName.text = ZhString.Charactor_Help_FormName
  local FormLabel = self:FindComponent("FormLabel", UILabel)
  FormLabel.text = ZhString.Charactor_Help_FormLabel
  local FormPromot = self:FindComponent("FormPromot", UILabel)
  FormPromot.text = ZhString.Charactor_Help_FormPromot
  local FormDetail = self:FindComponent("FormDetail", UILabel)
  FormDetail.text = ZhString.Charactor_Help_FormDetail
  local FormDetailValue = self:FindComponent("FormDetailValue", UILabel)
  FormDetailValue.text = ZhString.Charactor_Help_FormDetailValue
  local UnitLabelCt = self:FindComponent("UnitLabelCt", UILabel)
  UnitLabelCt.text = ZhString.Charactor_Help_FormName
  local Unit_PerLabel = self:FindComponent("Unit_PerLabel", UILabel)
  Unit_PerLabel.text = ZhString.Charactor_Help_Unit_PerLabel
  local Unit_divideLabel = self:FindComponent("Unit_divideLabel", UILabel)
  Unit_divideLabel.text = ZhString.Charactor_Help_Unit_divideLabel
  local Unit_dividesecondLabel = self:FindComponent("Unit_dividesecondLabel", UILabel)
  Unit_dividesecondLabel.text = ZhString.Charactor_Help_Unit_dividesecondLabel
  local Unit_secondLabel = self:FindComponent("Unit_secondLabel", UILabel)
  Unit_secondLabel.text = ZhString.Charactor_Help_Unit_secondLabel
  local SignLabelCt = self:FindComponent("SignLabelCt", UILabel)
  SignLabelCt.text = ZhString.Charactor_Help_SignLabelCt
  local NoSignLabel = self:FindComponent("NoSignLabel", UILabel)
  NoSignLabel.text = ZhString.Charactor_Help_NoSignLabel
  local SignLabel = self:FindComponent("SignLabel", UILabel)
  SignLabel.text = ZhString.Charactor_Help_SignLabel
  local ColorLabelCt = self:FindComponent("ColorLabelCt", UILabel)
  ColorLabelCt.text = ZhString.Charactor_Help_ColorLabelCt
  local ColorValueLabel = self:FindComponent("ColorValueLabel", UILabel)
  ColorValueLabel.text = ZhString.Charactor_Help_NoSignLabelt
end
function PropTipHelp:CloseSelf()
  TipsView.Me():HideCurrent()
end
function PropTipHelp:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
