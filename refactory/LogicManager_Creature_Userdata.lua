LogicManager_Creature_Userdata = class("LogicManager_Creature_Userdata")

local ChangeDressData = {
	ProtoCommon_pb.EUSERDATATYPE_FACE,
	ProtoCommon_pb.EUSERDATATYPE_HAIR,
	ProtoCommon_pb.EUSERDATATYPE_BACK,
	ProtoCommon_pb.EUSERDATATYPE_TAIL,
	ProtoCommon_pb.EUSERDATATYPE_LEFTHAND,
	ProtoCommon_pb.EUSERDATATYPE_RIGHTHAND,
	ProtoCommon_pb.EUSERDATATYPE_BODY,
	ProtoCommon_pb.EUSERDATATYPE_HEAD,
	ProtoCommon_pb.EUSERDATATYPE_EYE,
	ProtoCommon_pb.EUSERDATATYPE_MOUNT,
	ProtoCommon_pb.EUSERDATATYPE_MOUTH,
	ProtoCommon_pb.EUSERDATATYPE_HAIRCOLOR,
	ProtoCommon_pb.EUSERDATATYPE_CLOTHCOLOR,
	ProtoCommon_pb.EUSERDATATYPE_TAIL,
}

function LogicManager_Creature_Userdata:ctor()
	self.dirtyCalls = {}
	self.updateCalls = {}
	self.setCalls = {}
	--set begin
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DIR,self.SetDir)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BODYSCALE,self.SetScale)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_STATUS,self.SetStatus)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_NORMAL_SKILL,self.SetNormalSkill)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL,self.SetRoleLevel)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER,self.SetPartner)
	self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_SHADERCOLOR,self.SetShaderColorChange)

	--set end
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DIR,self.UpdateDir)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NAME,self.UpdateName)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BODYSCALE,self.UpdateScale)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_STATUS,self.UpdateStatus)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NORMAL_SKILL,self.SetNormalSkill)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL,self.UpdateRoleLevel)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER,self.UpdatePartner)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHADERCOLOR,self.UpdateShaderColorChange)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HANDID,self.UpdateHandId)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TWINS_ACTIONID or 124,self.UpdateTwinsActionId)
	self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_COOKER_LV,self.UpdateCooklv)

	--change dress begin
	for i=1,#ChangeDressData do
		self:AddDirtyCall(ChangeDressData[i],self.SetChangeDressDirty)
	end
	--change dress end
end

function LogicManager_Creature_Userdata:IsDirty(id)
	return self.dirtyCalls[id] ~= nil
end

--func(ncreature,userData id,oldValue,newValue)
function LogicManager_Creature_Userdata:AddDirtyCall(id,func)
	self.dirtyCalls[id] = func
end

--func(ncreature,userData id,oldValue,newValue)
function LogicManager_Creature_Userdata:AddUpdateCall(id,func)
	self.updateCalls[id] = func
end

function LogicManager_Creature_Userdata:AddSetCall(id,func)
	self.setCalls[id] = func
end

function LogicManager_Creature_Userdata:RemoveDirtyCall(id)
	self.dirtyCalls[id] = nil
end

function LogicManager_Creature_Userdata:RemoveUpdateCall(id)
	self.updateCalls[id] = nil
end

function LogicManager_Creature_Userdata:RemoveSetCall(id)
	self.setCalls[id] = nil
end

function LogicManager_Creature_Userdata:CheckDirtyDatas(ncreature)
	local userDatas = ncreature.data.userdata
	local call
	if(userDatas and userDatas.hasDirtyDatas) then
		for k,v in pairs(userDatas.dirtyIDs) do
			call = self.dirtyCalls[k]
			if(call~=nil) then
				call(self,ncreature,k,v,userDatas:GetById(k))
			end
			userDatas.dirtyIDs[k] = nil
		end
		userDatas.hasDirtyDatas = false
	end
	self:CheckDressDirty(ncreature)
end

function LogicManager_Creature_Userdata:CheckDressDirty(ncreature)
	if(self.changeDressDirty) then
		self.changeDressDirty = false
		ncreature:ReDress()
	end
end

function LogicManager_Creature_Userdata:CheckHasAnyDressData(ncreature)
	if(ncreature ~=nil and ncreature.data~=nil) then
		local userDatas = ncreature.data.userdata
		if(userDatas) then
			local v
			for i=1,#ChangeDressData do
				v = userDatas:GetById(ChangeDressData[i])
				if(v ~=nil and v~=0) then
					return true
				end
			end
		end
	end
	return false
end

function LogicManager_Creature_Userdata:SetChangeDressDirty(ncreature,userDataID,oldValue,newValue)
	self.changeDressDirty = true
end

function LogicManager_Creature_Userdata:CheckUpdateDataCall(ncreature,userDataID,oldValue,newValue)
	local call = self.updateCalls[userDataID]
	if(call) then
		call(self,ncreature,userDataID,oldValue,newValue)
	end
end

function LogicManager_Creature_Userdata:CheckSetDataCall(ncreature,userDataID,oldValue,newValue)
	local call = self.setCalls[userDataID]
	if(call) then
		call(self,ncreature,userDataID,oldValue,newValue)
	end
end

function LogicManager_Creature_Userdata:SetDir(ncreature,userDataID,oldValue,newValue)
	ncreature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY,newValue/1000,true)
end

function LogicManager_Creature_Userdata:UpdateDir(ncreature,userDataID,oldValue,newValue)
	ncreature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY,newValue/1000)
end

