--行为树根节点
autoImport("LNode")
LRootNode = class('LRootNode',LNode)

function LRootNode:ctor(behaviorTree)
	LRootNode.super.ctor(self,behaviorTree)
	self.directeNode = nil
end

function LRootNode:SetDirecteNode(node)
	if(self.directeNode~=node) then
		self.directeNode=node
		LNode.SetParentNode (self.directeNode, self)
	end
end

function LRootNode:OnUpdate()
	if (self.directeNode == nil) then
		return TaskState.Success
	end
	return self.directeNode:Update ()
end

function LRootNode:OnStart()
	self.isStart = true
	-- print(string.format("BT:%s, 开始",self.behaviorTree.Name))
end

function LRootNode:OnEnd()
	LRootNode.super.OnEnd(self)
	-- print(string.format("BT:%s, 结束",self.behaviorTree.Name))
end