EquipedSkills = class("EquipedSkills")

function EquipedSkills:ctor(posParam)
	self._skills = {}
	self.posParam = posParam
	self.dirty = false
end

function EquipedSkills:GetSkills()
	if(self.dirty) then
		self.dirty = false
		local param = self.posParam or "pos"
		table.sort(self._skills,function(l,r)
			   	return l[param] < r[param]
			  	end)
	end
	return self._skills
end

function EquipedSkills:IsEmpty()
	return #self._skills == 0
end

function EquipedSkills:GetAutoFillSkills(totalNum)
end

function EquipedSkills:AddSkill(skillItemData)
	local index = TableUtility.ArrayFindIndex(self._skills, skillItemData)
	if(index<=0) then
		self.dirty = true
		self._skills[#self._skills+1] = skillItemData
	end
end

function EquipedSkills:RemoveSkill(skillItemData)
	TableUtility.ArrayRemove(self._skills, skillItemData)
end

function EquipedSkills:RemoveSkillAt(index)
	if(index>0 and index <= #self._skills) then
		table.remove(self._skills,index)
	end
end

TransformedEquipSkills = class("TransformedEquipSkills",EquipedSkills)

function TransformedEquipSkills:RefreshServerSkills(serverDatas)
	local currentNum = #self._skills
	local newNum = 0
	if(serverDatas~=nil)then
		newNum = #serverDatas
	end

	local delta = newNum - currentNum

	if(delta>0) then
		for i=1,delta do
			self:_CreateSkillItemData()
		end
	elseif(delta<0)then
		for i=1,-delta do
			self:RemoveSkillAt(#self._skills)
		end
	end

	for i=1,newNum do
		self:UpdateServerSkill(i,serverDatas[i])
	end
	self.dirty = true
end

function TransformedEquipSkills:_CreateSkillItemData()
	local skill = SkillItemData.new(0,0,0,0,0)
	self._skills[#self._skills+1] = skill
end

function TransformedEquipSkills:UpdateServerSkill(index,serverSkillItem)
	if(index>0 and index <= #self._skills) then
		local skill = self._skills[index]
		skill:Reset(serverSkillItem.id,serverSkillItem.pos,serverSkillItem.autopos,serverSkillItem.cd,serverSkillItem.sourceid,serverSkillItem.extendpos,serverSkillItem.shortcuts)
		self:UpdateSingleSkill(skill,serverSkillItem)
	end
end

function TransformedEquipSkills:UpdateSingleSkill(skillItemData,serverSkillItem)
	if(skillItemData) then
		skillItemData:SetActive(serverSkillItem.active)
		skillItemData:SetLearned(serverSkillItem.learn)
		skillItemData:SetSource(serverSkillItem.source)
		skillItemData:SetShadow(serverSkillItem.shadow)
		skillItemData:SetSpecialID(serverSkillItem.runespecid)
		skillItemData:SetReplaceID(serverSkillItem.replaceid)
		skillItemData:SetEnableSpecialEffect(serverSkillItem.selectswitch)
		skillItemData:SetExtraLevel(serverSkillItem.extralv)
	end
end