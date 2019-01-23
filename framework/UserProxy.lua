local UserProxy = class('UserProxy', pm.Proxy)

UserProxy.Instance = nil;

UserProxy.NAME = "UserProxy"

autoImport("Table_RoleData")

function UserProxy:ctor(proxyName, data)
	self.proxyName = proxyName or UserProxy.NAME
	if(UserProxy.Instance == nil) then
		UserProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:ParsePropVOs()
end

function UserProxy:onRegister()
end

function UserProxy:onRemove()
end

function UserProxy:ParsePropVOs()
	self.creatureProps = {}
	for _, o in pairs(Table_RoleData) do
		local prop = PropVO.Create(_,1,o.VarName,o.PropName,(o.IsPercent == 1),0,PropValueType.Float,o.Default,o.IsClientPercent == 1,o.SyncFloat == 1)
		self.creatureProps[_] = prop
		self.creatureProps[o.VarName] = prop
	end
	RolePropsContainer.config = self.creatureProps
end

function UserProxy:GetPropVO(key)
	if(key)then
		return self.creatureProps[key];
	end
end

function UserProxy:ChangeDress(data)
	-- local role = nil
	-- if(data.charid == MyselfProxy.Instance.myself.id) then
	-- 	role = MyselfProxy.Instance.myself
	-- else
	-- 	role = SceneUserProxy.Instance:Find(data.charid)
	-- end
	
	-- if(role~= nil) then
	-- 	role:TempSetAvatar(data.male,data.body,data.hair,data.rightHand,data.accessory,data.wing)
	-- 	RoleUtil.RoleDress(role.roleInfo.avatar, role.roleAgent)
	-- end
end

function UserProxy:UpdateRoleData(data)
	local role = SceneCreatureProxy.FindCreature(data.guid)
	if(role~= nil) then
		role:Server_SetAttrs(data.attrs)
		role:Server_SetUserDatas(data.datas,false)
	end
end

function UserProxy:RoleChangeObj(data)
	local role = SceneCreatureProxy.FindCreature(data.guid)
	if role~= nil then
		role:Server_SetAttrs(data.attrs)
		MyselfProxy.Instance:setExtraProps(data.pointattrs)
		role:Server_SetUserDatas(data.datas,false)
	end
end

function UserProxy:ChangeSave(data)
	local scenePlayer = NSceneUserProxy.Instance:Find(data.guid)
	local effect = EffectMap.Maps.Change_Job
	if scenePlayer then
		redlog(Find)
		scenePlayer.assetRole:PlayEffectOneShotOn(effect, RoleDefines_EP.Bottom)
	end
end

return UserProxy