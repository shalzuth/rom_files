AdventureHomePage = class("AdventureHomePage", SubView)
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
function AdventureHomePage:initView()
  self.gameObject = self:FindGO("AdventureHomePage")
  self.playerName = self:FindGO("UserName"):GetComponent(UILabel)
  self.manualPoint = self:FindComponent("manualPoint", UILabel)
  self.achievementScoreSlider = self:FindGO("progressCt", self:FindGO("achievementCt")):GetComponent(UISlider)
  self.achievementCurScore = self:FindGO("curScore", self:FindGO("achievementCt")):GetComponent(UILabel)
  self.manualLevel = self:FindGO("manualLevel"):GetComponent(UILabel)
  local rewardLabel = self:FindGO("rewardLabel"):GetComponent(UILabel)
  self.levelGrid = self:FindGO("levelGrid"):GetComponent(UIGrid)
  rewardLabel.text = ZhString.AdventureRewardPanel_RewardLabel
  self.friendScrollview = self:FindGO("friendRankCt")
  self.friendScrollview = self:FindComponent("content", UIScrollView, self.friendScrollview)
  self.myRank = self:FindComponent("myRank", UILabel)
  self.loading = self:FindGO("Loading")
  local ContentContainer = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = ContentContainer,
    pfbNum = 7,
    cellName = "AdventureFriendCell",
    control = AdventureFriendCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.descriptionText = self:FindGO("DescriptionText"):GetComponent(UILabel)
  self.secondContent = self:FindGO("secondContent")
  local secondContentTitle = self:FindComponent("secondContentTitle", UILabel)
  secondContentTitle.text = ZhString.AdventureHomePage_SecondContentTitle
  local collectionShowGrid = self:FindComponent("adventureProgressGrid", UIGrid)
  self.collectionShowGrid = UIGridListCtrl.new(collectionShowGrid, AdventureCollectionAchShowCell, "AdventureCollectionAchShowCell")
  self.thirdContent = self:FindGO("thirdContent")
  self.thirdContentTitle = self:FindComponent("thirdContentTitle", UILabel)
  self.fourthContent = self:FindGO("fourthContent")
  self.fourthContentTitle = self:FindComponent("fourthContentTitle", UILabel)
  local unlockAdventureSkillTitle = self:FindComponent("unlockAdventureSkillTitle", UILabel)
  unlockAdventureSkillTitle.text = ZhString.AdventureHomePage_UnlockSkillitle
  self.fourthSrl = self:FindComponent("ScrollView", UIScrollView, self.fourthContent)
  local nextSkills = self:FindComponent("unlockAdventureSkillGrid", UIGrid)
  self.nextSkillsGrid = UIGridListCtrl.new(nextSkills, ProfessionSkillCell, "ProfessionSkillCell")
  self.nextSkillsGrid:AddEventListener(MouseEvent.MouseClick, self.cellClick, self)
  self.propBord = self:FindGO("PropBord")
  local proptyBtn = self:FindGO("proptyBtn")
  local lable = self:FindComponent("Label", UILabel, proptyBtn)
  lable.text = ZhString.AdventureHomePage_PropBordBtn
  self:AddClickEvent(proptyBtn, function()
    self:showPropView()
  end)
  self:AddButtonEvent("PropBordClose", function()
    self:Hide(self.propBord)
  end)
  self:AddButtonEvent("PropBordHelp", function()
    helplog("help button click")
    local data = Table_Help[100001]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
    else
    end
  end)
  lable = self:FindComponent("PropBordTitle", UILabel)
  lable.text = ZhString.AdventureHomePage_PropBordTitleDes
  lable = self:FindComponent("emptyDes", UILabel)
  lable.text = ZhString.AdventureHomePage_EmptyPropDes
  self.emptyCt = self:FindGO("emptyCt")
  self.appellationPropCt = self:FindGO("AppellationPropCt")
  self.applationTitle = self:FindComponent("title", UILabel, self.appellationPropCt)
  local grid = self:FindComponent("Grid", UIGrid, self.appellationPropCt)
  self.appellationGrid = UIGridListCtrl.new(grid, AdventureAttrCell, "AdventureAttrCell")
  self.adventurePropCt = self:FindGO("AdventurePropCt")
  local title = self:FindComponent("title", UILabel, self.adventurePropCt)
  title.text = ZhString.AdventureHomePage_PropBordPropTitleDes
  grid = self:FindComponent("Grid", UIGrid, self.adventurePropCt)
  self.adventurePropGrid = UIGridListCtrl.new(grid, AdventureAttrCell, "AdventureAttrCell")
