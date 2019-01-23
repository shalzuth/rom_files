autoImport("TutorMatcherCell")
autoImport("TutorMatcherData")

TutorMatchResultView = class("TutorMatchResultView",ContainerView)
TutorMatchResultView.ViewType = UIViewType.GOGuideLayer
local viewName = "view/TutorMatchResultView"

local general_countdown = GameConfig.Tutor.general_countdown
local blacklist_countdown = GameConfig.Tutor.blacklist_countdown
local matchStatus = TutorProxy.TutorMatchStatus
local myTutorType
local targetType
local targetMatcherData

function TutorMatchResultView:Init()
	if TutorProxy.Instance:CanAsTutor() then
		myTutorType = TutorType.Student
		targetType = TutorType.Tutor
	else
		myTutorType = TutorType.Tutor
		targetType = TutorType.Student
	end
	self:FindObj()
	self:AddEvts()
	self:AddViewEvt()
	self:AddCloseButtonEvent()
	
	self:InitShow()
end

function TutorMatchResultView:FindObj()
	self.title = self:FindGO("title"):GetComponent(UILabel)
	self.hint = self:FindGO("hintLabel"):GetComponent(UILabel)
	self.selfContainer = self:FindGO("self")
	self.selfInfo = Game.AssetManager_UI:CreateAsset(TutorMatcherCell.path,self.selfContainer)
	self.selfInfo = TutorMatcherCell.new(self.selfInfo)
	self.selfInfo:SetType(myTutorType)
	self.selfInfo:UpdataStatus(false)

	self.targetContainer = self:FindGO("target")
	self.targetInfo = Game.AssetManager_UI:CreateAsset(TutorMatcherCell.path,self.targetContainer)
	self.targetInfo = TutorMatcherCell.new(self.targetInfo)
	self.targetInfo:SetType(targetType)
	self.targetInfo:UpdataStatus(false)

	self.countdownGO = self:FindGO("Countdown")
	self.progressBar = self:FindGO("progressBar"):GetComponent(UIProgressBar)
	self.progressBar.value = 1
	self.countdownGO:SetActive(true)

	self.beginTime = ServerTime.CurServerTime()
	self.blackBeginTime= nil
	self:CountdownTick()
	
	--todo xde fix ui
	OverseaHostHelper:ShrinkFixLabelOver(self.hint,420)
end

function TutorMatchResultView:AddEvts()
	self.ContinueBtn = self:FindGO("ContinueBtn")
	self:AddClickEvent(self.ContinueBtn, function ()
		self:Continue()
	end)

	self.agreeBtn = self:FindGO("AgreeBtn")
	self:AddClickEvent(self.agreeBtn,function ()
		self:Agree()
	end)
	self.agreeSprite = self.agreeBtn:GetComponent(UIMultiSprite)
	self.ContinueSprite = self.ContinueBtn:GetComponent(UIMultiSprite)

	self.agreeBtnCollider = self.agreeBtn:GetComponent(BoxCollider)
	self.ContinueBtnCollider = self.ContinueBtn:GetComponent(BoxCollider)

	self.agreeSprite.CurrentState = 1
	self.ContinueSprite.CurrentState = 1

	self.agreeLabel = self:FindGO("btnLabel",self.agreeBtn.gameObject):GetComponent(UILabel)
	self.ContinueLabel = self:FindGO("btnLabel",self.ContinueBtn.gameObject):GetComponent(UILabel)
	self.agreeBtnCollider.enabled = true
	self.agreeLabel.effectStyle = UILabel.Effect.Outline
	self.ContinueBtnCollider.enabled = true
	self.ContinueLabel.effectStyle = UILabel.Effect.Outline
end

function TutorMatchResultView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.MatchCCmdTutorMatchResultNtfMatchCCmd, self.CheckStatus)
	self.targetInfo:AddEventListener(FriendEvent.SelectHead, self.ClickResult, self)
end

function TutorMatchResultView:AddCloseButtonEvent()
	self:AddButtonEvent("CloseButton", function (go)
		ServiceMatchCCmdProxy.Instance:CallTutorMatchResponseMatchCCmd(matchStatus.Refuse)
		self:CloseSelf();
	end);
end

function TutorMatchResultView:InitShow()
	targetMatcherData = TutorProxy.Instance:GetTutorMatcherInfo()	
	self.targetName = targetMatcherData.name	
	self.targetInfo:SetData(targetMatcherData)

	local data2 = ReusableTable.CreateTable()
	local userdata = Game.Myself.data.userdata
	data2.profession = userdata:Get(UDEnum.PROFESSION)
	data2.level = userdata:Get(UDEnum.ROLELEVEL)
	data2.portrait = userdata:Get(UDEnum.PORTRAIT)
	data2.gender = userdata:Get(UDEnum.SEX)
	data2.name = Game.Myself.data.name
	data2.hairID = userdata:Get(UDEnum.HAIR)
	data2.headID = userdata:Get(UDEnum.HEAD)
	data2.faceID = userdata:Get(UDEnum.FACE)
	data2.mouthID = userdata:Get(UDEnum.MOUTH)
	data2.bodyID = userdata:Get(UDEnum.BODY)
	data2.eyeID = userdata:Get(UDEnum.EYE)
	data2.findtutor = not targetMatcherData.findtutor
	self.selfFindTutor = data2.findtutor
	self.selfInfo:SetData(data2)

	ReusableTable.DestroyTable(data2)

	self.funkey = {
		"InviteMember",
		"AddFriend",
		"InviteEnterGuild",
		"ShowDetail",
		"AddBlacklist",
	}
	if targetMatcherData.findtutor then
		self.hint.text = ZhString.Tutor_TutorHint
	else
		self.hint.text = ZhString.Tutor_StudentHint
	end
