autoImport("WrapCellHelper")
autoImport("ServantRecommendCell")
autoImport("ServantCalendarView")
local BTN_BG_IMG = {
  "taskmanual_btn_1",
  "taskmanual_btn_2"
}
ServantRecommendView = class("ServantRecommendView", SubView)
ServantRecommendView._ColorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
ServantRecommendView._ColorTitleGray = ColorUtil.TitleGray
local ColorEffectOrange = ColorUtil.ButtonLabelOrange
local ColorEffectBlue = ColorUtil.ButtonLabelBlue
local Prefab_Path = ResourcePathHelper.UIView("ServantRecommendView")
function ServantRecommendView:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:AddViewEvts()
  self.chooseTypeId = 1
  self:ShowUI(self.chooseTypeId)
  self:UpdateWeekLimited()
end
function ServantRecommendView:FindObjs()
  self:LoadSubView()
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.table = self:FindComponent("ItemWrap", UITable)
  self.cellCtl = UIGridListCtrl.new(self.table, ServantRecommendCell, "ServantRecommendCell")
  self.calendarBtn = self:FindGO("CalendarTog")
  self.recommendBtn = self:FindGO("RecommendTog")
  self.calendarBtnImg = self.calendarBtn:GetComponent(UISprite)
  self.recommendBtnImg = self.recommendBtn:GetComponent(UISprite)
  self.calendarLab = self:FindComponent("Lab", UILabel, self.calendarBtn)
  self.calendarLab.text = ZhString.Servant_Calendar_CalendarTogLab
  self.recommendLab = self:FindComponent("Lab", UILabel, self.recommendBtn)
  self.recommendLab.text = ZhString.Servant_Calendar_RecommendTogLab
  self.recommendLab.fontSize = 19
  self.recommendBtnImg.height = 68
  self.calendarLab.fontSize = 19
  self.calendarBtnImg.height = 68
  self.recommendBtn.transform.localPosition = Vector3(57, 308, 0)
  self.calPos = self:FindGO("calendarViewPos")
  self.recomPos = self:FindGO("recommendPos")
  self.helpBtn = self:FindGO("HelpBtn")
  self:SetBtn()
  local dailyObj = self:FindGO("DailyToggle")
  self.dailyToggle = dailyObj:GetComponent(UIToggle)
  self.dailyLab = dailyObj:GetComponent(UILabel)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_DAY, dailyObj, 6, {0, 6})
  self.dailyLab.text = ZhString.Servant_Recommend_PageDaily
  local weekObj = self:FindGO("WeeklyToggle")
  self.weeklyToggle = weekObj:GetComponent(UIToggle)
  self.weeklyLab = weekObj:GetComponent(UILabel)
  self.weeklyLab.text = ZhString.Servant_Recommend_PageWeek
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_WEEK, weekObj, 6, {0, 6})
  local guideObj = self:FindGO("GuideToggle")
  self.guideToggle = guideObj:GetComponent(UIToggle)
  self.guideLab = guideObj:GetComponent(UILabel)
  self.guideLab.text = ZhString.Servant_Recommend_PageGuide
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_FOREVER, guideObj, 6, {0, 6})
  self.weekLimitedLab = self:FindComponent("WeekLimitedLab", UILabel)
  self.fixedWeekLimitedLab = self:FindComponent("FixedWeekLimitedLab", UILabel)
  self.fixedWeekLimitedLab.text = ZhString.Servant_Recommend_WeeklyLimited
  self.favoriteItem = self:FindComponent("FavoriteItem", UISprite)
  self.empty = self:FindGO("Empty")
  local emptyLab = self:FindComponent("EmptyLab", UILabel)
  emptyLab.text = ZhString.Servant_Recommend_EmptyWeek
  OverseaHostHelper:FixLabelOverV1(self.fixedWeekLimitedLab, 3, 300)
  self.favoriteItem.transform.localPosition = Vector3(22, 0, 0)
end
local favorCFG = GameConfig.Servant.npcFavoriteItemid or {}
local maxLimited = GameConfig.Servant.recommend_max_coin or 4500
function ServantRecommendView:UpdateWeekLimited()
  local myServant = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or -1
  local iconName = favorCFG[myServant] and Table_Item[favorCFG[myServant]] and Table_Item[favorCFG[myServant]].Icon or ""
  IconManager:SetItemIcon(iconName, self.favoriteItem)
  local weeknum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SERVANT_RECOMMEND_COIN) or 0
  self.weekLimitedLab.text = string.format(ZhString.GuildBuilding_Submit_MatNum, weeknum, maxLimited)
end
function ServantRecommendView:PageToggleChange(toggle, label, toggleColor, normalColor, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        self.chooseTypeId = param
        handler(self, param)
      end
    else
      label.color = normalColor
    end
  end)
end
function ServantRecommendView:SetBtn(var)
  self.calendarLab.effectColor = var and ColorEffectOrange or ColorEffectBlue
  self.recommendLab.effectColor = var and ColorEffectBlue or ColorEffectOrange
  self.calendarBtnImg.spriteName = var and BTN_BG_IMG[2] or BTN_BG_IMG[1]
  self.recommendBtnImg.spriteName = var and BTN_BG_IMG[1] or BTN_BG_IMG[2]
  self.isCalendar = var
end
function ServantRecommendView:AddUIEvts()
  self:AddClickEvent(self.helpBtn, function()
    local data = Table_Help[30000]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
  self:AddClickEvent(self.calendarBtn, function(go)
    if not self.calendarView then
      self.calendarView = self:AddSubView("ServantCalendarView", ServantCalendarView)
    end
    self:SetBtn(true)
    self:Show(self.calPos)
    self:Hide(self.recomPos)
    self.calendarView:OnClickWeekTog()
  end)
  self:AddClickEvent(self.recommendBtn, function(go)
    self:SetBtn()
    self:Hide(self.calPos)
    self:Show(self.recomPos)
    self.container:SetMainTexture()
    self:ShowUI(self.chooseTypeId)
  end)
  self:PageToggleChange(self.dailyToggle, self.dailyLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 1)
  self:PageToggleChange(self.weeklyToggle, self.weeklyLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 2)
  self:PageToggleChange(self.guideToggle, self.guideLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 3)
end
function ServantRecommendView:LoadSubView()
  local container = self:FindGO("recommendView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantRecommendView"
end
function ServantRecommendView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.NUserRecommendServantUserCmd, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateWeekLimited)
end
function ServantRecommendView:RecvRecommendServant(note)
  self:ShowUI(self.chooseTypeId)
end
function ServantRecommendView:ShowTexture()
  if self.isCalendar then
    local _, m = ServantCalendarProxy.Instance:ViewDate()
    self.container:SetSeasonTexture(m)
  else
    self.container:SetMainTexture()
  end
end
function ServantRecommendView:ShowUI(type)
  self.fixedWeekLimitedLab.gameObject:SetActive(type ~= 3)
  local data = ServantRecommendProxy.Instance:GetRecommendDataByType(type) or {}
  self.empty:SetActive(#data <= 0)
  self.cellCtl:ResetDatas(data)
  self.table:Reposition()
  self.scrollView:ResetPosition()
end
