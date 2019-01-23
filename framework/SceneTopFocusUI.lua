local BaseCell = autoImport("BaseCell")
SceneTopFocusUI = reusableClass("SceneTopFocusUI", BaseCell);

SceneTopFocusUI.resId = ResourcePathHelper.EffectUI("25focus")

SceneTopFocusUI.FocusType = {
	Creature = 1,
	SceneObject =2,
}

SceneTopFocusUI.PoolSize = 10

local tempVector3 = LuaVector3.zero

function SceneTopFocusUI:Construct(asArray, args)	
	self:DoConstruct(asArray, args)
end

function SceneTopFocusUI:Finalize()
	
end

function SceneTopFocusUI:DoConstruct(asArray, args)

	local focusType = args[1]
	if(focusType == SceneTopFocusUI.FocusType.Creature)then
		local target = args[2]
		self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneTopFocusUI.resId,target)
	elseif(focusType == SceneTopFocusUI.FocusType.SceneObject)then
		self.followTarget = GameObject("SceneTopFocusUIObj")
		local uicontainer = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.PhotoFocus)
		self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneTopFocusUI.resId,uicontainer)
		self:setFollowTarget()
	end

	if(self.gameObject)then
		tempVector3:Set(0,0,0)
		self.gameObject.transform.localPosition = tempVector3
		self.gameObject.transform.localRotation = LuaQuaternion.identity
		tempVector3:Set(1,1,1)
		self.gameObject.transform.localScale = tempVector3
		self.animator = self.gameObject:GetComponent(Animator)
	end
	self._alive = true
end

function SceneTopFocusUI:Deconstruct(asArray)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneTopFocusUI.resId, self.gameObject)
	end

	if(not self:ObjIsNil(self.followTarget))then
		Game.TransformFollowManager:UnregisterFollow(self.gameObject.transform)
		GameObject.DestroyImmediate(self.followTarget)
	end

	TimeTickManager.Me():ClearTick(self,PhotographPanel.TickType.CheckAnim)
	self._alive = false
end

function SceneTopFocusUI:playFocusAnim()
	self.animator:Play("focus2",-1,0)
	TimeTickManager.Me():CreateTick(0,16,self.checkIsPlayIngAnim,self,PhotographPanel.TickType.CheckAnim)
end

function SceneTopFocusUI:playLostFocusAnim()
	self.animator:Play("focus1",-1,0)
	TimeTickManager.Me():ClearTick(self,PhotographPanel.TickType.CheckAnim)
end

function SceneTopFocusUI:playStopFocusAnim()
	self.animator:Play("focus3",-1,0)
end

function SceneTopFocusUI:reSetFollowPos( pos )
	-- body
	if(not self:ObjIsNil(self.followTarget))then
		self.followTarget.transform.position = pos
	end
end

function SceneTopFocusUI:setFollowTarget(  )
	-- body
	tempVector3:Set(0,0,0)
	if(not self:ObjIsNil(self.followTarget))then
		Game.TransformFollowManager:RegisterFollowPos(
			self.gameObject.transform,
			self.followTarget.transform,
			tempVector3,
			SceneTopFocusUI.lostCallback, 
			self)
	end
end

function SceneTopFocusUI.lostCallback( owner )
	-- body
	owner:Deconstruct()
end

function SceneTopFocusUI:getPosition(  )
	-- body
	tempVector3:Set(LuaGameObject.GetPosition(self.gameObject.transform))
	return tempVector3
end

function SceneTopFocusUI:getTarPosition(  )
	-- body
	if(self.followTarget)then
		tempVector3:Set(LuaGameObject.GetPosition(self.followTarget.transform))
		return tempVector3
	else
		return self:getPosition()
	end
end

function SceneTopFocusUI:checkIsPlayIngAnim(  )
	-- body
	if(self:ObjIsNil(self.animator))then
		return
	end
	if(self.animator)then
		local animState = self.animator:GetCurrentAnimatorStateInfo(0)
		local complete = animState.normalizedTime >= 1
		local isPlaying = animState:IsName("focus2")
		if(not complete and isPlaying)then
			return 
		end
	end
	if(self.sound and not self:ObjIsNil(self.sound))then
		self.sound:Stop()
	end
	self.sound = self:PlayUISound(AudioMap.UI.Focus)
	self:playStopFocusAnim()
	TimeTickManager.Me():ClearTick(self,PhotographPanel.TickType.CheckAnim)
end

function SceneTopFocusUI:Alive()
	return self._alive
end