autoImport("DesertWolfCombineCell")

DesertWolfView = class("DesertWolfView",SubView)

local desertWolf_Path = ResourcePathHelper.UIView("DesertWolfView");

local D_PVP_TYPE

function DesertWolfView:Init()
	D_PVP_TYPE = PvpProxy.Type.DesertWolf
	self.selectRoomID = nil
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function DesertWolfView:FindObjs()
	self:LoadSubView()
	self.desertWolfView = self:FindGO("DesertWolfView")
	self.empty = self:FindGO("Empty", self.desertWolfView)
	self.teamTable = self:FindGO("TeamTable" , self.desertWolfView):GetComponent(UITable)
	self.join = self:FindGO("Join", self.desertWolfView)
	self.refuseJoin=self:FindGO("refuseJoin",self.desertWolfView)
	self.playerTipStick = self:FindComponent("Stick", UIWidget);
	self.scrollView = self:FindComponent("TeamScrollView", UIScrollView);
end

function DesertWolfView:AddEvts()
	local change = self:FindGO("Change", self.desertWolfView)
	self:AddClickEvent(change,function ()
		self:ClickChange()
	end)

	local rule = self:FindGO("Rule", self.desertWolfView)
	self:AddClickEvent(rule,function ()
		self:ClickRule()
	end)

	self:AddClickEvent(self.join,function ()
		self:ClickJoin()
	end)
	self:AddClickEvent(self.refuseJoin,function ()
		self:ClickRefuseJoin()
	end)
end

function DesertWolfView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.MatchCCmdReqRoomListCCmd, self.HandleReqRoomList)
	-- self:AddListenEvt(ServiceEvent.MatchCCmdReqRoomDetailCCmd, self.HandleReqRoomDetail)
	self:AddListenEvt(ServiceEvent.MatchCCmdReqMyRoomMatchCCmd, self.HandleMyRoomMatchCCmd);
	self:AddListenEvt(ServiceEvent.MatchCCmdKickTeamCCmd, self.HandleKickMyRoom);

	self:AddListenEvt(ServiceEvent.MatchCCmdPvpTeamMemberUpdateCCmd, self.HandlePvpMemberUpdate);
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfRoomStateCCmd, self.HandleNtfRoomState);

	self:AddListenEvt(ServiceEvent.MatchCCmdReqRoomDetailCCmd, self.HandleReqRoomDetailCCmd);
end

function DesertWolfView:HandleReqRoomDetailCCmd(note)
	local data = note.body;
	if(data)then
		local dtype, roomid = data.type, data.roomid;
		if(dtype == D_PVP_TYPE)then
			-- _SelectCell
			self.selectRoomID = roomid;
			self:_ReSelectByRoomID();
			-- self:UpdateRoomDetalInfo(roomid);
		end
	end
end

function DesertWolfView:HandleNtfRoomState(note)
	self:RefreshJoinBtn()
end

function DesertWolfView:InitShow()
	self.teamCtl = UIGridListCtrl.new(self.teamTable , DesertWolfCombineCell , "DesertWolfCombineCell")
	self.teamCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickTeam, self)
	self.teamCtl:AddEventListener(DesertWolfCombineEvent.ClickMember, self.HandleClickMember, self)

	self:UpdateRoomList()
end

function DesertWolfView:HandleClickMember(param)
	helplog("HandleClickMember1");
	local wolfCombineCell, headCell = param[1], param[2];
	if(wolfCombineCell and headCell)then
		helplog("HandleClickMember2");
		local teamData = wolfCombineCell.data:GetRoomTeamList()[1]
		local memberHeadData = headCell.data;
		local id = memberHeadData.iconData.id;
		if(id == Game.Myself.data.id)then
			return;
		end

		local memberData = teamData:GetMemberByGuid(id);
		if(memberData)then
			local playerData = PlayerTipData.new();
			playerData:SetByTeamMemberData(memberData);
			if(not self.container.playerTipShow)then
				self.container.playerTipShow = true;
				local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Left, {-300,0});
				local tipData = {
					playerData = playerData,
					funckeys = {"SendMessage", "AddFriend", "AddBlacklist", "ShowDetail"},
				};
				playerTip:SetData(tipData);
				playerTip.closecallback = function (go)
					self.container.playerTipShow = false;
				end
			else
				FunctionPlayerTip.Me():CloseTip();
				self.container.playerTipShow = false;
			end
		else
			redlog("not find member", tostring(id));
		end
	end
end

function DesertWolfView:LoadSubView()
	local container = self:FindGO("DesertWolfView")
	local obj = self:LoadPreferb_ByFullPath(desertWolf_Path, container, true);
	obj.name = "DesertWolfView";
end

function DesertWolfView:HandlePvpMemberUpdate()
	self:UpdateRoomList()
end

function DesertWolfView:HandleMyRoomMatchCCmd(note)
	local data = note.body
	if(data)then
		if(data.type==D_PVP_TYPE)then
			self:UpdateRoomList()
			self:RefreshJoinBtn()
		end
	end
end

