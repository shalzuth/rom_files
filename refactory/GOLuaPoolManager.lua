GOLuaPoolManager = class("GOLuaPoolManager")

local IsNull = Slua.IsNull
local SetParent = SetParent
-- local vector3One = LuaVector3.one
-- local quaternionIdentity = LuaQuaternion.identity
local FAST_MODE = GAME_FAST_MODE

function GOLuaPoolManager:ctor()
	self.gameObject = GameObject("LuaGameObjectPool")
	self.gameObject.transform.parent = LuaLuancher.Instance.monoGameObject.transform
	GameObject.DontDestroyOnLoad(self.gameObject)
	--创建分类池子
	self.uiPool = GOLuaPool.new("UI",self.gameObject,0,20)
	self.sceneuiPool = GOLuaPool.new("SceneUI",self.gameObject,0,20)
	self.sceneuiMovePool = MovePosPool.new(15)
	self.chatPool = GOLuaPool.new("Chat",self.gameObject,0,85)
	self.hurtNumPool = GOLuaPool.new("HurtNum",self.gameObject,0,100)
	self.effectPool = GOLuaPool.new("effectPool",self.gameObject,0,100)
	self.astrolabePool = GOLuaPool.new("Astrolabe", self.gameObject, 0, 200);

	self.sceneDropItemPool = GOLuaPool.new("SceneDropItems",self.gameObject,0,20)

	self.role_CompletePool = GOLuaPool.new("role_CompletePool",self.gameObject,0,500,true)
	self.role_part_bodyPool = GOLuaPool.new("role_part_bodyPool",self.gameObject,50,200,true)
	self.role_part_hairPool = GOLuaPool.new("role_part_hairPool",self.gameObject,50,200,true)
	self.role_part_weaponPool = GOLuaPool.new("role_part_weaponPool",self.gameObject,50,100,true)
	self.role_part_headPool = GOLuaPool.new("role_part_headPool",self.gameObject,50,50,true)
	self.role_part_facePool = GOLuaPool.new("role_part_facePool",self.gameObject,50,50,true)
	self.role_part_wingPool = GOLuaPool.new("role_part_wingPool",self.gameObject,50,10,true)
	self.role_part_tailPool = GOLuaPool.new("role_part_tailPool",self.gameObject,50,10,true)
	self.role_part_eyePool = GOLuaPool.new("role_part_eyePool",self.gameObject,50,200,true)
	self.role_part_mountPool = GOLuaPool.new("role_part_mountPool",self.gameObject,50,10,true)
	self.role_part_mouthPool = GOLuaPool.new("role_part_mouthPool",self.gameObject,50,10,true)
end

-- UI begin
function GOLuaPoolManager:GetFromUIPool(key,parent)
	return self.uiPool:Remove(key,parent)
end

function GOLuaPoolManager:AddToUIPool(key,go)
	local isAdd = self.uiPool:Add(key,go);
	if( not isAdd and not IsNull(go))then
		GameObject.Destroy(go);
	end
	return isAdd;
end

function GOLuaPoolManager:ClearUIPool()
	self.uiPool:Clear()
end
-- UI end


-- SceneUI begin
function GOLuaPoolManager:GetFromSceneUIPool(key,parent)
	return self.sceneuiPool:Remove(key,parent)
end

function GOLuaPoolManager:AddToSceneUIPool(key,go)
	local isAdd = self.sceneuiPool:Add(key,go);
	if( not isAdd and not IsNull(go))then
		GameObject.Destroy(go);
	end
	return isAdd;
end

function GOLuaPoolManager:ClearSceneUIPool()
	self.sceneuiPool:Clear()
end
-- SceneUI end

-- Astrolabe begin
function GOLuaPoolManager:GetFromAstrolabePool(key, parent)
	return self.astrolabePool:Remove(key,parent)
end

function GOLuaPoolManager:AddToAstrolabePool(key,go)
	local isAdd = self.astrolabePool:Add(key,go);
	if( not isAdd and not IsNull(go))then
		GameObject.Destroy(go);
	end
	return isAdd;
end

function GOLuaPoolManager:ClearAstrolabePool()
	self.astrolabePool:Clear()
end
-- Astrolabe end

-- SceneUIMovePool begin
function GOLuaPoolManager:GetFromSceneUIMovePool(key,parent)
	return self.sceneuiMovePool:Get(key,parent)
end

