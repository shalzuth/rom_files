ClickGroundEffectManager = class("ClickGroundEffectManager")

local tempPos = LuaVector3.zero
--特效为异步，那么这里的逻辑也要按异步来做
function ClickGroundEffectManager:ctor()
	self._clickGroundEffect = nil -- Asset_Effect
	self._clickGroundGO = nil -- GameObject
	self._isShow = false
	self._effectPath = EffectMap.Maps.ClickGround
end

function ClickGroundEffectManager.OnEffectCreated( effectHandle,instance )
	instance._clickGroundGO = effectHandle.gameObject
	if(instance._clickGroundEffect) then
		if(instance._isShow) then
			instance:ShowEffect()
		else
			instance:HideEffect()
		end
	end
end

function ClickGroundEffectManager:_CreateEffect()
	if(self._clickGroundEffect==nil) then
		self._clickGroundEffect = Asset_Effect.PlayAtXYZ(self._effectPath, tempPos[1],tempPos[2],tempPos[3],self.OnEffectCreated,self)
	end
end

function ClickGroundEffectManager:SetPos(p)
	self:SetPosXYZ(p[1],p[2],p[3])
end

function ClickGroundEffectManager:SetPosXYZ(x,y,z)
	tempPos:Set(x,y,z)
	if(Slua.IsNull(self._clickGroundGO)) then
		self:_CreateEffect()
	else
		self._clickGroundGO.transform.localPosition = tempPos
	end
	GameFacade.Instance:sendNotification(MyselfEvent.TargetPositionChange, tempPos)
	self:_Launch()
end

function ClickGroundEffectManager:ShowEffect()
	if(self._clickGroundEffect and Slua.IsNull(self._clickGroundGO)==false) then
		self._clickGroundEffect:SetActive(true)
	else
		self._isShow = true
	end
end

function ClickGroundEffectManager:HideEffect()
	if(self._clickGroundEffect and Slua.IsNull(self._clickGroundGO)==false) then
		self._clickGroundEffect:SetActive(false)
	else
		self._isShow = false
	end
	GameFacade.Instance:sendNotification(MyselfEvent.TargetPositionChange, nil)
end

function ClickGroundEffectManager:_Launch()
	self:ShowEffect()
	if(self.running) then
		return
	end
	self.running = true
end

function ClickGroundEffectManager:Shutdown()
	if(not self.running) then
		return
	end
	self.running = false
	self:_DestroyEffect()
end

function ClickGroundEffectManager:_DestroyEffect()
	if(self._clickGroundEffect) then
		self._clickGroundEffect:Destroy()
	end
	self._clickGroundEffect = nil
	self._clickGroundGO = nil
end