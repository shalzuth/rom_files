DeathPopView = class("DeathPopView", ContainerView)
-- autoImport("CountDownView")
DeathPopView.ViewType = UIViewType.ReviveLayer

DeathPopView.TextureBg = "persona_bg_npc"

function DeathPopView:Init()
	self:initData()
	self:initView()
	self:addEventListener()		
	self:AddViewEvts()
end

function DeathPopView:initData(  )
	-- body
	self.isPvpMap = SceneProxy.Instance:IsPvPScene()
	self.totalTime = GameConfig.DeathPopViewShowTime.showTime	
	self.leftTime = self.totalTime
	self.costItem = GameConfig.UserRelive.deathcost2[1].id
	self.reliveCostCount = GameConfig.UserRelive.deathcost2[1].num
	self.isDaoChangMap = DojoProxy.Instance:IsSelfInDojo()
	self.currentMap = SceneProxy.Instance.currentScene
	self.mapMng = Game.MapManager
end

function DeathPopView:initView(  )
	-- body
	-- self.goldCount = self:FindChild("GoldCount"):GetComponent(UILabel)
	self.goldIcon = self:FindGO("gold"):GetComponent(UISprite)
	self.title = self:FindGO("deathTitle"):GetComponent(UILabel)
	self.title.text = ZhString.DeathPopView_Title

	local ReliveInSituLabel = self:FindComponent("ReliveInSituLabel",UILabel)
	ReliveInSituLabel.text = ZhString.DeathPopView_ReliveInSitu

	self.ReliveInRelivePointLabel = self:FindComponent("ReliveInRelivePointLabel",UILabel)
	self.ReliveInRelivePointLabel.text = ZhString.DeathPopView_ReliveInRelivePoint

	self.ReliveInSavePointLabel = self:FindComponent("ReliveInSavePointLabel",UILabel)
	self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveInSavePoint

	local ReliveInRelivePointBtn = self:FindGO("ReliveInRelivePointBtn")
	self.timeCt = self:FindGO("timeCt")
	self.timeThumnail = self:FindGO("timeThumnail")
	self.timeSlider = self:FindComponent("timeSlider",UISlider)
	
	-- local moneytype = GameConfig.UserRelive.deathcost1.moneytype
	-- local money = GameConfig.UserRelive.deathcost1.money
	-- local param = GameConfig.UserRelive.param

	-- local deathCount = 0
	-- if(self.isPvpMap)then
	-- 	deathCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_PVP_DEAD_COUNT)
	-- else
	-- 	deathCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_RELIVE)
	-- end
	-- if deathCount == nil then
	-- 	deathCount =0
	-- end
	-- if deathCount >= 9 then
	-- 	deathCount = 9
	-- end	
	
	-- if self.goldCount ~= nil then
		-- self.reliveGoldCount = param*(deathCount+1)*money
		
		-- self.goldCount.text = self.reliveCostCount
		self.itemData = Table_Item[self.costItem]
		if(self.itemData)then
			IconManager:SetItemIcon(self.itemData.Icon,self.goldIcon)
		end
	-- end

	local totalCount =BagProxy.Instance:GetItemNumByStaticID(self.costItem)
	self.ReliveInRelivePointBtnBox = self:FindComponent("ReliveInRelivePointBtn",BoxCollider)
	self.ReliveInRelivePointBtnSp = self:FindComponent("ReliveInRelivePointBtn",UISprite)
	local ReliveInRelivePointBtnCt = self:FindGO("ReliveInRelivePointBtnCt")
	self.ReliveInSavePointBtn = self:FindGO("ReliveInSavePointBtn")
	local ReliveInSavePointBtnCt = self:FindGO("ReliveInSavePointBtnCt")
	local ReliveInSavePointBg = self:FindComponent("ReliveInSavePointBtn",UISprite)
	self.ReliveInSituBtnCt = self:FindGO("ReliveInSituBtnCt")
	
	local DeathHint = self:FindComponent("DeathHint",UILabel)
	local userData =  Game.Myself.data.userdata
	local defeat = userData:GetBytes(UDEnum.KILLERNAME)
	local base = userData:Get(UDEnum.DROPBASEEXP)
	if(self.isPvpMap)then
		DeathHint.text = string.format(ZhString.DeathPopView_TitleHintPvP,defeat)	
	else
		DeathHint.text = string.format(ZhString.DeathPopView_TitleHint,defeat,base)	
	end
	--todo xde fix ui
	DeathHint.overflowMethod = 3
	DeathHint.width = 240
	DeathHint.transform.localPosition = Vector3(0,8,0)
	if(self.isPvpMap)then
		self:Hide(self.ReliveInSituBtnCt)	
	elseif(self.isDaoChangMap)then
		self:Hide(ReliveInRelivePointBtnCt)
	 	self:Hide(self.timeCt)
	 	if(totalCount < self.reliveCostCount)then
	 		self:Hide(self.ReliveInSituBtnCt)
	 	end
			-- local btnText = self:FindGO("BtnText",self:FindGO("immediatelyBtn")):GetComponent(UILabel)
			-- btnText.text = ZhString.DeathPopView_ImmRelive
			-- btnText.transform.localPosition = Vector3.zero
			-- btnText = self:FindChild("backToRevivePointBtn"):GetComponentInChildren(UILabel)
			-- btnText.text = ZhString.DeathPopView_ReturnRelive
			-- self:FindGO("Cost"):SetActive(false)
	elseif(not self.isPvpMap)then
		-- TimeTickManager.Me():CreateTick(0,10,self.updateCdTime,self)
		self:Hide(ReliveInRelivePointBtnCt)
		ReliveInSavePointBg.spriteName = "com_btn_3s"
		self.ReliveInSavePointLabel.effectColor = Color(41/255,105/255,0,1)

 		self.timeCt.transform:SetParent(self.ReliveInSavePointBtn.transform,false)
	 	if(totalCount < self.reliveCostCount)then
	 		self:Hide(self.ReliveInSituBtnCt)
	 	end
		-- local btnText = self:FindGO("BtnText",self:FindGO("immediatelyBtn")):GetComponent(UILabel)
		-- btnText.text = ZhString.DeathPopView_ImmRelive
		-- btnText.transform.localPosition = Vector3.zero
		-- btnText = self:FindChild("backToRevivePointBtn"):GetComponentInChildren(UILabel)
		-- btnText.text = ZhString.DeathPopView_ReturnRelive
		-- self:FindGO("Cost"):SetActive(false)
	end

	if(Game.MapManager:IsGvgMode_Droiyan())then
		self:Hide(ReliveInSavePointBtnCt) --ReliveInSavePointBtnCt:SetActive(false)
	end
	local BoundCt = self:FindGO("BoundCt")
	local grid = BoundCt:GetComponent(UITable)
	grid:Reposition()
	
	local btnCt = self:FindGO("btnCt"):GetComponent(UISprite)
	local bound = NGUIMath.CalculateRelativeWidgetBounds(BoundCt.transform,false)
	local tmp = bound.size.y+54.0 
	bound = NGUIMath.CalculateRelativeWidgetBounds(DeathHint.transform,false)
	tmp = tmp+bound.size.y
	btnCt.height  = tmp
	-- printRed("size:","btnCt",bound.size.y,tmp,btnCt.height)

	-- self.CountDownView = self:AddSubView("CountDownView",CountDownView)

	if(self.currentMap:IsInDungeonMap())then
		self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveAndLeave
	end

	self.bgTexture = self:FindComponent("Texture",UITexture)
	PictureManager.Instance:SetUI(DeathPopView.TextureBg, self.bgTexture);
	self:HandleReliveCd()
