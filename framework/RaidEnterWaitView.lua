autoImport("ContainerView")
RaidEnterWaitView = class("RaidEnterWaitView", ContainerView)
RaidEnterWaitView.ViewType = UIViewType.PopUpLayer
autoImport("CarrierWaitListCell")
local evts = {}
function RaidEnterWaitView.SetListenEvent(evtname, evt)
  evts[evtname] = evt
end
local startFunc
function RaidEnterWaitView.SetStartFunc(func)
  startFunc = func
end
local cancelFunc
function RaidEnterWaitView.SetCancelFunc(func)
  cancelFunc = func
end
local allApplyFunc
function RaidEnterWaitView.SetAllApplyCall(func)
  allApplyFunc = func
end
local preactive_start
function RaidEnterWaitView.PreActiveButton_Start(b)
  preactive_start = b
end
local preactive_cancel
function RaidEnterWaitView.PreActiveButton_Cancel(b)
  preactive_cancel = b
end
local preenable_start
function RaidEnterWaitView.PreEnableButton_Start(b)
  preenable_start = b
end
local preenable_cancel
function RaidEnterWaitView.PreEnableButton_Cancel(b)
  preenable_cancel = b
end
local ClearLocalParam = function()
  TableUtility.TableClear(evts)
  startFunc = nil
  cancelFunc = nil
  preactive_start = nil
  preactive_cancel = nil
  pregrey_start = nil
  pregrey_cancel = nil
  allApplyFunc = nil
end
function RaidEnterWaitView:Init()
  self.cache_value = {}
  self:InitView()
  self:MapEvent()
end
function RaidEnterWaitView:InitView()
  self.waitCell = self:LoadPreferb("cell/WaitCell", self.gameObject)
  self.waitCell.transform.localPosition = LuaVector3.zero
  local waitGrid = self:FindGO("WaitList"):GetComponent(UIGrid)
  self.waitList = ListCtrl.new(waitGrid, CarrierWaitListCell, "CarrierWaitListCell")
  self.startBtn = self:FindGO("StartBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self:AddClickEvent(self.startBtn, function(go)
    if startFunc then
      startFunc(self)
    end
  end)
  self:AddClickEvent(self.cancelBtn, function(go)
    if cancelFunc then
      cancelFunc(self)
    end
  end)
  self.buttonGrid = self:FindComponent("ButtonGrid", UIGrid)
end
function RaidEnterWaitView:PreUpdateButtons()
  if preactive_start ~= nil then
    self:ActiveButton_Start(preactive_start)
  end
  if preactive_cancel ~= nil then
    self:ActiveButton_Cancel(preactive_cancel)
  end
  if preenable_start ~= nil then
    self:EnableButton_Start(preenable_start)
  end
  if preenable_cancel ~= nil then
    self:EnableButton_Cancel(preenable_cancel)
  end
end
function RaidEnterWaitView:MapEvent()
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.UpdateWaitList)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.UpdateWaitList)
  if evts == nil then
    return
  end
  for k, v in pairs(evts) do
    do
      local func = function(view_self, note)
        v(view_self, note)
      end
      self:AddListenEvt(k, func)
    end
    break
  end
end
function RaidEnterWaitView:UpdateWaitList(defaultValue)
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam == nil then
    return
  end
  local members = myTeam:GetPlayerMemberList(true, true)
  self.datas = {}
  local myid = Game.Myself.data.id
  local m
  for i = 1, #members do
    m = members[i]
    if not m:IsOffline() then
      local tdata = {}
      tdata.name = m.name
      if self.summoned_map and self.summoned_map[m.id] then
        tdata.summon = 1
      end
      if self.cache_value[m.id] == nil then
        if myid == m.id then
          tdata.agree = true
        else
          tdata.agree = defaultValue
        end
      else
        tdata.agree = self.cache_value[m.id]
      end
      table.insert(self.datas, tdata)
    end
  end
  self.waitList:ResetDatas(self.datas)
  self:CheckCallAllApplyFunc()
end
function RaidEnterWaitView:UpdateMemberEnterState(memberid, state)
  self.cache_value[memberid] = state
  self:CheckCallAllApplyFunc()
end
function RaidEnterWaitView:ActiveSummonedInfo(memberid)
  if self.summoned_map == nil then
    self.summoned_map = {}
  end
  self.summoned_map[memberid] = true
end
function RaidEnterWaitView:CheckCallAllApplyFunc()
  if allApplyFunc == nil then
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam == nil then
    return
  end
  local members = myTeam:GetPlayerMemberList(true, true)
  local allApply = true
  local m
  local myid = Game.Myself.data.id
  for i = 1, #members do
    m = members[i]
    if m.id ~= myid and self.cache_value[m.id] == nil then
      allApply = false
      break
    end
  end
  if allApply then
    allApplyFunc(self)
    allApplyFunc = nil
  end
end
function RaidEnterWaitView:OnEnter()
  RaidEnterWaitView.super.OnEnter(self)
  self:UpdateWaitList()
  self:PreUpdateButtons()
end
function RaidEnterWaitView:ActiveButton_Start(b)
  self.startBtn:SetActive(b)
  self.buttonGrid.repositionNow = true
end
function RaidEnterWaitView:ActiveButton_Cancel(b)
  self.cancelBtn:SetActive(b)
  self.buttonGrid.repositionNow = true
end
function RaidEnterWaitView:EnableButton_Start(b)
  self:SetTextureGrey(self.startBtn, b)
  self.startBtn:GetComponent(BoxCollider).enabled = b
end
function RaidEnterWaitView:EnableButton_Cancel(b)
  if b then
    self:SetTextureWhite(self.cancelBtn, ColorUtil.NGUILabelBlueBlack)
  else
    self:SetTextureGrey(self.cancelBtn)
  end
  self.cancelBtn:GetComponent(BoxCollider).enabled = b
end
function RaidEnterWaitView:OnExit()
  RaidEnterWaitView.super.OnExit(self)
  helplog("OnExit")
  TableUtility.TableClear(self.cache_value)
  ClearLocalParam()
end
