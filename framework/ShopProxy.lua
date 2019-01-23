autoImport("ShopData")

ShopProxy = class('ShopProxy', pm.Proxy)
ShopProxy.Instance = nil;
ShopProxy.NAME = "ShopProxy"

function ShopProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ShopProxy.NAME
	if ShopProxy.Instance == nil then
		ShopProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function ShopProxy:Init()
	self.info = {}
	self.callTime = {}
end

function ShopProxy:CallQueryShopConfig(type, shopID)
	local currentTime = Time.unscaledTime
	local nextValidTime
	local infoMap = self.info[type]
	if infoMap and infoMap[shopID] then
		nextValidTime = infoMap[shopID]:GetNextValidTime()
	end
	if nextValidTime == nil or nextValidTime <= currentTime then
		if infoMap == nil then
			infoMap = {}
			self.info[type] = infoMap
		end
		if infoMap[shopID] == nil then
			infoMap[shopID] = ShopData.new()
			self.info[type][shopID] = infoMap[shopID]
		end
		infoMap[shopID]:SetNextValidTime(5)

		helplog("CallQueryShopConfigCmd", type, shopID)
		ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(type, shopID)
	end
end

function ShopProxy:RecvQueryShopConfig(servicedata)
	local type = servicedata.type
	local shopID = servicedata.shopid
	local goods = servicedata.goods

	local infoMap = self.info[type]
	if infoMap == nil then
		infoMap = {}
		self.info[type] = infoMap
	end
	if infoMap[shopID] == nil then
		infoMap[shopID] = ShopData.new(servicedata)
		self.info[type][shopID] = infoMap[shopID]
	else
		infoMap[shopID]:SetData(servicedata)
	end
	infoMap[shopID]:SetNextValidTime(60)
end

function ShopProxy:RecvServerLimitSellCountCmd(servicedata)
	local config = self:GetConfigByTypeId(servicedata.type, servicedata.shopID)
	if config then
		for i=1,#servicedata.sell_infos do
			local data = servicedata.sell_infos[i]
			local shopItemData = config[data.id]
			if shopItemData ~= nil then
				shopItemData:SetCurProduceNum(data.sell_count)
			end
		end
	end
end

function ShopProxy:RecvShopDataUpdateCmd(servicedata)
	local infoMap = self.info[servicedata.type]
	if infoMap ~= nil then
		local shop = infoMap[servicedata.shopid]
		if shop ~= nil then
			shop:SetNextValidTime(0)
		end
	end
end

function ShopProxy:RecvUpdateShopConfigCmd(servicedata)
	local infoMap = self.info[servicedata.type]
	if infoMap ~= nil then
		local shop = infoMap[servicedata.shopid]
		if shop ~= nil then
			for i=1,#servicedata.add_goods do
				shop:AddShopItemData(servicedata.add_goods[i])
			end
			for i=1,#servicedata.del_goods_id do
				shop:RemoveShopItemData(servicedata.del_goods_id[i])
			end
		end
	end
end

--获得对应shop type的列表
function ShopProxy:GetConfigByType(type)
	return self.info[type] or {}
end

--获得对应type和shopid的列表
function ShopProxy:GetConfigByTypeId(type, shopID)
	local infoMap = self.info[type]
	if infoMap and infoMap[shopID] then
		return infoMap[shopID]:GetGoods()
	end

	return {}
end

--获得对应type和shopid的shop data
function ShopProxy:GetShopDataByTypeId(type, shopID)
	local infoMap = self.info[type]
	if infoMap then
		return infoMap[shopID]
	end

	return nil
end

--获得对应type、shopid和id的shop item data
function ShopProxy:GetShopItemDataByTypeId(type, shopID, id)
	local config = self:GetConfigByTypeId(type, shopID)
	if config then
		return config[id]
	end

	return nil
end

-- 设置商品出售数量
function ShopProxy:Server_SetShopSoldCountCmdInfo(server_items)
	if(server_items == nil or #server_items == 0)then
		return;
	end

	for i=1,#server_items do
		local item = server_items[i];
		local shopData = self:GetShopDataByTypeId(item.type, item.shopid);
		helplog(item.type, item.shopid);
		if(shopData)then
			local shopItemData = shopData.goods[item.id];
			if(shopItemData)then
				helplog(item.count);
				shopItemData:SetSoldCount(item.count);
			end
		end
	end
end