function GOLuaPoolManager:AddToSceneUIMovePool(key,go)
	local putIn,res = self.sceneuiMovePool:Put(key,go);
	if( not putIn and res~=nil)then
		-- Debug.Log("GOLuaPoolManager:AddToSceneUIMovePool Full")
		for i=1,#res do
			self:AddToSceneUIPool(key,res[i])
		end
		self.sceneuiMovePool:RemovePoolByKey(key)
		return true
	end
	return putIn;
end

function GOLuaPoolManager:ClearSceneUIMovePool()
	self.sceneuiMovePool:Clear()
end
-- SceneUIMovePool end


-- Chat begin
function GOLuaPoolManager:GetFromChatPool(go,parent)
	if SetParent(go,parent) then
		return go
	end
	return nil
end

function GOLuaPoolManager:AddToChatPool(go)
	if(IsNull(go)==false) then
		return self.chatPool:AddChild(go)
	end
	return false
end
-- Chat end

-- hurtnum begin
function GOLuaPoolManager:GetFromHurtNumPool(go,parent)
	if(SetParent(go,parent)) then
		return go
	end
	return nil
end

function GOLuaPoolManager:AddToHurtNumPool(go)
	if(IsNull(go)==false) then
		return self.hurtNumPool:AddChild(go)
	end
	return false
end
-- hurtnum end

-- Effect begin
function GOLuaPoolManager:GetFromEffectPool(key,parent)
	local effect = self.effectPool:Remove(key,parent)
	-- if(FAST_MODE or not IsNull(effect)) then
	-- 	effect.gameObject:SetActive(true)
	-- end
	return effect
end

function GOLuaPoolManager:AddToEffectPool(key,go)
	local success = self.effectPool:Add(key,go,true)
	-- if(FAST_MODE or not IsNull(go)) then
	-- 	go.gameObject:SetActive(false)
	-- end
	return success
end

function GOLuaPoolManager:ClearEffectPool()
	self.effectPool:Clear()
end
-- Effcet end

-- SceneDropItem begin
function GOLuaPoolManager:GetFromSceneDropPool(key,parent)
	local drop = self.sceneDropItemPool:Remove(key,parent)
	-- if(FAST_MODE or not IsNull(effect)) then
	-- 	effect.gameObject:SetActive(true)
	-- end
	return drop
end

function GOLuaPoolManager:AddToSceneDropPool(key,go)
	local success = self.sceneDropItemPool:Add(key,go)
	-- if(FAST_MODE or not IsNull(go)) then
	-- 	go.gameObject:SetActive(false)
	-- end
	return success
end

function GOLuaPoolManager:ClearSceneDropPool()
	self.sceneDropItemPool:Clear()
end
-- SceneDropItem end

-- role begin
function GOLuaPoolManager:GetFromRoleCompletePool(parent)
	return self.role_CompletePool:Remove(1,parent)
end
function GOLuaPoolManager:AddToRoleCompletePool(go)
	return self.role_CompletePool:Add(1,go,true)
end
function GOLuaPoolManager:ClearRoleCompletePool()
	self.role_CompletePool:Clear()
end

	-- role parts begin
function GOLuaPoolManager:GetFromRolePartBodyPool(key,parent)
	local part = self.role_part_bodyPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartBodyPool(key,go)
	go.componentsDisable = true
	return self.role_part_bodyPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartBodyPool()
	self.role_part_bodyPool:Clear()
end
function GOLuaPoolManager:RolePartBodyKeyFull()
	return self.role_part_bodyPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartBodyElementFull(key)
	return self.role_part_bodyPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartBodyElementCount(key)
	return self.role_part_bodyPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartHairPool(key,parent)
	local part = self.role_part_hairPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartHairPool(key,go)
	go.componentsDisable = true
	return self.role_part_hairPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartHairPool()
	self.role_part_hairPool:Clear()
end
function GOLuaPoolManager:RolePartHairKeyFull()
	return self.role_part_hairPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartHairElementFull(key)
	return self.role_part_hairPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartHairElementCount(key)
	return self.role_part_hairPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartWeaponPool(key,parent)
	local part = self.role_part_weaponPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartWeaponPool(key,go)
	go.componentsDisable = true
	return self.role_part_weaponPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartWeaponPool()
	self.role_part_weaponPool:Clear()
end
function GOLuaPoolManager:RolePartWeaponKeyFull()
	return self.role_part_weaponPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartWeaponElementFull(key)
	return self.role_part_weaponPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartWeaponElementCount(key)
	return self.role_part_weaponPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartHeadPool(key,parent)
	local part = self.role_part_headPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartHeadPool(key,go)
	go.componentsDisable = true
	return self.role_part_headPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartHeadPool()
	self.role_part_headPool:Clear()
