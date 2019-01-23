OricalCardInfoView = class("OricalCardInfoView", ContainerView)

OricalCardInfoView.ViewType = UIViewType.NormalLayer

autoImport("WrapListCtrl");
autoImport("OricalCardCell");
autoImport("OricalCardDetailInfo");

function OricalCardInfoView:Init()	
	self:InitView();
	self:MapEvent();
end

function OricalCardInfoView:InitView()	
	self.titleName = self:FindComponent("TitleName", UILabel);
	self.diffLabel = self:FindComponent("DiffLabel", UILabel);

	local wrap = self:FindGO("CardContent");
	self.cardInfoCtl = WrapListCtrl.new(wrap, 
		OricalCardCell, 
		"OricalCardCell",
		WrapListCtrl_Dir.Vertical);
	self.cardInfoCtl:AddEventListener(MouseEvent.MouseClick, self.ClickOricalCard, self)

	local cardDetailGO = self:FindGO("CardDetailInfo");
	self.cardDetailInfo = OricalCardDetailInfo.new(cardDetailGO);
end

function OricalCardInfoView:ClickOricalCard(cell)
	self:ShowCardDetailInfo(cell.data);
end

function OricalCardInfoView:ShowCardDetailInfo(data)
	if(data == nil)then
		return;
	end

	local cardId,num = data.id, data.num;
	if(cardId == nil)then
		return;
	end

	local cardData = Table_PveCard[cardId];
	if(cardData == nil)then
		self.cardDetailInfo:Hide();
		return;
	end
	self.cardDetailInfo:Show();
	self.cardDetailInfo:SetData(cardData);
end

function OricalCardInfoView:Update()
	local cardIds;
	if(Game.MapManager:IsPveMode_PveCard())then
		cardIds = DungeonProxy.Instance:GetSelectCardIds();
	else
		cardIds = DungeonProxy.Instance:GetCardData(self.index);
	end
	if(cardIds == nil)then
		return;
		-- cardIds = {};
		-- for i=1,30 do
		-- 	table.insert(cardIds, 111 + i);
		-- end
	end

	if(self.index ~= nil)then
		cardIds = self:PreHandleHandIds(cardIds);
	end

	self.cardInfoCtl:ResetDatas(cardIds);

	local myName = Game.Myself.data.name;
	self.titleName.text = string.format(ZhString.OricalCardInfoView_TitleName, myName);

	if(self.index == nil)then
		local index = DungeonProxy.Instance:GetNowPlayingIndex();
		self.diffLabel.text = ZhString["OricalCardInfoView_Diff_" .. index];
	else
		self.diffLabel.text = ZhString["OricalCardInfoView_Diff_" .. self.index];
	end
end

local CardTypeWeight = 
{
	Boss = 1,
	Environment = 2,
	Monster = 3,
	Item = 4
}
function OricalCardInfoView.CardSortFunc(a,b)
	local cardA = Table_PveCard[a];
	local cardB = Table_PveCard[b];

	local weightA = CardTypeWeight[ cardA.Type ];
	local weightB = CardTypeWeight[ cardB.Type ];

	if(weightA ~= weightB)then
		return weightA < weightB;
	end
	return cardA.id < cardB.id;
end
function OricalCardInfoView:PreHandleHandIds(cardIds)
	table.sort(cardIds, self.CardSortFunc);

	local result = {};

	for i=1,#cardIds do
		local id = cardIds[i];
		local combineCount = #result;

		if(combineCount == 0)then
			local data = { id = id, num = 1};
			table.insert(result, data);
		else
			local lastData = result[combineCount];
			if(lastData.id == id)then
				lastData.num = lastData.num + 1;
			else
				local data = { id = id, num = 1};
				table.insert(result, data);
			end
		end
	end

	return result;
end


function OricalCardInfoView:MapEvent()
	self:AddListenEvt(ServiceEvent.PveCardQueryCardInfoCmd, self.HandleOpenBarrowBag);
end

function OricalCardInfoView:HandleOpenBarrowBag(note)
	self:Update();
end

function OricalCardInfoView:OnEnter()
	OricalCardInfoView.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;
	self.index = viewdata.index;

	self:Update();
	
	-- QueryCardInfo
	ServicePveCardProxy.Instance:CallQueryCardInfoCmd();

	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(false);
end

function OricalCardInfoView:OnExit()
	self.cardDetailInfo:Unload_OldIconPic();
	
	OricalCardInfoView.super.OnExit(self);

	local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera];
	gOManager_Camera:ActiveMainCamera(true);
end
