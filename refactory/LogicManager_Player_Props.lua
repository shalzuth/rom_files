LogicManager_Player_Props = class("LogicManager_Player_Props", LogicManager_Creature_Props)
function LogicManager_Player_Props:ctor()
  LogicManager_Player_Props.super.ctor(self)
  self:AddUpdateCall("TransformID", self.UpdateTransformState)
end
function LogicManager_Player_Props:UpdateTransformState(ncreature, propName, oldValue, p)
  local transformID = p:GetValue()
  if transformID == 0 then
    FunctionTransform.Me():EndTransform(ncreature)
  else
    FunctionTransform.Me():TransformTo(ncreature, transformID)
  end
end
