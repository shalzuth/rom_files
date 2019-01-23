local baseCell = autoImport("BaseCell")
AnnounceQuestPanelCell = class("AnnounceQuestPanelCell",baseCell)
autoImport("AnnounceQuestPanelTeamMemberPortrail")
local tempVector3 = LuaVector3.zero

AnnounceQuestPanelCellLabelColor = {
	[1] = LuaColor.New(184/255,91/255,26/255,1),
	[2] = LuaColor.New(38/255,107/255,0,1),
	[3] = LuaColor.New(131/255,7/255,12/255,1),
}

function AnnounceQuestPanelCell:Init()
	self:initView()
	self:addViewEventListener()
end

function AnnounceQuestPanelCell:initView(  )
	-- body
	-- self.des = self:FindGO("des"):GetComponent(UILabel)
	self.questPublisherHead = self:FindGO("questPublisherHead")
	self.publishName = self:FindGO("publishName"):GetComponent(UILabel)
	self.questName = self:FindGO("questName"):GetComponent(UILabel)

	
	self.questDetailLabel = self:FindGO("questDetailLabel"):GetComponent(UILabel)
	self.questDetailLabel.spacingX = 0 --todo xde spacingX set 0 
	self.questTarget = self:FindGO("questTarget"):GetComponent(UILabel)
	self.questTargetCt = self:FindGO("questTargetCt")

	-- --todo xde
	-- self.questTarget.useFloatSpacing = true
	-- self.questTarget.overflowMethod = 3
	-- self.questTarget.fontSize = 18
	-- self.questTarget.transform.localPosition = Vector3(0,0,0)
	-- self.questTarget.width = 290
	-- self.questTargetNumLable = self:FindGO("numLabel",self.questTarget.gameObject):GetComponent(UILabel)

	-- self.questRewardLabel = self:FindGO("questRewardLabel"):GetComponent(UILabel)
	self.questReward = self:FindGO("questReward")
	self.publishNameCt = self:FindGO("publishNameCt")
	self.simpleIcon = self:FindComponent("simpleIcon",UISprite)

	self.acceptActionBtn = self:FindGO("acceptActionBtn")
	self.abandonActionBtn = self:FindGO("abandonActionBtn")
	self.cannotActionBtn = self:FindGO("cannotActionBtn")
	self.commitActionBtn = self:FindGO("commitActionBtn")
	
	self.leaderAceeptBtn = self:FindGO("leaderAceeptBtn")
	local leaderAceeptBtnText = self:FindComponent("actionBtnLabel1",UILabel,self.leaderAceeptBtn)
	leaderAceeptBtnText.text = ZhString.AnnounceQuestPanel_LeaderAceeptBtn

	self.actionBtn = self:FindComponent("actionBtn",UISprite)
	self.actionBtnLabel = self:FindComponent("actionBtnLabel1",UILabel)
	self.actionBtnCollider = self:FindComponent("actionBtn",BoxCollider)

	self.questState = self:FindGO("questState")

	self.questStateScale = self.questState:GetComponent(UIPlayTween)
	self.completeHolder = self:FindGO("completeHolder")

	self.questBaseReward = self:FindGO("questBaseReward")
	self.baseExp = self:FindGO("baseExp"):GetComponent(UILabel)
	self.jobExp = self:FindGO("jobExp"):GetComponent(UILabel)
	self.robCount = self:FindGO("robCount"):GetComponent(UILabel)

	self.itemCount = self:FindGO("itemCount"):GetComponent(UILabel)
	self.itemIcon = self:FindGO("itemCt"):GetComponent(UISprite)

	self.teamQuestPortrait = self:FindGO("teamQuestPortrait")
	self.teamQuestPortraitGrid = self:FindComponent("portraitList",UIGrid)
	self.teamQuestPortraitGrid = UIGridListCtrl.new(self.teamQuestPortraitGrid , AnnounceQuestPanelTeamMemberPortrail, "AnnounceQuestPanelTeamMemberPortrail");

	self.teamQuestHelpReward = self:FindGO("teamQuestHelpReward")
	self.teamQuestHelpRewardLabel = self:FindGO("teamQuestHelpRewardLabel")
	self.teamQuestHelpRewardLabel = SpriteLabel.new(self.teamQuestHelpRewardLabel,nil,40,40,true)
	self.helpQuestIcon = self:FindGO("helpQuestIcon")
	self.radioCt = self:FindGO("ratioCt")
	self.activityRelCt = self:FindGO("activityRelCt")
	self.acBgCt = self:FindGO("acBgCt")
	self.act_bg = self:FindGO("act_bg")
	-- self.extraCt = self:FindGO("extraCt")
	local ratioTip = self:FindComponent("ratioTip",UILabel)
	ratioTip.text = "Award" -- todo xde ZhString.AnnounceQuestPanel_MultiRewardTip	
	self:FindComponent("ratioTip",UIWidget).depth = 100
    self:FindComponent("ratioLabel",UIWidget).depth = 100
	self.ratioLabel = self:FindComponent("ratioLabel",UILabel)
	-- self.extraLabel = self:FindComponent("extraLabel",UILabel)
	local teamOngingLabel = self:FindComponent("teamOngingLabel",UILabel)
	teamOngingLabel.text = ZhString.AnnounceQuestPanel_TeamOngingLabel
	self:Hide(teamOngingLabel.gameObject)
	self:Hide(self.activityRelCt)
	self:Hide(self.acBgCt)
	self:Hide(self.act_bg)
	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local panels = self:FindComponents(UIPanel);

	for i=1,#panels do
		panels[i].depth = upPanel.depth + panels[i].depth;
	end
