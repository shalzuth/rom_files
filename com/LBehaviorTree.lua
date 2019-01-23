autoImport("LRootNode")
autoImport("LActionNode")
autoImport("LConditionNode")
autoImport("LParentNode")
autoImport("LParallelNode")
autoImport("LSequenceNode")
autoImport("LSelectorNode")

LBehaviorTree = class('LBehaviorTree')

function LBehaviorTree:ctor(name)
	self.Name = name
	self.rootNode = nil
	self.paused = false
	self.isRunning = false
	self.curState = nil
	self.isComplete = false
	self.blackBoard = {}
end

function LBehaviorTree:Run()
	if(not self.isRunning) then
		self.isRunning = true
	end
end

function LBehaviorTree:Pause()
	if (not self.isRunning or paused) then
		return
	end
	paused = true;
end

function LBehaviorTree:Resume()
	if (not self.isRunning or not paused) then
		return
	end
	paused = false;
end

function LBehaviorTree:GetRootNode(autoGenerate)
	if(autoGenerate and self.rootNode==nil) then
		self.rootNode = LRootNode.new(self)
	end
	return self.rootNode
end

function LBehaviorTree:ClearRootNode()
	self.rootNode = nil
end

function LBehaviorTree:OnUpdate()
	if(not self.isRunning or self.rootNode == nil) then
		return TaskState.Failure
	end
	if(self.paused) then
		return TaskState.Inactive;
	end
	local result = self.rootNode:Update ()
	return result
end

function LBehaviorTree:Update()
	self.curState = self:OnUpdate()
	return self.curState
end