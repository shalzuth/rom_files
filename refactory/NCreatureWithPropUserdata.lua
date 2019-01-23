NCreatureWithPropUserdata = class("NCreatureWithPropUserdata",NCreature)
autoImport("NCreatureWithPropUserdata_Client")

function NCreatureWithPropUserdata:ctor(aiClass)
	NCreatureWithPropUserdata.super.ctor(self,aiClass)
	--> reusable begin
	--userdata manager
	self.userDataManager = nil
	--prop manager
	self.propmanager = nil
	--> reusable end
end

function NCreatureWithPropUserdata:IsPhotoStatus()
	return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_PHOTO
end

function NCreatureWithPropUserdata:IsDead()
	local status = self.data.userdata:Get(UDEnum.STATUS)
	return status == ProtoCommon_pb.ECREATURESTATUS_DEAD or status == ProtoCommon_pb.ECREATURESTATUS_INRELIVE
end

function NCreatureWithPropUserdata:IsInRevive()
	return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_INRELIVE
end

function NCreatureWithPropUserdata:IsFakeDead()
	return self.data.userdata:Get(UDEnum.STATUS) == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD
end

function NCreatureWithPropUserdata:Server_SetUserDatas(serverUserdatas,init)
	local userdata = self.data.userdata
	local sdata
	local manager = self.userDataManager
	local oldValue
	for i = 1, #serverUserdatas do
		sdata = serverUserdatas[i]
		if sdata ~= nil then
			if(manager:IsDirty(sdata.type)) then
				userdata:DirtyUpdateByID(sdata.type,sdata.value,sdata.data)
			else
				if(not init) then
					oldValue = userdata:UpdateByID(sdata.type,sdata.value,sdata.data)
					manager:CheckUpdateDataCall(self,sdata.type,oldValue,sdata.value)
				else
					userdata:SetByID(sdata.type,sdata.value,sdata.data)
					manager:CheckSetDataCall(self,sdata.type,nil,sdata.value)
				end
			end
		end
	end
end

function NCreatureWithPropUserdata:Server_SetAttrs(serverAttrs)
	local props = self.data.props
	local sdata
	local manager = self.propmanager
	local oldValue,p
	for i = 1, #serverAttrs do
		sdata = serverAttrs[i]
		if sdata ~= nil then
			if(manager:IsDirty(sdata.type)) then
				props:DirtySetByID(sdata.type,sdata.value)
			else
				oldValue,p = props:SetValueById(sdata.type,sdata.value)
				manager:CheckPropUpdateCall(self,sdata.type,oldValue,p)
			end
		end
	end
end

function NCreatureWithPropUserdata:SetVisible(v,reason)
	local assetRoleInVisible = self.assetRole:GetInvisible()
	NCreatureWithPropUserdata.super.SetVisible(self,v,reason)
	--处理身上管理的特效
	local nowAssetRoleInVisible = self.assetRole:GetInvisible()
	if(nowAssetRoleInVisible~=assetRoleInVisible) then
		-- helplog("生物显示/隐藏改变",self.data:GetName(),not nowAssetRoleInVisible)
		if(self.buffs~=nil) then
			for k,buff in pairs(self.buffs) do
				if(buff and type(buff) == "table") then
					buff:SetEffectVisible(not nowAssetRoleInVisible)
				end
			end
		end
		if self.buffGroups ~= nil then
			for k,v in pairs(self.buffGroups) do
				v:SetEffectVisible(not nowAssetRoleInVisible)
			end
		end
		if(self.skill~=nil) then
			self.skill:SetEffectVisible(not nowAssetRoleInVisible)
		end
	end
end

