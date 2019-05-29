local baseCell = autoImport("BaseCell")
AdventureCombineNpcCell = class("AdventureCombineNpcCell", baseCell)
autoImport("AdventrueItemCell")
local vecArrowFoldPos = LuaVector3(1.5, 1, 0)
local vecArrowOpenEuler = LuaVector3(0, 0, -90)
function AdventureCombineNpcCell:Init()
  self.isActive = true
  self:FindObjs()
  self:AddEvents()
  self:InitCells(5, "AdventureItemCell", AdventrueItemCell)
end
function AdventureCombineNpcCell:InitCells(childNum, cellName, control)
  if not self.childCells then
    self.childCells = {}
  else
    TableUtility.ArrayClear(self.childCells)
  end
  local rid = ResourcePathHelper.UICell(cellName)
  for i = 1, childNum do
    local go = Game.AssetManager_UI:CreateAsset(rid, self.objCellsRoot)
    go.name = "child" .. i
    table.insert(self.childCells, control.new(go))
  end
  self:Reposition()
end
function AdventureCombineNpcCell:Reposition()
  self.gridCells:Reposition()
end
function AdventureCombineNpcCell:AddEventListener(eventType, handler, handlerOwner)
  self.super.AddEventListener(self, eventType, handler, handlerOwner)
  for k, v in pairs(self.childCells) do
    v:AddEventListener(eventType, handler, handlerOwner)
  end
end
function AdventureCombineNpcCell:GetCells()
  return self.childCells
end
function AdventureCombineNpcCell:FindObjs()
  self.objCellsRoot = self:FindGO("CellsRoot")
  self.gridCells = self.objCellsRoot:GetComponent(UIGrid)
  self.objTag = self:FindGO("Tag")
  self.labTagName = self:FindComponent("labTagName", UILabel, self.objTag)
  self.objProgressIcon = self:FindGO("sprProgressIcon", self.objTag)
  self.sprProgressIcon = self.objProgressIcon:GetComponent(UISprite)
  self.objBtnSwitchFold = self:FindGO("BtnSwitchFold", self.objTag)
  self.tsfBtnSwitchHoldArrow = self:FindGO("sprIconFold", self.objBtnSwitchFold).transform
  self.objBtnReward = self:FindGO("BtnReward", self.objTag)
  self.sprBtnReward = self.objBtnReward:GetComponent(UISprite)
  self.colBtnReward = self.objBtnReward:GetComponent(Collider)
  self.objRewardHighLight = self:FindGO("HighLight", self.objBtnReward)
  self.labRewardNum = self:FindComponent("labRewardNum", UILabel, self.objBtnReward)
  self.objContentNpc = self:FindGO("ContentNpc", self.objTag)
  self.labVisitNum = self:FindComponent("labVisitNum", UILabel, self.objContentNpc)
  self.objContentMonster = self:FindGO("ContentMonster", self.objTag)
  self.labKillNum = self:FindComponent("labKillNum", UILabel, self.objContentMonster)
  self.labPhotoNum = self:FindComponent("labPhotoNum", UILabel, self.objContentMonster)
  local labKill = self:FindGO("labKill"):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(labKill, 2, 100)
  labKill.transform.localPosition = Vector3(-10, 0, 0)
end
function AdventureCombineNpcCell:AddEvents()
  self:AddClickEvent(self.objBtnSwitchFold, function()
    self:OnClickBtnSwitchFold()
  end)
  self:AddClickEvent(self.objBtnReward, function()
    self:OnClickBtnReward()
  end)
end
function AdventureCombineNpcCell:SetData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  if self.isTag ~= data.isTag then
    self.isTag = data.isTag
    self.objCellsRoot:SetActive(not data.isTag)
    self.objTag:SetActive(data.isTag == true)
  end
  if data.isTag then
    self.id = data.id
    self.tsfBtnSwitchHoldArrow.localPosition = data.isOpen and LuaVector3.zero or vecArrowFoldPos
    self.tsfBtnSwitchHoldArrow.localEulerAngles = data.isOpen and vecArrowOpenEuler or LuaVector3.zero
    self:ReloadTagData()
  elseif self.childCells then
    for i = 1, #self.childCells do
      self.childCells[i]:SetData(self.data[i])
    end
  end
