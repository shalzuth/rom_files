autoImport("EngageDateData")
autoImport("WeddingInfoData")
autoImport("WeddingPackageData")
autoImport("WeddingInviteData")
WeddingProxy = class("WeddingProxy", pm.Proxy)
WeddingProxy.Instance = nil
WeddingProxy.NAME = "WeddingProxy"
MaritalType = {
  Single = ProtoCommon_pb.EMARITAL_SINGLE,
  Engage = ProtoCommon_pb.EMARITAL_RESERVED,
  Married = ProtoCommon_pb.EMARITAL_MARRIED,
  DivorcePunish = ProtoCommon_pb.EMARITAL_DIVORCE_PUNISH
}
WeddingProxy.EngageViewEnum = {Check = 1, Book = 2}
local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
local _EngageRefresh = GameConfig.Wedding.EngageRefresh + 86400
function WeddingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or WeddingProxy.NAME
  if WeddingProxy.Instance == nil then
    WeddingProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function WeddingProxy:Init()
  self.dateList = {}
  self.dateMap = {}
  self.weddingMap = {}
  self.weddingRingid = {}
  self.inviteMap = {}
  self.inviteList = {}
  self.weddingActDiscount = {}
end
function WeddingProxy:CallWeddingInviteCCmd(charids)
  for i = 1, #charids do
    if self.inviteMap[charids[i]] ~= nil then
      return
    end
  end
  ServiceWeddingCCmdProxy.Instance:CallWeddingInviteCCmd(charids)
end
function WeddingProxy:RecvReqWeddingDateListCCmd(serverData)
  _ArrayClear(self.dateList)
  _TableClear(self.dateMap)
  for i = 1, #serverData.date_list do
    local data = EngageDateData.new(serverData.date_list[i])
    _ArrayPushBack(self.dateList, data)
    self.dateMap[data.timeStamp] = data
  end
  self.isUseTicket = serverData.use_ticket
end
function WeddingProxy:RecvReqWeddingOneDayListCCmd(serverData)
  local date = self.dateMap[serverData.date]
  if date ~= nil then
    date:SetDayList(serverData.info)
  end
end
function WeddingProxy:RecvReqWeddingInfoCCmd(serverData)
  local id = serverData.id
  local info = serverData.info
  local data = self.weddingMap[id]
  if data == nil then
    self.weddingMap[id] = WeddingInfoData.new(info)
  else
    data:SetData(info)
  end
end
function WeddingProxy:RecvNtfWeddingInfoCCmd(serverData)
  local info = serverData.info
  if info.id ~= 0 then
    self.weddingInfo = WeddingInfoData.new(info)
  else
    self.weddingInfo = nil
  end
end
function WeddingProxy:RecvUpdateWeddingManualCCmd(serverData)
  local manual = serverData.manual
  local packageList = self:GetWeddingPackageList()
  for i = 1, #manual.packageids do
    for j = 1, #packageList do
      local package = packageList[j]
      if manual.packageids[i] == package.id then
        package:SetPurchase(true)
        break
      end
    end
  end
  self.weddingRingid = manual.ringid
  for i = 1, #serverData.invitees do
    local charid = serverData.invitees[i].charid
    self.inviteMap[charid] = charid
  end
  self.manualPhotoIndex = manual.photoindex
  self.manualPhotoTime = manual.phototime
end
function WeddingProxy:RecvWeddingSwitchQuestionCCmd(serverData)
  if serverData.onoff then
    self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WeddingQuestionView,
      viewdata = {isNpcFuncView = true}
    })
  end
end
function WeddingProxy:UpdateMarital(oldValue, newValue)
  if oldValue ~= newValue and oldValue == MaritalType.Engage then
    self.weddingPackageList = nil
    self.weddingRingid = nil
    self.manualPhotoIndex = nil
    self.manualPhotoTime = nil
    _TableClear(self.inviteMap)
  end
