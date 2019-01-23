QuotaCardView = class("QuotaCardView",ContainerView)
autoImport("QuotaLogCell")
autoImport("QuotaDetailCell")
QuotaCardView.ViewType = UIViewType.NormalLayer
QuotaCardView.moneyID=149
local textureName = "auction_bg_card"
function QuotaCardView:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitUIView()
	self:MapListenEvt()
	self.pageMap = {};
	self.pageDetailMap = {};
end

function QuotaCardView:FindObjs()
	self.goBtn = self:FindGO("goBtn")
	self.desc = self:FindGO("desc"):GetComponent(UILabel)
	self.accountLab = self:FindGO("accountLab"):GetComponent(UILabel)
	self.lock = self:FindGO("Lock"):GetComponent(UILabel)
	self.pointLimitDate = self:FindGO("pointLimitDate")
	self.desc2 = self:FindGO("desc2"):GetComponent(UILabel)
	self.quotaDetail=self:FindGO("quotaDetail")
	self.icon=self:FindGO("icon"):GetComponent(UISprite)
	self.texture=self:FindGO("Texture"):GetComponent(UITexture)
	self.accountLine = self:FindGO("AccountLine"):GetComponent(UISprite)
end

function QuotaCardView:AddEvts()
	self:AddClickEvent(self.goBtn,function (g)
		self:OnClickGoBtn()
	end)
	self:AddClickEvent(self.pointLimitDate,function (g)
		self:OnClickPointLimitDate()
	end)
end

function QuotaCardView:InitUIView()
	PictureManager.Instance:SetQuota(textureName, self.texture)
	self.desc.text=ZhString.QuotaCard_Desc

	local _MyselfProxy = MyselfProxy.Instance
	local quota = _MyselfProxy:GetQuota()
	local lockQuota = _MyselfProxy:GetQuotaLock()
	self.accountLab.text= string.format(ZhString.QuotaCard_QuotaTitle, quota)
	self.lock.text = string.format(ZhString.QuotaCard_LockTitle, lockQuota)
	self.accountLine.fillAmount = quota / (quota + lockQuota)

	local iconName=Table_Item[QuotaCardView.moneyID] and Table_Item[QuotaCardView.moneyID].Icon or "item_100"
	IconManager:SetItemIcon(iconName, self.icon);
	self.desc2.text=ZhString.QuotaCard_Desc2
	local logWrap = self:FindGO("LogWrapContent");
	local wrapConfig = {
		wrapObj = logWrap,
		cellName = "QuotaLogCell",
		control = QuotaLogCell,
	};
	self.logCtl = WrapCellHelper.new(wrapConfig);

	local logWrap = self:FindGO("detailWrapContent");
	local wrapConfig = {
		wrapObj = logWrap,
		cellName = "QuotaDetailCell",
		control = QuotaDetailCell,
	};
	self.detailCtl = WrapCellHelper.new(wrapConfig);


	local logScroll = self:FindComponent("logScroll", UIScrollView);
	logScroll.momentumAmount = 100;
	NGUIUtil.HelpChangePageByDrag(logScroll, function ()
		self:GetPreLogPage();
	end, function ()
		self:GetNextLogPage();
	end, 120)

	local detailScroll = self:FindComponent("detailScroll", UIScrollView);
	detailScroll.momentumAmount = 100;
	NGUIUtil.HelpChangePageByDrag(detailScroll, function ()
		self:GetPreDetailPage();
	end, function ()
		self:GetNextDetailPage();
	end, 120)

end

function QuotaCardView:OnClickGoBtn()
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ZenyShop}); 
end

function QuotaCardView:OnClickPointLimitDate()
	self:Show(self.quotaDetail)
	self:QueryDetailList(1)
end


function QuotaCardView:GetPreLogPage()
	if(self.nowLogPage)then
		local page = math.max(self.nowLogPage - 1, 1);
		self:QueryLogList(page);
	end
end

function QuotaCardView:GetPreDetailPage()
	if(self.nowDetailPage)then
		local page = math.max(self.nowDetailPage - 1, 1);
		self:QueryDetailList(page);
	end
