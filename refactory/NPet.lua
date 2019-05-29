autoImport("Table_PetAvatar")
NPet = reusableClass("NPet", NNpc)
NPet.PoolSize = 10
local rolePartIndex = {
  Asset_Role.PartIndex.Head,
  Asset_Role.PartIndex.Face,
  Asset_Role.PartIndex.Mouth,
  Asset_Role.PartIndex.Wing,
  Asset_Role.PartIndex.Tail
}
local tempVector3 = LuaVector3.zero
local tempRot = LuaQuaternion()
local GetPartCfg = function(id, cfg)
  for k, partCfg in pairs(cfg) do
    for i = 1, #partCfg do
      local equipId = partCfg[i].FakeID or partCfg[i].id
      if equipId == id then
        return partCfg[i]
      end
    end
  end
end
function NPet:ctor(aiClass)
  NPet.super.ctor(self, AI_CreatureLookAt)
end
function NPet:GetCreatureType()
  return Creature_Type.Pet
end
function NPet:IsMyPet()
  return self.data.ownerID == Game.Myself.data.id
end
function NPet:InitAssetRole()
  NPet.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetGUID(self.data.id)
  assetRole:SetName(self.data:GetOriginName())
  assetRole:SetClickPriority(self.data:GetClickPriority())
  assetRole:SetShadowEnable(self.data.staticData.move ~= 1)
  assetRole:SetInvisible(false)
  if self.data:IsCatchNpc_Detail() then
    assetRole:SetColliderEnable(true)
  else
    assetRole:SetColliderEnable(self.data:IsPet() and self:IsMyPet())
  end
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetRenderEnable(true)
  assetRole:SetActionSpeed(1)
  LeanTween.delayedCall(3, function()
    self:ResetPos()
  end)
end
function NPet:Server_SetHandInHand(masterID, running)
  local func = self.ai.HandInHand
  if self.data:GetFeature_BeHold() then
    func = self.ai.BeHolded
  end
  if running then
    func(self.ai, masterID, self)
  else
    func(self.ai, 0, self)
  end
end
function NPet:Logic_LookAt(creatureGUID)
  if creatureGUID == nil then
    creatureGUID = 0
  end
  self.ai:LookAt(creatureGUID)
end
function NPet:SetDressEnable(v)
  if self.data and v ~= self.data.dressEnable then
    self.data:SetDressEnable(v)
    self:ReDress()
  end
end
function NPet:SetOwner(owner)
  if owner then
    self.data:SetOwnerID(owner.data.id)
    self:SetDressEnable(owner:IsDressEnable())
    if self.data:IsCatchNpc_Detail() then
      self.assetRole:SetColliderEnable(true)
    else
      self.assetRole:SetColliderEnable(self.data:IsPet() and self:IsMyPet())
    end
  else
    self.data:SetOwnerID(nil)
    self:SetDressEnable(true)
  end
  self.foundOwner = true
  self:CatchNpcTryLookAt()
end
function NPet:ParseServerData(serverData)
  return PetData.CreateAsTable(serverData)
end
function NPet:CatchNpcTryLookAt()
  if self.data:IsCatchNpc_Detail() then
    self:Logic_LookAt(self.data.ownerID)
  end
end
function NPet:_DelayDestroy()
  if not NScenePetProxy.Instance:RealRemove(self.data.id, true) then
    self:Destroy()
  end
end
function NPet:ReDress()
  if self._changeJobTimeFlag then
    return
  end
  NPet.super.ReDress(self)
  LeanTween.delayedCall(0.5, function()
    self:ResetPos()
  end)
end
function NPet:ResetPos()
  if not self.assetRole then
    return
  end
  local bodyId = self.assetRole:GetPartID(Asset_Role.PartIndex.Body)
  local avatarStaticData = Table_PetAvatar[bodyId]
  if not avatarStaticData then
    return
  end
  for i = 1, #rolePartIndex do
    local data_id = self.assetRole:GetPartID(rolePartIndex[i])
    local partCfg = GetPartCfg(data_id, avatarStaticData)
    if partCfg then
      local cfgCp = tonumber(string.sub(partCfg.EquipPoint, -1))
      local part = self.assetRole:GetPartObject(rolePartIndex[i])
      if part then
        if rolePartIndex[i] - 1 ~= cfgCp then
          local cp = self.assetRole:GetCP(cfgCp)
          if nil ~= cp then
            part.transform.parent = cp
          end
        end
        tempVector3:Set(partCfg.Position[1], partCfg.Position[2], partCfg.Position[3])
        part.transform.localPosition = tempVector3
        tempVector3:Set(partCfg.Euler[1], partCfg.Euler[2], partCfg.Euler[3])
        tempRot.eulerAngles = tempVector3
        part.transform.localRotation = tempRot
        tempVector3:Set(partCfg.Scale[1], partCfg.Scale[2], partCfg.Scale[3])
        part.transform.localScale = tempVector3
      end
    end
  end
end
function NPet:PlayChangeJob()
  FunctionSystem.InterruptCreature(self)
  self:_PlayChangeJobBeginEffect()
end
function NPet:_PlayChangeJobBeginEffect()
  self._changeJobTimeFlag = Time.time + 3
  self.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_whiteClear, LuaGeometry.Const_Col_white, 3)
  self:PlayEffect(nil, EffectMap.Maps.JobChange, 0, nil, false, true)
end
function NPet:Update(time, deltaTime)
  NPet.super.Update(self, time, deltaTime)
  self:_UpdateEffect(time, deltaTime)
end
function NPet:_UpdateEffect(time, deltaTime)
  if self._changeJobTimeFlag and time >= self._changeJobTimeFlag then
    self._changeJobTimeFlag = nil
    self:_PlayChangeJobFireEffect()
  end
end
function NPet:_PlayChangeJobFireEffect()
  self:ReDress()
  FunctionSystem.InterruptCreature(self)
  self.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_white, LuaGeometry.Const_Col_whiteClear, 0.3)
end
function NPet:DoConstruct(asArray, serverData)
  self.foundOwner = false
  NPet.super.DoConstruct(self, asArray, serverData)
  self:CatchNpcTryLookAt()
end
function NPet:DoDeconstruct(asArray)
  NPet.super.DoDeconstruct(self, asArray)
end
