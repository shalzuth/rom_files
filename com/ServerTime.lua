ServerTime = class('ServerTime')

ServerTime.CacheUnscaledTime = 0

function ServerTime.ClampClientTime()
	ServerTime.clamp = ServerTime.CurClientTime()
end

--服务器时间
function ServerTime.InitTime(serverTime)
	local dateFormat = "【%Y年%m月】【%d日%H点%M分%S秒】";
	if(ServerTime.ServerTime == nil)then
		helplog("初始化服务器时间：", os.date(dateFormat, serverTime/1000));
		helplog("当前设备时间：" .. DateTimeHelper.SysNow():ToString());
	else
		helplog("当前服务器时间:".. os.date(dateFormat, serverTime/1000))
		helplog("客户端模拟服务器时间:".. os.date(dateFormat, ServerTime.ServerTime/1000))
		helplog("当前设备时间：" .. DateTimeHelper.SysNow():ToString());
		helplog("误差:"..tostring(serverTime - ServerTime.ServerTime).."毫秒")
	end

	ServerTime.serverTimeStamp = serverTime
	ServerTime.clientTimeStamp = ServerTime.CurClientTime()
	ServerTime.deltaStamp = ServerTime.serverTimeStamp - ServerTime.clientTimeStamp
	if(ServerTime.clamp) then
		ServerTime.deltaStamp = ServerTime.deltaStamp + (ServerTime.CurClientTime()-ServerTime.clamp)
	end
	if(ServerTime.timeTick == nil) then
		ServerTime.timeTick = TimeTickManager.Me():CreateTick(0,33,ServerTime.Update,ServerTime,1,true)
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
	-- return SystemTime.GetCurrentTimeStamp()
	return Time.realtimeSinceStartup *1000
end

function ServerTime.ServerDeltaSecondTime(serverTime,curServerTime)
	return ServerTime.ServerDeltaMillTime(serverTime,curServerTime) / 1000
end

function ServerTime.ServerDeltaMillTime(serverTime,curServerTime)
	-- print("服务器时间戳："..serverTime)

	curServerTime = curServerTime or ServerTime.CurServerTime()
	-- print("客户端时间戳："..curServerTime)
	return serverTime - curServerTime
end

function ServerTime.Update(owner,deltaTime)
	ServerTime.ServerTime = ServerTime.CurClientTime() + ServerTime.deltaStamp
	ServerTime.CacheUnscaledTime = Time.unscaledTime
	-- print("服务器时间:"..ServerTime.ServerTime)
end