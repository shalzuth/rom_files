 autoImport("SkillBuffParam")
 SkillBuffOwner = class("SkillBuffOwner")

function SkillBuffOwner:ctor(type)
	self.type = type
	self.paramByType = {}
	self.configs = {}
end

function SkillBuffOwner:GetConfig(id,paramType,key)
	local result = self.configs[id.."_"..paramType.."_"..key]
	if(not result) then
		local buffs = Table_Skill[id][self.type]
		if(buffs and #buffs>0) then
			local buff = nil
			for i=1,#buffs do
				buff = buffs[i]
				if(buff.type == paramType and buff.key == key) then
					result = buff
				end
			end
		end
		self.configs[id.."_"..paramType.."_"..key] = result
	end
	return result
end

function SkillBuffOwner:GetParamsByType(paramType)
	local params = nil
	if(paramType) then
		params = self.paramByType[paramType]
		if(not params) then
			params = {}
			self.paramByType[paramType] = params
		end
	end
	return params
end

function SkillBuffOwner:GetParam(id,paramType,key,autoCreate)
	local params = self:GetParamsByType(paramType)
	local param = params[key]
	if(not param and autoCreate) then
		param = SkillBuffParam.new(key,paramType)
		params[key] = param
	end
	return param
end

function SkillBuffOwner:Add(id,paramType,key)
	local config = self:GetConfig(id,paramType,key)
	if(config) then
		local param = self:GetParam(id,paramType,key,true)
		param:AddParams(config)
	end
end

function SkillBuffOwner:Remove(id,paramType,key)
	local param = self:GetParam(id,paramType,key)
	if(param) then
		local config = self:GetConfig(id,paramType,key)
		if(param:RemoveParams(config)) then
			local params = self:GetParamsByType(paramType)
			params[key] = nil
		end
	end
end