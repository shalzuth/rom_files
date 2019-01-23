UseCardPopUp = class("UseCardPopUp", BaseView);

UseCardPopUp.ViewType = UIViewType.PopUpLayer

autoImport("EquipTipCell");

function UseCardPopUp:Init()
	if(self.viewdata.viewdata)then
		self.carddata = self.viewdata.viewdata.carddata;
		self.equipdatas = self.viewdata.viewdata.equipdatas;
	end

	self:InitUI();
	self:MapEvent();
end

function UseCardPopUp:InitUI()
	local wrapContainer = self:FindGO("ItemGrid");

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
		cellName = "EquipTipCell", 
		control = EquipTipCell, 
		dir = 2,
	}

	self.itemCtl = WrapCellHelper.new(wrapConfig)	
	self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self);

	self:UpdateData();
end

function UseCardPopUp:ClickItem(cellCtl)
	local data = cellCtl.data;
	if(data)then

		self.nowcell = cellCtl;
		self:sendNotification(UIEvent.ShowUI, {viewname = "CardPosChoosePopUp", itemData = data});

	end
end

function UseCardPopUp:UpdateData()
	if(self.carddata and self.carddata.cardInfo)then
		local pos = self.carddata.cardInfo.Position;
		local filterDatas = self.equipdatas or BagProxy.Instance:FilterEquipedCardItems(pos);
		self.itemCtl:UpdateInfo(filterDatas);

		self.equipdatas = nil;
	end
end

function UseCardPopUp:MapEvent()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleCardUseSuc);
	self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleCardUseSuc);

	self:AddListenEvt(CardPosChoosePopUpEvent.ChoosePos, self.HandleChoosePos);
end

function UseCardPopUp:HandleChoosePos(note)
	local pos = note.body;

	local data = self.nowcell and self.nowcell.data;
	if(data)then
		MsgManager.ConfirmMsgByID(511, function ()
			ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPON, self.carddata.id, data.id, pos)
			self.callServer = true;
		end, nil,nil, self.carddata.staticData.NameZh, data.staticData.NameZh)
	end
end

function UseCardPopUp:HandleCardUseSuc(note)
	if(self.callServer)then
		self.callServer = false;
		self:CloseSelf();
	end
end

function UseCardPopUp:OnExit()
	local cells = self.itemCtl:GetCellCtls()
	for i=1,#cells do
		cells[i]:Exit();
	end
end














