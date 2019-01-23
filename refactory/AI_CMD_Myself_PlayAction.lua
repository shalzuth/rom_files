AI_CMD_Myself_PlayAction = {}
setmetatable(AI_CMD_Myself_PlayAction, {__index = AI_CMD_PlayAction})

function AI_CMD_Myself_PlayAction.ToString()
	return "AI_CMD_Myself_PlayAction",AI_CMD_Myself_PlayAction
end