FunctionAppStateMonitor = class("FunctionAppStateMonitor")
function FunctionAppStateMonitor.Me()
  if nil == FunctionAppStateMonitor.me then
    FunctionAppStateMonitor.me = FunctionAppStateMonitor.new()
  end
  return FunctionAppStateMonitor.me
end
function FunctionAppStateMonitor:ctor()
end
function FunctionAppStateMonitor:Reset()
  if self.monitor == nil then
    self.monitor = AppStateMonitor.Instance
  end
  if self.monitor then
    self.monitor.applicationQuitHandler = nil
    self.monitor.applicationPauseHandler = nil
    self.monitor.applicationFocusHandler = nil
  end
  self:UnRegisterOrientationListener()
  self.running = false
end
function FunctionAppStateMonitor:Launch()
  if self.running then
    return
  end
  self.running = true
  self.monitor = AppStateMonitor.Instance
  if self.monitor then
    function self.monitor.applicationQuitHandler()
      self:OnAppQuit()
    end
    function self.monitor.applicationPauseHandler(v)
      self:OnAppPause(v)
    end
    function self.monitor.applicationFocusHandler(v)
      self:OnAppFocus(v)
    end
  end
  self:RegisterOrientationListener()
end
function FunctionAppStateMonitor:OnAppQuit()
  Game.HandUpManager:EndHandUp()
  EventManager.Me():DispatchEvent(AppStateEvent.Quit)
  FunctionPreload.Me():SaveLoadFrequency_UI()
end
function FunctionAppStateMonitor:OnAppPause(paused)
  if paused then
    Game.HandUpManager:EndHandUp()
  end
  EventManager.Me():DispatchEvent(AppStateEvent.Pause, paused)
end
function FunctionAppStateMonitor:OnAppFocus(focus)
  EventManager.Me():DispatchEvent(AppStateEvent.Focus, focus)
end
function FunctionAppStateMonitor:RegisterOrientationListener()
  if not BackwardCompatibilityUtil.CompatibilityMode_V16 then
    function SafeArea.Instance.onOrientationChanged(isLandscapeLeft)
      self:OnOrientationChanged(isLandscapeLeft)
    end
  end
end
function FunctionAppStateMonitor:UnRegisterOrientationListener()
  if not BackwardCompatibilityUtil.CompatibilityMode_V16 then
    SafeArea.Instance.onOrientationChanged = nil
  end
end
function FunctionAppStateMonitor:OnOrientationChanged(isLandscapeLeft)
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    return
  end
  LogUtility.InfoFormat("OnOrientationChanged! isLandscapeLeft = {0}", isLandscapeLeft)
  EventManager.Me():DispatchEvent(AppStateEvent.OrientationChange, isLandscapeLeft)
end
