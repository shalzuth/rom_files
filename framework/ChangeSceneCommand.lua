local ChangeSceneCommand = class("ChangeSceneCommand",pm.SimpleCommand)

--这里的data都为服务器发来的数据结构ChangeSceneUserCmd
function ChangeSceneCommand:execute(note)
	local data = note.body
	if(note.type == LoadSceneEvent.StartLoad) then
		FunctionChangeScene.Me():TryLoadScene(data)
	else
		FunctionChangeScene.Me():LoadedScene(data)
	end
end
return ChangeSceneCommand