autoImport("CardRandomMakeData")
autoImport("CardMakeData")

CardMakeProxy = class('CardMakeProxy', pm.Proxy)
CardMakeProxy.Instance = nil;
CardMakeProxy.NAME = "CardMakeProxy"

CardMakeProxy.MakeType = {
	Random = SceneItem_pb.EEXCHANGECARDTYPE_DRAW,
	Compose = SceneItem_pb.EEXCHANGECARDTYPE_COMPOSE,
	Decompose = SceneItem_pb.EEXCHANGECARDTYPE_DECOMPOSE,
}

local tempList = {}
local filter = {}
local _getCardList = {}
local _getItemList = {}
local packageCheck = GameConfig.PackageMaterialCheck.exchange
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear

function CardMakeProxy:ctor(proxyName, data)
	self.proxyName = proxyName or CardMakeProxy.NAME
	if(CardMakeProxy.Instance == nil) then
		CardMakeProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function CardMakeProxy:Init()
	self.randomCardList = {}
	self.filterRandomCardList = {}
	self.chooseRandomCardList = {}

	self.filterCardList = {}

	self.decomposeCardList = {}
	self.filterDecomposeCardList = {}

	self.cardConfig = {
		[self.MakeType.Random] = {name = EffectMap.Maps.Randomcard, audio = AudioMap.Maps.Randomcard, skipType = SKIPTYPE.CardRandomMake},
		[self.MakeType.Compose] = {name = EffectMap.Maps.Compoundcard, audio = AudioMap.Maps.Compoundcard, skipType = SKIPTYPE.CardMake},
		[self.MakeType.Decompose] = {name = EffectMap.Maps.Randomcard, audio = AudioMap.Maps.Randomcard, skipType = SKIPTYPE.CardDecompose},
	}
end

function CardMakeProxy:RecvExchangeCardItemCmd(data)
	self.npcid = data.npcid
	local npcRole = SceneCreatureProxy.FindCreature(data.npcid)
	local isSelf = data.charid == Game.Myself.data.id
	local config = self.cardConfig[data.type]

	--自己制作 and 跳过动画
	if isSelf then
		if self:IsSkipGetEffect(config.skipType) then
			self:ShowAward(data.cardid, data.items)
			return
		end
	end

	--不跳过动画
	if isSelf then
		self:ShowAward(data.cardid, data.items, true)
	end
	if npcRole then
		--找到npc
		if isSelf then
			self:CameraReset()

			local viewPort = CameraConfig.CardMake_ViewPort
			local duration = CameraConfig.NPC_Dialog_DURATION
			self.cft = CameraEffectFocusTo.new(npcRole.assetRole.completeTransform, viewPort, duration)
			FunctionCameraEffect.Me():Start(self.cft)

			Game.Myself:Client_NoMove(true)
		end

		--动作
		npcRole:Client_PlayAction('functional_action', nil, false)
		--特效
		if self.effect then
			self.effect:Destroy()
			self.effect = nil
		end
		
		self.effect = npcRole:PlayEffect(nil, config.name, 0, nil, nil, true)
		self.effect:RegisterWeakObserver(self)
		npcRole:PlayAudio(config.audio)

		if isSelf then
			--获得物品界面
			LeanTween.delayedCall(GameConfig.Delay.card_exchange / 1000, function ()
				local id = TableUtility.ArrayPopFront(_getCardList)
				if id then
					self:ShowFloatAward(id)
				elseif #_getItemList > 0 then
					self:ShowItemPop(_getItemList)
				end

				self:CameraReset()
				Game.Myself:Client_NoMove(false)
			end)
		end
	else
		--找不到npc,自己制作成功飘字
		if isSelf then
			self:ShowAward(data.cardid, data.items)
		end
	end
end

function CardMakeProxy:ObserverDestroyed(obj)
	if obj == self.effect then
		self.effect = nil
	end
end

