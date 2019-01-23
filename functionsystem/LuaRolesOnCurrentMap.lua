LuaRolesOnCurrentMap = class('LuaRolesOnCurrentMap')

LuaRolesOnCurrentMap.ins = nil
function LuaRolesOnCurrentMap:Ins()
	if LuaRolesOnCurrentMap.ins == nil then
		LuaRolesOnCurrentMap.ins = LuaRolesOnCurrentMap.new()
	end
	return LuaRolesOnCurrentMap.ins
end

function LuaRolesOnCurrentMap:CreateRole()
	return {
		pos = LuaVector3.zero
	}
end

function LuaRolesOnCurrentMap:Exist(role_id)
	if self.roles ~= nil then
		return table.ContainsKey(self.roles, role_id)
	end
	return false
end

function LuaRolesOnCurrentMap:SetPos(role_id, pos)
	if self:Exist(role_id) then
		self.roles[role_id].pos = pos
	else
		if self.roles == nil then
			self.roles = {}
		end
		local role = self:CreateRole()
		role.pos = pos
		self.roles[role_id] = role
	end
end

function LuaRolesOnCurrentMap:GetPosOfRole(role_id)
	if self:Exist(role_id) then
		return self.roles[role_id].pos
	end
end

function LuaRolesOnCurrentMap:Reset()
	self.roles = nil
end