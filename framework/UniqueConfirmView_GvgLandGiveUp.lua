autoImport("BaseView");
UniqueConfirmView_GvgLandGiveUp = class("UniqueConfirmView_GvgLandGiveUp", BaseView);

UniqueConfirmView_GvgLandGiveUp.ViewType = UIViewType.ConfirmLayer

local _serverDeltaSecondTime;
local _formatTimeBySec
function UniqueConfirmView_GvgLandGiveUp:Init()
	_serverDeltaSecondTime = ServerTime.ServerDeltaSecondTime;
	_formatTimeBySec = ClientTimeUtil.FormatTimeBySec;

	self.contentLabel = self:FindComponent("ContentLabel", UILabel);
	self.confirmLabel = self:FindComponent("ConfirmLabel", UILabel);
	self.cancelLabel = self:FindComponent("CancelLabel", UILabel);

	self.confirmBtn = self:FindGO("ConfirmBtn")
	self.cancelBtn = self:FindGO("CancelBtn")

	self:AddButtonEvent("ConfirmBtn",function(go)
 		if(self.confirmHandler~=nil) then
			self.confirmHandler()
		end

		self:CloseSelf();
 	end)

 	self:AddButtonEvent("CancelBtn",function(go)
 		if(self.cancelHandler~=nil) then
			self.cancelHandler()
		end

		self:CloseSelf();
 	end)
end

function UniqueConfirmView_GvgLandGiveUp:DoConfirm()
	
end

function UniqueConfirmView_GvgLandGiveUp:DoCancel()
	-- print("取消")
	
end

function UniqueConfirmView_GvgLandGiveUp:FillContent(text)
	self.contentLabel.text = text
end

function UniqueConfirmView_GvgLandGiveUp:FillButton()
	if(self.msgData == nil)then
		return;
	end

	self.confirmLabel.text = self.msgData.button or "";
	self.cancelLabel.text = self.msgData.buttonF or "";
end

function UniqueConfirmView_GvgLandGiveUp:OnEnter()
	UniqueConfirmView_GvgLandGiveUp.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;

	self.iscancel = viewdata.iscancel;
	local msgId = viewdata.msgId;

	local msgData = Table_Sysmsg[msgId];
	self.msgData = msgData;

	self.confirmHandler = viewdata.confirmHandler;
	self.cancelHandler = viewdata.cancelHandler;

	self:UpdateLeftTime();	
	self:FillButton();
end

function UniqueConfirmView_GvgLandGiveUp:UpdateLeftTime()
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData == nil)then
		return;
	end
	if(self.iscancel)then
		self.cd = myGuildData.citygiveuptime;

		if(_serverDeltaSecondTime(self.cd * 1000) > 0)then
			self.timetick = TimeTickManager.Me():CreateTick(0, 1000, self._updateLeftTime, self, 1);
		else
			helplog("ERROR:", 
				"cd:" .. os.date("%Y-%m-%d-%H-%M-%S", self.cd), 
				"now:" .. os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime()/1000));
		end
	else
		local day,hour,min,sec = _formatTimeBySec( GameConfig.Guild.city_giveup_cd )
		local leftTimeStr = string.format("%02d:%02d:%02d", hour, min, sec);
		self:FillContent(string.format(self.msgData.Text, leftTimeStr));
	end
end

function UniqueConfirmView_GvgLandGiveUp:_updateLeftTime()
	local leftTime = _serverDeltaSecondTime(self.cd * 1000);
	if(leftTime > 0)then
		local day,hour,min,sec = _formatTimeBySec( leftTime )
		local leftTimeStr = string.format("%02d:%02d:%02d", hour, min, sec);
		self:FillContent(string.format(self.msgData.Text, leftTimeStr));
	else
		-- self:CloseSelf();
	end
end

function UniqueConfirmView_GvgLandGiveUp:RemoveTimeTick()
	if(self.timetick)then
		TimeTickManager.Me():ClearTick(self, 1);
		self.timetick = nil;
	end
end

function UniqueConfirmView_GvgLandGiveUp:OnExit()
	UniqueConfirmView_GvgLandGiveUp.super.OnExit(self);

	self:RemoveTimeTick();
	self.cd = nil;
end