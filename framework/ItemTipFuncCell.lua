local BaseCell = autoImport("BaseCell");
ItemTipFuncCell = class("ItemTipFuncCell", BaseCell)

function ItemTipFuncCell:Init()
	self.label = self:FindChild("Label"):GetComponent(UILabel);
	self.label_effect_oriColor = self.label.effectColor;

	self.bg=self:FindChild("Background"):GetComponent(UISprite);
	self.collider = self.gameObject:GetComponent(BoxCollider);

	self:AddCellClickEvent();
end

function ItemTipFuncCell:SetData(data)
	self.data = data;

	if(data)then
		self.gameObject:SetActive(true);
		if(data.type == "Active")then
			if(data.itemData and data.itemData.isactive)then
				self.label.text = ZhString.ItemTipFuncCell_Down;
			else
				self.label.text = data.name;
			end
		elseif(data.type=="GetTask")then
			if(not data.itemData or not data.itemData.staticData)then return end
			local questID = Table_UseItem[data.itemData.staticData.id].UseEffect.id;
			if(questID)then
				local bContain=QuestProxy.Instance:checkQuestHasAccept(questID);
				if(bContain)then
					self.label.text = ZhString.AdventureRewardPanel_HasGetAward;
					self:SetTextureGrey(self.gameObject)
				else
					-- self:SetTextureWhite(self.bg)
					self.label.text = data.name;
				end
			end
		else
			self.label.text = data.name;
		end

		if(data.inactive == true)then
			self.collider.enabled = false;
			self.bg.color = ColorUtil.NGUIShaderGray;
			self.label.effectColor = ColorUtil.NGUIGray;
		else
			self.collider.enabled = true;
			self.bg.color = ColorUtil.NGUIWhite;
			self.label.effectColor = self.label_effect_oriColor;
		end
	else
		self.gameObject:SetActive(false);
	end
end

function ItemTipFuncCell:AddQuestCallback(note)
	if(not self.data or self.data.type~="GetTask")then return end
	local result = false;
	local useItemID = self.data.itemData.staticData.id;
	local itemQuestID = Table_UseItem[useItemID].UseEffect.id;
	if(itemQuestID)then
		for k,v in pairs(note.data) do
			if(v==itemQuestID)then
				result=true;
				break;
			end
		end
	end
	if(result)then
		local taskID = itemQuestID;
		local name = MsgParserProxy.Instance:GetQuestName(taskID);
		if(name)then
			-- MsgManager.ShowMsgByID(933,name);服务端那边判断了
		end
	end
end

