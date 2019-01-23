autoImport("AstrolabeSaveData")
autoImport("EquipsSaveData")
autoImport("RoleAttrSaveData")
autoImport("SkillSaveData")
autoImport("Occupation")

UserSaveInfoData = class("UserSaveInfoData")

function UserSaveInfoData:ctor(data)
	self.id = data.id
	self.profession = data.profession
	self.jobLv = data.joblv
	self.jobexp = data.jobexp
	self.recordname = data.recordname
	self.recordtime = data.recordtime
	self.roleid = data.charid
	self.rolename = data.charname
	
	self.attrs = RoleAttrSaveData.new(data.attr_data)
	self.equips_map = {}
	if data.equip_data then
		local n = #data.equip_data		
		for i=1,n do
			local single = EquipsSaveData.new(data.equip_data[i], self.id)
			self.equips_map[single.pacakgeType] = single;
		end
		
	end
	self.astrolabes = AstrolabeSaveData.new(data.astrolabe_data)
	self.skills = SkillSaveData.new(data.skill_data)
end

function UserSaveInfoData:UpdateRecordTime(newTime)
	self.recordtime = newTime
end

function UserSaveInfoData:UpdateName(newName)
	self.recordname = newName
end

function UserSaveInfoData:GetUserData()
	return self.attrs:GetUserData()
end

function UserSaveInfoData:GetProfession()
	return self.profession
end

function UserSaveInfoData:GetJobLevel()
	return self.jobLv
end

function UserSaveInfoData:GetFixedJobLevel()
	return Occupation.GetFixedJobLevel(self.jobLv,self.profession)
end

function UserSaveInfoData:GetUnusedSkillPoint()
	return self.skills:GetUnusedSkillPoint()
end

function UserSaveInfoData:GetProfessionSkill()
	return self.skills:GetProfessionSkill()
end

function UserSaveInfoData:GetBeingSkill()
	return self.skills:GetBeingSkill()
end

function UserSaveInfoData:GetEquipedSkills()
	return self.skills:GetEquipedSkills()
end

function UserSaveInfoData:GetEquipedAutoSkills()
	return self.skills:GetEquipedAutoSkills()
end

function UserSaveInfoData:GetSkillData()
	return self.skills
end

function UserSaveInfoData:GetBeingInfo(beingid)
	return self.skills:GetBeingInfo(beingid)
end

function UserSaveInfoData:GetBeingsArray()
	return self.skills:GetBeingsArray()
end

function UserSaveInfoData:GetUsedPoints()
	return self.skills:GetUsedPoints()
end

function UserSaveInfoData:GetAstroble()
	return self.astrolabes
end

function UserSaveInfoData:GetActiveStars(id)
	return self.astrolabes:GetActiveStars()
end

function UserSaveInfoData:GetRoleEquipsSaveDatas()
	local roleEquip = self.equips_map[BagProxy.BagType.RoleEquip];
	if(roleEquip == nil)then
		return;
	end
	return roleEquip:GetEquipInfos();
end

function UserSaveInfoData:GetRoleName()
	return self.rolename or "";
end

function UserSaveInfoData:GetProps()
	return self.attrs:GetUserAttr()
end

function UserSaveInfoData:CheckAstrolMaterial(costMap)
	local myRoleID = Game.Myself and (Game.Myself.data and Game.Myself.data.id or 0)	
	local myCost = AstrolabeProxy.Instance:GetStorageActivePointsCost_ByPlate()
	local recordCost = AstrolabeProxy.Instance:GetStorageActivePointsCost(self.id)
	if myRoleID == self.roleid then
		local userdata = Game.Myself and Game.Myself.data.userdata
		local num = userdata:Get(UDEnum.CONTRIBUTE) or 0
		for k,v in pairs(recordCost) do
			local haveNum = myCost[k] or 0;				
			if k == 140 then
				if num + haveNum < v then
					return false
				end
			else
				local n = BagProxy.Instance:GetItemNumByStaticID(k,BagProxy.BagType.MainBag)
				if n + haveNum < v then
					return false
				end
			end
		end
		return true
	else
		if costMap[self.roleid] then
			local contri = costMap[self.roleid]:GetContribute()
			local goldMedal = costMap[self.roleid]:GetGoldMedal()
			for k,v in pairs(recordCost) do
				redlog("recordCost kv",k,v)
				if k == 140 then				
					if contri < v then
						return false
					end
				else
					if k == 5261 and goldMedal < v then
						return false
					end
				end
			end
			return true
		end		
		return false
	end

	
end

function UserSaveInfoData:GetContribute()
	local recordCost = AstrolabeProxy.Instance:GetStorageActivePointsCost(self.id)
	if recordCost[140] then
		return recordCost[140]
	end
end

function UserSaveInfoData:GetGoldMedal()
	local recordCost = AstrolabeProxy.Instance:GetStorageActivePointsCost(self.id)
	if recordCost[5261] then
		return recordCost[5261]
	end
end