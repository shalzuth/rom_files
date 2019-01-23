LogicManager_Player_Props = class("LogicManager_Player_Props",LogicManager_Creature_Props)

function LogicManager_Player_Props:ctor()
	LogicManager_Player_Props.super.ctor(self)
	self:AddUpdateCall("TransformID",self.UpdateTransformState)
end

function LogicManager_Player_Props:UpdateTransformState(ncreature,propName,oldValue,p)
	local transformID = p:GetValue()
	-- print(self.id,"变身！！ npcID:",transformID)
	if(transformID == 0) then
		--解除变身
		FunctionTransform.Me():EndTransform(ncreature)
		-- ncreature:SetActionConfig(Game.Config_PlayerAction)
	else
		--变身
		FunctionTransform.Me():TransformTo(ncreature,transformID)
		-- ncreature:SetActionConfig(Game.Config_NPCAction)
	end
end