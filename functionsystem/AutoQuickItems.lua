AutoQuickItems = class("AutoQuickItems")

LogicCommands = {
	-- creature begin
	GetProperty = function(creature, name)
    	return creature:GetProperty(name)
	end,
	GetPosition = function(creature)
    	return creature.roleAgent.position
	end,
	-- creature end

	-- myself begin
	GetMyProperty = function(name)
    	return LogicCommands.GetProperty(Game.Myself, name)
	end,
	GetMyPosition = function()
    	return LogicCommands.GetPosition(Game.Myself)
	end,
	GetMyRelativeHP = function()
		local Hp = LogicCommands.GetMyProperty("Hp")
    	local MaxHp = LogicCommands.GetMyProperty("MaxHp")
    	return Hp/MaxHp
	end,
	GetMyRelativeSP = function()
		local Sp = LogicCommands.GetMyProperty("Sp")
    	local MaxSp = LogicCommands.GetMyProperty("MaxSp")
    	return Sp/MaxSp
	end,
	MiniAndMVPAroundMe = function(range)
		local myPosition = LogicCommands.GetMyPosition()
		local myPositionXZ = Vector2(myPosition.x, myPosition.z)
		return SceneNpcProxy.Instance:PickNpcs(function(npc)
			local detailedType = npc:GetDetailedType()
			if nil == detailedType then
				return false
			end
			if NpcData.NpcDetailedType.MINI ~= detailedType 
				and NpcData.NpcDetailedType.MVP ~= detailedType then
				return false
			end

			if nil == npc.roleAgent then
				return false
			end

			local npcPosition = LogicCommands.GetPosition(npc)
			local npcPositionXZ = Vector2(npcPosition.x, npcPosition.z)
			local distance = Vector2.Distance(myPositionXZ, npcPositionXZ)
			return distance < range
		end)
	end,
	-- myself end

	-- scene begin
	PVP = function()
		return SceneProxy.Instance:IsPvPScene()
	end,
	GVG = function()
		return false -- Not implemented
	end,
	-- scene end
}

function AutoQuickItems.Use(config, skillProxy, shortCutProxy)
	for i = 1, #config.skills do
		-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems.Use</color> 1.1.{0}",i)
		local info = config.skills[i]
		if skillProxy:HasLearnedSkillBySort(info.skill) 
			and (nil == info.Condition or info.Condition(LogicCommands)) then
			-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems.Use</color> 1.2.{0}",i)
			for j = 1, #info.items do
				-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems.Use</color> 1.3.{0}.{1}",i,j)
				local itemID = info.items[j]
				local itemData = shortCutProxy:GetValidShortItem(itemID)
				if nil ~= itemData then
					-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems.Use</color> 1.4.{0}.{1}",i,j)
					FunctionItemFunc.DoUseItem(itemData);
					return true
				end
			end
		end
	end
	return false
end

function AutoQuickItems:ctor()
	self.nextTime = {}
end

function AutoQuickItems:On()
	if self.on then
		return
	end

	self.on = true
	TimeTickManager.Me():CreateTick(0,300,self.Update,self)
end

function AutoQuickItems:Off()
	if not self.on then
		return
	end

	self.on = false
	TimeTickManager.Me():ClearTick(self)
end

function AutoQuickItems:Update(deltaTime)
	-- LogUtility.Info("<color=yellow>AutoQuickItems</color> 0")
	local configs = CommonFun.AutoItemSkills
	if nil == configs then
		-- LogUtility.Info("<color=yellow>AutoQuickItems</color> -1")
		return
	end
	local user = Game.Myself
	if nil == user then
		-- LogUtility.Info("<color=yellow>AutoQuickItems</color> -2")
		return
	end
	local skillProxy = SkillProxy.Instance
	local shortCutProxy = ShortCutProxy.Instance
	if nil == skillProxy then
		-- LogUtility.Info("<color=yellow>AutoQuickItems</color> -3")
		return
	end
	if nil == shortCutProxy then
		-- LogUtility.Info("<color=yellow>AutoQuickItems</color> -4")
		return
	end
	-- LogUtility.Info("<color=yellow>AutoQuickItems</color> 1")
	local time = Time.time
	for i = 1, #configs do
		-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems</color> 2.1.{0}",i)
		local config = configs[i]
		local nextTime = self.nextTime[i]
		if nil == nextTime or time > nextTime then
			-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems</color> 2.2.{0}",i)
			if (nil == config.Condition or config.Condition(LogicCommands)) 
				and AutoQuickItems.Use(config, skillProxy, shortCutProxy) then
				-- LogUtility.InfoFormat("<color=yellow>AutoQuickItems</color> 2.3.{0}",i)
				nextTime = time + config.interval
				self.nextTime[i] = nextTime
			end
		end
	end
end




