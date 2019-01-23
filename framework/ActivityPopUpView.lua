ActivityPopUpView = class("ActivityPopUpView",BaseView)

ActivityPopUpView.ViewType = UIViewType.ConfirmLayer

autoImport('ActivityPopUpCell');

function ActivityPopUpView:Init()
end

function ActivityPopUpView:OnEnter()
	ActivityPopUpView.super.OnEnter(self);
	self:SetPopInfo();
end

function ActivityPopUpView:SetPopInfo()
	local viewdata = self.viewdata;

	local title = viewdata.title;
	local text = viewdata.text;
	local param = viewdata.param;
	local msgData = viewdata.msgData;

	if(not msgData)then
		helplog("not find msgData");
		self:CloseSelf();
		return;
	end

	local pfbType = msgData.PrefabType or 1;
	if(self.cell)then
		if(self.pfbType ~= pfbType)then
			self.cell:Destroy();
			self.cell = nil;
		end
	end
	if(not self.cell)then
		local goPath = ResourcePathHelper.UICell("ActivityPopUpCell_"..pfbType);
		local go = self:LoadPreferb_ByFullPath(goPath, self.gameObject);
		self.cell = ActivityPopUpCell.new(go);
		self.cell:AddEventListener(ActivityPopUpCell_Event.Confirm, self.ConfirmEvent, self);
		self.cell:AddEventListener(ActivityPopUpCell_Event.Cancel, self.CancelEvent, self);
	end

	if(param ~= nil)then
		text = MsgParserProxy.Instance:TryParse(text, unpack(param))
	else
		text = MsgParserProxy.Instance:TryParse(text)
	end
	local cellData = {
		title = title,
		text = text,
		confirmText = msgData.button,
		cancelText = msgData.buttonF,
	};
	self.cell:SetData(cellData);
end

function ActivityPopUpView:ConfirmEvent(cellCtl)
	self:CloseSelf();
end

function ActivityPopUpView:CancelEvent(cellCtl)
	self:CloseSelf();
end

