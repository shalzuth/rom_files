autoImport("MainViewAimMonsterCell")

MainViewAutoAimMonster = class("MainViewAutoAimMonster",SubView)

local noSweepBgHeight = 426
local sweepBgHeight = 466

function MainViewAutoAimMonster:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function MainViewAutoAimMonster:FindObj()
	local BeforePanel = self:FindGO("BeforePanel")
	local Anchor_DownRight = self:FindGO("Anchor_DownRight",BeforePanel)
	self.autoAimMonster = self:LoadPreferb("view/MainViewAutoAimMonster",Anchor_DownRight,true)

	self.autoFightBtn = self:FindGO("AutoBattleButton")
	self.autoFight = self:FindGO("Auto", self.autoFightBtn)
	self.autoAim = self:FindGO("AutoAim" , self.autoFightBtn)
	self.autoBattleBtnSps = self:FindComponent("AutoBattleBg", UISprite, self.autoFightBtn)
	self.autoFightTip = self:FindComponent("Label", UILabel, self.autoFightBtn)
	self.protectToggle = self:FindGO("ProtectToggle"):GetComponent(UIToggle)
	self.stayToggle = self:FindGO("StayToggle"):GetComponent(UIToggle)
	self.sweepBtn = self:FindGO("SweepBtn")
	self.sweepCheckmark = self:FindGO("Checkmark", self.sweepBtn)
	self.bg = self:FindGO("Bg", self.autoAimMonster):GetComponent(UISprite)
end

function MainViewAutoAimMonster:AddButtonEvt()
	local closeButton = self:FindGO("CloseButton", self.autoAimMonster)
	self:AddClickEvent(closeButton, function (go)
		self:SelfClose()
	end)

	self.closecomp = self.autoAimMonster:GetComponent(CloseWhenClickOtherPlace);
	self.closecomp.callBack = function (go)
		self:SelfClose()
	end
	self:AddClickEvent(self.autoFightBtn, function ()
		local myself = Game.Myself
		local isHanding,handowner = myself:IsHandInHand() 
		local isAuto = Game.AutoBattleManager.on
		if(not isHanding or handowner==true ) then
			if(isAuto)then
				self.isSweep = false

				Game.AutoBattleManager:AutoBattleOff()
				Game.Myself:Client_SetAutoEndlessTowerSweep(self.isSweep)
			else
				if myself:Client_GetFollowLeaderID() ~= 0 then
					Game.AutoBattleManager:AutoBattleOn()
				else
					self:SetBubbleTipActive(not state)
					if SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.SkillId) then
						self:ShowView(true)
					end
				end
			end
		end
	end)
	self:AddClickEvent(self.sweepBtn, function ()
		if Game.Myself:Client_GetFollowLeaderID() ~= 0 then
			MsgManager.ShowMsgByID(3433)
			return
		end

		self.isSweep = not self.isSweep
		self:UpdateSweepCheckmark(self.isSweep)

		if self.isSweep then
			self:SelfClose()
		end
	end)
end

function MainViewAutoAimMonster:AddViewEvt()
	self:AddListenEvt(SceneUserEvent.SceneAddNpcs,self.UpdateInfo)
	self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs,self.UpdateInfo)
	self:AddDispatcherEvt(AutoBattleManagerEvent.StateChanged, self.UpdateAutoBattle)
	self:AddListenEvt(GuideEvent.ShowAutoFightBubble, self.HandleGuideBubbleTip)
	self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateSkill)
end

function MainViewAutoAimMonster:InitShow()
	self.isShowSweep = nil	--是否显示扫荡按钮
	self.isSweep = false		--是否勾选扫荡

	local container = self:FindGO("Container")
	local wrapConfig = {
		wrapObj = container, 
		pfbNum = 10, 
		cellName = "MainViewAimMonsterCell", 
		control = MainViewAimMonsterCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)

	self:UpdateAutoBattle()

	local isProtect,isStay = false,false
	local str = LocalSaveProxy.Instance:GetMainViewAutoAimMonster()
	local history = string.split(str, "_")
	if #history == 2 then
		isProtect = history[1]
		-- isStay = history[2]
	end
	self.protectToggle.value = tonumber(isProtect) == 1
	self.stayToggle.value = tonumber(isStay) == 1

	self:UpdateSkill()

	self:ShowView(false)
end

local infoList = {}
function MainViewAutoAimMonster:UpdateInfo()

	if not self:IsShowView() then
		return
	end

	local functionMonster = FunctionMonster.Me()
	functionMonster:FilterMonsterStaticInfo()

	TableUtility.ArrayClear(infoList)
	TableUtility.ArrayShallowCopy(infoList,functionMonster:SortMonsterStaticInfo())

	local all = AutoAimMonsterData.new()
	all:SetId(0)
	TableUtility.ArrayPushFront(infoList,all)	--全部魔物

	-- LogUtility.InfoFormat("MainViewAutoAimMonster : {0}",#list)

	self.itemWrapHelper:UpdateInfo(infoList)

	if #infoList <= 5 then
		self.itemWrapHelper:ResetPosition()
	end

	if self.currentId then
		local cellCtls = self.itemWrapHelper:GetCellCtls()
		for i=1,#cellCtls do
			if cellCtls[i].data and cellCtls[i].data:GetId() == self.currentId then
				cellCtls[i]:SetChoose(true)
			end
		end
	end

	self:UpdateSweep()
	self:UpdateSweepCheckmark(self.isSweep)
end

function MainViewAutoAimMonster:HandleClickItem(cellctl)
	if cellctl.data then
		if self.cellctl and self.cellctl ~= cellctl then
			self.cellctl:SetChoose(false)
		end

		cellctl:SetChoose(true)
		self.cellctl = cellctl
		self.currentId = cellctl.data:GetId()

		if self.currentId == 0 then
			Game.AutoBattleManager:AutoBattleOn()
			if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance.equipedAutoSkills) then
				--没有攻击技能，弹提示
				MsgManager.DontAgainConfirmMsgByID(1712)
			end
			self:SelfClose()
		else
			local myself = Game.Myself
			if myself:Client_GetFollowLeaderID() ~= 0 then
				MsgManager.ShowMsgByID(1713)
			else			
				MsgManager.FloatMsg(nil, string.format(ZhString.AutoAimMonster_Tip , cellctl.name.text))
				myself:Client_SetAutoBattleLockID(self.currentId)
				myself:Client_SetAutoBattle(true)

				self:SelfClose()
			end
		end

		Game.Myself:Client_SetAutoBattleProtectTeam(self.protectToggle.value)
		Game.Myself:Client_SetAutoBattleStanding(self.stayToggle.value)
	end
