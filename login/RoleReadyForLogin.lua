autoImport('CSharpObjectForLogin')

RoleReadyForLogin = class("RoleReadyForLogin")

local luaVector3 = LuaVector3.zero

local m_mountTransform = {}
m_mountTransform.position = {x = 1.6, y = -1.8, z = -3}
m_mountTransform.eulerAngles = {x = 0, y = 148.8, z = 0}
local m_roleTransform = {}
m_roleTransform.position = {x = 0.735, y = -1.67, z = -4.3}
m_roleTransform.eulerAngles = {x = 0, y = -180, z = 0}
local m_falconTransform = {}
m_falconTransform.position = {x = 1.75, y = 0.6, z = -1.78}
m_falconTransform.eulerAngles = {x = 0, y = -163.3, z = 0}

RoleReadyForLogin.ins = nil
function RoleReadyForLogin.Ins()
	if RoleReadyForLogin.ins == nil then
		RoleReadyForLogin.ins = RoleReadyForLogin.new()
	end
	return RoleReadyForLogin.ins
end

function RoleReadyForLogin:ctor()
	self:Construct()
end

function RoleReadyForLogin:Construct()
	self.allModelsController = {}
	self.currentRoleID = 0
	self.currentModelsController = nil
end

function RoleReadyForLogin:Deconstruct()
	self:Release()
end

function RoleReadyForLogin:Iam(roleID)
	self:Hide()

	if self.allModelsController == nil then
		self.allModelsController = {}
	end

	if not table.ContainsKey(self.allModelsController, roleID) then
		local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
		if roleDetail ~= nil then
			local modelsController = {}
			-- role model
			local parts = Asset_Role.CreatePartArray()
			parts[1] = roleDetail.body
			parts[2] = roleDetail.hair
			parts[3] = roleDetail.lefthand
			parts[4] = roleDetail.righthand
			parts[5] = roleDetail.head
			parts[6] = roleDetail.back
			parts[7] = roleDetail.face
			parts[8] = roleDetail.tail
			parts[9] = roleDetail.eye
			parts[10] = roleDetail.mouth
			local gender = RoleConfig.Gender.None
			if roleDetail.gender == ProtoCommon_pb.EGENDER_FEMALE then
				gender = RoleConfig.Gender.Female
			elseif roleDetail.gender == ProtoCommon_pb.EGENDER_MALE then
				gender = RoleConfig.Gender.Male
			end
			parts[12] = gender
			parts[13] = roleDetail.haircolor
			parts[14] = roleDetail.eyecolor
			parts[16] = roleDetail.clothcolor
			local assetRole = Asset_Role.Create(parts)

			assetRole:SetGUID(roleID)
			assetRole:SetName(roleDetail.name)
			assetRole:SetShadowEnable( false )
			assetRole:SetColliderEnable( false )
			assetRole:SetWeaponDisplay( true )
			assetRole:SetRenderEnable( true )
			assetRole:SetActionSpeed(1)
			assetRole:SetInvisible(false)
			local color = LuaColor.New(0x32 / 255.0, 0x32 / 255.0, 0x32 / 255.0, 0xA / 255.0)
			assetRole:ChangeColorTo(color, 0)
			color:Destroy()
			assetRole:PlayAction_Idle()
			Asset_Role.DestroyPartArray(parts)

			luaVector3:Set(m_roleTransform.position.x, m_roleTransform.position.y, m_roleTransform.position.z)
			assetRole:SetPosition(luaVector3)
			luaVector3:Set(m_roleTransform.eulerAngles.x, m_roleTransform.eulerAngles.y, m_roleTransform.eulerAngles.z)
			assetRole:SetEulerAngles(luaVector3)
			modelsController.role = assetRole

			-- mount model
			if roleDetail.mount > 0 then
				local assetMount = Asset_RolePart.Create(Asset_Role.PartIndex.Mount, roleDetail.mount)
				luaVector3:Set(m_mountTransform.position.x, m_mountTransform.position.y, m_mountTransform.position.z)
				assetMount:ResetLocalPosition(luaVector3)
				luaVector3:Set(m_mountTransform.eulerAngles.x, m_mountTransform.eulerAngles.y, m_mountTransform.eulerAngles.z)
				assetMount:ResetLocalEulerAngles(luaVector3)
				modelsController.mount = assetMount
			end

			-- falcon
			if roleDetail.partnerid > 0 then
				local falconConf = Table_Npc[roleDetail.partnerid]
				if falconConf then
					local falconParts = Asset_Role.CreatePartArray()
					falconParts[1] = falconConf.Body
					local assetFalcon = Asset_Role.Create(falconParts)
					assetFalcon:SetGUID(roleDetail.partnerid)
					assetFalcon:SetName(falconConf.NameZh)
					assetFalcon:SetShadowEnable( false )
					assetFalcon:SetColliderEnable( false )
					assetFalcon:SetWeaponDisplay( false )
					assetFalcon:SetRenderEnable( true )
					assetFalcon:SetActionSpeed(1)
					assetFalcon:SetInvisible(false)
					assetFalcon:PlayAction_Idle()

					local scale = 1;
					if(Table_Npc[roleDetail.partnerid])then
						scale = Table_Npc[roleDetail.partnerid].Scale or 1;
					end
					assetFalcon:SetScale(scale)

					Asset_Role.DestroyPartArray(parts)
					local npcFollowConfigure = Table_NPCFollow[roleDetail.partnerid]
					if npcFollowConfigure ~= nil then
						luaVector3:Set(npcFollowConfigure.ChooseUILocation[1], npcFollowConfigure.ChooseUILocation[2], npcFollowConfigure.ChooseUILocation[3])
						assetFalcon:SetPosition(luaVector3)
						luaVector3:Set(npcFollowConfigure.ChooseUIRotating[1], npcFollowConfigure.ChooseUIRotating[2], npcFollowConfigure.ChooseUIRotating[3])
						assetFalcon:SetEulerAngles(luaVector3)
					end
					modelsController.falcon = assetFalcon
				end
			end

			self.allModelsController[roleID] = modelsController

			self.currentRoleID = roleID
			self.currentModelsController = modelsController
		end
	else
		local modelsController = self.allModelsController[roleID]
		local role = modelsController.role
		local mount = modelsController.mount
		local falcon = modelsController.falcon

		role:SetInvisible(false)
		luaVector3:Set(m_roleTransform.position.x, m_roleTransform.position.y, m_roleTransform.position.z)
		role:SetPosition(luaVector3)
		luaVector3:Set(m_roleTransform.eulerAngles.x, m_roleTransform.eulerAngles.y, m_roleTransform.eulerAngles.z)
		role:SetEulerAngles(luaVector3)

		if mount then
			self:ShowMount(mount)
			luaVector3:Set(m_mountTransform.position.x, m_mountTransform.position.y, m_mountTransform.position.z)
			mount:ResetLocalPosition(luaVector3)
			luaVector3:Set(m_mountTransform.eulerAngles.x, m_mountTransform.eulerAngles.y, m_mountTransform.eulerAngles.z)
			mount:ResetLocalEulerAngles(luaVector3)
		end

		if falcon then
			falcon:SetInvisible(false)
			-- luaVector3:Set(m_falconTransform.position.x, m_falconTransform.position.y, m_falconTransform.position.z)
			-- falcon:SetPosition(luaVector3)
			-- luaVector3:Set(m_falconTransform.eulerAngles.x, m_falconTransform.eulerAngles.y, m_falconTransform.eulerAngles.z)
			-- falcon:SetEulerAngles(luaVector3)
		end

		self.currentRoleID = roleID
		self.currentModelsController = modelsController
	end
