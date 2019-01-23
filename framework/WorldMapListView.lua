WorldMapListView = class("WorldMapListView",SubView)

autoImport("UIGridListCtrl")
autoImport("WorldMapAreaCell")
autoImport("WorldMapMenuCell")

function WorldMapListView:ctor(viewObj)
	WorldMapListView.super.ctor(self, viewObj);

	self.enableMapClick = true;

	local preferb = self:LoadPreferb("view/WorldMapListView");
	preferb.transform:SetParent(self.trans, false);
	self.gameObject = preferb;

	self:InitViewData();
	self:InitView();
	self:MapListenEvent();
end

function WorldMapListView:InitViewData()
	self.myself = Game.Myself;
end

function WorldMapListView:InitView()
	self.mapScrollView = self:FindComponent("MapScrollView", UIScrollViewEx);

	self.menuScrollView = self:FindComponent("MenuScrollView", UIScrollView);
	self.map = self:FindComponent("Map", UITexture);
	self.mapTween = self:FindComponent("MapContainer", Transform);
	self.menuTable = self:FindComponent("MenuTable", UITable);
	self.menuTween = self:FindComponent("TweenMenu", TweenPosition);
	-- refresh Bug
	local menuScrollGo = self:FindGO("MenuScrollView");
	self.menuTween:SetOnFinished(function()
		menuScrollGo:SetActive(false);
		menuScrollGo:SetActive(true);
	end);

	self.zoomSymbol = self:FindComponent("ZoomSymbol", UIMultiSprite);
	self.zoomLabel = self:FindComponent("ZoomLabel" , UILabel)
	self.hideInfoSymbol = self:FindComponent("HideInfoSymbol", UIMultiSprite)
	self.hideInfoLabel = self:FindComponent("HideInfoLabel" , UILabel)	
	self.myPosSymbol = self:FindGO("MyPosSymbol");
	self.chooseSymbol = self:FindComponent("ChooseSymbol", Transform);

	self:InitMapCells();
	self:UpdateTeamMemerPos();
	self.menuCtl = UIGridListCtrl.new(self.menuTable, WorldMapMenuCell, "WorldMapMenuCell");
	self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuCell, self);
	self.menuCtl:AddEventListener(WorldMapMenuEvent.StartTrace, self.StartTrace, self);

	self.zoomBtn = self:FindGO("ZoomBtn");
	self:AddClickEvent(self.zoomBtn, function (go)
		if(self.zoomIn)then
			self:PlayMapZoomAnim(false);
		else
			self:PlayMapZoomAnim(true);
		end
	end);

	self.hideBtn = self:FindGO("HideInfoBtn");
	self.showDetail = true;
	self:AddClickEvent(self.hideBtn, function (go)
		self:ActiveMapDetail(not self.showDetail);
	end);

	self.ig = self.gameObject:GetComponent(InputGesture);
	self.ig.zoomInAction = function ()
		self:PlayMapZoomAnim(true);
	end
	self.ig.zoomOutAction = function ()
		self:PlayMapZoomAnim(false);
	end

	self.zoomSymbol.CurrentState = 0
	self.zoomLabel.text = ZhString.WorldMapListView_zoomIn
	self.hideInfoSymbol.CurrentState = 1
	self.hideInfoLabel.text = ZhString.WorldMapListView_infoHide
end

local tempArgs = {};
function WorldMapListView:ClickMenuCell(cellctl)
	if(Game.Myself:IsDead())then
		MsgManager.ShowMsgByIDTable(2500);
	else
		if(cellctl.data)then
			TableUtility.TableClear(tempArgs);
			tempArgs.targetMapID = cellctl.data.id;

			local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove);
			if(cmd)then
				Game.Myself:Client_SetMissionCommand( cmd );
			end
			
			self.container:CloseSelf();
		end
	end
end

function WorldMapListView:StartTrace()
	self.container:CloseSelf();
end

