--并行处理节点
autoImport("LActionNode")
SceneChangeUINode = class('SceneChangeUINode',LActionNode)

function SceneChangeUINode:DoAction()
	-- print(string.format("%s屏蔽UI", self.behaviorTree.blackBoard.creature.name))
	return TaskState.Running
end