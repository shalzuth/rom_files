local baseCell = autoImport("BaseCell")
PuzzleBlockCell = class("PuzzleBlockCell", baseCell)
local blockSprite = "taskmanual_bic_a_"
local rimSprite = "taskmanual_add_"
local shadowSprite = "taskmanual_bic_b_"
function PuzzleBlockCell:Init()
  self:InitView()
end
function PuzzleBlockCell:InitView()
  self.plus = self:FindGO("plus")
  self.rim = self:FindComponent("rim", UISprite)
  self.blockPic = self:FindComponent("blockPic", UISprite)
  self:AddButtonEvent("plus", function()
    ServiceQuestProxy.Instance:CallOpenPuzzleQuestCmd(self.data.version, self.data.indexss)
    self:PlayUIEffect(EffectMap.UI.TaskManual_Puzzle, self.plus, true)
  end)
end
function PuzzleBlockCell:SetData(data)
  self.data = data
  self.plus:SetActive(false)
  self.rim.gameObject:SetActive(true)
  self.blockPic.gameObject:SetActive(true)
  IconManager:SetPuzzleIcon(blockSprite .. self.data.indexss, self.blockPic)
  IconManager:SetPuzzleIcon(shadowSprite .. self.data.indexss, self.rim)
  local poscfg = QuestManualView.PuzzleBlockPicPos[self.data.indexss]
  self.blockPic.gameObject.transform.localPosition = poscfg.pos
  self.rim.gameObject.transform.localPosition = LuaVector3.zero
  self.plus.gameObject.transform.localPosition = poscfg.plusPos
  self.rim:MakePixelPerfect()
  self.blockPic:MakePixelPerfect()
end
function PuzzleBlockCell:OpenPuzze()
  self.blockPic.gameObject:SetActive(true)
  IconManager:SetPuzzleIcon(shadowSprite .. self.data.indexss, self.blockPic)
  self.blockPic:MakePixelPerfect()
  self.plus:SetActive(false)
  self.rim.gameObject:SetActive(false)
end
function PuzzleBlockCell:UnlockPuzze()
  self.rim.gameObject:SetActive(true)
  IconManager:SetPuzzleIcon(rimSprite .. self.data.indexss, self.rim)
  self.rim:MakePixelPerfect()
  IconManager:SetPuzzleIcon(blockSprite .. self.data.indexss, self.blockPic)
  self.blockPic:MakePixelPerfect()
  self.plus:SetActive(true)
end
