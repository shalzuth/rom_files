FunctionTransform = class("FunctionTransform")

function FunctionTransform.Me()
	if nil == FunctionTransform.me then
		FunctionTransform.me = FunctionTransform.new()
	end
	return FunctionTransform.me
end

function FunctionTransform:ctor()
	-- self.transformedPlayers = {}
end

function FunctionTransform:Reset()
end

--player变身为transformID
function FunctionTransform:TransformTo(player,transformID)
	player.data.transformData:SetTransformID(player,transformID)
	-- self.transformedPlayers[player.data.id] = player.data.id
	if(player:GetCreatureType() == Creature_Type.Me) then
		EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.OnAddUsersHandler, self)
		EventManager.Me():AddEventListener(SceneUserEvent.ChangeProfession, self.TrySetOtherTransformedAtk, self)
		local isTransformAtkMap = self:IsTransformAtkMap()
		if(isTransformAtkMap) then
			self:OnAddUsersHandler(NSceneUserProxy.Instance:GetAll())
		end
	else
		player.data:Camp_SetIsSelfTransformedAtk(self:IsTransformAtkMap())
	end
	-- local data = player.transformData:GetNpcOrMonsterData()
	-- if(data ~= nil) then
	-- 	printRed( data.FloatHeight)
	-- 	player.floatHeight = data.FloatHeight
	-- end
end

--结束变身
function FunctionTransform:EndTransform(player)
	player.data.transformData:SetTransformID(player,0)
	-- printRed( 0)
	-- player.floatHeight = 0
	self:RemovePlayer(player)
end

--移除
function FunctionTransform:RemovePlayer(player)
	if(player) then
		if(player:GetCreatureType() == Creature_Type.Me) then
			EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.OnAddUsersHandler, self)
			EventManager.Me():RemoveEventListener(SceneUserEvent.ChangeProfession, self.TrySetOtherTransformedAtk, self)
			local otherPlayers = NSceneUserProxy.Instance:GetAll()
			for k,v in pairs(otherPlayers) do
				v.data:Camp_SetIsOtherTransformedAtk(false)
			end
		else
			player.data:Camp_SetIsSelfTransformedAtk(false)
		end
		-- self.transformedPlayers[player.data.id] = nil
	end
end

function FunctionTransform:IsTransformAtkMap()
	if(Game.MapManager:IsPVPMode_PoringFight())then
		return true
	end
	return SceneProxy.Instance.currentScene and SceneProxy.Instance.currentScene:CanTransformAtk() or false
end

function FunctionTransform:OnAddUsersHandler(players)
	if(self:IsTransformAtkMap()) then
		for k,player in pairs(players) do
			self:TrySetOtherTransformedAtk(player)
		end
	end
end

function FunctionTransform:TrySetOtherTransformedAtk(player)
	-- LogUtility.Info(player.data:GetProfesstion())
	-- LogUtility.Info(player.data.id)
	if(player and player.data:GetProfesstion() ~= RoleDefines_Profession.Novice and self:IsTransformAtkMap()) then
		player.data:Camp_SetIsOtherTransformedAtk(true)
	end
end