end
function AdventureCombineNpcCell:ReloadTagData()
  if not self.isTag or not self.isActive then
    return
  end
  self.zoneData = AdventureDataProxy.Instance:GetZoneProcessData(self.data.id)
  local zoneStaticData = self.data.zoneStaticData
  if self.data.isDefaultTag then
  end
  local mapStaticData = Table_Map[self.data.id]
  local rewardCount = 0
  local maxConditionCount = 0
  local unFinishConditionCount = 0
  self.labTagName.text = mapStaticData and mapStaticData.NameZh or GameConfig.AdventureDefaultTag.name
  if not self.zoneData and not self.data.isDefaultTag then
    redlog(string.format("MapID:%s cannot find zone process data!", self.data.id))
  end
  local isNpc = self.data.type == SceneManual_pb.EMANUALTYPE_NPC
  self.objContentNpc:SetActive(isNpc)
  if isNpc then
    maxConditionCount = 1
    local visitNum = self.zoneData and self.zoneData.visitNum or 0
    local maxNpcNum = zoneStaticData.NpcNum or 0
    self.labVisitNum.text = string.format("%d/%d", visitNum, maxNpcNum)
    if visitNum < maxNpcNum then
      unFinishConditionCount = unFinishConditionCount + 1
    elseif self.zoneData and not self.zoneData.npcRewardGot then
      rewardCount = rewardCount + 1
    end
  end
  local isMonster = self.data.type == SceneManual_pb.EMANUALTYPE_MONSTER
  self.objContentMonster:SetActive(isMonster)
  if isMonster then
    maxConditionCount = 2
    local killNum = self.zoneData and self.zoneData.killNum or 0
    local photoNum = self.zoneData and self.zoneData.photoNum or 0
    local maxMonsterNum = zoneStaticData.MonsterNum or 0
    self.labKillNum.text = string.format("%d/%d", killNum, maxMonsterNum)
    self.labPhotoNum.text = string.format("%d/%d", photoNum, maxMonsterNum)
    if killNum < maxMonsterNum then
      unFinishConditionCount = unFinishConditionCount + 1
    end
    if photoNum < maxMonsterNum then
      unFinishConditionCount = unFinishConditionCount + 1
    end
    if maxConditionCount > unFinishConditionCount and self.zoneData and not self.zoneData.goodRewardGot then
      rewardCount = rewardCount + 1
    end
    if unFinishConditionCount < 1 and self.zoneData and not self.zoneData.perfectRewardGot then
      rewardCount = rewardCount + 1
    end
  end
  self.objProgressIcon:SetActive(maxConditionCount > unFinishConditionCount)
  if maxConditionCount > unFinishConditionCount then
    self.sprProgressIcon.spriteName = "Adventure_icon_" .. (unFinishConditionCount < 1 and "perfect" or "good")
  end
  self.objBtnReward:SetActive(not self.data.isDefaultTag)
  if not self.data.isDefaultTag then
    self.labRewardNum.text = rewardCount > 0 and rewardCount or ""
    self.sprBtnReward.alpha = (rewardCount > 0 or unFinishConditionCount < 1) and 1 or 0.5
    self.objRewardHighLight:SetActive(rewardCount > 0)
    local haveRewardToGet = unFinishConditionCount > 0 or rewardCount > 0
    self.colBtnReward.enabled = haveRewardToGet
    IconManager:SetUIIcon(haveRewardToGet and "growup1" or "growup2", self.sprBtnReward)
  end
end
function AdventureCombineNpcCell:OnClickBtnSwitchFold(btn)
  if self.isTag then
    self:PassEvent(AdventureTagItemList.ClickFoldTag, self)
  end
end
function AdventureCombineNpcCell:OnClickBtnReward(btn)
  if self.isTag then
    self:PassEvent(AdventureNpcListPage.ClickReward, self)
  end
end
