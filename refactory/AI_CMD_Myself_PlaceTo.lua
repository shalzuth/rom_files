AI_CMD_Myself_PlaceTo = {}
setmetatable(AI_CMD_Myself_PlaceTo, {__index = AI_CMD_PlaceTo})

local InterruptCameraSmoothDistance = 10
local tempVector3 = LuaVector3.zero

function AI_CMD_Myself_PlaceTo.Start(self, time, deltaTime, creature)
	local p = creature:GetPosition()
	tempVector3:Set(p[1],p[2],p[3])
	local ret = AI_CMD_PlaceTo.Start(self, time, deltaTime, creature)
	p = creature:GetPosition()
	Game.Map2DManager:SetCurrentMap2D(p)
	GameFacade.Instance:sendNotification(SceneGlobalEvent.Map2DChanged, Game.Map2DManager:GetMap2D())
	
	EventManager.Me():DispatchEvent(MyselfEvent.PlaceTo, p)
	if VectorUtility.DistanceXZ(tempVector3, p) > InterruptCameraSmoothDistance then
		creature.ai:DelayInterruptCameraSmooth(1)
	end
	return ret
end

function AI_CMD_Myself_PlaceTo.ToString()
	return "AI_CMD_Myself_PlaceTo",AI_CMD_Myself_PlaceTo
end