function CardMakeProxy:ShowAward(cardid, items, isDelay)
	if #items > 0 then
		_ArrayClear(_getItemList)

		for i=1,#items do
			local item = items[i]
			local itemData = ItemData.new(item.guid, item.id)
			itemData.num = item.count
			_ArrayPushBack(_getItemList, itemData)
		end
		if not isDelay then
			self:ShowItemPop(_getItemList)
		end
	else
		local itemData = ItemData.new("ExchangeCard", cardid)
		if isDelay then
			_ArrayPushBack(_getCardList, itemData)
		else
			self:ShowFloatAward(itemData)
		end
	end
end

function CardMakeProxy:ShowFloatAward(itemData)
	if BagProxy.CheckIsCardTypeItem(itemData.staticData.Type) then
		FloatAwardView.addItemDatasToShow({itemData} ,function ()
			local npcRole = SceneCreatureProxy.FindCreature(self.npcid)
			if npcRole then
				local viewdata = {
					viewname = "DialogView",
					dialoglist = {9},
					npcinfo = npcRole,
					addconfig = npcRole.data.staticData.NpcFunction,
				}
				FunctionNpcFunc.ShowUI(viewdata)
			end
		end, nil, true)
	end
end

function CardMakeProxy:ShowItemPop(itemlist)
	self:sendNotification(UIEvent.ShowUI, {viewname = "PopUp10View"})
	self:sendNotification(SystemMsgEvent.MenuItemPop, itemlist)
end

function CardMakeProxy:CameraReset()
	if self.cft ~= nil then
		FunctionCameraEffect.Me():End(self.cft)
		self.cft = nil
	end
end

--可抽卡卡片列表
function CardMakeProxy:InitRandomCard()
	_ArrayClear(self.randomCardList)

	for i=1,#packageCheck do
		local items = BagProxy.Instance:GetBagItemsByTypes(Game.Config_ItemTypeGroup[BagProxy.ItemTypeGroup.Card], packageCheck[i])
		if items ~= nil then
			for j=1,#items do
				local bagData = items[j]
				if bagData.staticData.Quality < 4 and not bagData:CheckItemCardType(Item_CardType.Raffle) then
					for j=1,bagData.num do
						local data = CardRandomMakeData.new( bagData:Clone() )
						_ArrayPushBack(self.randomCardList, data)
					end
				end
			end
		end
	end

	self:SortRandomCard(self.randomCardList)
end

function CardMakeProxy:GetRandomCard()
	return self.randomCardList
end

--抽卡排序
function CardMakeProxy:SortRandomCard(list)
	table.sort( list, CardMakeProxy._SortRandomCard)
end

function CardMakeProxy._SortRandomCard(l,r)
	if l.isChoose == r.isChoose then
		local staticDatal = l.itemData.staticData
		local staticDatar = r.itemData.staticData
		if staticDatal and staticDatar then
			if staticDatal.Quality == staticDatar.Quality then
				return staticDatal.id < staticDatar.id
			else
				return staticDatal.Quality < staticDatar.Quality
			end
		end
	else
		return l.isChoose
	end
end

--根据卡片品质筛选
function CardMakeProxy:FilterRandomCard(quality)
	if quality == 0 then
		self:SortRandomCard(self.randomCardList)
		return self.randomCardList
	end

	_ArrayClear(self.filterRandomCardList)

	for i=1,#self.randomCardList do
		local data = self.randomCardList[i]
		if data.isChoose then
			_ArrayPushBack(self.filterRandomCardList, data)
		elseif data.itemData and data.itemData.staticData and data.itemData.staticData.Quality == quality then 
			_ArrayPushBack(self.filterRandomCardList, data)
		end
	end

	self:SortRandomCard(self.filterRandomCardList)

	return self.filterRandomCardList
end

