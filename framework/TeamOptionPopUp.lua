TeamOptionPopUp = class("TeamOptionPopUp", ContainerView)
TeamOptionPopUp.ViewType = UIViewType.PopUpLayer
local teamProxy
local defaulTeamDesc = GameConfig.Team.defaulTeamDesc or "%s\229\137\175\230\156\172\229\188\128\231\187\132"
local InputLimitMaxCount = GameConfig.System.team_desc_size or 20
local maxTeamNameLength = GameConfig.Team.maxteamnamelength or 10
function TeamOptionPopUp:Init()
  teamProxy = TeamProxy.Instance
  if self.viewdata then
    self.goal = self.viewdata.viewdata.goal
    self.isPublish = self.viewdata.viewdata.ispublish
  end
  self:InitUI()
  self:_resetOptionChangeFlag()
  self:AddViewInterests()
  local TeamNameTip = self:FindGO("TeamNameTip"):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(TeamNameTip, 3, 90)
  local CurTeamTypeTip = self:FindGO("CurTeamTypeTip"):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(CurTeamTypeTip, 3, 90)
  local TeamDescTip = self:FindGO("TeamDescTip"):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(TeamDescTip, 3, 90)
  local TeamLevel = self:FindGO("TeamLevel", self:FindGO("TeamLevel")):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(TeamLevel, 3, 90)
  local tip = self:FindGO("Tip"):GetComponent(UILabel)
  tip.pivot = UIWidget.Pivot.Left
  tip.transform.localPosition = Vector3(34, -427, 0)
  OverseaHostHelper:FixLabelOverV1(tip, 3, 400)
  local sprite = self:FindGO("Sprite", tip.gameObject)
  sprite.transform.localPosition = Vector3(-17, -2.2, 0)
  local Bg = self:FindGO("Bg")
  local l = self:FindGO("Label", Bg):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(l, 2, 200)
  l.transform.localPosition = Vector3(0, -42, 0)
end
function TeamOptionPopUp.ServerProxy()
  return ServiceSessionTeamProxy.Instance
end
function TeamOptionPopUp:InitUI()
  self.optionPage = self:FindGO("OptionPage")
  self.nameInput = self:FindComponent("TeamNameInput", UIInput)
  self.descInput = self:FindComponent("TeamDescInput", UIInput)
  self.curTeamTypeLab = self:FindComponent("CurTeamTypeLab", UILabel)
  self.filterType = GameConfig.MaskWord.TeamName
  UIUtil.LimitInputCharacter(self.nameInput, maxTeamNameLength, function(str)
    local resultStr = string.gsub(str, " ", "")
    if StringUtil.ChLength(resultStr) < 2 then
      resultStr = teamProxy:IHaveTeam() and teamProxy.myTeam.name or Game.Myself.data.name .. GameConfig.Team.teamname
      MsgManager.ShowMsgByIDTable(883)
    end
    return resultStr
  end)
  self:AddButtonEvent("ConfirmButton", function(go)
    self:ConfirmButton()
  end)
  self.minlvPopUp = self:FindComponent("MinLvPopUp", UIPopupList)
  self.maxlvPopUp = self:FindComponent("MaxLvPopUp", UIPopupList)
  local filtratelevel = GameConfig.Team.filtratelevel
  for i = 1, #filtratelevel do
    self.minlvPopUp:AddItem(filtratelevel[i])
    self.maxlvPopUp:AddItem(filtratelevel[i])
  end
  self.minLvTog = self.minlvPopUp:GetComponentInChildren(UIToggle)
  self.maxLvTog = self.maxlvPopUp:GetComponentInChildren(UIToggle)
  self:AddClickEvent(self.minlvPopUp.gameObject, function(go)
    self:ControlTogEvt(self.minLvTog)
  end)
  self:AddClickEvent(self.maxlvPopUp.gameObject, function(go)
    self:ControlTogEvt(self.maxLvTog)
  end)
  EventDelegate.Add(self.minlvPopUp.onChange, function()
    if self.minlvPopUp.isOpen then
      self:ControlTogEvt(self.minLvTog)
    end
  end)
  EventDelegate.Add(self.maxlvPopUp.onChange, function()
    if self.maxlvPopUp.isOpen then
      self:ControlTogEvt(self.maxLvTog)
    end
  end)
  local minLvSymbol = self:FindComponent("Symbol", TweenRotation, self.minlvPopUp.gameObject)
  EventDelegate.Set(self.minLvTog.onChange, function()
    local value = self.minLvTog.value
    if value then
      minLvSymbol:PlayForward()
    else
      minLvSymbol:PlayReverse()
    end
  end)
  local maxLvSymbol = self:FindComponent("Symbol", TweenRotation, self.maxlvPopUp.gameObject)
  EventDelegate.Set(self.maxLvTog.onChange, function()
    local value = self.maxLvTog.value
    if value then
      maxLvSymbol:PlayForward()
    else
      maxLvSymbol:PlayReverse()
    end
  end)
  local picUpMode = self:FindGO("PickUpMode")
  picUpMode:SetActive(GameConfig.SystemForbid.TeamPickUpMode == nil)
  self.pickUpModeTog_1 = self:FindComponent("PickUpMode_1", UIToggle)
  self.pickUpModeTog_2 = self:FindComponent("PickUpMode_2", UIToggle)
  self:AddClickEvent(self.pickUpModeTog_1.gameObject, function()
    self.pickUpMode = 0
  end)
  self:AddClickEvent(self.pickUpModeTog_2.gameObject, function()
    self.pickUpMode = 1
  end)
  self.autoApplyTip = {
    [0] = ZhString.TeamOptionPopUp_AutoApplyTip1,
    [1] = ZhString.TeamOptionPopUp_AutoApplyTip2,
    [2] = ZhString.TeamOptionPopUp_AutoApplyTip3
  }
  self.autoApplyPopup = self:FindComponent("AutoApplyPopUp", UIPopupList)
  for i = 0, 2 do
    self.autoApplyPopup:AddItem(self.autoApplyTip[i], i)
  end
  EventDelegate.Add(self.descInput.onChange, function()
    local str = self.descInput.value
    local length = StringUtil.Utf8len(str)
    if length > InputLimitMaxCount then
      self.descInput.value = StringUtil.getTextByIndex(str, 1, InputLimitMaxCount)
      MsgManager.ShowMsgByID(28010)
    end
  end)
  local uiTable = self:FindComponent("OptionPage", UITable)
  uiTable:Reposition()
