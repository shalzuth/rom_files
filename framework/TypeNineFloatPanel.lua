autoImport("EventDispatcher")
TypeNineFloatPanel = class("TypeNineFloatPanel", SubView)

--按组区分，组中包含的排序id，以及组中的最多显示数量
TypeNineFloatPanel.GrpInnerCount = {
	[1] = {groupSort = 1,sortIDs = {1,2},count = 4},
	[2] = {groupSort = 2,sortIDs = {3},count =1},
	[3] = {groupSort = 3,sortIDs = {4},count =1},
}

TypeNineFloatPanel.GroupFinishShow = "TypeNineFloatPanel.GroupFinishShow"

function TypeNineFloatPanel:Init()
	self.gameObject = self:FindGO("MiddleType9")
	--当前正在动画的组
	self.showingGrp = nil
	--当前等待的动画组
	self.waitingGrps = {}
end

function TypeNineFloatPanel:AddSysMsg(sortID,msg)
	local config = self:FindGrpConfig(sortID)
	self:AddMsgToGroup(config,sortID,msg)

	--尝试直接开始
	self:PlayShowGrp()
end

function TypeNineFloatPanel:Clear()
	self:_ClearWaitingGrp()
end

function TypeNineFloatPanel:_ClearWaitingGrp()
	if(self.waitingGrps) then
		for i=1,#self.waitingGrps do
			self.waitingGrps[i]:Destroy()
			self.waitingGrps[i] = nil
		end
	end
end

function TypeNineFloatPanel:FindGrpConfig(sortID)
	for k,v in pairs(TypeNineFloatPanel.GrpInnerCount) do
		for i=1,#v.sortIDs do
			if(v.sortIDs[i] == sortID) then
				return v
			end
		end
	end
end

function TypeNineFloatPanel:AddMsgToGroup(config,sortID,msg)
	local fitGrp = self:FindFitGroup(config)
	if(fitGrp == nil) then
		fitGrp = self:CreateGroup(config)
		self.waitingGrps[#self.waitingGrps + 1] = fitGrp
		self:SortWaitingGrps()
	end
	fitGrp:AddMsg(sortID,msg)
end

function TypeNineFloatPanel:CreateGroup(config)
	local grp = TypeNineFloatGrp.CreateAsTable(config.groupSort)
	grp:SetParent(self.gameObject)
	grp:SetCompleteCallback(self.HandleGrpFinish,self)
	return grp
end

function TypeNineFloatPanel:FindFitGroup(config)
	if(self:CheckGrp(config,self.showingGrp)) then
		return self.showingGrp
	end
	local group
	for i=1,#self.waitingGrps do
		group = self.waitingGrps[i]
		--数量满足
		if(self:CheckGrp(config,group)) then
			return group
		end
	end
	return nil
end

function TypeNineFloatPanel:CheckGrp(config,group)
	if(group and group:GetCount() < config.count and group.configID == config.groupSort and not group.cannotAddMsg) then
		return true
	end
	return false
end

function TypeNineFloatPanel:SortWaitingGrps()
	table.sort( self.waitingGrps, function (l,r)
			return l.configID<r.configID
	end )
end

function TypeNineFloatPanel:PlayShowGrp()
	if(self.showingGrp==nil) then
		if(#self.waitingGrps>0) then
			self.showingGrp = table.remove(self.waitingGrps,1)
			self.showingGrp:StartShow()
		end
	end
end

function TypeNineFloatPanel:HandleGrpFinish()
	self.showingGrp:Destroy()
	self.showingGrp = nil
	self:PlayShowGrp()
end


TypeNineFloatGrp = reusableClass("TypeNineFloatGrp")
TypeNineFloatGrp.PoolSize = 2

local tmpPos = LuaVector3.zero
function TypeNineFloatGrp:ctor()
	TypeNineFloatGrp.super.ctor(self)
	self.msgs = {}
	self:_Reset()
end

function TypeNineFloatGrp:SetParent(parent)
	self.parent = parent
end

function TypeNineFloatGrp:SetCompleteCallback(call,arg)
	self.call = call
	self.arg = arg
end

function TypeNineFloatGrp:CallComplete()
	if(self.call) then
		self.call(self.arg)
	end
end

function TypeNineFloatGrp:_Reset()
	self.playIndex = 0
	self.showedIndex = 0
	self.count = 0
	self.isShowing = false
	self.call = nil
	self.arg = nil
	self.parent = nil
	self.cannotAddMsg = false
	TableUtility.ArrayClear(self.msgs)
end

function TypeNineFloatGrp:GetCount()
	return self.count
	-- return #self.msgs
end

function TypeNineFloatGrp:AddMsg(sortID,msg)
	local element = ReusableTable.CreateArray()
	element[1] = sortID
	element[2] = msg
	self.msgs[#self.msgs + 1] = element
	self.count = self.count + 1
	if(self.isShowing) then
		self:SortMsg()
	end
end

function TypeNineFloatGrp:StartShow()
	if(not self.isShowing) then
		self.isShowing = true
		self:SortMsg()
		self:PlayNext()
	end
end

function TypeNineFloatGrp._EffectCreated(effectHandle,args)
	if(effectHandle and args) then
		args[1]:_RealPlayEffect(effectHandle,args[2])
		ReusableTable.DestroyAndClearArray(args)
	end
end

function TypeNineFloatGrp:_RealPlayEffect(effectHandle,index)
	local richlabel = effectHandle.gameObject:GetComponentInChildren(UIRichLabel)
	local spritelabel = SpriteLabel.CreateAsTable()
	spritelabel:Init(richlabel)
	local msg = table.remove(self.msgs,1)
	spritelabel:SetText(msg[2],true)
	ReusableTable.DestroyAndClearArray(msg)
	tmpPos[2] = - index * 25
	effectHandle.transform.localPosition = tmpPos
	LeanTween.delayedCall(0.3,function ()
			self:PlayNext()
		end)
end

function TypeNineFloatGrp:PlayNext()
	if(self.playIndex < self:GetCount()) then
		self.playIndex = self.playIndex + 1
		local args = ReusableTable.CreateArray()
		args[1] = self
		args[2] = self.playIndex
		local effect = Asset_Effect.PlayOneShotOn( EffectMap.Maps.PropertiesUp, self.parent.transform, TypeNineFloatGrp._EffectCreated, args )
		self:SetWeakData(self.playIndex, effect)
	else
		self.cannotAddMsg = true
	end
end

function TypeNineFloatGrp:DestroyEffects()
	if(self._weakData) then
		for k,v in ipairs(self._weakData) do
			v:Destroy()
		end
	end
end

local function _RealSortMsg(l,r)
	return l[1]<r[1]
end
function TypeNineFloatGrp:SortMsg()
	table.sort( self.msgs, _RealSortMsg)
end

-- override begin
function TypeNineFloatGrp:DoConstruct(asArray, configID)
	self.running = true
	self.configID = configID
	self:CreateWeakData()
end

function TypeNineFloatGrp:DoDeconstruct(asArray)
	self.running = false
	self:_Reset()
	self:DestroyEffects()
end

function TypeNineFloatGrp:OnObserverDestroyed(k, obj)
	if(self.running) then
		self.showedIndex = self.showedIndex + 1
		if(self.showedIndex>=self.playIndex) then
			self:CallComplete()
		end
	end
end
-- override end