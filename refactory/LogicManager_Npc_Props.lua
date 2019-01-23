LogicManager_Npc_Props = class("LogicManager_Npc_Props",LogicManager_Creature_Props)

function LogicManager_Npc_Props:ctor()
	LogicManager_Npc_Props.super.ctor(self)
end

function LogicManager_Npc_Props:UpdateHiding(ncreature,propName,oldValue,p)
	if(1 > p:GetValue()) then
		ncreature:Show()
	else
		local needHide = true
		local behaviourData = ncreature.data.behaviourData
		if(behaviourData) then
			--如果有特性
			print("check hiding",behaviourData:IsGhost(),FunctionPhoto.Me():IsRunningCmd(PhotoCommandShowGhost))
			if(behaviourData:IsGhost() and FunctionPhoto.Me():IsRunningCmd(PhotoCommandShowGhost)) then
				--如果是幽灵特性并且摄像机模式下，则不需要隐藏幽灵特性怪物
				needHide = false
			end
		end
		if(needHide) then
			ncreature:Hide()
		end
	end
end