end
function TeamOptionPopUp:ConfirmButton()
  local myTeam = TeamProxy.Instance.myTeam
  local name, desc
  if self.nameInput and (not myTeam or myTeam.name ~= self.nameInput.value) then
    self:_setOptionChangeFlag()
    name = self.nameInput.value
  end
  if self.descInput then
    desc = tostring(self.descInput.value)
  end
  local changeOption = {}
  local optionStateChanged, optionChanged = false, false
  local level1, level2 = tonumber(self.maxlvPopUp.value) or tonumber(self.minlvPopUp.value) or 0, 0
  local minlv, maxlv = math.min(level1, level2), math.max(level1, level2)
  if not myTeam or myTeam.minlv ~= minlv then
    self:_setOptionChangeFlag()
    self:_setStatusOptionChangeFlag()
    local minlvOption = {
      type = SessionTeam_pb.ETEAMDATA_MINLV,
      value = minlv
    }
    table.insert(changeOption, minlvOption)
  end
  if not myTeam or myTeam.maxlv ~= maxlv then
    self:_setOptionChangeFlag()
    self:_setStatusOptionChangeFlag()
    local maxlvOption = {
      type = SessionTeam_pb.ETEAMDATA_MAXLV,
      value = maxlv
    }
    table.insert(changeOption, maxlvOption)
  end
  if not myTeam or self.pickUpMode ~= myTeam.pickupmode then
    self:_setOptionChangeFlag()
    local pickUpOption = {
      type = SessionTeam_pb.ETEAMDATA_PICKUP_MODE,
      value = self.pickUpMode
    }
    table.insert(changeOption, pickUpOption)
  end
  local nowAcceptChoose = math.floor(self.autoApplyPopup.data)
  if nowAcceptChoose ~= self.autoAccept then
    self:_setOptionChangeFlag()
    local autoacceptOption = {
      type = SessionTeam_pb.ETEAMDATA_AUTOACCEPT,
      value = nowAcceptChoose
    }
    table.insert(changeOption, autoacceptOption)
  end
  if not myTeam or myTeam.desc ~= self.descInput.value then
    self:_setOptionChangeFlag()
    if self.descInput then
      local descOption = {
        type = SessionTeam_pb.ETEAMDATA_DESC,
        strvalue = self.descInput.value
      }
      table.insert(changeOption, descOption)
    end
  end
  local teamGoal = self.goal
  if not myTeam or myTeam.type ~= teamGoal then
    self:_setOptionChangeFlag()
    local teamGoalOption = {
      type = SessionTeam_pb.ETEAMDATA_TYPE,
      value = teamGoal
    }
    table.insert(changeOption, teamGoalOption)
  end
  if self.isPublish then
    if not myTeam or myTeam.state ~= SessionTeam_pb.ETEAMSTATE_PUBLISH then
      self:_setStatusOptionChangeFlag()
      local teamStateOption = {
        type = SessionTeam_pb.ETEAMDATA_STATE,
        value = SessionTeam_pb.ETEAMSTATE_PUBLISH
      }
      table.insert(changeOption, teamStateOption)
    end
  elseif self.statusOptionChange then
    local teamStateOption = {
      type = SessionTeam_pb.ETEAMDATA_STATE,
      value = SessionTeam_pb.ETEAMSTATE_FREE
    }
    table.insert(changeOption, teamStateOption)
  end
  if name and FunctionMaskWord.Me():CheckMaskWord(name, self.filterType) then
    MsgManager.ShowMsgByIDTable(2604)
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(desc, self.filterType) then
    MsgManager.ShowMsgByIDTable(2604)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    if self.optionChange or self.statusOptionChange then
      MsgManager.ConfirmMsgByID(371, function()
        self.ServerProxy():CallSetTeamOption(name, changeOption)
        self:CloseUI()
      end)
    else
      self:CloseSelf()
    end
  else
    local teamState = self.isPublish and SessionTeam_pb.ETEAMSTATE_PUBLISH or SessionTeam_pb.ETEAMSTATE_FREE
    ServiceSessionTeamProxy.Instance:CallCreateTeam(minlv, maxlv, self.goal, nowAcceptChoose, name, teamState, desc)
    self:CloseUI()
  end
