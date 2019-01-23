autoImport("LNode")
LParentNode = class('LParentNode',LNode)

function LParentNode:ctor(behaviorTree)
	LParentNode.super.ctor(self,behaviorTree)
	self.childrenNodes = {}
end

function LParentNode:AddNode( node )
	if(TableUtil.ArrayIndexOf(self.childrenNodes,node)==0) then
		self.childrenNodes[#self.childrenNodes + 1] = node
	end
	LNode.SetParentNode (node, self);
end

function LParentNode:RemoveNode( node )
	if(TableUtil.ArrayIndexOf(self.childrenNodes,node)>0) then
		TableUtil.Remove(self.childrenNodes,node)
	end
	LNode.SetParentNode (node, nil);
end

function LParentNode:Update()
	local node
	local state
	for i=1,#self.childrenNodes do
		node = self.childrenNodes [i];
		state = node:Update()
		-- if (state == TaskState.Inactive) then
		-- 	continue;
		if (state == TaskState.Success) then
			return TaskState.Running;
		end
	end
	return TaskState.Failure;
end