function LogicManager_Creature_Userdata:SetScale(ncreature,userDataID,oldValue,newValue)
	ncreature:Server_SetScaleCmd(newValue/100,true)
end

function LogicManager_Creature_Userdata:UpdateScale(ncreature,userDataID,oldValue,newValue)
	ncreature:Server_SetScaleCmd(newValue/100)
end

function LogicManager_Creature_Userdata:SetStatus(ncreature,userDataID,oldValue,newValue)
	self:_RefreshStatus(ncreature,newValue,true)
end

function LogicManager_Creature_Userdata:UpdateStatus(ncreature,userDataID,oldValue,newValue)
	self:_RefreshStatus(ncreature,newValue,false,oldValue)
end

function LogicManager_Creature_Userdata:SetRoleLevel(ncreature,userDataID,oldValue,newValue)	
	ncreature.data:SetBaseLv(newValue)
end

function LogicManager_Creature_Userdata:UpdateRoleLevel(ncreature,userDataID,oldValue,newValue)	
	ncreature.data:SetBaseLv(newValue)
end

function LogicManager_Creature_Userdata:SetPartner(ncreature,userDataID,oldValue,newValue)
	ncreature:SetPartner(newValue)
end

function LogicManager_Creature_Userdata:UpdatePartner(ncreature,userDataID,oldValue,newValue)
	ncreature:SetPartner(newValue)
end

function LogicManager_Creature_Userdata:UpdateName(ncreature,userDataID,oldValue,newValue)
	ncreature.data.name = ncreature.data.userdata:GetBytes(UDEnum.NAME);
	GameFacade.Instance:sendNotification(CreatureEvent.Name_Change, ncreature)
end

function LogicManager_Creature_Userdata:_RefreshStatus(ncreature,value,isSet,oldValue)
	if(value == ProtoCommon_pb.ECREATURESTATUS_DEAD)then
		self:_Die(ncreature,isSet)
		-- if(self.curStatus == ProtoCommon_pb.ECREATURESTATUS_PHOTO)then				
		-- 	self.weakAICtrl:RemoveAI(PhotoModeAI)
		-- end
		if(ncreature:GetCreatureType() == Creature_Type.Me)then
			GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide,false)
			GameFacade.Instance:sendNotification(MyselfEvent.DeathStatus)
		elseif(ncreature:GetCreatureType() == Creature_Type.Player)then
			GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
		end
	elseif (value == ProtoCommon_pb.ECREATURESTATUS_LIVE)then
		if(ncreature:GetCreatureType() == Creature_Type.Me)then
			GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide,true)
			GameFacade.Instance:sendNotification(MyselfEvent.ReliveStatus)
		elseif(ncreature:GetCreatureType() == Creature_Type.Player)then
			GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
		end
		self:_Revive(ncreature,oldValue)
		--退出拍照模式
		-- self:Notify(ServiceEvent.PlayerRelive, data)
	elseif(value == ProtoCommon_pb.ECREATURESTATUS_PHOTO and ncreature:GetCreatureType() ~= Creature_Type.Me)then
		-- SceneUserProxy.Instance:reLive(self.id)
			--拍照模式
		-- self.weakAICtrl:AddAI(PhotoModeAI)
	elseif(value == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD)then
		--npc 可装死
		self:_FakeDie(ncreature)
	elseif(value == ProtoCommon_pb.ECREATURESTATUS_INRELIVE)then
		--复活中
		if(ncreature:GetCreatureType() == Creature_Type.Player)then
			GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
		end
	end
end

function LogicManager_Creature_Userdata:_FakeDie(ncreature)
	FunctionSystem.InterruptCreature(ncreature)
	ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Die,1,false,true)
end

function LogicManager_Creature_Userdata:_Die(ncreature,isSet)
	ncreature:Server_DieCmd(isSet)
end

function LogicManager_Creature_Userdata:_Revive(ncreature,oldValue)
	ncreature:Server_ReviveCmd()
end

function LogicManager_Creature_Userdata:SetNormalSkill(ncreature,userDataID,oldValue,newValue)
	ncreature.data.normalAtkID = newValue
end

function LogicManager_Creature_Userdata:SetShaderColorChange(ncreature,userDataID,oldValue,newValue)
end

function LogicManager_Creature_Userdata:UpdateShaderColorChange(ncreature,userDataID,oldValue,newValue)
end

function LogicManager_Creature_Userdata:UpdateHandId(ncreature,userDataID,oldValue,newValue)
	if(newValue)then
		helplog("UpdateHandId", ncreature.data.name, newValue);
		ncreature:Server_SetHandInHand(newValue, newValue ~= 0);
	end
end

function LogicManager_Creature_Userdata:UpdateTwinsActionId(ncreature,userDataID,oldValue,newValue)
	if(newValue)then
		helplog("UpdateTwinsActionId", ncreature.data.name, newValue);
		-- break double-action by set twinsaction-with-zero
		if(oldValue ~= 0 and newValue == 0)then
			ncreature:Server_SetDoubleAction(0, false);
		end
	end
end

function LogicManager_Creature_Userdata:UpdateCooklv(ncreature,userDataID,oldValue,newValue)
	if(newValue > oldValue)then
		-- local data = {};
		-- local itemData = Table_Item[itemid];
		-- data.icontype = 1;
		-- data.icon = itemData.Icon;
		-- data.content = string.format(ZhString.FunctionFood_FoodTasteLvUp, itemData.NameZh, lv);

		-- GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "SystemUnLockView"})
		-- GameFacade.Instance:sendNotification(SystemUnLockEvent.CommonUnlockInfo, data);
	end
end