end

function DeathPopView:AddViewEvts()
	self:AddListenEvt(MyselfEvent.ReliveStatus,self.HandleReliveStatus)
end

function DeathPopView:HandleReliveStatus(note)
	self:CloseSelf()
end

function DeathPopView:addEventListener(  )
	-- body
	self:AddButtonEvent("ReliveInSituBtn",function ( obj )
		-- body			
		ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_MONEY)
		-- FunctionFollowCaptain.Me():Shutdown()
	end)

	self:AddButtonEvent("ReliveInRelivePointBtn",function ( obj )
		-- body
		-- if(self.isPvpMap)then			
		-- 	ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RAND)
		-- else
			ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
		-- end
	end)

	self:AddButtonEvent("ReliveInSavePointBtn",function ( obj )
		-- body
		-- if(self.currentMap:IsInDungeonMap())then
			-- ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
		-- else
		-- 	ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURNSAVE)
		-- end
		-- FunctionFollowCaptain.Me():Shutdown()
		-- self:CloseSelf()

		if(self.isPvpMap)then			
			ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURNSAVE)
		else
			ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
		end
	end)
	self:AddListenEvt(ServiceEvent.UserEventDieTimeCountEventCmd,self.HandleReliveCd)
end

function DeathPopView:HandleReliveCd(data)
	if(self.mapMng:IsPVPMode_GVGDetailed() or self.mapMng:IsGvgMode_Droiyan())then
		self.ReliveInSavePointLabel.text = ZhString.DeathPopView_ReliveInSavePoint
		local time = MyselfProxy.Instance.reliveStamp
		time = time and time or 0
		if(time > 0)then
			self.ReliveInRelivePointBtnBox.enabled = false
			self.ReliveInRelivePointBtnSp.spriteName = "com_btn_3s"
			local currentTime = ServerTime.CurServerTime()
			currentTime = currentTime / 1000
			self.totalTime = math.floor(time - currentTime)
			self.title.text = string.format(ZhString.DeathPopView_TitleReliveHintGVG,MyselfProxy.Instance.reliveName)
			self.ReliveInRelivePointLabel.effectColor = Color(41/255,105/255,0,1)
			if(self.totalTime >0)then
				self.Show(self.timeCt)
				-- self.timeCt.transform:SetParent(self.ReliveInSavePointBtn.transform,false)
				TimeTickManager.Me():ClearTick(self)
				TimeTickManager.Me():CreateTick(0,1000,self.updateCdTime,self)
			end
		else
			self.ReliveInRelivePointBtnBox.enabled = true
			-- self.ReliveInRelivePointLabel.effectColor = Color(158/255,158/255,158/255,1)
			-- self.ReliveInRelivePointBtnSp.spriteName = "com_btn_13"
		end
	end
