UIModelRolesList = class("UIModelRolesList")
local roles = {}
local emptyIndex = 0
local recycleTable = {}
UIModelRolesList.ins = nil
function UIModelRolesList.Ins()
  if UIModelRolesList.ins == nil then
    UIModelRolesList.ins = UIModelRolesList.new()
  end
  return UIModelRolesList.ins
end
function UIModelRolesList:SetRoles(pRoles)
  self:ClearRoles()
  if pRoles ~= nil and #pRoles > 0 then
    for i = 1, #pRoles do
      self:AddRole(pRoles[i])
    end
  end
end
function UIModelRolesList:GetRoles()
  return roles
end
function UIModelRolesList:ClearRoles()
  for i = 1, #roles do
    roles[i] = 0
  end
end
function UIModelRolesList:AddRole(role)
  local isStored = false
  for i = 1, #roles do
    local v = roles[i]
    if v == 0 then
      roles[i] = role
      isStored = true
      break
    end
  end
  if not isStored then
    table.insert(roles, role)
  end
end
function UIModelRolesList:SelectedRolePlistKey()
  local plistKeyForSelectedRole = "SELECTED_ROLE"
  local loginData = FunctionLogin.Me():getLoginData()
  local account = loginData ~= nil and loginData.accid or 0
  local server = FunctionLogin.Me():getCurServerData()
  local serverID = server ~= nil and server.serverid or 0
  plistKeyForSelectedRole = plistKeyForSelectedRole .. "_" .. account .. "_" .. serverID
  return plistKeyForSelectedRole
end
function UIModelRolesList:SetSelectedRole(roleID)
  if roleID > 0 then
    PlayerPrefs.SetString(self:SelectedRolePlistKey(), tostring(roleID))
  end
end
function UIModelRolesList:GetSelectedRole()
  local strRoleID = PlayerPrefs.GetString(self:SelectedRolePlistKey())
  if GameObjectUtil.Instance:SystemObjectIsNULL(strRoleID) or strRoleID == "" then
    return 0
  else
    return tonumber(strRoleID)
  end
end
function UIModelRolesList:SetEmptyIndex(index)
  if index > 0 then
    emptyIndex = index
  end
end
function UIModelRolesList:GetEmptyIndex()
  return emptyIndex
end
function UIModelRolesList:GetRoleDeleteNeedTime(roleID)
  local needTime = 0
  if roleID > 0 then
    local roleInfo = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
    if roleInfo ~= nil then
      local roleLevel = roleInfo.baselv
      local deleteRoleNeedTimeConf = GameConfig.SelectRole.RoleBeDeletedNeedTime
      local keys = {}
      for k, _ in pairs(deleteRoleNeedTimeConf) do
        table.insert(keys, k)
      end
      table.sort(keys)
      for _, v in pairs(keys) do
        local level = v
        local deleteNeedTime = deleteRoleNeedTimeConf[level]
        if roleLevel <= level then
          needTime = deleteNeedTime
          break
        end
      end
    end
  end
  return needTime
end
function UIModelRolesList:SetRoleDeleteCDCompleteTime(complete_time)
  self.roleDeleteCDCompleteTime = complete_time
end
function UIModelRolesList:IsRoleDeleteCDComplete()
  if self.roleDeleteCDCompleteTime ~= nil then
    local currentTime = ServerTime.CurServerTime()
    currentTime = currentTime / 1000
    return currentTime > self.roleDeleteCDCompleteTime
  end
  return false
end
function UIModelRolesList:GetRoleDeleteCDTime()
  if self.roleDeleteCDCompleteTime ~= nil then
    local currentTime = ServerTime.CurServerTime()
    currentTime = currentTime / 1000
    currentTime = math.floor(currentTime)
    local deltaTime = self.roleDeleteCDCompleteTime - currentTime
    if deltaTime > 0 then
      return UIListItemViewControllerRoleSlot.ToHMS(deltaTime)
    end
    return nil
  end
  return nil
end
