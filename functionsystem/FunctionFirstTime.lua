FunctionFirstTime = class("FunctionFirstTime")
FunctionFirstTime.SkillOverFlow = 0
FunctionFirstTime.ExchangeCard = 1
FunctionFirstTime.ComposeCard = 2
FunctionFirstTime.Lottery = 4
FunctionFirstTime.LotteryEquip = 6
FunctionFirstTime.LotteryCard = 7
FunctionFirstTime.LotteryMagic = 8
FunctionFirstTime.SocialRecall = 9
FunctionFirstTime.DecomposeCard = 10
function FunctionFirstTime.Me()
  if nil == FunctionFirstTime.me then
    FunctionFirstTime.me = FunctionFirstTime.new()
  end
  return FunctionFirstTime.me
end
function FunctionFirstTime:ctor()
end
function FunctionFirstTime:SyncServerRecord(firstTime)
  self.firstTime = firstTime
end
function FunctionFirstTime:IsFirstTime(flag)
  if self.firstTime then
    return BitUtil.band(self.firstTime, flag) <= 0
  end
  errorLog("\230\156\141\229\138\161\229\153\168\230\178\161\230\156\137\229\144\140\230\173\165\230\157\165 \233\166\150\230\172\161\230\156\186\229\136\182\231\154\132\229\128\188")
  return false
end
function FunctionFirstTime:DoneFirstTime(flag)
  local newfirstTime = BitUtil.setbit(self.firstTime, flag)
  if newfirstTime ~= self.firstTime then
    self.firstTime = newfirstTime
    ServiceUserEventProxy.Instance:CallFirstActionUserEvent(newfirstTime)
  end
end
