module("json.rpc")
local json = require("json")
local http = require("socket.http")
function proxy(url)
  local serverProxy = {}
  local proxyMeta = {
    __index = function(t, key)
      return function()
        return json.rpc.call(url, key, unpack(arg))
      end
    end
  }
  setmetatable(serverProxy, proxyMeta)
  return serverProxy
end
function call(url, method)
  assert(method, "method param is nil to call")
  local JSONRequestArray = {
    id = "httpRequest",
    method = method,
    params = arg
  }
  local httpResponse, result, code
  local jsonRequest = json.encode(JSONRequestArray)
  local ltn12 = require("ltn12")
  local resultChunks = {}
  httpResponse, code = http.request({
    url = url,
    sink = ltn12.sink.table(resultChunks),
    method = "POST",
    headers = {
      ["content-type"] = "text/plain",
      ["content-length"] = string.len(jsonRequest)
    },
    source = ltn12.source.string(jsonRequest)
  })
  httpResponse = table.concat(resultChunks)
  if code ~= 200 then
    return nil, "HTTP ERROR: " .. code
  end
  result = json.decode(httpResponse)
  if result.result then
    return result.result, nil
  else
    return nil, result.error
  end
end
