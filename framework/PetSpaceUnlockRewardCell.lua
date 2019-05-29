local BaseCell = autoImport("BaseCell")
autoImport("PetSpaceRewardCell")
PetSpaceUnlockRewardCell = class("PetSpaceUnlockRewardCell", BaseCell)
function PetSpaceUnlockRewardCell:Init()
  self.Desc = self:FindComponent("Desc", UILabel)
  self.RewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.RewardGrid = UIGridListCtrl.new(self.RewardGrid, PetSpaceRewardCell, "PetSpaceRewardCell")
end
function PetSpaceUnlockRewardCell:SetData(data)
  self.data = data
  if data then
    if data.desc then
      self.Desc.text = data.desc
      UIUtil.FitLabelHeight(self.Desc, 315)
    end
    if data.rewards and #data.rewards > 0 then
      self.RewardGrid:ResetDatas(data.rewards)
    end
  end
end
