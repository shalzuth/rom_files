PostCell = class("PostCell", BaseCell)
function PostCell:Init()
  PostCell.super.Init(self)
  self:InitCell()
end
local BG_TEXTURE = "bg_01"
function PostCell:InitCell()
  local bg = self:FindGO("bg")
  self:SetEvent(bg, function()
    self:PassEvent(PostView.ClickCell, self)
  end)
  self.postName = self:FindComponent("PostName", UILabel)
  self.time = self:FindGO("Time"):GetComponent(UILabel)
  self.expiretimeTip = self:FindGO("ExpireTime"):GetComponent(UILabel)
  self.chooseFlag = self:FindGO("ChooseFlag")
  self.multiChooseFlag = self:FindGO("MultiChooseFlag")
  self.multiChoosen = self:FindGO("MultiChoosen")
  self.mailIcon = self:FindComponent("MailIcon", UISprite)
  self.unread = self:FindGO("Unread")
  self.receiveLab = self:FindComponent("ReceiveLab", UILabel)
  self.pos = self:FindGO("Pos")
  self.empty = self:FindGO("Empty")
  local emptybg1 = self:FindComponent("EmptyBg1", UITexture)
  local emptybg2 = self:FindComponent("EmptyBg2", UITexture)
  PictureManager.Instance:SetUI(BG_TEXTURE, emptybg1)
  PictureManager.Instance:SetUI(BG_TEXTURE, emptybg2)
  OverseaHostHelper:FixLabelOverV1(self.expiretimeTip, 3, 160)
end
local defaultSeconds = GameConfig.System.sysmail_overtime * 24 * 60 * 60
local iconName
function PostCell:SetData(data)
  self.pos:SetActive(nil ~= data)
  self.empty:SetActive(nil == data)
  if data then
    self.postName.text = data.title
    if data:HasPostItems() then
      if data.status == PostProxy.STATUS.ATTACH then
        iconName = "icon_2"
        self:Show(self.receiveLab)
        self:Hide(self.time)
        self.receiveLab.text = ZhString.Post_HasReceived
      else
        self:Hide(self.receiveLab)
        iconName = "icon_1"
        self:Show(self.time)
        self.time.text = ClientTimeUtil.GetFormatDayTimeStr(data.time)
      end
    elseif data.status == PostProxy.STATUS.READ or data.status == PostProxy.STATUS.ATTACH then
      iconName = "emaiL_icon_02"
      self:Show(self.receiveLab)
      self:Hide(self.time)
      self.receiveLab.text = ZhString.Post_HasChecked
    else
      self:Hide(self.receiveLab)
      iconName = "emaiL_icon_01"
      self:Show(self.time)
      self.time.text = ClientTimeUtil.GetFormatDayTimeStr(data.time)
    end
    self.unread:SetActive(data.unread)
    IconManager:SetUIIcon(iconName, self.mailIcon)
    self.mailIcon:MakePixelPerfect()
    local leftTime = 0
    if data.expiretime == 0 then
      leftTime = data.time + defaultSeconds - ServerTime.CurServerTime() / 1000
    else
      leftTime = data.expiretime - data.time
    end
    if leftTime <= 0 then
      self.expiretimeTip.text = ZhString.Post_Expired
    elseif self.timeTick == nil then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self, data.id)
    end
  end
  self.data = data
  self:UpdateChoose()
  self:UpdateMultiChoose()
end
function PostCell:UpdateCountdown()
  if not self.data then
    return
  end
  if self:ObjIsNil(self.gameObject) then
    if self.timeTick then
      TimeTickManager.Me():ClearTick(self, self.data.id)
    end
    return
  end
  local leftTimecd = 0
  if self.data.expiretime == 0 then
    leftTimecd = self.data.time + defaultSeconds - ServerTime.CurServerTime() / 1000
  else
    leftTimecd = self.data.expiretime - ServerTime.CurServerTime() / 1000
  end
  if leftTimecd <= 0 then
    if self.timeTick ~= nil then
      TimeTickManager.Me():ClearTick(self, self.data.id)
      self.timeTick = nil
    end
    self.expiretimeTip.text = ZhString.Post_Expired
    return
  end
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTimecd)
  if day == 0 and hour == 0 then
    self.expiretimeTip.text = string.format(ZhString.Post_Countdowns, min, sec)
  else
    self.expiretimeTip.text = string.format(ZhString.Post_Countdown, day, hour)
  end
end
function PostCell:ShowMultiBox(var)
  self.multiChooseFlag:SetActive(var)
end
function PostCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function PostCell:UpdateMultiChoose()
  self.multiChoosen:SetActive(nil ~= self.data and self.data:IsMultiChoosenPost())
end
function PostCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
function PostCell:OnRemove()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self, self.data.id)
    self.timeTick = nil
  end
  PictureManager.Instance:UnLoadUI()
end
