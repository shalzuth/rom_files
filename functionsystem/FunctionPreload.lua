FunctionPreload = class("FunctionPreload")

function FunctionPreload.Me()
	if nil == FunctionPreload.me then
		FunctionPreload.me = FunctionPreload.new()
	end
	return FunctionPreload.me
end

function FunctionPreload:ctor()
	self:Reset()
	self.npcPreloads = ReusableTable.CreateTable()
	-- pool key limit
	self.partKeyLimit = {}
	local partIndex = Asset_Role.PartIndex
	self.partKeyLimit[partIndex.Body] = Game.GOLuaPoolManager.role_part_bodyPool:GetKeyLimit()
	self.partKeyLimit[partIndex.Hair] = Game.GOLuaPoolManager.role_part_hairPool:GetKeyLimit()
	self.partKeyLimit[partIndex.LeftWeapon] = Game.GOLuaPoolManager.role_part_weaponPool:GetKeyLimit()
	self.partKeyLimit[partIndex.RightWeapon] = Game.GOLuaPoolManager.role_part_weaponPool:GetKeyLimit()
	self.partKeyLimit[partIndex.Head] = Game.GOLuaPoolManager.role_part_headPool:GetKeyLimit()
	self.partKeyLimit[partIndex.Wing] = Game.GOLuaPoolManager.role_part_wingPool:GetKeyLimit()
	self.partKeyLimit[partIndex.Face] = Game.GOLuaPoolManager.role_part_facePool:GetKeyLimit()
	self.partKeyLimit[partIndex.Tail] = Game.GOLuaPoolManager.role_part_tailPool:GetKeyLimit()
	self.partKeyLimit[partIndex.Eye] = Game.GOLuaPoolManager.role_part_eyePool:GetKeyLimit()
	self.partKeyLimit[partIndex.Mount] = Game.GOLuaPoolManager.role_part_mountPool:GetKeyLimit()
	self.partKeyLimit[partIndex.Mouth] = Game.GOLuaPoolManager.role_part_mouthPool:GetKeyLimit()

	self.preloadKeyCountRecord = {}
	for k,v in pairs(partIndex) do
		self.preloadKeyCountRecord[v] = 0
	end
end

function FunctionPreload:Reset()
	if(self.launched) then
		if(self.professPreloader) then
			GameObject.Destroy(self.professPreloader)
		end
	end
end

function FunctionPreload:ResetCountRecord()
	for k,v in pairs(self.preloadKeyCountRecord) do
		self.preloadKeyCountRecord[k] = 0
	end
end

