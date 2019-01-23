PetAdventureView = class("PetAdventureView", BaseView);
autoImport("PetAdventureQuestCell");
autoImport("PetAdventureChooseCell")
autoImport("PetDropItemCell")
autoImport("PetDropItemData")

PetAdventureView.ViewType = UIViewType.NormalLayer
local startAdventureEff = EffectMap.Maps.StartPetAdventure
local effectResID=EffectMap.UI.PVP_Win
local rewardEffResID = EffectMap.UI.Pet_RewardUp
local totalQuest = GameConfig.PetAdventureMinLimit.max_adventure
local fightTimeHelpId = 100003
local rewardEfficHelpId = 100002
local Zeny = 100
local jobBase = 400
local base = 300

local chooseBtnPosition =
	 {
	 	[1] = Vector3(-122,58,0),
	 	[2] = Vector3(-260,58,0),
	 	[3] = Vector3(0,58,0),
	 	[4] = Vector3(-360,58,0),
	 	[5] = Vector3(118,58,0),
	 }

function PetAdventureView:Init()
	self:FindObjs()
	self:AddViewEvts()
	self:AddEvts()
	self:Hide(self.PetQuest)
end

local QuestPhase = {
	NONE = 0,
	MATCH = 1,
	FINISHED = 2,
	UNDERWAY = 3,
}

function PetAdventureView:FindObjs()
	self.PetQuest=self:FindGO("Pos")
	self.loadingPos=self:FindGO("Loading")
	self.petScroll = self:FindComponent("petQuestScroll",UIScrollView)
	self.petTexture = self:FindComponent("petTexture", UITexture)

	local PetInfo = self:FindGO("PetInfo")
	self.adventureNameLab = self:FindComponent("adventureName", UILabel, PetInfo)
	self.recommendPetLab = self:FindComponent("recommendLab",UILabel,PetInfo)
	self.petDesc = self:FindComponent("petDesc", UILabel, PetInfo)
	self.effectPos=self:FindGO("effectRoot")
	self.rewardEffectPos=self:FindGO("rewardEffectPos")
	self.goBtn = self:FindGO("goBtn")
	self.getRewardBtn = self:FindGO("GetRewardBtn")
	self.consumeFightTimeLab = self:FindComponent("ConsumeFightTimeLab",UILabel)
	self.questProcessLab = self:FindComponent("questProcess",UILabel)
	self.costMoney = self:FindComponent("costMoney",UILabel)
	self.areaFilter = self:FindComponent("areaFilter",UIPopupList)
	self.petChoosePanel = self:FindGO("petChoosePos")
	self.costLab=self:FindComponent("costLab",UILabel)
	self.goBtnLabelEffectColor = self.costLab.effectColor
	self.curFightEfficiency=self:FindComponent("fightEffec",UILabel)
	-- self.adventureTime = self:FindComponent("adventureTime",UILabel)
	self.consumeHelpBtn = self:FindGO("consumeHelpBtn")
	self.petChooseNum = self:FindComponent("petChooseNum",UILabel)
	self.rewardTitle=self:FindComponent("rewardTitle",UILabel)
	self.PetStatusTitle=self:FindComponent("PetStatusTitle",UILabel)
	self.curAreaName=self:FindComponent("areaFilterName",UILabel)
	self.finishedImg=self:FindComponent("finishedImg",UISprite)
	self.costPos=self:FindGO("costPos")
	self.emptyCost=self:FindComponent("emptyCost",UILabel)
	self.iconImg=self:FindComponent("costIcon",UISprite)
	self.closecomp = self.petChoosePanel:GetComponent(CloseWhenClickOtherPlace)
	self.closecomp.callBack = function (go)
		PetAdventureProxy.Instance:ResetPetClickIndex()
	end

	local container = self:FindGO("PetQuestWrap")
	local questConfig = {
		wrapObj = container,
		pfbNum = 6, 
		cellName = "PetAdventureQuestCell", 
		control = PetAdventureQuestCell, 
		dir = 1,
	}
	self.petQuestlist = WrapCellHelper.new(questConfig)
	self.petQuestlist:AddEventListener(MouseEvent.MouseClick, self.ClickPetQuestCell, self)
	self.petQuestlist:AddEventListener(PetQuestEvent.OnClickMonster,self.onClickSpec,self)

	local PetWrapObj = self:FindGO("PetWrap")
	local petConfig = {
		wrapObj = PetWrapObj,
		pfbNum = 6, 
		cellName = "PetAdventureChooseCell", 
		control = PetAdventureChooseCell, 
		dir = 1,
	}
	self.petlist = WrapCellHelper.new(petConfig)
	self.petlist:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenPetCell, self)
	self.petlist:AddEventListener(PetEvent.ClickPetAdventureIcon,self.ShowPetHeadTips,self)
	
	
	self:Hide(self.petChoosePanel)
	PetAdventureProxy.Instance:ResetPetClickIndex()
	self:InitAreaFilter()
end

function PetAdventureView:ShowPetHeadTips(cellctl)
	if(cellctl)then
		local stickPos = cellctl.headTipStick
		local tipData = cellctl.data
		local petheadTip = TipManager.Instance:ShowPetAdventureHeadTip(tipData,stickPos,NGUIUtil.AnchorSide.Right,{205,-120})
		petheadTip:AddIgnoreBounds(self.petChoosePanel)
		self:AddIgnoreBounds(petheadTip.gameObject)
	end
end

