local baseView = autoImport("BaseView")
GVGPortalView = class("GVGPortalView",BaseView)
GVGPortalView.ViewType = UIViewType.NormalLayer

function GVGPortalView:Init()
	self.helpPanel = self:FindGO("GeneralHelp")
	self.helpPanelText = self:FindComponent("IntroduceLabel",UIRichLabel)
	self.portalDesc = self:FindComponent("PortalDesc",UILabel)
	self.lineUpLabel = self:FindComponent("LineUpLabel",UILabel)
	self.noticeLineUp = self:FindGO("NoticeLineUp")
	self:addViewEventListener()
	self:addEventListener()
	self:InitData()
end

function GVGPortalView:addViewEventListener(  )
	-- body
	self:AddButtonEvent("CloseButton",function (  )
		-- body
		self:CloseSelf()
		-- local nowtime = ServerTime.CurServerTime()/1000;
		-- local data = {}
		-- data.pvp_type = PvpProxy.Type.SuGVG
		-- data.roomid = 1909
		-- data.state = MatchCCmd_pb.EROOMSTATE_WAIT_JOIN
		-- data.endtime = nowtime + 56;
		-- ServiceMatchCCmdProxy.Instance:RecvNtfRoomStateCCmd(data)
	end)
	self:AddButtonEvent("CloseButtonHelp",function (  )
		-- body
		self.helpPanel:SetActive(false)
	end)

	self:AddButtonEvent("Match",function (  )
		-- body
		local guildData = GuildProxy.Instance.myGuildData;
		if(guildData.insupergvg)then
			ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.SuGVG)
		else
			MsgManager.ShowMsgByID(25515)
		end
		-- self:CloseSelf()
	end)

	self:AddButtonEvent("LineUpCancel",function (  )
		-- body
		-- helplog("LineUpCancel", PvpProxy.Type.SuGVG)
		ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(PvpProxy.Type.SuGVG)
		self.noticeLineUp:SetActive(false)
		if(self.tickMg)then
			self.tickMg:ClearTick(self)
			self.tickMg = nil
		end
	end)
end

function GVGPortalView:InitData()
	self.portalDesc.text = ZhString.GVGProtalDesc
end

function GVGPortalView:addEventListener()
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfRoomStateCCmd, self.ShowLineUpPanel)
	self:AddListenEvt(ServiceEvent.PlayerMapChange,self.SceneLoadFinishHandler)
end

function GVGPortalView:ShowLineUpPanel( note )
	local data = note.body;
	-- helplog("===GVGPortalView:ShowLineUpPanel===>>>")
	-- TableUtil.Print(note)
	if(data)then
		local dtype, roomState, lineEndTime = data.pvp_type, data.state, data.endtime;
		if(dtype == PvpProxy.Type.SuGVG and roomState == MatchCCmd_pb.EROOMSTATE_WAIT_JOIN)then
			self.noticeLineUp:SetActive(true)
			self.lineEndTime = lineEndTime
			if(self.tickMg)then
				self.tickMg:ClearTick(self)
			else
				self.tickMg = TimeTickManager.Me()
			end
			self.tickMg:CreateTick(0,1000,self.updateCountDownTime,self)
		end
	end
end

function GVGPortalView:AddHelpButtonEvent()
	local go = self:FindGO("HelpButton")
	if(go)then
		self:AddClickEvent(go,function (g)
			self.helpPanel:SetActive(true)
			self.helpPanelText.text = Table_Help[self.viewdata.view.id].Desc
		end)
	end
end

function GVGPortalView:OnExit()
	if(self.tickMg)then
		self.tickMg:ClearTick(self)
		self.tickMg = nil
	end
end

function GVGPortalView:updateCountDownTime()
	local nowtime = ServerTime.CurServerTime()/1000;
	local showTime = math.max(math.floor(self.lineEndTime - nowtime), 0)
	self.lineUpLabel.text = string.format(ZhString.GVGProtalLineUpNotice, showTime)
end

function GVGPortalView:SceneLoadFinishHandler( note )
	if(note.type == LoadSceneEvent.StartLoad) then
		self:CloseSelf()
	end
end
