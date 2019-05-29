autoImport("BaseTip")
autoImport("ItemCell")
RewardListTip = class("RewardListTip", BaseTip)
RewardListTip.MaxWidth = 300
function RewardListTip:ctor(prefabName, stick, side, offset)
  RewardListTip.super.ctor(self, prefabName, stick.gameObject)
  self.stick = stick
  self.side = side
  self.offset = offset
  self:InitTip()
end
function RewardListTip:InitTip()
  self.scrollPanel = self:FindComponent("RewardScrollView", UIPanel)
  local upPanel = GameObjectUtil.Instance:FindCompInParents(self.stick.gameObject, UIPanel)
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.panel.depth = upPanel.depth + 10
  self.grid = self:FindComponent("Grid", UIGrid)
  if self.listControllerOfItems == nil then
    self.listControllerOfItems = UIGridListCtrl.new(self.grid, ItemCell, "ItemCell")
  end
  self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace)
  function self.closeComp.callBack()
    TipManager.Instance:CloseRewardListTip()
  end
end
function RewardListTip:SetData(data)
  local itemList = ItemUtil.GetRewardItemIdsByTeamId(data.rewardid)
  local itemDataList = {}
  if itemList and #itemList > 0 then
    for i = 1, #itemList do
      local itemInfo = itemList[i]
      local tempItem = ItemData.new("", itemInfo.id)
      tempItem.num = itemInfo.num
      itemDataList[#itemDataList + 1] = tempItem
    end
    self.listControllerOfItems:ResetDatas(itemDataList)
    local cells = self.listControllerOfItems:GetCells()
    for i = 1, #cells do
      cells[i].gameObject.transform.localScale = LuaVector3(0.5, 0.5, 0.5)
    end
    self.scrollPanel.depth = self.panel.depth + 10
  end
end
function RewardListTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end
function RewardListTip:RemoveUpdateTick()
  if self.updateCallTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateCallTick = nil
  end
  self.updateCall = nil
  self.updateCallTick = nil
end
function RewardListTip:SetUpdateSetText(interval, updateCall, updateCallParam)
  self.updateCall = updateCall
  self.updateCallParam = updateCallParam
  if self.updateCallTick == nil then
    self.updateCallTick = TimeTickManager.Me():CreateTick(0, interval, self._TickUpdateCall, self, 1)
  end
end
function RewardListTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end
function RewardListTip:_TickUpdateCall()
  if self.updateCall then
    local needRemove, text = self.updateCall(self.updateCallParam)
    self:SetData(text)
    if needRemove then
      self:RemoveUpdateTick()
    end
  end
end
function RewardListTip:OnEnter()
  RewardListTip.super.OnEnter(self)
end
function RewardListTip:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
function RewardListTip:OnExit()
  if self.closeCall then
    self.closeCall(self.closeCallParam)
  end
  return true
end
