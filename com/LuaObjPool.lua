
LuaObjPool = class("LuaObjPool")

-- function LuaObjPool.GetPool(poolName, maxCount)
-- 	if nil == LuaObjPool.PoolMap then
-- 		LuaObjPool.PoolMap = {}
-- 	end
-- 	local pool = LuaObjPool.PoolMap[poolName]
-- 	if nil == pool then
-- 		pool = {}
-- 		LuaObjPool.PoolMap[poolName] = pool
-- 	end
-- 	pool.maxCount = maxCount or 10
-- 	return pool
-- end

function LuaObjPool:ctor(name, maxCount, deletor)
	self.name = name
	self.maxCount = maxCount or 10
	self.deletor = deletor

	self.pool = {}
	self.keyQueue = {}
end

function LuaObjPool:Destroy(obj)
	if nil ~= self.deletor and nil ~= obj then
		self.deletor(obj)
	end
end

function LuaObjPool:AddOrRefreshKey(key)
	if self.keyQueue[#self.keyQueue] == key then
		return
	end

	local refresh = 0 ~= TableUtil.Remove(self.keyQueue, key)

	self.keyQueue[#self.keyQueue + 1] = key

	if not refresh then
		self:Trim()
	end
end

function LuaObjPool:Trim()
	local count = #self.keyQueue
	local removeCount = count-self.maxCount
	if 0 < removeCount then
		local needRemove
		for i = 1, removeCount do
			needRemove = self.pool[self.keyQueue[1]]
			self.pool[self.keyQueue[1]] = nil
			self:Destroy(needRemove)
			table.remove(self.keyQueue, 1)
		end
	end
end

function LuaObjPool:RemoveKey(key)
	return 0 ~= TableUtil.Remove(self.keyQueue, key)
end

function LuaObjPool:Get(key)
	local obj = self.pool[key]
	self.pool[key] = nil
	if nil ~= obj then
		self:RemoveKey(key)
	end
	return obj
end

function LuaObjPool:Put(key, obj)
	self.pool[key] = obj
	self:AddOrRefreshKey(key)
end