end

function MainViewAutoAimMonster:ShowView(isShow)
	self.autoAimMonster:SetActive(isShow)

	if isShow then
		self:UpdateInfo()
	end
end

function MainViewAutoAimMonster:OffAutoAim()
	self.cellctl = nil
	self.currentId = nil
end

function MainViewAutoAimMonster:IsShowView()
	return self.autoAimMonster.activeSelf
end

function MainViewAutoAimMonster:SelfClose()
	self:ShowView(false)

	if self.currentId then
		self:NotifyGuideQuestState(self.currentId)
	end
	self:SetBubbleTipActive(true)

	local protect,stay
	if self.protectToggle.value then
		protect = 1
	else
		protect = 0
	end
	if self.stayToggle.value then
		stay = 1
	else
		stay = 0
	end
	local str = protect.."_"..stay
	LocalSaveProxy.Instance:SetMainViewAutoAimMonster(str)

	--可扫荡状态下
	if self.isShowSweep then
		local _Myself = Game.Myself
		if _Myself:Client_GetFollowLeaderID() == 0 then
			if self.isSweep ~= _Myself:Client_GetAutoEndlessTowerSweep() then
				local _AutoBattleManager = Game.AutoBattleManager
				if self.isSweep then
					_AutoBattleManager:AutoBattleOn()
				else
					_AutoBattleManager:AutoBattleOff()
				end
				_Myself:Client_SetAutoEndlessTowerSweep(self.isSweep)
			end
		end
	end
end

function MainViewAutoAimMonster:UpdateSkill()
	self.protectToggle.gameObject:SetActive( SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.ProtectSkillId) )
	self.stayToggle.gameObject:SetActive( SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.UnmovableSkillId) )
end

function MainViewAutoAimMonster:NotifyGuideQuestState(selectId)
	local questList = QuestProxy.Instance:getLockMonsterGuideByMonsterId(selectId)
	if questList then
		for i=1,#questList do
			QuestProxy.Instance:notifyQuestState(questList[i])
		end
	end
end

function MainViewAutoAimMonster:UpdateAutoBattle(note)
	local isAuto = Game.AutoBattleManager.on
	if isAuto then
		local lockid = Game.Myself:Client_GetAutoBattleLockID()
		if lockid == 0 then
			self:ShowAuto(isAuto,not isAuto)
		else
			self:ShowAuto(not isAuto,isAuto)
			self.currentId = lockid
		end
	else
		self:ShowAuto(isAuto,isAuto)
		self:OffAutoAim()
	end
	self.autoFightTip.text = isAuto and ZhString.MainViewInfoPage_Cancel  or ZhString.MainViewInfoPage_Auto
end

function MainViewAutoAimMonster:ShowAuto(isAutoFight,isAutoAim)
	self.autoFight:SetActive(isAutoFight)
	self.autoAim:SetActive(isAutoAim)
end

function MainViewAutoAimMonster:TryAutoBattleOn()
	Game.AutoBattleManager:AutoBattleOn()
	if(not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance.equipedAutoSkills)) then
		--没有攻击技能，弹提示
		MsgManager.DontAgainConfirmMsgByID(1712)
	end
end

local anchorOffset = {0,40}
function MainViewAutoAimMonster:HandleGuideBubbleTip(note)
	local data = note.body
	if data then
		if data.isShow then
			if self.bubbleTip == nil then
				self.bubbleTip = TipManager.Instance:ShowBubbleTipById(data.bubbleId, self.autoBattleBtnSps , NGUIUtil.AnchorSide.Left, anchorOffset)
				self.bubbleTip:ActiveCloseButton(false)
			end
		else
			if self.bubbleTip then
				self.bubbleTip:CloseSelf()
				self.bubbleTip = nil
			end
		end
	end
end

function MainViewAutoAimMonster:SetBubbleTipActive(b)
	if self.bubbleTip then
		self.bubbleTip:SetActive(b)
	end
end

function MainViewAutoAimMonster:UpdateSweep()
	local isShow = Game.MapManager:IsEndlessTower()
	self.isSweep = isShow
	if isShow == self.isShowSweep then
		return
	end

	self.isShowSweep = isShow

	self.sweepBtn:SetActive(isShow)
	if isShow then
		self.bg.height = sweepBgHeight
	else
		self.bg.height = noSweepBgHeight
	end	
end

function MainViewAutoAimMonster:UpdateSweepCheckmark(isShow)
	self.sweepCheckmark:SetActive(isShow)
end