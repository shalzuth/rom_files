MainViewGvgPage = class("MainViewGvgPage",SubView)
autoImport("GvgProxy")
autoImport("GvgQuestTip")
local tempVector3 = LuaVector3.zero

-- MainViewGvgPage.FinishType = {
	
-- }
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local getLocalPos = LuaGameObject.GetLocalPosition
function MainViewGvgPage:Init()		
	self:AddViewEvts()
	self:initView()
	self:initData()
	self:resetData()
end

function MainViewGvgPage:resetData(  )
	self.isDefSide = false
	if(self.tickMg)then
		self.tickMg:ClearTick(self)
	end
end

function MainViewGvgPage:initData(  )
	-- body
	self.specialSusTime = GameConfig.specialSusTime
	self.specialSusTime = self.specialSusTime and self.specialSusTime or 300
	self.tickMg = TimeTickManager.Me()
	self.gvgIns = GvgProxy.Instance
end

function MainViewGvgPage:Show( tarObj )
	MainViewGvgPage.super.Show(self,tarObj)
	if(not tarObj)then
		self:SetData()
	end
	self.curServerT = ServerTime.CurServerTime()/1000
end

function MainViewGvgPage:Hide( tarObj )
	MainViewGvgPage.super.Hide(self,tarObj)
	if(not tarObj)then
		self:resetData()
	end
	TipsView.Me():HideTip(GvgQuestTip)
end

function MainViewGvgPage:SetData(  )
	-- body
	self:updateGuildInfo()
	self:updateCalmdown()
	self:updateHonorValue()
	-- self:updateMetal_hpper()
	self:updateDangerTime()

	self:resizeContent()
	self.tickMg:ClearTick(self)
	self.tickMg:CreateTick(0,1000,self.updateCountTime,self)
end

function MainViewGvgPage:initView(  )
	-- body	
	self.gameObject = self:FindGO("GvgInfoBord")

	self.progress = self:FindGO("progress")
	self.progressSlider = self.progress:GetComponent(UISlider)
	self.progressBg = self:FindComponent("bg",UISprite,self.progress)
	self.progressForebg = self:FindComponent("forebg",UISprite,self.progress)
	self.thumbBg = self:FindGO("bg",self.thumbCt):GetComponent(UISprite)

	self.name = self:FindComponent("Title",UILabel)
	-- self.countDownLabel = self:FindComponent("Title",UILabel)
	self.countDownLabel = self:FindComponent("DescriptionText",UILabel)
	self.scoreLabel = self:FindComponent("score",UILabel)
	self.progressLabel = self:FindComponent("progressLabel",UILabel)
	self.bg = self:FindComponent("contentBg",UISprite)
	self.content = self:FindGO("content")

	self.effectObj = self:FindGO("EffectHolder")
	local resPath = ResourcePathHelper.EffectUI(EffectMap.UI.HlightBox);
	local effect = Game.AssetManager_UI:CreateAsset(resPath,self.effectObj);
	effect.transform.localScale = Vector3.one
	local hlightTexture = self:FindGO("pic_skill_uv_add",effect)
	hlightTexture = hlightTexture:GetComponent(UIWidget)
	hlightTexture.depth = 3000
	hlightTexture.width = 57
	hlightTexture.height = 101
	self:Hide(self.effectObj)

	self.bgSizeX = self.bg.width	
	local objLua = self.gameObject:GetComponent(GameObjectForLua)
	objLua.onEnable = function (  )
		-- body
		LeanTween.delayedCall(0.8, function ()
			self:resizeContent()
		end)
	end
	self.taskCellFoldSymbolSp = self:FindComponent("taskCellFoldSymbol",UISprite)
	local clickBox = self:FindGO("taskBordFoldSymbol")
	self:AddClickEvent(clickBox,function ( go )
		-- helplog("xxxxxclick")
		if(self.effectObj)then
			self:Hide(self.effectObj)
		end
		self:stopDelayRemoveEffect()
		TipManager.Instance:ShowGvgQuestTip(self.taskCellFoldSymbolSp,NGUIUtil.AnchorSide.Left,{-450,0})
		-- if(isPress)then
		-- 	TipsView.Me():ShowStickTip(QuestDetailTip,self.data,NGUIUtil.AnchorSide.TopLeft,self.bgSprite,{0,0})
		-- else
		-- 	TipsView.Me():HideTip(GvgQuestTip)
		-- end
	end)

	self.honorValue = self:FindComponent("honorValue",UILabel)
	self.honorProgress = self:FindComponent("honorProgress",UISlider)
	self.GvgHonorTraceInfo = self:FindGO("GvgHonorTraceInfo")
