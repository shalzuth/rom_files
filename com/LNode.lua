LNode = class("LNode")
TaskState = {
  Failure = 0,
  Inactive = 1,
  Success = 2,
  Running = 3
}
function LNode:ctor(behaviorTree)
  self.behaviorTree = behaviorTree
  self.parentNode = nil
  self.isStart = false
  self.isPasued = false
  self.priority = 0
end
function LNode.StaticUpdate(node)
  if node == nil or node.behaviorTree == nil or node.isPasued then
    return TaskState.Inactive
  end
  if not node.isStart then
    node:OnStart()
  end
  local state = node:OnUpdate()
  if state == TaskState.Failure or state == TaskState.Success then
    node.OnEnd()
  end
  return state
end
function LNode.SetParentNode(node, parent)
  node.parentNode = parent
end
function LNode:SetPriority(value)
  if self.priority ~= value then
    self.priority = value
  end
end
function LNode:SetIsPaused(value)
  if self.isPasued ~= value then
    self.isPasued = value
    if self.isPasued then
      self:OnPasue()
    else
      self:OnResume()
    end
  end
end
function LNode:OnStart()
  self.isStart = true
end
function LNode:OnEnd()
end
function LNode:OnPasue()
end
function LNode:OnResume()
end
function LNode:OnUpdate()
  if self.isPasued then
    return TaskState.Inactive
  end
  return TaskState.Running
end
function LNode:Update()
  return LNode.StaticUpdate(self)
end
