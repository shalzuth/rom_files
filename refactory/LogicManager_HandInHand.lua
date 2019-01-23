
LogicManager_HandInHand = class("LogicManager_HandInHand")

local HandInCP = RoleDefines_CP.LeftHand
local InHandCP = RoleDefines_CP.RightHand

local CameraFocusTransformDuration = 0.5

local FindCreature = SceneCreatureProxy.FindCreature

local tempVector3 = LuaVector3.zero
local tempVector3_1 = LuaVector3.zero
local tempVector3_2 = LuaVector3.zero
local tempVector3_3 = LuaVector3.zero

function LogicManager_HandInHand:ctor()
	self.doubleaction_targets = {};
	self.followers = {}

	-- 1:angleY excute
	self.cacheAngle_daction = {};
end

function LogicManager_HandInHand:RegisterHandInHand(masterCreature, followerCreature)
	self.followers[masterCreature.data.id] = followerCreature.data.id
	
	local followerAssetRole = followerCreature.assetRole
	if nil ~= CameraController.singletonInstance then
		CameraController.singletonInstance:SetPuppetFocus(
			followerAssetRole.completeTransform, 
			masterCreature.assetRole.completeTransform, 
			CameraFocusTransformDuration)
	end

	followerAssetRole:SetForceInvisible(nil)
	followerAssetRole:SetForceColliderEnable(nil)

	followerCreature.logicTransform:SetRotateSpeedScale(0.2)

	LogUtility.InfoFormat("<color=yellow>RegisterHandInHand: </color>{0}, {1}, followerGUID={2}", 
		masterCreature.data and masterCreature.data:GetName() or "No Name",
		followerCreature.data and followerCreature.data:GetName() or "No Name",
		followerCreature.data and followerCreature.data.id or "No GUID")
end

function LogicManager_HandInHand:UnregisterHandInHand(masterCreature, followerCreature)
	if nil ~= masterCreature and nil ~= masterCreature.data then
		self.followers[masterCreature.data.id] = nil
	end

	local followerAssetRole = followerCreature.assetRole
	if nil ~= CameraController.singletonInstance then
		CameraController.singletonInstance:SetPuppetFocus(
			followerAssetRole.completeTransform, 
			nil, 
			CameraFocusTransformDuration)
	end

	followerAssetRole:SetForceInvisible(nil)
	followerAssetRole:SetForceColliderEnable(nil)
	
	followerCreature.logicTransform:ScaleToXYZ(followerCreature:GetScaleWithFixHW())
	followerCreature.logicTransform:SetRotateSpeedScale(1)

	LogUtility.InfoFormat("<color=yellow>UnregisterHandInHand: </color>{0}, {1}, followerGUID={2}", 
		masterCreature and masterCreature.data and masterCreature.data:GetName() or "No Name",
		followerCreature.data and followerCreature.data:GetName() or "No Name",
		followerCreature.data and followerCreature.data.id or "No GUID")

end

function LogicManager_HandInHand:_UpdateHandInHand(time, deltaTime, masterCreature, followerCreature)
	if nil == followerCreature or nil ~= followerCreature.ai.parent then
		return false
	end

	local masterAssetRole = masterCreature.assetRole
	local followerAssetRole = followerCreature.assetRole

	local handInCPTransform = masterAssetRole:GetCP(HandInCP)
	if nil == handInCPTransform then
		return false
	end

	local inHandCPTransform = followerAssetRole:GetCP(InHandCP)
	if nil == inHandCPTransform then
		return false
	end

	local followerTransform = followerAssetRole.completeTransform

	tempVector3:Set(LuaGameObject.GetPosition(handInCPTransform))
	tempVector3_1:Set(LuaGameObject.GetPosition(inHandCPTransform))
	tempVector3_2:Set(LuaGameObject.GetPosition(followerTransform))

	LuaVector3.Better_Sub(tempVector3, tempVector3_1, tempVector3_3)
	tempVector3_2:Add(tempVector3_3)

	followerCreature.logicTransform:PlaceTo(tempVector3_2)

	followerCreature.logicTransform:SetTargetAngleY(masterCreature:GetAngleY())
	
	local masterScale = masterCreature:GetScaleVector()
	tempVector3_3:Set(masterScale[1],masterScale[2],masterScale[3])
	tempVector3_3:Mul(followerCreature:GetDefaultScale())
	followerCreature.logicTransform:SetScaleXYZ(tempVector3_3[1],tempVector3_3[2],tempVector3_3[3])

	followerCreature.ai:SyncLogicTransform(time, deltaTime, followerCreature)

	local masterInvisible = masterAssetRole:GetInvisible()
	local masterColliderEnable = masterAssetRole:GetColliderEnable()
	if followerAssetRole:GetInvisible() ~= masterInvisible then
		if masterInvisible then
			followerAssetRole:SetForceInvisible(masterInvisible)
		else
			followerAssetRole:SetForceInvisible(nil)
		end
	end
	if followerAssetRole:GetColliderEnable() ~= masterColliderEnable then
		followerAssetRole:SetForceColliderEnable(masterColliderEnable)
	end
	return true
end

--
--
--
--
--

