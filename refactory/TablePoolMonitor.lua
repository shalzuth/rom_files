TablePoolMonitor = class("TablePoolMonitor")

local function InfoFormat(fmt, ... )
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	Debug.Log(msg)
end

local function WarningFormat(fmt, ... )
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	Debug.LogWarning(msg)
end

local function ErrorFormat(fmt, ... )
	local msg = String.Format(fmt, ...)
	if LogUtility.traceEnable then
		msg = String.Format("{0}\n{1}", msg, debug.traceback())
	end
	Debug.LogError(msg)
end

function TablePoolMonitor.Me()
	if nil == TablePoolMonitor.me then
		TablePoolMonitor.me = TablePoolMonitor.new()
	end
	return TablePoolMonitor.me
end

function TablePoolMonitor:ctor()
	self.infos = {}
	self.removedInfos = {}
	self.AllPools = {}
	-- 最多允许5%不能放回池子
	self.MaxLeak = 0.05
	-- 每10s输出一次
	self.PrintIntevals = 10
	self.lasttime = 0
	-- %s处为生成日期 mmddHHMM 格式
	self.PoolSizeLogFilePath = './Assets/Resources/PoolSizeLog%s.csv'
end

function TablePoolMonitor:GetTracebackInfo(level)
	local ar = nil
	while not ar do
		ar = debug.getinfo(level, "lnS")
		level = level - 1
	end
	return ar.short_src  .. ":" .. ar.currentline
end

function TablePoolMonitor:AddItem(tag, obj)
	if self.AutoSize then
		self:AutoSizePoolRemove(tag)
	end
	if self.checkPoolLeak then
		self:Add(obj)
	end
end

function TablePoolMonitor:RemoveItem(tag, obj)
	if self.AutoSize then
		self:AutoSizePoolAdd(tag)
	end
	if self.checkPoolLeak then
		self:Remove(obj)
	end
end

