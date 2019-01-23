local baseCell = autoImport("BaseCell")
UseWayTipCell = class("UseWayTipCell", baseCell)

UseWayTipCell.Event = {};
function UseWayTipCell.Event.HaveGuild(data)
	return GuildProxy.Instance:IHaveGuild()
end

function UseWayTipCell:Init()
	self.empty = self:FindGO("Empty");
	self.item = self:FindGO("Item");
	self.notOpen=self:FindGO("notOpen")
	self.itemName=self:FindGO("itemName"):GetComponent(UILabel)
	self.getWay=self:FindGO("getWay"):GetComponent(UILabel)
	self.signSprite=self:FindGO("signSprite"):GetComponent(UISprite)
	self.Icon_Sprite=self:FindGO("Icon_Sprite"):GetComponent(UISprite)
	self.bossLevel=self:FindGO("bossLevel"):GetComponent(UILabel)
	self.traceBtn = self:FindGO("TraceButton");

	self.gotoBtn = self:FindGO("GoToButton");
	self:AddClickEvent(self.gotoBtn, function (go)
		if(self:CheckCanClick())then
			self:PassEvent(MouseEvent.MouseClick, self);
		end
	end);
end

function UseWayTipCell:CheckCanClick()
	local errorEvent = self.data.ErrorMsgEvent;
	for funcKey, msgId in pairs(errorEvent)do
		local func = self.Event[funcKey];
		if(func and not func(self.data))then
			MsgManager.ShowMsgByID(msgId);
			return false;
		end
	end
	if(self.data.SuccessMsgID)then
		MsgManager.ShowMsgByID(self.data.SuccessMsgID);
	end
	return true;
end

function UseWayTipCell:SetData(data)
	if(data)then
		self.data = data;

		self.gameObject:SetActive(true);

		self.itemName.text = data.Name;

		self.getWay.text = data.Desc;
		IconManager:SetUIIcon(data.Icon, self.Icon_Sprite);

		self.gotoBtn:SetActive(#data.GotoMode > 0);
		self.bossLevel.gameObject:SetActive(false);
	else
		self.gameObject:SetActive(false);
	end
end