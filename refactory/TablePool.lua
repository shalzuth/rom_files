
TablePool = class("TablePool")

-- NOTE: if k is a table, k.PoolSize is the count limited in pool

if not TablePool.inited then
	TablePool.inited = true

	TablePool.DebugCheckInterval = 0
	TablePool.nextDebugCheckTime = 0
end

local LogFormat = LogUtility.InfoFormat
local LogIsEnable = LogUtility.IsEnable
local LogSetEnable = LogUtility.SetEnable

local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayPopBack = TableUtility.ArrayPopBack

function TablePool.DefaultCreator()
	return {}
end

local monitor
function TablePool.DebugCheck(time, deltaTime)
	if nil ~= monitor and monitor.checkPoolLeak == true then
		if time < TablePool.nextDebugCheckTime then
			return
		end
		TablePool.nextDebugCheckTime = time + TablePool.DebugCheckInterval
		
		local aliveCount = monitor:Check()
		if TablePool.Debug_ActiveCount ~= aliveCount then
			TablePool.Debug_ActiveCount = aliveCount
			-- LogUtility.InfoFormat("Alive Table Count: {0}", aliveCount)
		end
	end
end

function TablePool:ctor()
	self.pool = {}
	self.poolSize = {}
end

function TablePool:Log()
	local logEnable = LogIsEnable()
	LogSetEnable(true)
	for k,v in pairs(self.pool) do
		local poolSize = self.poolSize[v] or -1
		local poolName = (type(k) == "table" and k.__cname) or tostring(k)
		LogFormat("<color=#0066BB>Pool({0}): </color>{1}/{2}", 
			poolName,
			#v,
			poolSize)
	end
	LogSetEnable(logEnable)
end

function TablePool:_Init(k, size)
	local tag = self.pool[k]
	if nil == tag then
		tag = {}
		self.pool[k] = tag
		if nil ~= size then
			self.poolSize[tag] = size
		else
			if type(k) == "table" and nil ~= k.PoolSize then
				self.poolSize[tag] = k.PoolSize
			end
		end
	end
	return tag
end

function TablePool:Init(k, size)
	return self:_Init(k, size)
end

function TablePool:GetTag(k)
	return self:_Init(k)
end

function TablePool:SetPoolSize(k, size)
	local tag = self:GetTag(k)
	self:SetPoolSizeByTag(tag, size)
end

function TablePool:SetPoolSizeByTag(tag, size)
	self.poolSize[tag] = size
end

function TablePool:GetPoolSize(k)
	local tag = self.pool[k]
	if nil == tag then
		return -1
	end
	return self:GetPoolSizeByTag(tag)
end

function TablePool:GetPoolSizeByTag(tag)
	return self.poolSize[tag] or -1
end

function TablePool:Add(k, v)
	local tag = self:GetTag(k)
	return self:AddByTag(tag, v)
end

function TablePool:AddByTag(tag, v)
	if nil ~= monitor then
		monitor:RemoveItem(tag, v)
		if monitor.checkRemove then
			return false -- don't put into pool
		end
	end
	local poolSize = self:GetPoolSizeByTag(tag)
	-- stack(poolSize)
	if 0 < poolSize then
		if #tag >= poolSize then
			return false
		end
	elseif 0 == poolSize then
		return false
	end
	ArrayPushBack(tag, v)
	return true
end

-- return v, newCreated
function TablePool:RemoveOrCreate(k, creator)
	return self:RemoveOrCreateByTag(self.pool[k], creator, k)
end

function TablePool:RemoveOrCreateByTag(tag, creator, k)
	local v = nil
	local newCreated = false
	if nil ~= tag and 0 < #tag then
		v = ArrayPopBack(tag)
	else
		newCreated = true
		v = creator(k)
	end

	if nil ~= monitor then
		monitor:AddItem(tag, v)
	end
	return v, newCreated
end

-- debug mode begin
autoImport ("TablePoolMonitor")
function TablePool.EnableMonitor()
	if not monitor then
		monitor = TablePoolMonitor.Me()
	end
end
-- monitor = TablePoolMonitor.Me()
-- monitor.checkPoolLeak = true
-- monitor.checkRemove = true
-- debug mode end

