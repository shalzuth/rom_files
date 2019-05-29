local Ignore_InputFocus_Cmd = {send = 1}
local facade
local notify = function(notificationName, body, type)
  if facade == nil then
    facade = GameFacade.Instance
  end
  facade:sendNotification(notificationName, body, type)
end
local Func_CloseUI = function(panelid)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if not hasNode then
    return false
  end
  notify(UIEvent.CloseUI, PanelProxy.Instance:GetViewType(panelid))
  return true
end
local Func_OpenUI = function(panelid)
  local panelConfig = PanelProxy.Instance:GetData(panelid)
  if panelConfig == nil then
    return false
  end
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if hasNode then
    return false
  end
  notify(UIEvent.JumpPanel, {view = panelConfig})
  return true
end
local HotKeyCmd = {}
HotKeyCmd.Type = {
  Forward = "forward",
  Toggle = "toggle",
  Reverse = "reverse"
}
function HotKeyCmd.use_shortskill(data)
  helplog("use_shortskill")
  notify(HotKeyEvent.UseShortCutSkill, data.Param)
  return true
end
function HotKeyCmd.change_shortskill(data)
  helplog("change_shortskill")
  notify(HotKeyEvent.SwitchShortCutSkillIndex, data.Param)
  return true
end
function HotKeyCmd.use_shortitem(data)
  helplog("use_shortitem")
  notify(HotKeyEvent.UseShortCutItem, data.Param)
  return true
end
function HotKeyCmd.auto_battle(data)
  helplog("auto_battle")
  local dtype = data.Type
  if dtype == HotKeyCmd.Type.Toggle then
    local isAuto = Game.AutoBattleManager.on
    if isAuto then
      Game.AutoBattleManager:AutoBattleOff()
    else
      Game.AutoBattleManager:AutoBattleOn()
      if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance.equipedAutoSkills) then
        MsgManager.DontAgainConfirmMsgByID(1712)
      end
    end
  elseif dtype == HotKeyCmd.Type.Forward then
    Game.AutoBattleManager:AutoBattleOn()
  elseif dtype == HotKeyCmd.Type.Reverse then
    Game.AutoBattleManager:AutoBattleOff()
  end
  return true
end
local _HandleOpenComPanelIds = function(com_panelid)
  for i = 1, #com_panelid do
    if Func_OpenUI(com_panelid[i]) then
      return true
    end
  end
  return false
end
local _HandleCloseComPanelIds = function(com_panelid)
  local panelProxy = PanelProxy.Instance
  local uiManagerProxy = UIManagerProxy.Instance
  local closeTypes = {}
  for i = 1, #com_panelid do
    local panelid = com_panelid[i]
    local data = panelProxy:GetData(panelid)
    if data == nil then
      redlog(string.format("PanelID:%s Get Data Error!!", panelid))
    end
    local suc = pcall(function()
      if uiManagerProxy:HasUINode(data) then
        local viewType = panelProxy:GetViewType(panelid)
        if viewType then
          table.insert(closeTypes, viewType)
        end
      end
    end)
    if not suc then
      redlog(string.format("PanelID:%s Check Error!!", panelid))
    else
    end
  end
  if #closeTypes == 0 then
    return false
  end
  table.sort(closeTypes, function(v1, v2)
    return v1.depth > v2.depth
  end)
  notify(UIEvent.CloseUI, closeTypes[1])
  return true
