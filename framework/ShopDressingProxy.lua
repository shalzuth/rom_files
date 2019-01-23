ShopDressingProxy = class('ShopDressingProxy', pm.Proxy)
ShopDressingProxy.Instance = nil;
ShopDressingProxy.NAME = "ShopDressingProxy"

ShopDressingProxy.DressingType=
{
	HAIR = SceneUser2_pb.EDRESSTYPE_HAIR,
	HAIRCOLOR = SceneUser2_pb.EDRESSTYPE_HAIRCOLOR,
	EYE = SceneUser2_pb.EDRESSTYPE_EYE,
	ClothColor = SceneUser2_pb.EDRESSTYPE_CLOTH,
}

ShopDressingProxy.DressShopType = 
{
	Hair=950,
	EyeLenses=960,
	ClothColor = 961,
}

function ShopDressingProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ShopDressingProxy.NAME
	if(ShopDressingProxy.Instance == nil) then
		ShopDressingProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function ShopDressingProxy:Init()
	self.activeIDs={}
end

function ShopDressingProxy:InitProxy(shopID,shopType)
	self.shopID = shopID
	self.shopType = shopType
	self.queryData={}
	ShopProxy.Instance:CallQueryShopConfig(self.shopType,self.shopID)

	self.chooseData={}
	
	if(Game and Game.Myself and Game.Myself.data and Game.Myself.data.userdata)then
		local userData = Game.Myself.data.userdata
		self.originalHair = userData:Get(UDEnum.HAIR)
		self.originalHairColor = userData:Get(UDEnum.HAIRCOLOR)
		self.originalEye = userData:Get(UDEnum.EYE)
		self.originalBodyColor = userData:Get(UDEnum.CLOTHCOLOR)
		self.originalBody = userData:Get(UDEnum.BODY)
		self.originalHead = userData:Get(UDEnum.HEAD)
		self.originalFace = userData:Get(UDEnum.FACE)
	else
		errorLog("ShopDressingProxy InitHairProxy:Get Role_Asset parts failed")
	end
end

function ShopDressingProxy:GetShopType()
	if(self.shopType)then
		return self.shopType
	end
end

function ShopDressingProxy:GetShopId()
	if (self.shopID)then
		return self.shopID
	end
end

function ShopDressingProxy:RecvNewDressing(data)
	if(nil==self.activeIDs[data.type])then
		self.activeIDs[data.type]={}
	end
	for i,v in ipairs(data.dressids) do
		local bContain = false
		for key,value in ipairs(self.activeIDs) do
			if(value==v)then
				bContain=true;
				break;
			end
		end
		if(not bContain)then
			table.insert(self.activeIDs[data.type],v)
		end
	end
	-- for k,v in pairs(self.activeIDs) do
	-- 	helplog("Dressing 类型： ",tostring(k))
	-- 	for i=1,#v do
	-- 		helplog("激活的ID：",v[i])
	-- 	end
	-- end
end

function ShopDressingProxy:RecvDressingListUserCmd(data)
	if(nil==self.activeIDs[data.type])then
		self.activeIDs[data.type]={}
	end
	TableUtility.TableClear(self.activeIDs[data.type])
	for i,v in ipairs(data.dressids) do
		table.insert(self.activeIDs[data.type],v)
	end
end

function ShopDressingProxy:bActived(id,type)
	if(self.activeIDs and self.activeIDs[type])then
		for k,v in ipairs(self.activeIDs[type])do
			if(v==id)then
				return true
			end
		end
	end
	return false
end

function ShopDressingProxy:GetHairStyleIDByItemID(itemid)
	for _,v in pairs(Table_HairStyle) do
		if(v.ItemID==itemid)then
			return v.id;
		end
	end
	return nil;
end

function ShopDressingProxy:GetEyeIDByItemID(itemid)
	for _,v in pairs(Table_Eye) do
		if(v.ItemID==itemid)then
			return v.id;
		end
	end
	return nil;
end

