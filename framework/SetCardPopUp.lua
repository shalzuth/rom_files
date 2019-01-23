SetCardPopUp = class("SetCardPopUp", BaseView);

SetCardPopUp.ViewType = UIViewType.PopUpLayer

autoImport("CardNCell");

function SetCardPopUp:Init()
	self:AddGameObjectComp();

	if(self.viewdata.viewdata)then
		self.itemdata = self.viewdata.viewdata.itemdata;
		if(self.itemdata)then
			self.pos = ItemUtil.getEquipPos(self.itemdata.staticData.id);
		end
	end
	self:MapEvent();

	self:InitUI();
end

function SetCardPopUp:InitUI()
	-- local cardGrid = self:FindComponent("CardGrid", UIGrid);
	-- self.cardCtl = UIGridListCtrl.new(cardGrid, CardNCell, "CardNCell");
	-- self.cardCtl:AddEventListener(MouseEvent.MouseClick, self.EquipCard, self);

	local wrapContainer = self:FindGO("CardGrid");

	local itemSize = wrapContainer:GetComponent(UIWrapContent).itemSize;
	local view_width = UIManagerProxy.Instance:GetUIRootSize()[1];
	local numInt, numPoint = math.modf(view_width/itemSize);
	if(numPoint < 0.5)then
		numInt = numInt + 1;
	else
		numInt = numInt + 2;
	end

	local wrapConfig = {
		wrapObj = wrapContainer,
		pfbNum = numInt, 
		cellName = "CardNCell", 
		control = CardNCell, 
		dir = 2,
	}
	self.cardCtl = WrapCellHelper.new(wrapConfig)	
	self.cardCtl:AddEventListener(MouseEvent.MouseClick, self.EquipCard, self);

	self.cardSlots = {};
	for i=1,5 do
		local cardsprite = self:FindComponent("CardEquip"..i, UISprite, tempSlot)
		table.insert(self.cardSlots, cardsprite);
	end
	self:UpdateSlots();

	self:UpdateCards();
end

function SetCardPopUp:EquipCard(cellCtl)
	local data = cellCtl.data;
	if(data)then
		self.nowcell = cellCtl;
		self:sendNotification(UIEvent.ShowUI, {viewname = "CardPosChoosePopUp", itemData = self.itemdata});
	end
end

function SetCardPopUp:GetFilterCard()
	local equipCards, cards = self.itemdata.equipedCardInfo or {}, {};

	for pos,equipCard in pairs(equipCards) do
		equipCard.used = true;
		table.insert(cards, equipCard);
	end
	
	local items = BagProxy.Instance.bagData:GetItems();
	for i=1,#items do
		local item = items[i];
		local cardInfo = item.cardInfo;
		if(cardInfo and cardInfo.Position == self.pos)then
			-- 该界面卡片不可以堆叠 new出新的ItemData赋值
			for i=1,item.num do
				local tempNew = ItemData.new(item.id, item.staticData.id);
				tempNew.num = 1;
				table.insert(cards, tempNew);
			end
		end
	end
	table.sort(cards, SetCardPopUp.CardSortRule);
	return cards;
end

function SetCardPopUp.CardSortRule(a,b)
	if(a.used ~= b.used)then
		return b.used~=true;
	end
	if(a.used and b.used)then
		return a.index < b.index;
	end

	if(a.staticData.Quality~=b.staticData.Quality)then
		return a.staticData.Quality>b.staticData.Quality
	end
	return a.staticData.id<b.staticData.id;
end

function SetCardPopUp:UpdateCards()
	local datas = self:GetFilterCard();
	self.cardCtl:UpdateInfo(datas);
end

function SetCardPopUp:UpdateSlots()
	local data = self.itemdata;
	local cardDatas = data.equipedCardInfo or {};
	for i=1,#self.cardSlots do
		local obj = self.cardSlots[i];
		if(i<=data.cardSlotNum)then
			obj.gameObject:SetActive(true);
			if(cardDatas[i])then
				obj.spriteName = "card_icon_0"..cardDatas[i].staticData.Quality;
			else
				obj.spriteName = "card_icon_0";
			end
		else
			obj.gameObject:SetActive(false);
		end
	end
end

function SetCardPopUp:MapEvent()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleCardUseSuc);
	self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleCardUseSuc);

	self:AddListenEvt(CardPosChoosePopUpEvent.ChoosePos, self.HandleChoosePos);
end

function SetCardPopUp:HandleChoosePos(note)
	local pos = note.body;
	
	local data = self.nowcell.data;
	if(data)then
		MsgManager.ConfirmMsgByID(511, function ()
			ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPON, data.id, self.itemdata.id, pos)
		end, nil,nil, data.staticData.NameZh, self.itemdata.staticData.NameZh);
	end
end

function SetCardPopUp:HandleCardUseSuc(note)
	if(self.nowcell)then
		self.nowcell:SetChooseState(false);
		self.nowcell = nil;
	end
	self:UpdateCards();
	self:UpdateSlots();
end

function SetCardPopUp:OnDestroy()
	PictureManager.Instance:UnLoadCard()
end


