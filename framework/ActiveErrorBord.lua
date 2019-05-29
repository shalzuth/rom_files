ActiveErrorBord = class("ActiveErrorBord", ContainerView)
ActiveErrorBord.ViewType = UIViewType.PopUpLayer
function ActiveErrorBord:Init()
  self:initView()
  self:addViewEventListener()
end
function ActiveErrorBord:initView()
  local Title = self:FindComponent("Title", UILabel)
  Title.text = ZhString.ActiveErrorBord_ErrorTitle
  local cancel = self:FindComponent("cancelLabel", UILabel)
  cancel.text = ZhString.ActiveErrorBord_Cancel
  local confirm = self:FindComponent("confirmLabel", UILabel)
  confirm.text = ZhString.ActiveErrorBord_Confirm
end
function ActiveErrorBord:addViewEventListener()
  self:AddButtonEvent("cancelBtn", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("confirmBtn", function()
    local url = GameConfig.GetActiveCodeUrl or ""
    Application.OpenURL(url)
    self:CloseSelf()
  end)
end
