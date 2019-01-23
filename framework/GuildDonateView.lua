autoImport("GuildDonateItemCell");
autoImport("GuildDonateMemberCell");
autoImport("ItemCell");

GuildDonateConfirmTip = class("GuildDonateConfirmTip", CoreView);

autoImport("GainWayTip");

GuildDonateConfirmEvent = {
	Confirm = "GuildDonateConfirmEvent_Confirm",
}

function GuildDonateConfirmTip:ctor(go)
	GuildDonateConfirmTip.super.ctor(self, go);
	self:Init();
end

function GuildDonateConfirmTip:Init()
	local confirmTipCellGO = self:FindGO("SimpleItem");
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.closecomp.callBack = function (go)
		self:Hide();
	end

	self.confirmTipCell = ItemCell.new(confirmTipCellGO);
	self.confirmItemName = self:FindComponent("ItemName", UILabel);
	self.confirmNeedNum = self:FindComponent("NeedNum", UILabel);
	self.confirmHaveNum = self:FindComponent("HaveNum", UILabel);
	self.confirmGuildReward = self:FindComponent("GuildReward", UILabel);
	self.confirmMyReward = self:FindComponent("MyReward", UILabel);
	self.donateButton = self:FindGO("DonateButton");
	local getWayButton = self:FindGO("GetWayButton");
	self:AddClickEvent(getWayButton, function (go)
		if(self.selectGuildItemData)then
			local itemData = ItemData.new("DonateItem", self.selectGuildItemData.itemid);
			self:ShowItemGetWay(itemData);
		end
	end);
	local closeTipButton = self:FindGO("CloseTip");
	self:AddClickEvent(closeTipButton, function (go)
		self:HideItemGetWay();
		self.gameObject:SetActive(false);
	end);

	local confirmButton = self:FindGO("DonateButton");
	self:AddClickEvent(confirmButton, function (go)
		self:PassEvent(GuildDonateConfirmEvent.Confirm);
	end);

	self.gpContainer = self:FindGO("GainWayContainer");
end

function GuildDonateConfirmTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function GuildDonateConfirmTip:SetData(guildItemData)
	self.selectGuildItemData = guildItemData;

	if(guildItemData)then
		local itemData = ItemData.new("DonateItem", guildItemData.itemid);
		self.confirmTipCell:SetData(itemData);
		self.confirmItemName.text = itemData.staticData.NameZh;
		self.confirmNeedNum.text = string.format(ZhString.GuildDonateConfirmTip_NeedNum, guildItemData.itemcount);

		local havNum = GuildDonateItemCell.GetDonateItemNum(guildItemData.itemid);
		self.confirmHaveNum.text = string.format(ZhString.GuildDonateConfirmTip_HaveNum, havNum);

		local detailInfo = FunctionDonateItem.Me():GetDetailInfo(guildItemData.configid)
		if(detailInfo)then
			self:UpdateConfirmDetailInfo(detailInfo);
		else
			self.confirmGuildReward.text = ZhString.GuildDonateConfirmTip_GuildReward;
			self.confirmMyReward.text = "";
		end
	end
end

