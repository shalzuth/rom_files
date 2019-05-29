local baseCell = autoImport("BaseCell")
ActivityPuzzleBlockCell = class("ActivityPuzzleBlockCell", baseCell)
local posConfig = GameConfig.ActivityPuzzle
local blockSprite = "taskmanual_bic_a_"
local blockSprite3 = "taskmanual_bic_3x3a_"
local blockSprite5 = "taskmanual_bic_5x5a_"
local shadowSprite = "taskmanual_bic_b_"
local shadowSprite3 = "taskmanual_bic_3x3b_"
local shadowSprite5 = "taskmanual_bic_5x5b_"
function ActivityPuzzleBlockCell:Init()
  self:InitView()
end
function ActivityPuzzleBlockCell:InitView()
  local plus = self:FindGO("plus")
  local rim = self:FindGO("rim")
  self.blockGO = self:FindGO("blockPic")
  self.blockSp = self.blockGO:GetComponent(UISprite)
  plus:SetActive(false)
  rim:SetActive(false)
  self.effectContainer = self:FindGO("EffectContainer")
end
local tempVector3 = LuaVector3.zero
function ActivityPuzzleBlockCell:SetData(data)
  self.data = data
  local itemData = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(data.ActivityID, data.PuzzleID)
  local condition = itemData and itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE
  local activitySizeType = Table_ActivityInfo[data.ActivityID].Size
  local cf
  if activitySizeType == 9 then
    cf = posConfig.PuzzleBlockPicPos_9[self.data.PuzzleID].pos
    if condition then
      IconManager:SetPuzzleIcon(shadowSprite3 .. data.PuzzleID, self.blockSp)
    else
      IconManager:SetPuzzleIcon(blockSprite3 .. data.PuzzleID, self.blockSp)
    end
  elseif activitySizeType == 16 then
    cf = posConfig.PuzzleBlockPicPos_16[self.data.PuzzleID].pos
    if condition then
      IconManager:SetPuzzleIcon(shadowSprite .. data.PuzzleID, self.blockSp)
    else
      IconManager:SetPuzzleIcon(blockSprite .. data.PuzzleID, self.blockSp)
    end
  elseif activitySizeType == 25 then
    cf = posConfig.PuzzleBlockPicPos_25[self.data.PuzzleID].pos
    if condition then
      IconManager:SetPuzzleIcon(shadowSprite5 .. data.PuzzleID, self.blockSp)
    else
      IconManager:SetPuzzleIcon(blockSprite5 .. data.PuzzleID, self.blockSp)
    end
  end
  self.blockSp:MakePixelPerfect()
  tempVector3:Set(cf[1], cf[2], cf[3])
  self.blockGO.transform.localPosition = tempVector3
end
function ActivityPuzzleBlockCell:PlayEffect(msg)
  self:PlayUIEffect(EffectMap.UI.TaskManual_Puzzle, self.effectContainer, true)
end
