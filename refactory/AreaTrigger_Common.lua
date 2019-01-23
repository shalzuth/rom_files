AreaTrigger_Common = class("AreaTrigger_Common")

AreaTrigger_Common.UpdateInterval = 0.5

AreaTrigger_Common_ClientType = {
	CatchPet = 11,
	GvgDroiyan_FightForArea = 100001,	-- gvg决战的华丽金属
}

function AreaTrigger_Common:ctor()
	self.triggers = {}
	self.nextUpdateTime = 0
	self.triggerEnterCall = {}
	self.triggerEnterCall[SceneMap_pb.EACTTYPE_PURIFY] = self.EnterPurify
	self.triggerEnterCall[SceneMap_pb.EACTTYPE_SEAL] = self.EnterSeal
	self.triggerEnterCall[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.EnterSceneEvent
	self.triggerEnterCall[AreaTrigger_Common_ClientType.CatchPet] = self.EnterCatchPet
	self.triggerEnterCall[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.Enter_GDFightForArea

	self.triggerLeaveCall = {}
	self.triggerLeaveCall[SceneMap_pb.EACTTYPE_PURIFY] = self.LeavePurify
	self.triggerLeaveCall[SceneMap_pb.EACTTYPE_SEAL] = self.LeaveSeal
	self.triggerLeaveCall[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.LeaveSceneEvent
	self.triggerLeaveCall[AreaTrigger_Common_ClientType.CatchPet] = self.LeaveCatchPet
	self.triggerLeaveCall[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.Leave_GDFightForArea

	self.triggerRemoveCall = {}
	self.triggerRemoveCall[SceneMap_pb.EACTTYPE_PURIFY] = self.LeavePurify
	self.triggerRemoveCall[SceneMap_pb.EACTTYPE_SEAL] = self.RemoveSeal
	self.triggerRemoveCall[SceneMap_pb.EACTTYPE_SCENEEVENT or 3] = self.RemoveSceneEvent
	self.triggerRemoveCall[AreaTrigger_Common_ClientType.CatchPet] = self.RemoveCatchPet
	self.triggerRemoveCall[AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea] = self.Remove_GDFightForArea

end

function AreaTrigger_Common:Launch()
	if self.running then
		return
	end
	self.running = true

end

function AreaTrigger_Common:Shutdown()
	if not self.running then
		return
	end
	self.running = false

end

local distanceFunc = VectorUtility.DistanceXZ
function AreaTrigger_Common:Update(time, deltaTime)
	if not self.running then
		return
	end

	if time < self.nextUpdateTime then
		return
	end
	self.nextUpdateTime = time + AreaTrigger_Common.UpdateInterval

	local myselfPosition = Game.Myself:GetPosition()
	for id,trigger in pairs(self.triggers) do
		if(distanceFunc(myselfPosition,trigger.pos)<=trigger.reachDis) then
			self:EnterArea(trigger)
		else
			self:ExitArea(trigger)
		end
	end
end

function AreaTrigger_Common:EnterPurify(trigger)
	QuickUseProxy.Instance:AddTriggerData(trigger)
end

function AreaTrigger_Common:EnterSeal(trigger)
	FunctionRepairSeal.Me():EnterSealArea();
end

function AreaTrigger_Common:EnterSceneEvent(trigger)
	helplog("Enter Scene Event!!!", trigger.id);
	ServiceUserEventProxy.Instance:CallInOutActEventCmd(trigger.id, true);
end

function AreaTrigger_Common:EnterCatchPet(trigger)
	
end

function AreaTrigger_Common:LeavePurify(trigger)
	QuickUseProxy.Instance:RemoveTrigger(trigger)
end

function AreaTrigger_Common:LeaveSeal(trigger)
	FunctionRepairSeal.Me():ExitSealArea();
end

function AreaTrigger_Common:LeaveCatchPet(trigger)
	MsgManager.ShowMsgByIDTable(9008);
end

function AreaTrigger_Common:LeaveSceneEvent(trigger)
	helplog("Leave Scene Event!!!", trigger.id);
	ServiceUserEventProxy.Instance:CallInOutActEventCmd(trigger.id, false);
end

function AreaTrigger_Common:RemoveSeal(trigger)
	FunctionRepairSeal.Me():ExitSealArea(true);
end

function AreaTrigger_Common:RemoveSceneEvent(trigger)
end

function AreaTrigger_Common:EnterArea(trigger)
	if(trigger.reached==false) then
		trigger.reached = true
		local call = self.triggerEnterCall[trigger.type]
		if(call) then
			call(self,trigger)
		end
	end
end

function AreaTrigger_Common:ExitArea(trigger)
	if(trigger.reached==true) then
		trigger.reached = false
		local call = self.triggerLeaveCall[trigger.type]
		if(call) then
			call(self,trigger)
		end
	end
end

function AreaTrigger_Common:_RemoveCall(trigger)
	local call = self.triggerRemoveCall[trigger.type]
	if(call) then
		call(self,trigger)
	end
end

function AreaTrigger_Common:RemoveCatchPet(trigger)
	
end

function AreaTrigger_Common:AddCheck(trigger)
	if(self.triggers[trigger.id]==nil) then
		self.triggers[trigger.id] = trigger
		trigger.reached = false
	end
end

function AreaTrigger_Common:RemoveCheck(id)
	-- printRed("remove MissionAreaTrigger--"..id)
	local trigger = self.triggers[id]
	if(trigger~=nil) then
		self:_RemoveCall(trigger)
	end
	self.triggers[id] = nil
	return trigger
end

--GDFightForArea begin
function AreaTrigger_Common:Enter_GDFightForArea(trigger)
	GameFacade.Instance:sendNotification(TriggerEvent.Enter_GDFightForArea, trigger.id);
end

function AreaTrigger_Common:Leave_GDFightForArea(trigger)
	GameFacade.Instance:sendNotification(TriggerEvent.Leave_GDFightForArea, trigger.id);
end

function AreaTrigger_Common:Remove_GDFightForArea(id)
	GameFacade.Instance:sendNotification(TriggerEvent.Remove_GDFightForArea, id);
end
--GDFightForArea end