function GuildDonateConfirmTip:UpdateConfirmDetailInfo(detailInfo)
	local asset = detailInfo and detailInfo.asset;
	asset = asset;
	if(asset)then
		for i=1,#asset do
			local itemId, num = asset[i][1],asset[i][2];
			if(itemId and num)then
				local itemStaticData = Table_Item[itemId];
				if(itemStaticData)then
					self.confirmGuildReward.text = ZhString.GuildDonateConfirmTip_GuildReward .. itemStaticData.NameZh .. "+" .. num;
				end
			end
		end
		
	end

	local itemStr = "";
	local con = detailInfo and detailInfo.con;
	if(con)then
		for i=1,#con do
			local id, count = con[i][1], con[i][2];
			itemStr = itemStr..string.format(ZhString.GuildDonateConfirmTip_MyReward, Table_Item[id].NameZh, count);
			if(i<#con)then
				itemStr = itemStr..ZhString.GuildDonateConfirmTip_And.."\n";
			end
		end
	end

	self.confirmMyReward.text = itemStr;
end

function GuildDonateConfirmTip:ShowItemGetWay(itemData)
	if(not self.bdt)then
		self.bdt = GainWayTip.new(self.gpContainer)
		self.bdt:AddEventListener(GainWayTip.CloseGainWay, function ()
			self.bdt = nil;
			self.closecomp:ReCalculateBound();
		end, self);
	end
	self.bdt:SetData(itemData.staticData.id);
	self.bdt:Show();

	self.bdt:AddIgnoreBounds(self.gameObject);
	self:AddIgnoreBounds(self.bdt.gameObject);
end

function GuildDonateConfirmTip:HideItemGetWay()
	if(self.bdt)then
		self.bdt:OnExit();
		self.bdt = nil;
	end
end

function GuildDonateConfirmTip:Show()
	self.gameObject:SetActive(true);
end

function GuildDonateConfirmTip:Hide()
	self.gameObject:SetActive(false);
	self:HideItemGetWay();
end


--------------------------------------------------------------------------------------------------------

GuildDonateView = class("GuildDonateView", ContainerView)

GuildDonateView.ViewType = UIViewType.NormalLayer

function GuildDonateView:Init()
	self:InitView();
	self:MapEvent();
end

function GuildDonateView:InitView()
	local donation = self:FindGO("Donation");
	self.donationlabel = self:FindComponent("Label", UILabel, donation);
	self.noneTip = self:FindGO("NoneTip");

	self.refreshTimelabel = self:FindComponent("NextRefreshTime", UILabel);
	self.orderCount = self:FindComponent("OrderCount", UILabel);

	self.rankBord = self:FindGO("RankBord");
	self.rankButton = self:FindGO("RankButton");
	self:AddClickEvent(self.rankButton,function (go)
		self.rankBord:SetActive(true);
	end)

	local donateItemGrid = self:FindComponent("DonateItemGrid", UIGrid);	
	self.donateItemCtl = UIGridListCtrl.new(donateItemGrid, GuildDonateItemCell, "GuildDonateItemCell")
	self.donateItemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDonateItemCell, self)

	local rankGrid = self:FindComponent("RankGrid", UIGrid);	
	self.rankCtl = UIGridListCtrl.new(rankGrid, GuildDonateMemberCell, "GuildDonateMemberCell")

	self.confirmTip = GuildDonateConfirmTip.new(self:FindGO("ConfirmTip"));
	self.confirmTip:AddEventListener(GuildDonateConfirmEvent.Confirm, self.DoDonate, self);
end

function GuildDonateView:DoDonate()
	if(self.selectGuildItemData)then
		local itemid = self.selectGuildItemData.itemid;
		local hasNum = GuildDonateItemCell.GetDonateItemNum(itemid);
		local needNum = self.selectGuildItemData.itemcount;
		if(hasNum < needNum)then
			local needItem = {id = itemid, count = needNum-hasNum};
			if(QuickBuyProxy.Instance:TryOpenView({needItem}))then
				return;
			end
			MsgManager.ShowMsgByIDTable(8);
		else
			local configid = self.selectGuildItemData.configid;
			local time = self.selectGuildItemData.time;
			ServiceGuildCmdProxy.Instance:CallDonateGuildCmd(configid, time);

			self.confirmTip:Hide();
			if(self.selectGuildItemCell)then
				self.selectGuildItemCell:ActiveGrey(true);
			end

			self.selectGuildItemData = nil;
			self.selectGuildItemCell = nil;
		end
	end
end

function GuildDonateView:ClickDonateItemCell(cellCtl)
	local data = cellCtl.data;
	self.selectGuildItemData = data;
	self.selectGuildItemCell = cellCtl;

	if(data)then
		self.confirmTip:SetData(data);
		self.confirmTip:Show();
		self.confirmTip:AddIgnoreBounds(cellCtl.gameObject);
	end
end

function GuildDonateView:UpdateGuildDonateInfo()
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData)then
		local myGuildMemberData = myGuildData:GetMemberByGuid(Game.Myself.data.id);
		if(myGuildMemberData)then
			self.donationlabel.text = tostring(myGuildMemberData.contribution);
		end

		TimeTickManager.Me():ClearTick(self, 1);
		TimeTickManager.Me():CreateTick(0, 1000, self.RefreshNextDonateTime, self, 1)
	end
