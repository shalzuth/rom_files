autoImport("RecallContractSelectCell")
RecallContractSelectView = class("RecallContractSelectView", ContainerView)
RecallContractSelectView.ViewType = UIViewType.PopUpLayer
function RecallContractSelectView:Init()
  self:AddViewEvt()
  self:InitShow()
end
function RecallContractSelectView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
end
function RecallContractSelectView:InitShow()
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "RecallContractSelectCell",
    control = RecallContractSelectCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self:UpdateView()
end
function RecallContractSelectView:HandleClickItem(cell)
  local data = cell.data
  if data then
    self:sendNotification(RecallEvent.Select, data)
    self:CloseSelf()
  end
end
function RecallContractSelectView:UpdateView()
  self.itemWrapHelper:UpdateInfo(FriendProxy.Instance:GetRecallList())
end
