LogicManager_Myself_Userdata = class("LogicManager_Myself_Userdata",LogicManager_Player_Userdata)

function LogicManager_Myself_Userdata:ctor()
	LogicManager_Myself_Userdata.super.ctor(self)

	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_CURID, self.MusicBoxInfoChange)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_START, self.MusicBoxInfoChange)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_LOOP, self.MusicBoxInfoChange)

	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ZONEID,self.UpdateZoneId)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_NORMALSKILL_OPTION,self.UpdateNormalSkillOption)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION,self.SetProfession)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CONTRIBUTE,self.UpdateContribute)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT,self.UpdatePeakEffect)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MARITAL,self.UpdateMarital)

	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_CURID, self.MusicBoxInfoChange)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_START, self.MusicBoxInfoChange)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_LOOP, self.MusicBoxInfoChange)

	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ROLEEXP, self.BaseExpChange)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ZONEID, self.UpdateZoneId)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SILVER, self.UpdateZeny)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_FAVORABILITY,self.UpdateServantFavor)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NORMALSKILL_OPTION, self.UpdateNormalSkillOption)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CONTRIBUTE, self.UpdateContribute)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT,self.UpdatePeakEffect)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MARITAL,self.UpdateMarital)

	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_COOKER_LV, self.UpdateCookLv)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TASTER_LV, self.UpdateTasterLv)

	self:RemoveUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DIR)
end

function LogicManager_Myself_Userdata:SetProfession(ncreature,userDataID,oldValue,newValue)
	ncreature:HandlerAssetRoleSuffixMap()
	AstrolabeProxy.Instance:InitProfessionPlate_PropData(newValue);
end

function LogicManager_Myself_Userdata:CheckDressDirty(ncreature)
	if(self.changeDressDirty) then
		self.changeDressDirty = false
		ncreature:ReDress()
		GameFacade.Instance:sendNotification(MyselfEvent.ChangeDress)
	end
end

function LogicManager_Myself_Userdata:_Die(ncreature,isSet)
	LogicManager_Myself_Userdata.super._Die(self,ncreature,isSet)
	-- 2016.11.8. by Ghost
	-- Game.AutoBattleManager:AutoBattleOff()
end

function LogicManager_Myself_Userdata:_Revive(ncreature,oldValue)
	if(oldValue == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD) then
		if(ncreature.assetRole:IsPlayingAction(Asset_Role.ActionName.Die)) then
			ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Idle)
		end
	end
	ncreature:Server_ReviveCmd()
end

function LogicManager_Myself_Userdata:_FakeDie(ncreature)
	FunctionSystem.InterruptMyself()
	ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Die,1,false,true)
end

function LogicManager_Myself_Userdata:UpdateProfession(ncreature,userDataID,oldValue,newValue)
	ncreature.data:UpdateProfession()
	GameFacade.Instance:sendNotification(MyselfEvent.MyProfessionChange)
	FunctionItemCompare.Me():TryCompare()

	AstrolabeProxy.Instance:InitProfessionPlate_PropData(newValue);
end

function LogicManager_Myself_Userdata:MusicBoxInfoChange(ncreature,userDataID,oldValue,newValue)
	local soundid = ncreature.data.userdata:Get(UDEnum.MUSIC_CURID);
	local starttime = ncreature.data.userdata:Get(UDEnum.MUSIC_START);
	local playTimes = ncreature.data.userdata:Get(UDEnum.MUSIC_LOOP) == 1 and 0 or 1;
	FunctionMusicBox.Me():SetMusic(soundid, starttime, playTimes);
end

function LogicManager_Myself_Userdata:UpdateJobExpLevel(ncreature,userDataID,oldValue,newValue)
	LogicManager_Myself_Userdata.super.UpdateJobExpLevel(self,ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.JobExpChange)
end

function LogicManager_Myself_Userdata:BaseExpChange(ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.BaseExpChange)
end

function LogicManager_Myself_Userdata:UpdateZoneId(ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.ZoneIdChange)
end

function LogicManager_Myself_Userdata:UpdateRoleLevel(ncreature,userDataID,oldValue,newValue)	
	LogicManager_Myself_Userdata.super.UpdateRoleLevel(self,ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.LevelUp)

	-- 更新活动信息（活动信息有可能会跟等级相关）
	FunctionActivity.Me():UpdateNowMapTraceInfo()
end

function LogicManager_Myself_Userdata:UpdateZeny(ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.ZenyChange)
end

function LogicManager_Myself_Userdata:UpdateServantFavor(ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.ServantFavorChange)
end

function LogicManager_Myself_Userdata:UpdateNormalSkillOption(ncreature,userDataID,oldValue,newValue)
	MyselfProxy.Instance.selectAutoNormalAtk = newValue == 1
end

function LogicManager_Myself_Userdata:UpdateContribute(ncreature,userDataID,oldValue,newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.ContributeChange)
end

function LogicManager_Myself_Userdata:UpdateCookLv(ncreature, userDataID, oldValue, newValue)
	FunctionFood.MyCookerLvChange(oldValue, newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.CookerLvChange)
end

function LogicManager_Myself_Userdata:UpdateTasterLv(ncreature, userDataID, oldValue, newValue)
	FunctionFood.MyTasterLvChange(oldValue, newValue)
	GameFacade.Instance:sendNotification(MyselfEvent.TasterLvChange)
end

function LogicManager_Myself_Userdata:UpdatePeakEffect(ncreature,userDataID,oldValue,newValue)
	if newValue == 1 then
		local selfPeak = FunctionPerformanceSetting.Me():GetSetting().selfPeak
		if selfPeak then
			ncreature:PlayPeakEffect()
		end
	elseif newValue == 0 then
		ncreature:RemovePeakEffect()
	end
end

function LogicManager_Myself_Userdata:UpdateMarital(ncreature,userDataID,oldValue,newValue)
	WeddingProxy.Instance:UpdateMarital(oldValue,newValue)
end