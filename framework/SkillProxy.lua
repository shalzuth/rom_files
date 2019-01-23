autoImport("SkillItemData")
autoImport("SkillDynamicInfo")
autoImport("EquipedSkills")
SkillProxy = class('SkillProxy', pm.Proxy)
SkillProxy.Instance = nil;
SkillProxy.NAME = "SkillProxy"

SkillProxy.UNLOCKPROSKILLPOINTS = 40

SkillProxy.ManulSkillsIndex = 1
SkillProxy.AutoSkillsIndex = 2
SkillProxy.AutoSkillsWithComboIndex = 3

--场景管理，场景的加载队列管理等

function SkillProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SkillProxy.NAME
	if(SkillProxy.Instance == nil) then
		SkillProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end
	self.professionSkills = {}
	self.transformProfess = SkillProfessData.new(99999,0)
	--放到手动快捷栏的技能，hash表，key为skillidlevel
	self.equipedSkills = {}
	--放到自动快捷栏的技能，hash表，key为skillidlevel
	self.equipedAutoSkills = {}
	self.equipedSkillsArrays = {{},{},{}}
	self.comboGetPrevious = {}
	self.equipedAutoArrayDirty = false
	self:ResetTransformSkills(0)
	self.learnedSkills = {}
	self.sameProfessionType = {}
	--动态属性数据,hash表，key为skillID
	self.dynamicSkillInfos = {}
	self:initSameProfessionType()
	--
	self:InitCombo()
	FunctionSkillEnableCheck.Me():Launch()
end

