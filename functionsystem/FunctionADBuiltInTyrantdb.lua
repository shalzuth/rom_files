FunctionADBuiltInTyrantdb = class('FunctionADBuiltInTyrantdb')

FunctionADBuiltInTyrantdb.instance = nil
function FunctionADBuiltInTyrantdb:Instance()
	if FunctionADBuiltInTyrantdb.instance == nil then
		FunctionADBuiltInTyrantdb.instance = FunctionADBuiltInTyrantdb.new()
	end
	return FunctionADBuiltInTyrantdb.instance
end

function FunctionADBuiltInTyrantdb:ChargeTo3rd(order_id, amounce)
	local currencyType = 'RMB'
	local payment = 'payment'
	FunctionTyrantdb.Instance:ChargeTo3rd(order_id, amounce, currencyType, payment)
end

function FunctionADBuiltInTyrantdb:OnCreateRole()
	local roleName = 'roleNameForOnCreateRole'
	local roleID = Game.Myself and (Game.Myself.data and Game.Myself.data.id or nil) or nil
	if roleID then
		local roleInfo = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
		if roleInfo ~= nil then
			roleName = roleInfo.name
		end
	end
	--FunctionTyrantdb.Instance:OnCreateRole(roleName)
end