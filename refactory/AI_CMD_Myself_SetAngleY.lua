
AI_CMD_Myself_SetAngleY = {}
setmetatable(AI_CMD_Myself_SetAngleY, {__index = AI_CMD_SetAngleY})

function AI_CMD_Myself_SetAngleY.ToString()
	return "AI_CMD_Myself_SetAngleY",AI_CMD_Myself_SetAngleY
end