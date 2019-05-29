autoImport("LActionNode")
SceneChangeUINode = class("SceneChangeUINode", LActionNode)
function SceneChangeUINode:DoAction()
  return TaskState.Running
end
