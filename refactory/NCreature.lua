autoImport("CreatureVisibleHandler")
autoImport ("ClientProps")
NCreature = class("NCreature",ReusableObject)

autoImport("NCreature_Effect")
autoImport("NCreature_Client")
autoImport("NCreature_Logic")

local table_ActionAnime = Table_ActionAnime;
local config_Action;

local DressDelayScale = 1
local fixHeightScale = {0.9,1.1}
local fixWeightScale = {0.9,1.1}

HandInActionType = 
{
	Clear = 0,

	HandIn = 1,
	InHand = 2,

	Hold = 3,
	BeHolded = 4,

	DoubleAction = 5,
}

function NCreature:ctor(aiClass)
	NCreature.super.ctor(self)

	config_Action = Game.Config_Action;
	--> reusable begin
	--数据对象
	self.data = nil
	--表现管理
	self.assetRole = nil
	--> reusable end

	--transform管理
	self.logicTransform = Logic_Transform.new()
	--行为树
	aiClass = aiClass or AI_Creature
	self.ai = aiClass.new()
	--may be has
	-- self.visibleHandler = nil
	-- self.partner = nil
	self.originalScale = nil

	self.isCullingRegisted = false
end

function NCreature:GetDressPriority()
	return LogicManager_RoleDress.Priority.Normal
end

function NCreature:IsMoving()
	return nil ~= self.logicTransform.targetPosition
end

function NCreature:IsExtraMoving()
	return 0 < #self.logicTransform.extraLogics
end

--注意，此方法为LXY专享，不要调用
function NCreature:SetDressEnable(v)
	if(self.data) then
		if(v~= self.data.dressEnable) then
			self.data:SetDressEnable(v)
			self:ReDress()
			if(self.partner) then
				self.partner:SetDressEnable(v)
			end
			if self.handNpc then
				local npc = self:GetHandNpc()
				if npc then
					npc:SetDressEnable(v)
				end
			end
			if self.expressNpcMap then
				for key,value in pairs(self.expressNpcMap) do
					local npc = self:GetExpressNpc( key )
					if npc then
						npc:SetDressEnable(v)
					end
				end
			end
			NScenePetProxy.Instance:SetOwnerDressEnable(self,v)
		end
	end
end

function NCreature:IsDressEnable()
	if(self.data) then
		return self.data:IsDressEnable()
	end
	return true
end

function NCreature:IsDressed()
	return self.dressed
end

function NCreature:IsPhotoStatus()
	return false
end

function NCreature:IsOnSceneSeat()
	return nil ~= Game.SceneSeatManager:GetCreatureSeat(self)
end

function NCreature:GetCreatureType()
	return nil
end

function NCreature:IsHandInHand()
	return false,nil
end

function NCreature:MaskUI(reason,uiType)
	if(self.sceneui) then
		self.sceneui:MaskUI(reason,uiType)
	end
	if(self.handNpc) then
		local npc = self:GetHandNpc()
		if npc then
			npc:MaskUI(reason,uiType)
		end
	end
	if self.expressNpcMap then
		for k,v in pairs(self.expressNpcMap) do
			local npc = self:GetExpressNpc(k)
			if npc then
				npc:MaskUI(reason,uiType)
			end
		end
	end
end

function NCreature:UnMaskUI(reason,uiType)
	if(self.sceneui) then
		self.sceneui:UnMaskUI(reason,uiType)
	end
	if(self.handNpc) then
		local npc = self:GetHandNpc()
		if npc then
			npc:UnMaskUI(reason,uiType)
		end
	end
	if self.expressNpcMap then
		for k,v in pairs(self.expressNpcMap) do
			local npc = self:GetExpressNpc(k)
			if npc then
				npc:UnMaskUI(reason,uiType)
			end
		end
	end
end

