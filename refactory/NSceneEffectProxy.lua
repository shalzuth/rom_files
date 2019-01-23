autoImport("SceneObjectProxy")
NSceneEffectProxy = class('NSceneEffectProxy', SceneObjectProxy)

NSceneEffectProxy.Instance = nil;

NSceneEffectProxy.NAME = "NSceneEffectProxy"

-- autoImport("Table_RoleData")

function NSceneEffectProxy:ctor(proxyName, data)
	self.userMap = {}
	self.sceneEffectMap = {}
	if(NSceneEffectProxy.Instance == nil) then
		NSceneEffectProxy.Instance = self
	end
	self.proxyName = proxyName or NSceneEffectProxy.NAME
	self.MapEffectLow = SkillInfo.MapEffectLow
end

function NSceneEffectProxy:GetEffectPath(effect)
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		local low = self.MapEffectLow[effect]
		if(low) then
			return low
		end
	end
	return effect
end

function NSceneEffectProxy:Add(data)
	if 0 == data.charid then
		return
	end

	data.effect = self:GetEffectPath(data.effect)
	local effect = NSceneEffect.CreateAsTable(data)
	local guid = effect.guid
	
	local effects = self:Find(guid)
	if(effects==nil) then
		effects = ReusableTable.CreateArray()
		self.userMap[guid] = effects
	end
	effects[#effects+1] = effect
	-- LogUtility.InfoFormat("<color=red>add effect: </color>{0}, {1},{2}", tostring(guid), data.times,data.effect)
	effect:Start(self.EffectEnd,self)
end

function NSceneEffectProxy:Client_AddSceneEffect(id,pos,effectPath,oneShot)
	if(not oneShot) then
		local effect = self.sceneEffectMap[id]
		if(effect == nil) then
			-- LogUtility.InfoFormat("<color=red>add effect: </color>{0}, {1},{2}", id, effectPath,pos)
			effect = ReusableObject.Create( ClientSceneEffect, false, nil )
			-- effect = ClientSceneEffect.CreateAsTable()
			self.sceneEffectMap[id] = effect
			effect:Start(pos,effectPath,oneShot)
		end
	else
		ClientSceneEffect.PlayEffect(pos,effectPath,oneShot)
	end
end

function NSceneEffectProxy:Client_RemoveSceneEffect(id)
	local effect = self.sceneEffectMap[id]
	if(effect) then
		self.sceneEffectMap[id] = nil
		effect:Destroy()
	end
end

function NSceneEffectProxy:Server_AddSceneEffect(data)
	if(data.id ==nil or data.id ==0) then
		return
	end
	local guid = data.id
	local effect = self.sceneEffectMap[guid]
	if(effect==nil) then
		data.effect = self:GetEffectPath(data.effect)
		effect = NSceneEffect.CreateAsTable(data)
		self.sceneEffectMap[guid] = effect
		effect:Start(self.EffectEnd,self)
	end
end

function NSceneEffectProxy:Server_RemoveSceneEffect(id)
	self:Client_RemoveSceneEffect(id)
end

function NSceneEffectProxy:EffectEnd(effect)
	self:Remove(effect.args, effect)
end

function NSceneEffectProxy:Destroy(effect)
	if nil == effect or type(effect)~="table" then
		return
	end
	if(effect.__cname and effect.__cname ~= "NSceneEffect" and effect.__cname ~= "ClientSceneEffect") then
		return
	end

	if(effect:Alive()) then
		effect:Destroy()
	end
end

function NSceneEffectProxy:Remove(data, effect)
	if(data.id and data.id>0) then
		self:Server_RemoveSceneEffect(data.id)
	else
		local guid = NSceneEffect.GetEffectGuid(data)
		-- print(string.format("<color=red>remove effect: </color>%s", tostring(guid)))
		local effects = self:Find(guid)
		if nil ~= effects then
			if nil ~= effect then
				local index = TableUtil.Remove(effects, effect)
				self:Destroy(effect)
				-- LogUtility.InfoFormat("<color=red>remove: </color>{0}, {1}", tostring(guid), tostring(index))
			else
				--移除全部
				for k,v in pairs(effects) do
					-- LogUtility.InfoFormat("<color=red>remove: </color>{0}, {1}", tostring(guid), tostring(k))
					self:Destroy(v)
				end
				ReusableTable.DestroyAndClearArray(effects)
				self.userMap[guid] = nil
			end
		end	
	end
	return effect
end

function NSceneEffectProxy:Clear()
	for _, effects in pairs(self.userMap) do
		for k,v in pairs(effects) do
			-- LogUtility.InfoFormat("<color=red>remove: </color>{0}, {1}", tostring(_), tostring(k))
			self:Destroy(v)
		end
		ReusableTable.DestroyAndClearArray(effects)
		self.userMap[_] = nil
 	end

 	for k,effect in pairs(self.sceneEffectMap) do
 		self.sceneEffectMap[k] = nil
 		self:Destroy(effect)
 	end
end
NSceneEffect = reusableClass('NSceneEffect')
NSceneEffect.PoolSize = 20

NSceneEffect.AssetEffect = "AssetEffect"

function NSceneEffect.GetEffectGuid(data)
	if(data.id~=nil and data.id~=0) then
		return data.id
	end
	return tostring(data.charid).."_"..tostring(data.index)
end

function NSceneEffect.IsEffectOneShot(args)
	return 0 ~= args.times
end

function NSceneEffect:ctor(data)
	NSceneEffect.super.ctor(self)
	
	self:CreateWeakData()
end

function NSceneEffect:Start(endCallback,context)
	if self.running then
		return
	end
	self.running = true
	-- print(string.format("<color=red>SceneEffect Start: </color>%s", tostring(self.guid)))
	
	self.endCallback = endCallback
	self.context = context

	local args = self.args
	if nil ~= args.delay and 0 < args.delay then
		self.delayLT = LeanTween.delayedCall(args.delay/1000, function ()
			self:DoStart()
		end)
	else
		self:DoStart()
	end
end

function NSceneEffect.PlayEffect(args, creature)
	if NSceneEffect.IsEffectOneShot(args) then
		local go = nil
		if args.posbind then
			--绑定世界坐标位置
			if(creature) then
				return creature.assetRole:PlayEffectOneShotAt(args.effect,args.effectpos)
			else
				NavMeshUtility.SelfSample(args.pos)
				return Asset_Effect.PlayOneShotAt(args.effect,args.pos)
			end
		else
			--绑定ep点游戏对象
			return creature.assetRole:PlayEffectOneShotOn(args.effect,args.effectpos)
		end
	else
		if args.posbind then
			--绑定世界坐标位置
			if(creature) then
				return creature.assetRole:PlayEffectAt(args.effect,args.effectpos)
			else
				NavMeshUtility.SelfSample(args.pos)
				return Asset_Effect.PlayAt(args.effect,args.pos)
			end
		else
			--绑定ep点游戏对象
			return creature.assetRole:PlayEffectOn(args.effect,args.effectpos)
		end
	end
end

function NSceneEffect:DoStart()
	if not self.running then
		return
	end

	local args = self.args
	self:CancelDelay()

	local assetEffect
	if args.epbind then
		local creature =  SceneCreatureProxy.FindCreature(args.charid)
		if nil ~= creature then
			assetEffect = NSceneEffect.PlayEffect(args, creature)
		end
	else
		assetEffect = NSceneEffect.PlayEffect(args)
		assetEffect:ResetLocalEulerAnglesXYZ(0,args.dir,0)
	end
	if(assetEffect and not NSceneEffect.IsEffectOneShot(args)) then
		self:CreateWeakData()
		self:SetWeakData(NSceneEffect.AssetEffect,assetEffect)
	else
		if(not self:FireCallBack()) then
			self:Destroy()
		end
	end
end

function NSceneEffect:CancelDelay()
	if nil ~= self.delayLT then
		self.delayLT:cancel()
		self.delayLT = nil
	end
end

function NSceneEffect:FireCallBack()
	if nil ~= self.endCallback then
		local call,context = self.endCallback,self.context
		self.endCallback = nil
		self.context = nil
		call(context,self)
		return true
	end
	return false
end

-- override begin
function NSceneEffect:DoConstruct(asArray, data)
	NSceneEffect.super.DoConstruct(self)
	local args = ReusableTable.CreateTable()
	self.args = args

	args.charid = data.charid
	args.index = data.index
	args.epbind = data.epbind
	args.effectpos = data.effectpos
	args.times = data.times
	args.posbind = data.posbind
	args.effect = data.effect
	args.pos = ProtolUtility.S2C_Vector3(data.pos)
	args.delay = data.delay
	args.id = data.id
	args.dir = ServiceProxy.ServerToNumber(data.dir)

	self.guid = NSceneEffect.GetEffectGuid(data)
end

function NSceneEffect:Destroy()
	-- body
	-- LogUtility.InfoFormat("<color=red>SceneEffect Destroy: </color>{0} {1} {2}", tostring(self.guid),self.args.index,tostring(self))
	NSceneEffect.super.Destroy(self)
end

function NSceneEffect:DoDeconstruct(asArray)
	if not self.running then
		return
	end
	self.running = false
	-- LogUtility.InfoFormat("<color=red>SceneEffect End: </color>{0} {1} {2}", tostring(self.guid),self.args.index,self.args.effect)
	self.endCallback = nil
	self.context = nil
	self:CancelDelay();

	local effect 
	if(self._weakData) then
		effect = self:GetWeakData(NSceneEffect.AssetEffect)
	end

	NSceneEffect.super.DoDeconstruct(self)
	if(effect) then
		effect:Destroy()
	end
	if(self.args) then
		if(self.args.pos) then
			self.args.pos:Destroy()
			self.args.pos = nil
		end
		ReusableTable.DestroyAndClearTable(self.args)
		self.args = nil
	end
end

-- function NSceneEffect:OnObserverDestroyed(k, obj)
-- 	if(k == NSceneEffect.AssetEffect) then
-- 		if(not self:FireCallBack()) then
-- 			self:Destroy()
-- 		end
-- 	end
-- end
-- override end

ClientSceneEffect = reusableClass('ClientSceneEffect',NSceneEffect)
ClientSceneEffect.PoolSize = 10

-- override begin
function ClientSceneEffect:Start(pos,effect,oneShot,endCallback,context)
	if self.running then
		return
	end
	self.running = true
	self.endCallback = endCallback
	self.context = context
	local assetEffect = ClientSceneEffect.PlayEffect(pos,effect,oneShot)
	self:SetWeakData(NSceneEffect.AssetEffect,assetEffect)
end

function ClientSceneEffect.PlayEffect(pos,effect,oneShot)
	if(oneShot) then
		return Asset_Effect.PlayOneShotAt(effect,pos)
	else
		return Asset_Effect.PlayAt(effect,pos)
	end
end

function ClientSceneEffect:DoConstruct(asArray, data)
	self._alive = true
	self:CreateWeakData()
end

function ClientSceneEffect:OnObserverDestroyed(k, obj)
end
-- override end
