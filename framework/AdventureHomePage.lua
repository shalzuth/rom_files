AdventureHomePage = class("AdventureHomePage",SubView)
autoImport("AdventureProfessionCell")
autoImport("AdventureCollectionAchShowCell")
autoImport("AdventureAchievementCell")
autoImport("AdventureRewardPanel")
autoImport("AdventureFriendCell")
autoImport("Charactor")
autoImport("ProfessionSkillCell")
autoImport("AdventureAttrCell")

local tempArray = {}
local tempVector3 = LuaVector3.zero
AdventureHomePage.ProfessionIconClick = "ProfessionPage_ProfessionIconClick"
function AdventureHomePage:Init()
	self:initView()	
	self:addViewEventListener()
	self:AddListenerEvts()	
	self:initData()
end

function AdventureHomePage:initView(  )
	-- -- body
	self.gameObject = self:FindGO("AdventureHomePage")
	self.playerName = self:FindGO("UserName"):GetComponent(UILabel)

	self.manualPoint = self:FindComponent("manualPoint",UILabel)
	-- local professionsTable = self:FindGO("professionsTable"):GetComponent(UIGrid)
	-- self.professionsTable = UIGridListCtrl.new(professionsTable,AdventureProfessionCell,"AdventureProfessionCell")

	

	-- local achievementShowGird = self:FindGO("achievementShowGird"):GetComponent(UIGrid)
	-- self.achievementShowGird = UIGridListCtrl.new(achievementShowGird,AdventureAchievementCell,"AdventureAchievementCell")
	
	-- self.achievementCtTotalNum = self:FindGO("totalNum",self:FindGO("achievementCt")):GetComponent(UILabel)
	self.achievementScoreSlider = self:FindGO("progressCt",self:FindGO("achievementCt")):GetComponent(UISlider)
	self.achievementCurScore = self:FindGO("curScore",self:FindGO("achievementCt")):GetComponent(UILabel)

	-- self.achievemIcon = self:FindGO("rewardIcon",self:FindGO("RewardCt")):GetComponent(UISprite)
	self.manualLevel = self:FindGO("manualLevel"):GetComponent(UILabel)
	-- self.appellationLevel = self:FindGO("appellationLevel"):GetComponent(UILabel)
	
	local rewardLabel = self:FindGO("rewardLabel"):GetComponent(UILabel)
	self.levelGrid = self:FindGO("levelGrid"):GetComponent(UIGrid)
	rewardLabel.text = ZhString.AdventureRewardPanel_RewardLabel

	self.friendScrollview = self:FindGO("friendRankCt")
	self.friendScrollview = self:FindComponent("content",UIScrollView,self.friendScrollview)
	
	self.myRank = self:FindComponent("myRank",UILabel)

	self.loading = self:FindGO("Loading")

	local ContentContainer = self:FindGO("ContentContainer")
	-- local friendsGrid = self:FindGO("friendsGrid"):GetComponent(UIGrid)
	-- self.friendsGrid = UIGridListCtrl.new(friendsGrid,,"AdventureFriendCell")
	local wrapConfig = {
		wrapObj = ContentContainer,
		pfbNum = 7, 
		cellName = "AdventureFriendCell", 
		control = AdventureFriendCell, 
		dir = 1,
		disableDragIfFit = true,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)


	-- self.collectionScrollview = self:FindGO("collectionShow")
	-- self.collectionScrollview = self:FindGO("content",self.collectionScrollview):GetComponent(UIScrollView)
	
	-- local collectionShowGrid = self:FindGO("collectionShowGrid"):GetComponent(UIGrid)
	-- self.collectionShowGrid = UIGridListCtrl.new(collectionShowGrid,AdventureCollectionAchShowCell,"AdventureCollectionAchShowCell")
	self.descriptionText = self:FindGO("DescriptionText"):GetComponent(UILabel)
	self.secondContent = self:FindGO("secondContent")
	local secondContentTitle = self:FindComponent("secondContentTitle",UILabel)
	secondContentTitle.text = ZhString.AdventureHomePage_SecondContentTitle
	local collectionShowGrid = self:FindComponent("adventureProgressGrid",UIGrid)
	self.collectionShowGrid = UIGridListCtrl.new(collectionShowGrid,AdventureCollectionAchShowCell,"AdventureCollectionAchShowCell")	

	self.thirdContent = self:FindGO("thirdContent")
	self.thirdContentTitle = self:FindComponent("thirdContentTitle",UILabel)
	-- self.recentFoodList = self:FindComponent("recentFoodList",UIGrid)
	-- self.recentFoodList = UIGridListCtrl.new(self.recentFoodList,ItemCell,"RecentFoodItemCell")

	self.fourthContent = self:FindGO("fourthContent")
	self.fourthContentTitle = self:FindComponent("fourthContentTitle",UILabel)
	local unlockAdventureSkillTitle = self:FindComponent("unlockAdventureSkillTitle",UILabel)
	unlockAdventureSkillTitle.text = ZhString.AdventureHomePage_UnlockSkillitle
	self.fourthSrl = self:FindComponent("ScrollView",UIScrollView,self.fourthContent)
	local nextSkills = self:FindComponent("unlockAdventureSkillGrid",UIGrid)
	-- self.nextSkillsGrid = UIGridListCtrl.new(nextSkills,AdventureSkillCell,"AdventureSkillCell")
	self.nextSkillsGrid = UIGridListCtrl.new(nextSkills,ProfessionSkillCell,"ProfessionSkillCell")
	self.nextSkillsGrid:AddEventListener(MouseEvent.MouseClick,self.cellClick,self)

	self.propBord = self:FindGO("PropBord")
	local proptyBtn = self:FindGO("proptyBtn")
	local lable = self:FindComponent("Label",UILabel,proptyBtn)
	lable.text = ZhString.AdventureHomePage_PropBordBtn
	self:AddClickEvent(proptyBtn,function (  )
		-- body
		self:showPropView()
	end)

	self:AddButtonEvent("PropBordClose",function (  )
		-- body
		self:Hide(self.propBord )
	end)

	self:AddButtonEvent("PropBordHelp",function (  )
		-- body
		helplog("help button click")
		local data=Table_Help[100001]
		if(data)then
			TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
		else
			-- errorLog("can not find Table_Help content,id is "..self.viewdata.view.id)
		end
	end)

	lable = self:FindComponent("PropBordTitle",UILabel)
	lable.text = ZhString.AdventureHomePage_PropBordTitleDes

	lable = self:FindComponent("emptyDes",UILabel)
	lable.text = ZhString.AdventureHomePage_EmptyPropDes
	self.emptyCt = self:FindGO("emptyCt")
	
	self.appellationPropCt = self:FindGO("AppellationPropCt")
	self.applationTitle = self:FindComponent("title",UILabel,self.appellationPropCt)
	local grid = self:FindComponent("Grid",UIGrid,self.appellationPropCt)
	self.appellationGrid = UIGridListCtrl.new(grid,AdventureAttrCell,"AdventureAttrCell")

	self.adventurePropCt = self:FindGO("AdventurePropCt")
	local title = self:FindComponent("title",UILabel,self.adventurePropCt)
	title.text = ZhString.AdventureHomePage_PropBordPropTitleDes
	grid = self:FindComponent("Grid",UIGrid,self.adventurePropCt)
	self.adventurePropGrid = UIGridListCtrl.new(grid,AdventureAttrCell,"AdventureAttrCell")