end

function RoleReadyForLogin:Show()
	if self.currentModelsController ~= nil then
		local role = self.currentModelsController.role
		role:SetInvisible(false)
		local mount = self.currentModelsController.mount
		if mount then
			self:ShowMount(mount)
		end
		local falcon = self.currentModelsController.falcon
		if falcon then
			falcon:SetInvisible(false)
		end
	end
end

function RoleReadyForLogin:Hide()
	if self.currentModelsController ~= nil then
		local role = self.currentModelsController.role
		role:SetInvisible(true)
		local mount = self.currentModelsController.mount
		if mount then
			self:HideMount(mount)
		end
		local falcon = self.currentModelsController.falcon
		if falcon then
			falcon:SetInvisible(true)
		end
	end
end

function RoleReadyForLogin:ShowMount(assetMount)
	if assetMount ~= nil then
		luaVector3:Set(m_mountTransform.position.x, m_mountTransform.position.y, m_mountTransform.position.z)
		assetMount:ResetLocalPosition(luaVector3)
	end
end

function RoleReadyForLogin:HideMount(assetMount)
	if assetMount ~= nil then
		luaVector3:Set(m_mountTransform.position.x, m_mountTransform.position.y + 10000, m_mountTransform.position.z)
		assetMount:ResetLocalPosition(luaVector3)
	end
end

function RoleReadyForLogin:RotateDelta(deltaEulerAngle)
	if self.currentModelsController ~= nil then
		local role = self.currentModelsController.role
		role:RotateDelta(deltaEulerAngle)
	end
end

function RoleReadyForLogin:Release()
	self.currentModelsController = nil
	if self.allModelsController ~= nil then
		for k, v in pairs(self.allModelsController) do
			local modelsController = v
			modelsController.role:Destroy()
			if modelsController.mount ~= nil then
				modelsController.mount:Destroy()
			end
			if modelsController.falcon ~= nil then
				modelsController.falcon:Destroy()
			end
		end
		self.allModelsController = nil
	end
end

function RoleReadyForLogin:Reset()
	self:Release()
end