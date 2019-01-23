
Debug_LuaMemotry = {}

local Enable = false

local StringFormat = LogUtility.StringFormat
local LogFormat = LogUtility.InfoFormat
local LogIsEnable = LogUtility.IsEnable
local LogSetEnable = LogUtility.SetEnable
local FormatSize = LogUtility.FormatSize_KB

local ArrayClear = TableUtility.ArrayClear

local function FormatPercent(p)
	return StringFormat("{0:F2}%", p*100)
end

local memStart = nil
local memEnd = nil
local totalCost = nil

local sampleMap = {}
local sampleStack = {}

local running = false

function Debug_LuaMemotry.SampleBegin(k)
	if not Enable or not running then
		return nil
	end

	local v = sampleMap[k]
	if nil == v then
		v = {key=k,cost=0}
		sampleMap[k] = v
	end
	if nil ~= v.memStart then
		v.refCount = v.refCount + 1
	else
		v.memStart = collectgarbage("count")
		v.refCount = 1
	end

	return v
end

function Debug_LuaMemotry.SampleEnd(v)
	if not Enable or not running then
		return
	end
	
	if nil == v then
		return
	end
	if 0 < v.refCount then
		v.refCount = v.refCount-1
		if 0 == v.refCount then
			v.cost = v.cost + collectgarbage("count")-v.memStart
			v.memStart = nil
		end
	end
end

function Debug_LuaMemotry.Start()
	if not Enable or running then
		return
	end
	running = true

	collectgarbage("collect")
	memStart = collectgarbage("count")
	memEnd = memStart
	totalCost = 0

	for k,v in pairs(sampleMap) do
		v.memStart = nil
		v.cost = 0
		v.refCount = 0
	end
end

function Debug_LuaMemotry.End()
	if not Enable or not running then
		return
	end

	memEnd = collectgarbage("count")
	totalCost = memEnd-memStart

	for k,v in pairs(sampleMap) do
		if 0 < v.refCount then
			v.cost = v.cost + memEnd-v.memStart
			v.memStart = nil
			v.refCount = 0
		end
	end

	running = false
end

local sortArray = {}
local function SortComparator_Cost(v1, v2)
	return v1.cost > v2.cost
end
function Debug_LuaMemotry.Debug()
	if not Enable or not running then
		return
	end
	Debug_LuaMemotry.End()
	local logEnable = LogIsEnable()
	LogSetEnable(true)
	LogFormat("<color=white>Lua Memory: </color>{0}-->{1}, {2}", 
		FormatSize(memStart),
		FormatSize(memEnd),
		FormatSize(totalCost))
	if 0 < totalCost then
		local i = 1
		for k,v in pairs(sampleMap) do
			sortArray[i] = v
			i = i+1
		end
		table.sort(sortArray, SortComparator_Cost)
		for i=1, #sortArray do
			local v = sortArray[i]
			LogFormat("<color=white>Lua Memory({0}): </color>{1}, {2}", 
				v.key,
				FormatSize(v.cost),
				FormatPercent(v.cost/totalCost))
		end
		ArrayClear(sortArray)
	end
	LogSetEnable(logEnable)
	Debug_LuaMemotry.Start()
end