function ShopDressingProxy:ResetData()
	self.staticData = {}
	local heroLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL);
	local csvData = ShopProxy.Instance:GetConfigByTypeId(self.shopType,self.shopID)
	for k,v in pairs(csvData) do
		local dressShopType = GameConfig.ShopDressingType or ShopDressingProxy.DressShopType
		if(self.shopType==dressShopType.ClothColor)then
			if(nil==self.staticData[ShopDressingProxy.DressingType.ClothColor])then
				self.staticData[ShopDressingProxy.DressingType.ClothColor]={}
			end
			table.insert(self.staticData[ShopDressingProxy.DressingType.ClothColor],v)
		end
		local limitedLevel=0;
		if(#v.LevelDes>0) then
			local startIndex,endIndex=string.find(v.LevelDes,"%d+")
			limitedLevel=string.sub(v.LevelDes,startIndex,endIndex);
		end
			
		if(heroLevel>=tonumber(limitedLevel)) then
			if(v.goodsID and v.goodsID~=0)then
				if(self.shopType==dressShopType.Hair)then
					local hairid = self:GetHairStyleIDByItemID(v.goodsID);
					local hairStyleData = Table_HairStyle[hairid];
					if(hairStyleData and hairStyleData.Sex) then
						if(MyselfProxy.Instance:GetMySex()==hairStyleData.Sex or hairStyleData.Sex==3)then
							if(hairStyleData.IsPro and hairStyleData.IsPro==1 and hairStyleData.OnSale and hairStyleData.OnSale == 1)then
								if(nil==self.staticData[ShopDressingProxy.DressingType.HAIR])then
									self.staticData[ShopDressingProxy.DressingType.HAIR]={}
								end
								table.insert(self.staticData[ShopDressingProxy.DressingType.HAIR],v)
							end
						end
					end
				elseif(self.shopType==dressShopType.EyeLenses)then
					local eyeID = v.goodsID
					local eyeStaticData = Table_Eye[eyeID];
					if(eyeStaticData and eyeStaticData.Sex) then
						if(MyselfProxy.Instance:GetMySex()==eyeStaticData.Sex or eyeStaticData.Sex==3)then
							if(eyeStaticData.IsPro and eyeStaticData.IsPro==1 and eyeStaticData.OnSale and eyeStaticData.OnSale == 1)then
								if(nil==self.staticData[ShopDressingProxy.DressingType.EYE])then
									self.staticData[ShopDressingProxy.DressingType.EYE]={}
								end
								table.insert(self.staticData[ShopDressingProxy.DressingType.EYE],v)
							end
						end
					end
				end
			end
			if(v.hairColorID and v.haircolorid~=0)then
				local hairColorID = v.hairColorID;
				local hairColorData = Table_HairColor[hairColorID];
				if(hairColorData)then
					if(nil==self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR])then
						self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR]={}
					end
					table.insert(self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR],v)
				end
			end
		end
	end
	if(self.shopType==ShopDressingProxy.DressShopType.Hair)then
		if(self.staticData[ShopDressingProxy.DressingType.HAIR])then
			table.sort( self.staticData[ShopDressingProxy.DressingType.HAIR], function (l,r)
				return self:_sortHairFunc(l,r)
			end )
		end
		if(self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR])then
			table.sort(self.staticData[ShopDressingProxy.DressingType.HAIRCOLOR],function (l,r)
				return self:_colorSortFunc(l,r)
			end)
		end
	elseif(self.staticData[ShopDressingProxy.DressingType.EYE])then
		table.sort( self.staticData[ShopDressingProxy.DressingType.EYE], function (l,r)
				return self:_sortEyelensesFunc(l,r)
			end )
	elseif(self.staticData[ShopDressingProxy.DressingType.ClothColor])then
		table.sort( self.staticData[ShopDressingProxy.DressingType.ClothColor], function (l,r)
				return self:_sortClothFunc(l,r)
			end )
	end
end

