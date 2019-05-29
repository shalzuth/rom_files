AdventureRewardPanel = class("AdventureRewardPanel", ContainerView)
AdventureRewardPanel.ViewType = UIViewType.PopUpLayer
autoImport("ProfessionSkillCell")
AdventureRewardPanel.FromConfig = {AdventurePanel = 1, AdventureLevelUp = 2}
local tempVector3 = LuaVector3.zero
local tempArray = {}
function AdventureRewardPanel:Init()
  self:initView()
  self:initData()
  self:addViewEventListener()
  self:addListEventListener()
end
function AdventureRewardPanel:OnEnter()
  self.super.OnEnter(self)
end
function AdventureRewardPanel:OnExit()
  self.super.OnExit(self)
end
function AdventureRewardPanel:initView()
  local nextSkills = self:FindGO("nextSkillGrid"):GetComponent(UIGrid)
  self.nextSkillsGrid = UIGridListCtrl.new(nextSkills, ProfessionSkillCell, "ProfessionSkillCell")
  self.nextSkillsGrid:AddEventListener(MouseEvent.MouseClick, self.cellClick, self)
  self.nextLevelAch = self:FindGO("nextLevelAch"):GetComponent(UILabel)
  self.userName = self:FindGO("userName"):GetComponent(UILabel)
  self.des = self:FindGO("des"):GetComponent(UILabel)
  local achCell = self:FindGO("achievementCell")
  self.achIcon = self:FindGO("icon", achCell):GetComponent(UISprite)
  self.achName = self:FindGO("achieventName", achCell):GetComponent(UILabel)
  self.nextSkillGridCt = self:FindGO("nextSkillGridCt")
  local getRewardBtnLabel = self:FindGO("getRewardBtnLabel"):GetComponent(UILabel)
  getRewardBtnLabel.text = ZhString.AdventureRewardPanel_GetRewardBtnLabel
  self:AddButtonEvent("forwardBtn", function()
    FuncShortCutFunc.Me():CallByID(27)
    self:CloseSelf()
  end)
  self.errorTxName = "Adventure_bg_bottom05"
  local tx = self:FindGO("textureBg"):GetComponent(UITexture)
  self.scView = self:FindComponent("ScrollView", UIScrollView)
  local achievementCell = self:FindGO("HeadHolder")
  self.headCell = MyHeadIconCell.new()
  self.headCell:CreateSelf(achievementCell)
  self.headCell:SetMinDepth(2)
  self:Hide(self.headCell.frameSp)
  self:Hide(self.headCell.simpleIcon)
  self.headCell:Refresh()
end
function AdventureRewardPanel:cellClick(obj)
  local skillId = obj.data
  local skillItem = SkillItemData.new(skillId)
  local tipData = {}
  tipData.data = skillItem
  TipsView.Me():ShowTip(SkillTip, tipData, "SkillTip")
  local tip = TipsView.Me().currentTip
  if tip then
    tempVector3:Set(400, 0, 0)
    tip.gameObject.transform.localPosition = tempVector3
  end
end
function AdventureRewardPanel:initData()
  self:setData()
end
function AdventureRewardPanel:setData()
  self.userName.text = Game.Myself.data:GetName() .. ":"
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local itemData = Table_Item[achData.id]
    if itemData then
      self.achName.text = itemData.NameZh
      self.des.text = string.format(ZhString.AdventureRewardPanel_Des, itemData.NameZh)
    else
      errorLog("can't find current appellation's itemData in table Item!itemId:", achData.id)
    end
  else
    errorLog("can't find current appellation Data in table Appellation!")
  end
  local skills = self:unlockAdventureSkills()
  self.nextLevelAch.text = ZhString.AdventureRewardPanel_AdventureUnlockSkill
  if skills and #skills > 0 then
    TableUtility.ArrayClear(tempArray)
    for i = 1, #skills do
      local data = {}
      data[1] = MyselfProxy.Instance:GetMyProfession()
      data[2] = skills[i]
      tempArray[#tempArray + 1] = data
    end
    self.nextSkillsGrid:ResetDatas(tempArray)
    self.scView:ResetPosition()
  else
  end
end
function AdventureRewardPanel:unlockAdventureSkills()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local skills = AdventureDataProxy.Instance:getAdventureSkillByAppellation(achData.id)
    return skills
  end
end
function AdventureRewardPanel:addViewEventListener()
end
function AdventureRewardPanel:addListEventListener()
  self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate, self.setData)
end
