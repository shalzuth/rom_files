ServerPopupListTip = class("ServerPopupListTip", BaseTip)
autoImport("NewServerListCell")
function ServerPopupListTip:Init()
  ServerPopupListTip.super.Init(self)
  self.closecomp = self:FindComponent("content", CloseWhenClickOtherPlace)
  local gridCmp = self:FindComponent("ServerListTable", UIGrid)
  self.serverList = UIGridListCtrl.new(gridCmp, NewServerListCell, "NewServerListCell")
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.serverList:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end
function ServerPopupListTip:ClickItem(cell)
  local serverData = cell.data
  local loginData = FunctionLogin.Me():getLoginData()
  local flag = loginData ~= nil and loginData.flag or 0
  if serverData.state == SelectServerPanel.ServerConfig.ComingSoon and flag ~= 1 then
    FunctionLoginAnnounce.Me():doShowAnnouncement()
    FunctionNetError.Me():ShowErrorById(111)
  else
    self:sendNotification(ServiceEvent.ChooseServer, serverData)
  end
  self:CloseSelf()
end
function ServerPopupListTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end
function ServerPopupListTip:SetData()
  local list = FunctionLogin.Me():getServerDatas()
  self.serverList:ResetDatas(list)
  self.scrollView:ResetPosition()
end
function ServerPopupListTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function ServerPopupListTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
  self.closecomp = nil
end
function ServerPopupListTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