function ShopDressingProxy:_sortHairFunc(left,right)
	if(left == nil) then 
		return false
	elseif(right ==nil) then 
		return true
	end
	if(not left.ShopOrder or not right.ShopOrder)then helplog("Shop表中发型物品未配ShopOrder字段");return false; end
	local leftHairId = self:GetHairStyleIDByItemID(left.goodsID);
	local bleftUnlock = self:bActived(leftHairId,ShopDressingProxy.DressingType.HAIR)
	local rightHairId =  self:GetHairStyleIDByItemID(right.goodsID);
	local brightUnlock = self:bActived(rightHairId,ShopDressingProxy.DressingType.HAIR)

	if(bleftUnlock and brightUnlock)then
		return left.ShopOrder<right.ShopOrder
	elseif(bleftUnlock and not brightUnlock)then
		return true
	elseif(not bleftUnlock and brightUnlock)then
		return false
	else
		return left.ShopOrder<right.ShopOrder
	end
end

function ShopDressingProxy:_sortEyelensesFunc(left,right)
	if(left == nil) then 
		return false
	elseif(right ==nil) then 
		return true
	end
	local bleftUnlock = self:bActived(left.goodsID,ShopDressingProxy.DressingType.EYE)
	local brightUnlock = self:bActived(right.goodsID,ShopDressingProxy.DressingType.EYE)

	if(bleftUnlock and brightUnlock)then
		return left.ShopOrder<right.ShopOrder
	elseif(bleftUnlock and not brightUnlock)then
		return true
	elseif(not bleftUnlock and brightUnlock)then
		return false
	else
		return left.ShopOrder<right.ShopOrder
	end
end

function ShopDressingProxy:_sortClothFunc(left,right)
	if(left == nil) then 
		return false
	elseif(right ==nil) then 
		return true
	end
	local bleftUnlock = self:CheckCanOpen(left.MenuID)
	local brightUnlock = self:CheckCanOpen(right.MenuID)

	if(bleftUnlock and brightUnlock)then
		return left.ShopOrder<right.ShopOrder
	elseif(bleftUnlock and not brightUnlock)then
		return true
	elseif(not bleftUnlock and brightUnlock)then
		return false
	else
		return left.ShopOrder<right.ShopOrder
	end
end

function ShopDressingProxy:_colorSortFunc(left,right)
	if(left == nil)then 
		return false
	elseif(right ==nil)then 
		return true
	end
	if(not left.ShopOrder or not right.ShopOrder)then helplog("Shop表发型颜色物品中未配ShopOrder字段.");return false; end
	if(left.ShopOrder~=right.ShopOrder)then
		return left.ShopOrder<right.ShopOrder
	else
		return left.id<right.id;
	end
end

function ShopDressingProxy:SetQueryData(args)
	if(nil==args)then
		self.queryData={}
		return
	end
	self.queryData.type=args[1]
	self.queryData.id=args[2]
	self.queryData.count=args[3]
end

function ShopDressingProxy:GetQueryData()
	return self.queryData
end

function ShopDressingProxy:ReUniteCellData(datas, perRowNum)
	local newData = {};
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end

function ShopDressingProxy:CallReplaceDressing(id,count)
	ServiceSessionShopProxy.Instance:CallBuyShopItem(id,count);
end

local tempVector3 = LuaVector3.zero
function ShopDressingProxy:FakeDressingPreview(args)
	if nil==Game.Myself.assetRole then
		return
	end
	local partIndex = Asset_Role.PartIndex;
	local partIndexEx = Asset_Role.PartIndexEx;
	tempVector3:Set(Game.Myself.assetRole:GetPositionXYZ())
	local parts = Asset_Role.CreatePartArray();
	parts[partIndex.Hair] = args[1]
	parts[partIndexEx.HairColorIndex] = args[2]
	parts[partIndex.Eye] = args[3]
	
	parts[partIndexEx.BodyColorIndex] = args[6]
	parts[partIndex.Body] = args[7]
	parts[partIndex.Head] = args[8]
	parts[partIndex.Face] = args[9]
	if(nil==self.fakeAssetRole)then
		self.fakeAssetRole = Asset_Role.Create(parts)
	end
	self.fakeAssetRole:SetPosition(tempVector3)
	self.fakeAssetRole:IgnoreHead(args[4])
	self.fakeAssetRole:IgnoreFace(args[5])
	self.fakeAssetRole:Redress(parts)
	Asset_Role.DestroyPartArray(parts)
end

function ShopDressingProxy:DestroyFakeModel()
	if(self.fakeAssetRole)then
		self.fakeAssetRole:Destroy()
		self.fakeAssetRole=nil
	end