function PetAdventureView:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function PetAdventureView:AddEvts()

	self:AddClickEvent(self.goBtn,function (g)
		self:StartPetAdventure()
	end)
	self:AddClickEvent(self.getRewardBtn,function (g)
		self:ClickGetRewardBtn()
	end)
	self:AddClickEvent(self.curFightEfficiency.gameObject,function (g)
		local data = PetAdventureProxy.Instance.tipData
		if(data)then
			self:ShowAdventureEffDetail(data)
		end
	end)

	self:AddClickEvent(self.recommendPetLab.gameObject,function (g)
		self:ShowRecommendPetTip()
	end)

	self:AddClickEvent(self.consumeHelpBtn,function (g)
		local Desc = Table_Help[fightTimeHelpId] and Table_Help[fightTimeHelpId].Desc or ZhString.Help_RuleDes
		TipsView.Me():ShowGeneralHelp(Desc)
	end)
	self:AddClickEvent(self.rewardTitle.gameObject,function (g)
		local Desc = Table_Help[rewardEfficHelpId] and Table_Help[rewardEfficHelpId].Desc or ZhString.Help_RuleDes
		TipsView.Me():ShowGeneralHelp(Desc)
	end)
	local closePetChoose = self:FindGO("closePetChoose")
	self:AddClickEvent(closePetChoose,function ()
		self:Hide(self.petChoosePanel)
		PetAdventureProxy.Instance:ResetPetClickIndex()
		TipManager.Instance:CloseTip();
	end)

	EventDelegate.Add(self.areaFilter.onChange, function()
		if self.areaFilter.data == nil then
			return
		end
		if self.areaFilterData ~= self.areaFilter.data then
			local allData = self:SetAreaData()
			local areaId = tonumber(self.areaFilter.data)
			local result
			if(areaId==0)then
				result=self.petQuestData
			else
				result = allData[areaId]
			end
			if(#result>0)then
				self.areaFilterData = self.areaFilter.data
				self:UpdateQuestByArea(result)
				self.areaFilterData=self.areaFilter.data
				self.curAreaValue=self.areaFilter.value
			else
				self.curAreaName.text=self.curAreaValue
				MsgManager.ShowMsgByID(8022)
			end
		end
	end)
end

function PetAdventureView:_resetClickIndex()
	self.clickPetIndex=nil
end

function PetAdventureView:UpdateQuestByArea(data)
	self.petQuestlist:ResetDatas(data)
	self:_ShowFirstQuestData()
	self.petQuestlist:ResetPosition()
end

function PetAdventureView:InitQuestData()
	self.petQuestData = PetAdventureProxy.Instance:GetQuestData()
	self.petQuestlist:UpdateInfo(self.petQuestData)
	self.petQuestlist:ResetPosition()
	self:_ShowFirstQuestData()
	self:SetProcessLab()
end

function PetAdventureView:InitAreaFilter()
	if(not self.rangeList)then
		self.rangeList = PetAdventureProxy.Instance:GetAreaFilter(GameConfig.PetAdventureArea)
		for i=1,#self.rangeList do
			local rangeData = GameConfig.PetAdventureArea[self.rangeList[i]]
			self.areaFilter:AddItem(rangeData , self.rangeList[i])
		end
	end
	if #self.rangeList > 0 then
		local range = self.rangeList[1]
		self.areaFilterData = range
		local rangeData = GameConfig.PetAdventureArea[range]
		self.areaFilter.value = rangeData
		self.curAreaValue=self.areaFilter.value
	end
end

function PetAdventureView:_ShowFirstQuestData()
	local questData = self.petQuestlist:GetCellCtls()
	local firstData = questData[1]
	if(firstData)then
		self:ClickPetQuestCell(firstData)
	end
end

function PetAdventureView:ShowRecommendPetTip()
	local chooseData = self.ChooseQuestData
	local condition = chooseData and chooseData.staticData.Condition
	if(condition)then
		TipManager.Instance:ShowRecommendTip(condition,self.recommendPetLab,NGUIUtil.AnchorSide.Top, {0,200})
	end
end

function PetAdventureView:ClickChoosenPetCell(cellctl)
	local clickPetId = cellctl.data.id
	local data = cellctl and cellctl.data;
	if(data)then
		local choosePet = data.guid
		if(PetAdventureProxy.Instance:bOverFlowPet(choosePet))then
			local petNum = self.ChooseQuestData.staticData.PetNum
			MsgManager.ShowMsgByIDTable(8012,petNum)
			-- MsgManager.ShowMsgByID(8012)
			return
		end
		local locked = PetAdventureProxy.Instance:bPetlocked(data)
		if(locked)then
			MsgManager.ShowMsgByID(8015)
			return
		end
		local index= PetAdventureProxy.Instance:SetMatchPetData(data)
		self:ShowPetModel(index)

		local petChoosenData=self.petlist:GetCellCtls()
		for _,cell in pairs(petChoosenData) do
			cell:UpdateChoose();
		end

		self:_updateInfoByState()
	end
end

function PetAdventureView:_refreshEfficiency()
	local configEff = PetAdventureProxy.Instance:GetFightEfficiency()
	if(0==configEff)then
		self:Hide(self.curFightEfficiency)
		return configEff
	end
	self.curFightEfficiency.text = string.format(ZhString.PetAdventure_FightEfficiency,math.ceil(configEff*100))
	self:Show(self.curFightEfficiency)
	return configEff
end

function PetAdventureView:OnClickPetChoose(index)
	if(self.ChooseQuestData.status~=PetAdventureProxy.QuestPhase.MATCH)then
		return 
	end
	self.petDataCells=PetAdventureProxy.Instance:GetOwnPetsData()
	if(not self.petDataCells or #self.petDataCells<=0)then
		MsgManager.ShowMsgByID(8019)
		return
	end
	PetAdventureProxy.Instance.clickPetIndex=index
	self:Show(self.petChoosePanel)
	TipManager.Instance:HidePetSpecTip()
	self.petlist:UpdateInfo(self.petDataCells)

	self.petlist:ResetPosition();
end

function PetAdventureView:SetProcessLab()
	local count = PetAdventureProxy.Instance:GetQuestProcess()
	self.questProcessLab.text=string.format(ZhString.PetAdventure_Process,count,totalQuest)
end

function PetAdventureView:SetAreaData()
	local static = Table_Pet_Adventure
	local result = {}
	for k,v in pairs(GameConfig.PetAdventureArea) do
		local data = {}
		for _,v in pairs(self.petQuestData) do
			local area = static[v.id].BigArea
			if(k==area)then
				table.insert(data,v)
			end
		end
		result[k]=data
	end
	return result
end

function PetAdventureView:AddViewEvts()
	-- 战斗时长
	-- self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd , self.GetBattleTime)
	self:AddListenEvt(ServiceEvent.ScenePetQueryPetAdventureListPetCmd, self.HandlePetAdventureList)
	self:AddListenEvt(ServiceEvent.ScenePetPetAdventureResultNtfPetCmd,self.HandlePetAdventureResult)
	self:AddListenEvt(ServiceEvent.ScenePetQueryBattlePetCmd,self.HandleBattlePet)
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange);	
end

