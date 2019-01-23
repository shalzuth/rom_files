LogUtility = class("LogUtility")

function LogUtility.SetEnable(enable)
	LogUtility.enable = enable
	ROLogger.enable = enable
end

function LogUtility.IsEnable()
	return LogUtility.enable
end

function LogUtility.SetTraceEnable(enable)
	LogUtility.traceEnable = enable
end

function LogUtility.IsTraceEnable()
	return LogUtility.traceEnable
end

function LogUtility.ToString(v)
	if not LogUtility.enable then
		return "ToString not enable"
	end
	return tostring(v)
end

function LogUtility.StringFormat(fmt, ... )
	if not LogUtility.enable then
		return "StringFormat not enable"
	end
	return String.Format(fmt, ...)
end

function LogUtility.FormatSize_KB(size)
	return LogUtility.FormatSize(size*1024)
end

function LogUtility.FormatSize(size)
	if size < 1024 then
	    return LogUtility.StringFormat("{0}B", size)
	end
	if size < 1024*1024 then
	    return LogUtility.StringFormat("{0:F2}KB", size/1024)
	end
	if size < 1024*1024*1024 then
	    return LogUtility.StringFormat("{0:F3}MB", size/(1024*1024))
	end
	return LogUtility.StringFormat("{0:F4}GB", size/(1024*1024*1024))
end

function LogUtility.Info(msg)
	if not LogUtility.enable then
		return
	end
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.Log(msg)
end

function LogUtility.Warning(msg)
	if not LogUtility.enable then
		return
	end
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogWarning(msg)
end

function LogUtility.Error(msg)
	if not LogUtility.enable then
		return
	end
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogError(msg)
end

function LogUtility.InfoFormat(fmt, ... )
	if not LogUtility.enable then
		return
	end
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.Log(msg)
end

function LogUtility.WarningFormat(fmt, ... )
	if not LogUtility.enable then
		return
	end
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogWarning(msg)
end

function LogUtility.ErrorFormat(fmt, ... )
	if not LogUtility.enable then
		return
	end
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogError(msg)
end

function LogUtility.DebugInfo(obj, msg)
	if not LogUtility.enable then
		return
	end
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.Log(msg, obj)
end

function LogUtility.DebugWarning(obj, msg)
	if not LogUtility.enable then
		return
	end
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogWarning(msg, obj)
end

function LogUtility.DebugError(obj, msg)
	if not LogUtility.enable then
		return
	end
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogError(msg, obj)
end

function LogUtility.DebugInfoFormat(obj, fmt, ... )
	if not LogUtility.enable then
		return
	end
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.Log(msg, obj)
end

function LogUtility.DebugWarningFormat(obj, fmt, ... )
	if not LogUtility.enable then
		return
	end
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogWarning(msg, obj)
end

function LogUtility.DebugErrorFormat(obj, fmt, ... )
	if not LogUtility.enable then
		return
	end
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	ROLogger.LogError(msg, obj)
end