end
function WeddingProxy:InitWeddingService()
  self.weddingPackageList = {}
  for k, v in pairs(Table_WeddingService) do
    if v.Type == 2 then
      local data = WeddingPackageData.new(k)
      _ArrayPushBack(self.weddingPackageList, data)
    end
  end
  table.sort(self.weddingPackageList, WeddingProxy._SortWeddingService)
end
function WeddingProxy._SortWeddingService(l, r)
  return l.id < r.id
end
function WeddingProxy:IsSelfSingle()
  local _Myself = Game.Myself
  if _Myself then
    local marital = _Myself.data.userdata:Get(UDEnum.MARITAL)
    return marital == MaritalType.Single or marital == MaritalType.DivorcePunish
  end
  return true
end
function WeddingProxy:IsSelfEngage()
  local _Myself = Game.Myself
  if _Myself then
    return _Myself.data.userdata:Get(UDEnum.MARITAL) == MaritalType.Engage
  end
  return false
end
function WeddingProxy:IsSelfMarried()
  local _Myself = Game.Myself
  if _Myself then
    return _Myself.data.userdata:Get(UDEnum.MARITAL) == MaritalType.Married
  end
  return false
end
function WeddingProxy:IsSelfDivorcePunish()
  local _Myself = Game.Myself
  if _Myself then
    return _Myself.data.userdata:Get(UDEnum.MARITAL) == MaritalType.DivorcePunish
  end
  return false
end
function WeddingProxy:IsEngageNeedRefresh(timeStamp)
  if timeStamp ~= nil then
    local serverTime = ServerTime.CurServerTime() / 1000
    local offsetTime = serverTime - timeStamp
    if offsetTime >= _EngageRefresh then
      return true
    end
  end
  return false
end
function WeddingProxy:IsSelfInWeddingTime()
  if self.weddingInfo ~= nil then
    local serverTime = ServerTime.CurServerTime() / 1000
    local time = os.date("*t", serverTime)
    return self.weddingInfo:IsWeddingTime(time.year, time.month, time.day, time.hour)
  end
  return false
end
function WeddingProxy:IsEngageUseTicket()
  return self.isUseTicket
end
function WeddingProxy:IsInWedding(guid)
  if self.weddingInfo ~= nil then
    return self.weddingInfo:GetCharData(guid) ~= nil
  end
  return false
end
function WeddingProxy:CanSingleDivorce()
  if self.weddingInfo ~= nil then
    return self.weddingInfo.canSingleDivorce
  end
  return false
end
function WeddingProxy:CheckIsEnough(price)
  local id = price.id
  local num = price.num
  local count = self:GetItemCount(id)
  return num <= count
end
function WeddingProxy:GetDateData(timeStamp)
  return self.dateMap[timeStamp]
end
function WeddingProxy:GetDateList()
  return self.dateList
end
function WeddingProxy:GetWeddingData(id)
  return self.weddingMap[id]
end
function WeddingProxy:GetWeddingInfo()
  return self.weddingInfo
end
function WeddingProxy:GetWeddingPackageList()
  if self.weddingPackageList == nil then
    self:InitWeddingService()
  end
  return self.weddingPackageList
end
function WeddingProxy:GetWeddingPackagePrice(packageid)
  if packageid ~= nil then
    local packageData, purchasedData
    local list = self:GetWeddingPackageList()
    for i = 1, #list do
      local package = list[i]
      if package.isPurchased then
        purchasedData = package
      end
      if package.id == packageid then
        packageData = package
      end
    end
    if packageData ~= nil then
      local price
      local serviceMap = packageData:GetServiceMap()
      for k, v in pairs(serviceMap) do
        if purchasedData ~= nil and purchasedData:GetServicePriceById(k) ~= nil then
        elseif price == nil then
          price = {}
          for i = 1, #v do
            price[i] = {}
            price[i].id = v[i].id
            price[i].num = v[i].num
          end
        else
          for j = 1, #price do
            for i = 1, #v do
              if v[i].id == price[j].id then
                price[j].num = price[j].num + v[i].num
              end
            end
          end
        end
      end
      return price
    end
  end