end

function MainViewGvgPage:updateHonorValue()
	local cur = self.gvgIns.questInfoData[FuBenCmd_pb.EGVGDATA_HONOR] or 0
	local max = GameConfig.GVGConfig.reward.max_honor or 1200
	self.honorProgress.value = cur/max
	self.honorValue.text = string.format(ZhString.MainViewGvgPage_HonorValue,cur,max)
	if(TipsView.Me().currentTipType == GvgQuestTip)then
		TipManager.Instance:ShowGvgQuestTip(self.taskCellFoldSymbolSp,NGUIUtil.AnchorSide.Left,{-450,0})
	end
end

function MainViewGvgPage:updateMetal_hpper()
	local metal_hpper = self.gvgIns.metal_hpper
	metal_hpper = metal_hpper and metal_hpper or 0
	self.progressSlider.value = metal_hpper/100
	self.progressLabel.text = math.floor(metal_hpper).."%"
	if(metal_hpper >= 70)then
		self.progressForebg.spriteName = "com_bg_hp"
	elseif(metal_hpper >= 25)then
		self.progressForebg.spriteName = "com_bg_hp_3s"
	else
		self.progressForebg.spriteName = "com_bg_hp_2s"
	end
end

function MainViewGvgPage:AddViewEvts()
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireMetalHpFubenCmd, self.updateMetal_hpper)
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireDangerFubenCmd, self.updateDangerTime)
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireStopFubenCmd, self.handleFireStopFubenCmd)
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireNewDefFubenCmd, self.updateGuildInfo)
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, self.SetData)
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireRestartFubenCmd, self.SetData)
	self:AddListenEvt(ServiceEvent.FuBenCmdGvgDataSyncCmd, self.updateHonorValue)
	self:AddListenEvt(ServiceEvent.FuBenCmdGvgDataUpdateCmd, self.updateHonorValue)
	self:AddListenEvt(GVGEvent.ShowNewAchievemnetEffect, self.HandleAchieveEffect)
end

function MainViewGvgPage:resizeContent(  )
	-- body
	if(not self.container.gameObject.activeInHierarchy)then
		return
	end
	local bd = calSize(self.content.transform,false)
	local height = bd.size.y
	self.bg.height = height+10

	local x,y,z = getLocalPos(self.GvgHonorTraceInfo.transform)
	local x1,y1,z1 = getLocalPos(self.bg.transform)
	tempVector3:Set(x,y1 - height - 20,z)
	self.GvgHonorTraceInfo.transform.localPosition = tempVector3
end

function MainViewGvgPage:updateCountTime( totalTime,type )
	local susGuildName = self.gvgIns.susGuildName
	local danger = self.gvgIns.danger
	local finish = self.gvgIns.isFinish
	local result = self.gvgIns.result
	local dangerTime = self.gvgIns.danger_time
	local endfire_time = self.gvgIns.endfire_time
	local isDefPerfect = self.gvgIns.def_perfect
	-- local calmdown = self.gvgIns.calmdown
	-- if(calmdown)
	danger = danger and danger or false
	finish = finish and finish or false
	result = result and result or FuBenCmd_pb.EGUILDFIRERESULT_DEFSPEC
	susGuildName = susGuildName and susGuildName or "unknow"

	dangerTime = dangerTime and dangerTime or self.curServerT+300
	endfire_time = endfire_time and endfire_time or self.curServerT +3000
	local leftTime = nil
	local str = ""
	local countLabel = nil
	-- helplog("danger:",tostring(danger),tostring(self.isDefSide),tostring(finish),tostring(result))

	if(finish)then
		if(result == FuBenCmd_pb.EGUILDFIRERESULT_DEFSPEC)then
			if(self.isDefSide)then
				str = ZhString.MainViewGvgPage_FinishState_SpecialSus
			else
				str = ZhString.MainViewGvgPage_FinishState_DefSusCountLabel
			end
		elseif(result == FuBenCmd_pb.EGUILDFIRERESULT_DEF)then
			str = ZhString.MainViewGvgPage_FinishState_Unbreak
		else
			str = ZhString.MainViewGvgPage_FinishState_Break
		end
	elseif(danger)then
		if(self.isDefSide)then
			str = ZhString.MainViewGvgPage_DangerState_Def
		else
			str = ZhString.MainViewGvgPage_DangerState_Attack
		end
		leftTime = dangerTime - ServerTime.CurServerTime()/1000
		leftTime = math.floor(leftTime)
		if(leftTime < 0)then
			leftTime = 0
		end
		local m = math.floor(leftTime / 60)
		local s = leftTime - m*60
		local time = string.format(ZhString.MainViewGvgPage_LeftTime,m,s)
		str = string.format(str,time)
	
	elseif(isDefPerfect)then
		str = ZhString.MainViewGvgPage_FinishState_SpecialSus
	else
		if(self.isDefSide)then
			str = ZhString.MainViewGvgPage_NormalState_Def
		else
			str = ZhString.MainViewGvgPage_NormalState_Attack
		end
		leftTime = endfire_time - ServerTime.CurServerTime()/1000
	end

