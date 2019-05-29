NewServerSignInProxy = class("NewServerSignInProxy", pm.Proxy)
NewServerSignInProxy.SignInType = {
  Normal = 0,
  WithSmallGift = 1,
  WithLargeGift = 2,
  WithQuestion = 3
}
NewServerSignInProxy.PeriodDayCount = 30
function NewServerSignInProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "NewServerSignInProxy"
  if not NewServerSignInProxy.Instance then
    NewServerSignInProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end
function NewServerSignInProxy:Init()
  self.serverLineGroup = 1
  self.isTodayQuestionAnswered = false
  self.isSignInNotifyReceived = false
  self:SetSignInInfo()
end
function NewServerSignInProxy:InitRewardData()
  if self.dayRewardDataMap and self.dayTypeMap then
    return
  end
  self.dayRewardDataMap = {}
  self.dayTypeMap = {}
  self.maxDayCount = 0
  local isOldTable, day, rewardInfo, rewardItem
  for id, data in pairs(self.staticRewardTable) do
    if isOldTable == nil then
      isOldTable = data.ServerID == nil
    end
    if isOldTable or data.ServerID == self.serverLineGroup then
      day = isOldTable and id or data.Days
      self.dayRewardDataMap[day] = {}
      for i = 1, #data.RewardItems do
        rewardInfo = data.RewardItems[i]
        rewardItem = ItemData.new("Reward", rewardInfo[1])
        rewardItem.num = rewardInfo[2]
        TableUtility.ArrayPushBack(self.dayRewardDataMap[day], rewardItem)
      end
      self.dayTypeMap[day] = data.Type
      self.maxDayCount = self.maxDayCount + 1
    end
  end
end
function NewServerSignInProxy:SetSignInInfo(signedCount, isTodaySigned, isCatShowed)
  self.signedCount = signedCount or 0
  self.isTodaySigned = isTodaySigned == nil and true or isTodaySigned
  self.isCatShowed = isCatShowed == nil and true or isCatShowed
  LogUtility.InfoFormat("SignInInfo has been set to: signedCount:{0}, isTodaySigned:{1}, isCatShowed:{2}", self.signedCount, self.isTodaySigned, self.isCatShowed)
end
function NewServerSignInProxy:CallSignIn()
  ServiceNUserProxy.Instance:CallSignInUserCmd()
end
function NewServerSignInProxy:RecvSignInResult(isSuccess)
  if isSuccess then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SIGNIN_DAY)
    LogUtility.Info("Today SignIn Success.")
  else
    LogUtility.Warning("Today SignIn Failed.")
  end
end
function NewServerSignInProxy:RecvSignInNotify(signedCount, todaySigned, catShowed)
  self:SetSignInInfo(signedCount, self:IsTrue(todaySigned), self:IsTrue(catShowed))
  if not self.isSignInNotifyReceived then
    self:TryGetCurrentLineGroup()
    self:InitStaticTables()
  end
  self.isSignInNotifyReceived = true
end
function NewServerSignInProxy:TryGetCurrentLineGroup()
  local serverData = FunctionLogin.Me():getCurServerData()
  if not serverData then
    LogUtility.Error("NewServerSignInProxy: Cannot find current server data!")
    return
  end
  local linegroup = serverData.linegroup
  if linegroup then
    self.serverLineGroup = linegroup
    LogUtility.InfoFormat("NewServerSignInProxy: linegroup has been set to {0}", linegroup)
  end
end
function NewServerSignInProxy:InitStaticTables()
  self.staticTextTable = _G.Table_SigninText or _G.Table_Signin
  self.staticRewardTable = _G.Table_SigninReward or _G.Table_Signin
  self:InitRewardData()
end
function NewServerSignInProxy:IsRewardCanGet(day)
  return day == self.signedCount + 1 and not self.isTodaySigned
end
function NewServerSignInProxy:IsDayWithSmallGift(day)
  return self:IsDayOfType(day, NewServerSignInProxy.SignInType.WithSmallGift)
end
function NewServerSignInProxy:IsDayWithLargeGift(day)
  return self:IsDayOfType(day, NewServerSignInProxy.SignInType.WithLargeGift)
end
function NewServerSignInProxy:IsDayWithQuestion(day)
  return self:IsDayOfType(day, NewServerSignInProxy.SignInType.WithQuestion)
end
function NewServerSignInProxy:IsDayOfType(day, type)
  local t = self:GetRewardTypeOfDay(day)
  if not t then
    return nil
  end
  return t == type
end
function NewServerSignInProxy:IsSignInNotifyReceived()
  local menuId = GameConfig.SystemOpen_MenuId.NewSignIn
  if menuId and not FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
    return false
  end
  return self.isSignInNotifyReceived
end
function NewServerSignInProxy:GetToday()
  if self.isTodaySigned then
    return self.signedCount
  else
    local today = self.signedCount + 1
    if today <= self.maxDayCount then
      return today
    else
      return nil
    end
  end
end
function NewServerSignInProxy:GetRewardDataOfDay(day)
  return self.dayRewardDataMap[self:GetRemainderOfDay(day)]
end
function NewServerSignInProxy:GetStaticTextDataOfDay(day)
  return self.staticTextTable[self:GetRemainderOfDay(day, self:GetStaticTextDataCount())]
end
function NewServerSignInProxy:GetRewardTypeOfDay(day)
  return self.dayTypeMap[self:GetRemainderOfDay(day)]
end
function NewServerSignInProxy:GetStaticTextDataCount()
  return #self.staticTextTable
end
function NewServerSignInProxy:SetTodayQuestionAnswered()
  self.isTodayQuestionAnswered = true
end
function NewServerSignInProxy:SetSignInNotifyNeverReceived()
  self.isSignInNotifyReceived = false
end
function NewServerSignInProxy:GetRemainderOfDay(day, divisor)
  divisor = divisor or self.maxDayCount or NewServerSignInProxy.PeriodDayCount
  return (day - 1) % divisor + 1
end
function NewServerSignInProxy:IsTrue(v)
  local t = type(v)
  if t == "boolean" then
    return v
  elseif t == "number" then
    return v ~= 0
  else
    return v ~= nil
  end
end
