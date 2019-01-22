local tempVector3 = LuaVector3.zero
local selfVector3 = LuaVector3.zero

--????????????????????????
function NPlayer:PlayBaseLevelUpEffect()
	self:PlayEffect(nil,EffectMap.Maps.RoleLevelUp, 0,nil,false,true)
end

--job??????????????????
function NPlayer:PlayJobLevelUpEffect()
	self:PlayEffect(nil,EffectMap.Maps.JobLevelUp, 0,nil,false,true)
end

--????????????????????????
function NPlayer:PlayAdventureLevelUpEffect()
	self:PlayEffect(NPlayer.EffectKey_PlayAdventureLevelUp,EffectMap.Maps.AdventureLv_up, 0,nil,false,true)
	if(self:GetCreatureType() == Creature_Type.Me)then
		LeanTween.delayedCall(5,function (  )
			-- body
			local body = ReusableTable.CreateTable()
			body.view = PanelConfig.AdventureRewardPanel
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, body) 
			ReusableTable.DestroyAndClearTable(body)
		end)	
	end
end

function NPlayer:PlayBaseLevelUpAudio()
	self:PlayAudio(AudioMap.Maps.RoleLevelUp, nil,false)
end

--??????boss??????
function NPlayer:PlayKilledMVPEffect()
	self:PlayEffect(nil,EffectMap.Maps.MVPKilled, RoleDefines_EP.Top,nil,false,true)
	self:PlayAudio(AudioMap.Maps.KillMvp, RoleDefines_EP.Top,false)
end

--???????????????
function NPlayer:PlayHpUp()
	self:PlayEffect(nil,EffectMap.Maps.HpUp, RoleDefines_EP.Chest,nil,false,true)
end

--PVP????????????
function NPlayer:PlayTeamCircle(teamEnum)
	self:RemoveEffect("TeamCircle_Effect")
	if(teamEnum>0) then
		local effectMap = nil;
		if(Game.MapManager:IsGvgMode_Droiyan())then
			effectMap = EffectMap.Maps.SuperGVGTeamCircl;
		else
			effectMap = EffectMap.Maps.PVPTeamCircl;
		end
		self:PlayEffect("TeamCircle_Effect",effectMap[teamEnum], 0,nil,true,true)
	end
end

--????????????
function NPlayer:PlayPeakEffect()
	self:RemovePeakEffect()
	self:PlayEffect("Peak_Effect", EffectMap.Maps.Peak, 0, nil, true, true)
end

function NPlayer:RemovePeakEffect()
	self:RemoveEffect("Peak_Effect")
end

-- track effect begin
function NPlayer:_AddTrackEffect(trackEffect)
	if(self.trackEffects == nil) then
		self.trackEffects = {}
	end
	self.trackEffects[#self.trackEffects+1] = trackEffect
end

local Better_MoveTowards = LuaVector3.Better_MoveTowards
local tableRemove = table.remove
function NPlayer:_UpdateTrackEffect(time,deltaTime)
	local effects = self.trackEffects
	if(effects) then
		selfVector3[1],selfVector3[2],selfVector3[3] = LuaGameObject.GetPosition(self.assetRole:GetEPOrRoot(RoleDefines_EP.Chest))
		local trackEffect,currentPosition,deltaDistance
		for i=#effects,1,-1 do
			trackEffect = effects[i]
			currentPosition = trackEffect:GetLocalPosition()
			if(currentPosition) then
				deltaDistance = trackEffect:GetSpeed() * deltaTime
				Better_MoveTowards(currentPosition, selfVector3, tempVector3, deltaDistance)
				if VectorUtility.AlmostEqual_3(tempVector3, selfVector3) then
					-- hit
					trackEffect:Hit()
					trackEffect:Destroy()
					tableRemove(effects,i)
				else
					trackEffect:ResetLocalPosition(tempVector3)
				end
			else
				tableRemove(effects,i)
			end
		end
	end
end

function NPlayer:_ClearTrackEffects()
	local effects = self.trackEffects
	if(effects) then
		for i=1,#effects do
			effects[i]:Destroy()
		end
		TableUtility.TableClear(effects)
	end
end
-- track effect end
--??????????????????
function NPlayer:PlayPickUpTrackEffect(path,pos,speed,audioPath)
	local effect = TrackEffect.CreateAsArray()
	effect:SetSpeed(speed)
	effect:Spawn(path,pos)
	effect:SetHitCall(NPlayer.PickUpEffectArrivedHandler,self,audioPath)
	self:_AddTrackEffect(effect)
end

function NPlayer.PickUpEffectArrivedHandler( trackEffect,player,audioPath )
	player:PlayPickedUpItem(audioPath)
end

--????????????
function NPlayer:PlayPickedUpItem(audioPath)
	self:PlayEffect(nil,GameConfig.SceneDropItem.itemPickedEffect, RoleDefines_EP.Chest,nil,false,true)
	self:PlayAudio(audioPath,RoleDefines_EP.Chest,false)
end

--????????????
function NPlayer:PlayDeathEffect()
	self:PlayEffect(nil,EffectMap.Maps.HumanDead,RoleDefines_EP.Middle,nil,false,false)
end

--??????
function NPlayer:PlayChangeJob()
	FunctionSystem.InterruptCreature(self)
	self:_PlayChangeJobBeginEffect()
end

--??????????????????
function NPlayer:_PlayChangeJobBeginEffect()
	self._changeJobTimeFlag = Time.time + 3
	-- effect 1
	self.assetRole:ChangeColorFromTo(
			LuaGeometry.Const_Col_whiteClear,
			LuaGeometry.Const_Col_white, 
			3)
	local changeJobEffect = self:PlayEffect(nil,EffectMap.Maps.JobChange,0,nil,false,true)
	self:PlayAudio(AudioMap.Maps.JobChange,1,false)
	return changeJobEffect
end

--??????fire??????
function NPlayer:_PlayChangeJobFireEffect()
	self:ReDress()
	FunctionSystem.InterruptCreature(self)
	-- effect 2
	self.assetRole:ChangeColorFromTo(
			LuaGeometry.Const_Col_white, 
			LuaGeometry.Const_Col_whiteClear,
			0.3)
	local resID = ResourcePathHelper.EffectSpineCommon(EffectMap.Maps.JobChangeHorn)
	if(self.sceneui) then
		self.sceneui.roleTopUI:PlayTopSpine(resID, "animation");
	end
	self:PlayAudio(AudioMap.Maps.JobChangeHorn,1,false)
end

function NPlayer:_UpdateEffect(time,deltaTime)
	self:_UpdateTrackEffect(time,deltaTime)
	if(self._changeJobTimeFlag) then
		if(self._changeJobTimeFlag<=time) then
			self._changeJobTimeFlag = nil
			self:_PlayChangeJobFireEffect()
		end
	end
end