--guild war left time
	local titleLeftTime = endfire_time - ServerTime.CurServerTime()/1000

	if(titleLeftTime < 0)then
		titleLeftTime = 0
		self.tickMg:ClearTick(self,type)
	end

	titleLeftTime = math.floor(titleLeftTime)

	local m = math.floor(titleLeftTime / 60)
	local s = titleLeftTime - m*60
	self.name.text = string.format(ZhString.MainViewGvgPage_TitleDes,m,s)
--end
	
	--des 
	local desText = ZhString.MainViewGvgPage_GvgPageTitleDes
	local holdName
	local sb = LuaStringBuilder.CreateAsTable()
	local def_guildid = self.gvgIns.def_guildid
	def_guildid = def_guildid and def_guildid or 0
	if(def_guildid == 0)then
		sb:Append(ZhString.MainViewGvgPage_GvgPageNoDefine)
	else		
		sb:Append('[ ')
		sb:Append(self.gvgIns.def_guildname)
		sb:Append(' ]')
	end
	-- helplog("sb:Append(self.gvgIns.def_guildname):",self.gvgIns.def_guildname,self.gvgIns.def_guildid,tostring(isDefPerfect))
	-- helplog(tostring(danger),tostring(finish),result)
	holdName=sb:ToString()
	sb:Destroy()
	desText = string.format(desText,holdName,str)
	self.countDownLabel.text = desText
	--end
	self:updateMetal_hpper()
	self:resizeContent()
end

function MainViewGvgPage:updateGuildInfo()
	local def_guildid = self.gvgIns.def_guildid
	def_guildid = def_guildid and def_guildid or 0
	local myGuildId = GuildProxy.Instance.myGuildData and GuildProxy.Instance.myGuildData.guid or nil
	if(myGuildId == nil)then
		self.isDefSide = false
	elseif(myGuildId == def_guildid)then
		self.isDefSide = true
	else
		self.isDefSide = false
	end
end

function MainViewGvgPage:updateDangerTime()
	local isDanger = self.gvgIns.danger
	isDanger = isDanger and isDanger or false
	if(isDanger)then
		if(self.isDefSide)then

		else

		end
	else

	end
end

function MainViewGvgPage:stopDelayRemoveEffect()
	if(self.BlockRemoveEffectTwId)then
		LeanTween.cancel(self.gameObject,self.BlockRemoveEffectTwId)
		self.BlockRemoveEffectTwId = nil
	end
end

function MainViewGvgPage:delayRemoveEffect()
	self:stopDelayRemoveEffect()
	local ret = LeanTween.delayedCall(self.gameObject,2,function (  )
		self.BlockRemoveEffectTwId = nil
		if(self.effectObj)then
			self:Hide(self.effectObj)
		end
	end)
	self.BlockRemoveEffectTwId = ret.uniqueId
end

function MainViewGvgPage:HandleAchieveEffect()
	if(self.effectObj and TipsView.Me().currentTipType ~= GvgQuestTip)then
		self:Show(self.effectObj)
		self:delayRemoveEffect()
	end
end

function MainViewGvgPage:updateCalmdown(isCalmdown,calmTime)

end

function MainViewGvgPage:handleFireStopFubenCmd()

end