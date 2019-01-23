
AI_CMD_Myself_SetScale = {}
setmetatable(AI_CMD_Myself_SetScale, {__index = AI_CMD_SetScale})

function AI_CMD_Myself_SetScale.ToString()
	return "AI_CMD_Myself_SetScale",AI_CMD_Myself_SetScale
end