function NCreature:HandleSettingMask()
	if(self.sceneui and self.sceneui.roleBottomUI) then
		self.sceneui.roleBottomUI:HandleSettingMask(self)
	end

	if(self.data.petIDs and #self.data.petIDs>0)then
		for i=1,#self.data.petIDs do
			local guid = self.data.petIDs[i]
			local creature = NScenePetProxy.Instance:Find(guid)
			if(creature and creature.sceneui and creature.sceneui.roleBottomUI)then
				creature.sceneui.roleBottomUI:HandleSettingMask(creature)
			end
		end
	end

	if(self.handNpc) then
		local npc = self:GetHandNpc()
		if npc then
			npc:HandleSettingMask()
		end
	end
	if self.expressNpcMap then
		for k,v in pairs(self.expressNpcMap) do
			local npc = self:GetExpressNpc(k)
			if npc then
				npc:HandleSettingMask()
			end
		end
	end
end

function NCreature:HandIn()
	if(self:IsPlayingDoubleAction())then
		return;
	end

	self:_SetHandInHandAction(HandInActionType.HandIn)
end

function NCreature:InHand()
	self:_SetHandInHandAction(HandInActionType.InHand)
end

function NCreature:ClearHandInHand()
	if(self:IsPlayingDoubleAction())then
		return;
	end

	self:_SetHandInHandAction(HandInActionType.Clear)
end

function NCreature:IsPlayingHandInIdleAction()
	if 1 ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end

function NCreature:IsPlayingHandInMoveAction()
	if 1 ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsPlayingHandInAction()
	if 1 ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
		or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsPlayingInHandIdleAction()
	if 2 ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end

function NCreature:IsPlayingInHandMoveAction()
	if 2 ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsPlayingInHandAction()
	if 2 ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
		or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsReadyToHandIn(handInCP)
	if(self:IsDoubleActionBuild())then
		return;
	end

	if self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) 
		or self.assetRole:IsPlayingActionRaw(self:GetMoveAction()) then
		return nil ~= self.assetRole:GetCP(handInCP)
	end
	return false
end

function NCreature:_SetHandInHandAction(action)
	if action == self.handInHandAction then
		return
	end

	local oldIdleActionName = self:GetIdleAction()
	local oldMoveActionName = self:GetMoveAction()

	self.handInHandAction = action

	if self.assetRole:IsPlayingAction(oldIdleActionName) then
		self.assetRole:PlayAction_Simple(self:GetIdleAction())
	elseif self.assetRole:IsPlayingAction(oldMoveActionName) then
		self.assetRole:PlayAction_Simple(self:GetMoveAction())
	end
end

-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
function NCreature:Hold()
	if(self:IsPlayingDoubleAction())then
		return;
	end

	self:_SetHandInHandAction(HandInActionType.Hold)
end

function NCreature:BeHolded()
	self:_SetHandInHandAction(HandInActionType.BeHolded)
end

function NCreature:ClearHold()
	self:_SetHandInHandAction(HandInActionType.Clear)
end

function NCreature:ClearBeHolded()
	self:_SetHandInHandAction(HandInActionType.Clear)
end

function NCreature:IsPlayingHoldIdleAction()
	if HandInActionType.Hold ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end

function NCreature:IsPlayingHoldMoveAction()
	if HandInActionType.Hold ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsPlayingHoldAction()
	if HandInActionType.Hold ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
		or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsPlayingBeHoldedIdleAction()
	if HandInActionType.BeHolded ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end

function NCreature:IsPlayingBeHoldedMoveAction()
	if HandInActionType.BeHolded ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsPlayingBeHoldedAction()
	if HandInActionType.BeHolded ~= self.handInHandAction then
		return false
	end
	return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
		or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end

function NCreature:IsReadyToHold(holdCP)
	if(self:IsDoubleActionBuild())then
		return false;
	end

	if self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) 
		or self.assetRole:IsPlayingActionRaw(self:GetMoveAction()) then
		return nil ~= self.assetRole:GetCP(holdCP)
	end
	return false
end

-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 

function NCreature:IsDoubleActionBuild()
	return self.doubleaction_build == true;
end
function NCreature:IsPlayingDoubleAction()
	if(self.assetRole == nil)then
		return false;
	end

	local actionRaw = self.assetRole.actionRaw;
	local d_a = config_Action[actionRaw] and config_Action[actionRaw].DoubleAction;
	if(d_a == nil or d_a <= 0)then
		return false;
	end

	return true;
end
function NCreature:PlayDoubleAction(isMaster)
	helplog("PlayDoubleAction", self.data:GetName());
	self:_SetHandInHandAction(HandInActionType.DoubleAction)

	local handNpc = self:GetHandNpc();
	if(handNpc)then
		handNpc:SetVisible(false, LayerChangeReason.DoubleAction);
	end
