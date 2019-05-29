ShopConfirmPanel = class("ShopConfirmPanel", BaseView)
ShopConfirmPanel.ViewType = UIViewType.PopUpLayer
function ShopConfirmPanel:Init()
  self.data = self.viewdata.viewdata and self.viewdata.viewdata.data or nil
  self.callback = self.data.callback
  local panelAction = self:FindGO("pannelAction")
  local cancelBtn = self:FindGO("cancel", panelAction)
  self:AddClickEvent(cancelBtn, function(go)
    self:CloseSelf()
  end)
  local confirmBtn = self:FindGO("comfirm", panelAction)
  self:AddClickEvent(confirmBtn, function(go)
    self:dealCallback()
  end)
  local detailConfirmBtn = self:FindGO("detailConfirm", detailTxtContainer)
  self:AddClickEvent(detailConfirmBtn, function(go)
    detailTxtContainer:SetActive(false)
  end)
  local title = self:FindGO("title"):GetComponent(UILabel)
  title.text = self.data.title
  local des = self:FindGO("des"):GetComponent(UILabel)
  des.text = self.data.desc
  local ScrollView = self:FindGO("ScrollView")
  local detailTxt = self:FindGO("Text", ScrollView):GetComponent(UILabel)
  detailTxt.text = ZhString.ShopConfirmDesTxT
end
function ShopConfirmPanel:dealCallback()
  self:CloseSelf()
  if self.callback then
    self.callback()
  end
end
function ShopConfirmPanel:OnEnter()
  ShopConfirmPanel.super.OnEnter(self)
end
function ShopConfirmPanel:OnExit()
  ShopConfirmPanel.super.OnExit(self)
end
