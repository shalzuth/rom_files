UseLotteryItemPopUp = class("UseLotteryItemPopUp", BaseView);

UseLotteryItemPopUp.ViewType =  UIViewType.ConfirmLayer;

function UseLotteryItemPopUp:Init()
	self.contentLabel = self:FindComponent("ContentLabel", UILabel);
	self.confirmLabel = self:FindComponent("ConfirmLabel", UILabel);
	self.cancelLabel = self:FindComponent("CancelLabel", UILabel);

	self.confirmBtn = self:FindGO("ConfirmBtn")
	self:AddClickEvent(self.confirmBtn, function (go)
		self:DoConfirm();
	end);
	self.cancelBtn = self:FindGO("CancelBtn")
	self:AddClickEvent(self.cancelBtn, function (go)
		self:DoCancel();
	end);

	self:MapEvent();
end

function UseLotteryItemPopUp:DoConfirm()
	ServiceItemProxy.Instance:CallItemUse(self.itemdata, nil, self.count);
	self:CloseSelf();
end

function UseLotteryItemPopUp:DoCancel()
	self:CloseSelf();
end

function UseLotteryItemPopUp:UpdateInfo()
	local timeInfo = os.date("*t", math.floor(ServerTime.CurServerTime()/1000));
	local groupId = LotteryProxy.Instance:GetMonthGroupId(timeInfo.year, timeInfo.month);

	local group = LotteryProxy.Instance:GetHeadwearMonthGroupById(groupId)
	local getName = "";
	if(group)then
		local months = group:GetMonth();
		for i=1,#months do
			local items = months[i].items;
			for j=1,#items do
				if(items[j].rarity == self.rarity)then
					getName = items[j]:GetItemData():GetName();
				end
			end
		end
	end
	local text = Table_Sysmsg[self.sysMsgId].Text;
	text = string.format(text, tostring(getName));
	self.contentLabel.text = text;
end

function UseLotteryItemPopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.ItemQueryLotteryInfo, self.UpdateInfo);
end

function UseLotteryItemPopUp:OnEnter()
	UseLotteryItemPopUp.super.OnEnter(self);

	self.itemdata = self.viewdata.itemdata;
	self.count = self.viewdata.count;
	self.sysMsgId = self.viewdata.sysMsgId;
	self.rarity = self.viewdata.rarity;

	LotteryProxy.Instance:CallQueryLotteryInfo(LotteryType.Head)
	self:UpdateInfo();
end

function UseLotteryItemPopUp:OnExit()
	UseLotteryItemPopUp.super.OnExit(self);
end