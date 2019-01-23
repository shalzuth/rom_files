autoImport("YoyoViewPage")
autoImport("DesertWolfView")
autoImport("GorgeousMetalView")

PvpMainView = class("PvpMainView",ContainerView)
PvpMainView.ViewType = UIViewType.NormalLayer

function PvpMainView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function PvpMainView:FindObjs()
	self.yoyoToggle = self:FindGO("YoyoBtn")
	self.desertWolfToggle = self:FindGO("DesertWolfBtn")
	self.gorgeousMetalToggle = self:FindGO("GorgeousMetalBtn")

	self.yoyoViewObj = self:FindGO("YoyoView")
	self.desertWolfViewObj = self:FindGO("DesertWolfView")
	self.gorgeousMetalViewObj = self:FindGO("GorgeousMetalView")
	
	self.playerTipStick = self:FindComponent("Stick", UIWidget);
end

function PvpMainView:AddEvts()
	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
	self:AddListenEvt(PVPEvent.PVPDungeonLaunch, self.HandleDungeonLaunch);
end

function PvpMainView:HandleDungeonLaunch(note)
	self:CloseSelf();
end

function PvpMainView:AddViewEvts()

end

function PvpMainView:InitShow()
	self.yoyoView = self:AddSubView("YoyoViewPage", YoyoViewPage)
	self.desertWolfView = self:AddSubView("DesertWolfView", DesertWolfView)
	self.gorgeousMetalView = self:AddSubView("GorgeousMetalView", GorgeousMetalView)

	self:AddTabChangeEvent(self.yoyoToggle, self.yoyoViewObj, PanelConfig.YoyoViewPage)
	self:AddTabChangeEvent(self.desertWolfToggle, self.desertWolfViewObj, PanelConfig.DesertWolfView)
	self:AddTabChangeEvent(self.gorgeousMetalToggle, self.gorgeousMetalViewObj, PanelConfig.GorgeousMetalView)

	if self.viewdata.view and self.viewdata.view.tab then
		self:TabChangeHandler(self.viewdata.view.tab)
	else
		self:TabChangeHandler(PanelConfig.YoyoViewPage.tab)
	end
end

function PvpMainView:TabChangeHandler(key)
	if self.currentKey ~= key then
		PvpMainView.super.TabChangeHandler(self, key)
		if key == PanelConfig.YoyoViewPage.tab then
			self.yoyoView:ClearLeanTick()
			self.yoyoView:UpdateView()
		elseif key == PanelConfig.DesertWolfView.tab then
			self.desertWolfView:UpdateView()
		elseif key == PanelConfig.GorgeousMetalView.tab then
			self.gorgeousMetalView:UpdateView()
		end

		self.currentKey = key
	end
end

function PvpMainView:OnEnter()
	PvpMainView.super.OnEnter(self);
	ServiceMatchCCmdProxy.Instance:CallReqMyRoomMatchCCmd();
end

function PvpMainView:OnExit()
	PvpMainView.super.OnExit(self);
end

function PvpMainView:HandleLoadScene()
	if PvpProxy.Instance:IsSelfInGuildBase() then
		self:CloseSelf()
	end
end