end
function NCreature:ClearDoubleAction()
	helplog("ClearDoubleAction", self.data:GetName());
	self:_SetHandInHandAction(HandInActionType.Clear)

	local handNpc = self:GetHandNpc();
	if(handNpc)then
		handNpc:SetVisible(true, LayerChangeReason.DoubleAction);
	end
end

function NCreature:GetIdleAction()
	if HandInActionType.HandIn == self.handInHandAction then
		return Asset_Role.ActionName.IdleHandIn
	elseif HandInActionType.InHand == self.handInHandAction then
		return Asset_Role.ActionName.IdleInHand
	elseif HandInActionType.Hold == self.handInHandAction then
		return Asset_Role.ActionName.IdleHold
	elseif HandInActionType.BeHolded == self.handInHandAction then
		return Asset_Role.ActionName.IdleBeHolded
	elseif HandInActionType.DoubleAction == self.handInHandAction then
		local dactionid = self:GetDoubleActionId();
		if(dactionid ~= 0)then
			return table_ActionAnime[dactionid].Name;
		end
	end
	return self.data and self.data.idleAction or Asset_Role.ActionName.Idle
end

function NCreature:GetMoveAction()
	if HandInActionType.HandIn == self.handInHandAction then
		return Asset_Role.ActionName.MoveHandIn
	elseif HandInActionType.InHand == self.handInHandAction then
		return Asset_Role.ActionName.MoveInHand
	elseif HandInActionType.Hold == self.handInHandAction then
		return Asset_Role.ActionName.MoveHold
	elseif HandInActionType.BeHolded == self.handInHandAction then
		return Asset_Role.ActionName.MoveBeHolded
	end
	return self.data and self.data.moveAction or Asset_Role.ActionName.Move
end

function NCreature:GetPosition()
	return self.logicTransform.currentPosition
end

--y旋转值
function NCreature:GetAngleY()
	return self.logicTransform.currentAngleY
end

--缩放值 float
function NCreature:GetScale()
	return self.data.bodyScale
end

function NCreature:GetOriginalScale()
	return self.originalScale
end

function NCreature:GetDefaultScale()
	return self.data and self.data:GetDefaultScale() or 1
end

function NCreature:GetScaleVector()
	return self.logicTransform.currentScale
end

--返回带有修正高度、体重的缩放x,y,z
function NCreature:GetScaleWithFixHW()
	local scaleX,scaleY,scaleZ = self.data.bodyScale,self.data.bodyScale,self.data.bodyScale
	local fixHScale = 1+(self.data.props.SlimHeight:GetValue()/50)
	if(fixHScale<fixHeightScale[1]) then
		fixHScale = fixHeightScale[1]
	elseif(fixHScale>fixHeightScale[2]) then
		fixHScale = fixHeightScale[2]
	end
	scaleY = fixHScale * scaleY
	local fixWScale = 1+(self.data.props.SlimWeight:GetValue()/50)
	if(fixWScale<fixWeightScale[1]) then
		fixWScale = fixWeightScale[1]
	elseif(fixWScale>fixWeightScale[2]) then
		fixWScale = fixWeightScale[2]
	end
	scaleX = fixWScale * scaleX
	scaleZ = fixWScale * scaleZ
	return scaleX,scaleY,scaleZ
end

function NCreature:GetSceneUI()
	return nil
end

function NCreature:SetVisible(v,reason)
	if( self.visibleHandler == nil) then
		self.visibleHandler = CreatureVisibleHandler.CreateAsTable()
	end
	self.visibleHandler:Visible(self,v,reason)
	if(self.partner) then
		self.partner:SetVisible(v,reason)
	end
	if self.handNpc then
		local npc = self:GetHandNpc()
		if npc then
			npc:SetVisible(v,reason)
		end
	end
	if self.expressNpcMap then
		for key,value in pairs(self.expressNpcMap) do
			local npc = self:GetExpressNpc(key)
			if npc then
				npc:SetVisible(v,reason)
			end
		end
	end
end

function NCreature:SetOnCarrier(val)
	-- helplog("SetOnCarrier",val)
	self.onCarrier = val
	if(val) then
		if(self.partner~=nil and not self.partner.data:CanGetOnCarrier()) then
			local partnerID = self.partnerID
			self:RemovePartner()
			self.partnerID = partnerID
		end
	else
		if(self.partner ==nil and self.partnerID~=nil and self.partnerID~=0) then
			self:SetPartner(self.partnerID)
		end
	end
