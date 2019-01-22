--??????????????????
autoImport("LActionNode")
SceneChangeUINode = class('SceneChangeUINode',LActionNode)

function SceneChangeUINode:DoAction()
	-- print(string.format("%s??????UI", self.behaviorTree.blackBoard.creature.name))
	return TaskState.Running
end