end

function AnnounceQuestPanelCell:initHelpTeamReward(  )
	-- body
	-- local reward = GameConfig.Quest.helpTeamMemberReward
	-- if(reward)then
		local itemId = 147
		local itemData = Table_Item[itemId]
		-- local count = reward.count
		if(itemData)then
			-- local text = string.format(ZhString.AnnounceQuestPanel_HelpTeammemberReward,reward.itemId,itemData.NameZh,count)
			local text = string.format(ZhString.AnnounceQuestPanel_HelpTeammemberReward,itemId,itemData.NameZh)
			----[[ todo xde 临时解决换行问题
			if(AppBundleConfig.GetSDKLang() == 'id') then
				text = text:gsub("Membantu teman akan mendapatkan", "")
				-- self.teamQuestHelpRewardLabel.width = 340
				-- printData('text', text)
			end
			--]]
			self.teamQuestHelpRewardLabel:SetText(text)
			return
		end
	-- end
	-- self.teamQuestHelpRewardLabel:SetText("")	
end

function AnnounceQuestPanelCell:addViewEventListener(  )
	-- body

	self:AddButtonEvent("actionBtn",function ( obj )
	-- body
		if(self.data.notMine)then
			self.actionBtn.color = Color(1/255,2/255,3/255,1)
			self.actionBtnCollider.enabled = false
			if(self.DisenableAnnounceQuestTwId)then
				LeanTween.cancel(self.gameObject,self.DisenableAnnounceQuestTwId)
				self.DisenableAnnounceQuestTwId = nil
			end
			local ret = LeanTween.delayedCall(self.gameObject,5,function (  )
				self.DisenableAnnounceQuestTwId = nil
				self.actionBtn.color = Color(1,1,1,1)
				self.actionBtnCollider.enabled = true
			end)
			self.DisenableAnnounceQuestTwId = ret.id
		end
		self:PassEvent(MouseEvent.MouseClick, self);
	end)

	self:AddClickEvent(self.leaderAceeptBtn,function ( obj )
	-- body
		if(self:checkWantedTick(self.data))then
			return
		end
		ServiceQuestProxy.Instance:CallInviteHelpAcceptQuestCmd(nil,self.data.id)
	end)
end


function AnnounceQuestPanelCell:checkWantedTick( data )

	if(not data or not data.wantedData or data.wantedData.IsActivity == 1)then
		return
	end

	local questConfig = GameConfig.Quest.quick_finish_board_quest or {}
	local wantedData = data.wantedData
	local questMinLimit,questMaxLimit = wantedData.LevelRange[1],wantedData.LevelRange[2]
	local dont = LocalSaveProxy.Instance:GetDontShowAgain(55)
	local single
	local itemId
	local minLv
	local maxLv
	if(dont == nil)then
		for i=1,#questConfig do
			single = questConfig[i]
			itemId = single[1] or nil
			minLv = single[2] or 1
			maxLv = single[3] or 999999
			itemData = BagProxy.Instance:GetItemByStaticID(itemId)
			if(self:checkLevelCross(questMinLimit,questMaxLimit,minLv,maxLv) and itemData )then
				MsgManager.DontAgainConfirmMsgByID(55,
				 function ()
					AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
					ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM,self.data.id)
				 end,
				 function (  )
				 	AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
				 	ServiceQuestProxy.Instance:CallInviteHelpAcceptQuestCmd(nil,self.data.id)
				 end, nil, itemData:GetName(true,true))
				return true
			end
		end
	else
		for i=1,#questConfig do
			single = questConfig[i]
			itemId = single[1] or nil
			minLv = single[2] or 1
			maxLv = single[3] or 999999
			itemData = BagProxy.Instance:GetItemByStaticID(itemId)
			if(self:checkLevelCross(questMinLimit,questMaxLimit,minLv,maxLv) and itemData)then
				AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
				ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD_TEAM,self.data.id)
				return true
			end
		end
	end
