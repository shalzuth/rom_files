InVisibleObjCmd = class("InVisibleObjCmd")

function InVisibleObjCmd:ctor()
end

function InVisibleObjCmd:End()
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.SceneAddRolesHandler,self)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveRoles,self.SceneRemoveRolesHandler,self)
end

function InVisibleObjCmd:Start()
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.SceneAddRolesHandler,self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveRoles,self.SceneRemoveRolesHandler,self)
end

function InVisibleObjCmd:IsInVisible(player)
end

function InVisibleObjCmd:SceneAddRolesHandler(players)
end

function InVisibleObjCmd:SceneRemoveRolesHandler(players)
end

-- function InVisibleObjCmd:ChangePlayerLayer(p,layer,needRecord)
-- 	local go = p.roleAgent and p.roleAgent.gameObject or nil
-- 	if(go and not GameObjectUtil.Instance:ObjectIsNULL(go) and go.layer ~= layer) then
-- 		if(needRecord) then p.orignVisibleLayer = go.layer end
-- 		GameObjectUtil.Instance:ChangeLayersRecursively(go,layer)
-- 	end
-- end