end

function AdventureHomePage:cellClick( obj )
	-- body
	-- local data = obj.data
	-- print("cellClick")
	local skillId = obj.data
	-- printRed(skillId)
	local skillItem = SkillItemData.new(skillId)
	local tipData = {}
	tipData.data = skillItem
	TipsView.Me():ShowTip(SkillTip,tipData,"SkillTip")
	local tip = TipsView.Me().currentTip
	if(tip)then
		tempVector3:Set(200,0,0)
		tip.gameObject.transform.localPosition = tempVector3
	end
end

function AdventureHomePage:Show( target )
	-- body
	AdventureHomePage.super.Show(self,target)
	-- self.collectionScrollview:ResetPosition();
	self:setCurrentAchIcon()
	self:setCollectionAchievement()
	self:setAdventureLevel()
	self:setAppellationLevel()
end
local tempVector3 = LuaVector3.zero

function AdventureHomePage:initData(  )
	-- body
	-- self.guidText = nil
	-- self.textLen = 0
	-- self.starIndex = 0
	-- self:updateAdvanceCodition()
	self.playerName.text = Game.Myself.data:GetName()
	self.manualScore = nil
	-- self.professionsTable:ResetDatas(Game.Myself.occupations)
end

function AdventureHomePage:SetData(  )
	-- body
	self:setCurrentAchIcon()
	self:setCollectionAchievement()
	self:setAdventureLevel()
	self:setAppellationLevel()
	self:setAchievementShow()
	self:setAchievementScore()
	self:showScoreUpdateAnim()
	-- self.fourthSrl:ResetPosition()
