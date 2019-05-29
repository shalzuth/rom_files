autoImport("DojoRewardCell")
ExpRaidResultView = class("ExpRaidResultView", BaseView)
ExpRaidResultView.ViewType = UIViewType.NormalLayer
function ExpRaidResultView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end
function ExpRaidResultView:InitData()
  local viewData = self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("ExpRaidResultView: viewdata is nothing")
    return
  end
  self.baseExp = viewData.baseexp or 0
  self.jobExp = viewData.jobexp or 0
  self.closeTimestamp = viewData.closetime or 60
  self.rewardDataArray = viewData.items
end
function ExpRaidResultView:FindObjs()
  self.tipLabel = self:FindComponent("Tip", UILabel)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.tipNameLabel = self:FindComponent("TipName", UILabel)
  self.countDownLabel = self:FindComponent("CountDownLabel", UILabel)
  self.anim1 = self:FindGO("Anim1")
  self.anim2 = self:FindGO("Anim2")
  self.anim3 = self:FindGO("Anim3")
  self.grid = self:FindComponent("Grid", UIGrid)
  self.emptyTipGO = self:FindGO("EmptyTip")
end
function ExpRaidResultView:InitView()
  self.tipLabel.text = ZhString.ExpRaid_ResultViewTipLabel
  self.tipNameLabel.text = ZhString.Dojo_Reward
  self.nameLabel.text = ""
  self.emptyTipGO:SetActive(false)
  local curRaidId = SceneProxy.Instance:GetCurRaidID()
  if curRaidId then
    local mapRaidData = Table_MapRaid[curRaidId]
    if mapRaidData and mapRaidData.NameZh then
      self.nameLabel.text = mapRaidData.NameZh
    end
  end
  local gridLocalPos = self.grid.transform.localPosition
  gridLocalPos.x = 321
  self.grid.transform.localPosition = gridLocalPos
  self.grid.cellWidth = 180
  self.grid.cellHeight = 80
  self.grid.pivot = UIWidget.Pivot.Left
  self:AddJobAndBaseToDataArray()
  self.rewardCtl = UIGridListCtrl.new(self.grid, DojoRewardCell, "ExpRaidRewardCell")
  self.rewardCtl:ResetDatas(self.rewardDataArray)
  TimeTickManager.Me():CreateTick(0, 300, self.RefreshTime, self)
end
local curServerTime
local getNowTime = function()
  if not curServerTime then
    curServerTime = ServerTime.CurServerTime
  end
  if curServerTime then
    return curServerTime() / 1000
  end
  return 0
end
function ExpRaidResultView:RefreshTime()
  local period = math.ceil(self.closeTimestamp - getNowTime())
  if period < 0 then
    period = 0
    TimeTickManager.Me():ClearTick(self)
  end
  self.countDownLabel.text = string.format(ZhString.Dojo_Secend, tostring(period))
end
function ExpRaidResultView:PlayAnim()
  self.anim1:SetActive(false)
  self.anim2:SetActive(false)
  self.anim3:SetActive(false)
  self.anim1Call = LeanTween.delayedCall(1.5, function()
    self.anim1Call = nil
    self.anim1:SetActive(true)
    self.anim2Call = LeanTween.delayedCall(0.3, function()
      self.anim2Call = nil
      self.anim2:SetActive(true)
      self.anim3Call = LeanTween.delayedCall(0.3, function()
        self.anim3Call = nil
        self.anim3:SetActive(true)
      end)
    end)
  end)
end
function ExpRaidResultView:OnEnter()
  ExpRaidResultView.super.OnEnter(self)
  self:CameraRotateToMe()
  self:PlayAnim()
end
function ExpRaidResultView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.anim1Call then
    self.anim1Call:cancel()
    self.anim1Call = nil
  end
  if self.anim2Call then
    self.anim2Call:cancel()
    self.anim2Call = nil
  end
  if self.anim3Call then
    self.anim3Call:cancel()
    self.anim3Call = nil
  end
  ExpRaidResultView.super.OnExit(self)
  self:CameraReset()
end
function ExpRaidResultView:AddJobAndBaseToDataArray()
  if self.baseExp <= 0 and 0 >= self.jobExp then
    return
  end
  local newDojoRewardData = ReusableTable.CreateTable()
  if self.baseExp > 0 then
    newDojoRewardData.id = 300
    newDojoRewardData.count = self.baseExp
    TableUtility.ArrayPushFront(self.rewardDataArray, DojoRewardData.new(newDojoRewardData))
  end
  if 0 < self.jobExp then
    newDojoRewardData.id = 400
    newDojoRewardData.count = self.jobExp
    TableUtility.ArrayPushFront(self.rewardDataArray, DojoRewardData.new(newDojoRewardData))
  end
  ReusableTable.DestroyAndClearTable(newDojoRewardData)
end
function ExpRaidResultView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end)
end