end
function AdventureHomePage:cellClick(obj)
  local skillId = obj.data
  local skillItem = SkillItemData.new(skillId)
  local tipData = {}
  tipData.data = skillItem
  TipsView.Me():ShowTip(SkillTip, tipData, "SkillTip")
  local tip = TipsView.Me().currentTip
  if tip then
    tempVector3:Set(200, 0, 0)
    tip.gameObject.transform.localPosition = tempVector3
  end
end
function AdventureHomePage:Show(target)
  AdventureHomePage.super.Show(self, target)
  self:setCurrentAchIcon()
  self:setCollectionAchievement()
  self:setAdventureLevel()
  self:setAppellationLevel()
end
local tempVector3 = LuaVector3.zero
function AdventureHomePage:initData()
  self.playerName.text = Game.Myself.data:GetName()
  self.manualScore = nil
end
function AdventureHomePage:SetData()
  self:setCurrentAchIcon()
  self:setCollectionAchievement()
  self:setAdventureLevel()
  self:setAppellationLevel()
  self:setAchievementShow()
  self:setAchievementScore()
  self:showScoreUpdateAnim()
end
function AdventureHomePage:showNextSkillInfo()
  local skills = self:unlockAdventureSkills()
  if skills and #skills > 0 then
    TableUtility.ArrayClear(tempArray)
    for i = 1, #skills do
      local data = {}
      data[1] = MyselfProxy.Instance:GetMyProfession()
      data[2] = skills[i]
      tempArray[#tempArray + 1] = data
    end
    self.nextSkillsGrid:ResetDatas(tempArray)
  else
  end
end
function AdventureHomePage:unlockAdventureSkills()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local skills = AdventureDataProxy.Instance:getAdventureSkillByAppellation(achData.staticData.PostID)
    return skills
  end
end
function AdventureHomePage:showScoreUpdateAnim()
  self:setAchievementScore()
  local curScore = AdventureDataProxy.Instance:getPointData()
  if self.manualScore and curScore ~= self.manualScore then
    local score = curScore - self.manualScore
    if score < 0 then
      local manualLevel = AdventureDataProxy.Instance:getManualLevel()
      if Table_AdventureLevel[manualLevel - 1] then
        score = curScore + Table_AdventureLevel[manualLevel - 1].AdventureExp - self.manualScore
      end
    end
    MsgManager.ShowMsgByIDTable(44, {score})
  end
  self.manualScore = curScore
end
function AdventureHomePage:setCurrentAchIcon()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local manualLevel = AdventureDataProxy.Instance:getManualLevel()
    local itemData = Table_Item[achData.id]
    if itemData then
      self.descriptionText.text = string.format(ZhString.AdventureHomePage_AppellationDes, itemData.NameZh)
      self.manualLevel.text = string.format(ZhString.AdventureHomePage_manualLevel, manualLevel)
    else
      errorLog("AdventureHomePage:setCurrentAchIcon can't find ItemData by id:", achData.id)
    end
  else
    errorLog("AdventureHomePage:appellation is nil")
  end
end
function AdventureHomePage:setAchievementShow()
end
function AdventureHomePage:setCollectionAchievement()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.descriptionText.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.descriptionText.transform)
  y = y - height - 20
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  tempVector3:Set(x1, y, z1)
  self.secondContent.transform.localPosition = tempVector3
  local bagMap = AdventureDataProxy.Instance.bagMap
  local score = 0
  local list = {}
  for k, v in pairs(bagMap) do
    if v.tableData.Position == 1 or v.tableData.Position == 3 then
      table.insert(list, v)
    end
  end
  table.sort(list, function(l, r)
    local lTable = Table_ItemTypeAdventureLog[l.type]
    local rTable = Table_ItemTypeAdventureLog[r.type]
    return lTable.Order < rTable.Order
  end)
  self.collectionShowGrid:ResetDatas(list)
