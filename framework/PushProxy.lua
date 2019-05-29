PushProxy = class("PushProxy", pm.Proxy)
PushProxy.Instance = nil
PushProxy.NAME = "PushProxy"
function PushProxy:DebugLog(msg)
  if false then
    LogUtility.Info("-------PushProxy-----------:::" .. msg)
  end
end
function PushProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PushProxy.NAME
  if PushProxy.Instance == nil then
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
  function ROPushReceiver.Instance._OnReceiveNotification(msg)
    self:DebugLog("_OnReceiveNotification:" .. msg)
  end
  function ROPushReceiver.Instance._OnReceiveMessage(msg)
    self:DebugLog("_OnReceiveMessage" .. msg)
  end
  function ROPushReceiver.Instance._OnOpenNotification(msg)
    self:DebugLog("_OnOpenNotification" .. msg)
  end
  function ROPushReceiver.Instance._OnJPushTagOperateResult(msg)
    self:DebugLog("_OnJPushTagOperateResult" .. msg)
  end
  function ROPushReceiver.Instance._OnJPushAliasOperateResult(msg)
    self:DebugLog("_OnJPushAliasOperateResult" .. msg)
  end
  if ApplicationInfo.IsRunOnEditor() then
    self:DebugLog("\231\188\150\232\190\145\229\153\168\230\168\161\229\188\143 \230\151\160\230\179\149\228\189\191\231\148\168jpush")
    return
  end
  do return end
  if ROPush.hasInit == false then
    ROPush.Init("ROPushReceiver")
    if ROPush.StopPush ~= nil then
      ROPush.StopPush()
    end
  end
end
function PushProxy:AddEvts()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(AppStateEvent.Pause, self.OnPause, self)
end
function PushProxy:OnPause(note)
  local paused = note.data
  if paused then
    self:DebugLog("paused ")
  else
    self:DebugLog("paused ~= return")
  end
  if ROPush.hasInit then
    if paused then
      if ROPush.ResumePush ~= nil then
        ROPush.ResumePush()
        self:DebugLog("ResumePush")
      end
    elseif ROPush.StopPush ~= nil then
      ROPush.StopPush()
      self:DebugLog("StopPush")
    end
  end
end
return PushProxy
