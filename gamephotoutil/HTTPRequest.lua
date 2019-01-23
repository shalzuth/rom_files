HTTPRequest = {}

-- test
-- local testTab = {3, 4, 99, 17, 54, 1000, 80, 16, 3, 4, 99, 17, 54, 66, 889, 91, 7, 9, 7, 3}
-- function HTTPRequest.Test()
-- 	local c = coroutine.create(function ()
-- 		local testCaseComplete = false
-- 		print('test case 1 start')
-- 		for i = 1, #testTab do
-- 			local url = string.format('https://ro.xdcdn.net/game/scenery/10017/user/10017000100082111/%d.png', testTab[i])
-- 			HTTPRequest.Head(
-- 				url,
-- 				function (x)
-- 					local unityWebRequest = x
-- 					local responseCode = unityWebRequest.responseCode
-- 					local responseIsDone = unityWebRequest.isDone
-- 					local responseIsError = unityWebRequest.isError
-- 					unityWebRequest = nil
-- 					local strPrint =
-- 						'request complete\n'..
-- 						url .. '\n' ..
-- 						responseCode .. '\n' ..
-- 						tostring(responseIsDone) .. '\n' ..
-- 						tostring(responseIsError)
-- 					print(strPrint)
-- 					if i == #testTab then
-- 						print('i == #testTab')
-- 						testCaseComplete = true
-- 					end
-- 				end
-- 			)
-- 		end

-- 		while not testCaseComplete do
-- 			Yield(0)
-- 		end

-- 		testCaseComplete = false
-- 		print('test case 2 start')
-- 		local times = 9
-- 		for i = 1, times do
-- 			local url = string.format('https://ro.xdcdn.net/game/scenery/10017/user/10017000100082111/%d.png', testTab[1])
-- 			HTTPRequest.Head(
-- 				url,
-- 				function (x)
-- 					local unityWebRequest = x
-- 					local responseCode = unityWebRequest.responseCode
-- 					local responseIsDone = unityWebRequest.isDone
-- 					local responseIsError = unityWebRequest.isError
-- 					unityWebRequest = nil
-- 					local strPrint =
-- 						'request complete\n'..
-- 						url .. '\n' ..
-- 						responseCode .. '\n' ..
-- 						tostring(responseIsDone) .. '\n' ..
-- 						tostring(responseIsError)
-- 					print(strPrint)
-- 					if i == times then
-- 						testCaseComplete = true
-- 					end
-- 				end
-- 			)
-- 		end

-- 		while not testCaseComplete do
-- 			Yield(0)
-- 		end

-- 		testCaseComplete = false
-- 		print('test case 3 start')
-- 		local url = 'about:blank'
-- 		HTTPRequest.Head(url, function (x)
-- 			local unityWebRequest = x
-- 			local responseCode = unityWebRequest.responseCode
-- 			local responseIsDone = unityWebRequest.isDone
-- 			local responseIsError = unityWebRequest.isError
-- 			unityWebRequest = nil
-- 			local strPrint =
-- 				'request complete\n'..
-- 				url .. '\n' ..
-- 				responseCode .. '\n' ..
-- 				tostring(responseIsDone) .. '\n' ..
-- 				tostring(responseIsError)
-- 			print(strPrint)
-- 		end)
-- 	end)
-- 	coroutine.resume(c)
-- end

local unityWebRequestPool = {}
function HTTPRequest.CreateUnityWebRequest(url, method)
	local request = Slua.CreateClass('UnityEngine.Networking.UnityWebRequest', url, method)
	return request
end
function HTTPRequest.GetUnityWebRequest(url, method)
	local request = nil
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
		HTTPRequest.InQueueRequest(url, 'HEAD', complete_callback)
	end
end

function HTTPRequest.DoHead(url, complete_callback)
	local c = coroutine.create(function ()
		local request = HTTPRequest.CreateUnityWebRequest(url, 'HEAD')
		Yield(request:Send())
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
	table.insert(queueRequest, {url = url, method = method, completeCallback = complete_callback})
end

function HTTPRequest.QueueHeadDo()
	local requestParam = queueRequest[1]
	table.remove(queueRequest, 1)
	if requestParam.method == 'HEAD' then
		HTTPRequest.DoHead(requestParam.url, requestParam.completeCallback)
	end
end