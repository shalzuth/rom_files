LogicManager_Pet_Props = class("LogicManager_Pet_Props",LogicManager_Npc_Props)

function LogicManager_Pet_Props:ctor()
	LogicManager_Pet_Props.super.ctor(self)
end

function LogicManager_Pet_Props:UpdateHp(ncreature,propName,oldValue,p)
	LogicManager_Pet_Props.super.UpdateHp(self,ncreature,propName,oldValue,p);

	if(ncreature.data.ownerID ~= nil)then
		if(ncreature.data.ownerID == Game.Myself.data.id)then
			EventManager.Me():PassEvent(MyselfEvent.Pet_HpChange, ncreature);
		end
	end
end

function LogicManager_Pet_Props:UpdateHiding(ncreature,propName,oldValue,p)
	if(1 > p:GetValue()) then
		ncreature:Show()
	else
		ncreature:Hide()
	end
end