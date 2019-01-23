IdleAI_Photographer = class("IdleAI_Photographer")

local photoModelResPath = ResourcePathHelper.RoleWeapon(GameConfig.photomodelID)

local tempVector3 = LuaVector3.zero

local function FollowLostCallback(transform, creatureGUID)
	local creature = SceneCreatureProxy.FindCreature(creatureGUID)
	if not (nil ~= creature and creature.ai.autoAI_Photographer:StopFollow()) then
		GameObject.Destroy(transform.gameObject)
	end
end

function IdleAI_Photographer:ctor()
	self.actionPlayed = false
	self.cameraModel = nil
	self.following = false
end

function IdleAI_Photographer:StopFollow()
	if nil ~= self.cameraModel then
		self.cameraModel:SetActive(false)
		self.following = false
		return true
	end
	return false
end

function IdleAI_Photographer:_Reset(idleElapsed, time, deltaTime, creature)
	self.actionPlayed = false
	if nil ~= self.cameraModel then
		creature:Client_UnregisterFollowCP(self.cameraModel.transform)
		Game.GOLuaPoolManager:AddToSceneUIPool(photoModelResPath, self.cameraModel)
		self.cameraModel = nil
	end
	self.following = false
	if creature.assetRole:IsPlayingAction(Asset_Role.ActionName.Photograph) then
		creature:Logic_PlayAction_Idle()
	end
end

function IdleAI_Photographer:Clear(idleElapsed, time, deltaTime, creature)
	self:_Reset(idleElapsed, time, deltaTime, creature)
end

function IdleAI_Photographer:Prepare(idleElapsed, time, deltaTime, creature)
	return creature:IsPhotoStatus()
end

function IdleAI_Photographer:Start(idleElapsed, time, deltaTime, creature)
	self.actionPlayed = creature:Logic_PlayAction_Simple(Asset_Role.ActionName.Photograph)
	if self.actionPlayed then
		self.cameraModel = Game.AssetManager_UI:CreateSceneUIAsset(photoModelResPath)
		if nil ~= self.cameraModel then
			self.following = true
			creature:Client_RegisterFollowCP(
				self.cameraModel.transform, 
				RoleDefines_CP.RightHand, 
				FollowLostCallback, 
				creature.data.id)
		end
	end
end

function IdleAI_Photographer:End(idleElapsed, time, deltaTime, creature)
	self:_Reset(idleElapsed, time, deltaTime, creature)
end

function IdleAI_Photographer:Update(idleElapsed, time, deltaTime, creature)
	if self.actionPlayed then
		if nil ~= self.cameraModel and not self.following then
			self.following = true
			creature:Client_RegisterFollowCP(
				self.cameraModel.transform, 
				RoleDefines_CP.RightHand, 
				FollowLostCallback, 
				creature.data.id)
		end
		return true
	end
	return false
end

function IdleAI_Photographer:Flash(time, deltaTime, creature)
	if nil ~= self.cameraModel and self.following then
		tempVector3:Set(LuaGameObject.GetPosition(self.cameraModel.transform))
		Asset_Effect.PlayOneShotAt(
			EffectMap.Maps.photo_flashlight, 
			tempVector3)
		local resPath = ResourcePathHelper.AudioSEUI(AudioMap.UI.Picture)
		AudioUtility.PlayOneShotAt_Path(resPath, tempVector3)
	end
end