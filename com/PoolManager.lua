autoImport("LuaTablePool")
autoImport("UserData")

PoolManager = class("PoolManager")

function PoolManager.Me()
	if nil == PoolManager.me then
		PoolManager.me = PoolManager.new()
	end
	return PoolManager.me
end

function PoolManager:ctor()
	self.poolMap = {}
	self:InitTablePool(UserData,1000)
	self:InitTablePool(RolePropsContainer,2000)
	self:InitTablePool(LNpc,100)
	self:InitTablePool(LPlayer,200)
end

function PoolManager:InitTablePool(class,maxCount)
	local pool = self.poolMap[class.__cname]
	if(pool == nil) then
		pool = LuaTablePool.new(class.__cname,maxCount)
		self.poolMap[class.__cname] = pool
	end
	pool.maxCount = maxCount
end

function PoolManager:GetTable(class)
	local pool = self.poolMap[class.__cname]
	if(pool) then
		return pool:Get()
	end
	return nil
end

function PoolManager:PutToPool(data)
	if(data) then
		local pool = self.poolMap[data.__cname]
		if(pool) then
			return pool:Put(data)
		end
	end
	return false
end