end

function AdventureHomePage:showNextSkillInfo(  )
	local skills = self:unlockAdventureSkills()
	-- printRed(skills)
	if(skills and #skills>0)then
		TableUtility.ArrayClear(tempArray)
		for i=1,#skills do
			local data = {}
			data[1] = MyselfProxy.Instance:GetMyProfession()
			data[2] = skills[i]
			tempArray[#tempArray+1] = data
		end
		self.nextSkillsGrid:ResetDatas(tempArray)
		-- self.scView:ResetPosition();
	else
		-- self:Hide(self.nextSkillGridCt)		
	end
end

function AdventureHomePage:unlockAdventureSkills()
	local achData = MyselfProxy.Instance:GetCurManualAppellation()
	if(achData)then	 
		local skills = AdventureDataProxy.Instance:getAdventureSkillByAppellation( achData.staticData.PostID)		
		return skills
	end
end

function AdventureHomePage:showScoreUpdateAnim(  )
	-- body
	self:setAchievementScore()
	local curScore = AdventureDataProxy.Instance:getPointData( )
	if(self.manualScore and curScore ~= self.manualScore)then
		local score = curScore - self.manualScore
		if(score<0)then
			local manualLevel = AdventureDataProxy.Instance:getManualLevel()
			if(Table_AdventureLevel[manualLevel-1])then
				score = curScore + Table_AdventureLevel[manualLevel-1].AdventureExp - self.manualScore
			end
		end
		MsgManager.ShowMsgByIDTable(44, {score});
	end
	self.manualScore = curScore
end

function AdventureHomePage:setCurrentAchIcon()
	-- body
	local achData = MyselfProxy.Instance:GetCurManualAppellation( )
	if(achData)then
		local manualLevel = AdventureDataProxy.Instance:getManualLevel()
		local itemData = Table_Item[achData.id]
		if(itemData)then
			-- TODO
			-- self.appellationLevel.text = itemData.NameZh
			self.descriptionText.text = string.format(ZhString.AdventureHomePage_AppellationDes,itemData.NameZh)
			self.manualLevel.text = string.format(ZhString.AdventureHomePage_manualLevel,manualLevel)
			-- IconManager:SetItemIcon(itemData.Icon,self.achievemIcon)
		else
			errorLog("AdventureHomePage:setCurrentAchIcon can't find ItemData by id:",achData.id)
		end
	else
		errorLog("AdventureHomePage:appellation is nil")
	end
end

function AdventureHomePage:setAchievementShow(  )
	-- body
	-- local achBag = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_ACHIEVE]
	-- local alreadHas = achBag:GetItems()
	-- local list = {}
	-- for i=1,#alreadHas do
	-- 	local single = alreadHas[i]
	-- 	local groupId = single.staticData.GroupID
	-- 	local group = list[groupId]
	-- 	if(group)then
	-- 		if(group.staticData.id < single.staticData.id)then
	-- 			list[groupId] = single
	-- 		end
	-- 	else
	-- 		list[groupId] = single
	-- 	end
	-- end
	-- local tempList = {}
	-- for k,v in pairs(list) do
	-- 	table.insert(tempList,v)
	-- end

	-- table.sort(tempList,function ( l,r )
	-- 	-- body
	-- 	return l.staticData.id < r.staticData.id
	-- end)

	-- self.achievementShowGird:ResetDatas(tempList)
end

function AdventureHomePage:setCollectionAchievement(  )
	-- body
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.descriptionText.transform)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.descriptionText.transform)
	y = y - height - 20

	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
	tempVector3:Set(x1,y,z1)
	self.secondContent.transform.localPosition = tempVector3

	local bagMap = AdventureDataProxy.Instance.bagMap
	local score = 0
	local list = {}
	for k,v in pairs(bagMap) do
		if(v.tableData.Position == 1 or v.tableData.Position == 3)then
			table.insert(list,v)
		end
	end

	table.sort(list,function ( l,r )
		-- body
		local lTable = Table_ItemTypeAdventureLog[l.type]
		local rTable = Table_ItemTypeAdventureLog[r.type]
		return lTable.Order < rTable.Order
	end)
	self.collectionShowGrid:ResetDatas(list)
	-- self.collectionScrollview:ResetPosition()