function FunctionPreload:_PreloadMakeRole(info,element,manager)
	local id = info[element]
	if(id) then
		self.makeRoles[#self.makeRoles+1] = id
		self:_PreloadNpc(id,manager,1)
	end
end

function FunctionPreload:PreloadMakeRole()
	local manager = Game.AssetManager_Role
	manager:SetForceLoadAll(true)
	self.makeRoles = {}
	local roleInfo
	for i=1,#CharacterSelectList do
		roleInfo = CharacterSelectList[i]
		-- 1.male
		self:_PreloadMakeRole(roleInfo,"maleID",manager)
		-- 2.female
		self:_PreloadMakeRole(roleInfo,"femaleID",manager)
		-- 3.pet
		self:_PreloadMakeRole(roleInfo,"petID",manager)
	end
end

function FunctionPreload:ClearMakeRole()
	local manager = Game.AssetManager_Role
	manager:SetForceLoadAll(false)
	if(self.makeRoles) then
		for i=1,#self.makeRoles do
			self:_ClearPreloadNpc(self.makeRoles[i],manager)
		end
	end
end

function FunctionPreload:PreloadJobs()
	if(not self.preloadJobs) then
		self.preloadJobs = true
		local professBodyIDs = {1,2,3,4,5,6,11,12,13,14,19,20,21,22,27,28,29,30,35,36,37,38}
		local manager = Game.AssetManager_Role
		for i=1,#professBodyIDs do
			manager:PreloadPart(1,professBodyIDs[i],10)
		end
	end
end

function FunctionPreload:SceneNpcs(pos,range)
	local npcList = Game.MapManager:GetNPCPointArray()
	local manager = Game.AssetManager_Role
	local npcInfo,npcID,distance,needPreLoad
	local newPreloads = ReusableTable.CreateTable()
	local bothHave = ReusableTable.CreateTable()
	local distanceFunc = VectorUtility.DistanceXZ
	if(npcList) then
		for i=1,#npcList do
			npcInfo = npcList[i]
			npcID = npcInfo.ID
			needPreLoad = false
			if(newPreloads[npcID]==nil and bothHave[npcID] == nil) then
				if(pos) then
					distance = distanceFunc(pos, npcInfo.position)
					if(distance<=range) then
						needPreLoad = true
					end
				else
					needPreLoad = true
				end
				if(needPreLoad) then
					if(self.npcPreloads[npcID]) then
						--1 是否原来就有
						bothHave[npcID] = npcID
						self.npcPreloads[npcID] = nil
					else
						--2 没得话标记预加载
						newPreloads[npcID] = npcID
					end
				end
			end
		end
	end
	self:ResetCountRecord()
	--预加载
	for k,v in pairs(newPreloads) do
		self:_PreloadNpc(v,manager)
	end

	for k,v in pairs(bothHave) do
		newPreloads[k] = v
	end
	--设置
	self:_SetCurrentNpcPreload(newPreloads)

	ReusableTable.DestroyAndClearTable(bothHave)
end

local function PreLoadOrClear(data,manager,func,args,keyCountTable,keyLimit)
	local indexMap = Asset_Role.PartIndex
	local count
	for k,v in pairs(indexMap) do
		if(data[k]) then
			if(keyCountTable) then
				count = keyCountTable[v]
				count = count + 1
				if(v == indexMap.LeftWeapon or v == indexMap.RightWeapon) then
					keyCountTable[indexMap.LeftWeapon] = count
					keyCountTable[indexMap.RightWeapon] = count
				else
					keyCountTable[v] = count
				end
				if(count<=keyLimit[v]) then
					-- LogUtility.InfoFormat("加载{0}  部件 {1}",data.NameZh,k)
					func(manager,v,data[k],args)
				else
					-- LogUtility.InfoFormat("{0}超过池子最大限制啦{1} name:{2}",k,keyLimit[v],data.NameZh)
				end
			else
				func(manager,v,data[k],args)
			end
		end
	end
end
function FunctionPreload:_ManagerNpcPartsHandle(npcID,manager,func,args,checkKey)
	local npcData = Table_Npc[npcID]
	local indexMap = Asset_Role.PartIndex
	if(npcData) then
		if(checkKey) then
			PreLoadOrClear(npcData,manager,func,args,self.preloadKeyCountRecord,self.partKeyLimit)
		else
			PreLoadOrClear(npcData,manager,func,args)
		end
	else
		npcData = Table_Monster[npcID]
		if(npcData) then
			if(checkKey) then
				PreLoadOrClear(npcData,manager,func,args,self.preloadKeyCountRecord,self.partKeyLimit)
			else
				PreLoadOrClear(npcData,manager,func,args)
			end
		end
	end
end

function FunctionPreload:_ClearPreloadNpc(npcID,manager)
	-- LogUtility.InfoFormat("卸载NPC {0}",npcID )
	-- self:_ManagerNpcPartsHandle(npcID,manager,manager.ClearPreloadPart)
end

function FunctionPreload:_PreloadNpc(npcID,manager,count)
	count = count or 10
	-- LogUtility.InfoFormat("预加载NPC {0}",npcID )
	self:_ManagerNpcPartsHandle(npcID,manager,manager.PreloadPart,count,true)
end

function FunctionPreload:_SetCurrentNpcPreload(maps)
	if(self.npcPreloads and self.npcPreloads ~= maps) then
		ReusableTable.DestroyAndClearTable(self.npcPreloads)
	end
	self.npcPreloads = maps
end