end
function GOLuaPoolManager:RolePartHeadKeyFull()
	return self.role_part_headPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartHeadElementFull(key)
	return self.role_part_headPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartHeadElementCount(key)
	return self.role_part_headPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartFacePool(key,parent)
	local part = self.role_part_facePool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartFacePool(key,go)
	go.componentsDisable = true
	return self.role_part_facePool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartFacePool()
	self.role_part_facePool:Clear()
end
function GOLuaPoolManager:RolePartFaceKeyFull()
	return self.role_part_facePool:KeyIsFull()
end
function GOLuaPoolManager:RolePartFaceElementFull(key)
	return self.role_part_facePool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartFaceElementCount(key)
	return self.role_part_facePool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartWingPool(key,parent)
	local part = self.role_part_wingPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartWingPool(key,go)
	go.componentsDisable = true
	return self.role_part_wingPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartWingPool()
	self.role_part_wingPool:Clear()
end
function GOLuaPoolManager:RolePartWingKeyFull()
	return self.role_part_wingPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartWingElementFull(key)
	return self.role_part_wingPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartWingElementCount(key)
	return self.role_part_wingPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartTailPool(key,parent)
	local part = self.role_part_tailPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartTailPool(key,go)
	go.componentsDisable = true
	return self.role_part_tailPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartTailPool()
	self.role_part_tailPool:Clear()
end
function GOLuaPoolManager:RolePartTailKeyFull()
	return self.role_part_tailPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartTailElementFull(key)
	return self.role_part_tailPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartTailElementCount(key)
	return self.role_part_tailPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartEyePool(key,parent)
	local part = self.role_part_eyePool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartEyePool(key,go)
	go.componentsDisable = true
	return self.role_part_eyePool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartEyePool()
	self.role_part_eyePool:Clear()
end
function GOLuaPoolManager:RolePartEyeKeyFull()
	return self.role_part_eyePool:KeyIsFull()
end
function GOLuaPoolManager:RolePartEyeElementFull(key)
	return self.role_part_eyePool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartEyeElementCount(key)
	return self.role_part_eyePool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartMountPool(key,parent)
	local part = self.role_part_mountPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartMountPool(key,go)
	go.componentsDisable = true
	return self.role_part_mountPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartMountPool()
	self.role_part_mountPool:Clear()
end
function GOLuaPoolManager:RolePartMountKeyFull()
	return self.role_part_mountPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartMountElementFull(key)
	return self.role_part_mountPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartMountElementCount(key)
	return self.role_part_mountPool:GetElementCountByKey(key)
end

function GOLuaPoolManager:GetFromRolePartMouthPool(key,parent)
	local part = self.role_part_mouthPool:Remove(key,parent)
	if(part) then
		part.componentsDisable = false
	end
	return part
end
function GOLuaPoolManager:AddToRolePartMouthPool(key,go)
	go.componentsDisable = true
	return self.role_part_mouthPool:Add(key,go,true)
end
function GOLuaPoolManager:ClearRolePartMouthPool()
	self.role_part_mouthPool:Clear()
end
function GOLuaPoolManager:RolePartMouthKeyFull()
	return self.role_part_mouthPool:KeyIsFull()
end
function GOLuaPoolManager:RolePartMouthElementFull(key)
	return self.role_part_mouthPool:ElementsFull(key)
end
function GOLuaPoolManager:RolePartMouthElementCount(key)
	return self.role_part_mouthPool:GetElementCountByKey(key)
end
	-- role parts end
-- role end

function GOLuaPoolManager:ClearAllPools()
	self:ClearUIPool()
	self:ClearEffectPool()
	self:ClearSceneDropPool();
	-- self:ClearRoleCompletePool()
	self:ClearRolePartBodyPool()
	self:ClearRolePartHairPool()
	self:ClearRolePartWeaponPool()
	self:ClearRolePartHeadPool()
	self:ClearRolePartFacePool()
	self:ClearRolePartWingPool()
	self:ClearRolePartTailPool()
	self:ClearRolePartMountPool()
	self:ClearSceneUIPool();
	self:ClearAstrolabePool();
	self:ClearSceneUIMovePool();
end

function GOLuaPoolManager:Dispose()
	GameObject.Destroy(self.gameObject)
end

local tmpV = LuaVector3(10000,10000,10000)
GOLuaPool = class("GOLuaPool",LuaLRUKeyTable)