function SkillProxy:InitCombo()
	if(GameConfig.AutoSkillGroup) then
		for k,v in pairs(GameConfig.AutoSkillGroup) do
			if(#v>1) then
				for i=#v,2,-1 do
					self.comboGetPrevious[v[i]] = v[i-1]
				end
			end
		end
	end
end

function SkillProxy:initSameProfessionType(  )
	for key,value in pairs(Table_Class) do
		local singleItem = Table_Class[key]
		self.sameProfessionType[singleItem.Type] = self.sameProfessionType[singleItem.Type] or {}
		table.insert(self.sameProfessionType[singleItem.Type],singleItem)
	end	
	for key,value in pairs(self.sameProfessionType) do
		table.sort(value,function (l,r)
			-- body
			return l.id <= r.id
		end)
		local list = {}
		for i=1,#value do
			local cur = value[i]
			local advanceClasses = cur.AdvanceClass
			if(advanceClasses) then
				for j=1,#advanceClasses do
					local single = advanceClasses[j]
					-- local tmp = list[tostring(single)] or {}
					-- table.insert(tmp,cur)
					list[tostring(single)] = cur
				end		
			end	
		end

		for i=1,#value do
			local cur = value[i]
			local singleData = list[tostring(cur.id)]	
			if(not singleData and key ~=0)then
				singleData = Table_Class[1]	
			end
			-- printRed("cur:"..cur.id)
			-- if(key ~=0)then
			-- 	printRed("pre:"..singleData.id)
			-- end
			cur.previousClasses = singleData
		end		
	end
end

--在手动技能快捷栏里查找sortid
function SkillProxy:GetEquipedSkillBySort(sortID)
	for k,v in pairs(self.equipedSkills) do
		if(v.sortID == sortID and v.sourceId ==0) then
			return true
		end
	end
	return false
end

function SkillProxy:GetEquipedSkillByGuid( skillId ,includeAuto)
	local skill = self.equipedSkills[skillId]
	if(skill == nil and includeAuto) then
		skill = self:GetEquipedAutoSkillByGuid(skillId)
	end
	return skill
end

function SkillProxy:GetEquipedAutoSkillByGuid( skillId )
	return self.equipedAutoSkills[skillId]
end

function SkillProxy:startCdTimeBySkillId( skillId )
	local sortID = math.floor(skillId / 1000)
	local skills = self.learnedSkills[sortID]
	local findSkill = self:FindSkill(skillId)
	local skillCD,skillDelayCD
	if(findSkill and Game.Myself ~= nil) then
		local skillInfo = Game.LogicManager_Skill:GetSkillInfo(findSkill:GetID())
		-- if(findSkill.staticData.CD)
		skillCD = skillInfo:GetCD(Game.Myself)
		skillDelayCD = skillInfo:GetDelayCD(Game.Myself)
		if(skills) then
			local skill
			for i=1,#skills do
				skill = self:GetEquipedSkillByGuid(skills[i].guid,true)
				if(skill == nil) then
					skill = self:GetTransformedSkill(skills[i].id)
				end
				--自动栏组合
				if(skill == nil) then
					skill = skills[i]
				end
				self:_InnerStartCD(skill,skillCD,skillDelayCD)
			end
		else
			self:_InnerStartCD(findSkill,skillCD,skillDelayCD)
		end
		GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
	end
end

function SkillProxy:_InnerStartCD(skillItemData,skillCD,skillDelayCD)
	if(skillItemData) then
		--技能CD
		if(skillCD) then
			CDProxy.Instance:AddSkillCD(skillItemData.id,0,skillCD,skillCD)
		end
		--handle special cd
		local staticData = skillItemData:GetStaticData()
		if(staticData) then
			local buff
			if(Game.MapManager:IsPVPMode()) then
				buff = staticData.Buff
			else
				buff = staticData.Pvp_buff
			end
			if(buff.self~=nil) then
				local buffConfig,cdTime,buffcd
				for i=1,#buff.self do
					buffConfig = Table_Buffer[buff.self[i]]
					if(buffConfig and buffConfig.BuffEffect and buffConfig.BuffEffect.type and buffConfig.BuffEffect.type=="AddSkillCD") then
						buffcd = buffConfig.BuffEffect.cd
						if(buffcd) then
							for j=1,#buffcd do
								cdTime = buffcd[j].time
								CDProxy.Instance:AddSkillCDBySortID(buffcd[j].id,0,cdTime,cdTime)
							end
						end
					end
				end
			end
		end
		if(skillDelayCD and skillDelayCD>0) then
			--技能公共CD
			CDProxy.Instance:AddSkillCD(CDProxy.CommunalSkillCDID,0,skillDelayCD,skillDelayCD)
		end
	end
end

---------------new--------
function SkillProxy:HasEnoughSkillPoint(pro)
	local p = self:FindProfessSkill(pro)
	if(p) then
		return p.points >=SkillProxy.UNLOCKPROSKILLPOINTS
	end
	return false
end

function SkillProxy:FindProfessSkill(pro,autoCreate)
	if self.multiSaveId ~= nil then
		local skills = SaveInfoProxy.Instance:GetProfessionSkill(self.multiSaveId, self.multiSaveType)
		if skills ~= nil then
			for i=1,#skills do
				if pro == skills[i].profession then
					return skills[i]
				end
			end
		end
	else
		for i=1,#self.professionSkills do
			if(pro==self.professionSkills[i].profession) then
				return self.professionSkills[i]
			end
		end
	end

	if(autoCreate) then
		local professData = SkillProfessData.new(pro,0)
		local p = Table_Class[pro]
		for i=1,#p.Skill do
			professData:AutoFillAdd(p.Skill[i])
		end
		self:AddProfessSkill(professData)
		return professData
	end
	return nil
end

function SkillProxy:FindSkill(skillID,profession)
	local professionSkill = nil
	if(profession) then
		professionSkill = self:FindProfessSkill(profession)
		if(professionSkill) then
			return professionSkill:FindSkillById(skillID)
		end
	end
	local skill
	for i=1,#self.professionSkills do
		skill = self.professionSkills[i]:FindSkillById(skillID)
		if(skill) then
			return skill
		end
	end
	return self:GetTransformedSkill(skillID)
end

function SkillProxy:ServerReInit(serverData)
	Game.Myself:Client_SetAutoFakeDead(0)
	self.professionSkills = {}
	self:ClearEquipedSkill()
	self:ClearEquipedSkill(true)
	self.learnedSkills = {}
	local professSkill
	for i=1,#serverData.data do
		self:AddProfessSkill(self:CreateProfessSkill(serverData.data[i]))
	end
end

function SkillProxy:ClearEquipedSkill(isAutoMode)
	local t = isAutoMode and self.equipedAutoSkills or self.equipedSkills
	for k,v in pairs(t) do
		FunctionSkillEnableCheck.Me():RemoveCheckSkill(v)
	end
	if(isAutoMode) then
		self.equipedAutoSkills = {}
		self.equipedSkillsArrays[SkillProxy.AutoSkillsIndex] = {}
	else
		self.equipedSkills = {}
		self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex] = {}
	end
end

