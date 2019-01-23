autoImport("ServantRecommendView")
autoImport("FinanceView")
-- autoImport("ServantStrengthenView")
local waitAnimName = 'wait'

ServantMainView = class("ServantMainView",ContainerView)
ServantMainView.ViewType = UIViewType.NormalLayer

local max_favor = GameConfig.Servant.max_favorability

local UI_FLITER = GameConfig.Servant.Filter or {11,12};

function ServantMainView:Init()
	self:FindObjs()
	self:AddViewEvts()
	self:InitShow()
	self:InitData()

	--todo xde 强行显示
	self.gameObject:SetActive(true)
end

function ServantMainView:InitData()
	self.myId = Game.Myself.data.id
end

function ServantMainView:FindObjs()
	self.recommendToggle = self:FindGO("RecommendBtn")
	self.financeToggle = self:FindGO("FinanceBtn")
	self.strenghtenToggle = self:FindGO("StrengthenBtn")
	self.recommendObj = self:FindGO("recommendView")
	self.financeObj = self:FindGO("financeView")
	self.strenghtenObj = self:FindGO("strengthenView")
	self.favorProcess = self:FindComponent("FavorProcess",UILabel)
	self.servantName = self:FindComponent("ServantName",UILabel)

	self:Hide(self.strenghtenToggle) -- temp
end

function ServantMainView:AddViewEvts()
	self:AddListenEvt(SceneUserEvent.SceneAddPets, self.HandleAddNpcs)
	self:AddListenEvt(SceneUserEvent.SceneRemovePets,self.HandleRemoveNpcs)
	self:AddListenEvt(MyselfEvent.ServantFavorChange, self.UpdateFavorAbility);
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleEvt);
	self:AddListenEvt(ShortCut.MoveToPos, self.HandleEvt);	
end

function ServantMainView:HandleEvt()
	self:CloseSelf()
end

function ServantMainView:PlayNpcAction(actionName)
	local animParams = Asset_Role.GetPlayActionParams(actionName, nil, 1)
	animParams[7] = function ()
		animParams = Asset_Role.GetPlayActionParams(waitAnimName, nil, 1)
		self.npc:PlayActionRaw(animParams)
	end
	if(self.npc)then
		self.npc:PlayActionRaw(animParams)
	end
end

function ServantMainView:UpdateFavorAbility()
	local servantFavor = MyselfProxy.Instance:GetServantFavorability()
	self.favorProcess.text = string.format(ZhString.GuildBuilding_Submit_MatNum,servantFavor,max_favor)
end

function ServantMainView:InitShow()
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED, self.recommendToggle, 4, {-5,-5})

	self.recommendView = self:AddSubView("ServantRecommendView", ServantRecommendView)
	self.financeView = self:AddSubView("FinanceView", FinanceView)
	-- self.StrengthenView = self:AddSubView("ServantStrengthenView",ServantStrengthenView)

	self:AddTabChangeEvent(self.recommendToggle, self.recommendObj, PanelConfig.ServantRecommendView)
	self:AddTabChangeEvent(self.financeToggle, self.financeObj, PanelConfig.FinanceView)
	-- self:AddTabChangeEvent(self.strenghtenToggle,self.strenghtenObj,PanelConfig.ServantStrengthenView)

	if self.viewdata.view and self.viewdata.view.tab then
		self:TabChangeHandler(self.viewdata.view.tab)
	else
		self:TabChangeHandler(PanelConfig.ServantRecommendView.tab)
	end

	local servantID = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
	self.servantName.text = Table_Npc[servantID].NameZh
	self:UpdateFavorAbility()
end

function ServantMainView:TabChangeHandler(key)
	if self.currentKey ~= key then
		ServantMainView.super.TabChangeHandler(self, key)
		if key == PanelConfig.ServantRecommendView.tab then
			-- local type = SceneUser2_pb.ESERVANT_SERVICE_RECOMMEND
		elseif key == PanelConfig.FinanceView.tab then
			-- TODO
		end

		self.currentKey = key
	end
end

local selfFilter = 12
function ServantMainView:OnEnter()
	FunctionSceneFilter.Me():StartFilter(UI_FLITER);
	Game.Myself:Client_PauseIdleAI()
	ServiceNUserProxy.Instance:CallShowServantUserCmd(true) 
	ServantMainView.super.OnEnter(self);
	FunctionSceneFilter.Me():StartFilter(selfFilter)
	self.lockid = Game.Myself:Client_GetAutoBattleLockID()
	self.autoBattle = Game.AutoBattleManager.on
	Game.AutoBattleManager:AutoBattleOff()
	Game.Myself:Client_SetMissionCommand(nil)
	-- notify server summer servant
end

function ServantMainView:OnExit()
	FunctionSceneFilter.Me():EndFilter(UI_FLITER);
	self:RemoveLeanTween();
	Game.Myself:Client_ResumeIdleAI()
	ServiceNUserProxy.Instance:CallShowServantUserCmd(false) 
	ServantMainView.super.OnExit(self);
	self:CameraReset()
	FunctionSceneFilter.Me():EndFilter(selfFilter)
	if(self.autoBattle)then
		if(0==self.lockid)then
			Game.AutoBattleManager:AutoBattleOn()
		else
			local myself = Game.Myself
			if myself:Client_GetFollowLeaderID() ~= 0 then
				MsgManager.ShowMsgByID(1713)
			else			
				myself:Client_SetAutoBattleLockID(self.lockid)
				myself:Client_SetAutoBattle(true)
			end
		end
	end
end

function ServantMainView:HandleAddNpcs(note)
	local npcs = note.body;
	if(not npcs)then
		return
	end
	-- local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
	for _,npc in pairs(npcs)do
		if(npc.data and npc.data.ownerID == self.myId)then
			self.npc = npc.assetRole
			self:delayFocus(npc.assetRole.completeTransform)
			break
		end
	end
end

function ServantMainView:HandleRemoveNpcs(note)
	local npcs = note.body;
	if(not npcs)then return end 

	-- local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
	for _,npc in pairs(npcs)do
		if('table'==type(npc) and npc.data and npc.data.ownerID == self.myId)then
			self.npc= nil
			self:CloseSelf()
			break
		end
	end
end

function ServantMainView:RemoveLeanTween()
	if(self.DelayFocusTwId)then
		LeanTween.cancel(self.gameObject,self.DelayFocusTwId)
		self.DelayFocusTwId = nil
	end
end

function ServantMainView:delayFocus(trans)
	self:RemoveLeanTween();
	
	helplog("delayFocus In");
	local ret = LeanTween.delayedCall(self.gameObject,0.1,function (  )
		self.DelayFocusTwId = nil
		local viewPort = CameraConfig.Servant_ViewPort
		local rotation = CameraConfig.Servant_Rotation
		self:CameraFaceTo(trans,viewPort,rotation)
	end)
	self.DelayFocusTwId = ret.uniqueId
end