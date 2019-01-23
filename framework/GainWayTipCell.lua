local baseCell = autoImport("BaseCell")
GainWayTipCell = class("GainWayTipCell", baseCell)

GainWayItemData.AddType = {
	Monster = 1,
}

GainWayTipCell.AddItemTrace = "GainWayTipCell_AddItemTrace";
GainWayTipCell.CloseGainWay = "GainWayTipCell_CloseGainWay";

function GainWayTipCell:Init()
	GainWayTipCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function GainWayTipCell:FindObjs()
    self.empty = self:FindGO("Empty");
	self.item = self:FindGO("Item");
	self.notOpen=self:FindGO("notOpen")
	self.itemName=self:FindGO("itemName"):GetComponent(UILabel)
	self.getWay=self:FindGO("getWay"):GetComponent(UILabel)
	self.signSprite=self:FindGO("signSprite"):GetComponent(UISprite)
	self.Icon_Sprite=self:FindGO("Icon_Sprite"):GetComponent(UISprite)
	self.bossLevel=self:FindGO("bossLevel"):GetComponent(UILabel)

	self.gotoBtn = self:FindGO("GoToButton");
	self:AddClickEvent(self.gotoBtn, function (go)
		self:PassEvent(ItemEvent.GoTraceItem, self.data);
	end);

	self.traceBtn = self:FindGO("TraceButton");
	self.traceBtnSprite = self.traceBtn:GetComponent(UISprite);
	self:AddClickEvent(self.traceBtn, function (go)
		if(self.traced)then
			self:sendNotification(MainViewEvent.CancelItemTrace, {self.data.itemID});
		else
			local item = {
				itemid = self.data.itemID, 
				monsterid = self.data.monsterID
			};
			self:sendNotification(MainViewEvent.AddItemTrace, {item});
		end
		self:UpdateTraceInfo();
		
		self:PassEvent(GainWayTipCell.AddItemTrace);
	end);
end

function GainWayTipCell:SetData(data)
	self.data = data;
	if(data)then
	 	self:SetActive(self.item, true)
	 	self:SetActive(self.empty, false)
	 	self.signSprite.gameObject:SetActive(false)
	 	self.itemName.text=data.name
	 	UIUtil.WrapLabel (self.itemName)
	 	self.getWay.text=data.desc
	 	
	 	if(data.type == GainWayItemCellType.Monster)then
	 		IconManager:SetFaceIcon(data.icon,self.Icon_Sprite)	
	 		self.bossLevel.gameObject:SetActive(true);
	 		self.bossLevel.text="Lv."..data.level
	 		if(data.monsterType=="MINI")then
	 			self.signSprite.spriteName="ui_HP_2"
	 			self.signSprite.gameObject:SetActive(true)
	 		elseif(data.monsterType=="MVP")then
	 			self.signSprite.spriteName="ui_HP_1"
	 			self.signSprite.gameObject:SetActive(true)
	 		end 
	 	else
	 		self.bossLevel.gameObject:SetActive(false);
	 		if(data.icon ~="")then
	 			IconManager:SetUIIcon(data.icon,self.Icon_Sprite)	
	 		else
	 			IconManager:SetFaceIcon(data.npcFace,self.Icon_Sprite)	
	 		end
	 	end
	 	self.notOpen:SetActive(not data.isOpen)

		local id = self.data.addWayID;
		local gotoMode = Table_AddWay[id] and Table_AddWay[id].GotoMode;
		if(gotoMode==nil or gotoMode[1]==nil)then
		 	self.gotoBtn:SetActive(false);
		else
		 	self.gotoBtn:SetActive(true);
		end

	 	self:UpdateTraceInfo();
	else
		self:SetActive(self.item, false)
	 	self:SetActive(self.empty, true)
	end
end

function GainWayTipCell:UpdateTraceInfo()
	local data = self.data;
	if(data and data.origins and data.type == GainWayItemCellType.Monster)then
		self:Show(self.traceBtn);
		local traceData = MyselfProxy.Instance:GetTraceItemByItemId(data.itemID);
		self.traced = traceData and traceData.monsterid == data.monsterID or false;
		self.traceBtnSprite.spriteName = self.traced and "com_btn_close4" or "com_icon_search2";
	else
		self:Hide(self.traceBtn);
	end
end