function PetAdventureView:HandleMapChange()
	self:CloseSelf()
end

function PetAdventureView:HandlePetAdventureList(note)
	if(self.loadingPos.activeSelf)then
		self:Hide(self.loadingPos)
	end
	if(not self.PetQuest.activeSelf)then
		self:Show(self.PetQuest)
	end
	self:InitQuestData()
end

function PetAdventureView:ShowSpecialIDTip(data,stick,side,offset)
	local callback = function (param)
		if(not self.destroyed)then
			self.chooseSpecid=nil
			self:_setAdventureName(param)
			self.ChooseQuestData.specid=param
			local cellData = self.petQuestlist:GetCellCtls()
			for _,cell in pairs(cellData) do
				if(cell.data and cell.data.id==self.ChooseQuestData.id)then
					cell:SetChooseSpecial(param);
				end
			end
			self:_updateInfoByState()
		end
	end;

	local sdata = {
		itemdata = data, 
		ignoreBounds = ignoreBounds,
		callback = callback,
		callbackParam = callbackParam,
	};
	local tip = TipManager.Instance:ShowPetSpeicMonsterTip(sdata,stick,side,offset)
end

function PetAdventureView:_getMonsterID()
	local cellData = self.petQuestlist:GetCellCtls()
	for _,cell in pairs(cellData) do
		if(cell.data and cell.data.id==self.ChooseQuestData.id)then
			return cell.monsterId
		end
	end	
end

function PetAdventureView:ShowAdventureEffDetail(data,stick,side,offset)
	local sdata = {
		itemdata = data, 
		ignoreBounds = ignoreBounds,
	};
	local tip = TipManager.Instance:ShowPetAdventureEffDetail(sdata,stick,side,offset)
end

function PetAdventureView:HandlePetAdventureResult(note)
	local serData = note.body.item
	self.petQuestData = PetAdventureProxy.Instance:GetQuestData()
	self.petQuestlist:UpdateInfo(self.petQuestData)
	self.petQuestlist:ResetPosition()
	self:SetProcessLab()
	if(serData.status==PetAdventureProxy.QuestPhase.SUBMIT)then
		self:_ShowFirstQuestData()
		return
	end
	for k,v in pairs(self.petQuestData) do
		if(v.id==serData.id)then
			if(serData.status==PetAdventureProxy.QuestPhase.UNDERWAY)then
				self:UpdatePetQuestInfo(v)
			end
		end
	end
end

function PetAdventureView:HandleBattlePet(note)
	local data = note.body
	if(data and data.pets)then
		PetAdventureProxy.Instance:GetBattlePet(data.pets)
	end
end

