autoImport("TabView")
BaseView = class("BaseView", TabView)
BaseView.ViewType = UIViewType.NormalBg
function BaseView:ctor(viewObj, viewdata, uiMediator)
  BaseView.super.ctor(self, viewObj)
  self.viewdata = viewdata
  self.filtersWhenViewOpen = self.viewdata.view and GameConfig.FilterType.UIFilter[self.viewdata.view.id] or nil
  self.uiMediator = uiMediator
  self.viewName = viewdata.viewname
  self.disPatherEvt = {}
  self:AddCloseButtonEvent()
  self:Init()
end
function BaseView:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end
function BaseView:MediatorReActive()
  return true
end
function BaseView:Init()
end
function BaseView:OnShow()
end
function BaseView:OnHide()
end
function BaseView:OnEnter()
  if self.filtersWhenViewOpen ~= nil then
    FunctionSceneFilter.Me():StartFilter(self.filtersWhenViewOpen)
  end
  if self.disPatherEvt ~= nil then
    for evt, func in pairs(self.disPatherEvt) do
      EventManager.Me():AddEventListener(evt, func, self)
    end
  end
  local viewdata = self.viewdata and self.viewdata.viewdata
  if type(viewdata) == "table" then
    local isNpcFuncView = viewdata.isNpcFuncView
    if isNpcFuncView then
      FunctionVisitNpc.Me():AddVisitRef()
    end
  end
end
function BaseView:OnExit()
  self:UnRegisterRedTipChecks()
  if self.filtersWhenViewOpen ~= nil then
    FunctionSceneFilter.Me():EndFilter(self.filtersWhenViewOpen)
  end
  if self.disPatherEvt ~= nil then
    for evt, func in pairs(self.disPatherEvt) do
      EventManager.Me():RemoveEventListener(evt, func, self)
    end
    self.disPatherEvt = nil
  end
  if self.ViewType then
    local list = GuideProxy.Instance:getGuideListByViewName(self.__cname)
    if list then
      FunctionGuide.Me():checkGuideStateWhenExit(list)
    end
  end
  local viewdata = self.viewdata and self.viewdata.viewdata
  if type(viewdata) == "table" then
    local isNpcFuncView = viewdata.isNpcFuncView
    if isNpcFuncView then
      FunctionVisitNpc.Me():RemoveVisitRef()
    end
  end
  self:UnRegisterChildPopObj()
end
function BaseView:RegisterRedTipCheck(id, uiwidget, depth, offset, side)
  self.RedTipChecks = self.RedTipChecks or {}
  local checks = self.RedTipChecks[id]
  if not checks then
    checks = {}
    self.RedTipChecks[id] = checks
  end
  if checks[uiwidget] == nil then
    checks[uiwidget] = uiwidget
    RedTipProxy.Instance:RegisterUI(id, uiwidget, depth, offset, side)
  end
end
function BaseView:RegisterRedTipCheckByIds(ids, uiwidget, depth, offset, side)
  if ids then
    for i = 1, #ids do
      self:RegisterRedTipCheck(ids[i], uiwidget, depth, offset, side)
    end
  end
end
function BaseView:UnRegisterRedTipChecks()
  if self.RedTipChecks then
    for k, v in pairs(self.RedTipChecks) do
      for kui, vui in pairs(v) do
        RedTipProxy.Instance:UnRegisterUI(k, vui)
      end
    end
    self.RedTipChecks = nil
  end
end
function BaseView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
end
function BaseView:CloseSelf()
  self:sendNotification(UIEvent.CloseUI, self)
end
function BaseView:AddListenEvt(interest, func)
  if interest then
    self.interests = self.interests or {}
    table.insert(self.interests, interest)
    self.ListenerEvtMap = self.ListenerEvtMap or {}
    self.ListenerEvtMap[interest] = func
  else
    printRed("Event name is nil")
  end
end
function BaseView:AddDispatcherEvt(evtname, func)
  self.disPatherEvt = self.disPatherEvt or {}
  self.disPatherEvt[evtname] = func
end
function BaseView:sendNotification(notificationName, body, type)
  self.uiMediator:sendNotification(notificationName, body, type)
end
function BaseView:GotoView(data)
  self:sendNotification(UIEvent.JumpPanel, data)
end
function BaseView:CheckViewCanOpen(id)
  return FunctionUnLockFunc.Me():CheckCanOpenByPanelId(id)
end
function BaseView:RegisterChildPopObj(obj)
  UIManagerProxy.Instance:RegisterChildPopObj(self.ViewType, obj)
end
function BaseView:UnRegisterChildPopObj(obj)
  UIManagerProxy.Instance:UnRegisterChildPopObj(self.ViewType)
end
function BaseView:listNotificationInterests()
  return self.interests or {}
end
function BaseView:handleNotification(note)
  if self.ListenerEvtMap ~= nil then
    local evt = self.ListenerEvtMap[note.name]
    if evt ~= nil then
      evt(self, note)
    end
  end
end