function CardMakeProxy:CheckFilterRandomCardList(quality)
	if quality == 0 then
		return self.randomCardList
	end

	for i = #self.filterRandomCardList, 1, -1  do
		local data = self.filterRandomCardList[i]
		if not data.isChoose and data.itemData and data.itemData.staticData and data.itemData.staticData.Quality ~= quality then
			table.remove(self.filterRandomCardList, i)
		end
	end

	return self.filterRandomCardList
end

--获得选中列表
function CardMakeProxy:GetRandomChooseList()
	_ArrayClear(self.chooseRandomCardList)
	local data
	for i=1,#self.randomCardList do
		data = self.randomCardList[i]
		if data.isChoose then
			_ArrayPushBack(self.chooseRandomCardList, data)
		end
	end
	return self.chooseRandomCardList
end

--获得选中id列表
function CardMakeProxy:GetRandomChooseIdList()
	_ArrayClear(tempList)

	for i=1,#self.chooseRandomCardList do
		_ArrayPushBack(tempList, self.chooseRandomCardList[i].itemData.id)
	end
	
	return tempList
end

function CardMakeProxy:GetRandomCost()
	local randomList = GameConfig.CardMake.RandomTip
	local data
	for i=1,#Table_CardRate do
		_ArrayClear(tempList)
		for i=1,#self.chooseRandomCardList do
			_ArrayPushBack(tempList, self.chooseRandomCardList[i].itemData.staticData.Quality)
		end

		data = Table_CardRate[i]
		for j=1,#data.quality do
			TableUtility.ArrayRemove(tempList, data.quality[j])
		end

		if #tempList == 0 then
			return data.Cost
		end
	end

	return nil	
end

function CardMakeProxy:InitRandomGetList()
	for k,v in pairs(Table_Card) do
		if self:CheckType(v.Type, Item_CardType.Get) then
			local data = ItemData.new("Card", v.id)
			_ArrayPushBack(self.randomGetList, data)
		end
	end

	table.sort(self.randomGetList, CardMakeProxy._SortRandomGet)
end

function CardMakeProxy._SortRandomGet(l,r)
	local staticDatal = l.staticData
	local staticDatar = r.staticData
	if staticDatal and staticDatar then
		if staticDatal.Quality == staticDatar.Quality then
			return staticDatal.id < staticDatar.id
		else
			return staticDatal.Quality > staticDatar.Quality
		end
	end
end

function CardMakeProxy:GetRandomGetList()
	if self.randomGetList == nil then
		self.randomGetList = {}
		self:InitRandomGetList()
	end

	return self.randomGetList
end

--可制作卡片列表
function CardMakeProxy:InitCard()
	self.cardList = {}

	for k,v in pairs(Table_Compose) do
		if v.Category == 7 then
			local data = CardMakeData.new(k)
			_ArrayPushBack(self.cardList, data)
		end
	end
end

function CardMakeProxy:GetCard()
	return self.cardList
end

function CardMakeProxy:SortCard(list)
	table.sort( list, CardMakeProxy._SortCard)
end

function CardMakeProxy._SortCard(l,r)
	local composel = Table_Compose[l.id]
	local composer = Table_Compose[r.id]
	local staticDatal = l.itemData.staticData
	local staticDatar = r.itemData.staticData
	if staticDatal and staticDatar then
		if composel.IsTop == composer.IsTop then
			if staticDatal.Quality == staticDatar.Quality then
				return staticDatal.id < staticDatar.id
			else
				return staticDatal.Quality > staticDatar.Quality
			end
		else
			return composel.IsTop == 1
		end
	end
end

function CardMakeProxy:FilterCard(type)
	if self.cardList == nil then
		self:InitCard()
	end

	if type == 0 then
		self:SortCard(self.cardList)

		return self.cardList
	end

	_ArrayClear(self.filterCardList)

	for i=1,#self.cardList do
		local data = self.cardList[i]
		if data.itemData and data.itemData.staticData and data.itemData.staticData.Type == type then 
			_ArrayPushBack(self.filterCardList, data)
		end
	end

	self:SortCard(self.filterCardList)

	return self.filterCardList