function GOLuaPool:ctor(name,parent,keyMaxNum,maxNum,poolActive)
	if(poolActive==nil) then 
		poolActive = false
	end
	GOLuaPool.super.ctor(self,keyMaxNum,maxNum)
	self.poolGO = GameObject(name)
	self.poolTrans = self.poolGO.transform
	self.poolGO:SetActive(poolActive)
	self.poolActive = poolActive
	if(poolActive==true) then
		self.poolGO.transform.localPosition = tmpV
	end
	SetParent(self.poolGO,parent)
	self.name = name
end

local superAdd = GOLuaPool.super.Add
local DestroyGameObject = LuaGameObject.DestroyGameObject
local DestroyAndClearArray = ReusableTable.DestroyAndClearArray
function GOLuaPool:Add(name,go,checkEnabled)
	if(IsNull(go)==false) then
		if checkEnabled and not go.enabled then
			LogUtility.DebugInfoFormat(
				go.gameObject, 
				"<color=red>GOLuaPool:Add is not enabled: </color>{0},{1}", 
				name,
				go.name)
			LuaGameObject.RestoreBehaviours(go.gameObject)
		end
		local added,removes = superAdd(self,name,go)
		if(added) then
			self:AddChild(go)
		end
		if(removes) then
			for i=1,#removes do
				DestroyGameObject(removes[i])
			end
			DestroyAndClearArray(removes)
		end
		return added
	else
		LogUtility.InfoFormat(
			"<color=red>GOLuaPool:Add is destroyed: </color>{0}", 
			name)
	end
	return false
end

function GOLuaPool:AddChild(child)
	if(self.poolActive) then
		child.transform:SetParent(self.poolTrans,false)
	else
		SetParent(child,self.poolGO)
	end
end

local superTryGet = GOLuaPool.super.TryGetValue
function GOLuaPool:Remove(name,newParent)
	local element = superTryGet(self,name)
	if(element~=nil) then
		if(SetParent(element,newParent)) then
			return element
		end
	end
	return nil
end

function GOLuaPool:RemoveChild(child,newParent)
	if(child~=nil and IsNull(child)==false) then
		child.transform.parent = IsNull(newParent)==false and newParent.transform or nil
		return child
	end
	return nil
end

local superClear = GOLuaPool.super.Clear
function GOLuaPool:Clear()
	local go
	local elements = self[4]
	for k,v in pairs(elements) do
		for i=1,#v do
			go = v[i]
			if(go ~= nil and IsNull(go)==false) then
				GameObject.Destroy(go.gameObject)
			end
		end
		elements[k] = nil
		ReusableTable.DestroyAndClearArray(v)
	end
	superClear(self)
end

function GOLuaPool:RemoveChilds()
	local trans = self.poolGO.transform
	local childCount = trans.childCount
	for i=childCount-1,0,-1 do
		GameObject.Destroy (trans:GetChild (i).gameObject);
	end
end

MovePosPool = class("MovePosPool")
local pos = LuaVector3(999999,999999,999999)
function MovePosPool:ctor(count)
	self.count = count
	self.pool = {}
end

function MovePosPool:Put(key,go)
	if(IsNull(go)==false) then
		local pool = self.pool[key]
		if(pool==nil) then
			pool = {}
			self.pool[key] = pool
		end
		pool[#pool+1] = go
		if(self.count>0 and #pool>=self.count) then
			return false,pool
		end
		go.transform.localPosition = pos
		-- Debug.Log("MovePosPool:Put "..go.name)
		-- go.name = "cena"
		-- Debug.Log(go.transform.localPosition)
		-- Debug.Log(go.transform.position)
		return true,nil
	end
	return false,nil
end

function MovePosPool:Get(key,parent)
	local pool = self.pool[key]
	if(pool and #pool >0) then
		local go
		for i=#pool,1,-1 do
			go = pool[i]
			pool[i] = nil
			if(IsNull(go)==false) then
				if(SetParent(go,parent)) then
					return go
				end
			end
		end
	end
	return nil
end

function MovePosPool:RemovePoolByKey(key)
	local pool = self.pool[key]
	if(pool) then
		ReusableTable.DestroyAndClearArray(pool)
		self.pool[key] = nil
	end
end

function MovePosPool:Clear()
	local go,p
	for k,pool in pairs(self.pool) do
		if(pool)then
			for i=#pool,1,-1 do
				go = pool[i]
				if(IsNull(go)==false) then
					GameObject.Destroy (go);
				end
			end
			ReusableTable.DestroyAndClearArray(pool)
			self.pool[k] = nil
		end
	end
end