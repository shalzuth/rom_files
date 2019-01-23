LuaProfilerSample = class("LuaProfilerSample")
autoImport("LogUtility")
local _collectgarbage = collectgarbage
local clock = os.clock
local concat = table.concat
local concatTable = {}

LuaProfilerSample.printLog = ""

LuaProfilerSample.__tostring = function(t)
	concatTable[1] = t.tag
	concatTable[2] = "\t"
	concatTable[3] = "CPUCost : "
	concatTable[4] = t.elapsedTime * 1000
	concatTable[5] = "ms   "
	concatTable[6] = "MemoryUsage : "
	concatTable[7] = t.usedMemory
	concatTable[8] = "kb   "
	return concat(concatTable)
end

function LuaProfilerSample:ctor(tag)
	self:Reset()
	self.tag = tag
	self.totalMemUsage = 0
end

function LuaProfilerSample:Reset()
	self.callingSource = nil
	self.tag = nil
	self.elapsedTime = 0
	self.usedMemory = 0
	self.stacklayer = 0
end

function LuaProfilerSample:Start()
	self.usedMemory = _collectgarbage("count")
	self.elapsedTime = clock()
end

function LuaProfilerSample:Stop()
	self.elapsedTime = clock() - self.elapsedTime
	self.usedMemory = _collectgarbage("count") - self.usedMemory
	if self.usedMemory < 0 then
		LogUtility.Info("MemError!!!     "..tostring(self))
	end
end