autoImport("LCarrier")
autoImport("SceneObjectProxy")
SceneCarrierProxy = class('SceneCarrierProxy', SceneObjectProxy)

SceneCarrierProxy.Instance = nil;

SceneCarrierProxy.NAME = "SceneCarrierProxy"

--场景玩家（可见玩家）数据管理，添加、删除、查找玩家

function SceneCarrierProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneCarrierProxy.NAME
	self.waitMembers = {}
	self:Reset()
	self.addMode = SceneObjectProxy.AddMode.Normal
	if(SceneCarrierProxy.Instance == nil) then
		SceneCarrierProxy.Instance = self
	end
	EventManager.Me():AddEventListener(SceneCreatureEvent.CreatureRemove,self.CreatureRemoveHandler,self)
	EventManager.Me():AddEventListener(MyselfEvent.LeaveCarrier,self.MeLeaveCarrierHandler,self)
end

function SceneCarrierProxy:Reset()
	self.carrierMap = {}
	self.inCarriers = {}
	self.myCarrier = nil
	-- self.waitMembers = {}
end

function SceneCarrierProxy:GetMyCarrier()
	return self.myCarrier
end

function SceneCarrierProxy:GetMyWaitMembers()
	return self.myCarrier and self.waitMembers[self.myCarrier.masterID] or nil
end

function SceneCarrierProxy:RemoveOtherWaitMembers(masterid)
	for k,v in pairs(self.waitMembers) do
		if(k~=masterid) then
			self.waitMembers[k] = nil
		end
	end
end

function SceneCarrierProxy:CarrierWaitMembers(masterid,members)
	local waits = {}
	self.waitMembers = self.waitMembers or {}
	self.waitMembers[masterid] = waits
	-- local str = ""
	local member
	local data
	local myselfID = Game.Myself.data.id
	for i=1,#members do
		member = members[i]
		if(member.id ~= myselfID) then
			data = {id = member.id,name = member.name}
			waits[#waits + 1] = data
			-- str = str..member.name.." "
			if(member.id == masterid) then
				data.agree = true
			end
		end
	end
	-- print(str)
end

function SceneCarrierProxy:MemberAgree(data)
	local waits = self.waitMembers[data.masterid]
	local member
	if(waits) then
		for i=1,#waits do
			member = waits[i]
			if(member.name == data.membername) then
				member.agree = data.agree
				break
			end
		end
	end
end

function SceneCarrierProxy:SetInCarrier(id,carrier)
	self.inCarriers[id] = carrier
end

function SceneCarrierProxy:CreatureIsInCarrier(id)
	return self.inCarriers[id] ~= nil
end

function SceneCarrierProxy:Find(guid)
	-- print("try find id:"..guid.." type:"..type(guid))
	return self.carrierMap[guid]
end

function SceneCarrierProxy:CreatureRemoveHandler(evt)
	local id = evt.data
	local carrier = self:Find(id)
	if(carrier) then
		if(not carrier.isMine) then
			self:RemoveCarrier(carrier)
		end
	end
end

function SceneCarrierProxy:TryCreateCarrier(carrierID,masterID)
	local carrier = self:Find(masterID)
	if(not carrier) then
		local alreadyInCarrier = self:CreatureIsInCarrier(masterID)
		if(not alreadyInCarrier) then
			carrier = LCarrier.CreateAsTable()
			carrier:Reset(masterID,carrierID)
			self.carrierMap[masterID] = carrier
		else
			errorLog(string.format("场景中已经有masterid为%s的载具了，服务器九屏又通知添加了一次",masterID))
		end
	end
	return carrier
end

function SceneCarrierProxy:ChangeCarrier(masterid,carrierid)
	local carrier = self:Find(masterid)
	if(carrier) then
		carrier:ChangeCarrier(carrierid)
	end
end

function SceneCarrierProxy:CarrierChangeMaster(carrier,masterID,newMasterID)
	local carrier = carrier or self:Find(data.masterid)
	if(carrier) then
		self.carrierMap[masterID] = nil
		self.carrierMap[newMasterID] = carrier
		carrier:Reset(newMasterID)
		carrier:GetOn(newMasterID,LCarrier.MasterSeat)
		if(newMasterID==Game.Myself.data.id) then
			self.myCarrier = carrier
		end
	end
end

function SceneCarrierProxy:CarrierAddMember(carrier,memberID,index,needAnim)
	if(carrier) then
		--九屏自己的话忽略，别人的话，移除
		local myselfID = Game.Myself.data.id
		if(memberID == myselfID) then
			self.myCarrier = carrier
			GameFacade.Instance:sendNotification(InviteConfirmEvent.RemoveInviteByType,InviteType.Carrier)
			FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.OnCarrier,false)
			self:RemoveOtherWaitMembers(carrier.masterID)
			-- print("start",carrier.carrierID,index)
		else
			-- SceneUserProxy.Instance:Remove(memberID)
		end
		carrier:GetOn(memberID,index,needAnim)
	end
end

function SceneCarrierProxy:CreateMyCarrier(data)
	-- if(self.myCarrier) then
	-- 	FunctionBus.Me():Launch(self.myCarrier.carrierID,1)
	-- end
end

function SceneCarrierProxy:SyncCarrierMove(data)
	local carrier = self:Find(data.masterid)
	if(carrier) then
		carrier:SetProgress(data.progress/100)
	end
end

