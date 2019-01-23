autoImport("BusinessmanMakeData")

BusinessmanMakeProxy = class('BusinessmanMakeProxy', pm.Proxy)
BusinessmanMakeProxy.Instance = nil;
BusinessmanMakeProxy.NAME = "BusinessmanMakeProxy"

BusinessmanMakeProxy.Category = {
	AttributeWeapon = 5,	--属性武器
	MagicStone = 3,		--魔石
	SharpGold = 4,		--合金
	Medicine = 8,		--炼金药水
	Property = 9,		--炼金道具
	Runestone = 11,		--符文石
}

BusinessmanMakeProxy.Skill = {
	Businessman = {Type = 3, Category = {BusinessmanMakeProxy.Category.AttributeWeapon, BusinessmanMakeProxy.Category.MagicStone, BusinessmanMakeProxy.Category.SharpGold}},
	Alchemist = {Type = 4, Category = {BusinessmanMakeProxy.Category.Medicine, BusinessmanMakeProxy.Category.Property}},
	Knight = {Type = 5, Category = {BusinessmanMakeProxy.Category.Runestone}},
}

function BusinessmanMakeProxy:ctor(proxyName, data)
	self.proxyName = proxyName or BusinessmanMakeProxy.NAME
	if(BusinessmanMakeProxy.Instance == nil) then
		BusinessmanMakeProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
end

function BusinessmanMakeProxy:InitItemList(Type)
	if Type == nil then
		return
	end

	if self.initMap == nil then
		self.initMap = {}
	end

	if not self.initMap[Type] then
		if self.itemList == nil then
			self.itemList = {}
		end

		for k,v in pairs(Table_Compose) do
			if v.Type == Type then
				local itemList = self.itemList[v.Category]
				if itemList == nil then
					itemList = {}
					self.itemList[v.Category] = itemList
				end

				local data = BusinessmanMakeData.new(v.id)
				TableUtility.ArrayPushBack(itemList, data)
			end
		end

		self.initMap[Type] = true
	end
end

function BusinessmanMakeProxy:GetItemList(skill)
	if self.itemList ~= nil then
		return self.itemList[skill]
	end
end

function BusinessmanMakeProxy:GetMakeData(composeId)
	if composeId == nil then
		return nil
	end

	if self.itemList ~= nil then
		for k,v in pairs(self.itemList) do
			for i=1,#v do
				if v[i].id == composeId then
					return v[i]
				end
			end
		end
	end

	return nil
end

function BusinessmanMakeProxy:CheckItemType(itemData)
	if itemData.staticData then
		if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
			return FloatAwardView.ShowType.ModelType
		else
			return nil
		end
	end
	return nil
end