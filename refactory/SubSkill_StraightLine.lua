local SelfClass = {}
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.zero
function SelfClass:Deconstruct()
end
function SelfClass:Start(endPosition)
  local args = self.args
  local effect = args[8]
  VectorUtility.Better_LookAt(effect:GetLocalPosition(), tempVector3, endPosition)
  effect:ResetLocalEulerAngles(tempVector3)
  return true
end
function SelfClass:End()
end
function SelfClass:Update(endPosition, refreshed, time, deltaTime)
  local args = self.args
  local effect = args[8]
  local currentPosition = effect:GetLocalPosition()
  if refreshed then
    VectorUtility.Better_LookAt(currentPosition, tempVector3, endPosition)
    effect:ResetLocalEulerAngles(tempVector3)
  end
  local nextPosition = tempVector3
  local emitParams = args[2]
  local deltaDistance = emitParams.speed * deltaTime
  LuaVector3.Better_MoveTowards(currentPosition, endPosition, nextPosition, deltaDistance)
  if VectorUtility.AlmostEqual_3(nextPosition, endPosition) then
    self:Hit(endPosition)
    return false
  else
    effect:ResetLocalPosition(nextPosition)
    return true
  end
end
return SelfClass
