SignInRewardGetView = class("SignInRewardGetView", BaseView)
SignInRewardGetView.ViewType = UIViewType.TipLayer
function SignInRewardGetView:Init()
  local clickZone = self:FindGO("ClickZone")
  self:AddClickEvent(clickZone, function()
    self:CloseSelf()
  end)
end
