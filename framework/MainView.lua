local MainView = class("MainView",ContainerView)

MainView.ViewType = UIViewType.MainLayer

autoImport("HeadImageData");
autoImport("MainViewSkillPage");
autoImport("MainViewItemPage");
autoImport("MainViewInfoPage");
autoImport("MainViewMenuPage")
autoImport("MainUseEquipPopup")
autoImport("MainViewTeamPage");
autoImport("MainViewHeadPage");
autoImport("EndlessTowerConform")
autoImport("MainViewMiniMap")
autoImport("MainviewRaidTaskPage")
autoImport("MainViewAddTrace")
autoImport("MainViewChatMsgPage")
autoImport("MainViewAutoAimMonster")
autoImport("MainViewTraceInfoPage")
autoImport("MainViewAuctionPage")
autoImport("RaidCountMsg")
autoImport("MainviewActivityPage")
autoImport("MainViewRecallPage")

autoImport("AdventureItemData")

MainViewShortCutBord = {
	"ShortCutGrid",
	"SkillBord",
}

--todo xde
autoImport("OverseaHostHelper")

function MainView:Init()
	FunctionCDCommand.Me():StartCDProxy(ShotCutItemCDRefresher)

	self:AddSubView("skillShortCutPage", MainViewSkillPage);
	self.infoPage = self:AddSubView("infoPage", MainViewInfoPage);
	self.menuPage = self:AddSubView("menu", MainViewMenuPage);
	self:AddSubView("MainUseEquipPopup", MainUseEquipPopup);
	self:AddSubView("TeamPage", MainViewTeamPage);
	self:AddSubView("HeadPage", MainViewHeadPage);
	self:AddSubView("MainViewItemPage", MainViewItemPage);
	self:AddSubView("MainViewMiniMap", MainViewMiniMap);
	self:AddSubView("MainviewRaidTaskPage", MainviewRaidTaskPage);
	self:AddSubView("MainViewAddTrace",MainViewAddTrace)
	self.chatMsgPage = self:AddSubView("MainViewChatMsgPage",MainViewChatMsgPage)
	self:AddSubView("TraceInfoBord",MainViewTraceInfoPage)
	self:AddSubView("MainviewActivityPage",MainviewActivityPage)
	self.autoAimMonster = self:AddSubView("MainViewAutoAimMonster",MainViewAutoAimMonster)
	self:AddSubView("MainViewRecallPage",MainViewRecallPage)
	if not GameConfig.SystemForbid.Auction then
		--self:AddSubView("MainViewAuctionPage",MainViewAuctionPage)
		self:AddSubView("MainViewAuctionPage",MainViewAuctionPage)
	end

	self.mainBord = self:FindChild("MainBord");

	--记录已经显示的界面
	self.showViews = {};
	self:FindObjs();
	self:AddBtnListener();
	self:MapViewListener();
	self:TestFloat();
	-- self:CheckMaskName()

	--todo xde check storeiap
	-- OverseaHostHelper:CheckStoreIap()
	
	
	-- todo xde fix oversea back
	local moreBord = self:FindGO("MoreBord")
	moreBord.transform.localPosition = Vector3(-189.2,-144,0)
	
	local background = self:FindGO("Background",moreBord):GetComponent(UISprite)
	background.transform.localPosition = Vector3(-48,-220,0)
	background.width = 492
	background.height = 524
	
	local titlename = self:FindGO("titlename",moreBord)
	titlename.transform.localPosition = Vector3(0,216,0)
	
	local TitleBg = self:FindGO("TitleBg",moreBord):GetComponent(UISprite)
	TitleBg.transform.localPosition = Vector3(2,192,0)
	TitleBg.width = 450
	TitleBg.height = 100
	
	local mapbg = self:FindGO("mapbg",moreBord)
	mapbg.transform.localPosition = Vector3(1,-18,0)
	
	local Sprite = self:FindGO("Sprite",moreBord):GetComponent(UISprite)
	Sprite.transform.localPosition = Vector3(0,0,0)
	Sprite.width = 440
	Sprite.height = 422
	
	local CloseMore = self:FindGO("CloseMore",moreBord)
	CloseMore.transform.localPosition = Vector3(154,-2,0)

	--todo xde check storeiap
	OverseaHostHelper:CheckStoreIap(true)
	-- todo xde 强行取一次，为了后续打开没问题
	ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function MainView:TestFloat()
	local testButton = self:FindGO("TestFloat");
		self.index = 0
	self:AddClickEvent(testButton, function (g)
		-- MsgManager.ShowMsgByID(3071);
		self.fightStatInfo = {}
		if(self.index % 3 == 0)then
			self.fightStatInfo.pvp_type = PvpProxy.Type.Yoyo
		elseif(self.index %3 == 1)then
			self.fightStatInfo.pvp_type = PvpProxy.Type.DesertWolf
		elseif(self.index %3 == 2)then
			self.fightStatInfo.pvp_type = PvpProxy.Type.GorgeousMetal
		end
		self.index  = self.index +1
		self.fightStatInfo.starttime = os.time()
		self.fightStatInfo.player_num = 20
		self.fightStatInfo.score = 20
		self.fightStatInfo.my_teamscore = 3000
		self.fightStatInfo.enemy_teamscore = 200
		self.fightStatInfo.remain_hp = 10
		PvpProxy.Instance:NtfFightStatCCmd(self.fightStatInfo)

		self:sendNotification(PVPEvent.PVPDungeonLaunch)
		
	end);
	self:AddDoubleClickEvent(testButton, function (g)
		print("Add Double Click!!");
		self:sendNotification(PVPEvent.PVPDungeonShutDown)
		self:sendNotification(ServiceEvent.FuBenCmdMonsterCountUserCmd, {num = 0});
	end);
