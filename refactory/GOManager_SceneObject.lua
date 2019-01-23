GOManager_SceneObject = class("GOManager_SceneObject")

function GOManager_SceneObject:ctor()
	
end

function GOManager_SceneObject:Clear()
	self:SetFinder(nil)
	self:SetSceneAnimation(nil)
end

function GOManager_SceneObject:GetFinder()
	return self.finder
end

function GOManager_SceneObject:SetFinder(finder)
	self.finder = finder
	local sceneObjectMaterials = nil
	if nil ~= finder then
		sceneObjectMaterials = finder.sceneObjectMaterials
	end
	Game.EnviromentManager:SetSceneObjectMaterials(sceneObjectMaterials)
end

function GOManager_SceneObject:ClearFinder(obj)
	if nil ~= self.finder and self.finder.gameObject == obj.gameObject then
		self:SetFinder(nil)
		return true
	end
	return false
end

function GOManager_SceneObject:GetSceneAnimation()
	return self.sceneAnimation
end

function GOManager_SceneObject:SetSceneAnimation(a)
	self.sceneAnimation = a
	Game.MapManager:SetSceneAnimation(a)
end

function GOManager_SceneObject:ClearSceneAnimation(obj)
	if nil ~= self.sceneAnimation and self.sceneAnimation.gameObject == obj.gameObject then
		self:SetSceneAnimation(nil)
		return true
	end
	return false
end

function GOManager_SceneObject:RegisterGameObject(obj)
	local objType = obj.type
	local objID = obj.ID
	if Game.GameObjectType.SceneObjectFinder == objType then
		self:SetFinder(obj)
		return true
	elseif Game.GameObjectType.SceneAnimation == objType then
		self:SetSceneAnimation(obj)
		return true
	end
	return false
end

function GOManager_SceneObject:UnregisterGameObject(obj)
	local objType = obj.type
	if Game.GameObjectType.SceneObjectFinder == objType then
		if not self:ClearFinder(obj) then
			Debug_AssertFormat(false, "UnregisterSceneObjectFinder({0}) failed: {1}", obj, obj.ID)
			return false
		end
		return true
	elseif Game.GameObjectType.SceneAnimation == objType then
		if not self:ClearSceneAnimation(obj) then
			Debug_AssertFormat(false, "UnregisterSceneAnimation({0}) failed: {1}", obj, obj.ID)
			return false
		end
		return true
	end
	return false
end

