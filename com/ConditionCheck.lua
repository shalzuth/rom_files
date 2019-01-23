ConditionCheck = class('ConditionCheck')
local TableClear = TableUtility.TableClear
function ConditionCheck:ctor()
	self.reasons = {}
	self:Reset()
end

function ConditionCheck:Reset()
	TableClear(self.reasons)
	self.dirty = false
	self.hasReason = false
	self.reasonCount = 0
end

function ConditionCheck:IsDirty()
	return self.dirty
end

function ConditionCheck:HasReason()
	if(self.dirty) then
		self.hasReason = false
		for k,v in pairs(self.reasons) do
			self.hasReason = true
			break
		end
	end
	return self.hasReason
end

function ConditionCheck:SetReason(reason)
	-- printOrange("加上reason"..reason)
	if(self.reasons[reason] == nil) then
		self.reasons[reason] = reason
		self.hasReason = true
		self.reasonCount = self.reasonCount + 1
	end
end

function ConditionCheck:RemoveReason(reason)
	-- printOrange("移除reason"..reason)
	if(self.reasons[reason] ~= nil) then
		self.reasons[reason] = nil
		self.dirty = true
		self.reasonCount = self.reasonCount - 1
	end
end

ConditionCheckWithDirty = class('ConditionCheckWithDirty',ConditionCheck)

function ConditionCheckWithDirty:ctor(dirty)
	self.reasons = {}
	self:Reset()
	if(dirty == nil) then dirty = false end
	self.dirty = dirty
end

function ConditionCheckWithDirty:HasReason()
	if(self.dirty) then
		self.hasReason = false
		for k,v in pairs(self.reasons) do
			self.hasReason = true
			break
		end
		self.dirty = false
	end
	return self.hasReason
end

function ConditionCheckWithDirty:SetReason(reason)
	-- printOrange("加上reason"..reason)
	if(self.reasons[reason]~=reason) then
		self.reasons[reason] = reason
		self.hasReason = true
		self.dirty = true
	end
end

function ConditionCheckWithDirty:RemoveReason(reason)
	-- printOrange("移除reason"..reason)
	if(self.reasons[reason]~=nil) then
		self.reasons[reason] = nil
		self.dirty = true
	end
end


--带有 与,或 性质的ConditionCheckWithDirty
LogicalConditionCheckWithDirty = class("LogicalConditionCheckWithDirty",ConditionCheckWithDirty)
LogicalConditionCheckWithDirty.And = "&&"
LogicalConditionCheckWithDirty.Or = "||"

function LogicalConditionCheckWithDirty:ctor(logic)
	self.logic = logic
	if(logic ~= LogicalConditionCheckWithDirty.Or and logic ~= LogicalConditionCheckWithDirty.And) then
		self.logic = LogicalConditionCheckWithDirty.And
	end 
	LogicalConditionCheckWithDirty.super.ctor(self)
end

function LogicalConditionCheckWithDirty:HasReason()
	if(self.dirty) then
		local cond = self.logic == LogicalConditionCheckWithDirty.Or
		self.hasReason = not cond
		for k,v in pairs(self.reasons) do
			if(v==cond) then
				self.hasReason = cond
				break
			end
		end
		self.dirty = false
	end
	return self.hasReason
end

function LogicalConditionCheckWithDirty:SetReason(reason)
	-- printOrange("加上reason"..reason)
	if(self.reasons[reason]~=true) then
		self.reasons[reason] = true
		self.hasReason = true
		self.dirty = true
	end
end

function LogicalConditionCheckWithDirty:RemoveReason(reason)
	-- printOrange("移除reason"..reason)
	if(self.reasons[reason]~=false) then
		self.reasons[reason] = false
		self.dirty = true
	end
end