function LogicManager_HandInHand:RegisterDoubleAction(masterCreature, followerCreature)
	self.doubleaction_targets[masterCreature.data.id] = followerCreature.data.id
	
	local followerAssetRole = followerCreature.assetRole
	if nil ~= CameraController.singletonInstance then
		CameraController.singletonInstance:SetPuppetFocus(
			followerAssetRole.completeTransform, 
			masterCreature.assetRole.completeTransform, 
			CameraFocusTransformDuration)
	end

	followerAssetRole:SetForceInvisible(nil)
	followerAssetRole:SetForceColliderEnable(nil)

	followerCreature.logicTransform:SetRotateSpeedScale(0.2)

	helplog("RegisterDoubleAction", masterCreature and masterCreature.data and masterCreature.data:GetName() or "No Name", 
		followerCreature and followerCreature.data and followerCreature.data:GetName() or "No Name");

	if(masterCreature == Game.Myself)then
		self.myDoubleAction_TargetId = followerCreature.data.id;
	end
end

function LogicManager_HandInHand:UnRegisterDoubleAction(masterCreature, followerCreature)
	if nil ~= masterCreature and nil ~= masterCreature.data then
		if self.doubleaction_targets[masterCreature.data.id] == nil then
			return;
		end
		self.doubleaction_targets[masterCreature.data.id] = nil
		self.cacheAngle_daction[ masterCreature.data.id ] = nil;
	end

	local followerAssetRole = followerCreature.assetRole
	if nil ~= CameraController.singletonInstance then
		CameraController.singletonInstance:SetPuppetFocus(
			followerAssetRole.completeTransform, 
			nil, 
			CameraFocusTransformDuration)
	end

	followerAssetRole:SetForceInvisible(nil)
	followerAssetRole:SetForceColliderEnable(nil)
	
	followerCreature.logicTransform:ScaleToXYZ(followerCreature:GetScaleWithFixHW())
	followerCreature.logicTransform:SetRotateSpeedScale(1)

	if(masterCreature == Game.Myself)then
		self.myDoubleAction_TargetId = nil;
	end

	helplog("UnRegisterDoubleAction", masterCreature and masterCreature.data and masterCreature.data:GetName() or "No Name", 
		followerCreature and followerCreature.data and followerCreature.data:GetName() or "No Name");
end

function LogicManager_HandInHand:_UpdateDoubleAction(time, deltaTime, masterCreature, followerCreature)
	if nil == followerCreature or nil ~= followerCreature.ai.parent then
		return false
	end

	local masterAssetRole = masterCreature.assetRole
	local followerAssetRole = followerCreature.assetRole

	local masterTransform = masterAssetRole.completeTransform
	
	tempVector3:Set(LuaGameObject.GetPosition(masterTransform));
	followerCreature.logicTransform:PlaceTo(tempVector3);

	local angleY = self.cacheAngle_daction[ masterCreature.data.id ];
	if(self.cacheAngle_daction[ masterCreature.data.id ] == nil)then
		angleY =  masterCreature:GetAngleY();
		self.cacheAngle_daction[ masterCreature.data.id ] = angleY;
	end
	masterCreature.logicTransform:SetTargetAngleY(angleY + 90);
	followerCreature.logicTransform:SetTargetAngleY(angleY - 90);

	
	local masterScale = masterCreature:GetScaleVector()
	tempVector3_3:Set(masterScale[1],masterScale[2],masterScale[3])
	tempVector3_3:Mul(followerCreature:GetDefaultScale())
	followerCreature.logicTransform:SetScaleXYZ(tempVector3_3[1],tempVector3_3[2],tempVector3_3[3])

	followerCreature.ai:SyncLogicTransform(time, deltaTime, followerCreature)

	local masterInvisible = masterAssetRole:GetInvisible()
	local masterColliderEnable = masterAssetRole:GetColliderEnable()
	if followerAssetRole:GetInvisible() ~= masterInvisible then
		if masterInvisible then
			followerAssetRole:SetForceInvisible(masterInvisible)
		else
			followerAssetRole:SetForceInvisible(nil)
		end
	end
	if followerAssetRole:GetColliderEnable() ~= masterColliderEnable then
		followerAssetRole:SetForceColliderEnable(masterColliderEnable)
	end
	return true
end

function LogicManager_HandInHand:TryBreakMyDoubleAction()
	if(self.myDoubleAction_TargetId == nil)then
		return;
	end
	
	local followerCreature = FindCreature(self.myDoubleAction_TargetId)
	if(followerCreature == nil)then
		return;
	end
	
	self:UnRegisterDoubleAction(Game.Myself, followerCreature);
end

function LogicManager_HandInHand:LateUpdate(time, deltaTime)
	for masterGUID, followerGUID in pairs(self.doubleaction_targets)do
		local masterCreature = FindCreature(masterGUID)
		if nil ~= masterCreature then
			local followerCreature = FindCreature(followerGUID)
			if nil ~= masterCreature then
				if not self:_UpdateDoubleAction(time, deltaTime, masterCreature, followerCreature) then
					self.doubleaction_targets[masterGUID] = nil
					self.cacheAngle_daction[masterGUID] = nil;
				end
			else
				self.doubleaction_targets[masterGUID] = nil
				self.cacheAngle_daction[masterGUID] = nil;
			end
		else
			self.doubleaction_targets[masterGUID] = nil
			self.cacheAngle_daction[masterGUID] = nil;
		end
	end

	for masterGUID, followerGUID in pairs(self.followers) do
		if(not self.doubleaction_targets[masterGUID])then

			local masterCreature = FindCreature(masterGUID)
			if nil ~= masterCreature then
				local followerCreature = FindCreature(followerGUID)
				if nil ~= masterCreature then
					if not self:_UpdateHandInHand(time, deltaTime, masterCreature, followerCreature) then
						self.followers[masterGUID] = nil
					end
				else
					self.followers[masterGUID] = nil
				end
			else
				self.followers[masterGUID] = nil
			end

		end
	end
end