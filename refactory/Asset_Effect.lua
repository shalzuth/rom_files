Asset_Effect = class("Asset_Effect", ReusableObject)

if not Asset_Effect.Asset_Effect_Inited then
	Asset_Effect.Asset_Effect_Inited = true
	Asset_Effect.PoolSize = 100
end

local tempArgs = {
	nil, -- path
	LuaVector3.zero, -- local Position
	LuaVector3.zero, -- local Rotation
	LuaVector3.one, -- local Scale
	nil, -- parent
	nil, -- callback
	nil, -- callbackArg
	false, -- isautoDestroy
}

local DeActiveOpt = {
	Origin = 1,
	Filter = 2,
	CreatureHide = 4,
}
Asset_Effect.DeActiveOpt = {
	Origin = DeActiveOpt.Origin,
	Filter = DeActiveOpt.Filter,
	CreatureHide = DeActiveOpt.CreatureHide,
}

function Asset_Effect._Create( args )
	local effect = ReusableObject.Create( Asset_Effect, true, args )
	args[5] = nil
	args[6] = nil
	args[7] = nil
	return effect
end

function Asset_Effect._CreateAutoDestroy( args )
	local effect = ReusableObject.Create( Asset_Effect, true, args )
	args[5] = nil
	args[6] = nil
	args[7] = nil
	Game.AssetManager_Effect:AddAutoDestroyEffect(effect)
	return effect
end

function Asset_Effect.PlayOneShotAtXYZ( path, x, y, z, callback, callbackArg )
	tempArgs[1] = path
	tempArgs[2]:Set(x, y, z)
	tempArgs[3]:Set(0, 0, 0)
	tempArgs[4]:Set(1, 1, 1)
	tempArgs[5] = nil
	tempArgs[6] = callback
	tempArgs[7] = callbackArg
	tempArgs[8] = true
	return Asset_Effect._CreateAutoDestroy(tempArgs)
end
function Asset_Effect.PlayOneShotAt( path, p, callback, callbackArg )
	return Asset_Effect.PlayOneShotAtXYZ(path, p[1], p[2], p[3], callback, callbackArg)
end

function Asset_Effect.PlayOneShotOn( path, parent, callback, callbackArg )
	tempArgs[1] = path
	tempArgs[2]:Set(0, 0, 0)
	tempArgs[3]:Set(0, 0, 0)
	tempArgs[4]:Set(1, 1, 1)
	tempArgs[5] = parent
	tempArgs[6] = callback
	tempArgs[7] = callbackArg
	tempArgs[8] = true
	return Asset_Effect._CreateAutoDestroy(tempArgs)
end

function Asset_Effect.PlayAtXYZ( path, x,y,z, callback, callbackArg )
	tempArgs[1] = path
	tempArgs[2]:Set(x, y, z)
	tempArgs[3]:Set(0, 0, 0)
	tempArgs[4]:Set(1, 1, 1)
	tempArgs[5] = nil
	tempArgs[6] = callback
	tempArgs[7] = callbackArg
	tempArgs[8] = false
	return Asset_Effect._Create(tempArgs)
end
function Asset_Effect.PlayAt( path, p, callback, callbackArg )
	return Asset_Effect.PlayAtXYZ( path, p[1], p[2], p[3], callback, callbackArg )
end

function Asset_Effect.PlayOn( path, parent, callback, callbackArg )
	tempArgs[1] = path
	tempArgs[2]:Set(0, 0, 0)
	tempArgs[3]:Set(0, 0, 0)
	tempArgs[4]:Set(1, 1, 1)
	tempArgs[5] = parent
	tempArgs[6] = callback
	tempArgs[7] = callbackArg
	tempArgs[8] = false
	return Asset_Effect._Create(tempArgs)
end

local Asset_Effect_ID = 1
function Asset_Effect:ctor()
	self.id = Asset_Effect_ID
	Asset_Effect_ID = Asset_Effect_ID + 1
	self.args = {}
	Asset_Effect.super.ctor(self)
end