function NCreatureWithPropUserdata:InitBuffs(serverData,needhit)
	local buffDatas = serverData.buffs
	if(buffDatas and #buffDatas>0) then
		for i=1,#buffDatas do
			self:AddBuff(buffDatas[i].id,true,needhit,buffDatas[i].fromid,buffDatas[i].layer,buffDatas[i].level)
		end
	end
end

local superUpdate = NCreatureWithPropUserdata.super.Update
function NCreatureWithPropUserdata:Update(time, deltaTime)
	superUpdate(self,time,deltaTime)
	--阵营变化
	if(self.data.campChanged) then
		self:HandleCampChange()
	end
end

function NCreatureWithPropUserdata:HandleCampChange()
	self.data.campChanged = false
	self:ResetClickPriority()
	if(self.sceneui) then
		self.sceneui.roleBottomUI:HandleCampChange(self)
	end
	EventManager.Me():PassEvent(CreatureEvent.Player_CampChange, self)
end

--init 是否是玩家被添加到场景时候的初始化
function NCreatureWithPropUserdata:AddBuff(buffID,init,needhit,fromID,layer,level)
	if nil == buffID then
		return
	end
	local buffInfo = Table_Buffer[buffID]
	if nil == buffInfo then
		return
	end
	if(needhit==nil) then
		needhit = true
	end
	local buff = self.buffs and self.buffs[buffID] or nil
	if(buff == nil) then
		self.data:AddBuff(buffID,fromID,layer,level)
		self:TryHandleAddSpecialBuff(buffInfo,fromID,layer)
		if(self.buffs==nil) then
			self.buffs = {}
		end
		--create
		local buffStateID = buffInfo.BuffStateID
		if nil ~= buffStateID and 0 < buffStateID then
			buff = Buff.Create( buffStateID )
			if(init) then
				buff:Refresh(self)
			else
				buff:Start(self)
			end
			buff:SetEffectVisible(not self.assetRole:GetInvisible())
			buff:SetLayer(layer or 1)
			-- buff:SetLevel(level or 0)
		else
			buff = layer or 1
		end
		self.buffs[buffID] = buff
		-- helplog("AddBuff", buffID)
		local stateEffect = buffInfo.BuffEffect and buffInfo.BuffEffect.StateEffect or nil
		if nil ~= stateEffect then
			local buffStateCount = self.buffStateCount
			if(buffStateCount==nil) then
				buffStateCount = {}
				self.buffStateCount = buffStateCount
			end 

			local count = buffStateCount[stateEffect]
			if(count==nil) then
				count = 1
			else
				count = count + 1
			end

			buffStateCount[stateEffect] = count
			-- helplog("Add State Effect", stateEffect, count)
		end
	else
		self.data:AddBuff(buffID,fromID,layer,level)
		self:TryHandleAddSpecialBuff(buffInfo,fromID,layer)
		if type(buff) == "table" and needhit then
			buff:Hit(self)
			buff:SetLayer(layer or 1)
			-- buff:SetLevel(level or 0)
		elseif(type(buff)=="number")then
			self.buffs[buffID] = layer or 1
		end
	end
end

function NCreatureWithPropUserdata:TryHandleAddSpecialBuff(buffInfo,fromID,layer)
	if(buffInfo) then
		local buffeffect = buffInfo.BuffEffect
		if(buffeffect.weak_freeze~=nil and buffeffect.weak_freeze==1) then
			self.data:_AddWeakFreezeSkillBuff(buffInfo,buffeffect.id)
			if(self.data:WeakFreeze()) then
				self:Logic_Freeze(true)
			end
		end
	end
end

function NCreatureWithPropUserdata:RemoveBuff(buffID)
	if nil == buffID then
		return
	end

	if(self.buffs~=nil) then
		local buff = self.buffs[buffID]
		if(buff) then
			if(type(buff) == "table") then
				buff:End(self)
				buff:Destroy()
			end
			self.buffs[buffID] = nil
			-- helplog("RemoveBuff", buffID)
			local buffInfo = Table_Buffer[buffID]
			if nil == buffInfo then
				return
			end
			self.data:RemoveBuff(buffID)
			self:TryHandleRemoveSpecialBuff(buffID,buffInfo)
			local stateEffect = buffInfo.BuffEffect and buffInfo.BuffEffect.StateEffect or nil
			if nil ~= stateEffect then
				local buffStateCount = self.buffStateCount
				if(buffStateCount~=nil) then
					local count = buffStateCount[stateEffect]
					if(count) then
						count = count-1
						buffStateCount[stateEffect] = count
						-- helplog("Remove State Effect", stateEffect, count)
					end
				end
			end
		end
	end
end

function NCreatureWithPropUserdata:TryHandleRemoveSpecialBuff(buffID,buffInfo)
	if(buffInfo==nil) then
		buffInfo = Table_Buffer[buffID]
	end
	if nil == buffInfo then
		return
	end
	local buffeffect = buffInfo.BuffEffect
	if(buffeffect.weak_freeze~=nil and buffeffect.weak_freeze==1) then
		self.data:_RemoveWeakFreezeSkillBuff(buffInfo,buffeffect.id)
		if(not self.data:WeakFreeze()) then
			self:Logic_Freeze(0 < self.data.props.Freeze:GetValue())
		end
	end
end

function NCreatureWithPropUserdata:RegisterBuffGroup(buff)
	local groupID = buff.staticData.GroupID
	if groupID ~= nil then
		if self.buffGroups == nil then
			self.buffGroups = {}
		end
		local group = self.buffGroups[groupID]
		if group == nil then
			group = BuffGroup.Create()
			group:SetEffectVisible(not self.assetRole:GetInvisible())
			self.buffGroups[groupID] = group
		end
		group:RegisterBuff(self, buff)
	end
end

function NCreatureWithPropUserdata:UnRegisterBuffGroup(buff)
	local groupID = buff.staticData.GroupID
	if groupID ~= nil and self.buffGroups ~= nil then
		local group = self.buffGroups[groupID]
		if group ~= nil then
			group:UnRegisterBuff(self, buff)

			if group:GetBuffCount() == 0 then
				group:Destroy()
				self.buffGroups[groupID] = nil
			end
		end
	end
end

function NCreatureWithPropUserdata:GetBuffLayer(buffID)
	if(self.buffs~=nil and buffID ~= nil) then
		local buff = self.buffs[buffID]
		if(buff) then
			if(type(buff) == "table") then
				return buff:GetLayer()
			else
				return buff
			end
		end
	end
	return 0
end

function NCreatureWithPropUserdata:HasBuff(buffID)
	if(self.buffs~=nil and buffID ~= nil) then
		return (self.buffs[buffID] ~= nil)
	end
	return false
end

function NCreatureWithPropUserdata:HasBuffs(buffIDs)
	local buffs = self.buffs
	if(buffs~=nil and buffIDs~=nil) then
		for i=1,#buffIDs do
			if(buffs[buffIDs[i]]~=nil) then
				-- helplog("Has Buff", buffIDs[i])
				return true
			end
		end
	end
	return false
end

function NCreatureWithPropUserdata:HasBuffStates(buffStateIDs)
	local buffStateCount = self.buffStateCount
	if(buffStateCount~=nil and buffStateIDs~=nil) then
		local count
		for i=1,#buffStateIDs do
			count = buffStateCount[buffStateIDs[i]]
			if(count~=nil and count>0) then
				-- helplog("Has State Effect", buffStateIDs[i], count)
				return true
			end
		end
	end
	return false
end

function NCreatureWithPropUserdata:ClearBuff()
	if(self.buffs~=nil) then
		for k,v in pairs(self.buffs) do
			if type(v) == "table" then
				v:Destroy()
			end
			self.buffs[k] = nil
			-- helplog("ClearBuff", k)
		end
	end
	if(self.buffStateCount~=nil) then
		for k,v in pairs(self.buffStateCount) do
			self.buffStateCount[k] = nil
			-- helplog("Clear State Effect", k)
		end
	end
	if self.buffGroups ~= nil then
		for k,v in pairs(self.buffGroups) do
			v:Destroy()
			self.buffGroups[k] = nil
		end
	end
end

function NCreatureWithPropUserdata:DoDeconstruct(asArray)
	NCreatureWithPropUserdata.super.DoDeconstruct(self,asArray)
	self:ClearBuff()
end