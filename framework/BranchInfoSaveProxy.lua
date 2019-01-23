autoImport("UserSaveInfoData")

BranchInfoSaveProxy = class('BranchInfoSaveProxy', pm.Proxy)
BranchInfoSaveProxy.Instance = nil
BranchInfoSaveProxy.NAME = "BranchInfoSaveProxy"

function BranchInfoSaveProxy:ctor(proxyName, data)
	self.proxyName = proxyName or BranchInfoSaveProxy.NAME
	if BranchInfoSaveProxy.Instance == nil then
		BranchInfoSaveProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self.recordDatas = {}
end

function BranchInfoSaveProxy:RecvUpdateBranchInfoUserCmd(data)
	for i = 1,#data.datas do
		local sdata =  data.datas[i]
		local single = UserSaveInfoData.new(sdata)
		self.recordDatas[sdata.id] = single
	end

end

function BranchInfoSaveProxy:GetProfession(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetProfession()
end

function BranchInfoSaveProxy:GetRoleID(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id].roleid
end

function BranchInfoSaveProxy:GetRoleName(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id].rolename
end

function BranchInfoSaveProxy:GetUnusedSkillPoint(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetUnusedSkillPoint()
end

function BranchInfoSaveProxy:GetProfessionSkill(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetProfessionSkill()
end

function BranchInfoSaveProxy:GetEquipedSkills(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetEquipedSkills()
end

function BranchInfoSaveProxy:GetEquipedAutoSkills(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetEquipedAutoSkills()
end

function BranchInfoSaveProxy:GetBeingSkill(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetBeingSkill()
end

function BranchInfoSaveProxy:GetBeingInfo(id, beingid)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetBeingInfo(beingid)
end

function BranchInfoSaveProxy:GetBeingsArray(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetBeingsArray()
end

function BranchInfoSaveProxy:GetUsedPoints(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetUsedPoints()
end

function BranchInfoSaveProxy:GetJobLevel(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetJobLevel()
end

function BranchInfoSaveProxy:GetProfessionType(id)
	if not self.recordDatas[id] then return nil end
	local profession = self.recordDatas[id]:GetProfession()
	profession = Table_Class[profession]
	return profession and profession.Type or 0
end

function BranchInfoSaveProxy:GetAstrobleByID(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetAstroble()
end

function BranchInfoSaveProxy:GetUserDataByID(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetUserData()

end

function BranchInfoSaveProxy:GetProps(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetProps()
end

function BranchInfoSaveProxy:GetUsersaveData(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]
end

function BranchInfoSaveProxy:GetActiveStars(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetActiveStars()
end

function BranchInfoSaveProxy:CheckAstrolMaterial(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:CheckAstrolMaterial()
end

function BranchInfoSaveProxy:GetContribute(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetContribute()
end

function BranchInfoSaveProxy:GetGoldMedal(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetGoldMedal()
end

function BranchInfoSaveProxy:GetSkillData(id)
	if not self.recordDatas[id] then return nil end
	return self.recordDatas[id]:GetSkillData()
end