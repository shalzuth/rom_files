FunctionMiyinStrengthen = class('FunctionMiyinStrengthen')

function FunctionMiyinStrengthen.Ins()
	if FunctionMiyinStrengthen.ins == nil then
		FunctionMiyinStrengthen.ins = FunctionMiyinStrengthen.new()
	end
	return FunctionMiyinStrengthen.ins
end

function FunctionMiyinStrengthen:OpenUI()
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.MiyinStrengthen})
end

function FunctionMiyinStrengthen:SetNPCCreature(npc_creature)
	self.npcCreature = npc_creature
end

function FunctionMiyinStrengthen:GetNPCCreature()
	return self.npcCreature
end

local strengthenAnimName = 'functional_action'
local waitAnimName = 'wait'
function FunctionMiyinStrengthen:BuildingPlayStrengthenAnim(complete_callback)
	local animParams = Asset_Role.GetPlayActionParams(strengthenAnimName, nil, 1)
	animParams[7] = function ()
		animParams = Asset_Role.GetPlayActionParams(waitAnimName, nil, 1)
		self.npcCreature.assetRole:PlayActionRaw(animParams)
		if complete_callback ~= nil then
			complete_callback()
		end
	end
	self.npcCreature.assetRole:PlayActionRaw(animParams)
end

function FunctionMiyinStrengthen:BuildingIsPlayingStrengthenAnim()
	return self.npcCreature.assetRole:IsPlayingActionRaw(strengthenAnimName)
end