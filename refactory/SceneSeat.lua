
SceneSeat = class("SceneSeat", ReusableObject)

if not SceneSeat.SceneSeat_Inited then
	SceneSeat.SceneSeat_Inited = true
	SceneSeat.PoolSize = 100
end

function SceneSeat.Create( args )
	return ReusableObject.Create( SceneSeat, true, args )
end

function SceneSeat:ctor()
	SceneSeat.super.ctor(self)
end

function SceneSeat:GetID()
	return self.staticData.id
end

function SceneSeat:GetAccessPosition()
	return self.staticData.StandPot
end

function SceneSeat:GetDir()
	return self.staticData.Dir
end

function SceneSeat:GetPassengerCount()
	return self.passengerCount
end

function SceneSeat:GetOn(creature)
	self.passengerCount = self.passengerCount + 1
	if 1 == self.passengerCount then
		self:_Hide()
	end
	local p = self.staticData.SeatPot
	creature:Logic_PlaceXYZTo(p[1],p[2],p[3])
	creature.assetRole:SetShadowEnable(false)
	local partner = creature.partner
	if partner ~= nil then
		partner:SetVisible(false, LayerChangeReason.SceneSeat)
	end
	helplog("SceneSeat:GetOn", creature.data.id, creature.data:GetName())
	return true
end

function SceneSeat:GetOff(creature)
	self.passengerCount = self.passengerCount - 1
	if 0 >= self.passengerCount and Game.SceneSeatManager:IsDisplaying() then
		self:_Show()
	end
	local p = self.staticData.StandPot
	creature:Logic_NavMeshPlaceXYZTo(p[1],p[2],p[3])
	creature:Logic_SetAngleY(self:GetDir())
	creature.assetRole:SetShadowEnable(true)
	local partner = creature.partner
	if partner ~= nil then
		partner:SetVisible(true, LayerChangeReason.SceneSeat)
	end
	helplog("SceneSeat:GetOff", creature.data.id, creature.data:GetName())
	return true
end

function SceneSeat:DeterminShow()
	if 0 < self.passengerCount then
		return
	end
	self:_Show()
end

function SceneSeat:Hide()
	self:_Hide()
end

function SceneSeat:Server_Show()
end

function SceneSeat:_Show()
	if nil == self.obj then
		local prefab = Game.Prefab_SceneSeat
		prefab.type = Game.GameObjectType.SceneSeat
		prefab.ID = self.staticData.id
		self.obj = LuaGameObjectClickable.Instantiate(Game.Prefab_SceneSeat)
		self.obj.transform.position = self.staticData.SeatPot
	else
		self.obj.gameObject:SetActive(true)
	end
end

function SceneSeat:_Hide()
	if nil ~= self.obj then
		self.obj.gameObject:SetActive(false)
	end
end

-- override begin
function SceneSeat:DoConstruct(asArray, args)
	self.staticData = args
	self.obj = nil
	self.passengerCount = 0
end

function SceneSeat:DoDeconstruct(asArray)
	self.staticData = nil
	if nil ~= self.obj then
		Object.Destroy(self.obj.gameObject)
		self.obj = nil
	end
end
-- override end

CustomSceneSeat = class("CustomSceneSeat",SceneSeat)
local SitAction = 60

function CustomSceneSeat.Create( args )
	return ReusableObject.Create( CustomSceneSeat, true, args )
end

function CustomSceneSeat:ctor()
	self.isCustomSeat = true
	CustomSceneSeat.super.ctor(self)
end

function CustomSceneSeat:Server_Show()
	if(self.staticData.SeverShow~=nil) then
		self:_Show()
	end
end

function CustomSceneSeat:DeterminShow()
end

function CustomSceneSeat:_Show()
	if nil == self.obj then
		if(self.staticData.PrefabID~=nil) then
			local prefab = ResourceManager.Instance:SLoad(ResourcePathHelper.BusCarrier( self.staticData.PrefabID ))
			self.obj = GameObject.Instantiate(prefab):GetComponent(PointSubject)
		end
		self.seat_animator = self.obj.gameObject:GetComponent(Animator)
		self.obj.transform.position = self.staticData.SeatPot
		if(self.staticData.PrefabDir) then
			LuaGameObject.SetLocalEulerAngleY(self.obj.transform,self.staticData.PrefabDir)
		end
	else
		self.obj.gameObject:SetActive(true)
	end
end

function CustomSceneSeat:GetOn(creature)
	self.passengerCount = self.passengerCount + 1
	local seat = self.obj:GetConnectPoint(1)
	if(seat~=nil) then
		creature:SetParent(seat.transform)
		creature.assetRole:SetShadowEnable(false)
		creature.assetRole:SetMountDisplay(false)
		local partner = creature.partner
		if partner ~= nil then
			partner:SetVisible(false, LayerChangeReason.SceneSeat)
		end
		if(creature == Game.Myself) then
			creature:Client_PlayMotionAction(self.staticData.ActionID or SitAction)
		else
			local actionInfo = Table_ActionAnime[self.staticData.ActionID or SitAction]
			if nil == actionInfo then
				return
			end
			creature:Client_PlayAction(actionInfo.Name, nil, true)
		end
		creature:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY,self:GetDir(),true)
	end
	if(self.seat_animator) then
		self.seat_animator:Play("ride_walk", -1, 0)
	end
	-- helplog("CustomSceneSeat:GetOn", creature.data.id, creature.data:GetName())
	return true
end

function CustomSceneSeat:GetOff(creature)
	self.passengerCount = self.passengerCount - 1

	-- FunctionSystem.InterruptCreature(creature)
	
	local p = self.staticData.StandPot

	-- 1 阴影整回来
	creature.assetRole:SetShadowEnable(true)
	creature.assetRole:SetMountDisplay(true)
	local partner = creature.partner
	if partner ~= nil then
		partner:SetVisible(true, LayerChangeReason.SceneSeat)
	end
	-- 2 
	creature:SetParent(nil)
	-- 3
	creature:Logic_NavMeshPlaceXYZTo(p[1],p[2],p[3])

	creature:Logic_SetAngleY(self:GetDir())

	creature:Logic_PlayAction_Idle()

	if(self.seat_animator) then
		self.seat_animator:Play("wait", -1, 0)
	end

	-- helplog("CustomSceneSeat:GetOff", creature.data.id, creature.data:GetName())
	return true
end

-- override begin
function CustomSceneSeat:DoConstruct(asArray, args)
	self.seat_animator = nil
	CustomSceneSeat.super.DoConstruct(self,asArray,args)
end

function CustomSceneSeat:DoDeconstruct(asArray)
	self.seat_animator = nil
	CustomSceneSeat.super.DoDeconstruct(self,asArray)
end
-- override end