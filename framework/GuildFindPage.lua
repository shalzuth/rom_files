GuildFindPage = class("GuildFindPage", SubView)

autoImport("GuildCell");

function GuildFindPage:Init(parent)	
	self:CreatePageObj(parent);
	self:InitUI();
	self:MapListenEvt();

	self.pageMap = {};
end

function GuildFindPage:CreatePageObj(parent)
	self.parent = parent;
	if(self.parent)then
		self:LoadPreferb("view/GuildFindPage", self.parent, true);
	end
end

function GuildFindPage:InitUI()
	local guildWrap = self:FindGO("GuildWrapContent");
	local wrapConfig = {
		wrapObj = guildWrap,
		cellName = "GuildCell",
		control = GuildCell,
	};
	self.guildlstCtl = WrapCellHelper.new(wrapConfig);

	self.keyInput = self:FindComponent("Input", UIInput);
	UIUtil.LimitInputCharacter(self.keyInput, 8);

	self.noneTip = self:FindGO("NoneTip", self.parent);
	self.exitCDTime = self:FindComponent("ExitCDTime", UILabel);

	local searchButton = self:FindGO("SearchButton");
	self:AddClickEvent(searchButton, function ()
		local key = self.keyInput.value;
		if(key and key~="")then
			self.keyword = key;
			self:QueryGuildPageList(nil, key);
		else
			self.pageMap = {};

			self:QueryGuildPageList(1);
			self.guildlstCtl:ResetPosition();
		end
	end);

	local scrollView = self:FindComponent("GuildScroll", UIScrollView);
	scrollView.momentumAmount = 100;
	NGUIUtil.HelpChangePageByDrag(scrollView, function ()
		self:GetPrePageGuilds();
	end, function ()
		self:GetNextPageGuilds();
	end, 120)
end

function GuildFindPage:GetPrePageGuilds()
	if(self.nowPage)then
		local page = math.max(self.nowPage - 1, 1);
		self:QueryGuildPageList(page);
	end
end

function GuildFindPage:GetNextPageGuilds()
	if(self.nowPage)then
		local page = self.nowPage + 1;
		if(self.maxPage)then
			page = math.min(self.maxPage, page);
		end
		self:QueryGuildPageList(page);
	end
end

function GuildFindPage:QueryGuildPageList(page, keyword)
	self.prePage = self.nowPage;
	self.nowPage = page or 1;
	if(keyword)then
		self.nowPage = nil;
		self.prePage = nil;
		self.pageMap = {};
		self.keyword = keyword;
		ServiceGuildCmdProxy.Instance:CallQueryGuildListGuildCmd(keyword);
	else
		if(not self.pageMap[self.nowPage])then
			self.pageMap[self.nowPage] = 1;
			ServiceGuildCmdProxy.Instance:CallQueryGuildListGuildCmd(nil, self.nowPage);

			if(self.nowPage > 1)then
				MsgManager.FloatMsg(nil, ZhString.GuildFindPage_Loading);
			end
		end
	end
end

function GuildFindPage:MapListenEvt()
	self:AddListenEvt(ServiceEvent.GuildCmdQueryGuildListGuildCmd, self.HandleGuildListUpdate);
end

function GuildFindPage:HandleGuildListUpdate(note)
	local datas = GuildProxy.Instance:GetGuildList();
	if(self.keyword)then
		self.keyword = nil;
		self.guildlstCtl:ResetDatas(datas);
		self.guildlstCtl:ResetPosition();
	elseif(self.prePage)then
		if(#datas > 0)then
			if(self.nowPage < self.prePage)then
				for i=#datas, 1, -1 do
					self.guildlstCtl:InsertData(datas[i], 1);
				end
			elseif(self.prePage < self.nowPage)then
				for i=1,#datas do
					self.guildlstCtl:InsertData(datas[i]);
				end
			end
		else
			self.nowPage = self.prePage;
			self.maxPage = self.nowPage;
		end
	elseif(self.nowPage)then
		self.guildlstCtl:ResetDatas(datas);
	end

	local alldatas = self.guildlstCtl:GetDatas();
	helplog("alldatas", #alldatas, #datas, self.prePage, self.nowPage);
	self.noneTip:SetActive(#alldatas == 0);
end

function GuildFindPage:UpdateCDTime()
	local exit_timetick = GuildProxy.Instance:GetExitTimeTick();
	if(exit_timetick == nil or exit_timetick == 0)then
		self.exitCDTime.text = "";
		return;
	end

	local delta_sec = ServerTime.ServerDeltaSecondTime(exit_timetick * 1000);
	if(delta_sec <= 0)then
		self.exitCDTime.text = "";
		return;
	end
	
	local hour = math.ceil(delta_sec/3600);
	self.exitCDTime.text = string.format(ZhString.GuildFindPage_ExitCDTip, hour);
end

function GuildFindPage:OnEnter()
	GuildFindPage.super.OnEnter(self);

	self:QueryGuildPageList(1);
	self:UpdateCDTime();
end

function GuildFindPage:OnExit()
	GuildFindPage.super.OnExit(self);
end