end

local BodyId
function ShopDressingProxy:getBodyID()
	local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
	if(self.shopType==ShopDressingProxy.DressShopType.ClothColor and Table_Body[self.originalBody] and 1==Table_Body[self.originalBody].Feature)then
		local sex = Game.Myself.data.userdata:Get(UDEnum.SEX);
		BodyId = sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
	else
		BodyId = self.originalBody
	end
	return BodyId
end

function ShopDressingProxy:RedressModel(enterPreview)
	if(not enterPreview)then
		self:DestroyFakeModel()
		return
	end
	local userdata = Game.Myself.data.userdata;
	local args = ReusableTable.CreateArray()
	args[1]=userdata:Get(UDEnum.HAIR) or 0;
	args[2]=userdata:Get(UDEnum.HAIRCOLOR) or 0;
	args[3]=userdata:Get(UDEnum.EYE) or 0;
	args[6]=userdata:Get(UDEnum.CLOTHCOLOR) or 0
	args[8]=userdata:Get(UDEnum.HEAD) or 0
	args[9]=userdata:Get(UDEnum.FACE) or 0
	args[4] = enterPreview
	args[5] = enterPreview
	if(enterPreview)then
		args[7]= self:getBodyID()
	end
	self:FakeDressingPreview(args)
	ReusableTable.DestroyAndClearArray(args)
end

function ShopDressingProxy:GetFakeRole()
	return self.fakeAssetRole
end

function ShopDressingProxy:bDyeMaterialEnough(csvID)
	if(csvID)then
		local hairColorData = Table_HairColor[csvID]
		if hairColorData and hairColorData.Money and #hairColorData.Money>0 and
		 	hairColorData.Money[1].item and hairColorData.Money[1].num then
			local materialID = hairColorData.Money[1].item
			local needCount = hairColorData.Money[1].num
			if materialID then
				local itemData = BagProxy.Instance:GetItemByStaticID(materialID)
				if(itemData and itemData.num and itemData.num>=needCount)then
					return true;
				end
			end
		end
	end
	return false;
end

function ShopDressingProxy:GetCurMoneyByID(moneyID)
	if(moneyID==GameConfig.MoneyId.Zeny)then
		return MyselfProxy.Instance:GetROB()
	else
		errorLog(string.format("ShopDressingProxy :GetCurMoneyByID failed. moneyID is: ", tostring(moneyID)))
		return 0;
	end
end

function ShopDressingProxy:bSameItem(type)
	local itemID,originalID=nil,nil
	local tableData = ShopProxy.Instance:GetShopItemDataByTypeId(self.shopType,self.shopID,self.queryData.id)
	if(ShopDressingProxy.DressingType.HAIR==type)then
		if(tableData and tableData.goodsID)then
			itemID = self:GetHairStyleIDByItemID(tableData.goodsID)
			originalID=self.originalHair
		end
	elseif(ShopDressingProxy.DressingType.HAIRCOLOR==type)then
		if(tableData and tableData.hairColorID)then
			itemID=tableData.hairColorID
			originalID=self.originalHairColor
		end
	elseif(ShopDressingProxy.DressingType.EYE==type)then
		if(tableData and tableData.goodsID)then
			itemID=tableData.goodsID
			originalID=self.originalEye
		end
	elseif(ShopDressingProxy.DressingType.ClothColor==type)then
		if(tableData and tableData.clothColorID)then
			itemID=Table_Couture[tableData.clothColorID].ClothColor
			originalID=self.originalBodyColor
		end
	end
	if(itemID and originalID)then
		return itemID==originalID
	end
	return false
end

function ShopDressingProxy:CheckCanOpen(menuid)
	if(menuid and 0~=menuid) then
		return FunctionUnLockFunc.Me():CheckCanOpen(tonumber(menuid))
	end
	return true;
end

function ShopDressingProxy:Clear()
	self.queryData=nil
	self.originalHair=nil
	self.originalHairColor=nil
	self.originalEye=nil
	self.originalBodyColor=nil
	self.originalBody = nil
	self.chooseData={}
	self:DestroyFakeModel()
end








