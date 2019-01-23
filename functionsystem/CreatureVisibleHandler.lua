CreatureVisibleHandler = reusableClass("CreatureVisibleHandler")
CreatureVisibleHandler.PoolSize = 100

LayerChangeReason = {
	HidingSkill = 999999,
	CJ = 999998,
	CarrierWaiting = 999997,
	SceneSeat = 999996,
	DoubleAction = 999995,
}

function CreatureVisibleHandler:ctor()
	CreatureVisibleHandler.super.ctor(self)
	self.reason = {}
end

function CreatureVisibleHandler:HasReason()
	for k,v in pairs(self.reason) do
		return true
	end
	return false
end

function CreatureVisibleHandler:Visible(creature,v,reason)
	-- LogUtility.InfoFormat("creature visible id : {0} , visible : {1} , reason:{2}",creature.data.id,v,reason )
	if(v) then
		self.reason[reason] = nil 
		if(not self:HasReason()) then
			creature.assetRole:SetInvisible(false)
			if(creature.data) then
				creature:SetClickable(true)
			end
		end
	else
		self.reason[reason] = reason
		creature.assetRole:SetInvisible(true)
		if(creature.data) then
			creature:SetClickable(false)
		end
	end
end

-- override begin
function CreatureVisibleHandler:DoConstruct(asArray, creatureID)
end

function CreatureVisibleHandler:DoDeconstruct(asArray)
	TableUtility.TableClear(self.reason)
end
-- override end