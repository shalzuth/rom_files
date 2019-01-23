autoImport("SkillBeingData")

CreatureSkillProxy = class('CreatureSkillProxy', pm.Proxy)
CreatureSkillProxy.Instance = nil;
CreatureSkillProxy.NAME = "CreatureSkillProxy"

CreatureSkillProxy.BeingEnableEvent = "CreatureSkillProxy.BeingEnableEvent"

function CreatureSkillProxy:ctor(proxyName, data)
	self.proxyName = proxyName or CreatureSkillProxy.NAME
	if(CreatureSkillProxy.Instance == nil) then
		CreatureSkillProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function CreatureSkillProxy:Init()
	self._creatureSkills = {}
	self:_InitBeings()
end

function CreatureSkillProxy:GetSelectSkillBeingData()
	return self.selectedSkillBeingData
end

function CreatureSkillProxy:SetEnableBeings(beingIDs,val)
	if(beingIDs) then
		for i=1,#beingIDs do
			local being = self:GetSkillBeingData(beingIDs[i])
			if(being) then
				being.isEnabled = val
			end
		end
		GameFacade.Instance:sendNotification(CreatureSkillProxy.BeingEnableEvent)
	end
end

function CreatureSkillProxy:SetSelectSkillBeingData(skillBeingData)
	if(self.selectedSkillBeingData~=skillBeingData) then
		if(self.selectedSkillBeingData~=nil) then
			self.selectedSkillBeingData.isSelect = false
		end
		self.selectedSkillBeingData = skillBeingData
		self.selectedSkillBeingData.isSelect = true
	end
end

function CreatureSkillProxy:_InitBeings()
	local skill,config
	if(Table_Being) then
		for k,v in pairs(Table_Being) do
			skill = SkillBeingData.new(k,v,0,0)
			self._creatureSkills[k] = skill

			for i=1,50 do
				config = v["Skill_"..i]
				if(config==nil) then
					break
				end
				-- skill:AutoFillAdd(config[1])
				skill:SetSkillRequiredLevel(config[1],config[2])
			end
			--test
			-- skill:ResetSimulateDatas()
			--test
			skill:SetAllActive(true)
			skill:InitPaths()
		end
	end
end

function CreatureSkillProxy:GetBeingsArray()
	local arrays = {}
	local hasSelect = false
	for k,v in pairs(self._creatureSkills) do
		arrays[#arrays+1] = v
		if(v.isSelect) then
			hasSelect = true
		end
	end

	table.sort(arrays ,function ( l,r )
			return l.profession < r.profession
		end)
	if(hasSelect==false and #arrays>0) then
		self:SetSelectSkillBeingData(arrays[1])
	end
	return arrays
end

function CreatureSkillProxy:GetSkillBeingData(creatureID)
	return self._creatureSkills[creatureID]
end

function CreatureSkillProxy:GetCreatureSkills( creatureID )
	local creatureSkill = self._creatureSkills[creatureID]
	if(creatureSkill) then
		return creatureSkill.skills
	end
	return nil
end

function CreatureSkillProxy:GetCreatureLearnedSkills( creatureID )
	local creatureSkill = self._creatureSkills[creatureID]
	if(creatureSkill) then
		return creatureSkill:GetLearnedSkills()
	end
	return nil
end

function CreatureSkillProxy:RecieveServerDatas(datas)
	local data,skillBeingData
	for i=1,#datas do
		data = datas[i]
		skillBeingData = self:GetSkillBeingData(data.id)
		if skillBeingData ~= nil then
			skillBeingData:ClearSkills()
		end
	end

	self:RecieveServerUpdateDatas(datas)
end

function CreatureSkillProxy:RecieveServerUpdateDatas(datas)
	local data,skillBeingData,skill
	for i=1,#datas do
		data = datas[i]
		skillBeingData = self:GetSkillBeingData(data.id)
		-- helplog("RecieveServerDelDatas",data.id)
		if(skillBeingData == nil) then
			skillBeingData = SkillBeingData.new(data.id,Table_Being[data.id],0,0)
			self._creatureSkills[data.id] = skillBeingData
		end
		skillBeingData:UpdatePoints(data.usedpoint)
		skillBeingData:SetLeftPoint(data.leftpoint)
		skillBeingData:Server_UpdateDynamicSkillInfos(data)
		for j=1,#data.items do
			skill = data.items[j]
			skillBeingData:UpdateSkill(skill)
		end
		skillBeingData:ResetSimulateDatas()
	end
end

function CreatureSkillProxy:RecieveServerDelDatas(dels)
	local data,skillBeingData,serverSkill,skill
	for i=1,#dels do
		data = dels[i]
		skillBeingData = self:GetSkillBeingData(data.id)
		-- helplog("RecieveServerDelDatas",data.id)
		if(skillBeingData ~= nil) then
			for j=1,#data.items do
				serverSkill = data.items[j]
				-- helplog("remove",serverSkill.id)
				skill = skillBeingData:RemoveSkill(serverSkill)
				if(skill) then
					skillBeingData:RemoveLearnedSkill(skill)
					skillBeingData:RemoveEquipedSkill(skill)
				end
			end
		end
	end
end

--skillidlevel
function CreatureSkillProxy:GetDynamicSkillInfoByID(beingID,skillID)
	local being = self:GetSkillBeingData(beingID)
	if(being) then
		return being:GetDynamicSkillInfoByID(skillID)
	end
end