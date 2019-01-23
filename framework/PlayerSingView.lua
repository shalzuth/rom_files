PlayerSingView = class("PlayerSingView", SubView)
autoImport("PlayerSingViewCell")
function PlayerSingView:Init()
	self:AddViewEvents()
end

function PlayerSingView:AddViewEvents(  )
	-- body
	EventManager.Me():AddEventListener(SkillEvent.SkillCastBegin,self.HandleStartProcess,self)
	EventManager.Me():AddEventListener(SkillEvent.SkillCastEnd,self.HandleStopProcess,self)
end

function PlayerSingView:OnExit(  )
	-- body
	EventManager.Me():RemoveEventListener(SkillEvent.SkillCastBegin,self.HandleStartProcess,self)
	EventManager.Me():RemoveEventListener(SkillEvent.SkillCastEnd,self.HandleStopProcess,self)
end

function PlayerSingView:HandleStartProcess( note )
	-- body
	local creature = note.data
	if(not creature)then
		return
	end
	local id = creature.data.id
	local castTime = creature.skill and creature.skill:GetCastTime(creature) or 0

	if(castTime > 0)then
		local singCell = self:getSingViewCell(id)
		if(not singCell)then
			local creature = SceneCreatureProxy.FindCreature(id)
			local sceneUI = creature and creature:GetSceneUI() or nil
			if(sceneUI)then
				singCell = sceneUI.roleTopUI:createOrGetTopSingUI()
			end			
		end
		if(singCell)then
			singCell:SetData(creature)
		end
	end
end

function PlayerSingView:getSingViewCell( id )
	-- body
	local creature = SceneCreatureProxy.FindCreature(id)
	local sceneUI = creature and creature:GetSceneUI() or nil
	if(sceneUI)then
		return sceneUI.roleTopUI.topSingUI
	end
end

function PlayerSingView:HandleStopProcess( note )
	-- body
	local creature = note.data
	if(not creature)then
		return
	end
	if(creature.data) then
		local id = creature.data.id
		local singCell = self:getSingViewCell(id)
		if(singCell)then
			singCell:delayProcess()
		end
	end
end