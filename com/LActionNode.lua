--并行处理节点
autoImport("LNode")
LActionNode = class('LActionNode',LNode)

function LActionNode:DoAction()
	return TaskState.Running
end

function LActionNode:Update()
	return self:DoAction()
	-- return TaskState.Success;
end