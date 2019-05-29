autoImport("BaseView")
autoImport("MatchPrepareCell")
MatchPreparePopUp = class("MatchPreparePopUp", BaseView)
MatchPreparePopUp.ViewType = UIViewType.PopUpLayer
MatchPreparePopUp.Instance = nil
MatchPreparePopUp.Anchor = nil
MatchPreparePopUp.PrepareData = {
  myTeam = {},
  enemyTeam = {}
}
function MatchPreparePopUp.Show(pvpType, goodMatch)
  if not MatchPreparePopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MatchPreparePopUp,
      viewdata = {pvptype = pvpType, goodmatch = goodMatch}
    })
    return
  end
  if MatchPreparePopUp.Instance.isShow then
    return
  end
  if MatchPreparePopUp.Anchor and MatchPreparePopUp.Anchor.gameObject.activeInHierarchy then
    MatchPreparePopUp.Instance.trans.localScale = Vector3.zero
    MatchPreparePopUp.Instance.trans.position = MatchPreparePopUp.Anchor.position
    TweenPosition.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, Vector3.zero)
    TweenScale.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, Vector3.one)
  else
    MatchPreparePopUp.Instance.trans.localPosition = Vector3.zero
    MatchPreparePopUp.Instance.trans.localScale = Vector3.one
  end
  if pvpType then
    MatchPreparePopUp.Instance.pvpType = pvpType
  end
  MatchPreparePopUp.Instance.goodMatch = goodMatch
  MatchPreparePopUp.Instance:OnShow()
  MatchPreparePopUp.Instance.isShow = true
end
function MatchPreparePopUp.Hide()
  if not MatchPreparePopUp.Instance or not MatchPreparePopUp.Instance.isShow then
    return
  end
  if MatchPreparePopUp.Anchor and MatchPreparePopUp.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, MatchPreparePopUp.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, Vector3.zero)
  MatchPreparePopUp.Instance:OnHide()
  MatchPreparePopUp.Instance.isShow = false
end
function MatchPreparePopUp.SetPrepareData(data)
  MatchPreparePopUp.PrepareData.type = data.type
  MatchPreparePopUp.PrepareData.startPrepareTime = data.startPrepareTime
  MatchPreparePopUp.PrepareData.maxPrepareTime = data.maxPrepareTime
  MatchPreparePopUp.CopyTeamPreInfo(MatchPreparePopUp.PrepareData.myTeam, data.myTeam)
  MatchPreparePopUp.CopyTeamPreInfo(MatchPreparePopUp.PrepareData.enemyTeam, data.enemyTeam)
  if MatchPreparePopUp.Instance then
    MatchPreparePopUp.Instance:InitData(data)
  end
end
function MatchPreparePopUp.CopyTeamPreInfo(targetList, sourceList)
  local table
  if sourceList then
    for i = 1, #sourceList do
      table = targetList[i]
      if not table then
        table = {}
        targetList[i] = table
      end
      table.charID = sourceList[i].charID
      table.isReady = sourceList[i].isReady
    end
  end
  for i = sourceList and #sourceList + 1 or 1, #targetList do
    targetList[i].charID = MatchPrepareCell.EmptyCell
  end
end
function MatchPreparePopUp.UpdatePrepareStatus(charID)
  if MatchPreparePopUp.PrepareData then
    local datas = MatchPreparePopUp.PrepareData.myTeam
    local found = false
    for i = 1, #datas do
      if datas[i].charID == charID then
        datas[i].isReady = true
        found = true
        break
      end
    end
    if not found then
      datas = MatchPreparePopUp.PrepareData.enemyTeam
      for i = 1, #datas do
        if datas[i].charID == charID then
          datas[i].isReady = true
          break
        end
      end
    end
  end
  if MatchPreparePopUp.Instance then
    MatchPreparePopUp.Instance:UpdatePrepareStatusByID(charID)
  end
end
function MatchPreparePopUp:Init()
  if MatchPreparePopUp.Instance then
    self:CloseSelf()
    return
  end
  MatchPreparePopUp.Instance = self
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
end
function MatchPreparePopUp:FindObj()
  self.gridMyTeam = self:FindComponent("gridMyTeam", UIGrid)
  self.listMyTeam = UIGridListCtrl.new(self.gridMyTeam, MatchPrepareCell, "MatchPrepareCell")
  local gridEnemyTeam = self:FindComponent("gridEnemyTeam", UIGrid)
  self.listEnemyTeam = UIGridListCtrl.new(gridEnemyTeam, MatchPrepareCell, "MatchPrepareCell")
  self.sliderCountDown = self:FindComponent("SliderCountDown", UISlider)
  self.labCountDown = self:FindComponent("labCountDown", UILabel)
  self.objBtnPrepare = self:FindGO("BtnPrepare")
  self.objPrepared = self:FindGO("labPrepared")
  self.forceMatchTip = self:FindComponent("ForceMatchTip", UILabel)
  self.forceMatchTip.text = ZhString.MatchPrepare_ForceMatchTip
end
function MatchPreparePopUp:AddButtonEvt()
  self:AddClickEvent(self.objBtnPrepare, function()
    self:ClickButtonPrepare()
  end)
  self:AddClickEvent(self:FindGO("BtnMin"), function()
    MatchPreparePopUp.Hide()
  end)
