local BaseCell = autoImport("BaseCell")
ActivityPopUpCell = class("ActivityPopUpCell", BaseCell);

ActivityPopUpCell_Event = {
	Confirm = "ActivityPopUpCell_Event_Confirm",
	Cancel = "ActivityPopUpCell_Event_Cancel",
}

function ActivityPopUpCell:Init()
	self.title = self:FindComponent("Title", UILabel);
	self.content = self:FindComponent("Content", UILabel);	
	self.confirmBtn = self:FindGO("ConfirmBtn");
	self.confirmLabel = self:FindComponent("ConfirmLabel", UILabel);
	self.cancelBtn = self:FindGO("CancelBtn");
	self.cancelLabel = self:FindComponent("CancelLabel", UILabel);

	self:AddClickEvent(self.confirmBtn, function ()
		self:PassEvent(ActivityPopUpCell_Event.Confirm, self);
	end);
	self:AddClickEvent(self.cancelBtn, function ()
		self:PassEvent(ActivityPopUpCell_Event.Cancel, self);
	end);

end

function ActivityPopUpCell:SetData(data)
	if(data.title and self.title)then
		self.title.text = data.title;
	end
	if(data.text and self.content)then
		self.content.text = data.text;
	end
	if(data.confirmText and data.confirmText~="" and self.confirmLabel)then
		self.confirmLabel.text = data.confirmText;
	end
	if(data.cancelText and data.cancelText~="" and self.cancelLabel)then
		self.cancelLabel.text = data.cancelText;
	end
end

function ActivityPopUpCell:Destroy()
	GameObject.Destroy(self.gameObject);
end