function TablePoolMonitor:Add(obj)
	local objInfo = {}
	setmetatable(objInfo, {__mode = "v"})
	objInfo[1] = obj

	local debugInfo = self:GetTracebackInfo(6)--debug.traceback()

	local info = {
		[1] = objInfo, 
		[2] = debugInfo
	}
	self.infos[#self.infos+1] = info

	-- InfoFormat("Table Created: obj={0}, debugInfo={1}", 
	-- 		obj,
	-- 		debugInfo)
end

function TablePoolMonitor:Remove(obj)
	for i=1, #self.infos do
		local info = self.infos[i]
		if obj == info[1][1] then
			if self.checkRemove then
				info[3] = self:GetTracebackInfo(6)--debug.traceback()
				self.removedInfos[#self.removedInfos+1] = info
			end
			table.remove(self.infos, i)
			-- InfoFormat("Table Remove: obj={0}, debugInfo={1}", 
			-- 	obj,
			-- 	info[2])
			break
		end
	end
end

function TablePoolMonitor:Check()
	collectgarbage("collect")

	local activeCount = 0

	for i=#self.removedInfos, 1, -1 do
		if self.checkRemove then
			local info = self.removedInfos[i]
			if nil ~= info[1][1] then
				ErrorFormat("Table Invalid Referenced: obj={0}\n\ncreate={1}\n\ndestroy={2}", 
					tostring(info[1][1]), info[2], info[3])
			end
		end
		self.removedInfos[i] = nil
	end

	for i=#self.infos, 1, -1 do
		local info = self.infos[i]
		if nil ~= info[1][1] then
			activeCount = activeCount + 1
		else
			if not self.checkRemove then
				local debugInfo = info[2]
				ErrorFormat("Table Leaked: debugInfo={0}", debugInfo)
			end
			table.remove(self.infos, i)
		end
	end

	return activeCount
end

function TablePoolMonitor:StartAutoSize()
	self.AutoSizeStartTime = os.date("%m-%d %H:%M", os.time())
	self.AutoSize = true
end

function TablePoolMonitor:StopAutoSize()
	self:ReportAutoSize()
	self.AutoSize = false
	self.AllPools = {}
end

function TablePoolMonitor:ReportAutoSize()
	if self.AutoSize then
		-- 标题为采样开始时间=>报告时间 mm-dd HH:MM => mm-dd HH:MM
		local time = os.time()
		local date = os.date("%m-%d %H:%M", time)
		local title = self.AutoSizeStartTime .. " => " .. date .. "\n"
		local str = title .. "Key,AddTimes,MaxPoolSize,PoolSize\n"
		for tag,v in pairs(self.AllPools) do
			str = str .. v:PrintSelf(tag)
		end
		self:SavePoolSizeLogFile(os.date("%m%d%H%M", time), str)
	end
end

function TablePoolMonitor:CreateAutoPool()
	return 
	{
		CurrentCount = 0,
		RealCurrent = 0,
		PoolSize = 0,
		MaxPoolSize = 0,
		PoolLeak = {},
		AddTimes = 0, 
		PrintSelf = function(v, tag)
			local key = TablePoolMonitor.GetKeyByTag(tag)
			local str = string.format("%s,%s,%s,%s\n", (type(key) == "table" and key.__cname or tostring(key)), v.AddTimes, v.MaxPoolSize, v.PoolSize)
			-- Debug.LogWarning(str)
			return str
		end
	}
end

function TablePoolMonitor:GetAutoPoolByTag(tag)
	if not self.AllPools[tag] then
		self.AllPools[tag] = self:CreateAutoPool()
	end
	return self.AllPools[tag]
end

function TablePoolMonitor.GetKeyByTag(tag)
	for k,v in pairs(ReusableTable.pool.pool) do
		if v == tag then return k end
	end
	for k,v in pairs(ReusableObject.pool.pool) do
		if v == tag then return k end
	end
end

function TablePoolMonitor:SavePoolSizeLogFile(date, contents)
	local path = string.format(self.PoolSizeLogFilePath, date)
	local f = io.open(path, 'w+')
	f:write(contents)
	f:close()
end

function TablePoolMonitor:ExpandAutoPoolSize(autopool)
	autopool.PoolSize = autopool.PoolSize * 1.1 + 10
end

function TablePoolMonitor:RemoveRangeAutoPoolLeak(autopool)
	-- 升序排列
	table.sort( autopool.PoolLeak, function(a, b) return a < b end )
	-- 小于autopool.PoolSize的被删除
	for i=1,#autopool.PoolLeak do
		if autopool.PoolLeak[i] >= autopool.PoolSize then
			for k=i, #autopool.PoolLeak do
				table.remove(autopool.PoolLeak)
			end
			break
		end
	end
end

function TablePoolMonitor:ReSizeAutoPool(autopool)
	self:ExpandAutoPoolSize(autopool)
	self:RemoveRangeAutoPoolLeak(autopool)
end

function TablePoolMonitor:AutoSizePoolAdd(tag)
	if tag then
		local autopool = self:GetAutoPoolByTag(tag)
		if autopool.RealCurrent >= autopool.MaxPoolSize then
			autopool.MaxPoolSize = autopool.MaxPoolSize + 1
		end
		autopool.AddTimes = autopool.AddTimes + 1
		autopool.RealCurrent = autopool.RealCurrent + 1

		if autopool.CurrentCount >= autopool.PoolSize then
			table.insert(autopool.PoolLeak, autopool.MaxPoolSize)
			if #autopool.PoolLeak / autopool.AddTimes > self.MaxLeak then
				self:ReSizeAutoPool(autopool)
			end
		else
			autopool.CurrentCount = autopool.CurrentCount + 1
		end
	end
end

function TablePoolMonitor:AutoSizePoolRemove(tag)
	if tag then
		local autopool = self:GetAutoPoolByTag(tag)
		if autopool.CurrentCount > 0 then
			autopool.CurrentCount = autopool.CurrentCount - 1
		end
		if autopool.RealCurrent > 0 then
			autopool.RealCurrent = autopool.RealCurrent - 1
		end
	end
end