end
function MatchPreparePopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleNtfMatchInfo)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.HandleClose)
  self:AddListenEvt(PVEEvent.ExpRaid_Launch, self.HandleClose)
end
local tempVector3 = LuaVector3.zero
function MatchPreparePopUp:InitData(data)
  if not MatchPreparePopUp.PrepareData then
    LogUtility.Error("\230\156\170\230\137\190\229\136\176\229\135\134\229\164\135\230\149\176\230\141\174\239\188\129")
    self:CloseSelf()
    return
  end
  if MatchPreparePopUp.PrepareData.type ~= self.pvpType then
    LogUtility.Warning(string.format("\231\149\140\233\157\162pvp\231\177\187\229\158\139(%s)\228\184\142\230\149\176\230\141\174pvp\231\177\187\229\158\139(%s)\228\184\141\228\184\128\232\135\180\239\188\140\228\187\165\230\149\176\230\141\174\231\177\187\229\158\139\228\184\186\229\135\134\227\128\130", self.pvpType, MatchPreparePopUp.PrepareData.type))
    self.pvpType = MatchPreparePopUp.PrepareData.type
  end
  self.forceMatchTip.gameObject:SetActive(not self.goodMatch)
  local myCharID = Game.Myself.data.id
  local datas = MatchPreparePopUp.PrepareData.myTeam
  if datas then
    for i = 1, #datas do
      local data = datas[i]
      if myCharID == data.charID then
        self.objBtnPrepare:SetActive(not data.isReady)
        self.objPrepared:SetActive(data.isReady)
        break
      end
    end
  end
  self.maxTeamPwsPrepareTime = MatchPreparePopUp.PrepareData.maxPrepareTime
  self.startPrepareTime = MatchPreparePopUp.PrepareData.startPrepareTime
  self.listMyTeam:ResetDatas(MatchPreparePopUp.PrepareData.myTeam)
  self.listMyTeam:Layout()
  if MatchPreparePopUp.PrepareData.enemyTeam and #MatchPreparePopUp.PrepareData.enemyTeam > 0 then
    self.listEnemyTeam:ResetDatas(MatchPreparePopUp.PrepareData.enemyTeam)
    self.listEnemyTeam:Layout()
    tempVector3:Set(-223, 45, 0)
  else
    tempVector3:Set(-223, 10, 0)
  end
  self.gridMyTeam.gameObject.transform.localPosition = tempVector3
  if self.startPrepareTime then
    TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
  else
    self.labCountDown.text = string.format("%ss", 0)
    self.sliderCountDown.value = 0
  end
end
function MatchPreparePopUp:UpdatePrepareStatusByID(charID)
  if not self:TryUpdateData(charID, self.listMyTeam) then
    self:TryUpdateData(charID, self.listEnemyTeam)
  end
end
function MatchPreparePopUp:UpdateCountDown()
  local curTime = (ServerTime.CurServerTime() - self.startPrepareTime) / 1000
  local leftTime = math.max(self.maxTeamPwsPrepareTime - curTime, 0)
  self.labCountDown.text = string.format("%ss", math.ceil(leftTime))
  self.sliderCountDown.value = leftTime / self.maxTeamPwsPrepareTime
  if leftTime == 0 then
    TimeTickManager.Me():ClearTick(self, 1)
  end
end
function MatchPreparePopUp:HandleNtfMatchInfo(note)
  if note.body and note.body.etype == self.pvpType then
    self:CloseSelf()
  end
end
function MatchPreparePopUp:HandleClose()
  PvpProxy.Instance:ClearTeamPwsPreInfo()
  PvpProxy.Instance:ClearMatchInfo(self.pvpType)
  self:CloseSelf()
end
function MatchPreparePopUp:TryUpdateData(charID, list)
  local cell
  local cells = list:GetCells()
  for i = 1, #cells do
    cell = cells[i]
    if cell.charID == charID then
      cell:Prepared()
      if charID == Game.Myself.data.id then
        self.objBtnPrepare:SetActive(false)
        self.objPrepared:SetActive(true)
      end
      return true
    end
  end
  return false
end
function MatchPreparePopUp:ClickButtonPrepare()
  if self.disableClick then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallUpdatePreInfoMatchCCmd(nil, self.pvpType)
  self.disableClick = true
  self.ltDisableClick = LeanTween.delayedCall(3, function()
    self.disableClick = false
    self.ltDisableClick = nil
  end)
end
function MatchPreparePopUp:OnEnter()
  self.super.OnEnter(self)
  MatchPreparePopUp.Show(self.viewdata.viewdata.pvptype, self.viewdata.viewdata.goodmatch)
end
function MatchPreparePopUp:OnShow()
  self.super.OnShow(self)
  if MatchPreparePopUp.PrepareData then
    self:InitData(MatchPreparePopUp.PrepareData)
  end
end
function MatchPreparePopUp:OnHide()
  TimeTickManager.Me():ClearTick(self, 1)
  self.super.OnHide(self)
end
function MatchPreparePopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  if self.ltDisableClick then
    self.ltDisableClick:cancel()
    self.ltDisableClick = nil
  end
  MatchPreparePopUp.Instance = nil
  self.super.OnExit(self)
end