end

function TutorMatchResultView:Continue()	
	ServiceMatchCCmdProxy.Instance:CallTutorMatchResponseMatchCCmd(matchStatus.Refuse)
end

function TutorMatchResultView:Agree()
	if not targetMatcherData then
	 return 
	end
	if self.timeTick then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil
	end

	local rid = targetMatcherData:GetCharID()
	if FriendProxy.Instance:IsBlacklist(rid) then
		MsgManager.ShowMsgByIDTable(25452,self.targetName)
		if self.timeTick then
			TimeTickManager.Me():ClearTick(self)
		end
		if not self.blackBeginTime then
			self.blackBeginTime = ServerTime.CurServerTime()
		end
		self:BlackCountdownTick()
		-- self.countdownGO:SetActive(false)
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BlacklistView, viewdata = {isFromMatcherView = true}})
		return
	end
	ServiceMatchCCmdProxy.Instance:CallTutorMatchResponseMatchCCmd(matchStatus.Agree)
	self.selfInfo:UpdataStatus(true)
	
	self.agreeSprite.CurrentState = 0
	self.ContinueSprite.CurrentState = 0
	self.agreeBtnCollider.enabled = false
	self.agreeLabel.effectStyle = UILabel.Effect.None
	self.ContinueBtnCollider.enabled = false
	self.ContinueLabel.effectStyle = UILabel.Effect.None

	if self.timeTick then
		TimeTickManager.Me():ClearTick(self)
	end
	self.countdownGO:SetActive(false)
end

function TutorMatchResultView:CountdownTick()
	if self.timeTick == nil then
		self.timeTick = TimeTickManager.Me():CreateTick(0,1,self.Countdown,self)
	end
end

function TutorMatchResultView:BlackCountdownTick()
	if self.blacktimeTick == nil then
		self.blacktimeTick = TimeTickManager.Me():CreateTick(0,1,self.BlackCountdown,self)
	end
end

local nowTime
function TutorMatchResultView:Countdown()
	nowTime = ServerTime.CurServerTime()
	local rest = (general_countdown - (nowTime-self.beginTime) /1000)
	if rest >= 0 then
		self.progressBar.value = rest/general_countdown
	else
		self.progressBar.value = 0
		if self.timeTick then
			TimeTickManager.Me():ClearTick(self)
		end
		self:Agree()
		FunctionPlayerTip.Me():CloseTip()
		-- self:CloseSelf()
	end
end

function TutorMatchResultView:BlackCountdown()
	nowTime = ServerTime.CurServerTime()
	local rest = (blacklist_countdown - (nowTime-self.blackBeginTime) /1000)
	if rest >= 0 then
		self.progressBar.value = rest/blacklist_countdown
	else
		self.progressBar.value = 0
		if self.blacktimeTick then
			TimeTickManager.Me():ClearTick(self)
		end
		ServiceMatchCCmdProxy.Instance:CallTutorMatchResponseMatchCCmd(matchStatus.Refuse)
		FunctionPlayerTip.Me():CloseTip()
		self:CloseSelf()
	end
end

local currentStatus
function TutorMatchResultView:CheckStatus()
	currentStatus = TutorProxy.Instance:GetTutorMatStatus()
	if currentStatus == matchStatus.Stop then
		self:CloseSelf()
	elseif currentStatus == matchStatus.Agree then
		self.targetInfo:UpdataStatus(true)
	elseif currentStatus == matchStatus.Start then
		self:CloseSelf()
	end 
end

local tipData = {}
function TutorMatchResultView:ClickResult(cell)
	if not targetMatcherData then
	 targetMatcherData = TutorProxy.Instance:GetTutorMatcherInfo()
	end
	if targetMatcherData then
		local playerData = PlayerTipData.new()
		playerData:SetByMatcherData(targetMatcherData)

		FunctionPlayerTip.Me():CloseTip()

		local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {400,100})

		tipData.playerData = playerData
		tipData.funckeys = self.funkey

		playerTip:SetData(tipData)
		playerTip:HideGuildInfo()
	end
end

function TutorMatchResultView:OnExit()
	if self.timeTick then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil
	end

	if self.blacktimeTick then
		TimeTickManager.Me():ClearTick(self)
		self.blacktimeTick = nil
	end
end