end
function TeamOptionPopUp:CloseUI()
  self:CloseSelf()
  if self.isPublish then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamMemberListPopUp
    })
  end
end
function TeamOptionPopUp:_resetOptionChangeFlag()
  self.optionChange, self.optionStateChanged = false, false
end
function TeamOptionPopUp:_setOptionChangeFlag(value)
  value = value or true
  local myTeam = TeamProxy.Instance.myTeam
  if nil ~= myTeam and self.optionChange ~= value then
    self.optionChange = value
  end
end
function TeamOptionPopUp:_setStatusOptionChangeFlag(value)
  value = value or true
  local myTeam = TeamProxy.Instance.myTeam
  if nil ~= myTeam and self.statusOptionChange ~= value then
    self.statusOptionChange = value
  end
end
function TeamOptionPopUp:ControlTogEvt(tog)
  if not tog.value then
    if self.nowCtlTog then
      self.nowCtlTog.value = false
    end
    self.nowCtlTog = tog
    tog.value = true
  else
    tog.value = false
    self.nowCtlTog = nil
  end
  return tog.value
end
function TeamOptionPopUp:ClickTarget(cellCtl)
  cellCtl:SetChoose(true)
  self.nowTarget = cellCtl.data
end
function TeamOptionPopUp:UpdateOption()
  if not teamProxy:IHaveTeam() then
    self.curTeamTypeLab.text = Table_TeamGoals[self.goal].NameZh
    self.nameInput.value = Game.Myself.data.name .. GameConfig.Team.teamname
    local filterLvCfg = GameConfig.Team.filtratelevel
    self.minlvPopUp.value = filterLvCfg[1]
    self.maxlvPopUp.value = filterLvCfg[#filterLvCfg]
    self.pickUpModeTog_1.value = true
    self.pickUpModeTog_2.value = false
    self.autoAccept = GameConfig.Team.defaultauto
    self.autoApplyPopup.value = self.autoApplyTip[self.autoAccept]
    self.descInput.value = string.format(defaulTeamDesc, Table_TeamGoals[self.goal].NameZh)
    self.pickUpMode = GameConfig.Team.pickupmode
    return
  end
  local myTeam = teamProxy.myTeam
  self.nameInput.value = myTeam.name
  self.minlvPopUp.value = tostring(myTeam.minlv)
  self.maxlvPopUp.value = tostring(myTeam.maxlv)
  self.pickUpMode = myTeam.pickupmode
  self.pickUpModeTog_1.value = myTeam.pickupmode == 0
  self.pickUpModeTog_2.value = myTeam.pickupmode == 1
  self.autoAccept = myTeam.autoaccept or 0
  self.autoApplyPopup.value = self.autoApplyTip[self.autoAccept]
  self.curTeamTypeLab.text = Table_TeamGoals[self.goal].NameZh
  self.descInput.value = self.isPublish and string.format(defaulTeamDesc, Table_TeamGoals[self.goal].NameZh) or myTeam.desc
  if self.descInput.value == "\232\135\170\231\148\177\233\152\159\228\188\141" then
    self.descInput.value = OverSea.LangManager.Instance():GetLangByKey(self.descInput.value)
  end
end
function TeamOptionPopUp:AddViewInterests()
end
function TeamOptionPopUp:OnEnter()
  TeamOptionPopUp.super.OnEnter(self)
  self:UpdateOption()
end
function TeamOptionPopUp:OnExit()
  self.minlvPopUp = nil
  self.maxlvPopUp = nil
  self.minLvTog = nil
  self.maxLvTog = nil
  self.descInput = nil
  TeamOptionPopUp.super.OnExit(self)
end
