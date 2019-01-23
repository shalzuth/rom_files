autoImport("LogicManager_Creature_Userdata")
LogicManager_Player_Userdata = class("LogicManager_Player_Userdata",LogicManager_Creature_Userdata)

local PVPTeam = RoleDefines.PVPTeam
--玩家

local bodyUserdataID = 0
function LogicManager_Player_Userdata:ctor()
	LogicManager_Player_Userdata.super.ctor(self)
	bodyUserdataID = ProtoCommon_pb.EUSERDATATYPE_BODY
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND,self.UpdateMusicDJ)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR,self.SetPvpColor)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT,self.UpdatePeakEffect)

	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL,self.UpdateJobLevel)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBEXP,self.UpdateJobExpLevel)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION,self.UpdateProfession)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND,self.UpdateMusicDJ)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR,self.UpdatePvpColor)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT,self.UpdatePeakEffect)
	--change dress begin
	-- for i=1,#LogicManager_Player_Userdata.ChangeDressData do
	-- 	self:AddDirtyCall(LogicManager_Player_Userdata.ChangeDressData[i],self.SetChangeDressDirty)
	-- end
	--change dress end
end

function LogicManager_Player_Userdata:UpdateRoleLevel(ncreature,userDataID,oldValue,newValue)	
	LogicManager_Player_Userdata.super.UpdateRoleLevel(self,ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature,SceneUserEvent.BaseLevelUp)
end

function LogicManager_Player_Userdata:UpdateJobLevel(ncreature,userDataID,oldValue,newValue)
	local occ = ncreature.data:GetCurOcc()
	if(occ)then
		occ:SetLevel(newValue)
	end
	GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature,SceneUserEvent.JobLevelUp)
end

function LogicManager_Player_Userdata:UpdateJobExpLevel(ncreature,userDataID,oldValue,newValue)
	local occ = ncreature.data:GetCurOcc()
	if(occ)then
		occ:SetExp(newValue)
	end
end

function LogicManager_Player_Userdata:SetChangeDressDirty(ncreature,userDataID,oldValue,newValue)
	self.changeDressDirty = true
	if(userDataID==bodyUserdataID) then
		ncreature:HandlerAssetRoleSuffixMap()
	end
end

function LogicManager_Player_Userdata:UpdateProfession(ncreature,userDataID,oldValue,newValue)
	ncreature.data:UpdateProfession()
	ncreature:HandlerAssetRoleSuffixMap()
	EventManager.Me():PassEvent(SceneUserEvent.ChangeProfession, ncreature)
	if(ncreature == Game.Myself:GetLockTarget()) then
		EventManager.Me():PassEvent(MyselfEvent.SelectTargetClassChange, ncreature)
	end
end

function LogicManager_Player_Userdata:UpdateMusicDJ(ncreature,userDataID,oldValue,newValue)
	if(newValue == 1)then
		FunctionMusicBox.Me():AddDJPlayer(ncreature);
	elseif(newValue == 0)then
		FunctionMusicBox.Me():RemoveDJPlayer(ncreature);
	end
end

function LogicManager_Player_Userdata:SetPvpColor(ncreature,userDataID,oldValue,newValue)
	ncreature:PlayTeamCircle(newValue)
end

function LogicManager_Player_Userdata:UpdatePvpColor(ncreature,userDataID,oldValue,newValue)
	ncreature:PlayTeamCircle(newValue)
	-- EventManager.Me():PassEvent(CreatureEvent.PVP_TeamChange, ncreature)
end

function LogicManager_Player_Userdata:UpdatePeakEffect(ncreature,userDataID,oldValue,newValue)
	if newValue == 1 then
		local otherPeak = FunctionPerformanceSetting.Me():GetSetting().otherPeak
		if otherPeak then
			ncreature:PlayPeakEffect()
		end
	elseif newValue == 0 then
		ncreature:RemovePeakEffect()
	end
end