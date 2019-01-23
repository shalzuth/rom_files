autoImport("ItemData")
autoImport("BagTabData")
autoImport("BagMainTab")
autoImport("BagData")
CardBagData = class("CardBagData",BagData)

function CardBagData:ctor(tabs,tabClass,type)
	CardBagData.super.ctor(self,tabs,tabClass,type)	
end

function CardBagData:getCardsOrCardFragmentsByPosition( Position,tab )
	-- body
	local items = self:GetItems(tab)
	local datas = {}

	for i=1,#items do
		local single = items[i]
		local cardInfo = single.cardInfo
		if( Position==0 or (cardInfo~=nil and cardInfo.Position==Position) )then
			table.insert(datas,single)
		end			
	end

	table.sort(datas,function(l,r)
			return self:sortFunc(l,r)
		end)

	return datas
end

function CardBagData:sortFunc(left,right)
	if(left == nil) then return false
	elseif(right ==nil) then return true
	end
	if(left.cardInfo.Quality == right.cardInfo.Quality) then
		return left.cardInfo.id >= right.cardInfo.id		
	else
		return left.cardInfo.Quality >= right.cardInfo.Quality
	end
end

function CardBagData:getCardFragmentsByCardId( cardId )
	-- body
	local items = self:GetItems(GameConfig.CardPage[110])
	local datas = {}
	for i=1,#items do
		local single = items[i]
		local cardInfo = single.cardInfo
		if(cardInfo~=nil and cardInfo.id == cardId)then
			table.insert(datas,single)
		end
	end
	return datas
end


function CardBagData:getCardDataByCardId( cardId )
	-- body
	local items = self:GetItems(GameConfig.CardPage[1])
	for i=1,#items do
		local single = items[i]
		local cardInfo = single.cardInfo		
		if(cardInfo~=nil and cardInfo.id == cardId)then
			return single
		end
	end
end

function CardBagData:getCardFragments(  )
	-- body
	local items = self:GetItems(GameConfig.CardPage[110])
	local datas = {}
	for i=1,#items do
		local single = items[i]
		local cardInfo = single.cardInfo
		if(cardInfo~=nil)then
			local cardId = cardInfo.CardID
			local cardTable = datas[cardId] or {}
			local index = single.Position;
			cardTable[index] = single;
			datas[cardId] = cardTable
		end
	end
	
	local rTable = {}
	for k,v in pairs(datas) do
		local data = {}
		data.cardId = k
		data.fragments = v
		table.insert(rTable,data)
	end
	table.sort(rTable,function ( l,r )
		-- body
		return #l.fragments > #r.fragments 
	end)
	return rTable
end


-- function CardBagData:getCardFragmentsByCardId( cardId )
-- 	-- body
-- 	local items = self:GetItems(GameConfig.CardPage[110])
-- 	local datas = {}
-- 	for i=1,#items do
-- 		local single = items[i]
-- 		local cardInfo = single.cardInfo
-- 		if(cardInfo~=nil and cardInfo.CardID == cardId)then
-- 			table.insert(datas,single)
-- 		end
-- 	end
-- 	return datas
-- end
