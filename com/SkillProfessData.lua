SkillProfessData = class("SkillProfessData")

function SkillProfessData:ctor(profession,points)
	-- print("add skill profession "..profession)
	self.skills = {}
	self.profession = profession
	self.basePoints = 0
	self:UpdatePoints(points)
end

function SkillProfessData:UpdatePoints(points)
	-- print("点数",points)
	self.points = points
end

function SkillProfessData:UpdateBasePoints(points)
	self.basePoints = points
	-- --for test
	-- local skill
	-- local breakpoints = 0
	-- for i=1,#self.skills do
	-- 	skill = self.skills[i]
	-- 	if(skill.learned) then
	-- 		breakpoints = breakpoints + skill:GetBreakLevel()
	-- 	end
	-- end
	-- self.basePoints = self.points - breakpoints
	-- --for test
end

function SkillProfessData:UpdateSkill(serverSkillItem)
	local skill = self:FindSkillByIdAndSource(serverSkillItem.id,serverSkillItem.sourceid)
	if(skill) then
		skill:Reset(serverSkillItem.id,serverSkillItem.pos,serverSkillItem.autopos,serverSkillItem.cd,serverSkillItem.sourceid,serverSkillItem.extendpos,serverSkillItem.shortcuts)
		self:UpdateSingleSkill(skill,serverSkillItem)
	else
		skill = self:AddSkill(serverSkillItem)
	end
	return skill
end

function SkillProfessData:UpdateSingleSkill(skillItemData,serverSkillItem)
	if(skillItemData) then
		AstrolabeProxy.Instance:SkillSetSpecialEnable(skillItemData:GetSpecialID(),nil)

		skillItemData:SetActive(serverSkillItem.active)
		skillItemData:SetLearned(serverSkillItem.learn)
		skillItemData:SetSource(serverSkillItem.source)
		skillItemData:SetShadow(serverSkillItem.shadow)
		skillItemData:SetSpecialID(serverSkillItem.runespecid)
		skillItemData:SetReplaceID(serverSkillItem.replaceid)
		skillItemData:SetEnableSpecialEffect(serverSkillItem.selectswitch)
		skillItemData:SetExtraLevel(serverSkillItem.extralv)
		skillItemData:SetOwnerId(serverSkillItem.ownerid)

		AstrolabeProxy.Instance:SkillSetSpecialEnable(serverSkillItem.runespecid,serverSkillItem.selectswitch)
		-- print(skillItemData.id,serverSkillItem.shadow,serverSkillItem.pos)
		local consume = serverSkillItem.consume
		if(consume) then
			skillItemData:ResetUseTimes(consume.curvalue,consume.maxvalue,consume.nexttime)
		end
	end
end

function SkillProfessData:AutoFillAdd(id,sourceid)
	sourceid = sourceid or 0
	local skill = self:FindSkillByIdAndSource(id,sourceid)
	if(skill == nil) then
	local skillItemData = SkillItemData.new(id,0,0,self.profession,sourceid)
	self.skills[#self.skills + 1] =skillItemData
	end
end

function SkillProfessData:AddSkill(serverSkillItem)
	-- print(self.profession,"add skill",serverSkillItem.id,serverSkillItem.sourceid,serverSkillItem.pos)
	local skillItemData = SkillItemData.new(serverSkillItem.id,serverSkillItem.pos,serverSkillItem.autopos,self.profession,serverSkillItem.sourceid,serverSkillItem.extendpos,serverSkillItem.shortcuts)
	self:UpdateSingleSkill(skillItemData,serverSkillItem)
	self.skills[#self.skills + 1] =skillItemData
	return skillItemData
end

function SkillProfessData:RemoveSkill(serverSkillItem)
	-- print("remove skill",serverSkillItem.id,serverSkillItem.sourceid)
	local skill,index = self:FindSkillByIdAndSource(serverSkillItem.id,serverSkillItem.sourceid)
	if(skill) then
		table.remove(self.skills, index)
	end
	return skill
end

function SkillProfessData:FindSkillByIdAndSource(id,source)
	for i=1,#self.skills do
		if(id == self.skills[i].id and (source == nil or self.skills[i].sourceId == source)) then
			return self.skills[i],i
		end
	end
end

function SkillProfessData:FindSkillById(id)
	for i=1,#self.skills do
		if(id == self.skills[i]:GetID()) then
			return self.skills[i],i
		end
	end
end

function SkillProfessData:SortSkills()
	-- print("排序技能")
	if self.profession ~= ProfessionProxy.Instance.rootProfession.id then
		table.sort(self.skills,function (l,r)
			if(l.id == r.id) then
				return l.sourceId < r.sourceId
			else
				return l.id < r.id
			end
		end)
	else
		table.sort(self.skills, function (l,r)
			local lstaticData = l.staticData
			local rstaticData = r.staticData
			local passiveType = GameConfig.SkillType.Passive.type

			if lstaticData.SkillType ~= rstaticData.SkillType then
				if lstaticData.SkillType == passiveType then
					return false
				end
				if rstaticData.SkillType == passiveType then
					return true
				end
			end

			if lstaticData.Contidion.riskid ~= rstaticData.Contidion.riskid then
				if lstaticData.Contidion.riskid == nil then
					return true
				end
				if rstaticData.Contidion.riskid == nil then
					return false
				end
			end

			if l.id == r.id then
				return l.sourceId < r.sourceId
			else
				return l.id < r.id
			end
		end)
	end
	-- local t = ""
	-- for i=1,#self.skills do
	-- 	t = t..self.skills[i].id.." "..self.skills[i].staticData.NameZh.."\n"
	-- end
	-- print(t)
end