function WorldMapListView:ActiveButtons(b)
	self.zoomBtn:SetActive(b);
	self.hideBtn:SetActive(b);
end

function WorldMapListView:EnableMapClick(b)
	self.enableMapClick = b;
end

function WorldMapListView:PlayMapZoomAnim(zoomIn)
	self.zoomIn = zoomIn;
	if(zoomIn)then
		self.zoomSymbol.CurrentState = 1;
		self.zoomLabel.text = ZhString.WorldMapListView_zoomOut;

		self:ZoomScrollView(Vector3(1.2, 1.2, 1.2), 0.2, self.myPosSymbol.transform, function ()
			self.mapScrollView.enabled = true;
		end);
	else
		self.zoomSymbol.CurrentState = 0;
		self.zoomLabel.text = ZhString.WorldMapListView_zoomIn;

		self:ZoomScrollView(Vector3(0.62, 0.62, 0.62), 0.2, self.mapTween.gameObject, function ()
			self.mapScrollView.enabled = false;
		end);
	end
end

function WorldMapListView:PlayMenuAnim(dir, resetToBeginning)
	self.menuShow = dir;
	if(resetToBeginning)then
		self.menuTween:ResetToBeginning();
	end
	if(dir)then
		self.menuTween:PlayForward();
	else
		self.menuTween:PlayReverse();
	end
end

function WorldMapListView:ActiveMapDetail(active)
	self.showDetail = active;

	if active then
		self.hideInfoSymbol.CurrentState = 1
		self.hideInfoLabel.text = ZhString.WorldMapListView_infoHide
	else
		self.hideInfoSymbol.CurrentState = 0
		self.hideInfoLabel.text = ZhString.WorldMapListView_infoShow
	end

	local cells = self.mapCtl:GetCells();
	for k, cell in pairs(cells)do
		if(type(cell.data)=="table" and cell.data.isactive)then
			cell:SetCellInfoActive(active);
		end
	end

	local menuCells = self.menuCtl:GetCells();
	for _,cell in pairs(menuCells)do
		cell:SetCellInfoActive(active);
	end
end

function WorldMapListView:InitMapCells()
	self.mapGrid = self:FindComponent("MapGrid", UIGrid);
	self.mapCtl = UIGridListCtrl.new(self.mapGrid, WorldMapAreaCell, "WorldMapAreaCell");
	self.mapCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self);

	local mapSize = {x=self.map.width, y=self.map.height};
	local gridPos = Vector3(-(mapSize.x- WorldMapCellSize.x)/2, (mapSize.y- WorldMapCellSize.y)/2, 0);
	self.mapGrid.transform.localPosition = gridPos;

	local xm,ym = math.ceil(mapSize.x/WorldMapCellSize.x), math.ceil(mapSize.y/WorldMapCellSize.y);
	self.mapGrid.maxPerLine = xm;
	local constMapDatas = {};

	self.indexs_map = {};

	local ori_x, ori_y = WorldMapProxy.OriginalPoint_X, WorldMapProxy.OriginalPoint_Y
	local offset_x = math.abs(1 - ori_x);
	local offset_y = math.abs(1 - ori_y);
	for y = ori_y, ym-offset_y do

		self.indexs_map[y] = {};

		for x = ori_x, xm-offset_x do
			local data = WorldMapProxy.Instance:GetMapAreaDataByPos(y, x);
			table.insert(constMapDatas, data or string.format("%s_%s", x, y));

			self.indexs_map[y][x] = #constMapDatas;

		end
	end
	self.mapCtl:ResetDatas(constMapDatas);


end

function WorldMapListView:ClickMapCell(cellctl)
	if(not self.enableMapClick)then
		return;
	end
	
	if(type(cellctl.data) == "table")then
		if(self.lastClickCell==cellctl)then
			self:PlayMenuAnim(not self.menuShow);
		else
			local mapid = cellctl.data.mapid;
			if(mapid)then
				self:UpdateMapMenuList(mapid);

				self.chooseSymbol:SetParent(cellctl.trans, false);
				self.chooseSymbol.localScale = Vector3.one;
				self.chooseSymbol.localPosition = Vector3.zero;
			end
		end
		self.lastClickCell = cellctl;
	end
