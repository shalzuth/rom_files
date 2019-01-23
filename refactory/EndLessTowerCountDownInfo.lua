EndLessTowerCountDownInfo = class("EndLessTowerCountDownInfo", CoreView);

local PATH = ResourcePathHelper.UICell("EndLessTowerCountDownInfo");

function EndLessTowerCountDownInfo:ctor(parent)
	self.parent = parent;
end

function EndLessTowerCountDownInfo:CreateSelf()
	if(self.gameObject ~= nil)then
		return;
	end

	self.gameObject = self:LoadPreferb_ByFullPath(PATH, self.parent);
	self:InitView();
end

function EndLessTowerCountDownInfo:InitView()
	self.label = self:FindComponent("Label", UILabel);
	self.countDownTime = self:FindComponent("CountDownTime", UILabel);
end

function EndLessTowerCountDownInfo:OnEnter()
	EventManager.Me():AddEventListener(ServiceEvent.UserEventQueryResetTimeEventCmd, self.SetData, self)
end

function EndLessTowerCountDownInfo:SetData(resettime)

	local dateFormat = "%m月%d日%H点%M分%S秒";
	helplog(os.date(dateFormat, resettime));

	self.endStamp = resettime * 1000;

	local delta = ServerTime.ServerDeltaSecondTime(self.endStamp);
	if(delta < 0)then
		self:OnExit();
		return;
	end

	if(self.timeTick == nil)then
		self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateTime, self, 1)
	end
end

function EndLessTowerCountDownInfo:UpdateTime()
	if(self.endStamp == nil)then
		return;
	end

	local delta = ServerTime.ServerDeltaSecondTime(self.endStamp);
	local day,hour,min,sec = ClientTimeUtil.FormatTimeBySec( delta )
	self.countDownTime.text = string.format( ZhString.EndLessTowerCountDownInfo_CountDown, day,hour,min );
end

function EndLessTowerCountDownInfo:OnExit()
	if(self.timeTick)then
		TimeTickManager.Me():ClearTick(self, 1);
	end

	EventManager.Me():RemoveEventListener(ServiceEvent.UserEventQueryResetTimeEventCmd, self.SetData, self)

	if(self.gameObject)then
		GameObject.Destroy(self.gameObject);
		self.gameObject = nil;
	end
end