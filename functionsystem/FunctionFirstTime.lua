FunctionFirstTime = class("FunctionFirstTime")

--第一次手动技能快捷栏满时再学技能
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
	if(self.firstTime) then
		return BitUtil.band(self.firstTime,flag) <= 0
	end
	errorLog("服务器没有同步来 首次机制的值")
	return false
end

function FunctionFirstTime:DoneFirstTime(flag)
	local newfirstTime = BitUtil.setbit(self.firstTime,flag)
	if(newfirstTime~=self.firstTime) then
		self.firstTime = newfirstTime
		ServiceUserEventProxy.Instance:CallFirstActionUserEvent(newfirstTime)
	end
end