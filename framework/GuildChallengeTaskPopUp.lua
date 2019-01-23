autoImport("GuildTaskCell")

GuildChallengeTaskPopUp = class("GuildChallengeTaskPopUp",ContainerView)

GuildChallengeTaskPopUp.ViewType = UIViewType.PopUpLayer

local emptyList = {}

function GuildChallengeTaskPopUp:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function GuildChallengeTaskPopUp:FindObj()
	self.nextRefreshTime = self:FindGO("NextRefreshTime"):GetComponent(UILabel)
	self.empty = self:FindGO("Empty")
end

function GuildChallengeTaskPopUp:AddButtonEvt()
	
end

function GuildChallengeTaskPopUp:AddViewEvt()
	self:AddListenEvt(ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd, self.UpdateView)
end

function GuildChallengeTaskPopUp:InitShow()
	local container = self:FindGO("Container")
	local wrapConfig = {
		wrapObj = container, 
		pfbNum = 4, 
		cellName = "GuildTaskCell", 
		control = GuildTaskCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self:UpdateView()

	self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateRefreshTime, self)
end

function GuildChallengeTaskPopUp:ClickConfirm()
	self:CloseSelf()
end

function GuildChallengeTaskPopUp:UpdateView()
	local myGuildData = GuildProxy.Instance.myGuildData
	if myGuildData ~= nil then
		local data = myGuildData:GetChallengeTaskList()
		if data ~= nil then
			self.itemWrapHelper:UpdateInfo(data)
			self.empty:SetActive(#data == 0)
			return
		end
	end

	self.itemWrapHelper:UpdateInfo(emptyList)
	self.empty:SetActive(false)
end

function GuildChallengeTaskPopUp:UpdateRefreshTime()
	local myGuildData = GuildProxy.Instance.myGuildData
	if myGuildData ~= nil then
		local refreshtime = myGuildData.task_refreshtime
		if refreshtime ~= nil then
			local time = refreshtime - ServerTime.CurServerTime()/1000
			if time >= 0 then
				local day,hour,min,sec = ClientTimeUtil.FormatTimeBySec(time)
				self.nextRefreshTime.text = string.format(ZhString.GuildChallenge_RefreshTime, day, hour, min, sec)
				return;
			end
		end
	end

	self.nextRefreshTime.text = ""
end

function GuildChallengeTaskPopUp:OnEnter()
	EventManager.Me():AddEventListener(GuildChallengeEvent.CloseUI,self.ClickConfirm,self)
	GuildChallengeTaskPopUp.super.OnEnter(self);
end

function GuildChallengeTaskPopUp:OnExit()
	EventManager.Me():RemoveEventListener(GuildChallengeEvent.CloseUI,self.ClickConfirm,self)
	GuildChallengeTaskPopUp.super.OnExit(self);
	if self.timeTick ~= nil then
		TimeTickManager.Me():ClearTick(self)
	end
	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_GUILD_CHALLENGE_ADD or 41);
end