function DesertWolfView:UpdateRoomList()
	local data = PvpProxy.Instance:GetRoomList(D_PVP_TYPE) or {}
	-- helplog("#data : ",#data)
	self.teamCtl:ResetDatas(data)
	self.empty:SetActive(#data == 0)
	self:_ReSelectByRoomID()
end

function DesertWolfView:RefreshJoinBtn()
	local myRoomState = PvpProxy.Instance:GetMyRoomState(D_PVP_TYPE);
	local myRoomType = PvpProxy.Instance:GetMyRoomType()
	local imleader = TeamProxy.Instance:CheckIHaveLeaderAuthority();
	if(myRoomType==D_PVP_TYPE)then
		if(myRoomState==PvpProxy.RoomStatus.Fighting)then
			self:Hide(self.refuseJoin)
			self:Hide(self.join)
		elseif(imleader)then
			self:Show(self.refuseJoin)
			self:Hide(self.join)
		else
			self:Hide(self.refuseJoin)
			self:Show(self.join)
		end
	else
		self:Hide(self.refuseJoin)
		self:Show(self.join)
	end
end

function DesertWolfView:HandleKickMyRoom(note)
	self:RefreshJoinBtn()
	ServiceMatchCCmdProxy.Instance:CallReqRoomListCCmd(D_PVP_TYPE)
end

function DesertWolfView:UpdateView()
	PvpProxy.Instance:Req_Server_MyRoomMatchCCmd();
	ServiceMatchCCmdProxy.Instance:CallReqRoomListCCmd(D_PVP_TYPE)
	self:RefreshJoinBtn()
end

function DesertWolfView:ClickChange()
	local now = Time.unscaledTime
	if self._clickChange == nil or (now - self._clickChange >= 15) then
		self._clickChange = now

		ServiceMatchCCmdProxy.Instance:CallReqRoomListCCmd(D_PVP_TYPE)
	else
		MsgManager.ShowMsgByID(952)
	end
end

function DesertWolfView:ClickRule()
	local panelId = PanelConfig.DesertWolfView.id
	local Desc = Table_Help[panelId] and Table_Help[panelId].Desc or ZhString.Help_RuleDes
	TipsView.Me():ShowGeneralHelp(Desc)
end

function DesertWolfView:ClickJoin()
	local myRoomState = PvpProxy.Instance:GetMyRoomState(D_PVP_TYPE)
	if(myRoomState==PvpProxy.RoomStatus.Fighting)then
		MsgManager.ShowMsgByID(978)
		return
	end
	if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.DesertWolfJoinView})
	else
		MsgManager.ShowMsgByID(955)
	end
end

function DesertWolfView:ClickRefuseJoin()
	local t = PvpProxy.Type.DesertWolf
	local roomid = PvpProxy.Instance:GetMyRoomGuid()
	ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(t,roomid)
end

function DesertWolfView:HandleReqRoomList(note)
	local data = note.body
	if data then
		local dtype = data.type
		if dtype == D_PVP_TYPE then
			self:UpdateRoomList()
		end
	end
end

-- function DesertWolfView:HandleReqRoomDetail(note)
-- 	local data = note.body
-- 	if data then
-- 		local dtype, droomid = data.type, data.roomid
-- 		if dtype == D_PVP_TYPE then
-- 			if self.lastTeamCell then
-- 				local data = self.lastTeamCell.data
-- 				if data.roomid == droomid then
-- 					self.lastTeamCell:RefreshDetalInfo()
-- 				end
-- 			else
-- 				-- self:UpdateView()
-- 			end
-- 			-- self:UpdateView()
-- 		end
-- 	end
-- end

local tempV3 = LuaVector3();
function DesertWolfView:HandleClickTeam(cell)
	if cell == self.lastTeamCell then
		self.lastTeamCell:Click(false)

		self:_SelectCell(nil)
	else
		if self.lastTeamCell then
			self.lastTeamCell:Click(false)
		end

		self:_SelectCell(cell)

		local data = cell.data
		if data then
			ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(D_PVP_TYPE, data.guid)
		end
	end

	-- self.teamTable:Reposition()
end

function DesertWolfView:_SelectCell(cell)
	self.lastTeamCell = cell
	if(cell) then
		local shouldMoveVertically = self.scrollView.shouldMoveVertically;

		cell:Click(true)
		self.selectRoomID = cell.data.roomid

		if(shouldMoveVertically)then
			self.teamTable:Reposition()

			tempV3:Set(0,-208,0);
			tempV3:Set(LuaGameObject.TransformPoint(cell.gameObject.transform, tempV3))
			UIUtil.CenterScrollViewPos(self.scrollView, tempV3, 13);
		else
			self.teamTable:Reposition()
		end
	else
		self.selectRoomID = nil
		self.teamTable:Reposition()
	end
end

function DesertWolfView:_ReSelectByRoomID()
	if(self.selectRoomID) then
		local cells = self.teamCtl:GetCells()
		local findCell
		for i=1,#cells do
			if(cells[i].data ~=nil and cells[i].data.roomid == self.selectRoomID) then
				findCell = cells[i]
			else
				cells[i]:Click(false)
			end
		end

		if(findCell) then
			self:_SelectCell(findCell)
			findCell:RefreshDetalInfo()
		else
			self:_SelectCell(nil)
		end
	end
end