end

function NCreature:SetPartner(id)
	-- helplog("SetPartner",id)
	self.partnerID = id
	if(id == 0) then
		self:RemovePartner()
	else
		if(self.partner) then
			self.partner:ResetID(id)
		else
			self.partner = NPartner.CreateAsTable(id)
		end
		self.partner:SetMaster(self)
	end
end

function NCreature:RemovePartner()
	if(self.partner) then
		-- helplog("RemovePartner")
		self.partner:Destroy()
		self.partner = nil
	end
	self.partnerID = 0
end

function NCreature:GetPartnerID()
	return self.partnerID
end

--艾娃
function NCreature:AddHandNpc(guid)
	self.handNpc = guid
end

function NCreature:RemoveHandNpc()
	self.handNpc = nil
end

function NCreature:GetHandNpc()
	if(self.handNpc == nil)then
		return;
	end
	local npc = SceneAINpcProxy.Instance:Find( self.handNpc )
	if npc == nil then
		self:RemoveHandNpc()
	end

	return npc	
end

--姜饼人
function NCreature:AddExpressNpc(guid)
	if self.expressNpcMap == nil then
		self.expressNpcMap = {}
	end

	if self.expressNpcMap[guid] == nil then
		self.expressNpcMap[guid] = guid
	end
end

function NCreature:ClearExpressNpc()
	if self.expressNpcMap then
		for k,v in pairs(self.expressNpcMap) do
			SceneAINpcProxy.Instance:Remove( k )
		end

		TableUtility.TableClear(self.expressNpcMap)
	end
end

function NCreature:IsExpressNpc(guid)
	if self.expressNpcMap then
		return self.expressNpcMap[guid]
	else
		return nil
	end
end

function NCreature:GetExpressNpc(guid)
	local npc = SceneAINpcProxy.Instance:Find( guid )
	if npc == nil then
		self.expressNpcMap[guid] = nil
	end

	return npc
end

--隐身
function NCreature:SetStealth(v)
	if(self.assetRole) then
		if(v) then
			self.assetRole:AlphaTo(0.5,1)
		else
			self.assetRole:AlphaTo(1,1)
		end
	end
end

function NCreature:SetParent(parentTransform)
	self.ai:SetParent(parentTransform, self)
end

function NCreature:Show()
	FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):ShowPlayer(self)
end

function NCreature:Hide()
	FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):HidePlayer(self)
end

function NCreature:SetClickable(v)
	if(self.data) then
		self.data.noAccessable = v and 0 or 1
	end
	if(self.assetRole) then
		local creatureType = self:GetCreatureType()
		if(creatureType == Creature_Type.Npc or creatureType == Creature_Type.Player) then
			local noAccessable = self.data:NoAccessable()
			self.assetRole:SetColliderEnable(not noAccessable)
			if(not v and Game.Myself:GetLockTarget() == self) then
				Game.Myself:Client_LockTarget(nil)
			end
		end
	end
end

function NCreature:GetClickable()
	return not self.data:NoAccessable()
end

function NCreature:InitAssetRole()
	self:ReDress()
end

function NCreature:ResetClickPriority()
	if(self.assetRole and self.data) then
		self.assetRole:SetClickPriority(self.data:GetClickPriority())
	end
end

function NCreature:Server_SyncSkill(phaseData)
	-- local creature = self
	-- LogUtility.InfoFormat("<color=green>{0} Receive Skill: </color>{1}\n{2}", 
	-- 	creature.data and creature.data:GetName() or "No Name",
	-- 	phaseData:GetSkillID(),
	-- 	phaseData:GetSkillPhase())
	-- local targetCount = phaseData:GetTargetCount()
	-- local logString = LogUtility.StringFormat("Targets: {0}\n", targetCount)
	-- for i=1, targetCount do
	-- 	local guid, damageType, damage = phaseData:GetTarget(i)
	-- 	local targetCreature = SceneCreatureProxy.FindCreature(guid)
	-- 	logString = LogUtility.StringFormat("{0}{1}, {2}\n", 
	-- 		logString, 
	-- 		LogUtility.StringFormat("({0}, {1})", 
	-- 			targetCreature and targetCreature.data and targetCreature.data:GetName() or "Null", 
	-- 			guid),
	-- 		LogUtility.StringFormat("{0}, {1}", 
	-- 			damageType, 
	-- 			damage))
	-- end
	-- LogUtility.Info(logString)
	
	self.ai:PushCommand(FactoryAICMD.GetSkillCmd(phaseData), self)
