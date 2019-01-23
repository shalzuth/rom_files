--errorLog
autoImport("SceneFilterTargerCondNode")
autoImport("SceneTargetFilter")
autoImport("SceneRangeFilter")
autoImport("SceneFiltersActions")

SceneFilterNode = class('SceneFilterNode')

SceneFilterNode.NodePool = nil

function SceneFilterNode.InitNodePool()
	SceneFilterNode.NodePool = {}
	SceneFilterNode.NodePool.Targets = {}
	SceneFilterNode.NodePool.TargetNodes = {}
	SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Player] = SceneTargetFilter.CheckIsPlayer
	SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Pet] = SceneTargetFilter.CheckIsPet
	SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Npc] = SceneTargetFilter.CheckIsNpc
	SceneFilterNode.NodePool.Targets[SceneFilterDefine.Target.Monster] = SceneTargetFilter.CheckIsMonster
	SceneFilterNode.NodePool.Ranges = {}
	SceneFilterNode.NodePool.RangeNodes = {}
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.NotGuildOther] = SceneRangeFilter.CheckNotGuildOther
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.SameGuild] = SceneRangeFilter.CheckSameGuild
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.NotTeamOther] = SceneRangeFilter.CheckNotTeamOther
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.SameTeam] = SceneRangeFilter.CheckSameTeam
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.AllOther] = SceneRangeFilter.CheckAllOther
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.NotTeam] = SceneRangeFilter.CheckNotTeam
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.All] = SceneRangeFilter.CheckAll
	SceneFilterNode.NodePool.Ranges[SceneFilterDefine.Range.Self] = SceneRangeFilter.CheckSelf
end

function SceneFilterNode.GetTargetConNode(targetType,tree)
	local cond = SceneFilterNode.NodePool.TargetNodes[targetType]
	if(not cond) then
		cond = SceneFilterTargerCondNode.new(tree,SceneFilterNode.NodePool.Targets[targetType])
		SceneFilterNode.NodePool.TargetNodes[targetType] = cond
	end
	return cond
end

function SceneFilterNode.GetRangeConNode(rangeType,tree)
	local cond = SceneFilterNode.NodePool.RangeNodes[rangeType]
	if(not cond) then
		cond = SceneFilterTargerCondNode.new(tree,SceneFilterNode.NodePool.Ranges[rangeType])
		SceneFilterNode.NodePool.RangeNodes[rangeType] = cond
	end
	return cond
end

function SceneFilterNode:ctor(behaviourTree,groupID)
	self.enabled = false
	self.groupID = groupID
	self.tree = behaviourTree
	self.selfRootSelector = LSelectorNode.new(self.tree)
	self.sequenceNode = LSequenceNode.new(self.tree)
	self.targetSelector = LSelectorNode.new(self.tree)
	self.rangeSelector = LSequenceNode.new(self.tree)
	self.sequenceNode:AddCondNode(self.targetSelector)
	self.sequenceNode:AddCondNode(self.rangeSelector)
	self.sequenceNode:AddNode(SceneFilterActiveNode.new(self.tree))
	--
	self.selfRootSelector:AddNode(SceneFilterSetDataAction.new(self.tree,"groupNode",self))
	self.selfRootSelector:AddNode(self.sequenceNode)
	self.selfRootSelector:AddNode(SceneFilterInActiveNode.new(self.tree))
	--
	self.data = SceneFilterNodeData.new()
	self.filterMap = {}
	self.filterCount = 0
	if(not SceneFilterNode.NodePool) then
		SceneFilterNode.InitNodePool()
	end
end

function SceneFilterNode:HasFilter()
	for k,v in pairs(self.filterMap) do
		return true
	end
	return false
end

function SceneFilterNode:SetEnable(value)
	if(self.enabled~=value) then
		self.enabled = value
		if(value)then
			self.tree:GetRootNode().directeNode:AddNode(self.selfRootSelector)
		else
			self.tree:GetRootNode().directeNode:RemoveNode(self.selfRootSelector)
		end
	end
end

function SceneFilterNode:IsEnabled()
	return self.enabled
end

function SceneFilterNode:AddFilter(id)
	if(not self.filterMap[id]) then
		local conf = Table_ScreenFilter[id]
		self.filterMap[id] = conf
		if(conf) then
			self.filterCount = self.filterCount + 1
			--add target
			local target
			for i=1,#conf.Targets do
				target = conf.Targets[i]
				if(SceneFilterNode.NodePool.Targets[target]) then
					if(self.data:AddTarget(target)) then
						self.targetSelector:AddNode(SceneFilterNode.GetTargetConNode(target,self.tree))
					end
				else
					errorLog("屏蔽ID %s 中配置的target %s程序未支持",id,target)
				end
			end
			self:_AddRanges(conf.Range)
		end
		return true
	end
	return false
end

function SceneFilterNode:_AddRanges(_Ranges)
	--add range
	local range
	for i=1,#_Ranges do
		range = _Ranges[i]
		if(SceneFilterNode.NodePool.Ranges[range]) then
			if(self.data:AddRange(range)) then
				self.rangeSelector:AddCondNode(SceneFilterNode.GetRangeConNode(range,self.tree))
			end
		else
			errorLog("屏蔽ID %s 中配置的range %s程序未支持",id,range)
		end
	end
end

function SceneFilterNode:RemoveFilter(id)
	if(self.filterMap[id]) then
		self.filterMap[id] = nil
		SceneFilterProxy.Instance:SceneFilterUnCheckById(id)
		local conf = Table_ScreenFilter[id]
		if(conf) then
			self.filterCount = self.filterCount - 1
			--remove target
			local target
			for i=1,#conf.Targets do
				target = conf.Targets[i]
				if(self.data:RemoveTarget(target)) then
					self.targetSelector:RemoveNode(SceneFilterNode.GetTargetConNode(target,self.tree))
				end
			end
			--remove range
			self:_RemoveRanges(conf.Range)
		end
	end
end

function SceneFilterNode:_RemoveRanges(_Ranges)
	--remove range
	local range
	for i=1,#_Ranges do
		range = _Ranges[i]
		if(self.data:RemoveRange(range)) then
			self.rangeSelector:RemoveCondNode(SceneFilterNode.GetRangeConNode(range,self.tree))
		end
	end
end

function SceneFilterNode:RemoveAll()
	for k,v in pairs(self.filterMap) do
		self:RemoveFilter(k)
	end
	self.filterCount = 0
end

function SceneFilterNode:GetFilter(id)
	return self.filterMap[id]
end

SceneFilterNodeData = class('SceneFilterNodeData')

function SceneFilterNodeData:ctor()
	self.targetCount = {}
	self.rangeCount = {}
end

function SceneFilterNodeData:Remove(tab,checkType)
	local count = tab[checkType] or 0
	tab[checkType] = count>0 and count -1 or 0
	--返回是否删除后变0
	return count == 1
end

function SceneFilterNodeData:Add(tab,checkType)
	local count = tab[checkType] or 0
	tab[checkType] = count + 1
	--返回是否是第一次添加
	return count == 0
end

function SceneFilterNodeData:AddTarget(targetType)
	return self:Add(self.targetCount,targetType)
end

function SceneFilterNodeData:RemoveTarget(targetType)
	return self:Remove(self.targetCount,targetType)
end

function SceneFilterNodeData:AddRange(rangeType)
	return self:Add(self.rangeCount,rangeType)
end

function SceneFilterNodeData:RemoveRange(rangeType)
	return self:Remove(self.rangeCount,rangeType)
end