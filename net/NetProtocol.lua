-- game protocol
NetProtocol = {}

-- listeners for protocol down
-- listeners are all function
-- the front listener will be called before the behinds
-- example :
-- 	receive protocol down 1 1
local listeners = {}
NetProtocol.noSendProtcol = false
NetProtocol.CachingSomeReceives = false

function NetProtocol.AddListener(id1, id2, func)
	local key = id1.."_"..id2
	if listeners[key] == nil then
		listeners[key] = {}
	else
		NetProtocol.InfoFormat("NetProtocol::AddListener Error id1:{0}  id2:{1}",id1,id2)
	end
	table.insert(listeners[key], func)
end

function NetProtocol.RemoveListener(id1, id2, func)
	local key = id1.."_"..id2
	if listeners[key] == nil then
		return
	end
	
	for i, value in ipairs(listeners[key]) do
		if value == func then
			table.remove(listeners[key], i)
			return
		end
	end
end

function NetProtocol.DispatchListener(id1, id2, data)
	local key = id1.."_"..id2
	if listeners[key] == nil then
		NetProtocol.InfoFormat("NetProtocol::DispatchListener Error id1:{0},id2:{1}",id1,id2)
		return
	end

	for i, value in ipairs(listeners[key]) do
		if value ~= nil then			
			value(id1, id2, data)
			ServiceConnProxy.Instance:RecvHeart()
			-- table.remove(listeners[key], i)
			-- return
		end
	end
end

-- log
function NetProtocol.TableToString(t)
	return ""
	-- local s = "" 
	-- for key, value in pairs(t) do
	-- 	if type(value) ~= "table" then	
	-- 		if value ~= nil then
	-- 			if string.len(tostring(value)) > 0 then
	-- 				s = s..key.."_"..tostring(value).."\n"
	-- 			else
	-- 				s = s..key.."_".." ".."\n"
	-- 			end
	-- 		else
	-- 			s = s..key.."_".."nil".."\n"
	-- 		end
	-- 	else
	-- 		s = s..key.."_"..NetProtocol.TableToString(value)
	-- 	end
	-- end
	-- return s
end

-- pack data -> dataBytes
function NetProtocol.Pack(id1, id2, data)
	local dataUp = _G[string.format("Data_Up_%d_%d", id1, id2)]		
	if dataUp == nil then
		return nil
	end

	local start = 0
	return NetProtocol.PackStruct(dataUp, data)	
end

-- unpack struct data -> bytes
function NetProtocol.PackStruct(struct, data)	
	local dataBytes = NetUtil.GetNewBytes()

	-- pack 
	for key, value in ipairs(struct) do		       
 		local name = value.name
 		local t = value.type
 		local lenFrom = value.lenFrom

 		if name ~= nil and t ~= nil then 	
 			if lenFrom ~= nil then
 				local number
 				if type(lenFrom) == "number" then	
 					number = lenFrom
	 			elseif data[lenFrom] ~= nil then					
				 	number = data[lenFrom]	
				end
 				
				for i = 1, number do
					dataBytes = NetUtil.Append(dataBytes, NetProtocol.PackValue(t, data[name][i]))
				end
 			else
 				dataBytes = NetUtil.Append(dataBytes, NetProtocol.PackValue(t, data[name]))
 			end 			
 		end 		
	end 

	return dataBytes
end

-- pack value -> bytes array
function NetProtocol.PackValue(t, value)
	-- array
	function PackArray(t, array)
		local dataBytes = NetUtil.GetNewBytes()
		for i = 1, #array do
			if array[i] ~= nil then
				if type(array[i]) ~= "table" then
					dataBytes = NetUtil.Append(dataBytes, NetProtocol.PackValue(t, array[i]))
				else
					dataBytes = NetUtil.Append(dataBytes, PackArray(t, array[i]))					
				end
			end
		end
		return dataBytes
	end
	if type(t) ~= "table" and type(value) == "table" then
		return PackArray(t, value)
	end

	-- struct
	if type(t) == "table" then
		return NetProtocol.PackStruct(t, value)
	end	

	-- char
	if t == "char" then
		return NetUtil.CharTo1Bytes(value)
	end	

	-- char32
	if t == "char32" then
		return NetUtil.CharsToBytes(value, 32)
	end	

	-- uint2
	if t == "uint2" then
		return NetUtil.UintTo2Bytes(value)
	end

	-- uint4
	if t == "uint4" then
		return NetUtil.UintTo4Bytes(value)
	end		

	-- uint8
	if t == "uint8" then
		return NetUtil.UintTo8Bytes(tostring(value))
	end	

	-- int2
	if t == "int2" then
		return NetUtil.IntTo2Bytes(value)
	end	

	-- int4
	if t == "int4" then
		return NetUtil.IntTo4Bytes(value)
	end	

	-- log pack fail

	return nil
end