end

function MainView:CheckMaskName()
	if FunctionMaskWord.Me():CheckMaskWord(Game.Myself.data.name, 
		FunctionMaskWord.MaskWordType.SpecialSymbol | FunctionMaskWord.MaskWordType.Chat | FunctionMaskWord.MaskWordType.SpecialName) then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ChangeNameView})
	end
end

function MainView:FindObjs()
	self.topFuncs = self:FindChild("TopRightFunc");
	self.moreBord = self:FindChild("MoreBord");
	self.mapBord = self:FindChild("MapBord");
	self.Anchor_DownLeft=self:FindGO("Anchor_DownLeft");
	self.raidMsgRoot = self:FindGO("RaidMsgPos")
end

function MainView:SetMainViewState(stateIndex)
	if(stateIndex == 1)then
		self.moreBord:SetActive(false);
		self.mapBord:SetActive(false);
	end
end

function MainView:OnEnter()
	MainView.super.OnEnter(self)
end

function MainView:OnExit()
	MainView.super.OnExit(self)
	FunctionCDCommand.Me():GetCDProxy(ShotCutItemCDRefresher):RemoveAll()
end

function MainView:AddBtnListener()
	self.showskill = false;
	self:AddButtonEvent("changeBtn", function (go)
		local key = self.showskill and "skill" or "func";
		self.showskill = not self.showskill;
	end);
end

function MainView:MapViewListener()
	self:AddListenEvt(UIEvent.EnterView, self.HandleEnterView);
	self:AddListenEvt(UIEvent.ExitView, self.HandleExitView);
	self:AddListenEvt(MainViewEvent.ShowOrHide, self.HandleShowOrHide);

	self:AddListenEvt(MainViewEvent.ActiveShortCutBord, self.HandleActiveShortCutBord);
	EventManager.Me():AddEventListener(SystemMsgEvent.RaidAdd,self.OnRaidMsg,self)
	EventManager.Me():AddEventListener(SystemMsgEvent.RaidRemove,self.RemoveRaidMsg,self)
	EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.SceneLoadHandler, self)
end

function MainView:SceneLoadHandler()
	self:RemoveRaidMsg()
end

function MainView:OnRaidMsg(evt)
	local data = evt.data
	if(self.raidMsg == nil) then
		self.raidMsg = RaidCountMsg.new(self.raidMsgRoot)
	end
	
	self.raidMsg:SetData(data)
end

function MainView:RemoveRaidMsg()
	if(self.raidMsg) then 
		self.raidMsg:Exit()
		self.raidMsg = nil
	end
end

function MainView:HandleActiveShortCutBord(note)
	local active = note.body == true;
	self:ActiveShortCutBord(active);
end

function MainView:ActiveShortCutBord(b)
	for i=1,#MainViewShortCutBord do
		local go = self:FindGO(MainViewShortCutBord[i]);
		if(go)then
			go:SetActive(b);
		end
	end
end

-- 进入副本的时候topfuncs关闭
function MainView:HandleTopFuncActive(note)
	local data = note.body;
	if(data == nil)then
		return;
	end
	if(note.type == LoadSceneEvent.FinishLoad)then
		self.topFuncs:SetActive(data.dmapID == 0);
		self:SetMainViewState(1);
	end
end

function MainView:HandleShowOrHide(note)
	self:ShowOrHideBord(note.body);
	if note.body == true then
		self.chatMsgPage:OnShow()
	end
end

function MainView:HandleEnterView(note)
	local enterView = note.body;
	if(enterView.ViewType.hideMainView)then
		self.showViews[enterView.ViewType.depth] = enterView;
		for k,v in pairs(self.showViews) do
			if(v~=nil)then
				self:ShowOrHideBord(false);
				return;
			end
		end
	end
end

function MainView:HandleExitView(note)
	local exitView = note.body;
	if(exitView.ViewType.hideMainView)then
		self.showViews[exitView.ViewType.depth] = nil;
		local needShow = true;
		for k,v in pairs(self.showViews) do
			if(v~=nil)then
				needShow = false;
			end
		end
		self:ShowOrHideBord(needShow);
	end
end

function MainView:ShowOrHideBord(isShow)
	self.mainBord:SetActive(isShow);
	local skillBord = self:FindGO("SkillBord");
	skillBord:SetActive(isShow);
end

function MainView:OnShow()
	if(self.viewMap)then
		for _, viewCtl in pairs(self.viewMap)do
			if(viewCtl and viewCtl.OnShow)then
				viewCtl:OnShow();
			end
		end
	end
end

return MainView