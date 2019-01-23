CardPosChoosePopUp = class("CardPosChoosePopUp", BaseView);

CardPosChoosePopUp.ViewType = UIViewType.ConfirmLayer

autoImport("EquipCardCell");

function CardPosChoosePopUp:Init()
	self:InitView();
end

function CardPosChoosePopUp:InitView()
	local grid = self:FindComponent("EquipCardPosGrid", UIGrid);
	self.posCtl = UIGridListCtrl.new(grid, EquipCardCell, "EquipCardCell");
	self.posCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosePos, self);

	local title = self:FindComponent("Title", UILabel);
	title.text = ZhString.CardPosChoosePopUp_Title;

	local cost = self:FindGO("Cost");
	local costTipLabel = self:FindComponent("CostTip", UILabel, cost);
	costTipLabel.text = ZhString.CardPosChoosePopUp_CostTip;
	self.costLabel = cost:GetComponent(UILabel);

	local closeButton = self:FindGO("CloseButton");
	local closeButton_Label = self:FindComponent("Label", UILabel, closeButton);
	closeButton_Label.text = ZhString.CardPosChoosePopUp_Cancel;

	self.confirmButton = self:FindGO("ConfirmButton");
	self.confirmButton_Collider = self.confirmButton:GetComponent(BoxCollider);
	self.confirmButton_Label = self:FindComponent("Label", UILabel, self.confirmButton);
	self.confirmButton_Label.text = ZhString.CardPosChoosePopUp_Confirm;
	self.confirmButton_Sp =  self.confirmButton:GetComponent(UISprite);

	self:AddClickEvent(self.confirmButton, function (go)
		self:sendNotification(CardPosChoosePopUpEvent.ChoosePos, self.choosePos);

		self:CloseSelf();
	end);
end

local tempColor = LuaColor.New(1,1,1,1);
function CardPosChoosePopUp:ActiveConfirmButton(b)
	if(b)then
		self.confirmButton_Collider.enabled = true;
		tempColor:Set(22/255,108/255,1/255,1);
		self.confirmButton_Label.effectColor = tempColor;

		tempColor:Set(1,1,1,1);
		self.confirmButton_Sp.color = tempColor;
	else
		self.confirmButton_Collider.enabled = false;
		tempColor:Set(157/255,157/255,157/255,1);
		self.confirmButton_Label.effectColor = tempColor;

		tempColor:Set(1/255,2/255,3/255,1);
		self.confirmButton_Sp.color = tempColor;
	end
end

function CardPosChoosePopUp:ClickChoosePos(cellCtl)
	if(cellCtl)then
		if(self.chooseCell ~= nil)then
			self.chooseCell:SetChoose(false);
		end

		cellCtl:SetChoose(true);

		local data = cellCtl.data;
		if(data and data~=EquipCardCell.Empty)then
			local quality = data.staticData.Quality;
			if(quality)then
				local cost = GameConfig.EquipRecover.Card[ quality ];
				self.costLabel.text = cost;
			else
				self.costLabel.text = 0;
			end
		else
			self.costLabel.text = 0;
		end

		self:ActiveConfirmButton(true);

		self.choosePos = cellCtl.indexInList;
		self.chooseCell = cellCtl;
	end
end

function CardPosChoosePopUp:UpdateCardPosInfo(itemData)
	if(itemData)then
		if(self.datas == nil)then
			self.datas = {};
		else
			TableUtility.TableClear(self.datas);
		end

		local equipCardInfo = itemData.equipedCardInfo or {};
		local cardSlotNum = itemData.cardSlotNum or 0;
		for i=1,cardSlotNum do
			if( equipCardInfo[i] )then
				table.insert(self.datas, equipCardInfo[i])
			else
				table.insert(self.datas, EquipCardCell.Empty);
			end
		end
		self.posCtl:ResetDatas(self.datas);
	 	local cells = self.posCtl:GetCells();
	 	self:ClickChoosePos(cells[1]);
	end
end

function CardPosChoosePopUp:OnEnter()
	CardPosChoosePopUp.super.OnEnter(self);

	local itemData = self.viewdata and self.viewdata.itemData;
	self:UpdateCardPosInfo(itemData);

	self:ActiveConfirmButton(self.choosePos ~= nil);
end

function CardPosChoosePopUp:OnExit()
	CardPosChoosePopUp.super.OnExit(self);

	self.choosePos = nil;
end