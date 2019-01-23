autoImport("LogUtility")
autoImport("LuaProfilerStatistics")

local concat = table.concat
local concatTable2 = {}
local concatTable3 = {}
LuaProfilerStackCell = class("LuaProfilerStackCell")

function LuaProfilerStackCell:Reset()
	self.stacklayer = 0
	self.source = nil
	self.parent = nil
	self.tag = nil
	self.call = 0
	self.stat:Reset()
end

function LuaProfilerStackCell:ctor()
	self.stat = LuaProfilerStatistics.new()
	self:Reset()
end

function LuaProfilerStackCell:InitRecord(sample,parent)
	self.stacklayer = sample.stacklayer
	self.source = sample.callingSource
	self.parent = parent
	self.tag = sample.tag
	self.call = 1
	self.stat:SetData(sample)
	self.stat:SetPercentage(self.parent)
end

function LuaProfilerStackCell:AddRecord(sample)
	self.call = self.call + 1
	self.stat:SetData(sample)
	self.stat:SetPercentage(self.parent)
end

function LuaProfilerStackCell:Statistics(needFormat)
	local tab = ""
	if needFormat then
		for i=1,self.stacklayer - 1 do
			tab = tab.."\t"
		end
	end
	concatTable2[1] = LuaProfilerSample.printLog
	concatTable2[2] = "Stack : "
	concatTable2[3] = self.source
	concatTable2[4] = "\n"
	concatTable2[5] = tab
	concatTable2[6] = self.tag
	concatTable2[7] = "\t"
	concatTable2[8] = "Call : "
	concatTable2[9] = self.call
	concatTable2[10] = "   MaxCPUCost : "
	concatTable2[11] = self.stat[1] * 1000
	concatTable2[12] = "ms   "
	concatTable2[13] = "MaxMemoryUsage : "
	concatTable2[14] = self.stat[2]
	concatTable2[15] = "kb   "
	concatTable2[16] = "TotalCPUCost : "
	concatTable2[17] = self.stat[3] * 1000
	concatTable2[18] = "ms   "
	concatTable2[19] = "TotalMemoryUsage : "
	concatTable2[20] = self.stat[4]
	concatTable2[21] = "kb"
	concatTable2[22] = "\n"
	LuaProfilerSample.printLog = concat(concatTable2)
end

function LuaProfilerStackCell:PercentageStatistics()
	if self.parent == nil then
		self:Statistics(false)
		return
	end
	local tab = ""
	for i=1,self.stacklayer - 1 do
		tab = tab.."\t"
	end
	concatTable3[1] = LuaProfilerSample.printLog
	concatTable3[2] = "Stack : "
	concatTable3[3] = self.source
	concatTable3[4] = "\n"
	concatTable3[5] = tab
	concatTable3[6] = self.tag
	concatTable3[7] = "\t"
	concatTable3[8] = "Call : "
	concatTable3[9] = self.call
	concatTable3[10] = "   TotalCPUCostTake : "
	concatTable3[11] = self.stat[5]
	concatTable3[12] = "%"
	concatTable3[13] = "\n"
	LuaProfilerSample.printLog = concat(concatTable3)
end