end

function NCreature:Server_GetOnSeat(seatID)
	self.ai:PushCommand(FactoryAICMD.GetGetOnSeatCmd(seatID), self)
end

function NCreature:Server_GetOffSeat(seatID)
	self.ai:PushCommand(FactoryAICMD.GetGetOffSeatCmd(seatID), self)
end

function NCreature:InitLogicTransform(serverX,serverY,serverZ,dir,scale,moveSpeed,rotateSpeed,scaleSpeed)
	self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
	self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor(rotateSpeed))
	self.logicTransform:SetScaleSpeed(self.data:ReturnScaleSpeedWithFactor(scaleSpeed))
	if(scale) then
		self:Server_SetScaleCmd(scale,true)
	end
	if(dir) then
		self:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY,dir)
	end
	self:Server_SetPosXYZCmd(serverX,serverY,serverZ,1000)
end

function NCreature:GetDressParts()
	if(not self:IsDressEnable()) then
		return Asset_Role.CreatePartArray()
	end
	return self.data:GetDressParts()
end

function NCreature:DestroyDressParts(parts,partsNoDestroy)
	if partsNoDestroy then
		return
	end
	Asset_Role.DestroyPartArray(parts)
end

function NCreature:AllowDress()
	-- return not (self:IsDressEnable() and not self.dressed and Game.Myself:IsMoving())
	return not (self:IsDressEnable() and not self.dressed)
end

function NCreature:ReDress()
	if nil ~= self.assetRole then
		if not self:AllowDress() then
			-- if self:IsDressEnable() then
			-- 	local parts,partsNoDestroy = self:GetDressParts()
			-- 	self.dressed = self.assetRole:RedressWithCache(parts)
			-- 	self:DestroyDressParts(parts,partsNoDestroy)
			-- end
			return
		end
		self:_ReDress()
	else
		local parts = nil
		local partsNoDestroy = false
		local dressEnable = false
		if self:AllowDress() then
			parts,partsNoDestroy = self:GetDressParts()
			dressEnable = self:IsDressEnable()
		else
			parts = Asset_Role.CreatePartArray()
			dressEnable = false
		end
		parts[Asset_Role.PartIndexEx.SmoothDisplay] = 0.3 -- smooth alpha to display
		
		self.dressed = dressEnable
		self.assetRole = Asset_Role.Create(parts)
		self:DestroyDressParts(parts,partsNoDestroy)

		-- if not dressEnable and self:IsDressEnable() then
		-- 	parts,partsNoDestroy = self:GetDressParts()
		-- 	self.dressed = self.assetRole:RedressWithCache(parts)
		-- 	self:DestroyDressParts(parts,partsNoDestroy)
		-- end
	end
end

function NCreature:_ReDress()
	local parts,partsNoDestroy = self:GetDressParts()
	self.dressed = self:IsDressEnable()
	self.assetRole:Redress(parts)
	self:DestroyDressParts(parts,partsNoDestroy)
end

-- cmds begin
local tmpVector3 = LuaVector3.zero
function NCreature:Server_SetPosXYZCmd(x,y,z,div,ignoreNavMesh)
	tmpVector3:Set(x,y,z)
	-- local pos = LuaVector3(x,y,z)
	if(div~=nil) then
		tmpVector3:Div(div)
	end
	self:Server_SetPosCmd(tmpVector3,ignoreNavMesh)
	-- pos:Destroy()
end

function NCreature:Server_SetPosCmd(p,ignoreNavMesh)
	self.ai:PushCommand(FactoryAICMD.GetPlaceToCmd(p,ignoreNavMesh), self)
end

function NCreature:Server_SetDirCmd(mode,dir,noSmooth)
	helplog(string.format("Server SetDirCmd Player:%s Dir:%s", self.data.name, dir));
	self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode,dir,noSmooth), self)
end