end
function WeddingProxy:GetItemCount(itemid)
  local moneyId = GameConfig.MoneyId
  if itemid == moneyId.Zeny then
    return MyselfProxy.Instance:GetROB()
  elseif itemid == moneyId.Lottery then
    return MyselfProxy.Instance:GetLottery()
  else
    return BagProxy.Instance:GetItemNumByStaticID(itemid)
  end
end
function WeddingProxy:GetWeddingRingid()
  return self.weddingRingid
end
function WeddingProxy:GetInviteFriendList()
  _ArrayClear(self.inviteList)
  local list = FriendProxy.Instance:GetFriendData()
  if list ~= nil then
    for i = 1, #list do
      if not self:IsInWedding(list[i].guid) then
        local data = WeddingInviteData.new()
        data:SetFriendData(list[i])
        if self.inviteMap[data.guid] then
          data:SetInvited(true)
        end
        _ArrayPushBack(self.inviteList, data)
      end
    end
    table.sort(self.inviteList, self._SortInviteList)
  end
  return self.inviteList
end
function WeddingProxy:GetInviteGuildList()
  _ArrayClear(self.inviteList)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local list = myGuildData:GetMemberList()
    for i = 1, #list do
      if not self:IsInWedding(list[i].id) then
        local data = WeddingInviteData.new()
        data:SetGuildData(list[i])
        if self.inviteMap[data.guid] then
          data:SetInvited(true)
        end
        _ArrayPushBack(self.inviteList, data)
      end
    end
    table.sort(self.inviteList, self._SortInviteList)
  end
  return self.inviteList
end
function WeddingProxy:GetInviteNearList()
  _ArrayClear(self.inviteList)
  local map = NSceneUserProxy.Instance:GetAll()
  if map ~= nil then
    for k, v in pairs(map) do
      local user = v.data
      if not self:IsInWedding(user.id) then
        local data = WeddingInviteData.new()
        data:SetCreatureData(user)
        if self.inviteMap[data.guid] then
          data:SetInvited(true)
        end
        _ArrayPushBack(self.inviteList, data)
      end
    end
  end
  return self.inviteList
end
function WeddingProxy._SortInviteList(l, r)
  if l.isInvited == r.isInvited then
    return l.offlinetime < r.offlinetime
  else
    return not l.isInvited
  end
end
function WeddingProxy:GetInviteCount()
  local count = 0
  for k, v in pairs(self.inviteMap) do
    count = count + 1
  end
  return count
end
function WeddingProxy:GetPortraitInfo(guid)
  if self.weddingInfo ~= nil then
    return self.weddingInfo:GetCharData(guid)
  end
  return nil
end
function WeddingProxy:GetPartnerData()
  if self.weddingInfo ~= nil then
    return self.weddingInfo:GetPartnerData()
  end
  return nil
end
function WeddingProxy:GetPartnerName()
  local data = self:GetPartnerData()
  if data ~= nil then
    return data.name
  end
  return ""
end
function WeddingProxy:Set_Courtship_PlayerId(playerid, ismaster)
  self.courtship_PlayerId = playerid
  self.courtship_Ismaster = ismaster
end
function WeddingProxy:Get_Courtship_PlayerId()
  return self.courtship_PlayerId, self.courtship_Ismaster
end
function WeddingProxy:IsHandPartner()
  local partnerId
  if self.weddingInfo == nil then
    return false
  end
  partnerId = self.weddingInfo:GetPartnerGuid()
  if partnerId == nil or partnerId == 0 then
    return false
  end
  local followId
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  if isHandFollow == false then
    followId = Game.Myself:Client_GetHandInHandFollower()
  else
    followId = Game.Myself:Client_GetFollowLeaderID()
  end
  return followId == partnerId
end
function WeddingProxy:AddDiscount(key, discount)
  self.weddingActDiscount[key] = discount
end
function WeddingProxy:ClearDiscount(key)
  if self.weddingActDiscount[key] then
    self.weddingActDiscount[key] = nil
  end
end
function WeddingProxy:GetDiscountByID(key)
  return self.weddingActDiscount[key]
end