-- for Asset_Role
function Asset_Effect:ObserveRole(role, epID)
	self.args[8] = epID
	if nil ~= self.args[6] then
		self.args[6].epID = epID
	end
	self:CreateWeakData()
	self:PushBackWeakData(role)
	if 0 == epID then
		-- observe invisible
	end
end

function Asset_Effect:GetEffectHandle()
	return self.args[6]
end

function Asset_Effect:IsActive()
	return self.args[14]
end

function Asset_Effect:SetActive(active,opt)
	if opt == nil then
		opt = DeActiveOpt.Origin
	end

	if(active) then
		if(self.deActiveFlag & opt > 0 ) then
			self.deActiveFlag = self.deActiveFlag - opt
		end
		if(self.deActiveFlag~=0) then
			return
		end
	else
		if(self.deActiveFlag & opt == 0 ) then
			self.deActiveFlag = self.deActiveFlag + opt
		end
	end

	if self.args[14] == active then
		return
	end
	self.args[14] = active
	if nil ~= self.args[6] 
		and not LuaGameObject.ObjectIsNull(self.args[6]) then
		self.args[6].gameObject:SetActive(active)
	end
end

function Asset_Effect:SetPlaybackSpeed(speed)
	self.args[11] = speed
	if nil ~= self.args[6] then
		self.args[6]:SetPlaybackSpeed(speed)
	end
end

function Asset_Effect:GetPath()
	return self.args[1]
end

function Asset_Effect:GetLocalPosition()
	return self.args[2]
end

function Asset_Effect:GetLocalEulerAngles()
	return self.args[3]
end

function Asset_Effect:GetLocalScale()
	return self.args[4]
end

function Asset_Effect:GetComponent(ComponentClass)
	return self.args[6] and self.args[6]:GetComponent(ComponentClass) or nil
end

function Asset_Effect:ResetParent(parent)
	self.args[5] = parent
	if nil ~= self.args[6] then
		self.args[6].transform:ResetParent(parent, false)
	end
end

function Asset_Effect:ResetLocalPositionXYZ(x, y, z)
	self.args[2]:Set(x, y, z)
	if nil ~= self.args[6] then
		self.args[6].transform.localPosition = self.args[2]
	end
end
function Asset_Effect:ResetLocalPosition(p)
	self:ResetLocalPositionXYZ(p[1], p[2], p[3])
end

function Asset_Effect:ResetLocalEulerAnglesXYZ(x, y, z)
	self.args[3]:Set(x, y, z)
	if nil ~= self.args[6] then
		self.args[6].transform.localEulerAngles = self.args[3]
	end
end
function Asset_Effect:ResetLocalEulerAngles(p)
	self:ResetLocalEulerAnglesXYZ(p[1], p[2], p[3])
end

function Asset_Effect:ResetLocalScaleXYZ(x, y, z)
	self.args[4]:Set(x, y, z)
	if nil ~= self.args[6] then
		self.args[6].transform.localScale = self.args[4]
	end
end
function Asset_Effect:ResetLocalScale(p)
	self:ResetLocalScaleXYZ(p[1], p[2], p[3])
end
function Asset_Effect:ResetAction(action, normalizedTime)
	local oldAction = self.args[15]
	if oldAction == action then
		return
	end
	self.args[15] = action
	self.args[16] = normalizedTime
	self:_ResetAction()
end

function Asset_Effect:UpdateLifeTime(time, deltaTime)
	self.args[12] = self.args[12] + deltaTime
	return self.args[12]
end

function Asset_Effect:Stop()
	self.args[13] = true
	self:_CancelLoading()
	self:_Destroy()
end

function Asset_Effect:IsRunning()
	return not self.args[13] 
		and (nil ~= self.args[7] 
			or (nil ~= self.args[6] 
				and not LuaGameObject.ObjectIsNull(self.args[6]) 
				and self.args[6].running))
end

function Asset_Effect:_ResetAction()
	if nil ~= self.args[15] and nil ~= self.args[6] then
		local action = self.args[15]
		local normalizedTime = self.args[16]
		self.args[16] = nil
		local animators = self.args[6].animators
		for i=1, #animators do
			animators[i]:Play(action, -1, normalizedTime)
		end
	end