function NCreature:Server_MoveToXYZCmd(x,y,z,div,ignoreNavMesh)
	-- local pos = LuaVector3(x,y,z)
	tmpVector3:Set(x,y,z)
	if(div~=nil) then
		tmpVector3:Div(div)
	end
	self:Server_MoveToCmd(tmpVector3,ignoreNavMesh)
	-- pos:Destroy()
end

function NCreature:Server_MoveToCmd(p,ignoreNavMesh)
	self.ai:PushCommand(FactoryAICMD.GetMoveToCmd(p,ignoreNavMesh), self)
end

-- @param noSmooth true的话，直接设置。false的话，渐变
function NCreature:Server_SetScaleCmd(scale,noSmooth)
	self.originalScale = scale
	self.data.bodyScale = scale
	local scaleX,scaleY,scaleZ = self:GetScaleWithFixHW()
	self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX,scaleY,scaleZ,noSmooth), self)
end

function NCreature:Server_SetFixHeightCmd(height,noSmooth)
	local scaleX,scaleY,scaleZ = self:GetScaleWithFixHW()
	self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX,scaleY,scaleZ,noSmooth), self)
end

function NCreature:Server_SetFixWeightCmd(weight,noSmooth)
	local scaleX,scaleY,scaleZ = self:GetScaleWithFixHW()
	self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX,scaleY,scaleZ,noSmooth), self)
end

function NCreature:Server_PlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration)
	-- LogUtility.Info("Server_PlayActionCmd "..self.data:GetName().." "..name)
	self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration), self)
end

function NCreature:Server_DieCmd(noaction)
	-- LogUtility.Info(self.data:GetName().." Server_DieCmd "..tostring(noaction))
	self.ai:PushCommand(FactoryAICMD.GetDieCmd(noaction), self)
end

function NCreature:Server_ReviveCmd()
	self.ai:PushCommand(FactoryAICMD.GetReviveCmd(), self)
end
--cmds end

function NCreature:Server_SetMoveSpeed(moveSpeed)
	self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
end

function NCreature:Server_SetAtkSpeed(atkSpeed)
	self.data:SetAttackSpeed(atkSpeed)
end

function NCreature:Server_CameraFlash()
	self.ai:CameraFlash(0, 0, self)
end

function NCreature:Server_SetHandInHand(masterID, running)
	if running then
		self.ai:HandInHand(masterID, self)
	else
		self.ai:HandInHand(0, self, nil)
	end
end

function NCreature:Server_SetDoubleAction(masterID, running)
	helplog("NCreature Server_SetDoubleAction", masterID, running);
	self.doubleaction_build = running;

	if running then
		self.ai:DoDoubleAction(masterID, self)
	else
		self.ai:DoDoubleAction(0, self)
	end
end

local DoubleAction_F_Prefix = "be_";
function NCreature:GetDoubleActionId()
	local handInActionID = self.data.userdata:Get(UDEnum.TWINS_ACTIONID);
	if(handInActionID == nil or
		handInActionID == 0)then
		return 0;
	end

	-- female double-acton start with "be_"
	local action_name = table_ActionAnime[handInActionID] and table_ActionAnime[handInActionID].Name;
	local prefix = string.sub(action_name, 1, 3);
  	local sex = self.data.userdata:Get(UDEnum.SEX);
  	if(sex == 1)then
  		if(prefix == DoubleAction_F_Prefix)then
  			local reflect_name = string.sub(action_name, 4,-1);
  			local reflect_data = config_Action[reflect_name];
  			if(reflect_data)then
  				return reflect_data.id;
  			end
  		end
	elseif(sex == 2)then
		if(prefix ~= DoubleAction_F_Prefix)then
			local reflect_name = DoubleAction_F_Prefix .. action_name;
			local reflect_data = config_Action[reflect_name];
			if(reflect_data)then
				return reflect_data.id;
			end
		end
	end

	return handInActionID;
end

function NCreature:Server_SetAlpha(alpha)
	if(self.assetRole) then
		self.assetRole:AlphaTo(alpha,0)
	end
end

