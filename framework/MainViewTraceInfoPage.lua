autoImport("MainViewTaskQuestPage")
autoImport("MainViewFightPage")
autoImport("MainViewGvgPage")
autoImport("MainViewPolyFightPage")
autoImport("MVPFightInfoBord")
autoImport("CardRaidBord");
autoImport("MainviewGvgFinalPage");

MainViewTraceInfoPage = class("MainViewTraceInfoPage",SubView)

function MainViewTraceInfoPage:Init()
	self:AddViewEvts()
	self:initView()
	self.startPvpLaunch = false
end

function MainViewTraceInfoPage:initView(  )
	-- body
	self.taskBord = self:AddSubView("TaskQuestBord",MainViewTaskQuestPage)
	self.fightBord = self:AddSubView("FightInfoBord",MainViewFightPage)
	self.gvgBord = self:AddSubView("GvgInfoBord",MainViewGvgPage)
	self.polyInfoBord = self:AddSubView("PolyFightInfoBord",MainViewPolyFightPage)
	self.mvpInfoBord = self:AddSubView("MVPFightInfoBord",MVPFightInfoBord)

	-- 奥特曼副本
	self:InitAltManRaid();
end

function MainViewTraceInfoPage:AddViewEvts()
	self:AddListenEvt(PVPEvent.PVPDungeonLaunch, self.HandlePVPDungeonLaunch)
	self:AddListenEvt(PVPEvent.PVPDungeonShutDown, self.HandlePVPDungeonShutDown)
	self:AddListenEvt(GVGEvent.GVGDungeonLaunch, self.HandleGVGLaunch)
	self:AddListenEvt(GVGEvent.GVGDungeonShutDown, self.HandleGVGShutDown)
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, self.HandleGVGLaunch)
	self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HandlePolyDungeonLaunch)
	self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.HandlePolyDungeonShutDown)
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.HandlePVPDungeonLaunch)

	self:AddListenEvt(PVPEvent.PVP_MVPFightLaunch, self.HandlePVP_MVPFightLaunch)
	self:AddListenEvt(PVPEvent.PVP_MVPFightShutDown, self.HandlePVP_MVPFightShutDown)


	self:AddListenEvt(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, self.HandleGVGFinalLaunch)
	self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.HandleGVGFinalShutDown)

	self:MapCardEvent();
end

function MainViewTraceInfoPage:HandlePVPDungeonLaunch( note )
	-- body
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	if(fightInfo and not self.startPvpLaunch)then
		local type = fightInfo.pvp_type
		if(type  == PvpProxy.Type.Yoyo or type  == PvpProxy.Type.DesertWolf or type  == PvpProxy.Type.GorgeousMetal)then
			self.startPvpLaunch = true
			self.taskBord:Hide()
			self.fightBord:Show()
		end
	end
end

function MainViewTraceInfoPage:HandlePVPDungeonShutDown( note )
	-- body
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	if(fightInfo)then
		local type = fightInfo.pvp_type
		if(type  == PvpProxy.Type.Yoyo or type  == PvpProxy.Type.DesertWolf or type  == PvpProxy.Type.GorgeousMetal)then
			self.startPvpLaunch = false
			self.taskBord:Show()
			self.fightBord:Hide()
		end
	end
end

function MainViewTraceInfoPage:HandlePolyDungeonLaunch( note )
	-- body
	self.taskBord:Hide()
	self.polyInfoBord:Show()
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	if(fightInfo)then
		fightInfo.ranks = {}
	end
end

function MainViewTraceInfoPage:HandlePolyDungeonShutDown( note )
	-- body
	self.taskBord:Show()
	self.polyInfoBord:Hide()
	local fightInfo = PvpProxy.Instance:GetFightStatInfo()
	if(fightInfo)then
		fightInfo.ranks = {}
	end
end

function MainViewTraceInfoPage:HandleGVGLaunch( note )
	if(GvgProxy.Instance.fire)then
		self.taskBord:Hide()
		self.gvgBord:Show()
	end
end

function MainViewTraceInfoPage:HandleGVGShutDown( note )
	self.taskBord:Show()
	self.gvgBord:Hide()
	local ins = GvgProxy.Instance
	ins:ClearFightInfo()
	ins:ClearQuestInfo()
end

function MainViewTraceInfoPage:HandlePVP_MVPFightLaunch( note )
	self.taskBord:Hide()
	self.mvpInfoBord:Show()
end

function MainViewTraceInfoPage:HandlePVP_MVPFightShutDown( note )
	PvpProxy.Instance:ClearBosses()
	self.taskBord:Show()
	self.mvpInfoBord:Hide()
