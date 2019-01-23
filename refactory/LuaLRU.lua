local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayPopBack = TableUtility.ArrayPopBack
local ArrayFindIndex = TableUtility.ArrayFindIndex
local ArrayRemove = TableUtility.ArrayRemove
local tableRemove = table.remove
local CreateArray = ReusableTable.CreateArray
local DestroyAndClearArray = ReusableTable.DestroyAndClearArray

LuaLRUKeyTable = class("LuaLRUKeyTable")
-- self.args = {
-- 	[1] = key_limit
-- 	[2] = container_limit
-- 	[3] = key time line
-- 	[4] = elements
-- }
local FAST_MODE = GAME_FAST_MODE
function LuaLRUKeyTable:ctor(key_limit,container_limit)
	self[1] = key_limit
	self[2] = container_limit
	self[3] = {}
	self[4] = {}
end

local function MoveElementToLast(array,element)
	local count = #array
	if(array[count] == element) then
		return
	end
	for i = count-1,1,-1 do
		if(array[i] == element) then
			tableRemove(array, i)
			array[count] = element
			return
		end
	end
end

function LuaLRUKeyTable:Add(key,obj)
	local array = self[4][key]
	local removed,removes
	if(array == nil) then
		array = CreateArray()
		self[4][key] = array
		self[3][#self[3] + 1] = key
		if(#self[3] > self[1] and self[1]~=0) then
			removed,removes = self:RemoveByKey(self[3][1])
		end
	elseif(self[1]~=0)then
		MoveElementToLast(self[3],key)
	end
	-- LogUtility.InfoFormat("LuaLRUKeyTable 的key数量为{0},limit {1}",#self[3],self[1])
	
	if(#array>=self[2]) then
		return false,nil
	end
	if(FAST_MODE or ArrayFindIndex(array,obj)==0) then
		ArrayPushBack(array, obj)
		return true,removes
	else
		LogUtility.ErrorFormat("LuaLRUKeyTable already has this obj {0} {1}",tostring(key),tostring(obj))
	end
end

function LuaLRUKeyTable:RemoveByKey(key)
	local array = self[4][key]
	if(array) then
		ArrayRemove(self[3],key)
		self[4][key] = nil
		return true,array
	end
	return false,nil
end

function LuaLRUKeyTable:TryGetValue(key)
	local array = self[4][key]
	if(array) then
		if(self[1]~=0)then
			MoveElementToLast(self[3],key)
		end
		local element = ArrayPopBack(array)
		if(#array == 0) then
			local removed,removes = self:RemoveByKey(key)
			if(removes~=nil) then
				DestroyAndClearArray(removes)
			end
		end
		return element
	end
end

function LuaLRUKeyTable:TryGetValueNoRemove(key)
	local array = self[4][key]
	if(array) then
		if(self[1]~=0)then
			MoveElementToLast(self[3],key)
		end
		if(#array>0) then
			return array[#array]
		end
		return nil
	end
end

function LuaLRUKeyTable:GetKeyCount()
	return #self[3]
end

function LuaLRUKeyTable:GetElementCountByKey(key)
	local array = self[4][key]
	if(array) then
		return #array
	end
	return 0
end

function LuaLRUKeyTable:KeyIsFull()
	return #self[3] >= self[1] and self[1]~=0
end

function LuaLRUKeyTable:GetKeyLimit()
	return self[1]
end

function LuaLRUKeyTable:ElementsFull(key)
	local array = self[4][key]
	if(array) then
		return #array >= self[2]
	end
	return false
end

function LuaLRUKeyTable:Clear()
	TableUtility.ArrayClear(self[3])
	TableUtility.TableClear(self[4])
end

--TODO 动态设置key limit


SimpleLuaLRU = class("LuaSimpleLuaLRULRU")

function SimpleLuaLRU:ctor(capacity)
	self[1] = capacity
	self[2] = {}
end

function SimpleLuaLRU:GetObjs()
	return self[2]
end

--return removed obj
function SimpleLuaLRU:Add(obj)
	if(obj~=nil) then
		local array = self[2]
		local index = ArrayFindIndex(array,obj)
		if(index==0) then
			local count = #array
			array[#array+1] = obj
			if(count==self[1]) then
				return tableRemove(array,1)
			end
		else
			tableRemove(array,index)
			array[#array+1] = obj
		end
	end
	return nil
end

function SimpleLuaLRU:Remove(obj)
	if(obj~=nil) then
		return ArrayRemove(self[2],obj)~=0
	end
end