PhotoCommandShowGhost = class("PhotoCommandShowGhost")

function PhotoCommandShowGhost:ctor()
	self.invisibleLayerID = RO.Config.Layer.INVISIBLE.Value
	self:Reset()
end

function PhotoCommandShowGhost:Reset()
	self.running = false
	self:ResetCreatures()
end

function PhotoCommandShowGhost:ShutDown()
	if not self.running then
		return
	end
	self:Reset()
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.OnAddNpcsHandler, self)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.OnRemoveNpcsHandler, self)
end

function PhotoCommandShowGhost:Launch()
	if self.running then
		return
	end
	self.running = true
	-- self:FindAllGhosts()
	-- EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.OnAddNpcsHandler, self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.OnRemoveNpcsHandler, self)
end

function PhotoCommandShowGhost:OnAddNpcsHandler(npcs)
	for i=1,#npcs do
		self:CheckAndShowCreature(npcs[i])
	end
end

function PhotoCommandShowGhost:OnRemoveNpcsHandler(npcs)
	for i=1,#npcs do
		self:RemoveCreature(npcs[i])
	end
end

function PhotoCommandShowGhost:CheckAndShowCreature(creature)
	if(creature and creature.data.behaviourData:IsGhost())then
		self.ghosts[creature.data.id] = creature.data.id
		FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):ShowPlayer(creature)
	end
end

function PhotoCommandShowGhost:FindAllGhosts()
	self:GetGhostIn(NSceneNpcProxy.Instance:GetAll())
end

function PhotoCommandShowGhost:GetGhostIn(creatures)
	for k,creature in pairs(creatures) do
		self:CheckAndShowCreature(creature)
	end
end

function PhotoCommandShowGhost:ResetCreatures()
	if(self.ghosts) then
		local creature
		local findFunc = SceneCreatureProxy.FindCreature
		local manager = Game.LogicManager_Npc_Props
		for k,id in pairs(self.ghosts) do
			creature = findFunc(id)
			if(creature) then
				manager:UpdateHiding(creature,nil,nil,creature.data.props.Hiding)
			end
		end
		TableUtility.TableClear(self.ghosts)
	else
		self.ghosts = {}
	end
end

function PhotoCommandShowGhost:RemoveCreature(id)
	self.ghosts[id] = nil
end

function PhotoCommandShowGhost:GhostInSight( creature )
	self:CheckAndShowCreature(creature)
end

function PhotoCommandShowGhost:GhostOutSight( creature )
	if(creature) then
		Game.LogicManager_Npc_Props:UpdateHiding(creature,nil,nil,creature.data.props.Hiding)
		self:RemoveCreature(creature)
	end
end