HotKeyInfoView = class("HotKeyInfoView", BaseView)
HotKeyInfoView.ViewType = UIViewType.PopUpLayer
function HotKeyInfoView:Init()
  self:FindObjs()
  self:AddEvents()
  self:InitShow()
end
function HotKeyInfoView:FindObjs()
  self.keyboardTex = self:FindComponent("Keyboard", UITexture)
  self.mouseTex = self:FindComponent("Mouse", UITexture)
end
function HotKeyInfoView:AddEvents()
end
function HotKeyInfoView:InitShow()
end
function HotKeyInfoView:OnEnter()
  PictureManager.Instance:SetUI("bg_keyboard", self.keyboardTex)
  PictureManager.Instance:SetUI("bg_mouse", self.mouseTex)
end
function HotKeyInfoView:OnExit()
  PictureManager.Instance:UnLoadUI("bg_keyboard", self.keyboardTex)
  PictureManager.Instance:UnLoadUI("bg_mouse", self.mouseTex)
end
