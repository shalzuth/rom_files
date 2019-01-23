LogicManager_Npc_Userdata = class("LogicManager_Creature_Userdata",LogicManager_Creature_Userdata)

function LogicManager_Npc_Userdata:ctor()
	LogicManager_Npc_Userdata.super.ctor(self)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ALPHA,self.SetAlpha)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ALPHA,self.UpdateAlpha)
end

function LogicManager_Npc_Userdata:SetAlpha(ncreature,userDataID,oldValue,newValue)
	local value = newValue/1000
	ncreature:Server_SetAlpha(value)
end

function LogicManager_Npc_Userdata:UpdateAlpha(ncreature,userDataID,oldValue,newValue)
	local value = newValue/1000
	ncreature:Server_SetAlpha(value)
end

--npc 换装开始
function LogicManager_Npc_Userdata:SetChangeDressDirty(ncreature,userDataID,oldValue,newValue)
	self.changeDressDirty = true
	if(newValue~=0 and ncreature ~=nil and ncreature.data ~=nil) then
		ncreature.data:SetUseServerDressData(true)
	end
end

local superCheckDressDirty = LogicManager_Npc_Userdata.super.CheckDressDirty
function LogicManager_Npc_Userdata:CheckDressDirty(ncreature)
	if(self.changeDressDirty) then
		if(not self:CheckHasAnyDressData(ncreature)) then
			ncreature.data:SetUseServerDressData(false)
		end
	end
	superCheckDressDirty(self,ncreature)
end
--npc 换装结束
