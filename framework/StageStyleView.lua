StageStyleView = class("StageStyleView", ContainerView)
StageStyleView.ViewType = UIViewType.ChatLayer
autoImport("StageStyleCell")
autoImport("StageStyleData")
StageStyleView.TabConfig = {
  [1] = {
    Config = GameConfig.StagePage[1]
  },
  [2] = {
    Config = GameConfig.StagePage[2]
  },
  [3] = {
    Config = GameConfig.StagePage[3]
  },
  [4] = {
    Config = GameConfig.StagePage[4]
  },
  [5] = {
    Config = GameConfig.StagePage[5]
  }
}
StageStyleView.UserdataMap = {
  [1] = ProtoCommon_pb.EUSERDATATYPE_HAIR,
  [2] = ProtoCommon_pb.EUSERDATATYPE_LEFTHAND,
  [3] = ProtoCommon_pb.EUSERDATATYPE_RIGHTHAND,
  [4] = ProtoCommon_pb.EUSERDATATYPE_HEAD,
  [5] = ProtoCommon_pb.EUSERDATATYPE_BACK
}
function StageStyleView:Init()
  self:InitView()
  self:AddCloseButtonEvent()
end
function StageStyleView:InitView()
  self.bord = self:FindGO("Bord")
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  local styleGrid = self:FindComponent("StyleGrid", UIGrid)
  self.styleCtl = UIGridListCtrl.new(styleGrid, StageStyleCell, "StageStyleCell")
  self.styleCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  self.closeComp = self.gameObject:GetComponent(CallBackWhenClickOtherPlace)
  function self.closeComp.call(go)
    TweenAlpha.Begin(self.gameObject, 0.5, 1)
  end
  self.nowTab = 1
  self.tabMap = {}
  local currentStage = StageProxy.Instance:GetCurrentStageid()
  local tabConfig = GameConfig.StagePage[currentStage]
  if not tabConfig then
    return
  end
  for i = 1, #tabConfig do
    local obj = self:FindGO("ItemTab" .. i)
    if obj then
      local comps = UIUtil.GetAllComponentsInChildren(obj, UISprite)
      for i = 1, #comps do
        comps[i]:MakePixelPerfect()
      end
      local index = i
      self:AddClickEvent(obj, function(go)
        self.nowTab = index
        self:UpdateData()
      end)
      self.tabMap[i] = obj:GetComponent(UIToggle)
    else
    end
  end
  self:UpdateData()
end
local stageid = 0
local stagePart = 0
function StageStyleView:ClickCell(cellctl)
  TweenAlpha.Begin(self.gameObject, 0.5, 0.3)
  stageid = StageProxy.Instance:GetCurrentStageid()
  stagePart = StageStyleView.UserdataMap[cellctl.data.stagePart]
  ServiceNUserProxy.Instance:CallDressUpModelUserCmd(stageid, stagePart, cellctl.data.partID)
end
function StageStyleView:OnEnter()
  StageStyleView.super.OnEnter(self)
end
function StageStyleView:UpdateData()
  local idconfig = StageProxy.Instance:GetCurrentStageid()
  if not GameConfig.StagePage[idconfig] then
    return
  end
  local Config = GameConfig.StagePage[idconfig]
  local types = Config[self.nowTab]
  if self.datas then
    TableUtility.TableClear(self.datas)
  else
    self.datas = {}
  end
  for i = 1, #types.types do
    local single = StageStyleData.new(self.nowTab, types.types[i])
    self.datas[#self.datas + 1] = single
  end
  self.styleCtl:ResetDatas(self.datas)
  self.scrollview:ResetPosition()
end
