HTTPRequest = {}
local unityWebRequestPool = {}
function HTTPRequest.CreateUnityWebRequest(url, method)
  local request = Slua.CreateClass("UnityEngine.Networking.UnityWebRequest", url, method)
  return request
end
function HTTPRequest.GetUnityWebRequest(url, method)
  local request
  local requestIndex = 0
  for i = 1, #unityWebRequestPool do
    local tempUnityWebRequest = unityWebRequestPool[i]
    if not tempUnityWebRequest.isBusy then
      request = tempUnityWebRequest.request
      request.url = url
      request.method = method
      requestIndex = i
      tempUnityWebRequest.isBusy = true
    end
  end
  if request == nil then
    request = HTTPRequest.CreateUnityWebRequest(url, method)
    table.insert(unityWebRequestPool, {request = request, isBusy = true})
    requestIndex = #unityWebRequestPool
  end
  return request, requestIndex
end
function HTTPRequest.BackUnityWebRequestWithIndex(request_index)
  local unityWebRequest = unityWebRequestPool[request_index]
  HTTPRequest.BackUnityWebRequest(unityWebRequest)
end
function HTTPRequest.BackUnityWebRequest(request)
  if request ~= nil then
    request.isBusy = false
  end
end
local queueRequest = {}
local ticketCount = 10
function HTTPRequest.Head(url, complete_callback)
  if ticketCount > 0 then
    HTTPRequest.DoHead(url, complete_callback)
    ticketCount = ticketCount - 1
  else
    HTTPRequest.InQueueRequest(url, "HEAD", complete_callback)
  end
end
function HTTPRequest.DoHead(url, complete_callback)
  local c = coroutine.create(function()
    local request = HTTPRequest.CreateUnityWebRequest(url, "HEAD")
    Yield(request:SendWebRequest())
    if #queueRequest > 0 then
      HTTPRequest.QueueHeadDo()
    else
      ticketCount = ticketCount + 1
    end
    if complete_callback ~= nil then
      complete_callback(request)
    end
    request:Dispose()
    request = nil
  end)
  coroutine.resume(c)
end
function HTTPRequest.InQueueRequest(url, method, complete_callback)
  table.insert(queueRequest, {
    url = url,
    method = method,
    completeCallback = complete_callback
  })
end
function HTTPRequest.QueueHeadDo()
  local requestParam = queueRequest[1]
  table.remove(queueRequest, 1)
  if requestParam.method == "HEAD" then
    HTTPRequest.DoHead(requestParam.url, requestParam.completeCallback)
  end
end
