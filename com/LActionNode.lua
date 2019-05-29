autoImport("LNode")
LActionNode = class("LActionNode", LNode)
function LActionNode:DoAction()
  return TaskState.Running
end
function LActionNode:Update()
  return self:DoAction()
end
