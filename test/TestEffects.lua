TestEffects = class("TestEffects")
function TestEffects.Me()
  if nil == TestEffects.me then
    TestEffects.me = TestEffects.new()
  end
  return TestEffects.me
end
function TestEffects:ctor()
  self.skillEffects = {
    "Angelus",
    "AngelusShield",
    "AnkleSnare",
    "ArcherAttack",
    "ArrowShower",
    "Aspersio",
    "BackSlide_attack",
    "Bleeding",
    "Blessing",
    "BowlingBash_attack",
    "BurstOperation",
    "CastSkill",
    "ClashingSpiral_attack",
    "Cloaking",
    "ColdBolt",
    "ColdBolt_1",
    "ColdBolt_10",
    "ColdBolt_2",
    "ColdBolt_3",
    "ColdBolt_4",
    "ColdBolt_5",
    "ColdBolt_6",
    "ColdBolt_7",
    "ColdBolt_8",
    "ColdBolt_9",
    "CounterAttack",
    "CrimsonRock",
    "CriticalHit",
    "Curse",
    "DarkClaw",
    "Dark_cast",
    "Dispersion",
    "Dizzy",
    "DoubleStrafe",
    "DragonBreath_hit",
    "DragonHowling_attack",
    "DrakAttributeHit",
    "DrugRoad",
    "EagleEye",
    "Eagle_hit",
    "Earth_cast",
    "Endure_cast",
    "Epiclesis",
    "FalconEyes",
    "FireAttributeHit",
    "FireHunt",
    "FireWall",
    "Fire_cast",
    "FlameShock_Boom",
    "FlameShock_Buff",
    "ForgingFailure",
    "ForgingSuccess",
    "FrostBlasting",
    "Frozen",
    "FrozenBroken",
    "GhostHit",
    "GoddessPurify",
    "Grimtooth",
    "HallucinationWalk",
    "Heal",
    "Heal_hit",
    "HolyLight",
    "HolyLight_hit",
    "Home",
    "HuntingOfFire",
    "ImpactBlade",
    "ImproveConcentration",
    "IncreaseSpeed",
    "JupitelThunder",
    "JupitelThunder_hit",
    "Keeping",
    "KyrieEleison",
    "KyrieEleisonShield",
    "LandMine",
    "LightAttributeHit",
    "LightHP",
    "LightHP_buff",
    "LightHunt",
    "Light_cast",
    "LordOfVermilion",
    "MagicFreezing",
    "MagicanAttack",
    "Magnificat",
    "MagnumBreak_attack",
    "MagnusExorcismus",
    "Mandragora_hit",
    "MudFlatDeep",
    "Parry",
    "PecoPecoRide",
    "PecoPecoRide_hit",
    "PhantomMenace",
    "PhantomOpera",
    "Pierce",
    "PoisonArrow_attack",
    "PoisonArrow_cast",
    "PoisonAttributeHit",
    "Provoke",
    "RageSpear",
    "RageSpear_buff",
    "Reading",
    "ReikiSpear",
    "RemoveHidden",
    "Renovatio",
    "Resurrection",
    "ResurrectionPrepare",
    "RollingCutter",
    "Sanctuary",
    "Sandman",
    "Silence",
    "Sleep",
    "SonicBlow",
    "SoulStrike",
    "SpearDynamo",
    "SpearPuncture_attack",
    "SpiritualShock",
    "SpreadMagic",
    "StaveCrasher",
    "Stone",
    "StoneCurse",
    "StormGust",
    "StrongBladeStrike",
    "Summon",
    "Task_Clover",
    "Task_GetWet",
    "Task_Rainbow",
    "Task_magic2",
    "Task_magic3",
    "Task_necklace",
    "Tast_magic",
    "Teleport",
    "TerrainAttributeHit",
    "ThermalLance_cast",
    "ThiefAttack",
    "Thunderstorm",
    "TurnUndead",
    "UndeadHit",
    "VenomDust",
    "VenomSplasher",
    "VitalStrike",
    "WaterAttributeHit",
    "Water_cast",
    "WateringPray",
    "WhiteImprison",
    "WindAttributeHit",
    "WindWalker",
    "Wind_cast",
    "fire_tuowei",
    "poisoning",
    "sniper",
    "sniper_hit",
    "treatment_cast"
  }
  self:Reset()
end
function TestEffects:Reset()
  if self.effects then
    for i = 1, #self.effects do
      if GameObjectUtil.Instance:ObjectIsNULL(self.effects[i]) == false then
        GameObject.Destroy(self.effects[i])
      end
    end
  end
  self.effects = {}
  self.index = 1
  TimeTickManager.Me():ClearTick(self)
end
function TestEffects:Switch()
  if self.isRunning then
    self:ShutDown()
  else
    self:Launch()
  end
end
function TestEffects:Launch()
  if self.isRunning then
    return
  end
  if MyselfProxy.Instance.myself then
    self.tests = {
      "StrongBladeStrike",
      "Task_magic2",
      "ArrowShower"
    }
    if self.testIndex == nil then
      self.testIndex = 1
    else
      self.testIndex = self.testIndex + 1
      if self.testIndex > #self.tests then
        self.testIndex = self.testIndex - #self.tests
      end
    end
    do
      local name = self.tests[self.testIndex]
      self:SpawnEffect(name)
      LeanTween.delayedCall(0.5, function()
        ResourceManager.Instance:UnLoad(ResourceIDHelper.IDEffectSkill(name), true)
        self.isRunning = false
      end)
    end
  else
  end
end
function TestEffects:SpawnEffect(effectName)
  if effectName then
    local myself = MyselfProxy.Instance.myself
    local ep = SkillUtils.GetEffectPointGameObject(myself.roleAgent, 1)
    local resID = ResourceIDHelper.IDEffectSkill(effectName)
    local effect = EffectHelper.PlayOneShotOn(resID, ep)
    local renders = effect:GetComponentsInChildren(Renderer)
    local mats
    for i = 1, #renders do
      mats = renders[i].sharedMaterials
      for j = 1, #mats do
        if mats[j] == nil then
          errorLog("fuck " .. effectName)
        end
      end
    end
    return effect
  end
  return nil
end
function TestEffects:StepSpawnEffect()
  local effectName
  if self.index < 35 then
    effectName = self.skillEffects[self.index]
    self.index = self.index + 1
  else
    local index = math.random(1, #self.skillEffects)
    effectName = self.skillEffects[index]
    if #self.effects > 60 then
      self:RemoveEffectAt(1)
    end
  end
  if effectName then
    local effect = self:SpawnEffect(effectName)
    self.effects[#self.effects + 1] = {
      effect = effect,
      resID = resID
    }
  end
end
function TestEffects:ShutDown()
  if not self.isRunning then
    return
  end
  self.isRunning = false
  self:Reset()
end
function TestEffects:RemoveEffectAt(index)
  if GameObjectUtil.Instance:ObjectIsNULL(self.effects[index].effect) == false then
  end
  table.remove(self.effects, 1)
end
