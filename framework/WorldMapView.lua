WorldMapView = class("WorldMapView",ContainerView)

WorldMapView.ViewType = UIViewType.NormalLayer

autoImport("WorldMapListView")

function WorldMapView:Init(viewObj)
	self:InitView();

	self:MapEvent();
end

function WorldMapView:InitView()
	self:AddSubView("WorldMapListView", WorldMapListView)
end

function WorldMapView:MapEvent()
	self:AddListenEvt(ServiceEvent.QuestQueryWorldQuestCmd, self.HandleWorldQuestInfo);
end

function WorldMapView:HandleWorldQuestInfo(note)
	local listView = self.viewMap.WorldMapListView;
	listView:UpdateQuestInfo();
end

function WorldMapView:OnEnter()
	WorldMapView.super.OnEnter(self);

	ServiceQuestProxy.Instance:CallQueryWorldQuestCmd();
end

function WorldMapView:OnExit()
	WorldMapView.super.OnExit(self);
end

function WorldMapView:OnShow()
	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(false);
end

function WorldMapView:OnHide()
	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(true);
end