function SceneCarrierProxy:CarrierStart(data)
	local carrier = self:Find(data.masterid)
	-- print(carrier.masterID,carrier.line,"server 发车")
	if(carrier) then
		carrier.line = data.line
		if(carrier:StartMove() and carrier.isMine) then
			GameFacade.Instance:sendNotification(CarrierEvent.MyCarrierStart)
		end
	end
end

function SceneCarrierProxy:ReachCarrier(data)
	local carrier = self:Find(data.masterid)
	if(carrier) then
		self:RemoveCarrier(carrier,data.pos)
	end
end

function SceneCarrierProxy:LeaveCarrier(data)
	local carrier = self:Find(data.masterid)
	-- print(string.format("%s车中，玩家%s离开，新的驾驶者%s ,离开坐标:%s %s %s,是否全部:%s",data.masterid,data.charid,data.newmasterid,data.pos.x,data.pos.y,data.pos.z,tostring(data.all)))
	if(carrier) then
		carrier:GetOff(data.charid,data.pos)
		if(carrier.isMine) then
			FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.OnCarrier,true)
			--通知UI有人离开
			GameFacade.Instance:sendNotification(CarrierEvent.MyCarrierLeaveMember,data.charid)
		end
		if(data.newmasterid>0) then
			self:CarrierChangeMaster(carrier,data.masterid,data.newmasterid)
		elseif(data.all) then
			self:RemoveCarrier(carrier,data.pos)
		end
	end
end

function SceneCarrierProxy:MeLeaveCarrierHandler(bus)
	-- helplog("MeLeaveCarrierHandler")
	self.myCarrier = nil
	self.waitMembers = {}
end

function SceneCarrierProxy:Add(data)
	local carrierInfo = data.carrier
	if(data.guid ~= Game.Myself.data.id) then
		if(carrierInfo and carrierInfo.masterid>0 and carrierInfo.id>0) then
			print(data.guid,"add",carrierInfo.id,carrierInfo.masterid,"进度:",carrierInfo.progress)
			local carrier = self:TryCreateCarrier(carrierInfo.id,carrierInfo.masterid)
			carrier.line = carrierInfo.line
			if(carrierInfo.progress>0) then
				carrier:SetProgress(carrierInfo.progress/100)
				if(carrierInfo.masterid==data.guid) then
					carrier:StartMove()
				end
			end
			if(carrierInfo.assemble and carrierInfo.assemble >0) then
				carrier:ChangeCarrier(carrierInfo.assemble)
			end
			self:CarrierAddMember(carrier,data.guid,carrierInfo.index)
		end
	elseif(carrierInfo and carrierInfo.id ==0 and carrierInfo.masterid ==0 and self.myCarrier) then
		self.myCarrier:GetOff(data.guid,data.pos)
		self:RemoveCarrier(self.myCarrier,data.pos)
	end
end

function SceneCarrierProxy:PureAddSome(datas)
	for i = 1, #datas do
		if datas[i] ~= nil then
			self:Add(datas[i])
		end
	end
end

function SceneCarrierProxy:RefreshAdd(datas)
	return nil
end

function SceneCarrierProxy:AddSome(datas)
	if(self.addMode == SceneObjectProxy.AddMode.Normal) then
		return self:PureAddSome(datas)
	elseif(self.addMode == SceneObjectProxy.AddMode.Refresh) then
		return self:RefreshAdd(datas)
	end
end

function SceneCarrierProxy:InfoAdd(data)
	-- print("InfoAdd",data.carrierid,data.masterid)
	local carrier = self:TryCreateCarrier(data.carrierid,data.masterid)
	if(carrier) then
		local needAnim = (data.needanimation == 1)
		--master单独处理
		self:CarrierAddMember(carrier,data.masterid,LCarrier.MasterSeat,needAnim)
		for i=1,#data.members do
			-- print(data.members[i].id,data.members[i].index)
			self:CarrierAddMember(carrier,data.members[i].id,data.members[i].index,needAnim)
		end
	end
end

function SceneCarrierProxy:InfoPureAddSome(datas)
	for i = 1, #datas do
		if datas[i] ~= nil then
			self:InfoAdd(datas[i])
		end
	end
end

function SceneCarrierProxy:InfoRefreshAdd(datas)
	return nil
end

function SceneCarrierProxy:InfoAddSome(datas)
	if(self.addMode == SceneObjectProxy.AddMode.Normal) then
		return self:InfoPureAddSome(datas)
	elseif(self.addMode == SceneObjectProxy.AddMode.Refresh) then
		return self:InfoRefreshAdd(datas)
	end
end

function SceneCarrierProxy:RemoveCarrier(carrier,pos)
	if(carrier) then
		if(carrier.isMine) then
			FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.OnCarrier,true)
		end
		self.carrierMap[carrier.masterID] = nil
		carrier:DestroyCarrier(pos)
		-- print("SceneCarrierProxy移除载具",carrier.masterID)
	end
end

function SceneCarrierProxy:Remove(guid)
	local carrier = self:Find(guid)
	--TODO
end

function SceneCarrierProxy:RemoveSome(guids)
	if(guids ~= nil and #guids >0) then
		for i = 1, #guids do
			self:Remove(guids[i])
		end
	end
end

function SceneCarrierProxy:Clear()
	-- helplog("清空carrier")
	self:ChangeAddMode(SceneObjectProxy.AddMode.Normal)
	for k,v in pairs(self.carrierMap)do
		if(v==self.myCarrier) then
			v:MyForceLeave()
		end
		v:DestroyCarrier()
	end
	-- FunctionBus.Me():Shutdown()
 	self:Reset()
 	-- GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,roles)
end