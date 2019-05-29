autoImport("LNode")
LRootNode = class("LRootNode", LNode)
function LRootNode:ctor(behaviorTree)
  LRootNode.super.ctor(self, behaviorTree)
  self.directeNode = nil
end
function LRootNode:SetDirecteNode(node)
  if self.directeNode ~= node then
    self.directeNode = node
    LNode.SetParentNode(self.directeNode, self)
  end
end
function LRootNode:OnUpdate()
  if self.directeNode == nil then
    return TaskState.Success
  end
  return self.directeNode:Update()
end
function LRootNode:OnStart()
  self.isStart = true
end
function LRootNode:OnEnd()
  LRootNode.super.OnEnd(self)
end
