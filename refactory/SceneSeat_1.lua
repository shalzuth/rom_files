SceneSeat = class("SceneSeat", ReusableObject)
local pos = LuaVector3.zero
if not SceneSeat.SceneSeat_Inited then
  SceneSeat.SceneSeat_Inited = true
  SceneSeat.PoolSize = 100
end
function SceneSeat.Create(args)
  return ReusableObject.Create(SceneSeat, true, args)
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
  creature:Logic_PlaceXYZTo(p[1], p[2], p[3])
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
  if self.passengerCount <= 0 and Game.SceneSeatManager:IsDisplaying() then
    self:_Show()
  end
  local p = self.staticData.StandPot
  creature:Logic_NavMeshPlaceXYZTo(p[1], p[2], p[3])
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
CustomSceneSeat = class("CustomSceneSeat", SceneSeat)
local SitAction = 60
function CustomSceneSeat.Create(args)
  return ReusableObject.Create(CustomSceneSeat, true, args)
end
function CustomSceneSeat:ctor()
  self.isCustomSeat = true
  CustomSceneSeat.super.ctor(self)
end
function CustomSceneSeat:Server_Show()
  if self.staticData.SeverShow ~= nil then
    self:_Show()
  end
end
function CustomSceneSeat:DeterminShow()
end
function CustomSceneSeat:_Show()
  if nil == self.obj then
    if self.staticData.PrefabID ~= nil then
      local prefab = ResourceManager.Instance:SLoad(ResourcePathHelper.BusCarrier(self.staticData.PrefabID))
      self.obj = GameObject.Instantiate(prefab):GetComponent(PointSubject)
    end
    self.seat_animator = self.obj.gameObject:GetComponent(Animator)
    if self.staticData.SeatPot ~= nil then
      self.obj.transform.position = self.staticData.SeatPot
    end
    if self.staticData.PrefabDir then
      LuaGameObject.SetLocalEulerAngleY(self.obj.transform, self.staticData.PrefabDir)
    end
  else
    self.obj.gameObject:SetActive(true)
  end
end
function CustomSceneSeat:GetOn(creature)
  self.passengerCount = self.passengerCount + 1
  local seat = self.obj:GetConnectPoint(1)
  if seat ~= nil then
    creature:SetParent(seat.transform)
    creature.assetRole:SetShadowEnable(false)
    creature.assetRole:SetMountDisplay(false)
    local partner = creature.partner
    if partner ~= nil then
      partner:SetVisible(false, LayerChangeReason.SceneSeat)
    end
    if creature == Game.Myself then
      creature:Client_PlayMotionAction(self.staticData.ActionID or SitAction)
    else
      local actionInfo = Table_ActionAnime[self.staticData.ActionID or SitAction]
      if nil == actionInfo then
        return
      end
      creature:Client_PlayAction(actionInfo.Name, nil, true)
    end
    if self:GetDir() ~= nil then
      creature:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self:GetDir(), true)
    end
  end
  if self.seat_animator then
    self.seat_animator:Play("ride_walk", -1, 0)
  end
  return true
end
function CustomSceneSeat:GetOff(creature)
  self.passengerCount = self.passengerCount - 1
  local p = self.staticData.StandPot
  creature.assetRole:SetShadowEnable(true)
  creature.assetRole:SetMountDisplay(true)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(true, LayerChangeReason.SceneSeat)
  end
  creature:SetParent(nil, true)
  if p ~= nil then
    creature:Logic_NavMeshPlaceXYZTo(p[1], p[2], p[3])
  end
  if self:GetDir() ~= nil then
    creature:Logic_SetAngleY(self:GetDir())
  end
  creature:Logic_PlayAction_Idle()
  if self.seat_animator then
    self.seat_animator:Play("wait", -1, 0)
  end
  return true
end
function CustomSceneSeat:DoConstruct(asArray, args)
  self.seat_animator = nil
  CustomSceneSeat.super.DoConstruct(self, asArray, args)
end
function CustomSceneSeat:DoDeconstruct(asArray)
  self.seat_animator = nil
  CustomSceneSeat.super.DoDeconstruct(self, asArray)
end
CustomSeat = class("CustomSeat", CustomSceneSeat)
function CustomSeat.Create(args)
  return ReusableObject.Create(CustomSeat, true, args)
end
function CustomSeat:GetOn(creature)
  if not creature:IsDressEnable() then
    return
  end
  self:_Show()
  CustomSeat.super.GetOn(self, creature)
  if self.obj ~= nil then
    self.obj.transform.position = creature:GetPosition()
    LuaGameObject.SetLocalEulerAngleY(self.obj.transform, creature:GetAngleY())
    creature:Logic_SetAngleY(0)
  end
  local assetRole = creature.assetRole
  assetRole:SetWingDisplay(false)
  assetRole:SetTailDisplay(false)
  creature:SetPeakEffectVisible(false, LayerChangeReason.SceneSeat)
end
function CustomSeat:GetOff(creature)
  self:_Hide()
  CustomSeat.super.GetOff(self, creature)
  local assetRole = creature.assetRole
  assetRole:SetWingDisplay(true)
  assetRole:SetTailDisplay(true)
  creature:SetPeakEffectVisible(true, LayerChangeReason.SceneSeat)
  if self.obj ~= nil then
    pos:Set(LuaGameObject.GetPosition(self.obj.transform))
    creature:Logic_NavMeshPlaceTo(pos)
  end
end
function CustomSeat:SetVisible(creature, visible)
  if visible then
    self:GetOn(creature)
  else
    self:GetOff(creature)
  end
end