end
function HotKeyCmd.open_view(data)
  helplog("open_view")
  local param = data.Param
  local dtype = data.Type
  if param.panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not Func_OpenUI(param.panelid) then
        Func_CloseUI(param.panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return Func_OpenUI(param.panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return Func_CloseUI(param.panelid)
    end
  elseif param.com_panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not _HandleOpenComPanelIds(param.com_panelid) then
        _HandleCloseComPanelIds(param.com_panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return _HandleOpenComPanelIds(param.com_panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return _HandleCloseComPanelIds(param.com_panelid)
    end
  end
  return false
end
function HotKeyCmd.close_view(data)
  helplog("close_view")
  local param = data.Param
  local dtype = data.Type
  if param.panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not Func_CloseUI(param.panelid) then
        Func_OpenUI(param.panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return Func_CloseUI(param.panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return Func_OpenUI(param.panelid)
    end
  elseif param.com_panelid then
    if dtype == HotKeyCmd.Type.Toggle then
      if not _HandleCloseComPanelIds(param.com_panelid) then
        _HandleOpenComPanelIds(param.com_panelid)
      end
      return true
    elseif dtype == HotKeyCmd.Type.Forward then
      return _HandleCloseComPanelIds(panel.com_panelid)
    elseif dtype == HotKeyCmd.Type.Reverse then
      return _HandleOpenComPanelIds(panel.com_panelid)
    end
  end
  return false
end
function HotKeyCmd.esc_back(data)
  do return true end
  local popCount = UIManagerProxy.Instance:GetModalPopCount()
  if popCount <= 0 then
    return false
  end
  UIManagerProxy.Instance:PopView()
  return true
end
function HotKeyCmd.open_map(data)
  helplog("open_map")
  notify(HotKeyEvent.OpenMap, data.Type)
  return true
end
function HotKeyCmd.open_teamview(data)
  local panelConfig = TeamProxy.Instance:IHaveTeam() and PanelConfig.TeamMemberListPopUp or PanelConfig.TeamFindPopUp
  local hasNode = UIManagerProxy.Instance:HasUINode(panelConfig)
  if data.Type == HotKeyCmd.Type.Forward then
    if hasNode then
      return false
    end
    notify(UIEvent.JumpPanel, {view = panelConfig})
    return true
  elseif data.Type == HotKeyCmd.Type.Toggle then
    if hasNode then
      local viewType = PanelProxy.Instance:GetViewType(panelConfig.id)
      notify(UIEvent.CloseUI, viewType)
    else
      notify(UIEvent.JumpPanel, {view = panelConfig})
    end
    return true
  elseif data.Type == HotKeyCmd.Type.Reverse then
    if not hasNode then
      return false
    end
    local viewType = PanelProxy.Instance:GetViewType(panelConfig.id)
    notify(UIEvent.CloseUI, viewType)
    return false
  end
  if not TeamProxy.Instance:IHaveTeam() then
    notify(UIEvent.JumpPanel, {
      view = PanelConfig.TeamFindPopUp
    })
  else
    notify(UIEvent.JumpPanel, {
      view = PanelConfig.TeamMemberListPopUp
    })
  end
  return true
end
function HotKeyCmd.attack(data)
end
function HotKeyCmd.move(data)
end
function HotKeyCmd.choose(data)
end
function HotKeyCmd.send(data)
  helplog("send")
  notify(HotKeyEvent.Send)
  return true
end
HotKeyManager = class("HotKeyManager")
local inputKey
function HotKeyManager:ctor()
  if not ApplicationInfo.IsRunOnWindowns() then
    return
  end
  inputKey = Game.InputKey
  if inputKey == nil then
    return
  end
  HotKeyManager.Running = false
  self:RegisterHotKey()
end
local WindowsHotKey_KeyMap, WindowsMouse_KeyMap
local Init_WindowsHotKey_KeyMap = function()
  if WindowsHotKey_KeyMap ~= nil then
    return
  end
  local keyMap = {}
  for id, data in pairs(Table_WindowsHotKey) do
    local t = keyMap[data.Hotkey]
    if t == nil then
      t = {}
      keyMap[data.Hotkey] = t
    end
    table.insert(t, data)
  end
  WindowsHotKey_KeyMap = {}
  WindowsMouse_KeyMap = {}
  local dataSortFunc = function(da, db)
    return da.id < db.id
  end
  local keyCode = KeyCode
  for key, datas in pairs(keyMap) do
    table.sort(datas, dataSortFunc)
    local keys = string.split(key, "+")
    local isKey = true
    for i = 1, #keys do
      local codeEnum = KeyCode[keys[i]]
      if codeEnum == nil then
        isKey = false
        WindowsMouse_KeyMap[key] = datas
        break
      end
      keys[i] = codeEnum
    end
    if isKey then
      local enumKey = table.concat(keys, "+")
      WindowsHotKey_KeyMap[enumKey] = datas
    end
  end
end
function HotKeyManager.ExcuteHotKeyEvent(key1, key2)
  if not HotKeyManager.Running then
    redlog("HotKeyManager Not In Running")
    return
  end
  if WindowsHotKey_KeyMap == nil then
    redlog("HotKeyManager Not Init")
    return
  end
  local enumKey = ""
  if key1 and key1 ~= 0 then
    enumKey = tostring(key1)
  end
  if key2 and key2 ~= 0 then
    enumKey = key1 .. "+" .. key2
  end
  local datas = WindowsHotKey_KeyMap[enumKey]
  if datas == nil then
    error("not find hotKey:" .. enumKey)
    return
  end
  for i = 1, #datas do
    if HotKeyManager.ExcuteCmdByData(datas[i]) then
      return
    end
  end
end
function HotKeyManager.ExcuteCmdByData(data)
  local cmd = data.Cmd
  if UICamera.inputHasFocus and not Ignore_InputFocus_Cmd[cmd] then
    redlog("Foucsing Input")
    return false
  end
  local event = HotKeyCmd[cmd]
  if event and event(data) then
    return true
  end
end
function HotKeyManager:RegisterHotKey()
  local config = Table_WindowsHotKey
  if config == nil then
    return
  end
  if WindowsHotKey_KeyMap == nil then
    Init_WindowsHotKey_KeyMap()
  end
  for keyEnum, data in pairs(WindowsHotKey_KeyMap) do
    local keys = string.split(keyEnum, "+")
    if #keys == 1 then
      inputKey:Register(RO.InputKey.KeyState.Down, tonumber(keys[1]), HotKeyManager.ExcuteHotKeyEvent)
    elseif #keys == 2 then
      inputKey:Register(RO.InputKey.KeyState.Down, tonumber(keys[1]), tonumber(keys[2]), HotKeyManager.ExcuteHotKeyEvent)
    end
  end
end
function HotKeyManager:Launch()
  if HotKeyManager.Running then
    return
  end
  HotKeyManager.Running = true
end
function HotKeyManager:Shutdown()
  if not HotKeyManager.Running then
    return
  end
  HotKeyManager.Running = false
end
