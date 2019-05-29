RedTipProxy = class("RedTipProxy", pm.Proxy)
RedTipProxy.Instance = nil
RedTipProxy.NAME = "RedTipProxy"
RedTipProxy.UpdateRedTipEvent = "RedTipProxy.UpdateRedTipEvent"
RedTipProxy.UpdateParamEvent = "RedTipProxy.UpdateParamEvent"
function RedTipProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RedTipProxy.NAME
  if RedTipProxy.Instance == nil then
    RedTipProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function RedTipProxy:Init()
  self.groupIDs = {}
  local groups
  for k, v in pairs(Table_RedTip) do
    if v.GroupID then
      groups = self.groupIDs[v.GroupID]
      if groups == nil then
        groups = {}
        self.groupIDs[v.GroupID] = groups
      end
      groups[#groups + 1] = k
    end
  end
  self.redTips = {}
  self.redTipsByMenu = {}
  self.uis = {}
  EventManager.Me():AddEventListener(ServiceEvent.NUserNewMenu, self.HandleMenuOpen, self)
end
function RedTipProxy:HandleMenuOpen(openMenus)
  for i = 1, #openMenus do
    local tips = self.redTipsByMenu[openMenus[i]]
    if tips then
      local tip
      for j = 1, #tips do
        tip = tips[j]
        if tip.isBlockByMenu and tip.enable then
          tip:AddReds()
        end
      end
    end
  end
end
function RedTipProxy:GetRedTip(id)
  return self.redTips[id]
end
function RedTipProxy:GetOrCreateRedTip(id)
  local tip = self:GetRedTip(id)
  if tip == nil then
    tip = RedTip.new(id, paramIds)
    if tip.config.MenuID then
      local tips = self.redTipsByMenu[tip.config.MenuID]
      if tips == nil then
        tips = {}
        self.redTipsByMenu[tip.config.MenuID] = tips
      end
      tips[#tips + 1] = tip
    end
    self.redTips[id] = tip
  end
  return tip
end
function RedTipProxy:InRedTip(id)
  local tip = self:GetRedTip(id)
  if tip ~= nil then
    return tip.enable
  end
  return false
end
function RedTipProxy:IsNew(tipId, id)
  local tip = self:GetRedTip(tipId)
  if tip and tip.enable then
    return tip:HasParam(id)
  end
  return false
end
function RedTipProxy:SeenNew(tipid, subtipid)
  local tip = self:GetOrCreateRedTip(tipid)
  if tip.enable and tip.config then
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(tipid, subtipid)
  end
end
function RedTipProxy:RemoveWholeTipsByServerData(data)
  for i = 1, #data.redtip do
    self:RemoveWholeTip(data.redtip[i].redsys)
  end
end
function RedTipProxy:RemoveWholeTips(ids)
  for i = 1, #ids do
    self:RemoveWholeTip(ids[i])
  end
end
function RedTipProxy:RemoveAll()
  for k, v in pairs(self.redTips) do
    self:RemoveWholeTip(k)
  end
end
function RedTipProxy:RemoveWholeTip(id)
  if self:InRedTip(id) then
    local tip = self:GetOrCreateRedTip(id)
    tip:SetEnable(false)
  end
end
function RedTipProxy:UpdateRedTipsbyServer(data)
  if data.opt == SceneTip_pb.ETIPOPT_UPDATE then
    for i = 1, #data.redtip do
      self:UpdateRedTipbyServer(data.redtip[i])
    end
  elseif data.opt == SceneTip_pb.ETIPOPT_DELETE then
    self:RemoveWholeTipsByServerData(data)
  end
end
function RedTipProxy:UpdateRedTipbyServer(data)
  if data.optItem == SceneTip_pb.ETIPITEMOPT_ADD then
    self:UpdateRedTip(data.redsys, data.tipid)
  elseif data.optItem == SceneTip_pb.ETIPITEMOPT_DELETE then
    self:RemoveRedTip(data.redsys, data.tipid)
  end
end
function RedTipProxy:UpdateRedTip(id, paramIds)
  if self:InRedTip(id) then
    local tip = self:GetOrCreateRedTip(id)
    tip:AddParams(paramIds)
    GameFacade.Instance:sendNotification(RedTipProxy.UpdateParamEvent, {id = id, paramIds = paramIds})
    return
  end
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  tip:SetEnable(true)
  tip:AddParams(paramIds)
  GameFacade.Instance:sendNotification(RedTipProxy.UpdateRedTipEvent, {id = id, paramIds = paramIds})
end
function RedTipProxy:RemoveRedTip(id, paramIds)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  if tip then
    tip:RemoveParams(paramIds)
  end
end
function RedTipProxy:RegisterUIs(id, uis)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  for i = 1, #uis do
    local uiData = self.uis[uis[i]]
    if not uiData then
      uiData = {
        ui = uis[i],
        red = nil,
        check = ConditionCheck.new()
      }
      self.uis[ui] = uiData
    end
    uiData.check:SetReason(id)
    tip:RegisterUI(uiData)
  end
end
function RedTipProxy:RegisterUIByGroupID(groupID, ui, depth, offset, side)
  local groupIDs = self.groupIDs[groupID]
  if groupIDs then
    for i = 1, #groupIDs do
      self:RegisterUI(groupIDs[i], ui, depth, offset, side)
    end
  end
end
function RedTipProxy:UnRegisterUIByGroupID(groupID, ui)
  local groupIDs = self.groupIDs[groupID]
  if groupIDs then
    for i = 1, #groupIDs do
      self:UnRegisterUI(groupIDs[i], ui)
    end
  end
end
function RedTipProxy:RegisterUI(id, ui, depth, offset, side)
-- fail 29
null
8
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  local uiData = self.uis[ui]
  if not uiData then
    uiData = {
      ui = ui,
      red = nil,
      check = ConditionCheck.new(),
      depth = depth
    }
    self.uis[ui] = uiData
  end
  uiData.offset = {-10, -10}
  uiData.side = side or NGUIUtil.AnchorSide.TopRight
  tip:RegisterUI(uiData)
end
function RedTipProxy:UnRegisterUIs(id, uis)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  for i = 1, #uis do
    tip:UnRegisterUI(uis[i])
    self.uis[uis[i]] = nil
  end
end
function RedTipProxy:UnRegisterUI(id, ui)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  tip:UnRegisterUI(ui)
  self.uis[ui] = nil
end
function RedTipProxy:TestPrint()
  local count = 0
  for k, v in pairs(self.uis) do
    count = count + 1
  end
end
RedTip = class("RedTip", EventDispatcher)
RedTip.resID = ResourcePathHelper.UICell("RedTipCell")
function RedTip:ctor(id, params)
  self.enable = false
  self.id = id
  self.config = Table_RedTip[id]
  self.params = {}
  self.uis = {}
  self:AddParams(params)
end
function RedTip:SetEnable(value)
  if self.enable ~= value then
    self.enable = value
    if self.enable then
      self:AddReds()
    else
      self:RemoveReds()
    end
  end
end
function RedTip:AddRed(uiData)
  if self.config and self.config.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(self.config.MenuID) then
    self.isBlockByMenu = true
    return
  end
  self.isBlockByMenu = false
  uiData.check:SetReason(self.id)
  if uiData.red == nil or GameObjectUtil.Instance:ObjectIsNULL(uiData.red) then
    uiData.red = Game.AssetManager_UI:CreateAsset(RedTip.resID, uiData.ui.gameObject):GetComponent(UISprite)
    UIUtil.ChangeLayer(uiData.red, uiData.ui.gameObject.layer)
    local parentSP = uiData.ui.gameObject:GetComponent(UIWidget)
    if parentSP then
      local pos = NGUIUtil.GetAnchorPoint(uiData.red, parentSP, uiData.side, uiData.offset)
      uiData.red.transform.position = pos
      uiData.red.transform.localScale = Vector3.one
      uiData.red.depth = uiData.depth or parentSP.depth + 10
    else
      error("\231\186\162\231\130\185\230\143\144\231\164\186\239\188\140\232\175\183\228\188\160\229\133\165uiwidget\231\154\132\230\184\184\230\136\143\231\136\182\231\137\169\228\189\147")
    end
  end
end
function RedTip:AddReds()
  for k, v in pairs(self.uis) do
    if not GameObjectUtil.Instance:ObjectIsNULL(k) then
      self:AddRed(v)
    else
      RedTipProxy.Instance.uis[k] = nil
      self.uis[k] = nil
    end
  end
end
function RedTip:RemoveRed(uiData)
  if uiData and uiData.red and not GameObjectUtil.Instance:ObjectIsNULL(uiData.red) then
    uiData.check:RemoveReason(self.id)
    if uiData.check:HasReason() == false then
      Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, uiData.red.gameObject)
      uiData.red = nil
    end
  end
end
function RedTip:RemoveReds()
  for k, v in pairs(self.uis) do
    if not GameObjectUtil.Instance:ObjectIsNULL(k) then
      self:RemoveRed(v)
    else
      RedTipProxy.Instance.uis[k] = nil
      self.uis[k] = nil
    end
  end
end
function RedTip:RegisterUI(uiData)
  self.uis[uiData.ui] = uiData
  if self.enable then
    self:AddRed(uiData)
  end
end
function RedTip:UnRegisterUI(ui)
  local uiData = self.uis[ui]
  self:RemoveRed(uiData)
  self.uis[ui] = nil
end
function RedTip:AddParams(params)
  if params then
    TableUtility.TableClear(self.params)
    for i = 1, #params do
      self.params[params[i]] = true
    end
  end
end
function RedTip:RemoveParams(params)
  if params then
    for i = 1, #params do
      self.params[params[i]] = nil
    end
  end
end
function RedTip:HasParam(id)
  return self.params[id] ~= nil
end
function RedTip:TestPrint()
  local count = 0
  for k, v in pairs(self.uis) do
    count = count + 1
  end
end
