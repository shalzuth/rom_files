SkillBuffParam = class("SkillBuffParam")
-- SkillBuffParam.__index =function (t,k)
-- 		return 0
-- 	end

function SkillBuffParam:ctor(key,type)
	self.key = key
	self.type = type
	self.sum = 0
end

function SkillBuffParam:AddParams(config)
	for k,v in pairs(config) do
		if(k ~= "type" and k~= "key") then
			if(self[k]==nil) then
				self[k] = v
			else
				self[k] = self[k] + v
			end
		end
	end
	self.sum = self.sum + 1
end

function SkillBuffParam:RemoveParams(config)
	for k,v in pairs(config) do
		if(k ~= "type" and k~= "key") then
			if(self[k]~=nil) then
				self[k] = self[k] - v
			end
		end
	end
	self.sum = self.sum - 1
	return self.sum <=0
end