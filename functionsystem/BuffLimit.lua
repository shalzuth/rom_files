BuffLimit = reusableClass("BuffLimit")
BuffLimit.PoolSize = 5

function BuffLimit:SetData(fromID, ignoreTarget)
	self.fromID = fromID
	if ignoreTarget ~= nil then
		self.ignoreTarget = ignoreTarget
	end
end

function BuffLimit:GetFromID()
	return self.fromID
end

function BuffLimit:IsIgnoreTarget()
	return self.ignoreTarget == 1
end

function BuffLimit:DoConstruct(asArray)

end

function BuffLimit:DoDeconstruct(asArray)
	self.fromID = nil
	self.ignoreTarget = nil	
end