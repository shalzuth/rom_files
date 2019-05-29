local BaseCell = autoImport("BaseCell")
ServantActivityInfoCell = class("ServantActivityInfoCell", BaseCell)
local btnStatus = {
  [1] = {
    "com_btn_2s",
    ZhString.Servant_Recommend_Go,
    Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
  },
  [2] = {
    "com_btn_3s",
    ZhString.Servant_Calendar_Book,
    Color(0.1607843137254902, 0.4117647058823529, 0 / 255)
  },
  [3] = {
    "com_btn_3s",
    ZhString.Servant_Calendar_CancelBook,
    Color(0.1607843137254902, 0.4117647058823529, 0 / 255)
  }
}
function ServantActivityInfoCell:Init()
  ServantActivityInfoCell.super.Init(self)
  self:FindObjs()
  self:AddUIEvts()
end
function ServantActivityInfoCell:FindObjs()
  self.bg = self:FindGO("Bg")
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.timeLab = self:FindComponent("Time", UILabel)
  self.duringTimeLab = self:FindComponent("DuringTime", UILabel)
  self.btn = self:FindComponent("Btn", UISprite)
  self.btnLab = self:FindComponent("BtnText", UILabel)
  self.chooseFlag = self:FindGO("ChooseFlag")
end
function ServantActivityInfoCell:AddUIEvts()
  self:AddClickEvent(self.btn.gameObject, function(obj)
    self:OnClickBtn()
  end)
  self:AddClickEvent(self.bg, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function ServantActivityInfoCell:OnClickBtn()
  if self.status ~= self.data:GetStatus() then
    MsgManager.ShowMsgByID(34004)
    return
  end
  local timestamp = self.data:GetStartTimeStamp(5)
  local id = self.data.staticData.id
  local status = self.data:GetStatus()
  if CalendarActivityData.STATUS.GO == status then
    FuncShortCutFunc.Me():CallByID(self.gotoMode)
  else
    local now = Time.unscaledTime
    if nil == self.delayTime or now - self.delayTime >= 1 then
      self.delayTime = now
      local canbook = CalendarActivityData.STATUS.CANBOOK == status
      if canbook then
        local acts = ServantCalendarProxy.Instance:GetBookingDataByDate(timestamp)
        if acts then
          for i = 1, #acts do
            if Table_ServantCalendar[acts[i]].StartTime == self.data.staticData.StartTime then
              MsgManager.ShowMsgByID(34020)
              return
            end
          end
        end
      end
      ServiceNUserProxy.Instance:CallServantReqReservationUserCmd(id, timestamp, canbook)
    else
      MsgManager.ShowMsgByID(49)
    end
  end
end
local TIME_FORMAT = "%s-%s"
local DURINGTIME = "%sh"
function ServantActivityInfoCell:SetData(data)
  self.data = data
  if data then
    local staticData = data.staticData
    self.bg:SetActive(true)
    self.status = data:GetStatus()
    self.duringTimeLab.text = string.format(TIME_FORMAT, staticData.StartTime, staticData.EndTime)
    self.timeLab.text = string.format(DURINGTIME, data:GetDuringHour())
    self.name.text = staticData.Name
    self.gotoMode = staticData.GotoMode
    local exitIcon = IconManager:SetUIIcon(staticData.Icon, self.icon)
    exitIcon = exitIcon or IconManager:SetItemIcon(staticData.Icon, self.icon)
    self:setBtnStatue(data:GetStatus())
  else
    self.bg:SetActive(false)
  end
end
function ServantActivityInfoCell:setBtnStatue(BTNCFG)
  BTNCFG = btnStatus[BTNCFG]
  self.btn.spriteName = BTNCFG[1]
  self.btnLab.text = BTNCFG[2]
  self.btnLab.effectColor = BTNCFG[3]
end
function ServantActivityInfoCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function ServantActivityInfoCell:UpdateChoose()
  if self.data and self.chooseId and self.data.staticData.id == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