end

function AnnounceQuestPanelCell:checkLevelCross( qMinLv,qMaxLv,rMinLv,rMaxLv )
	if(qMaxLv>=rMinLv and qMinLv <=rMaxLv)then
		return true
	end
end

function AnnounceQuestPanelCell:setIsSelected( isSelect )
	-- body
	if(self.isSelect ~= isSelect)then
		self.isSelect = isSelect
		if(self.isSelect)then
			self:Show(self.selector.gameObject)
		else
			self:Hide(self.selector.gameObject)
		end
	end
end
function AnnounceQuestPanelCell:OnRemove()
	if(self.DisenableAnnounceQuestTwId)then
		LeanTween.cancel(self.gameObject,self.DisenableAnnounceQuestTwId)
		self.DisenableAnnounceQuestTwId = nil
	end
end
function AnnounceQuestPanelCell:setEnableAccept(  )
	-- body
	local state = QuestProxy.Instance:hasGoingWantedQuest()
	if(state)then
		if(self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
			self.actionBtn.color = Color(1/255,2/255,3/255,1)
			self.actionBtnCollider.enabled = false
			self.actionBtnLabel.effectStyle = UILabel.Effect.None
		end
	end
end

function AnnounceQuestPanelCell:playAnim(  )
	self:PlayUIEffect(EffectMap.UI.stamp,self.completeHolder,true,AnnounceQuestPanelCell.AnimEffectHandle, self)
end

function AnnounceQuestPanelCell.AnimEffectHandle(effectHandle, owner)
end

function AnnounceQuestPanelCell:checkQuest()
	local charIds = ShareAnnounceQuestProxy.Instance:getOnGoTeamMembersByQuestIdAndAction(self.data.id)

	if(TeamProxy.Instance:IHaveTeam())then
		local questData = QuestProxy.Instance:getWantedQuestDataByIdAndType(self.data.id,SceneQuest_pb.EQUESTLIST_ACCEPT)
		questData = questData and QuestData or QuestProxy.Instance:getWantedQuestDataByIdAndType(self.data.id,SceneQuest_pb.EQUESTLIST_COMPLETE)
		if(questData)then
			table.insert(charIds,Game.Myself.data.id)
		end
	end
	
	if(charIds and #charIds>0)then
		local teamMembersData = {}
		if(not TeamProxy.Instance:IHaveTeam())then
			return
		end
		local myTeam = TeamProxy.Instance.myTeam
		for i=1,#charIds do
			local single = charIds[i]
			local memberData = myTeam:GetMemberByGuid(single);
			if(memberData)then
			  table.insert(teamMembersData,memberData)
			end
		end
		if(#teamMembersData>0)then
			self:Show(self.teamQuestPortrait)
			self:setTeamMembers(teamMembersData)
		else
			self:Hide(self.teamQuestPortrait)
		end
	else
		self:Hide(self.teamQuestPortrait)
	end
end

function AnnounceQuestPanelCell:setTeamMembers(teamMembersData)
	
	self.teamQuestPortraitGrid:ResetDatas(teamMembersData)
end

function AnnounceQuestPanelCell:adjustButtonSt( data )
	-- body
	self.actionBtn.color = Color(1,1,1,1)
	self.actionBtnCollider.enabled = true
	self:Show(self.actionBtn.gameObject)
	if(data.notMine)then
		self:Hide(self.questState)		
		self.actionBtn.spriteName = "com_btn_3"
		self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_HelpQuest
		self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[2]
		self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
		self:checkQuest()
		self:changeToNormalView()
	elseif(data:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT)then
		self:Hide(self.questState)
		self:checkQuest()
		self.actionBtn.spriteName = "com_btn_0"
		self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_AbadonQuest
		self:changeToNormalView()		
		self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[3]
		self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
	elseif(data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE)then
		self:Hide(self.questState)	
		self:checkQuest()		
		self.actionBtn.spriteName = "com_btn_2"
		self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_CommitQuest
		self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[1]
		self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
		self:changeToNormalView()		
	elseif(data:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT)then
		self:Show(self.questState)
		self:Hide(self.actionBtn.gameObject)
		self:Hide(self.teamQuestPortrait)
		self:changeToNormalView()
		-- self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
		-- self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[1]
	elseif(data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
		self:Hide(self.questState)	
		self:checkQuest()
		self.actionBtn.spriteName = "com_btn_2"
		self.actionBtnLabel.text = ZhString.AnnounceQuestPanel_AcceptQuest
		self.actionBtnLabel.effectColor = AnnounceQuestPanelCellLabelColor[1]
		self.actionBtnLabel.effectStyle = UILabel.Effect.Outline
		-- 当前队长
		-- 收集杀怪
		-- 可接取任务 （local state = QuestProxy.Instance:hasGoingWantedQuest()）
		local condition =  TeamProxy.Instance:IHaveTeam() and TeamProxy.Instance:CheckIHaveLeaderAuthority() or false
		condition = condition and not QuestProxy.Instance:hasGoingWantedQuest() or false
		
		-- self:Log(TeamProxy.Instance:IHaveTeam(),TeamProxy.Instance:CheckImTheLeader(),QuestProxy.Instance:hasGoingWantedQuest(),data.wantedData.Content )
		-- condition = false
		condition = condition and SkillProxy.Instance:HasLearnedSkill(AnnounceQuestPanel.skillid)
		if(condition and data.wantedData.IsActivity ~= 1)then
			self:changeToTeamLeaderView()
		else
			self:changeToNormalView()
		end
	end
end

function AnnounceQuestPanelCell:changeToTeamLeaderView(  )
	-- body
	self:Show(self.leaderAceeptBtn)
	tempVector3:Set(-88,0,0)
	self.actionBtn.transform.localPosition = tempVector3
	self.actionBtn.width = 161
end

function AnnounceQuestPanelCell:changeToNormalView(  )
	-- body
	self:Hide(self.leaderAceeptBtn)
	tempVector3:Set(0,0,0)
	self.actionBtn.transform.localPosition = tempVector3
	self.actionBtn.width = 226
end

function AnnounceQuestPanelCell:SetData( data )
	-- body
	self.data = data
	if(self.data)then
		self:Show()
	else
		if(not self:ObjIsNil(self.gameObject))then
			self:Hide()
		end
		return
	end
	local wantedData = data.wantedData
	if(wantedData)then
		-- self:initBg()
		local targetText = ""

		if(data.notMine or data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
			targetText = QuestDataUtil.parseWantedQuestTranceInfo(data,wantedData)
		else
			targetText = data:parseTranceInfo()
			-- printRed(data:parseTranceInfo())
		end
		if(targetText ~= "")then
			self:Show(self.questTargetCt)
			self.questTarget.text = targetText
		else
			self:Hide(self.questTargetCt)
		end
		self.questDetailLabel.text = wantedData.Describe
		self.questName.text = wantedData.Name
		local ret
		if(wantedData.Type ==2 and wantedData.Icon ~= "")then
			ret = self:SetSimpleIcon(wantedData.Icon)
		end
		if(not ret)then
			self:SetNpcData(wantedData.NpcId)
		end
		self:adjustButtonSt(data)
		self:setEnableAccept()

		if(data.notMine)then
			self:Show(self.teamQuestHelpReward)
			self:Hide(self.questBaseReward)
			self:Show(self.helpQuestIcon)
		else
			self:Hide(self.helpQuestIcon)
			self:Show(self.questBaseReward)
			self:Hide(self.teamQuestHelpReward)
			self:setQuestRewardData()
		end
		self:initHelpTeamReward()
	else
		printRed("can't find wantedData in Table_Wanted by id:"..data.id)
	end
end

function AnnounceQuestPanelCell:setQuestRewardData(  )
	-- body
	local data = self.data
	local wantedData = self.data.wantedData
	local BaseLv = data.acceptlv
	local expData = Table_ExpPool[BaseLv]
	local finishcount = data.finishcount
	if(self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
		finishcount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
	end
	if(not finishcount)then
		finishcount = 0
	end
	local ratio = QuestProxy.Instance:getWantedQuestRatio( finishcount  )
	-- printRed("AnnounceQuestPanelCell:SetData( data )",BaseLv,ratio,finishcount,wantedData.Name)
	if(wantedData.IsActivity == 1)then
		ratio = 1
	end
	if(expData)then
		self.baseExp.text = math.floor(expData.WantedBaseExp*ratio)
		self.jobExp.text = math.floor(expData.WantedJobExp*ratio)
	end
	if(data.wantedData.Rob)then
		self.robCount.text = math.floor(data.wantedData.Rob*ratio)
	else
		self.robCount.text = "0"
	end	

	if(data.rewards)then
		if(data.rewards[1])then
			local rewarData = data.rewards[1]
			local itemData = Table_Item[rewarData.id]
			if(itemData)then
				self.itemCount.text = rewarData.count
				IconManager:SetItemIcon(itemData.Icon,self.itemIcon)
			end
		end
	end

	local showCt = false
	local data = ActivityEventProxy.Instance:GetRewardByType(AERewardType.WantedQuest)
	if(data and data:GetMultiple() and data:GetMultiple() ~= 0 and wantedData.IsActivity ~= 1)then
		self:Show(self.activityRelCt)
		self:Show(self.radioCt)
		self.ratioLabel.text = "x"..data:GetMultiple()
		showCt = true
	else
		self:Hide(self.radioCt)
	end
	if(not showCt)then
		self:Hide(self.activityRelCt)
	else
		self:Show(self.activityRelCt)
		--todo xde
		OverseaHostHelper:FixLabelOverV1(self.questName,3,201)
		----[[ todo xde 调整 reward x 2位置
		TransformExtenstion:AddLocalPositionX(self.activityRelCt.transform, 24)
		--]]
	end

	if(wantedData.IsActivity ~= 1)then
		self:Hide(self.acBgCt)
		self:Hide(self.act_bg)
	else
		self:Show(self.acBgCt)
		self:Show(self.act_bg)
	end
end

function AnnounceQuestPanelCell:playRatioUpAnm(  )
	-- body
	if(self.data)then
		if(self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT or self.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT)then
			self:Hide(self.baseExp.gameObject)
			self:Hide(self.robCount.gameObject)
			self:Hide(self.jobExp.gameObject)

			local holder = self:FindGO("EffectContainer",self.baseExp.transform.parent.gameObject)
			self:PlayUIEffect(EffectMap.UI.Refresh,holder,true)
			holder = self:FindGO("EffectContainer",self.jobExp.transform.parent.gameObject)
			self:PlayUIEffect(EffectMap.UI.Refresh,holder,true)
			holder = self:FindGO("EffectContainer",self.robCount.transform.parent.gameObject)
			self:PlayUIEffect(EffectMap.UI.Refresh,holder,true)

			self:showReward()
		end
	end
end

function AnnounceQuestPanelCell:showReward(  )
	-- body		
	LeanTween.delayedCall(self.gameObject,0.5,function (  )
		-- body
		self:Show(self.baseExp.gameObject)
		self:Show(self.robCount.gameObject)
		self:Show(self.jobExp.gameObject)
	end)
end

function AnnounceQuestPanelCell.effectLoaded(effectObj )
	-- if( effectObj and not LuaGameObject.ObjectIsNull(effectObj.gameObject) )then
	-- 	LuaGameObject.SetRenderQueue(effectObj.gameObject,3500)
	-- end
end

function AnnounceQuestPanelCell:initBg( )
	-- local wantedData = self.data.wantedData
	-- if(wantedData and wantedData.Type ==1)then
	-- 	self:Show(self.actBgSp.gameObject)
	-- 	self:Hide(self.textureBg)
	-- else
	-- 	self:Hide(self.actBgSp.gameObject)
	-- 	self:Show(self.textureBg)
	-- end
end

function AnnounceQuestPanelCell:SetSimpleIcon( Icon )
	local ret =  IconManager:SetUIIcon(Icon,simpleIcon)
	if(ret)then
		self:Show(self.simpleIcon.gameObject)
		self:Hide(self.publishNameCt)
	end
	return ret
end

function AnnounceQuestPanelCell:SetNpcData( npcId )
	-- body
	local npcdata = Table_Npc[npcId]
	self:Hide(self.simpleIcon.gameObject)
	self:Show(self.publishNameCt)
	if(npcdata)then
		if(not self.targetCell)then
			self.targetCell = HeadIconCell.new()
			self.targetCell:CreateSelf(self.questPublisherHead)
			self.targetCell:SetScale(1)
			self.targetCell:SetMinDepth(3)
		end
		self.publishName.text = npcdata.NameZh
		local data = ReusableTable.CreateTable()

		if(npcdata.Icon == "")then
			data.bodyID = npcdata.Body or 0
			data.hairID = npcdata.Hair or 0
			data.haircolor = npcdata.HeadDefaultColor or 0
			data.gender = npcdata.Gender or -1
			data.eyeID = npcdata.Eye or 0
			self.targetCell:SetData(data)
		else
			self.targetCell:SetSimpleIcon(npcdata.Icon)
		end
		ReusableTable.DestroyTable(data)
	else
		printRed("can't find npcData at id:"..npcId)
	end	
end

function AnnounceQuestPanelCell:OnExit()
	self.super.OnExit(self)
	LeanTween.cancel(self.gameObject)
end