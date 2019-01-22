using "UnityEngine"
using "Ghost.Utils"
using "RO"

require ("Script.Main.Import")

autoImport ("oop")
autoImport ("LuaConfig")
autoImport ("ZhString")
autoImport ("DelegateUtil")

FunctionSystem = {
	roleIdleAIMap = {},
	extraInputListener = DelegateUtil.new(),
}

-- ????????????Mission
function FunctionSystem.InterruptMyself()
	local myself = Game.Myself
	if myself == nil or myself:IsDead() then
		return false
	end
	local inputManager = InputManager.Instance
	if nil ~= inputManager then
		inputManager:Interrupt()
	end
	myself.ai:TryBreakAll(Time.time, Time.deltaTime, myself)
	return true
end

function FunctionSystem.WeakInterruptMyself(ignoreAction)
	local myself = Game.Myself
	if myself == nil or myself:IsDead() then
		return false
	end
	local inputManager = InputManager.Instance
	if nil ~= inputManager then
		inputManager:Interrupt()
	end
	myself.ai:WeakBreak(Time.time, Time.deltaTime, myself, ignoreAction)
	return true
end

function FunctionSystem.InterruptMyselfAll()
 	FunctionSystem.InterruptMyself();
	FunctionSystem.InterruptMyselfAI()
end

function FunctionSystem.InterruptMyselfAI()
	FunctionSystem.InterruptMyFollow();
	FunctionSystem.InterruptMyAutoBattle();
	FunctionSystem.InterruptMyMissionCommand()
end

function FunctionSystem.InterruptMyFollow()
	ServiceNUserProxy.Instance:CallFollowerUser(0) 
	Game.Myself:Client_SetFollowLeader(0);
end

function FunctionSystem.InterruptMyAutoBattle()
	Game.AutoBattleManager:AutoBattleOff();
end

function FunctionSystem.InterruptMyMissionCommand()
	Game.Myself:Client_SetMissionCommand(nil)
end


function FunctionSystem.InterruptCreature(creature)
	if creature:IsDead() then
		return false
	end
	creature.ai:BreakAll(Time.time, Time.deltaTime, creature)
	return true
end

-- function FunctionSystem.GetRoleIdleAI(roleID)
-- 	local roleIdleAI = FunctionSystem.roleIdleAIMap[roleID]
-- 	if nil == roleIdleAI then
-- 		roleIdleAI = DelegateUtil.new()
-- 		FunctionSystem.roleIdleAIMap[roleID] = roleIdleAI
-- 	end
-- 	return roleIdleAI
-- 	return nil
-- end

-- function FunctionSystem.SetRoleIdleAI(owner, role, AI, interruptedCallback)
-- 	local roleIdleAI = FunctionSystem.GetRoleIdleAI(role.data.ID)
-- 	roleIdleAI:SetDelegate(owner, function()
-- 		if role:IsCurrentIdleAI(AI) then
-- 			return false
-- 		end
-- 		role:SetIdleAI(AI)
-- 		return true
-- 	end, interruptedCallback)
-- 	return false
-- end

-- function FunctionSystem.ClearRoleIdleAI(owner, role, AI)
-- 	local roleIdleAI = FunctionSystem.GetRoleIdleAI(role.data.ID)
-- 	return roleIdleAI:ClearDelegate(owner, function()
-- 			role:ClearIdleAI(AI)
-- 		end)
-- 	return false
-- end

-- function FunctionSystem.ForceClearRoleIdleAI(role)
-- 	FunctionSystem.SetRoleIdleAI(nil, role, nil, nil)
-- end

function FunctionSystem.SetExtraInputListener(owner, listener, interruptedCallback,immediately)
	FunctionSystem.extraInputListener:SetDelegate(owner, function()
		local inputManager = InputManager.Instance
		if nil == inputManager then
			return false
		end
		if inputManager:IsCurrentExtraInputListener(listener) then
			return false
		end
		inputManager:SetExtraInputListener(listener,immediately)
		return true
	end, interruptedCallback)
end

function FunctionSystem.ClearExtraInputListener(owner, listener)
	FunctionSystem.extraInputListener:ClearDelegate(owner, function()
		local inputManager = InputManager.Instance
		if nil == inputManager then
			return
		end
		inputManager:ClearExtraInputListener(listener)
	end)
end

autoImport ("WorldTeleport")

autoImport ("FunctionUnLockFunc")
autoImport ("AutoBattle")
autoImport ("AutoBattleManager")

autoImport ("FunctionSceneItemCommand")
autoImport ("FunctionBuff")
autoImport ("FunctionCameraEffect")
autoImport ("FunctionCameraAdditiveEffect")
autoImport ("CameraAdditiveEffectManager")
autoImport ("FunctionSkillTargetPointLauncher")
autoImport ("FunctionCDCommand")
autoImport ("FunctionBus")
autoImport ("FunctionCheck")

autoImport ("FunctionVisibleSkill")
autoImport ("FunctionPlayerUI")
autoImport ("FunctionSceneFilter")
autoImport ("FunctionPurify")
autoImport ("FunctionDungeon")
autoImport ("FunctionBGMCmd")
autoImport ("FunctionSkillSimulate")
autoImport ("FunctionSelectCharacter")
autoImport ("FunctionPhoto")
autoImport ("FunctionScenicSpot")
autoImport ("FunctionSkillEnableCheck")
autoImport ("FunctionMapEnd")
autoImport ("FunctionGuide")
autoImport ("FunctionQuest")
autoImport ("FunctionQuestDisChecker")
autoImport ("FunctionGuideChecker")

autoImport ("FunctionDamageNum")
autoImport ("FunctionSkill")
autoImport ("FunctionNetError")
autoImport ("FunctionGameState")
autoImport ("FunctionItemFunc")
autoImport ("FunctionNpcFunc")
autoImport ("FunctionPlayerTip")
autoImport ("FunctionBarrage")
autoImport ("FunctionChatIO")
autoImport ("FunctionChatSpeech")
autoImport ("FunctionAppStateMonitor")
autoImport ("FunctionChangeScene")
autoImport ("FunctionItemCompare")
autoImport ("FunctionFirstTime")
autoImport ("FuncShortCutFunc")
autoImport ("FunctionMusicBox")
autoImport ("FunctionPlayerPrefs")
autoImport ("FunctionTransform")
autoImport ("FunctionXO")
autoImport ("FunctionTeam")
autoImport ("FunctionVisitNpc")
autoImport ("FunctionRepairSeal")
autoImport ("FunctionLogin")
autoImport ("FunctionPlayerHead")
autoImport ("FunctionPerformanceSetting")
autoImport ("FunctionTest")
autoImport ("FunctionItemTrade")
autoImport ("FunctionPreload")
autoImport ("FunctionGuild")
autoImport ("FunctionMaskWord")
autoImport ("FunctionDialogEvent")
autoImport ("FunctionShakeTree")
autoImport ("FunctionMonster")
autoImport ("FunctionTempItem")
autoImport ("FunctionActivity")
autoImport ("FunctionSecurity")
autoImport ("FunctionDonateItem")
autoImport ("FunctionFood")
autoImport ("FunctionPet")
autoImport ("FunctionWedding")