end
function AdventureHomePage:OnEnter()
  self:setAchievementShow()
  self:setAchievementScore()
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
  self:setFriendAdData(true)
  self:UpdateHead()
  self:initScoreData()
end
function AdventureHomePage:initScoreData()
  local curScore = AdventureDataProxy.Instance:getPointData()
  self.manualScore = curScore
end
function AdventureHomePage:OnExit()
  self.manualScore = nil
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
end
function AdventureHomePage:setAdventureLevel()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  local manualLevel = AdventureDataProxy.Instance:getManualLevel()
  local nextLevel = AdventureDataProxy.Instance:getNextAdventureLevelProp(manualLevel)
  y = y - height - 20
  if nextLevel ~= "" then
    self.thirdContentTitle.text = string.format(ZhString.AdventureHomePage_ThirdContentTitle, manualLevel, manualLevel + 1, nextLevel)
  else
    self.thirdContentTitle.text = string.format(ZhString.AdventureHomePage_ThirdContentTitle, manualLevel, manualLevel + 1, "Max")
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
  tempVector3:Set(x1, y, z1)
  self.thirdContent.transform.localPosition = tempVector3
end
function AdventureHomePage:setAppellationLevel()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.thirdContent.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
  y = y - height - 20
  local sRet = AdventureDataProxy.Instance:getNextAppellationProp()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if sRet ~= "" then
    local needLv = GameConfig.AdventureAppellationLevel and GameConfig.AdventureAppellationLevel[achData.staticData.PostID]
    self.fourthContentTitle.text = string.format(ZhString.AdventureHomePage_FourThContentTitle, needLv, sRet)
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.fourthContent.transform)
  tempVector3:Set(x1, y, z1)
  self.fourthContent.transform.localPosition = tempVector3
  bd = NGUIMath.CalculateRelativeWidgetBounds(self.fourthContentTitle.transform)
  local height = bd.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.fourthContentTitle.transform)
  y = y - height - 95
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.fourthSrl.transform)
  tempVector3:Set(x1, y, z1)
  self.fourthSrl.transform.localPosition = tempVector3
  self:showNextSkillInfo()
end
function AdventureHomePage:setAchievementScore()
  local bagMap = AdventureDataProxy.Instance.bagMap
  local score = 0
  local achData = AdventureDataProxy.Instance:getNextAchievement()
  local value = 0
  score = AdventureDataProxy.Instance:getPointData()
  local nextScore = score
  local curAch = AdventureDataProxy.Instance:getCurAchievement()
  nextScore = curAch.AdventureExp
  local manualLevel = AdventureDataProxy.Instance:getManualLevel()
  manualLevel = StringUtil.StringToCharArray(tostring(manualLevel))
  GameObjectUtil.Instance:DestroyAllChildren(self.levelGrid.gameObject)
  for i = 1, #manualLevel do
    local obj = GameObject("tx")
    obj.transform:SetParent(self.levelGrid.transform, false)
    obj.layer = self.levelGrid.gameObject.layer
    tempVector3:Set(0, 0, 0)
    obj.transform.localPosition = tempVector3
    local sprite = obj:AddComponent(UISprite)
    sprite.depth = 100
    local atlas = RO.AtlasMap.GetAtlas("NewCom")
    sprite.atlas = atlas
    sprite.spriteName = string.format("txt_%d", manualLevel[i])
    sprite:MakePixelPerfect()
  end
  self.levelGrid:Reposition()
  self.achievementCurScore.text = score .. "/" .. nextScore
  self.achievementScoreSlider.value = score / nextScore
  local skillPoint = AdventureDataProxy.Instance:getSkillPoint()
  self.manualPoint.text = string.format(ZhString.AdventureHomePage_manualPoint, skillPoint)
