autoImport("ConditionCheck")
FuncAccessData = class("FuncAccessData")

function FuncAccessData:ctor(panelID)
	self.panelID = panelID
	self.lockConditions = ConditionCheckWithDirty.new()
end

function FuncAccessData:IsAccessable()
	return not self.lockConditions:HasReason()
end

function FuncAccessData:AddLockCond(cond)
	self.lockConditions:SetReason(cond)
end

function FuncAccessData:RemoveLockCond(cond)
	self.lockConditions:RemoveReason(cond)
end