end

function GuildDonateView:RefreshNextDonateTime()
	local myGuildData = GuildProxy.Instance.myGuildData;

	local nextRefreshTime = myGuildData:GetNextDonateTime();
	local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr( nextRefreshTime )
  	if(leftDay > 0)then
		self.refreshTimelabel.text = string.format("%s %02d:%02d:%02d", 
			ZhString.GuildDonateView_NextRefreshTimeTip, leftDay, leftHour, leftMin);
	else
		self.refreshTimelabel.text = string.format("%s %02d:%02d:%02d", 
			ZhString.GuildDonateView_NextRefreshTimeTip, leftHour, leftMin, leftSec);
	end
end

function GuildDonateView:UpdateDonateItemList()
	local donateItemList = GuildProxy.Instance:GetGuildDonateItemList() or {};
	self.donateItemCtl:ResetDatas(donateItemList);

	local count = 0;
	for i=1, #donateItemList do
		local item = donateItemList[i];
		if(item and type(item.count) == "number" and item.count<=0)then
			count = count + 1;
		end
	end
	self.noneTip:SetActive(count == 0);
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(not myGuildData)then
		return;
	end
	local config = myGuildData:GetGuildConfig();
	if(not config)then
		return;
	end
	self.orderCount.text = string.format(ZhString.GuildDonateView_OrderCountTip, count, config.DonateListLimit);
end

function GuildDonateView:UpdateDonateRankList()
	local memberList = GuildProxy.Instance.myGuildData:GetMemberList();
	table.sort(memberList, function (a,b)
		return a.weekasset > b.weekasset;
	end)
	local rankList = {};
	for i=1,#memberList do
		local rankData = {};
		rankData.index = i;
		rankData.memberData = memberList[i];
		table.insert(rankList, rankData);
	end
	self.rankCtl:ResetDatas(rankList);
end

function GuildDonateView:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdDonateListGuildCmd, self.UpdateDonateItemList);
	self:AddListenEvt(ServiceEvent.GuildCmdUpdateDonateItemGuildCmd, self.UpdateDonateItemList);
	
	self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.UpdateDonateItemList);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleMemeberDataUpdate);

	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateDonateItemList);

	self:AddListenEvt(ServiceEvent.GuildCmdApplyRewardConGuildCmd, self.HandleUpdateDonateTip);
end

function GuildDonateView:HandleUpdateDonateTip(note)
	if(self.selectGuildItemCell == nil)then
		return;
	end
	self:ClickDonateItemCell(self.selectGuildItemCell)
end

function GuildDonateView:HandleRewardConUpdate(note)
	if(self.selectGuildItemData)then
		local configid = self.selectGuildItemData.configid;
		local detailInfo = FunctionDonateItem.Me():GetDetailInfo(configid)
		self.confirmTip:UpdateConfirmDetailInfo(detailInfo);
	end
end

function GuildDonateView:HandleGuildDataUpdate()
	self:UpdateDonateItemList();
	self:UpdateGuildDonateInfo();
end

function GuildDonateView:HandleMemeberDataUpdate()
	self:UpdateGuildDonateInfo();
	self:UpdateDonateRankList();
end

function GuildDonateView:OnEnter()
	GuildDonateView.super.OnEnter(self);

	ServiceGuildCmdProxy.Instance:CallDonateListGuildCmd();
	ServiceGuildCmdProxy.Instance:CallDonateFrameGuildCmd(true);

	local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata;
	local rootTrans = npcData and npcData.assetRole.completeTransform;
	if(rootTrans)then
		self:CameraFocusOnNpc(rootTrans);
	else
		self:CameraRotateToMe();
	end

	self:UpdateDonateRankList();
	self:UpdateGuildDonateInfo();
end

function GuildDonateView:OnExit()
	GuildDonateView.super.OnExit(self);
	ServiceGuildCmdProxy.Instance:CallDonateFrameGuildCmd(false);
	TimeTickManager.Me():ClearTick(self, 1);

	self:CameraReset()
end


