ServerTime = class("ServerTime")
ServerTime.CacheUnscaledTime = 0
function ServerTime.ClampClientTime()
  ServerTime.clamp = ServerTime.CurClientTime()
end
function ServerTime.InitTime(serverTime)
  local dateFormat = "\227\128\144%Y\229\185\180%m\230\156\136\227\128\145\227\128\144%d\230\151\165%H\231\130\185%M\229\136\134%S\231\167\146\227\128\145"
  if ServerTime.ServerTime == nil then
    helplog("\229\136\157\229\167\139\229\140\150\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\239\188\154", os.date(dateFormat, serverTime / 1000))
    helplog("\229\189\147\229\137\141\232\174\190\229\164\135\230\151\182\233\151\180\239\188\154" .. DateTimeHelper.SysNow():ToString())
  else
    helplog("\229\189\147\229\137\141\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180:" .. os.date(dateFormat, serverTime / 1000))
    helplog("\229\174\162\230\136\183\231\171\175\230\168\161\230\139\159\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180:" .. os.date(dateFormat, ServerTime.ServerTime / 1000))
    helplog("\229\189\147\229\137\141\232\174\190\229\164\135\230\151\182\233\151\180\239\188\154" .. DateTimeHelper.SysNow():ToString())
    helplog("\232\175\175\229\183\174:" .. tostring(serverTime - ServerTime.ServerTime) .. "\230\175\171\231\167\146")
  end
  ServerTime.serverTimeStamp = serverTime
  ServerTime.clientTimeStamp = ServerTime.CurClientTime()
  ServerTime.deltaStamp = ServerTime.serverTimeStamp - ServerTime.clientTimeStamp
  if ServerTime.clamp then
    ServerTime.deltaStamp = ServerTime.deltaStamp + (ServerTime.CurClientTime() - ServerTime.clamp)
  end
  if ServerTime.timeTick == nil then
    ServerTime.timeTick = TimeTickManager.Me():CreateTick(0, 33, ServerTime.Update, ServerTime, 1, true)
  end
  ServerTime.Update()
end
function ServerTime.StampClientSend()
  ServerTime.clientStamp = ServerTime.CurServerTime()
end
function ServerTime.CurServerTime()
  return ServerTime.ServerTime
end
function ServerTime.CurClientTime()
  return Time.realtimeSinceStartup * 1000
end
function ServerTime.ServerDeltaSecondTime(serverTime, curServerTime)
  return ServerTime.ServerDeltaMillTime(serverTime, curServerTime) / 1000
end
function ServerTime.ServerDeltaMillTime(serverTime, curServerTime)
  curServerTime = curServerTime or ServerTime.CurServerTime()
  return serverTime - curServerTime
end
function ServerTime.Update(owner, deltaTime)
  ServerTime.ServerTime = ServerTime.CurClientTime() + ServerTime.deltaStamp
  ServerTime.CacheUnscaledTime = Time.unscaledTime
end
