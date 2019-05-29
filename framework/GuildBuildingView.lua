autoImport("GuildBuildingCell")
GuildBuildingView = class("GuildBuildingView", ContainerView)
GuildBuildingView.ViewType = UIViewType.NormalLayer
function GuildBuildingView:Init()
  self:FindObjs()
  self:MapListenEvt()
  self:InitUIView()
end
function GuildBuildingView:FindObjs()
  self.titleLab = self:FindComponent("Title", UILabel)
  self.ScrollView = self:FindGO("ScrollView")
  self.scrollViewComp = self.ScrollView:GetComponent(UIScrollView)
  self.container = self:FindGO("Container")
end
function GuildBuildingView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdBuildingNtfGuildCmd, self.HandleBuildingNtf)
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
end
local params = {}
local format = string.format
function GuildBuildingView:HandleBuildingNtf(note)
  local buildings = note.body.buildings
  if buildings and #buildings == 1 then
    local cellData = buildings[1]
    local buildingData = GuildBuildingData.new()
    buildingData:SetData(cellData)
    if buildingData.isbuilding and buildingData.staticData then
      TableUtility.ArrayClear(params)
      params[1] = buildingData.staticData.Name
      if not (buildingData.staticData.Level > 0) or not format(ZhString.GuildBuilding_StartBuild, ZhString.GuildBuilding_Levelup) then
      end
      params[2] = format(ZhString.GuildBuilding_StartBuild, ZhString.GuildBuilding_Build)
      MsgManager.ShowMsgByIDTable(3714, params)
      self:CloseSelf()
    end
  end
  self:UpdataBuilding()
end
function GuildBuildingView:CallBuildingSubmitCountGuildCmd(type)
  ServiceGuildCmdProxy.Instance:CallBuildingSubmitCountGuildCmd(type)
end
function GuildBuildingView:InitUIView()
  self.titleLab.text = ZhString.GuildBuilding_TitleName
  if self.wrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.container,
      pfbNum = 7,
      cellName = "GuildBuildingCell",
      control = GuildBuildingCell,
      dir = 2
    }
    self.wrapHelper = WrapCellHelper.new(wrapConfig)
    self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.OpenTips, self)
    self.wrapHelper:AddEventListener(GuildBuildingEvent.OnClickBuildBtn, self.StartBuild, self)
  end
  self:UpdataBuilding()
end
function GuildBuildingView:OpenTips(cellCtl)
  if cellCtl and cellCtl.data then
    if self.chooseTip ~= cellCtl.data.type then
      self.chooseTip = cellCtl.data.type
      if UIUtil.isClickLeftScreenArea() then
        self:ShowBuildingTip(cellCtl.data, cellCtl.icon, NGUIUtil.AnchorSide.Right, {190, -62})
      else
        self:ShowBuildingTip(cellCtl.data, cellCtl.icon, NGUIUtil.AnchorSide.Left, {-190, -62})
      end
    else
      TipManager.Instance:CloseTip()
      self.chooseTip = nil
    end
  end
end
function GuildBuildingView:StartBuild(cellCtl)
  if cellCtl and cellCtl.data then
    local result = GuildBuildingProxy.Instance:GetBuildAuth()
    if result == GuildBuildingProxy.BuildAuth.EBuildAuth_OnBuild then
      MsgManager.ShowMsgByID(3700)
      return
    end
    if result == GuildBuildingProxy.BuildAuth.EBuildAuth_OnCD then
      MsgManager.ShowMsgByID(3705)
      return
    end
    local data = cellCtl.data
    if data:GetCondMenu() then
      MsgManager.ShowMsgByID(3705)
      return
    end
    if data:LvlLimited() then
      MsgManager.ShowMsgByID(2868)
      return
    end
    local myGuildLv = GuildProxy.Instance.myGuildData.level
    if data.level < GameConfig.Guild.building_check_lv and myGuildLv <= data.level then
      MsgManager.ShowMsgByID(3701)
      return
    end
    ServiceGuildCmdProxy.Instance:CallBuildGuildCmd(data.type)
  end
end
function GuildBuildingView:ShowBuildingTip(data, stick, side, offset)
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds
  }
  local tip = TipManager.Instance:ShowGuildBuildingTip(sdata, stick, side, offset)
  tip:AddIgnoreBounds(self.ScrollView)
end
function GuildBuildingView:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
  local panel = self.scrollViewComp.panel
  local panelTrans = panel.cachedTransform
  local panelPos = panelTrans.position
  local panelClipOffset = panel.clipOffset
  self.wrapHelper:ResetPosition()
  panelTrans.position = panelPos
  panel.clipOffset = panelClipOffset
end
function GuildBuildingView:UpdataBuilding()
  local data = GuildBuildingProxy.Instance.BuildingData
  if data then
    self.wrapHelper:UpdateInfo(data)
  end
  self.wrapHelper:ResetPosition()
end
function GuildBuildingView:OnEnter()
  GuildBuildingView.super.OnEnter(self)
end
function GuildBuildingView:OnExit()
  PictureManager.Instance:UnLoadUI()
  EventManager.Me():RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  GuildBuildingView.super.OnExit(self)
end
