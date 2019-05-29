autoImport("BaseTip")
GeneralHelp = class("GeneralHelp", BaseTip)
local tempVector3 = LuaVector3.zero
function GeneralHelp:Init()
  self:FindObjs()
  self.spritelabel = SpriteLabel.new(self.introduceLabel)
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    self:CloseSelf()
  end)
  local activeH = GameObjectUtil.Instance:GetUIActiveHeight(self.gameObject)
  tempVector3:Set(1280, activeH, 0)
  self.collider.size = tempVector3
end
function GeneralHelp:FindObjs()
  self.scrollView = self:FindGO("IntroduceScrollView"):GetComponent(UIScrollView)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.introduceLabel = self:FindGO("IntroduceLabel"):GetComponent(UIRichLabel)
  self.collider = self:FindGO("Collider"):GetComponent(BoxCollider)
end
function GeneralHelp:SetData(data)
  self.data = data
  if data then
    self.spritelabel:SetText(data)
    self.scrollView:ResetPosition()
  end
end
function GeneralHelp:SetTitle(title)
  self.title.text = title or ZhString.Help_Title
end
function GeneralHelp:CloseSelf()
  TipsView.Me():HideCurrent()
  EventManager.Me():DispatchEvent(UICloseEvent.GeneralHelpClose)
end