function SkillProxy:CreateProfessSkill(serverSkillData)
	local data
	local skill
	local professSkill = SkillProfessData.new(serverSkillData.profession,serverSkillData.usedpoint)
	local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
	for j=1,#serverSkillData.items do
		data = serverSkillData.items[j]
		skill = professSkill:UpdateSkill(data)
		-- SkillUtils.RefreshPlayerSkillData(data.id)
		if self:_CheckPosInShortCut(skill) then
			self:AddEquipSkill(skill)
		end
		if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
			self:AddEquipSkill(skill,true)
		end
		if(skill.learned) then
			self:LearnedSkill(skill)
		end
	end
	professSkill:SortSkills()
	professSkill:UpdateBasePoints(serverSkillData.primarypoint)
	return professSkill
end

function SkillProxy:_CheckPosInShortCut(skill)
	if skill ~= nil then
		local _ShortCutEnum = ShortCutProxy.ShortCutEnum
		for k,v in pairs(_ShortCutEnum) do
			if skill:GetPosInShortCutGroup(v) > 0 then
				return true
			end
		end
	end
	return false
end

function SkillProxy:AddProfessSkill(professSkill)
	self.professionSkills[#self.professionSkills + 1] = professSkill
	table.sort(self.professionSkills,function (l,r)
		return l.profession < r.profession
	end)
end

function SkillProxy:AddEquipSkill(skillItemData,isAutoMode)
	local skilltable = isAutoMode and self.equipedAutoSkills or self.equipedSkills
	local skill = skilltable[skillItemData.guid]
	if(skill==nil or skill~=skillItemData) then
		EventManager.Me():PassEvent(SkillEvent.SkillEquip,skillItemData)
		skilltable[skillItemData.guid] = skillItemData
	end
	local skillArray = self:GetEquipedSkillsArray(isAutoMode)
	if(skillItemData.shadow == false) then
		local shortCutType
		if isAutoMode then
			shortCutType = ShortCutProxy.SkillShortCut.Auto
		else
			shortCutType = ShortCutProxy.ShortCutEnum.ID1
		end
		if(TableUtil.IndexOf(skillArray,skillItemData) == 0) then
			local added = false
			for i=1,#skillArray do
				if(skillArray[i]:GetPosInShortCutGroup(shortCutType) > skillItemData:GetPosInShortCutGroup(shortCutType)) then
					table.insert(skillArray,i,skillItemData)
					added = true
					break
				elseif(skillArray[i]:GetPosInShortCutGroup(shortCutType) == skillItemData:GetPosInShortCutGroup(shortCutType)) then
					skillArray[i] = skillItemData
					added = true
					break
				end
			end
			if(not added) then
				skillArray[#skillArray + 1] = skillItemData
			end
			if(isAutoMode) then
				self.equipedAutoArrayDirty = true
				if(skillItemData.staticData.SkillType == SkillType.FakeDead) then
					Game.Myself:Client_SetAutoFakeDead(skillItemData:GetID())
				end
			end
		else
			table.sort(skillArray,function(l,r)
			   	return l:GetPosInShortCutGroup(shortCutType) < r:GetPosInShortCutGroup(shortCutType)
			  	end)
		end
	else
		TableUtil.Remove(skillArray,skillItemData)
	end
end

function SkillProxy:RemoveEquipSkill(skillItemData,isAutoMode)
	local skilltable = isAutoMode and self.equipedAutoSkills or self.equipedSkills
	skilltable[skillItemData.guid] = nil
	local skillArray = self:GetEquipedSkillsArray(isAutoMode)
	if(TableUtil.Remove(skillArray,skillItemData)>0)then
		if(isAutoMode) then
			self.equipedAutoArrayDirty = true
		end
	end
	if(self.equipedAutoSkills[skillItemData.guid] == nil and self.equipedSkills[skillItemData.guid] ==nil) then
		EventManager.Me():PassEvent(SkillEvent.SkillDisEquip,skillItemData)
	end
	if(isAutoMode and self.equipedAutoSkills[skillItemData.guid] == nil) then
		if(skillItemData.staticData.SkillType == SkillType.FakeDead) then
			Game.Myself:Client_SetAutoFakeDead(0)
		end
	end
end

function SkillProxy:LearnedSkill(skillItemData)
	self.equipedAutoArrayDirty = true
	local skills = self.learnedSkills[skillItemData.sortID]
	if(not skills) then
		skills = {}
		self.learnedSkills[skillItemData.sortID] = skills
		skills[1] = skillItemData
	else
		if(TableUtil.IndexOf(skills,skillItemData)==0) then
			skills[#skills+1] = skillItemData
		end
	end
	if(skillItemData.id == GameConfig.Expression_Blink.needskill) then
		FunctionPlayerHead.Me():EnableBlinkEye()
	end

	local beings = self:GetSummonBeings(skillItemData.staticData)
	if(beings and #beings>0) then
		CreatureSkillProxy.Instance:SetEnableBeings(beings,true)
	end
end

function SkillProxy:GetSummonBeings(staticData)
	local Logic_Param = staticData.Logic_Param
	if(Logic_Param) then
		return Logic_Param.being_ids
	end
end

function SkillProxy:RemoveLearnedSkill(skillItemData)
	local skills = self.learnedSkills[skillItemData.sortID]
	if(skills) then
		TableUtil.Remove(skills,skillItemData)
		if(#skills==0) then
			self.learnedSkills[skillItemData.sortID] = nil
			local beings = self:GetSummonBeings(skillItemData.staticData)
			if(beings and #beings>0) then
				CreatureSkillProxy.Instance:SetEnableBeings(beings,false)
			end
		end
	end
end

function SkillProxy:GetUsedPoints()
	if(self.usedPointDirty) then
		self.usedPointDirty = false
		self.totalUsedPoint = 0
		for i=1,#self.professionSkills do
			if(self.professionSkills[i].points) then
				self.totalUsedPoint = self.totalUsedPoint + self.professionSkills[i].points
			end
		end
	end
	return self.totalUsedPoint
end

function SkillProxy:Update( data )
	-- printRed("update")
	local update = data.update
	local del = data.del
	local myself = Game.Myself;
	local proId = myself.data.userdata:Get(UDEnum.PROFESSION);
	local profess = nil
	local professSkill
	local data
	local skill
	for i=1,#del do
		profess = del[i]
		professSkill = self:FindProfessSkill(profess.profession)
		if(professSkill) then
			for j=1,#profess.items do
				data = profess.items[j]
				skill = professSkill:RemoveSkill(data)
				if(skill) then 
					self:RemoveEquipSkill(skill)
					self:RemoveEquipSkill(skill,true)
					self:RemoveLearnedSkill(skill) 
				end
			end
		end
	end

	for i=1,#update do
		profess = update[i]
		professSkill = self:FindProfessSkill(profess.profession)
		if(professSkill) then
			self.usedPointDirty = true
			professSkill:UpdatePoints(profess.usedpoint)
			local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
			for j=1,#profess.items do
				data = profess.items[j]
				-- LogUtility.InfoFormat("添加技能..{0} 职业:{1}",data.id,profess.profession)
				skill = professSkill:UpdateSkill(data)
				if(data.consume) then
					GameFacade.Instance:sendNotification(SkillEvent.SkillWithUseTimesChanged,skill.id)
				end
				-- SkillUtils.RefreshPlayerSkillData(data.id)
				if self:_CheckPosInShortCut(skill) then
					self:AddEquipSkill(skill)
				else
					self:RemoveEquipSkill(skill)
				end
				if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
					self:AddEquipSkill(skill,true)
				else
					self:RemoveEquipSkill(skill,true)
				end
				if(skill.learned) then
					self:LearnedSkill(skill)
				end
				-- if(skill:getCdTime()>0) then
				-- 	self:startCdTimeBySkillId(skill.id)
				-- end
			end
			professSkill:UpdateBasePoints(profess.primarypoint)
			professSkill:SortSkills()
		else
			self:AddProfessSkill(self:CreateProfessSkill(profess))
		end
	end
end

function SkillProxy:GetEquipedSkillsArray(isAuto)
	if(isAuto) then
		return self.equipedSkillsArrays[SkillProxy.AutoSkillsIndex]
	else
		return self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex]
	end
end

--手动技能快捷栏数据,autoFill是否补全空栏上的数据,id技能快捷栏id
function SkillProxy:GetCurrentEquipedSkillData( autoFill ,shortCutID)
	if(shortCutID==nil) then
		shortCutID = ShortCutProxy.ShortCutEnum.ID1
	end
	if(autoFill) then
		local equipedSkillData = {}
		if(autoFill)then
			for i=1,ShortCutData.CONFIGSKILLNUM do
				local item = SkillItemData.new(0,i,nil,nil,nil,i)
				item:SetPosInShortCutGroup(shortCutID, i)
				equipedSkillData[i] = item
			end
		end
		local pos
		local equipedSkills
		if self.multiSaveId ~= nil then
			equipedSkills = SaveInfoProxy.Instance:GetEquipedSkills(self.multiSaveId, self.multiSaveType)
		end
		equipedSkills = equipedSkills or self.equipedSkills
		for k,v in pairs(equipedSkills) do
			if(autoFill)then
				pos = v:GetPosInShortCutGroup(shortCutID)
				if pos ~= nil and pos ~= 0 then
					equipedSkillData[pos] = v
				end
			elseif(not v.shadow) then
				table.insert(equipedSkillData,v)
			end
		end
		if(not autoFill) then
			local ID1 = ShortCutProxy.ShortCutEnum.ID1
			table.sort(equipedSkillData,function(l,r)
			   	return l:GetPosInShortCutGroup(ID1) < r:GetPosInShortCutGroup(ID1)
			  	end)
		end
		return equipedSkillData
	end
	return self:GetEquipedSkillsArray(false)
end

--自动技能快捷栏数据
function SkillProxy:GetEquipedAutoSkillData(autoFill)
	if(autoFill) then
		local equipedSkillData = {}
		if(autoFill)then
			for i=1,ShortCutData.CONFIGAUTOSKILLNUM do
				local item = SkillItemData.new(0,0,i)
				equipedSkillData[i] = item
			end
		end
		local equipedAutoSkills
		if self.multiSaveId ~= nil then
			equipedAutoSkills = SaveInfoProxy.Instance:GetEquipedAutoSkills(self.multiSaveId, self.multiSaveType)
		end
		equipedAutoSkills = equipedAutoSkills or self.equipedAutoSkills
		local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
		for k,v in pairs(equipedAutoSkills) do
			if(autoFill)then
				equipedSkillData[v:GetPosInShortCutGroup(shortCutAuto)] = v
			elseif(not v.shadow) then
				table.insert(equipedSkillData,v)
			end
		end
		local sproxy = ShortCutProxy.Instance
		table.sort(equipedSkillData,function(l,r)
			if sproxy:AutoSkillIsLocked(l:GetPosInShortCutGroup(shortCutAuto)) == sproxy:AutoSkillIsLocked(r:GetPosInShortCutGroup(shortCutAuto)) then
		   		return l:GetPosInShortCutGroup(shortCutAuto) < r:GetPosInShortCutGroup(shortCutAuto)
		   	end
		   	return not sproxy:AutoSkillIsLocked(l:GetPosInShortCutGroup(shortCutAuto))
		  	end)
		return equipedSkillData
	end
	return self:GetEquipedSkillsArray(true)
end

function SkillProxy:GetEquipedAutoSkillNum(includeShadow)
	local num = 0
	local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
	for k,v in pairs(self.equipedAutoSkills) do
		if(not v.shadow or (v.shadow and includeShadow)) then
			if not ShortCutProxy.Instance:AutoSkillIsLocked(v:GetPosInShortCutGroup(shortCutAuto)) then
				num = num + 1
			end
		end
	end
	return num
end

function SkillProxy:HasLearnedSkill(skillID)
	local skill = self:GetLearnedSkillWithSameSort(skillID)
	return  skill~= nil and skill.id >= skillID
end

function SkillProxy:HasLearnedSkillBySort(skillSortID)
	local skill = self:GetLearnedSkillBySortID(skillSortID)
	return  skill~= nil
end

function SkillProxy:GetLearnedSkill(skillID)
	local sortID = math.floor(skillID / 1000)
	local skills = self.learnedSkills[sortID]
	if(skills) then
		for i=1,#skills do
			if(skills[i].id == skillID) then
				return skills[i]
			end
		end
	end
	return nil
end

function SkillProxy:GetLearnedSkillWithSameSort(skillID)
	local sortID = math.floor(skillID / 1000)
	return self:GetLearnedSkillBySortID(sortID)
end

function SkillProxy:GetLearnedSkillBySortID(sortID)
	local skills = self.learnedSkills[sortID]
	return skills ~= nil and skills[1] or nil
end

function SkillProxy:ForbitUse(skillItemData)
	if(skillItemData and skillItemData.staticData and skillItemData.staticData.ForbidUse~=nil) then
		if(Game.MapManager:IsPVPMode_GVGDetailed()) then
			return skillItemData.staticData.ForbidUse & SkillItemData.ForbidUse.GVG > 0
		end
	end
	return false
end

function SkillProxy:SkillCanBeUsed(skillItem)
	if(Game.Myself.data:HasLimitSkill()) then
		local skillID
		if(type(skillItem)=="number") then skillID = skillItem
		else skillID = skillItem:GetID() end
		if(Game.Myself.data:GetLimitSkillTarget(skillID)==nil) then
			return false
		end
	end
	if(self:ForbitUse(skillItem)) then
		return false
	end
	return (not self:IsInCD(skillItem) and self:HasEnoughSp(skillItem) and self:HasEnoughHp(skillItem) and self:IsFitPreCondition(skillItem) and self:HasFitSpecialCost(skillItem)) or false
end

function SkillProxy:SkillCanBeUsedByID(skillID, allowNoLearned)
	if(Game.Myself.data:HasLimitSkill()) then
		if(Game.Myself.data:GetLimitSkillTarget(skillID)==nil) then
			return false
		end
	end
	local learnedSkill = self:GetLearnedSkill(skillID)
	if(learnedSkill) then
		local canBeUsed = (not self:IsInCD(learnedSkill) and self:HasEnoughSp(learnedSkill) and self:HasEnoughHp(learnedSkill) and self:IsFitPreCondition(learnedSkill) and self:HasFitSpecialCost(learnedSkill)) or false
		if(self:ForbitUse(skillItem)) then
			return false
		end
		-- if not canBeUsed then
		-- 	print(string.format("<color=red>skill(%d)</color> InCD=%s, HasSP=%s, FitPreCondion=%s", 
		-- 		skillID,
		-- 		tostring(self:IsInCD(learnedSkill)),
		-- 		tostring(self:HasEnoughSp(learnedSkill)),
		-- 		tostring(self:IsFitPreCondition(learnedSkill))))
		-- end
		return canBeUsed
	else
		learnedSkill = self:FindSkill(skillID)
		if(learnedSkill) then
			return self:SkillCanBeUsed(learnedSkill)
		end
		return allowNoLearned or false
	end
end

function SkillProxy:IsInCD(skillItem)
	if(skillItem) then
		if(skillItem.staticData.id == Game.Myself.data:GetAttackSkillIDAndLevel()) then
			return false
		end
		return CDProxy.Instance:SkillIsInCD(skillItem.sortID)
	end
	return true
	-- return skillItem:getCdTime()>0
end

function SkillProxy:IsFitPreCondition(skillItem)
	return skillItem.fitPreCondion
end

function SkillProxy:HasEnoughSp(skillItem,sp)
	local myself = Game.Myself
	if(myself.data:IsTransformed()) then
		return true
	end
	if(sp == nil) then
		sp = myself.data.props.Sp:GetValue()
	end
	return self:_HasEnoughProp(myself,skillItem,"GetSP",sp)
end

function SkillProxy:HasEnoughHp(skillItem,hp)
	local myself = Game.Myself
	if(hp == nil) then
		hp = myself.data.props.Hp:GetValue()
	end
	return self:_HasEnoughProp(myself,skillItem,"GetHP",hp)
end

function SkillProxy:_HasEnoughProp(myself,skillItem,skillInfoFuncName,value)
	local skillID
	if(type(skillItem)=="number") then skillID = skillItem
	else skillID = skillItem:GetID() end
	local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
	if(skillInfo) then
		local func = skillInfo[skillInfoFuncName]
		if(func) then
			local cost = func(skillInfo,myself)
			if(cost and value < cost) then
				return false
			else
				return true
			end
		end
	end
	return false
end

function SkillProxy:HasFitSpecialCost(skillItem)
	local myself = Game.Myself
	if(myself.data:IsTransformed()) then
		return true
	end
	local skillStaticData 
	if(type(skillItem)=="number") then skillStaticData = Table_Skill[skillItem] 
	else skillStaticData = skillItem:GetStaticData() end
	if(skillStaticData) then
		local dynamicSkillInfo = Game.Myself.data:GetDynamicSkillInfo(skillStaticData.id)
		if(#skillStaticData.SkillCost>0) then
			local specialCost,num
			for i=1,#skillStaticData.SkillCost do
				specialCost = skillStaticData.SkillCost[i]
				if(specialCost.itemID) then
					if(dynamicSkillInfo~=nil) then
						num = dynamicSkillInfo:GetItemNewCost(specialCost.itemID,specialCost.num)
					else
						num = specialCost.num
					end
					if(BagProxy.Instance:GetItemNumByStaticID(specialCost.itemID)<num) then
						return false,Table_Item[specialCost.itemID],num,true
					end
				end
				if(specialCost.buffID) then
					num = specialCost.num
					if(myself:GetBuffLayer(specialCost.buffID)<num) then
						return false,"nil",num,false
					end
				end
			end
		elseif(dynamicSkillInfo and dynamicSkillInfo.costs) then
			for k,cost in pairs(dynamicSkillInfo.costs) do
				if(cost[1]~=nil and cost[2]>0) then
					if(BagProxy.Instance:GetItemNumByStaticID(cost[1])<cost[2]) then
						return false,Table_Item[cost[1]],cost[2],true
					end
				end
			end
		end
	end
	return true
end

function SkillProxy:GetLearnedSkillLevelBySortID(sortID)
	local skills = self.learnedSkills[sortID]
	if(skills and #skills>0) then
		return skills[1].level
	end
	return 0
end

function SkillProxy:HasAttackSkill(skills)
	local hasAttackTypeSkill
	for k,skillData in pairs(skills) do
		if(skillData and skillData.staticData) then
			local config = Table_SkillMould[skillData.sortID*1000 + 1]
			if(config and config.Atktype and config.Atktype==1) then
				hasAttackTypeSkill = true
				break
			end
		end
	end
	return hasAttackTypeSkill
end

function SkillProxy:GetTransformedSkills()
	if(self.dynamicTransformedSkills) then
		return self.dynamicTransformedSkills:GetSkills()
	end
	return self.equipedTransformSkills
end

function SkillProxy:UpdateTransformedSkills(update,del,clear)
	local data
	-- if(del and self.dynamicTransformedSkills) then
	-- 	for i=1,#del do
	-- 		data = del[i]
	-- 		skill = self.transformProfess:RemoveSkill(data)
	-- 		if(skill) then
	-- 			self.dynamicTransformedSkills:RemoveSkill(skill)
	-- 			self:RemoveLearnedSkill(skill)
	-- 		end
	-- 		if(self.dynamicTransformedSkills:IsEmpty()) then
	-- 			self.dynamicTransformedSkills = nil
	-- 		end
	-- 	end
	-- end
	if(update and #update >0) then
		if(self.dynamicTransformedSkills==nil) then
			self.dynamicTransformedSkills = TransformedEquipSkills.new("pos")
		end
		self.dynamicTransformedSkills:RefreshServerSkills(update)
	elseif(self.dynamicTransformedSkills)then
		self.dynamicTransformedSkills:RefreshServerSkills({})
	end
	if(clear) then
		self.dynamicTransformedSkills = nil
	end
end

function SkillProxy:ResetTransformSkills(monsterID)
	if(monsterID==0) then
		if(self.equipedTransformSkills) then
			for i=1,#self.equipedTransformSkills do
				self:RemoveLearnedSkill(self.equipedTransformSkills[i])
			end
		end
		self.equipedTransformSkills = nil
		self:UpdateTransformedSkills(nil,nil,true)
	else
		local monster = Table_Monster[monsterID]
		if(monster) then
			self.equipedTransformSkills = {}
			local skills = monster.Transform_Skill
			for i=1,#skills do
				local skill = SkillItemData.new(skills[i],i,0,0,0)
				self.equipedTransformSkills[#self.equipedTransformSkills+1] = skill
				self:LearnedSkill(skill)
			end
		end
	end
end

function SkillProxy:GetAutoBattleSkills()
	if(self.equipedTransformSkills~=nil and #self.equipedTransformSkills>0) then
		return self.equipedTransformSkills
	end
	-- return self:GetEquipedSkillsArray(true)
	return self:GetEquipedAutoSkillData()
end

local _removeDuplicates = {}
function SkillProxy:GetAutoBattleSkillsWithCombo()
	if(self.equipedTransformSkills ~=nil and #self.equipedTransformSkills>0) then
		return self.equipedTransformSkills
	end
	local array = self.equipedSkillsArrays[SkillProxy.AutoSkillsWithComboIndex]
	if(self.equipedAutoArrayDirty) then
		self.equipedAutoArrayDirty = false
		TableUtility.ArrayClear(array)
		TableUtility.TableClear(_removeDuplicates)
		
		local rawAutos = self:GetEquipedAutoSkillData()
		local skill,sortID,comboPrevious
		local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
		if(GameConfig.AutoSkillGroup) then
			for k,v in pairs(GameConfig.AutoSkillGroup) do
				local duplicateCount = 0
				if(#v>1) then
					for i=#v,1,-1 do
						skill = self:GetLearnedSkillBySortID(v[i])
						if skill and skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
							duplicateCount = duplicateCount + 1
							if(duplicateCount>1) then
								_removeDuplicates[skill:GetPosInShortCutGroup(shortCutAuto)] = 1
							end
						end
					end
				end
			end
		end
		for i=#rawAutos,1,-1 do
			skill = rawAutos[i]
			if _removeDuplicates[skill:GetPosInShortCutGroup(shortCutAuto)] == nil then
				-- helplog("准备递归",skill.id,skill.staticData.NameZh)
				self:_RecursiveGetComboPrevious(array,skill)
			end
		end
	end
	return array
end

function SkillProxy:_RecursiveGetComboPrevious( array,skill )
	if(skill~=nil) then
		comboPrevious = self.comboGetPrevious[skill.sortID]
		--kick out passive and fake dead
		if(skill.staticData.SkillType ~= GameConfig.SkillType.Passive.type and skill.staticData.SkillType ~= SkillType.FakeDead) then
			table.insert(array,1,skill)
		end
		if(comboPrevious ~= nil) then
			skill = self:GetLearnedSkillBySortID(comboPrevious)
			while (skill == nil and comboPrevious~=nil) do
				comboPrevious = self.comboGetPrevious[comboPrevious]
				skill = self:GetLearnedSkillBySortID(comboPrevious)
			end
			self:_RecursiveGetComboPrevious(array,skill)
		end
	end
end

function SkillProxy:GetTransformedSkill(id)
	local skills = self:GetTransformedSkills()
	if(skills~=nil and #skills>0) then
		for i=1,#skills do
			if(skills[i].id == id) then
				return skills[i]
			end
		end
	end
end

function SkillProxy:RefreshSkills()
	if(self.learnedSkills) then
		for k,skills in pairs(self.learnedSkills) do
			for i=1,#skills do
				SkillUtils.RefreshPlayerSkillData(skills[i].id)	
			end
		end
	end
end

function SkillProxy:LearnedExpressionBlink()
	return self:HasLearnedSkill(GameConfig.Expression_Blink.needskill)
end

function SkillProxy:Server_UpdateDynamicSkillInfos(serverData)
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
		local skill = self:GetLearnedSkillBySortID(dynamicServerData.id)
		if(skill) then
			if self:_CheckPosInShortCut(skill) then
				EventManager.Me():PassEvent(SkillEvent.SkillFitPreCondtion,skill)
			end
		end
	end
end

--skillidlevel
function SkillProxy:GetDynamicSkillInfoByID(skillID)
	local sortID = math.floor(skillID / 1000)
	return self.dynamicSkillInfos[sortID]
end

function SkillProxy:GetSkillCanBreak()
	if(MyselfProxy.Instance:HasJobBreak()) then
		return self:GetUsedPoints()>=GameConfig.Peak.SkillPointToBreak
	end
	return false
end

function SkillProxy:SetMultiSave(multiSaveId, multiSaveType)
	self.multiSaveId = multiSaveId
	self.multiSaveType = multiSaveType
end

function SkillProxy:IsMultiSave()
	return self.multiSaveId ~= nil
end

function SkillProxy:GetMyProfession()
	if self.multiSaveId ~= nil then
		local profession = SaveInfoProxy.Instance:GetProfession(self.multiSaveId, self.multiSaveType)
		if profession ~= nil then
			return profession
		end
	end
	return MyselfProxy.Instance:GetMyProfession()
end

function SkillProxy:GetBeingNpcInfo(beingid)
	if beingid == nil then
		return nil
	end

	if self.multiSaveId == nil then
		return PetProxy.Instance:GetMyBeingNpcInfo(beingid)
	else
		return SaveInfoProxy.Instance:GetBeingInfo(self.multiSaveId, beingid, self.multiSaveType)
	end
end