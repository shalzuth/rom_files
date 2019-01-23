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
	if(self.monitor==nil) then
		self.monitor = AppStateMonitor.Instance
	end
	if(self.monitor) then
		self.monitor.applicationQuitHandler = nil
		self.monitor.applicationPauseHandler = nil
		self.monitor.applicationFocusHandler = nil
	end
	self:UnRegisterOrientationListener()
	self.running = false
end

function FunctionAppStateMonitor:Launch()
	if(self.running) then return end
	self.running = true
	self.monitor = AppStateMonitor.Instance
	if(self.monitor) then
		self.monitor.applicationQuitHandler = function ()
			self:OnAppQuit()
		end

		self.monitor.applicationPauseHandler = function (v)
			self:OnAppPause(v)
		end

		self.monitor.applicationFocusHandler = function (v)
			self:OnAppFocus(v)
		end
	end
	self:RegisterOrientationListener()
end

function FunctionAppStateMonitor:OnAppQuit()
	-- printRed("---------OnAppQuit")
	-- GameFacade.Instance:sendNotification(AppStateEvent.Quit)
	Game.HandUpManager:EndHandUp()

	EventManager.Me():DispatchEvent(AppStateEvent.Quit)
end

function FunctionAppStateMonitor:OnAppPause(paused)
	-- printOrange("OnAppPause",paused)
	-- GameFacade.Instance:sendNotification(AppStateEvent.Pause,paused)
	if(paused)then
		Game.HandUpManager:EndHandUp()
	end
	EventManager.Me():DispatchEvent(AppStateEvent.Pause,paused)
end

function FunctionAppStateMonitor:OnAppFocus(focus)
	-- printOrange("OnAppFocus",focus)
	-- GameFacade.Instance:sendNotification(AppStateEvent.Focus,focus)
	EventManager.Me():DispatchEvent(AppStateEvent.Focus,focus)
end

function FunctionAppStateMonitor:RegisterOrientationListener()
	if not BackwardCompatibilityUtil.CompatibilityMode_V16 then
		SafeArea.Instance.onOrientationChanged = function(isLandscapeLeft)
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
	Debug.Log("OnOrientationChanged !")
end