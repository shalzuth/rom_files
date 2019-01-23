local LoadSceneLoadedCommand = class("LoadSceneLoadedCommand",pm.SimpleCommand)

function LoadSceneLoadedCommand:execute(note)
	--TODO 调用GC，释放内存
	--call gc
	self:UnLoadStartUI()
	SceneProxy.Instance:ASyncLoad()
end

function LoadSceneLoadedCommand:UnLoadStartUI()
	ResourceManager.Instance:SUnLoad(ResourcePathHelper.UIView("StartGamePanel"), false);
	ResourceManager.Instance:SUnLoad(ResourcePathHelper.UIView("CreateRoleViewV2"), false);
end

return LoadSceneLoadedCommand