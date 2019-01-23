PurchaseDeltaTimeLimit = class('PurchaseDeltaTimeLimit')

local tickDeltaTime = 1

function PurchaseDeltaTimeLimit.Instance()
	if PurchaseDeltaTimeLimit.instance == nil then
		PurchaseDeltaTimeLimit.instance = PurchaseDeltaTimeLimit.new()
	end
	return PurchaseDeltaTimeLimit.instance
end

function PurchaseDeltaTimeLimit:ctor()
	self.cacheLimit = {}
end

function PurchaseDeltaTimeLimit:Start(key, limit_delta_time)
	if self.timer == nil then
		self.timer = TimeTickManager.Me():CreateTick(tickDeltaTime * 1000, tickDeltaTime * 1000, self.OnTick, self, 1)
	end
	self.timer:StartTick()
	local limit = self.cacheLimit[key]
	if limit == nil then
		limit = ReusableTable.CreateTable()
	end
	self.cacheLimit[key] = limit
	limit.deltaTime = limit_delta_time
	limit.currentDeltaTime = 0
end

function PurchaseDeltaTimeLimit:End(key)
	local limit = self.cacheLimit[key]
	self.cacheLimit[key] = nil
	ReusableTable.DestroyTable(limit)
end

function PurchaseDeltaTimeLimit:OnTick()
	local isEmpty = true
	for k, v in pairs(self.cacheLimit) do
		isEmpty = false

		v.currentDeltaTime = v.currentDeltaTime + tickDeltaTime
		if v.currentDeltaTime >= v.deltaTime then
			self:End(k)
		end
	end
	if isEmpty then
		self.timer:StopTick()
	end
end

function PurchaseDeltaTimeLimit:Destroy()
	if self.timer ~= nil then
		self.timer:Destroy()
		self.timer = nil
	end
end

function PurchaseDeltaTimeLimit:IsEnd(key)
	return self.cacheLimit[key] == nil
end