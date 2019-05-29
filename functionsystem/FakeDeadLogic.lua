FakeDeadLogic = class("FakeDeadLogic")
local Hp_Max = 90.0
local Sp_Max = 90.0
local TryUseSkillInterval = 1
local On_Condition = {HasSkill = 1}
local FitAll_On = 0
for k, v in pairs(On_Condition) do
  FitAll_On = FitAll_On + v
end
function FakeDeadLogic:ctor(creature)
  self.AutoBattleManager = Game.AutoBattleManager
  self.creature = creature
  self.on = 0
  self.nextTryTime = 0
end
function FakeDeadLogic:Update(time, deltaTime)
  if self.on == FitAll_On and self.creature:IsFakeDead() and self.AutoBattleManager.on then
    local props = self.creature.data.props
    if nil ~= props then
      local maxHP = props.MaxHp:GetValue()
      local HP = props.Hp:GetValue()
      local maxSP = props.MaxSp:GetValue()
      local SP = props.Sp:GetValue()
      if HP >= Hp_Max / 100.0 * maxHP and SP >= Sp_Max / 100.0 * maxSP and self.skillID ~= nil and self.skillID > 0 and SkillProxy.Instance:SkillCanBeUsedByID(self.skillID) then
        self:_TryUseSkill(time, TryUseSkillInterval)
        return true
      end
    end
  end
end
function FakeDeadLogic:_TryUseSkill(time, interval)
  if time < self.nextTryTime then
    return
  end
  self.nextTryTime = time + interval
  FunctionSkill.Me():TryUseSkill(self.skillID)
end
function FakeDeadLogic:SetSkill(skillID)
  self.skillID = skillID or 0
  if self.skillID ~= nil and self.skillID > 0 then
    self:_SetOn(On_Condition.HasSkill, true)
  else
    self:_SetOn(On_Condition.HasSkill, false)
  end
end
function FakeDeadLogic:_SetOn(condition, on)
  if on then
    if self.on & condition <= 0 then
      self.on = self.on + condition
    end
  elseif self.on & condition > 0 then
    self.on = self.on - condition
  end
end
