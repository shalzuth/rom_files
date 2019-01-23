--并行处理节点
autoImport("LParentNode")
LParallelNode = class('LParallelNode',LParentNode)

function LParallelNode:Update()
	local state
	for i=1,#self.childrenNodes do
		self.childrenNodes [i]:Update()
	end
	return TaskState.Running;
end