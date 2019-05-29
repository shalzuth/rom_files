autoImport("RolePart_RootOffset")
autoImport("RolePart_Damp")
LogicManager_RolePart = class("LogicManager_RolePart")
local Logics = {
  [1] = RolePart_RootOffset,
  [2] = RolePart_Damp
}
local _CreatureRolePartArray = function()
  local array = ReusableTable.CreateRolePartArray()
  for i = 1, Asset_Role.PartCount do
    array[i] = nil
  end
  return array
end
local _DestroyRolePartArray = ReusableTable.DestroyRolePartArray
function LogicManager_RolePart:ctor()
  self.logics = {}
end
function LogicManager_RolePart:OnAssetRoleRedressed(assetRole)
  local observed = false
  local rolePartLogics = self.logics[assetRole]
  if nil == rolePartLogics then
    rolePartLogics = _CreatureRolePartArray()
  else
    observed = true
  end
  local logicCount = 0
  for i = 1, Asset_Role.PartCount do
    local logic = rolePartLogics[i]
    local rolePartID = assetRole:GetPartID(i)
    if 0 ~= rolePartID then
      local logicInfo = Table_RolePartLogic[rolePartID]
      if nil ~= logicInfo then
        local LogicClass = Logics[logicInfo.Logic]
        if nil ~= logic and LogicClass ~= logic.class then
          logic:Destroy()
          logic = nil
        end
        if nil == logic then
          logic = LogicClass.Create()
        end
        logic:SetParams(assetRole, i, logicInfo.Params)
        logicCount = logicCount + 1
      elseif nil ~= logic then
        logic:Destroy()
        logic = nil
      end
    elseif nil ~= logic then
      logic:Destroy()
      logic = nil
    end
    rolePartLogics[i] = logic
  end
  if 0 == logicCount then
    _DestroyRolePartArray(rolePartLogics)
    rolePartLogics = nil
    if observed then
      assetRole:UnregisterWeakObserver(self)
    end
  else
    assetRole:RegisterWeakObserver(self)
  end
  self.logics[assetRole] = rolePartLogics
end
function LogicManager_RolePart:LateUpdate(time, deltaTime)
  for assetRole, rolePartLogics in pairs(self.logics) do
    for i = 1, Asset_Role.PartCount do
      local logic = rolePartLogics[i]
      if nil ~= logic then
        logic:LateUpdate(time, deltaTime)
      end
    end
  end
end
function LogicManager_RolePart:ObserverDestroyed(assetRole)
  local rolePartLogics = self.logics[assetRole]
  if nil ~= rolePartLogics then
    for i = Asset_Role.PartCount, 1, -1 do
      local logic = rolePartLogics[i]
      if nil ~= logic then
        logic:Destroy()
      end
      rolePartLogics[i] = nil
    end
    _DestroyRolePartArray(rolePartLogics)
  end
  self.logics[assetRole] = nil
end
