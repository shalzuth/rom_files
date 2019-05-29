module("json.rpcserver")
function serve(luaClass, packReturn)
  cgilua.contentheader("text", "plain")
  require("cgilua")
  require("json")
  local postData = ""
  if not cgilua.servervariable("CONTENT_LENGTH") then
    cgilua.put("Please access JSON Request using HTTP POST Request")
    return 0
  else
    postData = cgi[1]
  end
  local jsonRequest = json.decode(postData)
  local jsonResponse = {}
  jsonResponse.id = jsonRequest.id
  local method = luaClass[jsonRequest.method]
  if not method then
    jsonResponse.error = "Method " .. jsonRequest.method .. " does not exist at this server."
  else
    local callResult = {
      pcall(method, unpack(jsonRequest.params))
    }
    if callResult[1] then
      table.remove(callResult, 1)
      if packReturn and 1 < table.getn(callResult) then
        jsonResponse.result = callResult
      else
        jsonResponse.result = unpack(callResult)
      end
    else
      jsonResponse.error = callResult[2]
    end
  end
  cgilua.contentheader("text", "plain")
  cgilua.put(json.encode(jsonResponse))
end
