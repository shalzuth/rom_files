autoImport("UIMapMapListCell")
autoImport('UIListItemViewControllerTransmitTeammate')
autoImport('UIModelKaplaTransmit')

UIMapMapList = class("UIMapMapList", ContainerView)

UIMapMapList.ViewType = UIViewType.NormalLayer

local vec3 = LuaVector3.New(0, 0, 0)
local gReusableArray = {}

UIMapMapList.E_TransmitType = {
	Single = 0,
	Team = 1,
}
UIMapMapList.transmitType = nil

function UIMapMapList:Init()
	self:GetGameObjects()
	self:RegisterButtonClickEvent()

	self:GetModelSet()
	self:LoadView()
	self:ListenTeamEvent()
	self:ListenServer()
	self:ListenCustomEvent()
end

function UIMapMapList:GetGameObjects()
	self.transScrollList = self:FindGO("ScrollList").transform
	self.transRoot = self:FindGO("Root", self.transScrollList.gameObject).transform
	self.uiGrid = self.transRoot.gameObject:GetComponent(UIGrid)
	self.goButtonBack = self:FindGO("Back", self.transScrollList.gameObject)
	self.goMyTeam = self:FindGO('MyTeam')
	self.goTeammateScrollList = self:FindGO('ScrollList', self.goMyTeam)
	self.goTeammateRoot = self:FindGO('Root', self.goTeammateScrollList)
	self.teammateUIGrid = self.goTeammateRoot:GetComponent(UIGrid)
	self.goBTNInviteFollow = self:FindGO('BTN_InviteFollow', self.goMyTeam)
	self.goTutorial = self:FindGO('Tutorial')
	self.goTutorialLab = self:FindGO('Lab', self.goTutorial)
	self.labTutorial = self.goTutorialLab:GetComponent(UILabel)
	self.goNoListItem = self:FindGO('NoListItem', self.goTeammateScrollList)
end

function UIMapMapList:RegisterButtonClickEvent()
	self:AddClickEvent(self.goButtonBack, function (go)
		self:OnButtonBackClick(go)
	end)
	self:AddClickEvent(self.goBTNInviteFollow, function (go)
		self:OnClickForButtonInviteFollow(go)
	end)
end

function UIMapMapList:GetModelSet()
	self.areaID = self.viewdata.viewdata.areaID
	if self.mapsInfo == nil then
		self.mapsInfo = {}
	end
	TableUtility.ArrayClear(self.mapsInfo)
	-- cache search result
	local amIMonthlyVIP = UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
	for _, v in pairs(Table_Map) do
		if v.Range == self.areaID and v.Money then
			local couldTransmit = true
			if v.MoneyType == 2 and not amIMonthlyVIP then
				couldTransmit = false
			end
			if couldTransmit then
				table.insert(self.mapsInfo, v)
			end
		end
	end
	table.sort(self.mapsInfo, function (x, y)
		return self:Sort(x, y)
	end)

	self.teammatesID = UIModelKaplaTransmit.Ins():GetTeammates()
end

function UIMapMapList:LoadView()
	if self.listCtrl == nil then
		self.listCtrl = UIGridListCtrl.new(self.uiGrid, UIMapMapListCell, "UIMapAreaListCell")
	end
	self.listCtrl:ResetDatas(self.mapsInfo)

	if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
		self:TransmitLayout()
	elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
		self:TeamTransmitLayout()
	end

	if self.teammateListCtrl == nil then
		self.teammateListCtrl = UIGridListCtrl.new(self.teammateUIGrid, UIListItemViewControllerTransmitTeammate, 'UIListItemTransmitTeammate')
	end
	self.teammateListCtrl:ResetDatas(self.teammatesID)
	if (self.teammatesID ~= nil) and (#self.teammatesID > 0) then
		self.goNoListItem:SetActive(false)
	else
		self.goNoListItem:SetActive(true)
	end

	if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
		local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
		if handInHandPlayerID ~= nil then
			local handInHandPlayer = UIModelKaplaTransmit.Ins():GetTeammateDetail(handInHandPlayerID)
			local handInHandPlayerName = handInHandPlayer and handInHandPlayer.name or ''
			self.labTutorial.text = string.format(ZhString.kaplaTransmit_HandInHandTransmitTutorial, handInHandPlayerName)
		else
			self.labTutorial.text = ZhString.KaplaTransmit_SelectTransmitDestination
		end
	elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
		self.labTutorial.text = ZhString.KaplaTransmit_TeammateTransmitTutorial
	end
end

function UIMapMapList:OnButtonBackClick(go)
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.UIMapAreaList})
end

function UIMapMapList:OnClickForButtonInviteFollow(go)
	if UIModelKaplaTransmit.Ins():AmITeamLeader() then
		self:RequestInviteTeammateFollow()
	else
		MsgManager.ShowMsgByID(351)
	end
end

function UIMapMapList:Sort(x, y)
	if x == nil then
		return true
	elseif y == nil then
		return false
	else
		return x.id < y.id
	end
end

function UIMapMapList:TeamTransmitLayout()
	local localPos = self.transScrollList.localPosition
	vec3:Set(-112, localPos.y, localPos.z)
	self.transScrollList.localPosition = vec3

	localPos = self.goTeammateScrollList.transform.localPosition
	vec3:Set(52, localPos.y, localPos.z)
	self.goTeammateScrollList.transform.localPosition = vec3
end

function UIMapMapList:TransmitLayout()
	local localPos = self.transScrollList.localPosition
	vec3:Set(0, localPos.y, localPos.z)
	self.transScrollList.localPosition = vec3

	self.goMyTeam:SetActive(false)
end

function UIMapMapList:ListenCustomEvent()
	self:AddListenEvt("UIMapMapList.CloseSelf", function ()
		self:CloseSelf()
	end)
	self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.OnReceiveFunctionFollowCaptainEventStateChanged)
end

function UIMapMapList:ListenTeamEvent()
	self:AddListenEvt(TeamEvent.MemberEnterTeam, self.OnReceiveMemberEnterTeam)
	self:AddListenEvt(TeamEvent.MemberExitTeam, self.OnReceiveMemberExitTeam)
	self:AddListenEvt(TeamEvent.MemberOffline, self.OnReceiveMemberOffline)
	self:AddListenEvt(TeamEvent.MemberOnline, self.OnReceiveMemberOnline)
end

function UIMapMapList:ListenServer()
	self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.OnReceiveBeFollowed)
end

function UIMapMapList:OnReceiveMemberEnterTeam()
	self:Refresh()
end

function UIMapMapList:OnReceiveMemberExitTeam()
	self:Refresh()
end

function UIMapMapList:OnReceiveMemberOffline()
	self:Refresh()
end

function UIMapMapList:OnReceiveMemberOnline()
	self:Refresh()
end

function UIMapMapList:OnReceiveBeFollowed()
	self:Refresh()
end

function UIMapMapList:OnReceiveFunctionFollowCaptainEventStateChanged()
	self:Refresh()
end

function UIMapMapList:RequestInviteTeammateFollow()
	FunctionTeam.Me():InviteMemberFollow()
end

function UIMapMapList:Refresh()
	self:GetModelSet()
	self:LoadView()
end