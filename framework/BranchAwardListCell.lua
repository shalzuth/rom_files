local baseCell = autoImport("BaseCell")
BranchAwardListCell = class("BranchAwardListCell", baseCell)
function BranchAwardListCell:Init()
  self:initView()
end
function BranchAwardListCell:initView()
  self.lock = self:FindGO("lock")
  self.item = self:FindGO("ItemCell")
  self.select = self:FindGO("Select")
  self.itemCell = ItemCell.new(self.item)
  self:AddButtonEvent("ActiveBtn", function()
    self:PassEvent(QuestManualEvent.AwardClick, self)
  end)
end
function BranchAwardListCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if self.select then
      if isSelected then
        self.select:SetActive(true)
      else
        self.select:SetActive(false)
      end
    end
  end
end
function BranchAwardListCell:SetData(data)
  self.data = data
  local itemData = ItemData.new("QuickBuy", data.itemid)
  self.itemCell:SetData(itemData)
  self.isSelected = false
  self.select:SetActive(false)
  local isUnlock = true
  if data.questList and #data.questList > 0 then
    for i = 1, #data.questList do
      if data.questList[i].type ~= SceneQuest_pb.EQUESTLIST_SUBMIT then
        isUnlock = false
        break
      end
    end
  end
  self.lock:SetActive(not isUnlock)
end
