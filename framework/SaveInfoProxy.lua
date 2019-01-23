SaveInfoProxy = class('SaveInfoProxy', pm.Proxy)
SaveInfoProxy.Instance = nil
SaveInfoProxy.NAME = "SaveInfoProxy"


SaveInfoEnum = {	
	Branch = SceneUser2_pb.ETypeBranch, -- 分支数据
    Record = SceneUser2_pb.ETypeRecord, -- 存档数据
}
function SaveInfoProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SaveInfoProxy.NAME
	if SaveInfoProxy.Instance == nil then
		SaveInfoProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
end

local _BranchInfoSaveProxy = BranchInfoSaveProxy
local _MultiProfessionSaveProxy = MultiProfessionSaveProxy

function SaveInfoProxy:GetProfession(id,type)
	if type == SaveInfoEnum.Branch then
		--TODO: duo zhi ye lin shi jie jue
		local pId = _BranchInfoSaveProxy.Instance:GetProfession(id)
		local pIdClass = Table_Class[pId]
		if pId%10 == 1 and pIdClass.TypeBranch ~=id then
			for k,v in pairs(Table_Class) do
				if v.TypeBranch == id and v.IsOpen then
					return v.id
				end
			end
		end	
		return _BranchInfoSaveProxy.Instance:GetProfession(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetProfession(id)
	end
end

function SaveInfoProxy:GetRoleID(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetRoleID(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetRoleID(id)
	end
end

function SaveInfoProxy:GetRoleName(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetRoleName(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetRoleName(id)
	end
end

function SaveInfoProxy:GetUnusedSkillPoint(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetUnusedSkillPoint(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetUnusedSkillPoint(id)
	end
end

function SaveInfoProxy:GetProfessionSkill(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetProfessionSkill(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetProfessionSkill(id)
	end
end

function SaveInfoProxy:GetEquipedSkills(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetEquipedSkills(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetEquipedSkills(id)
	end
end

function SaveInfoProxy:GetEquipedAutoSkills(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetEquipedAutoSkills(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetEquipedAutoSkills(id)
	end
end

function SaveInfoProxy:GetBeingSkill(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetBeingSkill(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetBeingSkill(id)
	end
end

function SaveInfoProxy:GetBeingInfo(id, beingid,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetBeingInfo(id, beingid)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetBeingInfo(id, beingid)
	end
end

function SaveInfoProxy:GetBeingsArray(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetBeingsArray(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetBeingsArray(id)
	end
end

function SaveInfoProxy:GetUsedPoints(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetUsedPoints(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetUsedPoints(id)
	end
end

function SaveInfoProxy:GetJobLevel(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetJobLevel(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetJobLevel(id)
	end
end

function SaveInfoProxy:GetProfessionType(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetProfessionType(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetProfessionType(id)
	end
end

function SaveInfoProxy:GetAstrobleByID(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetAstrobleByID(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetAstrobleByID(id)
	end
end

function SaveInfoProxy:GetUserDataByID(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetUserDataByID(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetUserDataByID(id)
	end
end

function SaveInfoProxy:GetProps(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetProps(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetProps(id)
	end
end

function SaveInfoProxy:GetUsersaveData(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetUsersaveData(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetUsersaveData(id)
	end
end

function SaveInfoProxy:GetSkillData(id,type)
	if type == SaveInfoEnum.Branch then
		return _BranchInfoSaveProxy.Instance:GetSkillData(id)
	elseif type == SaveInfoEnum.Record then
		return _MultiProfessionSaveProxy.Instance:GetSkillData(id)
	end
end