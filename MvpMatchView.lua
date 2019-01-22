MvpMatchView = class("MvpMatchView",ContainerView)

MvpMatchView.ViewType = UIViewType.NormalLayer

function MvpMatchView:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitShow()
	self:AddCloseButtonEvent()
end

function MvpMatchView:FindObjs()
	self.content1 = self:FindGO("content1"):GetComponent(UIRichLabel)
	self.content2 = self:FindGO("content2"):GetComponent(UIRichLabel)
	self.matchBtn = self:FindGO("MatchBtn")
end

function MvpMatchView:AddEvts()
	self:AddClickEvent(self.matchBtn,function ()
		self:ClickMatchButton()
	end)
	self:AddListenEvt(ServiceEvent.MatchCCmdJoinRoomCCmd,self.CloseSelf)
end

function MvpMatchView:InitShow()
	self.content1.text = ZhString.MVPMatch_tip1
	self.content2.text = string.format(ZhString.MVPMatch_tip2,GameConfig.MvpBattle.ActivityTime)
end

function MvpMatchView:ClickMatchButton()
	-- ???????????????
	local tipActID = GameConfig.MvpBattle.ActivityID or 4000000
	local actData = FunctionActivity.Me():GetActivityData(tipActID)
	if actData == nil then
		MsgManager.ShowMsgByIDTable(7300)
		return
	end
	-- ??????????????????
	local baselv = GameConfig.MvpBattle.BaseLevel
	local rolelv = MyselfProxy.Instance:RoleLevel()
	if rolelv < baselv then
		MsgManager.ShowMsgByID(7301, baselv)
		return
	end

	local teamProxy = TeamProxy.Instance
	-- ????????????
	if not teamProxy:IHaveTeam() then
		MsgManager.ShowMsgByID(332)
		return
	end
	-- ????????????
	if not teamProxy:CheckIHaveLeaderAuthority() then
		MsgManager.ShowMsgByID(7303)
		return
	end
	-- ??????????????????
	local mblsts = teamProxy.myTeam:GetMembersListExceptMe()
	for i=1,#mblsts do
		if mblsts[i].baselv < baselv then
			MsgManager.ShowMsgByID(7305, baselv)
			return
		end
	end
	local matchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.MvpFight)
	if matchStatus and matchStatus.ismatch then
		MsgManager.ShowMsgByIDTable(3609)
		return
	end
	ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.MvpFight) 
end