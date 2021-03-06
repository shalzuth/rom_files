local EffectKey_PlayGuideEffectArrow = "EffectKey_PlayGuideEffectArrow"
local EffectKey_PlayGuideEffectCircle = "EffectKey_PlayGuideEffectCircle"
function NNpc:PlayGuideEffect()
  self:PlayEffect(EffectKey_PlayGuideEffectArrow, EffectMap.Maps.GuideArrow, RoleDefines_EP.Top, nil, true, true)
  self:PlayEffect(EffectKey_PlayGuideEffectCircle, EffectMap.Maps.GuideArea, RoleDefines_EP.Bottom, nil, true, true)
end
function NNpc:DestroyGuideEffect()
  self:RemoveEffect(EffectKey_PlayGuideEffectArrow)
  self:RemoveEffect(EffectKey_PlayGuideEffectCircle)
end
function NNpc:PlayDeathEffect()
  local path = EffectMap.Maps.NPCDead
  if self.data and self.data.staticData and self.data.staticData.DeathEffect ~= nil and self.data.staticData.DeathEffect ~= "" then
    path = self.data.staticData.DeathEffect
  end
  self:PlayEffect(nil, path, RoleDefines_EP.Middle, nil, false, false)
end
local EffectKey_GetGuildWelfare = "EffectKey_GetGuildWelfare"
function NNpc:PlayGuildWelfareEffect()
  if not GameConfig.GuildBuilding.roleeffect_getwelfare then
    local roleEffect = {
      EffectMap.Maps.GuideArrow,
      RoleDefines_EP.Top
    }
  end
  self:PlayEffect(EffectKey_GetGuildWelfare, roleEffect[1], roleEffect[2], nil, true, true)
end
function NNpc:DestroyGuideWelfareEffect()
  self:RemoveEffect(EffectKey_GetGuildWelfare)
end
