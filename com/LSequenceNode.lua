--顺序结点,逻辑与（执行到第一个为failure的节点便停止
autoImport("LParentNode")
LSequenceNode = class('LSequenceNode',LParentNode)

function LSequenceNode:ctor(behaviorTree)
	LSequenceNode.super.ctor(self,behaviorTree)
	self.conditionNodes = {}
end

function LSequenceNode:AddCondNode(node)
	if(TableUtil.ArrayIndexOf(self.conditionNodes,node)==0) then
		self.conditionNodes[#self.conditionNodes + 1] = node
	end
	LNode.SetParentNode (node, self);
end

function LSequenceNode:RemoveCondNode( node )
	if(TableUtil.ArrayIndexOf(self.conditionNodes,node)>0) then
		TableUtil.Remove(self.conditionNodes,node)
	end
	LNode.SetParentNode (node, nil);
end

function LSequenceNode:OnConditionNodesUpdate()
	if(#self.conditionNodes == 0) then
		return TaskState.Success
	end
	local node,state
	for i=1,#self.conditionNodes do
		node = self.conditionNodes [i]
		state = node:Update()
		if(state == TaskState.Failure) then
			return state
		end
	end
	return TaskState.Success
end

function LSequenceNode:OnChildrenNodesUpdate()
	if(#self.childrenNodes == 0) then
		return TaskState.Success
	end
	local node,state
	for i=1,#self.childrenNodes do
		node = self.childrenNodes [i]
		state = node:Update()
		if (state == TaskState.Failure) then
			return state
		end
	end
	return state
end

function LSequenceNode:Update()
	local result = self:OnConditionNodesUpdate()
	-- print("sequence",result)
	if(result == TaskState.Success) then
		result = self:OnChildrenNodesUpdate ()
	end
	return result
end