end

function Asset_Effect:_ResetEffectHandle()
	local args = self.args
	local effectHandle = args[6]
	if nil == effectHandle then
		return
	end
	local objTransform = effectHandle.transform
	objTransform.parent = args[5]
	objTransform.localPosition = args[2]
	objTransform.localEulerAngles = args[3]
	objTransform.localScale = args[4]
	-- TODO layer

	effectHandle.epID = args[8]

	if nil ~= args[11] then
		effectHandle:SetPlaybackSpeed(args[11])
	else
		effectHandle:SetPlaybackSpeed(1)
	end
end

function Asset_Effect:_Destroy()
	if nil ~= self.args[6] then
		if not LuaGameObject.ObjectIsNull(self.args[6]) and not self:IsActive()then
			self.args[6].gameObject:SetActive(true)
		end
		self.assetManager:DestroyEffect(self.args[1], self.args[6])
		self.args[6] = nil
	end
end

function Asset_Effect:_CancelLoading()
	if nil ~= self.args[7] then
		self.assetManager:CancelCreateEffect(self.args[1], self.args[7])
		self.args[7] = nil
	end
end

function Asset_Effect:OnEffectCreated( tag, obj, path )
	if self.args[7] ~= tag then
		self.assetManager:DestroyEffect(path, obj)
		return
	end
	self.args[7] = nil
	if nil == obj and nil ~= path then
		LogUtility.WarningFormat("Load Effect Failed: path={0}", path)
		return
	end
	self.args[6] = obj
	if nil ~= obj then
		obj.gameObject:SetActive(false)
	end
	self:_ResetEffectHandle()
	if nil ~= obj and self.args[14] then
		obj.gameObject:SetActive(true)
		self:_ResetAction()
	end

	if nil ~= self.args[9] then
		self.args[9](obj, self.args[10])
		self:RemoveCreatedCallBack()
	end
end

function Asset_Effect:RemoveCreatedCallBack()
	self.args[9] = nil -- callback
	self.args[10] = nil -- callbackArg
end

-- override begin
function Asset_Effect:DoConstruct(asArray, args)
	self.assetManager = Game.AssetManager_Effect
	self.effectManager = Game.EffectManager

	-- 设置active/deactive的标志
	self.deActiveFlag = 0

	self.args[1] = args[1] -- path
	self.args[2] = args[2]:Clone() -- local Position
	self.args[3] = args[3]:Clone() -- local EulerAngles
	self.args[4] = args[4]:Clone() -- local Scale
	self.args[5] = args[5] -- parent
	self.args[6] = nil -- effectHandle
	self.args[8] = 0 -- epID
	self.args[9] = args[6] -- callback
	self.args[10] = args[7] -- callbackArg
	self.args[11] = nil -- playback speed
	self.args[12] = 0 -- life time
	self.args[13] = false -- stoped
	self.args[14] = true -- active
	self.args[15] = nil -- action

	self.args[7] = nil
	if(not args[8] or not self.effectManager:IsFiltered()) then
		if(self.effectManager:IsFiltered()) then
			self.args[14] = false
		end
		self.effectManager:RegisterEffect(self,args[8])
		local loadTag = self.assetManager:CreateEffect(
			args[1], 
			args[5],
			self.OnEffectCreated, 
			self)
		self.args[7] = loadTag
	end
end

function Asset_Effect:DoDeconstruct(asArray)
	self.effectManager:UnRegisterEffect(self)
	self:_CancelLoading()
	self:_Destroy()
	self.args[2]:Destroy()
	self.args[3]:Destroy()
	self.args[4]:Destroy()

	self.args[2] = nil
	self.args[3] = nil
	self.args[4] = nil

	self.args[5] = nil
	self.args[15] = nil
	self:RemoveCreatedCallBack()
end

function Asset_Effect:OnObserverDestroyed(k, obj)
	-- asset role destoryed
	self:Destroy()
end

function Asset_Effect:ObserverEvent(obj, args)
	-- asset role invisible changed
	self:SetActive(not args)
end
-- override end