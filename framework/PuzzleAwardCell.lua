local baseCell = autoImport("BaseCell")
PuzzleAwardCell = class("PuzzleAwardCell", baseCell)
function PuzzleAwardCell:Init()
  self:initView()
end
function PuzzleAwardCell:initView()
  self.item = self:FindGO("ItemCell")
  self.itemCell = ItemCell.new(self.item)
  self:AddButtonEvent("ItemCell", function()
    self:PassEvent(QuestManualEvent.ItemCellClick, self)
  end)
  self.puzzle = self:FindComponent("puzzle", UILabel)
  self.unlock = self:FindComponent("unlock", UILabel)
  self.lock = self:FindGO("Lock")
  self.unlock.transform.localPosition = Vector3(-68.5, -24, 0)
  OverseaHostHelper:FixLabelOverV1(self.unlock, 3, 250)
end
function PuzzleAwardCell:SetData(data)
  self.data = data
  if data.reward and #data.reward > 0 then
    local firstNoneCreditReward
    local firstRewardId = data.reward[1]
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(firstRewardId)
    if rewards and #rewards > 0 then
      for i = 1, #rewards do
        local reward = rewards[i]
        if reward.id ~= 100 and reward.id ~= 300 and reward.id ~= 400 then
          firstNoneCreditReward = reward
        end
      end
    end
    if firstNoneCreditReward then
      local itemData = ItemData.new("QuickBuy", firstNoneCreditReward.id)
      self.itemId = firstNoneCreditReward.id
      self.itemCell:SetData(itemData)
      self.puzzle.text = string.format(ZhString.QuestManual_GetPuzzleAward, data.indexss)
      local isLocked = QuestManualProxy.Instance:CheckPuzzleAwardLock(data.version, data.indexss)
      self.lock:SetActive(isLocked)
      if isLocked then
        self.unlock.text = string.format(ZhString.QuestManual_Unlock, itemData.staticData.NameZh)
      else
        self.unlock.text = ""
      end
    else
      self.puzzle.text = ""
      self.unlock.text = ""
    end
  end
end