function PetAdventureView:StartPetAdventure()
	local processCount = PetAdventureProxy.Instance:GetQuestProcess()
	if(processCount>=GameConfig.PetAdventureMinLimit.max_adventure)then
		MsgManager.ShowMsgByID(8013)
		return
	end
	local chooseData = self.ChooseQuestData
	local petNum = self.ChooseQuestData.staticData.PetNum
	-- local CostFT = chooseData.staticData.CostFightTime
	-- if(CostFT)then
	-- 	local bEnoughFightTime = self.fightTimeLen>=CostFT
	-- 	if(not bEnoughFightTime)then
	-- 		MsgManager.ShowMsgByID(8010)
	-- 		return
	-- 	end
	-- end
	if(chooseData.staticData.Cost and chooseData.staticData.Cost.id)then
		local petCount = PetAdventureProxy.Instance:GetMatchNum()
		if(petCount==0)then return end
		local staticNum = chooseData.staticData.Cost.num
		if(petNum ~= #staticNum)then
			helplog("Table_Pet_Adventure cost 配置错误,错误ID: ",chooseData.staticData.id)
			return
		end
		local costItem = chooseData.staticData.Cost.id
		if(costItem==GameConfig.MoneyId.Zeny)then
			local rob = MyselfProxy.Instance:GetROB()
			if(rob<staticNum[petCount])then
				MsgManager.ShowMsgByID(1)
				return 
			end
		else
			local ownCount = BagProxy.Instance:GetItemNumByStaticID(costItem)
			local needCount = staticNum[petCount]
			if(ownCount<needCount)then
				MsgManager.ShowMsgByID(8011)
				return
			end
		end
	end
	if(1==chooseData.staticData.QuestType)then
		local full = (petNum == PetAdventureProxy.Instance:GetMatchNum())
		if(not full)then
			MsgManager.ShowMsgByID(8015)
			return 
		end
	else
		if(0 == PetAdventureProxy.Instance:GetMatchNum())then
			MsgManager.ShowMsgByID(8019)
			return		
		end
	end
	local matchPet = PetAdventureProxy.Instance:GetMatchPetData()
	local servicePets = {}
	for i=1,#matchPet do
		if(matchPet[i] and 0~=matchPet[i] and matchPet[i].guid)then
			servicePets[i]=matchPet[i].guid
		else
			servicePets[i]="0"
		end
	end
	local cellMonsterID = self:_getMonsterID()
	ServiceScenePetProxy.Instance:CallStartAdventurePetCmd(self.chooseQuestID, servicePets,cellMonsterID)
	
	UIMultiModelUtil.Instance:PlayEffect(startAdventureEff,RoleDefines_EP.Chest)
end

function PetAdventureView:ClickGetRewardBtn()
	if(self.chooseQuestID and 0~=self.chooseQuestID)then
		ServiceScenePetProxy.Instance:CallGetAdventureRewardPetCmd(self.chooseQuestID)
	end
end

function PetAdventureView:_showVictoryEffect()
	self:PlayUIEffect(effectResID,self.effectPos,false,nil,self);
end

function PetAdventureView:_updateInfoByState()
	local petCount = PetAdventureProxy.Instance:GetMatchNum()
	local staticPetNum = self.ChooseQuestData.staticData.PetNum
	local bEmptyPets = (0==petCount)
	self.petChooseNum.text=string.format(ZhString.PetAdventure_MatchPetCount,petCount,staticPetNum)
	local chooseData = self.ChooseQuestData
	local staticdata = chooseData.staticData
	if(chooseData.status~=PetAdventureProxy.QuestPhase.MATCH)then
		self.costPos:SetActive(false)
		self:Hide(self.emptyCost)
	else
		if(staticdata.Cost and staticdata.Cost.id)then
			self.costPos:SetActive(true)
			local staticNum = staticdata.Cost.num
			if(staticPetNum~= #staticNum)then
				helplog("Table_Pet_Adventure cost 配置错误,错误ID: ",staticdata.id)
				return
			end
			local costIconName = Table_Item[staticdata.Cost.id].Icon
			IconManager:SetItemIcon(costIconName, self.iconImg)
			self.iconImg:MakePixelPerfect()
			--todo xde
			self.iconImg.transform.localScale = Vector3(0.5,0.5,0.5)
			self.iconImg.transform.localPosition = Vector3(20,3,0)
			if(bEmptyPets)then
				self.costPos:SetActive(false)
				self:Show(self.emptyCost)
			else
				local ownCount = BagProxy.Instance:GetItemNumByStaticID(staticdata.Cost.id)
				local needCount = staticNum[petCount]
				if(needCount)then
					if(ownCount>=needCount)then
						self.costMoney.color=ColorUtil.NGUIWhite
					else
						self.costMoney.color = ColorUtil.Red
					end
					self.costMoney.text = needCount
				end
				self.costPos:SetActive(true)
				self:Hide(self.emptyCost)
			end
		else
			self.costPos:SetActive(false)
			self:Show(self.emptyCost)
		end
	end

	
	local full = (staticPetNum == petCount)
	
	local bSpecialQuest = (1==chooseData.staticData.QuestType)

	local status = self.ChooseQuestData.status

	if(status==PetAdventureProxy.QuestPhase.FINISHED)then
		self:Hide(self.PetStatusTitle)
		self:Hide(self.recommendPetLab)
		self:Show(self.finishedImg)
	elseif(status==PetAdventureProxy.QuestPhase.MATCH)then
		if(bSpecialQuest)then
			self:Hide(self.recommendPetLab)
			self:Show(self.PetStatusTitle)
			local petNum = staticdata.PetNum
			self.PetStatusTitle.text=string.format(ZhString.PetAdventure_ThreePets,petNum)
		else
			self:Hide(self.PetStatusTitle)
			self:Show(self.recommendPetLab)
		end
		self:Hide(self.finishedImg)
	elseif(status==PetAdventureProxy.QuestPhase.UNDERWAY)then
		self:Show(self.PetStatusTitle)
		self:Hide(self.recommendPetLab)
		self:Hide(self.finishedImg)
	end

	if bEmptyPets then
		self:SetTextureGrey(self.goBtn)
		self.costLab.effectColor = ColorUtil.NGUIGray
		self.emptyCost.effectColor=ColorUtil.NGUIGray
	else
		if(not bSpecialQuest)then
			self:SetTextureWhite(self.goBtn)
			self.costLab.effectColor = self.goBtnLabelEffectColor
			self.emptyCost.effectColor=self.goBtnLabelEffectColor
		else
			if(full)then
				self:SetTextureWhite(self.goBtn)
				self.costLab.effectColor = self.goBtnLabelEffectColor
				self.emptyCost.effectColor=self.goBtnLabelEffectColor
			else
				self:SetTextureGrey(self.goBtn)
				self.costLab.effectColor = ColorUtil.NGUIGray
				self.emptyCost.effectColor=ColorUtil.NGUIGray
			end
		end
	end
	-- update condition by state 
	local condition = chooseData.staticData.Condition
	local icons = {}
	local recommendCond1 = self:FindComponent("recommendCond1",UISprite)
	local recommendCond2 = self:FindComponent("recommendCond2",UISprite)
	local recommendCond3 = self:FindComponent("recommendCond3",UISprite)
	icons={recommendCond1,recommendCond2,recommendCond3}
	for i=1,#icons do
		self:Hide(icons[i])
	end
	local rareCount = 0
	for i=1,#condition do
		local conditionData = Table_Pet_AdventureCond[condition[i]]
		if(nil==conditionData)then
			helplog("Table_Pet_AdventureCond 配置错误，错误ID：",tostring(condition[i]))
			return
		end
		local conType = conditionData.TypeID
		local param = conditionData.Param
		local staticIcon = conditionData.Icon
		self:Show(icons[i])
		local bOwn = self:_bConditionLocked(conditionData,icons[i])
		if(bOwn)then
			rareCount=rareCount+1
		end
	end

	local rewardData={}
	-- rareReward
	if(chooseData.rareReward)then
		for i=1,#chooseData.rareReward do
			local rareRewardCell = chooseData.rareReward[i]
			if(status==PetAdventureProxy.QuestPhase.MATCH)then
				local n = rareRewardCell.num/1000
				if(n<1)then
					helplog("稀有奖励数量发送错误")
				end
				--helplog("服务器发来的稀有奖励数量：",tostring(n),"达成多少个条件： ",tostring(rareCount)," 稀有奖励数量： ",n)
				if(rareCount==0)then
					rareRewardCell:SetCount(nil,0)
					rareRewardCell:SetlockState(true)
				else
					rareRewardCell:SetCount(nil,math.floor(n)*rareCount)
					rareRewardCell:SetlockState(false)
				end
			else
				rareRewardCell:SetCount(nil,rareRewardCell.num)
			end
			rareRewardCell:SetRare(true)
			-- helplog("添加的稀有奖励id :",dropItemData.staticData.id," 数量：",dropItemData.num)
			rewardData[#rewardData+1]=rareRewardCell
		end
	end
	-- normal reward
	local normalReward = chooseData.rewardMap
	local needCountDown = (status==PetAdventureProxy.QuestPhase.UNDERWAY)
	if(chooseData.multiMonsterReward)then
		local curMonsterId = self:_getMonsterID()
		if(curMonsterId)then
			local curRewardInfo = normalReward[curMonsterId]
			if(curRewardInfo)then
				for i=1,#curRewardInfo do
					local cell = curRewardInfo[i]
					local n = status==PetAdventureProxy.QuestPhase.MATCH and (cell.num/1000) or cell.num
					local count= (n<1 and 0 or math.floor(n))
					cell:SetCount(nil,count)
					cell:SetRare(false)
					rewardData[#rewardData+1]=cell
				end
			end
		end
	else
		for i=1,#normalReward do
			local dropItemData = normalReward[i]
			local n = status==PetAdventureProxy.QuestPhase.MATCH and (dropItemData.num/1000) or dropItemData.num
			local count= (n<1 and 0 or math.floor(n))
			dropItemData:SetCount(nil,count)
			dropItemData:SetRare(false)
			rewardData[#rewardData+1]=dropItemData
		end
	end
	if(not needCountDown)then
		self:_updateDropItem(rewardData)
	end
end

function PetAdventureView:_bConditionLocked(condStaticData,IconSprite)
	local petData = PetAdventureProxy.Instance:GetMatchPetData()
	local conType = condStaticData.TypeID
	local param = condStaticData.Param
	local staticIcon = condStaticData.Icon

	if('PetID'==conType)then
		IconManager:SetFaceIcon(staticIcon,IconSprite)
		self:SetTextureGrey(IconSprite.gameObject)
	elseif('Skill'==conType)then
		IconManager:SetSkillIcon(staticIcon,IconSprite)
		self:SetTextureGrey(IconSprite.gameObject)
	else
		IconManager:SetUIIcon(staticIcon,IconSprite)
		self:SetTextureGrey(IconSprite.gameObject)
	end
	local conLock = {PetID=false,Skill=false,Friendly=false,Nature=false,Race=false}
	for i=1,#petData do
		if(petData[i] and 0~=petData[i])then
			local id = petData[i].petid
			if('PetID'==conType and not conLock.PetID)then
				if(id and id == param[1])then
					self:SetTextureWhite(IconSprite.gameObject)
					conLock.PetID=true
				else
					self:SetTextureGrey(IconSprite.gameObject)
				end
			elseif('Skill'==conType and not conLock.Skill)then
				local bOwnSkill = petData[i]:bOwnSkill(param)
				if(bOwnSkill)then
					self:SetTextureWhite(IconSprite.gameObject)
					conLock.Skill=true
				else
					self:SetTextureGrey(IconSprite.gameObject)
				end
			elseif("Friendly"==conType and not conLock.Friendly)then
				local f = petData[i].friendlv>=param[1]
				if(f)then
					self:SetTextureWhite(IconSprite.gameObject)
					conLock.Friendly=true
				else
					self:SetTextureGrey(IconSprite.gameObject)
				end
			elseif("Nature"==conType and not conLock.Nature)then
				if(id and Table_Monster[id].Nature and Table_Monster[id].Nature==param[1])then
					self:SetTextureWhite(IconSprite.gameObject)
					conLock.Nature=true
				else
					self:SetTextureGrey(IconSprite.gameObject)
				end
			elseif("Race"==conType and not conLock.Race)then
				if(id and Table_Monster[id].Race and Table_Monster[id].Race==param[1])then
					self:SetTextureWhite(IconSprite.gameObject)
					conLock.Race=true
				else
					self:SetTextureGrey(IconSprite.gameObject)
				end
			end
		end
	end
	for k,v in pairs(conLock) do
		if(v)then
			return true
		end
	end
	return false
end

function PetAdventureView:ClickPetQuestCell(cellctl)
	local data = cellctl and cellctl.data;
	if(data)then
		self:UpdatePetQuestInfo(data)
		local clickQuestId = data.id
		-- 设置服务器宠物数据
		if(self.chooseQuestID~=clickQuestId)then
			self.chooseQuestID = clickQuestId
			local questData = self.petQuestlist:GetCellCtls()
			for _,cell in pairs(questData) do
				cell:SetChoose(clickQuestId);
				cell:SetChooseSpecial()
			end
		end
	end
end

function PetAdventureView:onClickSpec(cellctl)
	self:ClickPetQuestCell(cellctl)
	if(cellctl and cellctl.data.id)then
		if(cellctl.data.status~=PetAdventureProxy.QuestPhase.MATCH)then
			return
		end
		local mId = {0}
		local staticMonsterId = cellctl.data.staticData.MonsterReward
		for i=1,#staticMonsterId do
			mId[#mId+1]=staticMonsterId[i]
		end
		if(not mId)then return end
		if(self.chooseSpecid~=cellctl.data.id)then
			self.chooseSpecid=cellctl.data.id
			self:ShowSpecialIDTip(mId,cellctl.monsterIcon,NGUIUtil.AnchorSide.Right,{40, 0})
		else
			TipManager.Instance:CloseTip()
			self.chooseSpecid=nil
		end
	end
end

function PetAdventureView:_refreshPetModel(petData)
	local staticPetNum = self.ChooseQuestData.staticData.PetNum
	PetAdventureProxy.Instance:SetPetsData(staticPetNum,petData)
	for i=1,staticPetNum do
		self:ShowPetModel(i)
	end
end

function PetAdventureView:UpdatePetQuestInfo(data)
	PetAdventureProxy.Instance:SetChooseQuestData(data)
	self.ChooseQuestData=data
	local staticdata = data.staticData
	local staticPetNum = staticdata.PetNum

	local petChooseBtn1 = self:FindGO("ChooseBtn1")
	local petChooseBtn2 = self:FindGO("ChooseBtn2")
	local petChooseBtn3 = self:FindGO("ChooseBtn3")
	local ChooseBtn1 = self:FindGO("choosebg1")
	local ChooseBtn2 = self:FindGO("choosebg2")
	local ChooseBtn3 = self:FindGO("choosebg3")
	self.petChooseBg = {ChooseBtn1,ChooseBtn2,ChooseBtn3}
	self.petChooseBtn = {petChooseBtn1,petChooseBtn2,petChooseBtn3}
	
	if(1==staticPetNum)then
		self.petChooseBtn[1].transform.localPosition=chooseBtnPosition[1]
	elseif(2==staticPetNum)then
		self.petChooseBtn[1].transform.localPosition=chooseBtnPosition[2]
		self.petChooseBtn[2].transform.localPosition=chooseBtnPosition[3]
	elseif(3==staticPetNum)then
		self.petChooseBtn[1].transform.localPosition=chooseBtnPosition[4]
		self.petChooseBtn[2].transform.localPosition=chooseBtnPosition[1]
		self.petChooseBtn[3].transform.localPosition=chooseBtnPosition[5]
	end

	for i=1,#self.petChooseBtn do
		self:Hide(self.petChooseBtn[i])
	end
	for i=1,staticPetNum do
		self:Show(self.petChooseBtn[i])
	end
	for i=1,#self.petChooseBtn do
		self:AddClickEvent(self.petChooseBtn[i],function (g)
			self:OnClickPetChoose(i)
		end)
	end

	self.petDesc.text = staticdata.Desc;
	UIUtil.WrapLabel(self.petDesc)
	self:_setAdventureName(data.specid)
	local fT = staticdata.CostFightTime or 0
	self.consumeFightTimeLab.text = string.format(ZhString.PetAdventure_ConsumeFightTime,math.ceil(fT/60))
	
	self.startTime=data.startTime
	self.ConsumeTime=staticdata.ConsumeTime
	
	local questType = staticdata.QuestType
	local status=data.status
	-- 计算冒险剩余时间
	self:_ClearTickEff()
	if(PetAdventureProxy.QuestPhase.UNDERWAY==status)then
		self.reachedGap=0
		self.bDirty=true
		self.timeTick = TimeTickManager.Me():CreateTick(0,1000,self._refreshAdventureTime,self)
		if(self.ChooseQuestData.staticData.QuestType==1)then
			self:_refreshSpecQuestReward()
		end
	else
		self:Hide(self.PetStatusTitle)
	end
	if(status==PetAdventureProxy.QuestPhase.MATCH)then
		self.rewardTitle.text=ZhString.PetAdventure_RewardPreview
		self:Hide(self.getRewardBtn)
		self:Show(self.goBtn)
		self.consumeHelpBtn:SetActive(0~=fT)
		-- self:PlayUIEffect(rewardEffResID,self.rewardEffectPos,false,nil,self);	
	elseif(status==PetAdventureProxy.QuestPhase.FINISHED)then
		-- self:_showVictoryEffect() -- 胜利特效
		self.rewardTitle.text=ZhString.PetAdventure_Reward
		self:Show(self.getRewardBtn)
		self:Hide(self.goBtn)
		self:Hide(self.consumeHelpBtn)
	elseif(status==PetAdventureProxy.QuestPhase.UNDERWAY)then
		if(1==questType)then
			self.rewardTitle.text=ZhString.PetAdventure_GetRewardWhenFinshed
		else
			self.rewardTitle.text=ZhString.PetAdventure_Reward
		end
		self:Hide(self.getRewardBtn)
		self:Hide(self.goBtn)
		self:Hide(self.consumeHelpBtn)
	end

	-- 切换模型背景
	local textureName = staticdata.TextureName
	UIMultiModelUtil.Instance:ChangeMat(textureName,self.petTexture)
	self:_refreshPetModel(data.petEggs)
	-- helplog("准备刷新通用方法")
	-- self.petScroll:ResetPosition()
	self:_updateInfoByState()
end

function PetAdventureView:_setAdventureName(id)
	if(nil==id or 0==id)then
		self.adventureNameLab.text = string.format(ZhString.PetAdventure_NewAdventureName,self.ChooseQuestData.staticData.NameZh,"-All")
	else
		local name = Table_Monster[id] and Table_Monster[id].NameZh
		self.adventureNameLab.text = string.format(ZhString.PetAdventure_NewAdventureName,self.ChooseQuestData.staticData.NameZh,name)
	end
	--todo xde
	self.adventureNameLab.transform.localPosition = Vector3(-280,82,0)
	self.adventureNameLab.overflowMethod = 3
	self.adventureNameLab.width = 360
	
	self.PetStatusTitle.transform.localPosition = Vector3(410,82,0)
	self.PetStatusTitle.pivot = UIWidget.Pivot.Right
	self.PetStatusTitle.width = 312
	self.PetStatusTitle.overflowMethod = 3
	self.PetStatusTitle.spacingY = 1
end


function PetAdventureView:_updateDropItem(rewardData)
	local efficiency=0
	local phase = self.ChooseQuestData.status
	local bSpecialQuest = (1==self.ChooseQuestData.staticData.QuestType)
	if(self.ChooseQuestData.multiMonsterReward)then
		efficiency = self:_refreshEfficiency()
	else
		self:Hide(self.curFightEfficiency)
	end
	for k,v in pairs(rewardData) do
		if(self.ChooseQuestData.multiMonsterReward)then
			if(not v.Rare)then
				local n = math.floor(v.rewardCount*efficiency)
				local num = n<1 and 0 or n
				v:SetCount(nil,num)
			end
		end
	end
	if(not bSpecialQuest)then
		table.sort(rewardData,function (l,r)
			local lid = l.staticData.id
			local rid = r.staticData.id
			if(l.Rare or r.Rare)then
				return l.Rare and not r.Rare
			end
			if(lid==Zeny or rid==Zeny)then
				return lid==Zeny and rid~=Zeny
			end
			if(lid==jobBase or rid==jobBase)then
				return lid==jobBase and rid~=jobBase
			end
			if(lid==base or rid==base)then
				return lid==base and rid~=base
			end
			if(l.num==r.num)then
				return lid>rid
			else
				return l.num>r.num
			end
		end)
	end

	if(nil==self.drop)then
		local dropScrollObj = self:FindGO("RewardItemScroll");
		self.dropScroll = dropScrollObj:GetComponent(UIScrollView);
		local dropGrid = self:FindGO("Grid", dropScrollObj):GetComponent(UIGrid);
		self.drop = UIGridListCtrl.new(dropGrid, PetDropItemCell, "PetDropItemCell");
		self.drop:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self);
	end
	self.drop:ResetDatas(rewardData);
	self.dropScroll:ResetPosition();
end

function PetAdventureView:_refreshAdventureTime()
	if((self.startTime+self.ConsumeTime)<=(ServerTime.CurServerTime()/1000))then
		local v = PetAdventureProxy.Instance:HandleFinished()
		self:Hide(self.PetStatusTitle)
		self:InitQuestData()
		self:UpdatePetQuestInfo(v)
		self:_ClearTickEff()
		return
	end
	local deltaTime = math.abs(self.startTime+self.ConsumeTime - ServerTime.CurServerTime()/1000)
	local hour = math.floor(deltaTime/3600)
	local timeStr
	if(hour == 0)then
		timeStr = "00"
	elseif(hour<10)then
		timeStr = "0"..hour
	else
		timeStr = hour
	end
	timeStr = timeStr..":"
	local minute = math.floor((deltaTime - hour*3600)/60)
	if(minute == 0)then
		timeStr = timeStr.."00"
	elseif(minute<10)then
		timeStr = timeStr.."0"..minute
	else
		timeStr = timeStr..minute
	end
	timeStr = timeStr..":"
	local second = math.floor(deltaTime - hour*3600 - minute*60)
	if(second == 0)then
		timeStr = timeStr.."00"
	elseif(second<10)then
		timeStr = timeStr.."0"..second
	else
		timeStr = timeStr..second
	end
	self.PetStatusTitle.text = string.format(ZhString.PetAdventure_OnAdventureTime,timeStr)
	self:Show(self.PetStatusTitle)
	local chooseData = self.ChooseQuestData
	local reachedRewardData = {}
	if(chooseData and chooseData.staticData.QuestType==2)then
		local chooseData = self.ChooseQuestData
		local startTime = chooseData.startTime
		local consumeTime = chooseData.staticData.ConsumeTime 
		local times = chooseData.staticData.Times
		local interval = PetAdventureView.calcInterval(consumeTime,times)
		local steps = consumeTime/interval
		local rewardCount = #chooseData.rewardMap
		interval=consumeTime/(math.min(rewardCount,steps))
		-- helplog("间隔时间：  ",interval)
		-- helplog("阶段数: ",steps,"该任务奖励总数: ",rewardCount)
		local passedTime = ServerTime.CurServerTime()/1000-startTime
		if(passedTime>interval)then
			local reached = math.floor(passedTime/interval)
			if(self.reachedGap ~= reached)then
				self.reachedGap=reached
				self.bDirty=true
				for i=1,self.reachedGap do
					if(chooseData.rewardMap)then
						local cell = chooseData.rewardMap[i]
						cell:SetRare(false)
						cell:SetCount(nil,cell.num)
						table.insert(reachedRewardData,cell)
					end
				end
			end
		end
		if(self.bDirty)then
			self:_updateDropItem(reachedRewardData)
			self.bDirty=false
		end
	end
end

function PetAdventureView:_refreshSpecQuestReward()
	local reachedRewardData = {}
	for i=1,#self.ChooseQuestData.rewardMap do
		local cell=self.ChooseQuestData.rewardMap[i]
		cell:SetRare(false)
		cell:SetCount(nil,cell.num)
		table.insert(reachedRewardData,cell)
	end
	self:_updateDropItem(reachedRewardData)
end

---- consumeTime 耗时 
---- times 频率
function PetAdventureView.calcInterval(consumeTime,times)
	return consumeTime/times*100
end

-- 点击奖励
function PetAdventureView:ClickDropItem(cellctl)
	if(cellctl and cellctl~=self.chooseRewardItem)then
		local data = cellctl.data;
		local stick = cellctl.gameObject:GetComponentInChildren(UISprite);
		if(data)then
			local callback = function ()
				self:CancelChooseReward();
			end
			local sdata = {
				itemdata = data,
				funcConfig = {},
				callback = callback,
				ignoreBounds = {cellctl.gameObject},
			};
			self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0});
		end
		self.chooseRewardItem = cellctl;
	else
		self:CancelChooseReward();
	end
end

function PetAdventureView:CancelChooseReward()
	self.chooseRewardItem = nil
	self:ShowItemTip()
end



-- 宠物模型加载位置
PetAdventureView.petModelTrans = 
{
	[1]={
		position = Vector3(0.14,5.4,4.97),
		rotation = Quaternion.Euler(-8.3,-61,2.86),
		petEmojiRotation = Quaternion.Euler(-3.28,136,3.18),
		},
	[2]={
		position = Vector3(-2.2,5.3,4.6),
		rotation = Quaternion.Euler(-3.8,-25.8,0.4),
		petEmojiRotation=Quaternion.Euler(0,-180,0)
		},
	[3]={
		position = Vector3(-3.7,5.4,3.85),
		rotation = Quaternion.Euler(-4.7,15.6,-7.4),
		petEmojiRotation=Quaternion.Euler(2.91,180,7.06),
		},
		-- 宠物数量上限2个（左）
	[4]={
		position = Vector3(-1.05,5.45,4.68),
		rotation = Quaternion.Euler(-3.3,-44.8,5.9),
		petEmojiRotation = Quaternion.Euler(-1.76,157,2.58),
		},
		-- 宠物数量上限2个（右）
	[5]={
		position = Vector3(-2.8,5.4,4.1),
		rotation = Quaternion.Euler(-7,-4.8,-5.2),
		petEmojiRotation=Quaternion.Euler(0,-180,0)
		},
}	

local args = {}
local action = {}
local matchPetID=0
function PetAdventureView:ShowPetModel(index)
	local matchPet = PetAdventureProxy.Instance:GetMatchPetData()
	if(#matchPet<index or 0==matchPet[index])then
		matchPetID=0
	else
		if(matchPet[index].body and matchPet[index].body~=0)then
			matchPetID=matchPet[index].body
		else
			matchPetID=matchPet[index].petid
		end
	end
	local chooseData = self.ChooseQuestData
	local petNum = chooseData.staticData.PetNum
	local status = chooseData and chooseData.status
	local parts = 0~=matchPetID and Asset_RoleUtility.CreateMonsterRoleParts(matchPetID) or nil
	local randomEmojiDuation = GameConfig.PetRandomEmoji[4]
	local pos,rotation,scale,emoji,emojiRotation
	local modelPosConfig = GameConfig.petModelTrans or PetAdventureView.petModelTrans
	if(parts)then
		if(3==petNum)then
			pos=modelPosConfig[index].position
			rotation=modelPosConfig[index].rotation
			emojiRotation=modelPosConfig[index].petEmojiRotation
		elseif(2==petNum)then
			pos=modelPosConfig[index+3].position
			rotation=modelPosConfig[index+3].rotation
			emojiRotation=modelPosConfig[index+3].petEmojiRotation
		elseif(1==petNum)then
			pos=modelPosConfig[2].position
			rotation=modelPosConfig[2].rotation
			emojiRotation=modelPosConfig[2].petEmojiRotation
		end
		scale=1
		action.name =GameConfig.PetAdventureAction[status]
		action.loop= (status~=PetAdventureProxy.QuestPhase.MATCH)
		emoji=GameConfig.PetRandomEmoji[status]
	end
	args[1]=parts
	args[2]=self.petTexture
	args[3]=pos
	args[4]=rotation
	args[5]=scale
	args[6]=action
	args[7]=emoji
	args[8]=emojiRotation
	args[9]=randomEmojiDuation
	args[10]=true
	UIMultiModelUtil.Instance:SetModels(index,args)
	local bExist = UIMultiModelUtil.Instance:bPetModelExistByIndex(index)
	if(status==PetAdventureProxy.QuestPhase.MATCH)then
		for i=1,petNum do
			self.petChooseBtn[i]:SetActive(true)
		end
		self.petChooseBg[index]:SetActive(not bExist)
	else
		for i=1,#self.petChooseBtn do
			self.petChooseBtn[i]:SetActive(false)
		end
	end
end

function PetAdventureView:OnEnter()
	self.super.OnEnter(self)
	ServiceNUserProxy.Instance:CallBattleTimelenUserCmd()
	ServiceScenePetProxy.Instance:CallQueryPetAdventureListPetCmd()
	ServiceScenePetProxy.Instance:CallQueryBattlePetCmd()
end

function PetAdventureView:_ClearTickEff()
	if(self.timeTick)then
		self.timeTick=nil
		TimeTickManager.Me():ClearTick(self)
	end
	if(self.rewardEff)then
		self.rewardEff:Destroy();
		self.rewardEff = nil;
	end
end

function PetAdventureView:OnExit()
	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PET_ADVENTURE)
	self:_ClearTickEff()
	PictureManager.Instance:UnloadPetTexture()
	TipManager.Instance:HidePetEffTip()
	self.super.OnExit(self);
end



