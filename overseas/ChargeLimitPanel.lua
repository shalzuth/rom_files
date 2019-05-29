autoImport("ChargeLimitCell")
ChargeLimitPanel = class("ChargeLimitPanel", ContainerView)
ChargeLimitPanel.ViewType = UIViewType.PopUpLayer
ChargeLimitPanel.SelectEvent = "OverseasSelectEvent"
ChargeLimitPanel.CloseZeny = "OverSeasCloseZeny"
ChargeLimitPanel.RefreshZenyCell = "OverSeasRefreshZenyCell"
ChargeLimitPanel.ClosePanel = "OverSeasClosePanel"
function ChargeLimitPanel:Init()
  self.limit = {}
  for k, v in pairs(Table_ChargeLimit) do
    table.insert(self.limit, v)
  end
  if self.limitGrid == nil then
    local scrollViewObj = self:FindGO("ScrollView", self.thumbsUpPage)
    self.scrollView = scrollViewObj:GetComponent(UIScrollView)
    local giftsGrid = self:FindGO("Grid", scrollViewObj):GetComponent(UIGrid)
    self.limitGrid = UIGridListCtrl.new(giftsGrid, ChargeLimitCell, "ChargeLimitCell")
  end
  self.limitGrid:ResetDatas(self.limit)
  self.scrollView:ResetPosition()
  self.scrollView.transform.localPosition = Vector3(0, 0, 0)
  self:AddListenEvt(XDEUIEvent.ChargeLimitPanelBack, function()
    self:CloseSelf()
  end)
end
function ChargeLimitPanel:OnEnter()
  self.super.OnEnter(self)
  EventManager.Me():AddEventListener(ChargeLimitPanel.ClosePanel, self.ClosePanelEvt, self)
end
function ChargeLimitPanel:OnExit()
  EventManager.Me():RemoveEventListener(ChargeLimitPanel.ClosePanel, self.ClosePanelEvt, self)
  self.super.OnExit(self)
end
function ChargeLimitPanel:CloseSelf()
  helplog("ChargeLimitPanel:CloseSelf")
  if self.notCloseZeny == nil then
    EventManager.Me():PassEvent(ChargeLimitPanel.CloseZeny, self)
  end
  self.super.CloseSelf(self)
end
function ChargeLimitPanel:ClosePanelEvt(notCloseZeny)
  helplog("ChargeLimitPanel:CloseSelf")
  self.notCloseZeny = notCloseZeny
  self:CloseSelf()
end
