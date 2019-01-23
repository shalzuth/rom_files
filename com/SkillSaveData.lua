autoImport("SkillProfessData")
autoImport("SkillBeingData")
autoImport("BeingInfoData")
autoImport("ShortCutData")

SkillSaveData = class("SkillSaveData")

function SkillSaveData:ctor(serverSkillData)
	self.professionSkillList = {}
	self.beingSkillList = {}
	self.equipedSkills = {}
	self.equipedAutoSkills = {}

	self.beinginfo = {}

	self.left_point = serverSkillData.left_point

	self.skillShortCut = ShortCutData.new()

	local length = 0

	if serverSkillData.beings then		
		length = #serverSkillData.beings
		local data,skillBeingData,skill
		for i=1,length do
			data = serverSkillData.beings[i]
			skillBeingData = SkillBeingData.new(data.id,Table_Being[data.id],0,0)
			self.beingSkillList[data.id] = skillBeingData
			
			skillBeingData:UpdatePoints(data.usedpoint)
			skillBeingData:SetLeftPoint(data.leftpoint)
			skillBeingData:Server_UpdateDynamicSkillInfos(data)
			for j=1,#data.items do
				skill = data.items[j]
				skillBeingData:UpdateSkill(skill)
			end
			skillBeingData:ResetSimulateDatas()
		end
		self:GetBeingsArray()
	end

	if serverSkillData.datas then
		length = #serverSkillData.datas
		for i=1,length do
			self:AddProfessSkill(self:CreateProfessSkill(serverSkillData.datas[i]))
		end

	end

	if serverSkillData.curbeingid then
		self.curBeingID = serverSkillData.curbeingid
	end

	if serverSkillData.beinginfos then
		length = #serverSkillData.beinginfos
		local temp,beingInfo
		for i=1,length do
			temp = serverSkillData.beinginfos[i]
			beingInfo = BeingInfoData.new();
			self.beinginfo[temp.beingid] = beingInfo
			beingInfo:Server_SetData(temp)
		end
	end
	if serverSkillData.shortcut then
		self.skillShortCut:ResetSkillShortCuts()
		local shortcuts = serverSkillData.shortcut.shortcuts
		for i=1,#shortcuts do
			local shortcut = shortcuts[i]
			self.skillShortCut:UnLockSkillShortCuts(shortcut)
		end
	end
end


function SkillSaveData:GetProfessionSkill()
	return self.professionSkillList
end

function SkillSaveData:GetBeingSkill()
	return self.beingSkillList
end

function SkillSaveData:GetBeingInfo(beingid)
	return self.beinginfo[beingid]
end

function SkillSaveData:GetUnusedSkillPoint()
	return self.left_point
end

function SkillSaveData:GetCurrentBeing()
	return self.curBeingID
end

function SkillSaveData:GetEquipedSkills()
	return self.equipedSkills
end

function SkillSaveData:GetEquipedAutoSkills()
	return self.equipedAutoSkills
end

function SkillSaveData:CreateProfessSkill(serverSkillData)
	local data
	local skill
	local professSkill = SkillProfessData.new(serverSkillData.profession,serverSkillData.usedpoint)
	local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
	for j=1,#serverSkillData.items do
		data = serverSkillData.items[j]
		skill = professSkill:UpdateSkill(data)
		if self:_CheckPosInShortCut(skill) then
			table.insert(self.equipedSkills,skill)
		end
		if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
			table.insert(self.equipedAutoSkills,skill)
		end
		if skill.learned then
			self:LearnedSkill(skill)
		end
	end
	professSkill:SortSkills()
	return professSkill
end

function SkillSaveData:_CheckPosInShortCut(skill)
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

function SkillSaveData:AddProfessSkill(professSkill)
	self.professionSkillList[#self.professionSkillList + 1] = professSkill
	table.sort(self.professionSkillList,function (l,r)
		return l.profession < r.profession
	end)
end

function SkillSaveData:GetBeingsArray()
	local arrays = {}
	local hasSelect = false
	for k,v in pairs(self.beingSkillList) do
		arrays[#arrays+1] = v
		if(v.isSelect) then
			hasSelect = true
		end
	end

	table.sort(arrays ,function ( l,r )
			return l.profession < r.profession
		end)
	if(hasSelect==false and #arrays>0) then
		arrays[1]:SetSelect(true)
	end
	return arrays
end

function SkillSaveData:LearnedSkill(skillItemData)
	local beings = self:GetSummonBeings(skillItemData.staticData)
	if(beings and #beings>0) then
		self:SetEnableBeings(beings,true)
	end
end

function SkillSaveData:GetSummonBeings(staticData)
	local Logic_Param = staticData.Logic_Param
	if(Logic_Param) then
		return Logic_Param.being_ids
	end
end

function SkillSaveData:SetEnableBeings(beingIDs,val)
	if(beingIDs) then
		for i=1,#beingIDs do
			local being = self:GetSkillBeingData(beingIDs[i])
			if(being) then
				being.isEnabled = val
			end
		end
	end
end

function SkillSaveData:GetSkillBeingData(creatureID)
	return self.beingSkillList[creatureID]
end

function SkillSaveData:GetUsedPoints()
		self.totalUsedPoint = 0
		for i=1,#self.professionSkillList do
			if(self.professionSkillList[i].points) then
				self.totalUsedPoint = self.totalUsedPoint + self.professionSkillList[i].points
			end
		end
	return self.totalUsedPoint
end

--手动技能快捷栏数据,autoFill是否补全空栏上的数据,id技能快捷栏id
function SkillSaveData:GetCurrentEquipedSkillData( autoFill ,shortCutID)
	if(shortCutID==nil) then
		shortCutID = ShortCutProxy.ShortCutEnum.ID1
	end
	if(autoFill) then
		local equipedSkillData = {}

		for i=1,ShortCutData.CONFIGSKILLNUM do
			local item = SkillItemData.new(0,i,nil,nil,nil,i)
			equipedSkillData[i] = item
		end

		local pos
		for k,v in pairs(self.equipedSkills) do
			if(autoFill)then
				pos = v:GetPosInShortCutGroup(shortCutID)
				if(pos~=nil and pos ~=0) then
					equipedSkillData[pos] = v
				end
			elseif(not v.shadow) then
				table.insert(equipedSkillData,v)
			end
		end
		return equipedSkillData
	end
end

function SkillSaveData:ShortCutListIsEnable(id)
	return self.skillShortCut:ShortCutListIsEnable(id)
end

function SkillSaveData:SkillIsLocked(index,id)
	return self.skillShortCut:SkillIsLocked(index,id)
end

function SkillSaveData:AutoSkillIsLocked(index)
	return self.skillShortCut:AutoSkillIsLocked(index)
end