end
function AdventureHomePage:addViewEventListener()
end
function AdventureHomePage:AddListenerEvts()
  self:AddListenEvt(AdventureDataEvent.SceneManualQueryManualData, self.QueryManualHandler)
  self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate, self.SetData)
  self:AddListenEvt(ServiceEvent.SceneManualPointSync, self.showScoreUpdateAnim)
  self:AddListenEvt(SceneUserEvent.LevelUp, self.LevelUp)
  self:AddListenEvt(ServiceEvent.UserEventNewTitle, self.setCurrentAchIcon)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd, self.setCollectionAchievement)
  self:AddListenEvt(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, self.setCollectionAchievement)
  self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate, self.showNextSkillInfo)
end
function AdventureHomePage:QueryManualHandler(note)
  self:setFriendAdData(false)
  self:SetData()
end
function AdventureHomePage:LevelUp(note)
  if note.type == SceneUserEvent.ManualLevelUp then
    FloatingPanel.Instance:ShowManualUp()
  end
end
function AdventureHomePage:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    tempVector3:Set(0, 0, 0)
    self.headCellObj.transform.localPosition = tempVector3
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end
function AdventureHomePage:setFriendAdData(resetPos)
  local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
  local friends = {
    unpack(FriendProxy.Instance:GetFriendData())
  }
  if isQuerySocialData then
    local data = {}
    data.myself = true
    data.adventureLv = AdventureDataProxy.Instance:getManualLevel()
    data.adventureExp = AdventureDataProxy.Instance:getPointData()
    data.guid = Game.Myself.data.id
    data.appellation = ""
    data.name = Game.Myself.data:GetName()
    local achData = MyselfProxy.Instance:GetCurManualAppellation()
    if achData then
      data.appellation = achData.id
    end
    table.insert(friends, data)
    table.sort(friends, function(l, r)
      if l.adventureLv == r.adventureLv then
        if l.adventureExp == r.adventureExp then
          return l.guid > r.guid
        else
          return l.adventureExp > r.adventureExp
        end
      else
        return l.adventureLv > r.adventureLv
      end
    end)
    for i = 1, #friends do
      local single = friends[i]
      single.rank = i
      if single.myself then
        self.myRank.text = string.format(ZhString.AdventureHomePage_MyRank, i)
      end
    end
    self.itemWrapHelper:UpdateInfo(friends)
    if resetPos then
      self.friendScrollview:ResetPosition()
      self.itemWrapHelper:ResetPosition()
    end
  end
  self.loading:SetActive(not isQuerySocialData)
end
function AdventureHomePage:showPropView()
  self.propBord:SetActive(not self.propBord.activeSelf)
  if self.propBord.activeSelf then
    local approps = AdventureDataProxy.Instance:GetAppellationProp()
    local x, y, z = LuaGameObject.GetLocalPosition(self.appellationPropCt.transform)
    local apSize = #approps
    if apSize == 0 then
      self:Hide(self.appellationPropCt)
    else
      local appData = MyselfProxy.Instance:GetCurManualAppellation()
      self.applationTitle.text = string.format(ZhString.AdventureHomePage_PropBordAppllationTitleDes, appData.staticData.Name)
      self.appellationGrid:ResetDatas(approps)
      self:Show(self.appellationPropCt)
      local bd = NGUIMath.CalculateRelativeWidgetBounds(self.appellationPropCt.transform)
      local height = bd.size.y
      y = y - height - 20
    end
    local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.adventurePropCt.transform)
    tempVector3:Set(x1, y, z1)
    self.adventurePropCt.transform.localPosition = tempVector3
    local props = AdventureDataProxy.Instance:GetAllAdventureProp()
    local propSize = #props
    if propSize == 0 then
      self:Hide(self.adventurePropCt)
    else
      self.adventurePropGrid:ResetDatas(props)
      self:Show(self.adventurePropCt)
    end
    if propSize == 0 and apSize == 0 then
      self:Show(self.emptyCt)
    else
      self:Hide(self.emptyCt)
    end
  end
end
