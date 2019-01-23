--条件结点
autoImport("LNode")
LConditionNode = class('LConditionNode',LNode)

function LConditionNode:ctor(behaviorTree,checkFunc,owner,args)
	LConditionNode.super.ctor(self,behaviorTree)
	self.checkFunc = checkFunc
	self.owner = owner
	self.args = args
end

function LConditionNode:Check()
	if(owner) then
		return self.checkFunc(owner,self.args)
	else
		return self.checkFunc(self.args)
	end
end

function LConditionNode:Update()
	if(self.behaviorTree == nil) then
		return TaskState.Failure
	end
	return self:Check() and TaskState.Success or TaskState.Failure
end