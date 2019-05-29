autoImport("AdventureZoneRewardCell")
AdventureZoneRewardPopUp = class("AdventureZoneRewardPopUp", BaseView)
AdventureZoneRewardPopUp.ViewType = UIViewType.PopUpLayer
AdventureZoneRewardPopUp.ERewardType = {
  Good = SceneManual_pb.EMANUALZONEREWARD_GOOD,
  Perfect = SceneManual_pb.EMANUALZONEREWARD_PERFECT,
  Npc = SceneManual_pb.EMANUALZONEReward_NPC
}
local TipData = {
  funcConfig = {}
}
local ColorBtnAwardLabelEnable = LuaColor(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1)
function AdventureZoneRewardPopUp:Init()
  self.rewardDatas = {}
  self:FindObjs()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitList()
end
function AdventureZoneRewardPopUp:FindObjs()
  self.objLayOutBig = self:FindGO("LayOutBig")
  self.objLayOutSmall = self:FindGO("LayOutSmall")
end
function AdventureZoneRewardPopUp:AddButtonEvt()
  self:AddClickEvent(self:FindGO("Mask"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("BtnClose"), function()
    self:CloseSelf()
  end)
end
function AdventureZoneRewardPopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SceneManualNpcZoneRewardManualCmd, self.RefreshRewards)
  self:AddListenEvt(ServiceEvent.SceneManualNpcZoneDataManualCmd, self.RefreshRewards)
end
function AdventureZoneRewardPopUp:InitList()
  self.listReward = UIGridListCtrl.new(self:FindComponent("rewardContainer", UIGrid), AdventureZoneRewardCell, "AdventureZoneRewardCell")
  self.listReward:AddEventListener(MouseEvent.MouseClick, self.ClickRewardItem, self)
end
function AdventureZoneRewardPopUp:InitViewData()
  self.data = self.viewdata.viewdata
  self.zoneStaticData = self.data.zoneStaticData
  self.isNpc = self.data.type == SceneManual_pb.EMANUALTYPE_NPC
  self.isMonster = self.data.type == SceneManual_pb.EMANUALTYPE_MONSTER
  self:InitRewardDatas()
end
function AdventureZoneRewardPopUp:InitRewardDatas()
  self:ClearRewardDatas()
  self.zoneData = AdventureDataProxy.Instance:GetZoneProcessData(self.data.id)
  if self.isNpc then
    local visitNum = self.zoneData and self.zoneData.visitNum or 0
    local maxNpcNum = self.zoneStaticData.NpcNum or 0
    local zoneRewardData = ReusableTable.CreateTable()
    zoneRewardData.id = self.data.id
    zoneRewardData.rewardType = AdventureZoneRewardPopUp.ERewardType.Npc
    zoneRewardData.rewardGot = (self.zoneData and self.zoneData.npcRewardGot) == true
    zoneRewardData.canGetReward = visitNum >= maxNpcNum and not zoneRewardData.rewardGot or false
    zoneRewardData.rewards = ReusableTable.CreateArray()
    self:AddRewardItemDatasToList(zoneRewardData.rewards, ItemUtil.GetRewardItemIdsByTeamId(self.zoneStaticData.NpcReward))
    self.rewardDatas[#self.rewardDatas + 1] = zoneRewardData
  elseif self.isMonster then
    local killNum = self.zoneData and self.zoneData.killNum or 0
    local photoNum = self.zoneData and self.zoneData.photoNum or 0
    local maxMonsterNum = self.zoneStaticData.MonsterNum or 0
    local zoneRewardData = ReusableTable.CreateTable()
    zoneRewardData.id = self.data.id
    zoneRewardData.rewardType = AdventureZoneRewardPopUp.ERewardType.Good
    zoneRewardData.rewardGot = (self.zoneData and self.zoneData.goodRewardGot) == true
    zoneRewardData.canGetReward = (killNum >= maxMonsterNum or photoNum >= maxMonsterNum) and not zoneRewardData.rewardGot or false
    zoneRewardData.rewards = ReusableTable.CreateArray()
    self:AddRewardItemDatasToList(zoneRewardData.rewards, ItemUtil.GetRewardItemIdsByTeamId(self.zoneStaticData.GoodReward))
    self.rewardDatas[#self.rewardDatas + 1] = zoneRewardData
    zoneRewardData = ReusableTable.CreateTable()
    zoneRewardData.id = self.data.id
    zoneRewardData.rewardType = AdventureZoneRewardPopUp.ERewardType.Perfect
    zoneRewardData.rewardGot = (self.zoneData and self.zoneData.perfectRewardGot) == true
    zoneRewardData.canGetReward = killNum >= maxMonsterNum and photoNum >= maxMonsterNum and not zoneRewardData.rewardGot or false
    zoneRewardData.rewards = ReusableTable.CreateArray()
    self:AddRewardItemDatasToList(zoneRewardData.rewards, ItemUtil.GetRewardItemIdsByTeamId(self.zoneStaticData.PerfectReward))
    self.rewardDatas[#self.rewardDatas + 1] = zoneRewardData
  end
  self.listReward:ResetDatas(self.rewardDatas)
  self.objLayOutBig:SetActive(#self.rewardDatas > 1)
  self.objLayOutSmall:SetActive(#self.rewardDatas < 2)
end
function AdventureZoneRewardPopUp:AddRewardItemDatasToList(targetList, datas)
  local itemData
  if datas then
    for i = 1, math.min(#datas, 1) do
      itemData = ItemData.new("AdventureZoneReward", datas[i].id)
      itemData.num = datas[i].num
      targetList[#targetList + 1] = itemData
    end
  end
end
function AdventureZoneRewardPopUp:ClearRewardDatas()
  local cells = self.listReward:GetCells()
  for i = 1, #cells do
    cells[i]:ClearLt()
  end
  for i = 1, #self.rewardDatas do
    ReusableTable.DestroyAndClearArray(self.rewardDatas[i].rewards)
    ReusableTable.DestroyAndClearTable(self.rewardDatas[i])
  end
  TableUtility.ArrayClear(self.rewardDatas)
end
function AdventureZoneRewardPopUp:RefreshRewards()
  self:InitRewardDatas()
end
function AdventureZoneRewardPopUp:ClickRewardItem(cell)
  local data = cell.data
  if data then
    TipData.itemdata = data
    self:ShowItemTip(TipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function AdventureZoneRewardPopUp:OnEnter()
  AdventureZoneRewardPopUp.super.OnEnter(self)
  self:InitViewData()
end
function AdventureZoneRewardPopUp:OnExit()
  self:ClearRewardDatas()
  AdventureZoneRewardPopUp.super.OnExit(self)
end