end

function WorldMapListView:UpdateMapMenuList(mapid)
	local mapdata = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapid);
	if(mapdata)then
		self.menuScrollView:ResetPosition();
		self.menuCtl:ResetDatas(mapdata.childMaps);
		self.menuTable.repositionNow = true;
		self:PlayMenuAnim(true, true);
	end
end

function WorldMapListView:GetMapCellByMapId(mapid)
	local mapdata = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapid);
	local cells = self.mapCtl:GetCells();

	local pos = mapdata and mapdata.pos;
	if(pos and pos.x and pos.y)then
		local index = self.indexs_map[ pos.x ][ pos.y ];
		return cells[ index ];
	end
end

function WorldMapListView:UpdateTeamMemerPos()
	local myPosMap = SceneProxy.Instance.currentScene.mapID;
	local cell = self:GetMapCellByMapId(myPosMap);
	if(cell)then
		self.myPosSymbol.transform:SetParent(cell.trans, false);
	end

	local myid = Game.Myself.data.id;
	if(TeamProxy.Instance:IHaveTeam())then
		local myTeam = TeamProxy.Instance.myTeam;
		local memberlst = myTeam:GetMembersList();
		for i=1,#memberlst do
			local member = memberlst[i];
			if(member and member.mapid and member.id~=myid 
				and not member:IsOffline() 
				and member.zoneid == MyselfProxy.Instance:GetZoneId())then
				local cell = self:GetMapCellByMapId(member.mapid);
				if(cell)then
					cell:AddMapTeamMember();
				end
			end
		end
	end
end

function WorldMapListView:MapListenEvent()
	-- self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange);
end

function WorldMapListView:CenterMapByMapId(mapid, endScale, time, onfinish)
	local cell = self:GetMapCellByMapId(mapid)
	if(cell)then
		self:ZoomScrollView(endScale, time, cell.gameObject, onfinish);
	end
end

function WorldMapListView:ZoomScrollView(endScale, time , centerTarget, onfinish)
	local mDrag = self.mapScrollView;
	local mPanel = mDrag.panel;
	local mTrans = mDrag.transform;
	local pTrans = mTrans.parent;
	time = time or 1;

	local startPos = centerTarget.transform.position;
	local endPos = (mPanel.worldCorners [1] + mPanel.worldCorners [3]) * 0.5;	

	LeanTween.cancel(mTrans.gameObject);
	LeanTween.value(mTrans.gameObject, function (f)
		self.mapTween.localScale = Vector3.Lerp (Vector3.one, endScale, f);

		local before = centerTarget.transform.position;
		local after = Vector3.Lerp (startPos, endPos, f);
		local offset = after - before;

		local mlPosition = mTrans.localPosition;
		mTrans.position = mTrans.position + offset;
		mPanel.clipOffset = mPanel.clipOffset - (mTrans.localPosition - mlPosition);

		-- restrict
		local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, mTrans);
		local calOffset = mPanel:CalculateConstrainOffset (b.min, b.max);
		if (calOffset.magnitude >= 0.01) then
			mTrans.localPosition = mTrans.localPosition + calOffset;
			mPanel.clipOffset = mPanel.clipOffset - Vector2(calOffset.x, calOffset.y);
		end
	end, 0, 1, time):setOnComplete(onfinish):setDestroyOnComplete(true);
end

function WorldMapListView:UpdateQuestInfo()
	local cells = self.mapCtl:GetCells();
	for k, cell in pairs(cells)do
		if(type(cell.data)=="table" and cell.data.isactive)then
			cell:UpdateQuestSymbol();
		end
	end

	local menuCells = self.menuCtl:GetCells();
	for _,cell in pairs(menuCells)do
		cell:UpdateQuestSymbol();
	end
end