end

function AdventureHomePage:OnEnter(  )
	-- body
	-- self:SetData()	
	self:setAchievementShow()
	self:setAchievementScore()
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
	-- self:Log("AdventureHomePage OnEnter")
	self:setFriendAdData(true)
	self:UpdateHead()
	self:initScoreData()
end

function AdventureHomePage:initScoreData(  )
	local curScore = AdventureDataProxy.Instance:getPointData( )
	self.manualScore = curScore
end

function AdventureHomePage:OnExit(  )
	-- body
	-- if(self.headCellObj)then
	-- 	Game.GOLuaPoolManager:AddToUIPool(Charactor.PlayerHeadCellResId, self.headCellObj);
	-- end
	-- self:Log("AdventureHomePage OnExit")
	self.manualScore = nil
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
end

function AdventureHomePage:setAdventureLevel(  )
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.secondContent.transform)

	local manualLevel = AdventureDataProxy.Instance:getManualLevel()
	local nextLevel = AdventureDataProxy.Instance:getNextAdventureLevelProp(manualLevel)
	y = y - height - 20
	if(nextLevel ~= "")then
		self.thirdContentTitle.text = string.format(ZhString.AdventureHomePage_ThirdContentTitle,manualLevel,manualLevel+1,nextLevel)
	else
		self.thirdContentTitle.text = string.format(ZhString.AdventureHomePage_ThirdContentTitle,manualLevel,manualLevel+1,"Max")
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
	tempVector3:Set(x1,y,z1)	
	self.thirdContent.transform.localPosition = tempVector3
end

function AdventureHomePage:setAppellationLevel(  )
	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.thirdContent.transform)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
	y = y - height - 20

	local sRet = AdventureDataProxy.Instance:getNextAppellationProp()
	local achData = MyselfProxy.Instance:GetCurManualAppellation( )
	if(sRet ~="")then
		local needLv = GameConfig.AdventureAppellationLevel and GameConfig.AdventureAppellationLevel[achData.staticData.PostID]
		self.fourthContentTitle.text = string.format(ZhString.AdventureHomePage_FourThContentTitle,needLv, sRet)
	end
	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.fourthContent.transform)
	tempVector3:Set(x1,y,z1)
	self.fourthContent.transform.localPosition = tempVector3

	bd = NGUIMath.CalculateRelativeWidgetBounds(self.fourthContentTitle.transform)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.fourthContentTitle.transform)
	y = y - height - 95

	local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.fourthSrl.transform)
	tempVector3:Set(x1,y,z1)
	self.fourthSrl.transform.localPosition = tempVector3
	-- 升至下一称号（需要冒险等级达到%s）\n%s",
	self:showNextSkillInfo()
