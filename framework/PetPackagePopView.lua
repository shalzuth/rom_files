PetPackagePopView = class("PetPackagePopView", BaseView)
PetPackagePopView.ViewType = UIViewType.TipLayer
function PetPackagePopView:Init()
  self:GetComponents()
  self:InitView()
  local Label = self:FindGO("Label", self.noticeToggle.gameObject):GetComponent(UILabel)
  local Checkmark = self:FindGO("Checkmark", self.noticeToggle.gameObject):GetComponent(UISprite)
  local Background = self:FindGO("Background", self.noticeToggle.gameObject):GetComponent(UISprite)
  Label.pivot = UIWidget.Pivot.Center
  OverseaHostHelper:FixAnchor(Checkmark.leftAnchor, Label.transform, 0, -40)
  OverseaHostHelper:FixAnchor(Checkmark.rightAnchor, Label.transform, 0, -6)
  OverseaHostHelper:FixAnchor(Background.leftAnchor, Label.transform, 0, -38)
  OverseaHostHelper:FixAnchor(Background.rightAnchor, Label.transform, 0, -10)
  self.noticeToggle.gameObject:GetComponent(BoxCollider).size = LuaVector3(400, 100, 0)
end
function PetPackagePopView:GetComponents()
  self:AddButtonEvent("ConfirmButton", function()
    self:CloseSelf()
    EventManager.Me():DispatchEvent(UICloseEvent.PetPackagePopViewClose)
  end)
  self.notice = self:FindComponent("Notice", UILabel)
  self.noticeToggle = self:FindComponent("NoticeToggle", UIToggle)
end
function PetPackagePopView:InitView()
end
function PetPackagePopView:OnEnter()
  PetPackagePopView.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local msgid = viewdata.msgid
    if msgid == 8026 then
      local msgData = Table_Sysmsg[8026]
      if msgData then
        self.notice.text = msgData.Text
        EventDelegate.Add(self.noticeToggle.onChange, function()
          FunctionPlayerPrefs.Me():SetBool(PetPackagePart.IsNoticeShow, self.noticeToggle.value)
        end)
      end
    elseif msgid == 27180 then
      local msgData = Table_Sysmsg[27180]
      if msgData then
        self.notice.text = msgData.Text
        EventDelegate.Add(self.noticeToggle.onChange, function()
          FunctionPlayerPrefs.Me():SetBool(SetView.IsFPSShow, self.noticeToggle.value)
        end)
      end
    end
  else
  end
end
