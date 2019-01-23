 autoImport("SkillBuffOwner")
 SkillBuffs = class("SkillBuffs")

-- local test = SkillBuffs.new()
-- test:Add(16001,BuffConfig.SelfBuff,BuffConfig.changeskill,33001)
-- local owner = test:GetOwner(BuffConfig.SelfBuff)
-- local skillparam = owner:GetParamsByType(BuffConfig.changeskill)[33001]
function SkillBuffs:ctor()
	self.buffOwner = {}
end

function SkillBuffs:GetOwner(buffOwner)
	local owner = nil
	if(buffOwner) then
		owner = self.buffOwner[buffOwner]
		if(not owner) then
			owner = SkillBuffOwner.new(buffOwner)
			self.buffOwner[buffOwner] = owner
		end
	end
	return owner
end

function SkillBuffs:Add(id,buffOwner,paramType,key)
	local owner = self:GetOwner(buffOwner)
	if(owner) then
		owner:Add(id,paramType,key)
	end
end

function SkillBuffs:Remove(id,buffOwner,paramType,key)
	local owner = self:GetOwner(buffOwner)
	if(owner) then
		owner:Remove(id,paramType,key)
	end
end

function SkillBuffs:Dispose()
	self.buffOwner = nil
end