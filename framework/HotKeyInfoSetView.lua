HotKeyInfoSetView = class("HotKeyInfoSetView", BaseView)
HotKeyInfoSetView.ViewType = UIViewType.PopUpLayer
function HotKeyInfoSetView:Init()
  self:FindObjs()
  self:AddButtonEvt()
  self:InitShow()
end
function HotKeyInfoSetView:FindObjs()
  self.viewHotKeyBtn = self:FindGO("ViewHotKeyBtn")
  self.setViewBtn = self:FindGO("SetViewBtn")
  self.backLoginBtn = self:FindGO("BackLoginBtn")
end
function HotKeyInfoSetView:AddButtonEvt()
  self:AddClickEvent(self.viewHotKeyBtn, function()
    self:GotoView({
      view = PanelConfig.HotKeyInfoView
    })
  end)
  self:AddClickEvent(self.setViewBtn, function()
    self:GotoView({
      view = PanelConfig.SetView
    })
  end)
  self:AddClickEvent(self.backLoginBtn, function()
    Game.Me():BackToLogo()
  end)
end
function HotKeyInfoSetView:InitShow()
end
