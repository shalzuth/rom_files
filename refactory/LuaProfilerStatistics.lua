LuaProfilerStatistics = class("LuaProfilerStatistics")

-- maxCPUCost == [1]
-- maxMemoryUsage == [2]
-- totalCPUCost == [3]
-- totalMemoryUsage == [4]
-- totalCPUCostPercentage = [5]
function LuaProfilerStatistics:Reset()
	self[1] = 0
	self[2] = 0
	self[3] = 0
	self[4] = 0
	self[5] = 0
end

function LuaProfilerStatistics:ctor()
	self:Reset()
end

function LuaProfilerStatistics:SetData(unit)
	self[1] = math.max(self[1],unit.elapsedTime)
	self[2] = math.max(self[2],unit.usedMemory)
	self[3] = self[3] + unit.elapsedTime
	self[4] = self[4] + unit.usedMemory
end

function LuaProfilerStatistics:SetPercentage(parentCell)
	if parentCell ~= nil then
		self[5] = (self[3] / parentCell.stat[3]) * 100
	end
end