function NCreature:Update(time, deltaTime)
	self.logicTransform:Update(time,deltaTime)
	self.ai:Update(time,deltaTime,self)
	if(self.partner) then
		self.partner:Update(time,deltaTime)
	end
	if(self.handNpc) then
		local npc = self:GetHandNpc()
		if npc then
			npc:Update(time,deltaTime)
		end
	end
	if self.expressNpcMap then
		for k,v in pairs(self.expressNpcMap) do
			local npc = self:GetExpressNpc(k)
			if npc then
				npc:Update(time,deltaTime)
			end
		end
	end
	self:_UpdateArroundMyself(time, deltaTime)
	self:_UpdateSpEffect(time, deltaTime)
end

function NCreature:GetDressDisableDistanceLevel()
	return 999
end

function NCreature:_UpdateArroundMyself(time, deltaTime)
	if not self.dressed then
		local distanceLevelChanged = false
		if self.arroundMyselfLevel ~= self.culling_distanceLevel then
			self.arroundMyselfLevel = self.culling_distanceLevel
			distanceLevelChanged = true
		else
			self.arroundMyselfTime = self.arroundMyselfTime + deltaTime
		end

		local dressDisableDistanceLevel = self:GetDressDisableDistanceLevel()
		if not (self.culling_visible 
			and dressDisableDistanceLevel > self.culling_distanceLevel 
			and self:IsDressEnable()) then
			return
		end

		local myself = Game.Myself
		local lockTarget = myself:GetLockTarget()
		if self == lockTarget then
			self:_ReDress()
			return
		end
		
		if distanceLevelChanged and 0 >= self.culling_distanceLevel then
			local parts, partsNoDestroy = self:GetDressParts()
			self.dressed = self.assetRole:RedressWithCache(parts)
			self:DestroyDressParts(parts,partsNoDestroy)
			if self.dressed then
				return
			end
		end
		local dressDelayTime = self.arroundMyselfLevel * 2 + 1
		if dressDelayTime < self.arroundMyselfTime then
			self:_ReDress()
		end

		-- local p = self:GetPosition()
		-- local distance = VectorUtility.DistanceXZ(p, myself:GetPosition())
		-- local arroundLevel = Game.Myself:GetArroundLevel(p, distance)
		-- if self.arroundMyselfLevel ~= arroundLevel then
		-- 	-- if self.arroundMyselfLevel > arroundLevel then
		-- 	-- 	self.arroundMyselfTime = 0
		-- 	-- end
		-- 	self.arroundMyselfLevel = arroundLevel
		-- else
		-- 	if 0 < arroundLevel then
		-- 		self.arroundMyselfTime = self.arroundMyselfTime + deltaTime
		-- 	else
		-- 		self.arroundMyselfTime = 0
		-- 	end
		-- end

		-- local dressDistance = self:GetDressDistance()
		-- if 0 < dressDistance and dressDistance < distance then
		-- 	return
		-- end

		-- if 0 < arroundLevel and self:IsDressEnable() then
		-- 	-- if not Game.Myself:IsMoving() or arroundLevel*DressDelayScale < self.arroundMyselfTime then
		-- 	-- 	self:_ReDress()
		-- 	-- end
		-- 	if math.min(arroundLevel*DressDelayScale, 5) < self.arroundMyselfTime then
		-- 		self:_ReDress()
		-- 	end
		-- end
	end
end

autoImport ("EffectWorker_Connect")
autoImport ("EffectWorker_OnFloor")
SpEffectWorkerClass = {
	[1] = EffectWorker_Connect,
	[2] = EffectWorker_OnFloor,
}
function NCreature:AllowSpEffect_OnFloor()
	return false
end
function NCreature:Server_AddSpEffect(spEffectData)
	local effectID = spEffectData.id
	if nil == Table_SpEffect[effectID] then
		return
	end
	local effectType = Table_SpEffect[effectID].Type
	local EffectClass = SpEffectWorkerClass[effectType]
	if nil == EffectClass then
		return
	end

	if nil == self.spEffects then
		self.spEffects = {}
	end

	local key = spEffectData.guid
	local effect = self.spEffects[key]
	if nil ~= effect then
		effect:Destroy()
		self.spEffects[key] = nil
	end
	
	effect = EffectClass.Create(effectID)
	effect:SetArgs(spEffectData.entity, self)
	self.spEffects[key] = effect
end

function NCreature:Server_RemoveSpEffect(spEffectData)
	if nil == self.spEffects then
		return
	end
	local key = spEffectData.guid
	local effect = self.spEffects[key]
	if nil ~= effect then
		effect:Destroy()
		self.spEffects[key] = nil
	end
