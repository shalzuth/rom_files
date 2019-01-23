GLandStatusListView = class("GLandStatusListView", ContainerView);

GLandStatusListView.ViewType = UIViewType.NormalLayer;

autoImport("WrapListCtrl");
autoImport("GLandStatusListCell");

function GLandStatusListView:Init()
	self:MapEvent();
	self:InitUI();
end

function GLandStatusListView:InitUI()
	local container = self:FindGO("WrapContent");
	self.listCtl = WrapListCtrl.new(container, 
		GLandStatusListCell, 
		"GLandStatusListCell", 
		WrapListCtrl_Dir.Vertical);
	self.listCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGLandStatusCell, self);
	self.listCtl:AddEventListener(GLandStatusList_CellEvent_Trace, self.DoTrace, self);
end

function GLandStatusListView:ClickGLandStatusCell(cell)
	local cityid = cell.data_cityid;

	local viewdata = {
		view = PanelConfig.GvgLandInfoPopUp, 
		viewdata = {
			flagid = cityid,
			hide_downinfo = true,
		},
	};
	self:sendNotification(UIEvent.JumpPanel, viewdata);
end

local posV3 = LuaVector3(0,0,0)
function GLandStatusListView:DoTrace(cell)
	local mapid, pos = FunctionGuild.Me():GetGuildStrongHoldPosition(cell.data_cityid);
	if(mapid == nil or pos == nil)then
		redlog("not find gland pos", cell.data_cityid);
		return;
	end

	local cmdArgs = ReusableTable.CreateTable();
	cmdArgs.targetMapID = mapid;
	posV3:Set(pos[1],pos[2],pos[3]);
	cmdArgs.targetPos = posV3;

	local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)	
	Game.Myself:Client_SetMissionCommand(cmd)

	ReusableTable.DestroyAndClearTable(cmdArgs);
end

function GLandStatusListView:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, self.UpdateInfo);
end

function GLandStatusListView:UpdateInfo()
	local landInfos = GvgProxy.Instance:Get_GLandStatusInfos();
	self.listCtl:ResetDatas(landInfos);
end

function GLandStatusListView:OnEnter()
	GLandStatusListView.super.OnEnter(self);

	ServiceGuildCmdProxy.Instance:CallQueryGCityShowInfoGuildCmd();
	self:UpdateInfo();
end

function GLandStatusListView:OnExit()
	GLandStatusListView.super.OnExit(self);
end