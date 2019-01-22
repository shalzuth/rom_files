local LoadSceneLoadedCommand = class("LoadSceneLoadedCommand",pm.SimpleCommand)

function LoadSceneLoadedCommand:execute(note)
	--TODO ??????GC???????????????
	--call gc
	self:UnLoadStartUI()
	SceneProxy.Instance:ASyncLoad()
end

function LoadSceneLoadedCommand:UnLoadStartUI()
	ResourceManager.Instance:SUnLoad(ResourcePathHelper.UIView("StartGamePanel"), false);
	ResourceManager.Instance:SUnLoad(ResourcePathHelper.UIView("CreateRoleViewV2"), false);
end

return LoadSceneLoadedCommand