end

function NCreature:ClearSpEffect()
	if nil == self.spEffects then
		return
	end
	for k,v in pairs(self.spEffects) do
		v:Destroy()
		self.spEffects[k] = nil
	end
end

function NCreature:_UpdateSpEffect(time, deltaTime)
	if nil == self.spEffects then
		return
	end
	for k,v in pairs(self.spEffects) do
		if v:Update(time, deltaTime, self) == false then
			v:Destroy()
			self.spEffects[k] = nil
		end
	end
end

function NCreature:IsInMyTeam()
	return nil ~= self.data and TeamProxy.Instance:IsInMyTeam(self.data.id)
end

function NCreature:IsHatred()
	return self.beHatred
end

function NCreature:BeHatred(on, time)
	local oldBeHatred = self.beHatred
	self.beHatred = on
	if self.beHatred then
		Game.LogicManager_Hatred:Refresh(self, time)
	elseif oldBeHatred then
		Game.LogicManager_Hatred:Remove(self)
	end
end

function NCreature:HatredTimeout()
	self.beHatred = false
end

function NCreature:IsCullingRegisted()
	return self.isCullingRegisted
end

function NCreature:RegistCulling()
	Game.CullingObjectManager:Register_Creature(self)
	self.isCullingRegisted = true
end

function NCreature:UnRegistCulling()
	Game.CullingObjectManager:Unregister_Creature(self)
	self.isCullingRegisted = false
end

function NCreature:IsCullingVisible()
	return self.culling_visible
end

function NCreature:GetCullingDistanceLevel()
	return self.culling_distanceLevel
end

--begin culling group
--visible, -- int, not 0 is true, nil if not changed
--distanceLevel, -- int base 0, nil if not changed
-- {[0] <10,[1] 10~20 ,[2] 20~50 ,[3] >50}
function NCreature:CullingStateChange(visible,distanceLevel)
	if(visible~=nil) then
		self.culling_visible = (visible~=0 and true or false)
	end
	if(distanceLevel~=nil) then
		self.culling_distanceLevel = distanceLevel
	end

	local maskRange = Game.MapManager:GetCreatureMaskRange()
	if not self.culling_visible or self.culling_distanceLevel > maskRange then
		self:MaskOutOfMyRangeUI()
	else
		self:UnMaskOutOfMyRangeUI()
	end
end

function NCreature:MaskOutOfMyRangeUI()
	local reason = PUIVisibleReason.OutOfMyRange
	FunctionPlayerUI.Me():MaskHurtNum(self,reason,false)
	FunctionPlayerUI.Me():MaskChatSkill(self,reason,false)
	FunctionPlayerUI.Me():MaskEmoji(self,reason,false)
end

function NCreature:UnMaskOutOfMyRangeUI()
	local reason = PUIVisibleReason.OutOfMyRange
	FunctionPlayerUI.Me():UnMaskHurtNum(self,reason,false)
	FunctionPlayerUI.Me():UnMaskChatSkill(self,reason,false)
	FunctionPlayerUI.Me():UnMaskEmoji(self,reason,false)
end
--end culling group

-- override begin
function NCreature:DoConstruct(asArray, data)
	self.culling_visible = true
	self.culling_distanceLevel = 0
	self.dressed = false
	self.arroundMyselfTime = 0
	self.arroundMyselfLevel = -1
	self.data = data
	self.handInHandAction = HandInActionType.Clear -- 1:HandIn action, 2:InHand action
	self.originalScale = 1
	self.ai:Construct(self)
	self.logicTransform:Construct()
end

function NCreature:DoDeconstruct(asArray)
	self.onCarrier = false
	self:BeHatred(false)
	self:ClearSpEffect()
	self.ai:Deconstruct(self)
	if(self.data) then
		self.data:Destroy()
		self.data = nil
	end
	if( self.visibleHandler ~= nil) then
		self.visibleHandler:Destroy()
		self.visibleHandler = nil
	end
	self.logicTransform:Deconstruct()
	self:RemovePartner()
	self:RemoveHandNpc()
	self:ClearExpressNpc()
end

function NCreature:OnObserverDestroyed(k, obj)
	self:OnObserverEffectDestroyed(k,obj)
end
-- override end