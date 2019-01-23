--条件结点
autoImport("LConditionNode")
SceneFilterTargerCondNode = class('SceneFilterTargerCondNode',LConditionNode)

function SceneFilterTargerCondNode:ctor(behaviorTree,checkFunc,owner)
	SceneFilterTargerCondNode.super.ctor(self,behaviorTree)
	self.checkFunc = checkFunc
	self.owner = owner
end

function SceneFilterTargerCondNode:Check()
	if(self.owner) then
		return self.checkFunc(owner,self.behaviorTree.blackBoard.creature)
	else
		return self.checkFunc(self.behaviorTree.blackBoard.creature)
	end
end