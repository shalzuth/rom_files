AssetManager = class('AssetManager')

AssetManager.CachePoolNum = 10

function AssetManager.Me()
	if nil == AssetManager.me then
		AssetManager.me = AssetManager.new()
	end
	return AssetManager.me
end

function AssetManager.AssetCreator(resID)
	if(ResourceManager.Instance)then
		return ResourceManager.Instance:Load(resID);
	end
	return nil
end

function AssetManager.AssetDeletor(assetInfo)
	AssetManager.AssetRealDeletor(assetInfo.resID)
end

function AssetManager.AssetRealDeletor(resID)
	if(ResourceManager.Instance)then
		-- print("AssetRealDeletor "..resID.getRealPath)
		ResourceManager.Instance:UnLoad(resID, false);
	end
end

function AssetManager:ctor()
	self.pool = LuaObjPool.new("AssetPool", 10, AssetManager.AssetDeletor)
	self:Reset()
end

function AssetManager:Reset()
	self.assetInfoCache = {}
	self.ownerMapAssetInfo = {}
	self.cachePool = {}
end

function AssetManager:RealLoadAsset(resID)
	local resInfo = self.pool:Get(resID.getRealPath)
	if nil ~= resInfo then
		-- print("RealLoadAsset "..resID.getRealPath)
		return resInfo.asset
	end
	local asset = AssetManager.AssetCreator(resID)
	if nil == asset then
		return nil
	end
	return asset
end

function AssetManager:RealUnloadAsset(resID, asset)
	if(asset~=nil and not GameObjectUtil.Instance:ObjectIsNULL(asset)) then
		local resInfo = {}
		resInfo.asset = asset
		resInfo.resID = resID
		-- print("RealUnloadAsset "..resID.getRealPath)
		self.pool:Put(resID.getRealPath, resInfo)
	end
end

function AssetManager:AddAssetInfo(resID,asset,owner)
	local assetInfo = self:GetAssetInfo(resID)
	if(assetInfo == nil) then
		assetInfo = AssetInfo.new(asset,owner,resID)
		self.assetInfoCache[resID.getRealPath] = assetInfo
	else
		assetInfo:AddOwner(owner)
	end
	return assetInfo
end

-- unique begin
function AssetManager:GetOnwerAssetInfo(owner)
	return self.ownerMapAssetInfo[owner]
end

function AssetManager:SetOnwerAssetInfo(owner, assetInfo)
	self.ownerMapAssetInfo[owner] = assetInfo
end

function AssetManager:TryClearUnusedOwnerAssetInfo()
	local goUtil = GameObjectUtil.Instance
	local removes = {}
	for k,v in pairs(self.ownerMapAssetInfo) do
		if goUtil:ObjectIsNULL(k) then
			removes[#removes + 1] = k
		end
	end
	if(removes and 0 < #removes) then
		for i=1,#removes do
			self:SetOnwerAssetInfo(removes[i], nil)
		end
	end
end

function AssetManager:TryClearOwnerOldAssetInfo(owner, resID)
	local cleared = false
	local ownerMapInfo = self:GetOnwerAssetInfo(owner)
	if nil ~= ownerMapInfo then
		if nil == resID or not ownerMapInfo:IsResID(resID) then
			self:SetOnwerAssetInfo(owner, nil)
			cleared = true
		end
	end
	return ownerMapInfo, cleared
end

-- unique end

function AssetManager:GetAssetInfo(resID)
	return self.assetInfoCache[resID.getRealPath]
end

function AssetManager:DisposeAssetInfo(resID)
	local assetInfo = self:GetAssetInfo(resID)
	if(assetInfo) then
		self.assetInfoCache[resID.getRealPath] = nil
		self:RealUnloadAsset(resID, assetInfo.asset)
	end
end

function AssetManager:LoadAsset(owner,resID)
	-- unique test begin
	local oldAssetInfo, cleared = self:TryClearOwnerOldAssetInfo(owner, resID)
	if nil ~= oldAssetInfo then
		if cleared then
			self:UnLoadAsset(owner, oldAssetInfo.resID)
		else
			return oldAssetInfo.asset
		end
	end
	-- unique test end

	local assetInfo = self:GetAssetInfo(resID)
	if(assetInfo==nil) then
		-- print("create new info.."..resID.getRealPath)
		local asset = self:RealLoadAsset(resID)
		if nil == asset then
			-- print("asset is nil!!!!")
			return nil
		end
		assetInfo = self:AddAssetInfo(resID,asset,owner)
	else
		assetInfo:AddOwner(owner)
	end

	self:SetOnwerAssetInfo(owner, assetInfo)
	-- print(resID.getRealPath,assetInfo.asset)
	return assetInfo.asset
end

function AssetManager:UnLoadAsset(owner,resID)
	-- unique test begin
	self:TryClearOwnerOldAssetInfo(owner, nil)
	-- unique test end

	local assetInfo = self:GetAssetInfo(resID)
	if(assetInfo) then
		assetInfo:RemoveOwner(owner)
		assetInfo:RemoveUnUsedOwners()
		if(assetInfo:HasNoOwners()) then
			self:DisposeAssetInfo(resID,true)
		end
	end
end

function AssetManager:TryUnLoadAllUnused()
	local removes
	for k,v in pairs(self.assetInfoCache) do
		v:RemoveUnUsedOwners()
		if(v:HasNoOwners()) then
			removes = removes or {}
			removes[#removes + 1] = k
			-- print("TryUnLoadAllUnused "..k)
			self:RealUnloadAsset(v.resID,v.asset)
		end
	end
	if(removes) then
		for i=1,#removes do
			self.assetInfoCache[removes[i]] = nil
		end
	end

	-- for k,v in pairs(self.assetInfoCache) do
	-- 	print("left.."..k)
	-- end

	-- unique test begin
	self:TryClearUnusedOwnerAssetInfo()
	-- unique test end
end

function AssetManager:TryUnLoadUnused(resID)
	local assetInfo = self:GetAssetInfo(resID)
	if(assetInfo) then
		assetInfo:RemoveUnUsedOwners()
		if(assetInfo:HasNoOwners()) then
			self:DisposeAssetInfo(resID)
			return true
		end
	end
	return false
end


AssetInfo = class("AssetInfo")

function AssetInfo:ctor(asset,owner,resID)
	self.asset = asset
	self.resID = resID
	self.owners = {}
	self:AddOwner(owner)
end

function AssetInfo:AddOwner(owner)
	if(owner) then
		local findIndex = TableUtil.ArrayIndexOf(self.owners,owner)
		if(findIndex == 0) then
			self.owners[#self.owners + 1] = owner
			return true
		end
	end
	return false
end

function AssetInfo:RemoveOwner(owner)
	local index = TableUtil.Remove(self.owners,owner)
	return index~= 0
end

function AssetInfo:RemoveUnUsedOwners()
	local goUtil = GameObjectUtil.Instance
	local o
	for i=#self.owners,1,-1 do
		o = self.owners[i]
		if(o==nil or goUtil:ObjectIsNULL(o)) then
			table.remove(self.owners,i)
		end
	end
end

function AssetInfo:HasNoOwners()
	return #self.owners == 0
end

function AssetInfo:IsResID(testResID)
	local eq = false
	if(testResID and self.resID)then
		eq = testResID.IDStr == self.resID.IDStr
	end
	return eq
end