PushProxy = class('PushProxy', pm.Proxy)
PushProxy.Instance = nil;
PushProxy.NAME = "PushProxy"

function PushProxy:DebugLog(msg)
	-- body
	if false then
		Debug.Log("-------PushProxy-----------:::"..msg)
	end	
end

function PushProxy:ctor(proxyName, data)
	self.proxyName = proxyName or PushProxy.NAME
	if(PushProxy.Instance == nil) then
		PushProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
	self:AddEvts()
end

function PushProxy:Init()
	self:DebugLog("function PushProxy:Init()")


	ROPushReceiver.Instance._OnReceiveNotification = function (msg)
		-- body
		self:DebugLog("_OnReceiveNotification:"..msg)
	end

	ROPushReceiver.Instance._OnReceiveMessage = function (msg)
		-- body
		self:DebugLog("_OnReceiveMessage"..msg)
	end

	ROPushReceiver.Instance._OnOpenNotification = function (msg)
		-- body
		self:DebugLog("_OnOpenNotification"..msg)
	end

	ROPushReceiver.Instance._OnJPushTagOperateResult = function (msg)
		-- body
		self:DebugLog("_OnJPushTagOperateResult"..msg)
	end

	ROPushReceiver.Instance._OnJPushAliasOperateResult = function (msg)
		-- body
		self:DebugLog("_OnJPushAliasOperateResult"..msg)
	end

	if ApplicationInfo.IsRunOnEditor() then
		self:DebugLog("编辑器模式 无法使用jpush")
		do return end
	end

	if ROPush.hasInit== false then
		ROPush.Init("ROPushReceiver")
		ROPush.StopPush()
	end	

end

function PushProxy:AddEvts()
	local eventManager = EventManager.Me()
	eventManager:AddEventListener(AppStateEvent.Pause, self.OnPause , self)
end

function PushProxy:OnPause(note)
	local paused = note.data
	if paused  then
		self:DebugLog("paused ")
	else 
	 	self:DebugLog("paused ~= return")
	end	
	if ROPush.hasInit then
		if paused then
			ROPush.ResumePush()
			self:DebugLog("ResumePush")
		else 
			ROPush.StopPush()
		 	self:DebugLog("StopPush")
		end	
	end	
end

return PushProxy