end

function DeathPopView:OnEnter()
	DeathPopView.super.OnEnter(self)
	self:sendNotification( MainViewEvent.ActiveShortCutBord, false);
end

function DeathPopView:OnExit()
	self:sendNotification( MainViewEvent.ActiveShortCutBord, true);	
	self.super.OnExit(self)
	TimeTickManager.Me():ClearTick(self)
	PictureManager.Instance:UnLoadUI(DeathPopView.TextureBg,self.bgTexture);
	MyselfProxy.Instance:ClearReliveCd()
end

function DeathPopView:updateCdTime( )
	-- body
	local currentTime = ServerTime.CurServerTime()
	currentTime = currentTime / 1000
	local time = MyselfProxy.Instance.reliveStamp
	local leftTime = time - currentTime
	leftTime = math.floor(leftTime)
	local delta = 1 - leftTime/self.totalTime
	if(leftTime <= 0)then
		-- TimeTickManager.Me():ClearTick(self)	
		-- self:CloseSelf()
		leftTime = 0
		local isDead = Game.Myself:IsDead()
		if(isDead)then
			-- if(self.currentMap:IsInDungeonMap())then
				-- ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
			-- elseif(self.isPvpMap)then			
			-- 	ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RAND)
			-- else
			-- 	ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURNSAVE)
			-- end
		else
			self:CloseSelf()
			return
		end
		-- FunctionFollowCaptain.Me():Shutdown()
	end	
	-- if(self.leftTime <= GameConfig.DeathPopViewShowTime.leftTimeRedLimit)then
	-- 	self.existClock.color = Color(254,6/254.0,6/255.0,1)
	-- else 
	-- 	-- self.existClock.color = Color(0,0,0,1)
	-- end
	self.ReliveInRelivePointLabel.text = string.format(ZhString.DeathPopView_ReliveHintDesGVG,leftTime)
	self.timeSlider.value = delta
	self.timeThumnail.transform.eulerAngles = Vector3(0,0,90-delta*360)
	-- self.existClock.text ,_ = math.modf(self.leftTime).."s"
end