end

function QuotaCardView:GetNextLogPage()
	if(self.nowLogPage)then
		local page = self.nowLogPage + 1;
		if(self.maxPage)then
			page = math.min(self.maxPage, page);
		end
		self:QueryLogList(page);
	end
end

function QuotaCardView:GetNextDetailPage()
	if(self.nowDetailPage)then
		local page = self.nowDetailPage + 1;
		if(self.maxDetailPage)then
			page = math.min(self.maxDetailPage, page);
		end
		self:QueryDetailList(page);
	end
end

function QuotaCardView:QueryLogList(page)
	if(GameConfig.SystemForbid.Limit)then
		self:CloseSelf()
		return
	end
	self.preLogPage = self.nowLogPage;
	self.nowLogPage = page or 0;
	if(not self.pageMap[self.nowLogPage])then
		self.pageMap[self.nowLogPage] = 1;
		ServiceItemProxy.Instance:CallReqQuotaLogCmd(self.nowLogPage)
	end
end

function QuotaCardView:QueryDetailList(page)
	self.preDetailPage = self.nowDetailPage;
	self.nowDetailPage = page or 0;
	if(not self.pageDetailMap[self.nowDetailPage])then
		self.pageDetailMap[self.nowDetailPage] = 1;
		ServiceItemProxy.Instance:CallReqQuotaDetailCmd(self.nowDetailPage)
	end
end

function QuotaCardView:MapListenEvt()
	self:AddListenEvt(ServiceEvent.ItemReqQuotaDetailCmd, self.HandleQuotaDetailList);
	self:AddListenEvt(ServiceEvent.ItemReqQuotaLogCmd, self.HandleQuotaLogList);
end

function QuotaCardView:HandleQuotaDetailList(note)
	local datas = QuotaCardProxy.Instance:GetDetailData();
	if(self.preDetailPage)then
		if(#datas > 0)then
			if(self.nowDetailPage > 1)then
				MsgManager.FloatMsg(nil, ZhString.QuotaCard_Loading);
			end
			if(self.nowDetailPage < self.preDetailPage)then
				for i=#datas, 1, -1 do
					self.detailCtl:InsertData(datas[i], 1);
				end
			elseif(self.preDetailPage < self.nowDetailPage)then
				for i=1,#datas do
					self.detailCtl:InsertData(datas[i]);
				end
			end
		else
			MsgManager.FloatMsg(nil, ZhString.QuotaCard_End);
			self.nowDetailPage = self.preDetailPage;
			self.maxDetailPage = self.nowDetailPage;
		end
	elseif(self.nowDetailPage)then
		self.detailCtl:ResetDatas(datas);
	end

	local alldatas = self.detailCtl:GetDatas();
	-- helplog("detailCtl alldatas count : ",#alldatas)
end

function QuotaCardView:HandleQuotaLogList(note)
	local datas = QuotaCardProxy.Instance:GetLogData();
	if(self.preLogPage)then
		if(#datas > 0)then
			if(self.nowLogPage > 1)then
				MsgManager.FloatMsg(nil, ZhString.QuotaCard_Loading);
			end
			if(self.nowLogPage < self.preLogPage)then
				for i=#datas, 1, -1 do
					self.logCtl:InsertData(datas[i], 1);
				end
			elseif(self.preLogPage < self.nowLogPage)then
				for i=1,#datas do
					self.logCtl:InsertData(datas[i]);
				end
			end
		else
			MsgManager.FloatMsg(nil, ZhString.QuotaCard_End);
			self.nowLogPage = self.preLogPage;
			self.maxPage = self.nowLogPage;
		end
	elseif(self.nowLogPage)then
		self.logCtl:ResetDatas(datas);
	end
end

function QuotaCardView:OnEnter()
	QuotaCardProxy.Instance:Init()
	QuotaCardView.super.OnEnter(self);
	self:QueryLogList(1);
end

function QuotaCardView:OnExit()
	PictureManager.Instance:UnLoadQuota()
	QuotaCardView.super.OnExit(self);

end