end

function AdventureHomePage:setAchievementScore(  )
	-- body
	local bagMap = AdventureDataProxy.Instance.bagMap
	local score = 0
	-- for k,v in pairs(bagMap) do
	-- 	score = score + v.totalScore
	-- end
	local achData = AdventureDataProxy.Instance:getNextAchievement()
	local value = 0
	score = AdventureDataProxy.Instance:getPointData()

	local nextScore = score
	local curAch = AdventureDataProxy.Instance:getCurAchievement( )
	-- if(achData)then
	-- 	nextScore = achData.AdventureExp
	-- else
		nextScore = curAch.AdventureExp	
	-- end
	local manualLevel = AdventureDataProxy.Instance:getManualLevel()
	manualLevel = StringUtil.StringToCharArray(tostring(manualLevel))
	GameObjectUtil.Instance:DestroyAllChildren(self.levelGrid.gameObject)
	for i=1,#manualLevel do
		local obj = GameObject("tx")
		obj.transform:SetParent(self.levelGrid.transform,false)
		obj.layer = self.levelGrid.gameObject.layer
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		local sprite = obj:AddComponent(UISprite)
		sprite.depth = 100
		local atlas = RO.AtlasMap.GetAtlas("NewCom")
		sprite.atlas = atlas
		sprite.spriteName = string.format("txt_%d",manualLevel[i])
		sprite:MakePixelPerfect()
	end
	self.levelGrid:Reposition()
	-- if(manualLevel>1)then
	-- 	-- nextScore = nextScore - curAch.AdventureExp
	-- 	score = score - curAch.AdventureExp
	-- end
	self.achievementCurScore.text = score.."/"..nextScore
	self.achievementScoreSlider.value = score/nextScore
	local skillPoint = AdventureDataProxy.Instance:getSkillPoint()
	self.manualPoint.text = string.format(ZhString.AdventureHomePage_manualPoint,skillPoint)
	-- self.achievementCtTotalNum.text = score
end

function AdventureHomePage:addViewEventListener()
	--TODO
	-- self:AddButtonEvent("appellationLevelCt",function (  )
	-- 	-- body
	-- 	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AdventureRewardPanel,viewdata = {from = AdventureRewardPanel.FromConfig.AdventurePanel}})
	-- end)
end

function AdventureHomePage:AddListenerEvts()
	self:AddListenEvt(AdventureDataEvent.SceneManualQueryManualData,self.QueryManualHandler)
	self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate,self.SetData)
	-- self:AddListenEvt(ServiceEvent.SceneFoodNewFoodDataNtf,self.showScoreUpdateAnim)
	self:AddListenEvt(ServiceEvent.SceneManualPointSync,self.showScoreUpdateAnim)
	self:AddListenEvt(SceneUserEvent.LevelUp,self.LevelUp)
	self:AddListenEvt(ServiceEvent.UserEventNewTitle,self.setCurrentAchIcon)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate,self.setFriendAdData)
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate,self.setFriendAdData)
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData,self.setFriendAdData)
	
	self:AddListenEvt(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd,self.setCollectionAchievement);
	self:AddListenEvt(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd,self.setCollectionAchievement);
	self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate,self.showNextSkillInfo)
end

function AdventureHomePage:QueryManualHandler( note )
	-- body
	self:setFriendAdData(false)
	self:SetData()
end

function AdventureHomePage:LevelUp( note )
	-- body
	if(note.type == SceneUserEvent.ManualLevelUp)then
		FloatingPanel.Instance:ShowManualUp()
	end
end

