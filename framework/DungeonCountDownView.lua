DungeonCountDownView = class("DungeonCountDownView",ContainerView)

DungeonCountDownView.ViewType = UIViewType.GuideLayer

function DungeonCountDownView:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitShow()
end

function DungeonCountDownView:FindObjs()
	self.lab = self:FindGO("Context"):GetComponent(UILabel)
	self.timeSlider = self:FindGO("TimeSlider"):GetComponent(UISlider)
end

function DungeonCountDownView:AddEvts()
	self:AddListenEvt(MyselfEvent.DeathBegin , self.CloseSelf)
	self:AddListenEvt(ServiceEvent.NUserCountDownTickUserCmd, self.CloseSelf)
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam , self.CloseSelf)

	self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.HandleCancelFollow)
end

function DungeonCountDownView:HandleCancelFollow()
	local id = Game.Myself:Client_GetFollowLeaderID()
	if id == 0 then
		self:CloseSelf()
	end
end

function DungeonCountDownView:InitShow()
	self.leftTime = 15
	self.currentTime = 0
	self.totalTime = 15

	local viewdata = self.viewdata.viewdata
	if viewdata then
		self.leftTime = viewdata.tick
		self.totalTime = self.leftTime
		self.extparam = viewdata.extparam
		self.time = viewdata.time
		self.sign = viewdata.sign
		self.type = viewdata.type
	end

	TimeTickManager.Me():CreateTick(0,1000,self.TickTime,self)

	if viewdata.type == SceneUser2_pb.ECOUNTDOWNTYPE_DOJO then
		if self.extparam then
			local dojoData = Table_Guild_Dojo[self.extparam]
			if dojoData then
				if dojoData.Name then
					self.lab.text = string.format(ZhString.Dungeon_CountDown , dojoData.Name)
				else
					errorLog("DungeonCountDownView InitShow dojoData.Name = nil")
				end
			else
				errorLog(string.format("DungeonCountDownView InitShow : Table_Guild_Dojo[%s] == nil",tostring(self.extparam)))
			end
		end
	elseif viewdata.type == SceneUser2_pb.ECOUNTDOWNTYPE_TOWER then
		self.lab.text = string.format(ZhString.Dungeon_CountDown , ZhString.EndlessTower_name)
	elseif viewdata.type == SceneUser2_pb.ECOUNTDOWNTYPE_ALTMAN then
		self.lab.text = string.format(ZhString.Dungeon_CountDown , ZhString.DungeonCountDownView_AltmanRaidName)
	end
end

function DungeonCountDownView:OnExit()
	TimeTickManager.Me():ClearTick(self)
end

function DungeonCountDownView:TickTime()
	self:UpdateTime(self.currentTime,self.leftTime,self.totalTime)
	self.currentTime = self.currentTime + 1
	self.leftTime = self.leftTime - 1
end

function DungeonCountDownView:UpdateTime(currentTime,leftTime,totalTime)
	LeanTween.cancel(self.gameObject)

	self.timeSlider.gameObject:SetActive(true)
	local value = currentTime/totalTime
	LeanTween.value(self.gameObject, function(v)
		self.timeSlider.value = v
	end, value , 1, leftTime):setOnComplete(function()
		if self.type == SceneUser2_pb.ECOUNTDOWNTYPE_DOJO then
			ServiceDojoProxy.Instance:CallEnterDojo(nil,nil,nil,self.time,self.sign)
			self:sendNotification(DojoEvent.EnterSuccess)
			LogUtility.Info("CallEnterDojo")
		elseif self.type == SceneUser2_pb.ECOUNTDOWNTYPE_TOWER then
			ServiceInfiniteTowerProxy.Instance:CallEnterTower(0,Game.Myself.data.id,nil,self.time,self.sign)
			LogUtility.Info("CallEnterTower")
		elseif self.type == SceneUser2_pb.ECOUNTDOWNTYPE_ALTMAN then
			ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN,Game.Myself.data.id,nil,self.time,self.sign)
			LogUtility.Info("CallTeamRaidEnterCmd")
		end		

		self:CloseSelf()
	end)
end