local ProtobufPool_Get = ProtobufPool.Get
-- unpack dataBytes -> data
function NetProtocol.Unpack(id1, id2, dataStr)
	-- if id1 > 4 then		
		local cmd = Proto_Include[id1]
		if cmd == nil then
			return nil
		end
		local param = cmd[id2]
		if param == nil then
			return nil
		end

		-- local str = ""
		-- for i = 1, dataBytes.Length do
		-- 	str = str..(string.char(dataBytes[i - 1]))
		-- end

		local msg = ProtobufPool_Get(param)	
		-- local msg = param()		
		-- local str = Slua.ToString(dataBytes)

		if not NetConfig.IsHeart(id1, id2) then
			-- NetProtocol.InfoFormat("NetProtocol::<color=lime>Unpack</color> Proto id1:{0} id2:{1}",id1,id2)	
		end

		local memSample = Debug_LuaMemotry.SampleBegin("NetProtocolParseFromString")
		-- local memSample = Debug_LuaMemotry.SampleBegin(table.concat(keys))
		msg:ParseFromString(dataStr)
		Debug_LuaMemotry.SampleEnd(memSample)
		
		return msg,param
	-- end

	-- local dataDown = _G[string.format("Data_Down_%d_%d", id1, id2)]		
	-- if dataDown == nil then
	-- 	return nil
	-- end

	-- local start = 0
	-- local _, data = NetProtocol.UnpackStruct(dataDown, dataBytes, start)	
	-- return data
end

-- unpack struct bytes -> data
function NetProtocol.UnpackStruct(struct, bytes, start)	
	local data = {}
	local length = start	

	for key, value in ipairs(struct) do		       
 		local name = value.name
 		local t = value.type
 		local lenFrom = value.lenFrom

 		if name ~= nil and t ~= nil then
 			if lenFrom ~= nil then
 				local number
 				if type(lenFrom) == "number" then	
 					number = lenFrom
	 			elseif data[lenFrom] ~= nil then					
				 	number = data[lenFrom]	
				end

				data[name] = {}
				for i = 1, number do
					local len, value = NetProtocol.UnpackValue(t, bytes, start)
 					start = start + len
 					data[name][i] = value	
				end
 			else
 				local len, value = NetProtocol.UnpackValue(t, bytes, start)
 				start = start + len
 				data[name] = value 		
 			end 			
 		end 		 		 		
	end 
	return start - length, data
end

-- unpack bytes -> value
function NetProtocol.UnpackValue(t, bytes, start)
	local len

	-- struct
	if type(t) == "table" then
		return NetProtocol.UnpackStruct(t, bytes, start)
	end	

	-- int4
	if t == "int4" then
		len = 4
		return len, NetUtil.BytesToInt4(NetUtil.GetBytes(bytes, start, len))
	end		

	-- uint2
	if t == "uint2" then
		len = 2
		return len, NetUtil.BytesToUInt2(NetUtil.GetBytes(bytes, start, len))
	end	

	-- uint4
	if t == "uint4" then 
		len = 4
		return len, NetUtil.BytesToUInt4(NetUtil.GetBytes(bytes, start, len))		
	end	

	-- uint8
	if t == "uint8" then 
		len = 8
		return len, NetUtil.BytesToUInt8(NetUtil.GetBytes(bytes, start, len))		
	end	

	-- char
	if t == "char" then
		len = 1
		return len, tonumber(NetUtil.BytesToChar(NetUtil.GetBytes(bytes, start, len)))
	end	

	-- char32
	if t == "char32" then
		len = 32
		return len, NetUtil.BytesToChars(NetUtil.GetBytes(bytes, start, len))
	end	

	-- log unpack fail
	NetProtocol.InfoFormat("NetProtocol.UnpackValue Error type:{0}",t)

	return nil, nil
end

-- send
function NetProtocol.Send(id1, id2, data)
	if id1 ~= 2 and id2 ~= 22 then
		NetProtocol.InfoFormat("NetProtocol::<color=yellow>Send Request</color> id1:{0}  id2:{1}",id1,id2)
	end
	local dataBytes = NetProtocol.Pack(id1, id2, data)
	if dataBytes == nil then
		NetProtocol.InfoFormat("NetProtocol::Send Error Pack Error: id1:{0} id2:{1}",id1, id2)
		return
	end	

	-- log
	if not NetConfig.IsHeart(id1, id2) then
		NetProtocol.InfoFormat("NetProtocol::<color=yellow>Send Success</color> id1:{0} id2:{1}",id1,id2)
	end
	-- send
	NetManager.GameSend(
		id1, 
		id2,
		dataBytes
	)
end