function AdventureHomePage:UpdateHead(  )
	-- body
	if(not self.targetCell)then
		local headCellObj = self:FindGO("PortraitCell")		
		self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId,headCellObj)
		tempVector3:Set(0,0,0)
		self.headCellObj.transform.localPosition = tempVector3
		self.targetCell = PlayerFaceCell.new(self.headCellObj)
		-- self.targetCell:Hide(self.targetCell.hp.gameObject)
		-- self.targetCell:Hide(self.targetCell.mp.gameObject)
		self.targetCell:HideLevel()
		self.targetCell:HideHpMp()
	end
	local headData = HeadImageData.new();
	headData:TransByLPlayer(Game.Myself);
	-- 临时处理
	headData.frame = nil;
	headData.job = nil;
	self.targetCell:SetData(headData);
end

function AdventureHomePage:setFriendAdData( resetPos )
	local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
	local friends = {unpack(FriendProxy.Instance:GetFriendData())}
	if isQuerySocialData then
		local data = {}
		data.myself = true
		-- data.portrait = Game.Myself.data.userdata:Get(UDEnum.PORTRAIT)
		data.adventureLv = AdventureDataProxy.Instance:getManualLevel()
		data.adventureExp = AdventureDataProxy.Instance:getPointData()
		data.guid = Game.Myself.data.id
		-- printRed(data.guid)
		-- data.profession = Game.Myself.data:GetCurOcc().profession
		data.appellation = ""
		data.name = Game.Myself.data:GetName()
		local achData = MyselfProxy.Instance:GetCurManualAppellation( )
		if(achData)then
			data.appellation = achData.id
		end
		table.insert(friends,data)
		table.sort(friends,function ( l,r )
			-- body
			if(l.adventureLv == r.adventureLv)then
				if(l.adventureExp == r.adventureExp)then
					return l.guid > r.guid
				else
					return l.adventureExp > r.adventureExp
				end
			else
				return l.adventureLv > r.adventureLv
			end
		end)

		for i=1,#friends do
			local single = friends[i]
			single.rank = i
			if(single.myself)then
				self.myRank.text = string.format(ZhString.AdventureHomePage_MyRank,i)
			end
		end
		self.itemWrapHelper:UpdateInfo(friends)
		-- self.friendsGrid:ResetDatas(friends)
		if(resetPos)then
			self.friendScrollview:ResetPosition()
			self.itemWrapHelper:ResetPosition()
		end
	end
	self.loading:SetActive(not isQuerySocialData)
end

function AdventureHomePage:showPropView(  )
	self.propBord:SetActive(not self.propBord.activeSelf);
	if(self.propBord.activeSelf)then
		local approps = AdventureDataProxy.Instance:GetAppellationProp()
		local x,y,z = LuaGameObject.GetLocalPosition(self.appellationPropCt.transform)
		local apSize = #approps
		if(apSize == 0)then
			self:Hide(self.appellationPropCt)
		else
			local appData =  MyselfProxy.Instance:GetCurManualAppellation()
			self.applationTitle.text = string.format(ZhString.AdventureHomePage_PropBordAppllationTitleDes,appData.staticData.Name)
			self.appellationGrid:ResetDatas(approps)
			self:Show(self.appellationPropCt)
			local bd = NGUIMath.CalculateRelativeWidgetBounds(self.appellationPropCt.transform)
			local height = bd.size.y
			y = y - height - 20
		end		

		local x1,y1,z1 = LuaGameObject.GetLocalPosition(self.adventurePropCt.transform)
		tempVector3:Set(x1,y,z1)
		self.adventurePropCt.transform.localPosition = tempVector3

		local props = AdventureDataProxy.Instance:GetAllAdventureProp()
		local propSize = #props
		if(propSize == 0)then
			self:Hide(self.adventurePropCt)
		else
			self.adventurePropGrid:ResetDatas(props)
			self:Show(self.adventurePropCt)
		end
		if(propSize == 0 and apSize == 0)then
			self:Show(self.emptyCt)
		else
			self:Hide(self.emptyCt)
		end
	end
end