end

-- card raid begin
function MainViewTraceInfoPage:HandleGVGFinalLaunch()
	if(self.gvgFinalFight == nil)then
		local container = self:FindGO("TraceInfoBord");
		self.gvgFinalFight = self:AddSubView("MainviewGvgFinalPage",MainviewGvgFinalPage)
		self.gvgFinalFight:ResetParent(container)
		self.taskBord:Hide()
	end
end
function MainViewTraceInfoPage:HandleGVGFinalShutDown()
	if(self.gvgFinalFight)then
		self:RemoveSubView("MainviewGvgFinalPage")
		self.taskBord:Show()
	end
	self.gvgFinalFight = nil;
end


-- card raid begin
function MainViewTraceInfoPage:AddCardRaidBord()
	if(self.cardRaidBord == nil)then
		local container = self:FindGO("TraceInfoBord");
		self.cardRaidBord = CardRaidBord.CreateSelf(container);

		local taskBord = self:FindGO("TaskQuestBord")
		taskBord:SetActive(false);
	end
end
function MainViewTraceInfoPage:RemoveCardRaidBord()
	if(self.cardRaidBord)then
		self.cardRaidBord:Destroy();
		local taskBord = self:FindGO("TaskQuestBord")
		taskBord:SetActive(true);
	end
	self.cardRaidBord = nil;
	
end

function MainViewTraceInfoPage:MapCardEvent()
	self:AddListenEvt(ServiceEvent.PveCardUpdateProcessPveCardCmd, self.HandleCardRaidBordUpdate);
	self:AddListenEvt(ServiceEvent.PveCardSyncProcessPveCardCmd, self.HandleCardRaidBordUpdate);
	self:AddListenEvt(ServiceEvent.PveCardFinishPlayCardCmd, self.HandlePveCardFinish);
	
	self:AddListenEvt(PVEEvent.PVE_CardLaunch, self.AddCardRaidBord);
	self:AddListenEvt(PVEEvent.PVE_CardShutdown, self.RemoveCardRaidBord);

end

function MainViewTraceInfoPage:HandleCardRaidBordUpdate()
	if(self.cardRaidBord == nil)then
		return;
	end
	self.cardRaidBord:UpdateCards();
end

function MainViewTraceInfoPage:HandlePveCardFinish()
	if(self.cardRaidBord == nil)then
		return;
	end
	self.cardRaidBord:Finish();
end
-- card raid end



-- altman raid begin 
function MainViewTraceInfoPage:InitAltManRaid()
	self:MapAltmanEvent();
end

function MainViewTraceInfoPage:MapAltmanEvent()
	self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd, self.UpdateAltmanRaidInfo);
	self:AddListenEvt(PVEEvent.Altman_Launch, self.HandleEnterAltmanRaid);
	self:AddListenEvt(PVEEvent.Altman_Shutdown, self.HandleExitAltmanRaid);
end

local Altman_ForbidView = { 11 };
function MainViewTraceInfoPage:HandleEnterAltmanRaid(note)
	for i=1,#Altman_ForbidView do
		UIManagerProxy.Instance:SetForbidView(Altman_ForbidView[i], 3606, true);
	end

	self:UpdateAltmanRaidInfo();
end

function MainViewTraceInfoPage:HandleExitAltmanRaid(note)
	for i=1,#Altman_ForbidView do
		UIManagerProxy.Instance:UnSetForbidView(Altman_ForbidView[i]);
	end
	self:HideAltmanRaidInfo();
end

function MainViewTraceInfoPage:GetAltmanInfoBord(noCreate)
	if(noCreate)then
		return self.altmanInfoBord;
	end

	if(self.altmanInfoBord == nil)then
		autoImport("AltmanInfoBord");
		local container = self:FindGO("TraceInfoBord");
		self.altmanInfoBord = AltmanInfoBord.new(container);
	end

	return self.altmanInfoBord;
end

function MainViewTraceInfoPage:UpdateAltmanRaidInfo()
	if (not Game.MapManager:IsPveMode_AltMan()) then
		self:HideAltmanRaidInfo();
		return;
	end

	local altmanInfoBord = self:GetAltmanInfoBord();
	altmanInfoBord:ShowSelf();
	altmanInfoBord:Refresh();

	self.taskBord:Hide()
end

function MainViewTraceInfoPage:HideAltmanRaidInfo()
	local altmanInfoBord = self:GetAltmanInfoBord(true);
	if(altmanInfoBord)then
		altmanInfoBord:HideSelf();
	end

	self.taskBord:Show()
end
-- altman raid end