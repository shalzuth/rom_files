autoImport("SocialBaseCell")
local baseCell = autoImport("BaseCell")
FriendBaseCell = class("FriendBaseCell", SocialBaseCell)
function FriendBaseCell:Init()
  self:FindObjs()
  self:InitShow()
end
function FriendBaseCell:FindObjs()
  FriendBaseCell.super.FindObjs(self)
  self.mask = self:FindGO("Mask")
  self.offlinetime = self:FindGO("Offlinetime"):GetComponent(UILabel)
  self.offlinetimeGO = self.offlinetime.gameObject
  self.offlineTip = self:FindGO("OfflineTip"):GetComponent(UILabel)
  self.zone = self:FindGO("Zone"):GetComponent(UILabel)
  self.zoneGO = self.zone.gameObject
end
function FriendBaseCell:InitShow()
  FriendBaseCell.super.InitShow(self)
  self:AddGameObjectComp()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 60000, self.RefreshOfflinetime, self)
end
function FriendBaseCell:SetData(data)
  FriendBaseCell.super.SetData(self, data)
  if data then
    if data.offlinetime == 0 then
      self.offlinetimeGO:SetActive(false)
      self.mask:SetActive(false)
      self.headIcon:SetActive(true, true)
      if data.zoneid and MyselfProxy.Instance:GetZoneId() ~= data.zoneid then
        self.zoneGO:SetActive(true)
        self.zone.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
        self.offlineTip.text = ""
      else
        self.zoneGO:SetActive(false)
        self.offlineTip.text = ZhString.Friend_MapOnline
      end
    else
      self.offlinetimeGO:SetActive(true)
      self.mask:SetActive(true)
      self.headIcon:SetActive(false, true)
      self.zoneGO:SetActive(false)
      self.offlineTip.text = ZhString.Friend_MapOffline
    end
    self:RefreshOfflinetime()
  end
end
function FriendBaseCell:RefreshOfflinetime()
  if self.data and self.data.offlinetime ~= 0 then
    self.offlinetime.text = ClientTimeUtil.GetFormatOfflineTimeStr(self.data.offlinetime)
  end
end
function FriendBaseCell:OnDestroy()
  TimeTickManager.Me():ClearTick(self)
end
