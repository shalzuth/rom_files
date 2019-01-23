UIShowCommand = class("UIShowCommand",pm.SimpleCommand)

function UIShowCommand:execute(note)
	UIManagerProxy.Instance:ShowUI(note.body)
end