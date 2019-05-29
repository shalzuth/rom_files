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
function LogUtility.StringFormat(fmt, ...)
  if not LogUtility.enable then
    return "StringFormat not enable"
  end
  return String.Format(fmt, ...)
end
function LogUtility.FormatSize_KB(size)
  return LogUtility.FormatSize(size * 1024)
end
function LogUtility.FormatSize(size)
  if size < 1024 then
    return LogUtility.StringFormat("{0}B", size)
  end
  if size < 1048576 then
    return LogUtility.StringFormat("{0:F2}KB", size / 1024)
  end
  if size < 1073741824 then
    return LogUtility.StringFormat("{0:F3}MB", size / 1048576)
  end
  return LogUtility.StringFormat("{0:F4}GB", size / 1073741824)
end
function LogUtility.Info(msg)
  if not LogUtility.enable then
    return
  end
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.Log(msg)
end
function LogUtility.Warning(msg)
  if not LogUtility.enable then
    return
  end
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogWarning(msg)
end
function LogUtility.Error(msg)
  if not LogUtility.enable then
    return
  end
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogError(msg)
end
function LogUtility.InfoFormat(fmt, ...)
  if not LogUtility.enable then
    return
  end
  local msg = String.Format(fmt, ...)
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.Log(msg)
end
function LogUtility.WarningFormat(fmt, ...)
  if not LogUtility.enable then
    return
  end
  local msg = String.Format(fmt, ...)
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogWarning(msg)
end
function LogUtility.ErrorFormat(fmt, ...)
  if not LogUtility.enable then
    return
  end
  local msg = String.Format(fmt, ...)
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogError(msg)
end
function LogUtility.DebugInfo(obj, msg)
  if not LogUtility.enable then
    return
  end
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.Log(msg, obj)
end
function LogUtility.DebugWarning(obj, msg)
  if not LogUtility.enable then
    return
  end
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogWarning(msg, obj)
end
function LogUtility.DebugError(obj, msg)
  if not LogUtility.enable then
    return
  end
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogError(msg, obj)
end
function LogUtility.DebugInfoFormat(obj, fmt, ...)
  if not LogUtility.enable then
    return
  end
  local msg = String.Format(fmt, ...)
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.Log(msg, obj)
end
function LogUtility.DebugWarningFormat(obj, fmt, ...)
  if not LogUtility.enable then
    return
  end
  local msg = String.Format(fmt, ...)
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogWarning(msg, obj)
end
function LogUtility.DebugErrorFormat(obj, fmt, ...)
  if not LogUtility.enable then
    return
  end
  local msg = String.Format(fmt, ...)
  if LogUtility.traceEnable then
    msg = String.Format([[
{0}
{1}]], msg, debug.traceback())
  end
  ROLogger.LogError(msg, obj)
end
local logParam = {}
local combineMsg = function(arg1, arg2, arg3, arg4, arg5)
  logParam[1] = arg1
  logParam[2] = arg2
  logParam[3] = arg3
  logParam[4] = arg4
  logParam[5] = arg5
  local msg = ""
  for i = 1, #logParam do
    if logParam[i] ~= nil then
      msg = msg .. LogUtility.ToString(logParam[i])
    end
    if i < #logParam then
      msg = msg .. "  |  "
    end
  end
  TableUtility.ArrayClear(logParam)
  return msg
end
local _helplog = function(colorMsg, arg1, arg2, arg3, arg4, arg5)
  if not ROLogger.enable then
    return
  end
  LogUtility.Info(colorMsg .. combineMsg(arg1, arg2, arg3, arg4, arg5) .. "</color>")
end
function helplog(arg1, arg2, arg3, arg4, arg5)
  _helplog("<color=yellow>", arg1, arg2, arg3, arg4, arg5)
end
function redlog(arg1, arg2, arg3, arg4, arg5)
  _helplog("<color=red>", arg1, arg2, arg3, arg4, arg5)
end
function clog(channel, msg1, msg2, msg3, msg4, msg5)
  pcall(function()
    ROLogger.LogChannel(channel, combineMsg(msg1, msg2, msg3, msg4, msg5), nil)
  end)
end
function clogWarnning(channel, msg)
  pcall(function()
    ROLogger.LogWarningChannel(channel, combineMsg(msg1, msg2, msg3, msg4, msg5), nil)
  end)
end
function clogError(channel, msg, params)
  pcall(function()
    ROLogger.LogErrorChannel(channel, combineMsg(msg1, msg2, msg3, msg4, msg5), nil)
  end)
end
function xdlog(arg1, arg2, arg3, arg4, arg5)
  _helplog("<color=lime>", arg1, arg2, arg3, arg4, arg5)
end