local currentIndex = 1
local currentTime = 0
-- send
function NetProtocol.SendProto(data)

	if(NetProtocol.noSendProtcol)then
		return
	end

	ServiceConnProxy.Instance:UpdateSendHeartTime()
	
	local id1 = data.cmd
	local id2 = data.param

	if not NetConfig.IsHeart(id1, id2) then
		if not NetConfig.IsCare(id1, id2) then
			NetProtocol.InfoFormat("NetProtocol::<color=yellow>SendProto</color> id1:{0} id2:{1}",id1,id2)
		end
	end

	-- new way begin
	local str = data:SerializeToString()

	local now = ServerTime.ServerTime
	if(now)then
		now = math.floor(now/1000)
	else
		now = 0
	end

	local delta = now - currentTime
	if(delta >0)then
		currentIndex = 1
	elseif(delta < 0)then
		now = currentTime +1
		currentIndex = 1
	else
		currentIndex = currentIndex+1
	end

	local nonce = xCmd_pb.Nonce()
	currentTime = now

	local sign = currentTime .. "_" .. currentIndex .. "_!^ro&"
	nonce.index = currentIndex
	nonce.timestamp = currentTime
	sign =  NetUtil.getSha1(sign)
	if(#sign ~= 40)then
		LogUtility.ErrorFormat("sign error 看到此错误请贴给张国兵！！！sign:{0},sign size:{1}",sign,#sign)
		return
	end
	nonce.sign = sign	

	local nonceStr = nonce:SerializeToString()
	if(Game.NetConnectionManager and Game.NetConnectionManager.EnableNonce)then
		NetManagerHelper.GameSend(id1, id2,nonceStr, str)
	else
		NetManagerHelper.GameSend(id1, id2, str)
	end
end

local ProtobufPool_Add = ProtobufPool.Add
-- receive
local function _Receive(id1, id2, data)
	-- local data = dataBytes

	-- local startTime = os.clock()
	-- startTime = math.floor(startTime * 1000)
	-- local packageSize = data and #data or 0

	local dataClass
	if(not NetConfig.IsNoPbUnpack(id1,id2))then
		-- local memSample = Debug_LuaMemotry.SampleBegin("NetProtocolUnpack")
		data,dataClass = NetProtocol.Unpack(id1, id2, data)
		-- Debug_LuaMemotry.SampleEnd(memSample)
	end
	
	if data == nil then		
		-- NetProtocol.InfoFormat("NetProtocol::Receive Error: id1:{0},id2:{1}",id1,id2)
		return
	end

	-- log	
	if not NetConfig.IsHeart(id1, id2) then
		if not NetConfig.IsCare(id1, id2) then
			-- NetProtocol.InfoFormat("NetProtocol::<color=lime>Receive</color> id1:{0},id2:{1}",id1,id2)
		end
	end

	-- protocol down
	-- local protocolDown = _G[string.format("Protocol_Down_%d", id1)]	
	-- if protocolDown ~= nil then
	-- 	protocolDown["Receive_"..id2](data)
	-- end

	-- dispatch 
	-- local memSample = Debug_LuaMemotry.SampleBegin("NetProtocolDispatch")
	-- NetProtocol.InfoFormat("NetProtocol::<color=lime>Receive</color> id1:{0},id2:{1}",id1,id2)
	NetProtocol.DispatchListener(id1, id2, data)
	-- Debug_LuaMemotry.SampleEnd(memSample)
	ProtobufPool_Add(dataClass,data)

	-- local endTime = os.clock()
	-- endTime = math.floor(endTime * 1000)
	-- local deltaTime = endTime - startTime
	-- ProtocolStatistics.Instance():Receive(id1, id2, packageSize, deltaTime)
end

local cachedReceives = {}
local function _CacheReceive(id1,id2,str)
	local cache = ReusableTable.CreateArray()
	cache[1],cache[2],cache[3] = id1,id2,str
	cachedReceives[#cachedReceives + 1] = cache
end

local cacheIDMap = {}
function NetProtocol.NeedCacheReceive(id1,id2)
	local map = cacheIDMap[id1]
	if(map==nil) then
		map = {}
		cacheIDMap[id1] = map
	end
	map[id2] = true
end

function NetProtocol.Receive(id1, id2, str)
	NetProtocol.InfoFormat("NetProtocol::<color=yellow>Receive</color> id1:{0} id2:{1}",id1,id2)
	if(NetProtocol.CachingSomeReceives) then
		local map = cacheIDMap[id1]
		if(map and map[id2]) then
			_CacheReceive(id1,id2,str)
			return
		end
	end
	local memSample = Debug_LuaMemotry.SampleBegin("NetProtocolReceive")
	_Receive(id1, id2, str)
	Debug_LuaMemotry.SampleEnd(memSample)
end

function NetProtocol.CallCachedReceives()
	local cache
	for i=1,#cachedReceives do
		cache = cachedReceives[i]
		_Receive(cache[1],cache[2],cache[3])
		ReusableTable.DestroyAndClearArray(cache)
	end
	TableUtility.ArrayClear(cachedReceives)
end

function NetProtocol.InfoFormat(fmt,...)
	if(Game.NetConnectionManager and Game.NetConnectionManager.EnableLog)then
		LogUtility.InfoFormat(fmt,...)
	end
end

function NetProtocol.Info(text)
	if(Game.NetConnectionManager and Game.NetConnectionManager.EnableLog)then
		LogUtility.Info(text)
	end
end