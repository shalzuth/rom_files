local RestartGameCommand = class("RestartGameCommand",pm.SimpleCommand)

function RestartGameCommand:execute(note)
	FunctionNetError.Me():ErrorBackToLogin()
end

return RestartGameCommand