end

function CardMakeProxy:CanMake()
	if self.chooseData then
		return self.chooseData:CanMake()
	else
		return false
	end
end

--筛选下拉框
function CardMakeProxy:GetFilter(filterData)
	_ArrayClear(filter)
	for k,v in pairs(filterData) do
		table.insert(filter,k)
	end
	table.sort( filter, function (l,r)
		return l < r
	end )
	return filter
end

--是否高级卡片
function CardMakeProxy:IsCostGreatCard(composeId)
	local data = Table_Compose[composeId]
	if data then
		for i=1,#data.BeCostItem do
			local itemid = data.BeCostItem[i].id
			if Table_Card[itemid] ~= nil then
				local staticData = Table_Item[itemid]
				if staticData and staticData.Quality >= 4 then
					return true
				end
			end
		end
	end

	return false
end

function CardMakeProxy:CheckType(type,index)
	if type == nil or index == nil then
		return false
	end
	return type & index > 0
end

function CardMakeProxy:SetChoose(data)
	self.chooseData = data
end

function CardMakeProxy:GetChoose()
	return self.chooseData
end

function CardMakeProxy:CheckCanMake(materialData)
	if materialData and self.chooseData then
		return self.chooseData:CheckCanMake(materialData)
	end

	return false
end

function CardMakeProxy:IsSkipGetEffect(type)
	return LocalSaveProxy.Instance:GetSkipAnimation(type)
end

function CardMakeProxy:GetItemNumByStaticID(itemid)
	local _BagProxy = BagProxy.Instance
	local count = 0
	for i=1,#packageCheck do
		count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
	end
	return count
end

function CardMakeProxy:InitDecomposeCard()
	_ArrayClear(self.decomposeCardList)

	local _BagProxy = BagProxy.Instance

	for i=1,#packageCheck do
		local items = _BagProxy:GetBagItemsByTypes(Game.Config_ItemTypeGroup[BagProxy.ItemTypeGroup.Card], packageCheck[i])
		if items ~= nil then
			for j=1,#items do
				local bagData = items[j]
				if bagData.staticData.Quality <= 4 and not bagData:CheckItemCardType(Item_CardType.Decompose) then
					_ArrayPushBack(self.decomposeCardList, bagData:Clone())
				end
			end
		end
	end

	self:SortDecomposeCard(self.decomposeCardList)
end

function CardMakeProxy:GetDecomposeCard()
	return self.decomposeCardList
end

function CardMakeProxy:FilterDecomposeCard(quality)
	if quality == 0 then
		self:SortDecomposeCard(self.decomposeCardList)
		return self.decomposeCardList
	end

	_ArrayClear(self.filterDecomposeCardList)

	for i=1,#self.decomposeCardList do
		local data = self.decomposeCardList[i]
		if data.staticData.Quality == quality then 
			_ArrayPushBack(self.filterDecomposeCardList, data)
		end
	end

	self:SortDecomposeCard(self.filterDecomposeCardList)

	return self.filterDecomposeCardList
end

function CardMakeProxy:SortDecomposeCard(list)
	table.sort( list, CardMakeProxy._SortDecomposeCard)
end

function CardMakeProxy._SortDecomposeCard(l,r)
	local staticDatal = l.staticData
	local staticDatar = r.staticData
	if staticDatal and staticDatar then
		if staticDatal.Quality == staticDatar.Quality then
			return staticDatal.id < staticDatar.id
		else
			return staticDatal.Quality < staticDatar.Quality
		end
	end
end

function CardMakeProxy:GetDecomposeMaterialItemData()
	if self.decomposeMaterialItemData == nil then
		self.decomposeMaterialItemData = ItemData.new("CardDecompose", GameConfig.Card.decompose_item_id)
	end

	return self.decomposeMaterialItemData
end