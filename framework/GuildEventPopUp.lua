GuildEventPopUp = class("GuildEventPopUp", ContainerView)
GuildEventPopUp.ViewType = UIViewType.PopUpLayer
autoImport("GuildEventCell")
local tempColor = LuaColor.New(1, 1, 1, 1)
local _ColorBlue = LuaColor.New(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
local _ColorTitleGray = ColorUtil.TitleGray
local pageCfg = {
  1,
  2,
  3,
  4,
  5,
  6,
  7
}
function GuildEventPopUp:Init(parent)
  self:FindObjs()
  self:AddEvts()
  self:InitView()
  self:MapEvent()
end
function GuildEventPopUp:FindObjs()
  self.scrollview = self:FindGO("EventScrollView"):GetComponent(UIScrollView)
  self.toggleGrid = self:FindGO("ToggleRoot"):GetComponent(UIGrid)
  self.eventToggle = self:FindGO("EventToggle"):GetComponent(UIToggle)
  self.contributeToggle = self:FindGO("ContributeToggle"):GetComponent(UIToggle)
  self.buildingToggle = self:FindGO("BuildingToggle"):GetComponent(UIToggle)
  self.gvgToggle = self:FindGO("GVGToggle"):GetComponent(UIToggle)
  self.artifactToggle = self:FindGO("ArtifactToggle"):GetComponent(UIToggle)
  self.treasureToggle = self:FindGO("TreasureToggle"):GetComponent(UIToggle)
  if self:FindGO("GuildVoiceToggle") then
    self.guildVoiceToggle = self:FindGO("GuildVoiceToggle"):GetComponent(UIToggle)
  end
end
function GuildEventPopUp:AddEvts()
  self:AddToggleChange(self.eventToggle, self.RefreshView, pageCfg[1])
  self:AddToggleChange(self.contributeToggle, self.RefreshView, pageCfg[2])
  self:AddToggleChange(self.buildingToggle, self.RefreshView, pageCfg[3])
  self:AddToggleChange(self.gvgToggle, self.RefreshView, pageCfg[4])
  self:AddToggleChange(self.artifactToggle, self.RefreshView, pageCfg[5])
  self:AddToggleChange(self.treasureToggle, self.RefreshView, pageCfg[6])
  self:AddToggleChange(self.guildVoiceToggle, self.RefreshView, pageCfg[7])
end
local viewData = {}
function GuildEventPopUp:RefreshView(type)
  self.scrollview:ResetPosition()
  TableUtility.ArrayClear(viewData)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local list = myGuildData:GetGuildEventList()
    for i = 1, #list do
      local cellPage = list[i].type and Table_Guild_Incident[list[i].type] and Table_Guild_Incident[list[i].type].Page
      if cellPage == type then
        TableUtility.ArrayPushBack(viewData, list[i])
      end
    end
    self.wraplist:UpdateInfo(viewData)
    self.eventNoneTip:SetActive(#list == 0)
    self.wraplist:ResetPosition()
  end
end
function GuildEventPopUp:GetPageIndex()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    for i = 1, #pageCfg do
      local list = myGuildData:GetGuildEventList()
      for j = 1, #list do
        local cellPage = list[j].type and Table_Guild_Incident[list[j].type] and Table_Guild_Incident[list[j].type].Page
        if cellPage and cellPage == pageCfg[i] then
          return i
        end
      end
    end
  end
  return nil
end
function GuildEventPopUp:AddToggleChange(toggle, handler, param)
  if toggle then
    EventDelegate.Add(toggle.onChange, function()
      local label = toggle.gameObject:GetComponent(UILabel)
      if toggle.value then
        label.color = _ColorBlue
        if handler ~= nil then
          handler(self, param)
        end
      else
        label.color = _ColorTitleGray
      end
    end)
  end
end
function GuildEventPopUp:InitView()
  FunctionGuild.Me():QueryGuildEventList()
  local wrapContainer = self:FindGO("EventWrap")
  local wrapConfig = {
    wrapObj = wrapContainer,
    pfbNum = 13,
    cellName = "GuildEventCell",
    control = GuildEventCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.eventNoneTip = self:FindGO("EventNoneTip")
  self:UpdateGuildEventInfo()
end
function GuildEventPopUp:OnEnter()
  GuildEventPopUp.super.OnEnter(self)
end
function GuildEventPopUp:UpdateGuildEventInfo()
  local index = self:GetPageIndex() or 1
  self:RefreshView(index)
  self.toggleGrid:GetChild(index - 1).gameObject:GetComponent(UIToggle):Set(true)
end
function GuildEventPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryEventListGuildCmd, self.UpdateGuildEventInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdNewEventGuildCmd, self.UpdateGuildEventInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.Query)
end
function GuildEventPopUp:OnExit()
  GuildEventPopUp.super.OnExit(self)
end
function GuildEventPopUp:Query()
  FunctionGuild.Me():QueryGuildEventList()
end
