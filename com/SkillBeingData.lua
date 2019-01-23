autoImport("HeadImageData")
autoImport("SkillSimulate")
autoImport("SkillProfessData")

SkillBeingData = class("SkillBeingData",SkillProfessData)

function SkillBeingData:ctor(profession,beingData,usedPoints,leftPoints)
	usedPoints = usedPoints or 0
	self.id = profession
	self.isSelect = false
	self.isEnabled = false
	self.isEditMode = false
	self.equipedChanged = true
	self.beingData = beingData
	self.learnedSkills = {}
	self.equipedSkills = {}
	self.equipedSkillsFull = {}
	self.skillSortRequireLevel = {}
	self.dynamicSkillInfos = {}
	self:SetLeftPoint(leftPoints)
	SkillBeingData.super.ctor(self,profession,usedPoints)
	self.headImageData = HeadImageData.new()
	local data = Table_Npc[profession]
	if(data) then
		self.headImageData:TransByNpcData(data)
	else
		data = Table_Monster[profession]
		if(data) then
			self.headImageData:TransByNpcData(data)
		end
	end
	self.beingStaticData = data
	self.simulate = SkillSimulate.new(nil,0,0)
	self.simulate:ExtraCheckFunc(self.CheckBeing,self)
end

function SkillBeingData:CheckBeing(skill)
	local limitLevel = self.skillSortRequireLevel[math.floor(skill.data.id/1000)] 
	if(limitLevel) then
		local being = PetProxy.Instance:GetMyBeingNpcInfo(self.profession)
		if(being) then
			return being.lv >=limitLevel,limitLevel
		end

		--test
		return 6>=limitLevel,limitLevel
	end
	return true,limitLevel
end

function SkillBeingData:SetSkillRequiredLevel(id,level)
	self.skillSortRequireLevel[math.floor(id/1000)] = level
end

function SkillBeingData:GetIsEditMode(  )
	return self.simulate.isEditMode
end

function SkillBeingData:ResetSimulateDatas()
	self.simulate:ResetDatas(self.skills,self.points,self.leftPoints)
end

function SkillBeingData:InitPaths()
	self.paths = {}
	local skills = {}
	for i=1,#self.skills do
		skills[#skills+1] = self.skills[i].id
	end
	ProfessionTree.ParsePath(skills,self.paths)
	ProfessionTree.HandlePath(self.paths)
end

function SkillBeingData:SetAllActive( val )
	for i=1,#self.skills do
		self.skills[i]:SetActive(val)
	end
end

local Super_UpdateSingleSkill = SkillBeingData.super.UpdateSingleSkill
function SkillBeingData:UpdateSingleSkill(skillItemData,serverSkillItem)
	Super_UpdateSingleSkill(self,skillItemData,serverSkillItem)
	-- helplog(skillItemData.staticData.NameZh,skillItemData.pos,skillItemData.learned)
	-- helplog(skillItemData.staticData.NameZh,skillItemData.level,skillItemData.active)
	-- helplog(skillItemData)
	if skillItemData:GetPosInShortCutGroup(ShortCutProxy.SkillShortCut.BeingAuto) > 0 then
		self:AddEquipSkill(skillItemData)
	else
		self:RemoveEquipedSkill(skillItemData)
	end
	if(skillItemData) then
		if(skillItemData.learned) then
			if(TableUtility.ArrayFindIndex(self.learnedSkills, skillItemData)==0) then
				self.learnedSkills[#self.learnedSkills+1] = skillItemData
			end
		end
	end
end

function SkillBeingData:ClearSkills()
	local _ArrayClear = TableUtility.ArrayClear
	_ArrayClear(self.skills)
	_ArrayClear(self.learnedSkills)
	_ArrayClear(self.equipedSkills)
end

function SkillBeingData:SetLeftPoint(leftPoints)
	self.leftPoints = leftPoints or 0
end

function SkillBeingData:GetTotalPoints()
	return self.leftPoints + self.points
end

function SkillBeingData:GetEquipedSkills()
	if(self.equipedChanged) then
		self.equipedChanged = false
		TableUtility.ArrayClear(self.equipedSkillsFull)
		local max = 4
		if(GameConfig.Being and GameConfig.Being.auto_skill_max) then
			max = GameConfig.Being.auto_skill_max
		end

		local _BeingAuto = ShortCutProxy.SkillShortCut.BeingAuto
		for i=1,#self.equipedSkills do
			local skill = self.equipedSkills[i]
			self.equipedSkillsFull[skill:GetPosInShortCutGroup(_BeingAuto)] = skill
		end
		for i=1,max do
			if(self.equipedSkillsFull[i] == nil) then
				self.equipedSkillsFull[i] = SkillItemData.new(0,i,nil,nil,nil)
				self.equipedSkillsFull[i]:SetPosInShortCutGroup(_BeingAuto, i)
			end
		end
	end
	return self.equipedSkillsFull
end

function SkillBeingData:GetLearnedSkills()
	return self.learnedSkills
end

function SkillBeingData:RemoveLearnedSkill(skillitemData)
	TableUtility.ArrayRemove(self.learnedSkills, skillitemData)
end

function SkillBeingData:RemoveEquipedSkill(skillitemData)
	if(skillitemData) then
		local a = TableUtility.ArrayRemove(self.equipedSkills, skillitemData)
		if(a~=0) then
			self.equipedChanged = true
		end
	end
end

function SkillBeingData:AddEquipSkill(skillitemData)
	if(skillitemData) then
		self.equipedChanged = true
		if(TableUtil.IndexOf(self.equipedSkills,skillitemData) == 0) then
			self.equipedSkills[#self.equipedSkills+1] = skillitemData
		end
		local beingAuto = ShortCutProxy.SkillShortCut.BeingAuto
		table.sort(self.equipedSkills,function(l,r)
			return l:GetPosInShortCutGroup(beingAuto) < r:GetPosInShortCutGroup(beingAuto)
		end)
	end
end

function SkillBeingData:Server_UpdateDynamicSkillInfos(serverData)
	local dynamicServerData
	local dynamicData
	for i=1,#serverData.specinfo do
		dynamicServerData = serverData.specinfo[i]
		dynamicData = self.dynamicSkillInfos[dynamicServerData.id]
		if(dynamicData==nil) then
			dynamicData = SkillDynamicInfo.new()
			self.dynamicSkillInfos[dynamicServerData.id] = dynamicData
		end
		dynamicData:Server_SetProps(dynamicServerData.attrs)
		dynamicData:Server_SetCosts(dynamicServerData.cost)
		if(dynamicServerData.changerange) then
			dynamicData:Server_SetTargetRange(dynamicServerData.changerange/1000)
		end
		if(dynamicServerData.changenum) then
			dynamicData:Server_SetTargetNumChange(dynamicServerData.changenum)
		end
		if(dynamicServerData.changeready) then
			dynamicData:Server_SetChangeReady(dynamicServerData.changeready)
		end
	end
end

--skillidlevel
function SkillBeingData:GetDynamicSkillInfoByID(skillID)
	local sortID = math.floor(skillID / 1000)
	return self.dynamicSkillInfos[sortID]
end

function SkillBeingData:SetSelect(isSelect)
	self.isSelect = isSelect
end