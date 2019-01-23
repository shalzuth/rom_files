autoImport("BagTabData")

BagMainTab = class("BagMainTab",BagTabData)

function BagMainTab:ctor()
	self.holdPlaceData = ItemData.new("PlaceHolder",0)
	BagMainTab.super.ctor(self)
end

function BagMainTab:ResetPlaceHolder(item)
	if(self.holdPlaceData.index ~= item.index) then
		-- print("重设占位 old:"..self.holdPlaceData.index.." new:"..item.index)
		self.dirty = true
		self.holdPlaceData.index = item.index
	end
end

function BagMainTab:ClearPlaceHolder()
	-- print("清除占位")
	self.dirty = true
	self.holdPlaceData.index = 0
end

function BagMainTab:ReArrange(serverSortedItems)
	self.dirty = true
	self:ClearPlaceHolder()
	-- self.items = {}
	if(serverSortedItems~=nil) then
		for i=1,#serverSortedItems do
			local sItem = serverSortedItems[i]
			local item = self.itemsMap[sItem.guid]
			if(item ~=nil) then
				item.index = sItem.index
				item.isNew = false;
			end
		end
	end
end

function BagMainTab:GetItems()
	if(self.dirty==true) then
		self.parsedItems = {unpack(self.items)}
		table.sort(self.parsedItems,function(l,r)
			return self:sortFunc(l,r)
		end)
		self.dirty = false
		if(self.holdPlaceData.index > 0) then
			table.insert(self.parsedItems,1,self.holdPlaceData)
		end
	end
	return self.parsedItems
end

function BagMainTab:sortFunc(left,right)
	if(left == nil) then return false
	elseif(right ==nil) then return true
	end
	if(left.index >right.index) then
		return true
	else
		return false
	end
end

--时装切页
BagFashionTab = class("BagFashionTab",BagTabData)

function BagFashionTab:GetItems()
	if(self.dirty==true) then
		self.parsedItems = {unpack(self.items)}
		table.sort(self.parsedItems,function(l,r)
			return self:sortFunc(l,r)
		end)
		self.dirty = false
	end
	return self.parsedItems
end

function BagFashionTab:sortFunc(left,right)
	if(left.num == right.num) then
		if(left.staticData.Type ==right.staticData.Type)then
			if(left.staticData.Quality ==right.staticData.Quality)then
				return left.staticData.id >right.staticData.id
			else
				return left.staticData.Quality >right.staticData.Quality
			end
		else
			return left.staticData.Type <right.staticData.Type
		end
	else
		return left.num>right.num
	end
	
	return false
end

--装备切页
BagEquipTab = class("BagEquipTab",BagTabData)

function BagEquipTab:SetProfess( pro )
	-- print("BagEquipTab set pro "..pro)
	self.profess = pro
end

function BagEquipTab:sortFunc(left,right)
	if(left.equipInfo and right.equipInfo)then
		local leftCanEquip = left.equipInfo:CanUseByProfess(self.profess)
		local rightCanEquip = right.equipInfo:CanUseByProfess(self.profess)
		if(left.equipInfo.equipData.EquipType == right.equipInfo.equipData.EquipType)then
			if(leftCanEquip == rightCanEquip) then
				if(left.staticData.Type ==right.staticData.Type) then
					if(left.staticData.Quality ==right.staticData.Quality) then
						return left.staticData.id >right.staticData.id
					else
						return left.staticData.Quality >right.staticData.Quality
					end
				else
					-- if(left.equipInfo:IsWeapon() and right.equipInfo:IsWeapon()) then
					-- 	return leftCanEquip
					-- else
						return left.staticData.Type <right.staticData.Type
					-- end
				end
			else
				return leftCanEquip
			end
		else
			return left.equipInfo.equipData.EquipType < right.equipInfo.equipData.EquipType
		end
	end
	return false
end

function BagEquipTab:FilterStrengthItems(strengthMaxLv,includeFashion)
	if(not strengthMaxLv and includeFashion) then
		return {unpack(self.items)}
	end
	strengthMaxLv = strengthMaxLv or 99999
	local fitItems = {}
	local item
	for i=1,#self.items do
		item = self.items[i]
		local equipMaxLv = GameConfig.StrengthMaxLv[item.staticData.Quality]
		local strLv = item.equipInfo and item.equipInfo.strengthlv  or 0
		local fit = equipMaxLv == nil or strLv < equipMaxLv
		if(strLv<strengthMaxLv and fit) then
			if(includeFashion or not item:IsFashion()) then
				fitItems[#fitItems+1] = item
			end
		end
	end
	return fitItems
end

function BagEquipTab:FilterRefineItems()
	local fitItems = {}
	local item
	local blackSmith = BlackSmithProxy.Instance
	for i=1,#self.items do
		item = self.items[i]
		if(item.equipInfo) then
			if(item.equipInfo:CanRefine()) then
				fitItems[#fitItems+1] = item
			end
		end
	end
	return fitItems
end

function BagEquipTab:FilterFashionItems(includeFashion)
	if(includeFashion) then
		return {unpack(self.items)}
	end
	local fitItems = {}
	local item
	for i=1,#self.items do
		item = self.items[i]
		if(not item:IsFashion()) then
			fitItems[#fitItems+1] = item
		end
	end
	return fitItems
end

function BagEquipTab:GetNotFashionItems(sortFunc)
	local fitItems = self:FilterFashionItems()
	sortFunc = sortFunc or function (l,r)
		if(l.staticData.id == r.staticData.id) then
			if(l.equipInfo.strengthlv==r.equipInfo.strengthlv) then
				return (l.equipInfo.refinelv<r.equipInfo.refinelv)
			else
				return l.equipInfo.strengthlv<r.equipInfo.strengthlv
			end
		else
			return l.staticData.id < r.staticData.id
		end
	end
	table.sort(fitItems,sortFunc)
	return fitItems
end

function BagEquipTab:GetStrengthItems(strengthMaxLv,includeFashion)
	local fitItems = self:FilterStrengthItems(strengthMaxLv,includeFashion)
	table.sort(fitItems,function(l,r)
			--装备ID（大至小）＞强化等级（高至低）
			if(l.staticData.id == r.staticData.id) then
				local lstrLv = l.equipInfo and l.equipInfo.strengthlv  or 0
				local rstrLv = r.equipInfo and r.equipInfo.strengthlv  or 0
				return lstrLv > rstrLv
			else
				return l.staticData.id > r.staticData.id
			end
		end)
	return fitItems
end

function BagEquipTab:GetRefineItems()
	local fitItems = self:FilterRefineItems()
	table.sort(fitItems,function(l,r)
			if(l.staticData.id == r.staticData.id) then
				if(l.equipInfo and r.equipInfo)then
					return l.equipInfo.refinelv > r.equipInfo.refinelv
				else
					return true
				end
			else
				return l.staticData.id > r.staticData.id
			end
		end)
	return fitItems
end

function BagEquipTab:GetFitItems(staticID,refinelv,strengthlv)
	local res = {}
	refinelv = refinelv or 0
	strengthlv = strengthlv or 0
	local item
	for i=1,#self.items do
		item = self.items[i]
		if(item.staticData.id == staticID and item.equipInfo.refinelv==refinelv and item.equipInfo.strengthlv == strengthlv) then
			res[#res+1] = item
		end
	end
	return res
end