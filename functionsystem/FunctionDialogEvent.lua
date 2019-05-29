FunctionDialogEvent = class("FunctionDialogEvent")
autoImport("ItemTipComCell")
autoImport("DialogEventConfig")
FunctionDialogEvent.ReplaceAction = "functional_action"
FunctionDialogEvent.EventResult_Type = {
  Result_Succes = "Result1",
  Result_Fail_1 = "Result2",
  Result_Fail_2 = "Result3",
  Result_Wait = "Wait",
  Result_Close = "Close"
}
local tempV3 = LuaVector3()
function FunctionDialogEvent.Me()
  if nil == FunctionDialogEvent.me then
    FunctionDialogEvent.me = FunctionDialogEvent.new()
  end
  return FunctionDialogEvent.me
end
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, UPGRADE_MATERIAL_SEARCH_BAGTYPES, REPLACE_MATERIAL_SEARCH_BAGTYPES, _BagProxy, _BlackSmithProxy, Func_Type_Map
function FunctionDialogEvent:ctor()
  Func_Type_Map = {
    EquipUpgrade = FunctionDialogEvent.SetEquipUpgrade,
    EquipReplace = FunctionDialogEvent.SetEquipReplace,
    UpJobLevel = FunctionDialogEvent.UpJobLevel,
    DialogGoddessOfferDead = FunctionDialogEvent.SetDialogGoddessOfferDead
  }
  local pacakgeCheck = GameConfig.PackageMaterialCheck
  if not pacakgeCheck or not pacakgeCheck.default then
  end
  DEFAULT_MATERIAL_SEARCH_BAGTYPES = {1, 9}
  UPGRADE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.upgrade or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  REPLACE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.upgrade or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  _BagProxy = BagProxy.Instance
  _BlackSmithProxy = BlackSmithProxy.Instance
  self:MapEventConfig()
end
function FunctionDialogEvent:MapEventConfig()
  self.paramaMap = {}
  self.paramaMap["%[EquipSite%]"] = FunctionDialogEvent.GetEquipSite
  self.paramaMap["%[EquipName%]"] = FunctionDialogEvent.GetEquipName
  self.paramaMap["%[ReplaceProduceName%]"] = FunctionDialogEvent.GetReplaceProduceName
  self.paramaMap["%[ReplaceMaterials%]"] = FunctionDialogEvent.GetReplaceMaterials
  self.paramaMap["%[UpgradeMaterials%]"] = FunctionDialogEvent.GetUpgradeMaterials
  self.paramaMap["%[UpgradeProduceName%]"] = FunctionDialogEvent.GetUpgradeProduceName
  self.paramaMap["%[UpJobLvMaterialsData%]"] = FunctionDialogEvent.UpJobLvMaterialsData
  self.paramaMap["%[UpJobLvNumber%]"] = FunctionDialogEvent.UpJobLvNumber
  self.paramaMap["%[CurrentDeadCoin%]"] = FunctionDialogEvent.CurrentDeadCoin
  self.paramaMap["%[LackOfDeadCoin%]"] = FunctionDialogEvent.LackOfDeadCoin
  self.paramaMap["%[DeadCoin%]"] = FunctionDialogEvent.DeadCoin
  self.paramaMap["%[DeadLv%]"] = FunctionDialogEvent.DeadLv
  self.eventMap = {}
  self.eventMap.Replace_MaterialEnough = FunctionDialogEvent.Replace_MaterialEnough
  self.eventMap.Upgrade_MaterialEnough = FunctionDialogEvent.Upgrade_MaterialEnough
  self.eventMap.CanUpJobLv = FunctionDialogEvent.CanUpJobLv
  self.eventMap.DoReplace = FunctionDialogEvent.DoReplace
  self.eventMap.DoUpgrade = FunctionDialogEvent.DoUpgrade
  self.eventMap.DoUpJobLv = FunctionDialogEvent.DoUpJobLv
  self.eventMap.ConsumeDeadCoin = FunctionDialogEvent.ConsumeDeadCoin
  self.showEventMap = {}
  self.showEventMap.ShowUpgradeItem = FunctionDialogEvent.ShowUpgradeItemEvent
  self.dialogEventType = {}
  self.dialogEventType.EquipUpgrade = {}
end
function FunctionDialogEvent.GetEquipSite(parama, npc)
  local site = parama.site
  if site then
    site = site[1]
    for _, cfg in pairs(GameConfig.EquipType) do
      for _, sitecfg in pairs(cfg.site) do
        if sitecfg == site then
          return cfg.name
        end
      end
    end
  end
  return "NULL"
end
function FunctionDialogEvent.GetEquipName(parama, npc)
  local itemData = parama.itemData
  if itemData then
    return itemData:GetName(true, true)
  end
  return "NULL"
end
function FunctionDialogEvent.GetReplaceProduceName(parama, npc)
  local itemData = parama.itemData
  local composeId = itemData.equipInfo.equipData.SubstituteID
  local composeData = composeId and Table_Compose[composeId]
  local product = composeData.Product
  if product.id and Table_Item[product.id] then
    return Table_Item[product.id].NameZh
  end
  return "NULL"
end
function FunctionDialogEvent.GetUpgradeProduceName(parama, npc)
  local itemData = parama.itemData
  local equipInfo = itemData.equipInfo
  local upgradeData = equipInfo.upgradeData
  local equiplv = equipInfo.equiplv
  if equiplv < equipInfo.upgrade_MaxLv then
    return itemData.staticData.NameZh .. StringUtil.IntToRoman(equiplv + 1)
  else
    local productid = upgradeData.Product
    if productid then
      return Table_Item[productid].NameZh
    end
  end
end
function FunctionDialogEvent.UpJobLvMaterialsData(parama, npc)
  local itemConfig = GameConfig.Peak.itemaddlevel
  local itemid, num = itemConfig[1].item, itemConfig[1].num
  return string.format("%s x %s", Table_Item[itemid].NameZh, num)
end
function FunctionDialogEvent.UpJobLvNumber(parama, npc)
  local itemConfig = GameConfig.Peak.itemaddlevel
  return itemConfig[1].level
end
function FunctionDialogEvent.CurrentDeadCoin(parama, npc)
  return Game.Myself.data.userdata:Get(UDEnum.DEADCOIN)
end
function FunctionDialogEvent.LackOfDeadCoin(parama, npc)
  local curOfferedNum = Game.Myself.data.userdata:Get(UDEnum.DEADEXP) or 0
  local deadLvData = Table_DeadLevel[Game.Myself.data.userdata:Get(UDEnum.DEADLV) + 1]
  return math.max((deadLvData and deadLvData.exp or 0) - curOfferedNum, 0)
end
function FunctionDialogEvent.DeadCoin(parama, npc)
  return Table_Item[GameConfig.Dead.deadcoinID].NameZh
end
function FunctionDialogEvent.DeadLv(parama, npc)
  return Game.Myself.data.userdata:Get(UDEnum.DEADLV)
end
local Func_GetMaterial_SearchNum = function(itemid, search_bagTypes, filterDamage)
  if itemid == 100 then
    return Game.Myself.data.userdata:Get(UDEnum.SILVER)
  else
    search_bagTypes = search_bagTypes or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    local items
    if ItemData.CheckIsEquip(itemid) then
      items = _BlackSmithProxy:GetMaterialEquips_ByEquipId(itemid, nil, filterDamage, nil, search_bagTypes)
    else
      items = _BagProxy:GetMaterialItems_ByItemId(itemid, search_bagTypes)
    end
    local searchNum = 0
    if items then
      for i = 1, #items do
        if _BagProxy:CheckIfFavoriteCanBeMaterial(items[i]) ~= false then
          searchNum = searchNum + items[i].num
        end
      end
    end
    return searchNum, items
  end
end
function FunctionDialogEvent.GetReplaceMaterials(parama, npc)
  local itemData = parama.itemData
  local composeId = itemData.equipInfo.equipData.SubstituteID
  local composeData = composeId and Table_Compose[composeId]
  local cost = composeData.BeCostItem
  local resultStr, materialStr = "", nil
  for i = 1, #cost do
    local id = cost[i].id
    materialStr = string.format(ZhString.FunctionDialogEvent_MaterialFormat, Table_Item[id].NameZh, Func_GetMaterial_SearchNum(id, UPGRADE_MATERIAL_SEARCH_BAGTYPES, true), cost[i].num)
    if i < #cost then
      materialStr = materialStr .. ZhString.FunctionDialogEvent_And
    end
    resultStr = resultStr .. materialStr
  end
  if composeData.ROB > 0 then
    resultStr = resultStr .. string.format(ZhString.FunctionDialogEvent_ZenyCost, composeData.ROB)
  end
  return resultStr
end
function FunctionDialogEvent.GetUpgradeMaterials(parama, npc)
  local itemData = parama.itemData
  local upgradeData = itemData.equipInfo.upgradeData
  local resultStr = ""
  local equiplv = itemData.equipInfo.equiplv
  local materialsKey = "Material_" .. equiplv + 1
  local cost = upgradeData[materialsKey]
  if cost then
    local materialStr = ""
    for i = 1, #cost do
      local id = cost[i].id
      materialStr = string.format(ZhString.FunctionDialogEvent_MaterialFormat, Table_Item[id].NameZh, Func_GetMaterial_SearchNum(id, nil, true), cost[i].num)
      if i < #cost then
        materialStr = materialStr .. ZhString.FunctionDialogEvent_And
      end
      resultStr = resultStr .. materialStr
    end
  end
  return resultStr
end
function FunctionDialogEvent.Replace_MaterialEnough(parama, npc)
  local itemData = parama.itemData
  local composeId = itemData.equipInfo.equipData.SubstituteID
  local composeData = composeId and Table_Compose[composeId]
  if MyselfProxy.Instance:GetROB() < composeData.ROB then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  local composeCost = composeData.BeCostItem
  local equipItems, lackMats
  for i = 1, #composeCost do
    local itemCfg = composeCost[i]
    local itemid, neednum = itemCfg.num or itemCfg.id, 1
    local searchNum = 0
    if ItemData.CheckIsEquip(itemid) then
      equipItems = _BlackSmithProxy:GetMaterialEquips_ByEquipId(itemid, neednum, true, nil, REPLACE_MATERIAL_SEARCH_BAGTYPES)
      for j = 1, #equipItems do
        searchNum = searchNum + equipItems[j].num
      end
    else
      searchNum = Func_GetMaterial_SearchNum(itemid)
    end
    if itemid ~= 100 and neednum > searchNum then
      if lackMats == nil then
        lackMats = {}
      end
      table.insert(lackMats, {
        id = itemid,
        count = neednum - searchNum
      })
    end
  end
  if lackMats and QuickBuyProxy.Instance:TryOpenView(lackMats, QuickBuyProxy.QueryType.NoDamage) then
    return FunctionDialogEvent.EventResult_Type.Result_Close
  end
  local hasRecover, tipEquips = FunctionItemFunc.RecoverEquips(equipItems)
  if hasRecover then
    return FunctionDialogEvent.EventResult_Type.Result_Wait
  end
  if #tipEquips > 0 then
    local confirmMsgParam = {}
    confirmMsgParam.id = 247
    confirmMsgParam.param = {
      tipEquips[1].equipInfo.refinelv
    }
    return FunctionDialogEvent.EventResult_Type.Result_Wait, confirmMsgParam
  end
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end
function FunctionDialogEvent.Upgrade_MaterialEnough(parama, npc)
  local itemData = parama.itemData
  local upgradeData = itemData.equipInfo.upgradeData
  local resultStr = ""
  local equiplv = itemData.equipInfo.equiplv
  local materialsKey = "Material_" .. equiplv + 1
  local cost = upgradeData[materialsKey]
  local itemid = itemData.staticData.id
  local costEquips, lackMats
  local matEnough = true
  for i = 1, #cost do
    local sc = cost[i]
    local searchNum = 0
    if sc.id == 100 then
      searchNum = Game.Myself.data.userdata:Get(UDEnum.SILVER) or 0
      if searchNum < sc.num then
        return FunctionDialogEvent.EventResult_Type.Result_Fail_1
      end
    elseif ItemData.CheckIsEquip(sc.id) then
      costEquips = _BlackSmithProxy:GetMaterialEquips_ByEquipId(sc.id, sc.num, true, nil, UPGRADE_MATERIAL_SEARCH_BAGTYPES)
      for j = 1, #costEquips do
        searchNum = searchNum + costEquips[j].num
      end
    else
      searchNum = Func_GetMaterial_SearchNum(sc.id)
    end
    if searchNum < sc.num then
      matEnough = false
    end
    if sc.id ~= 100 and searchNum < sc.num then
      if lackMats == nil then
        lackMats = {}
      end
      table.insert(lackMats, {
        id = sc.id,
        count = sc.num - searchNum
      })
    end
  end
  if lackMats and QuickBuyProxy.Instance:TryOpenView(lackMats) then
    return FunctionDialogEvent.EventResult_Type.Result_Close
  end
  if not matEnough then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  local hasRecover, tipEquips = FunctionItemFunc.RecoverEquips(costEquips)
  if hasRecover then
    return FunctionDialogEvent.EventResult_Type.Result_Wait
  end
  if #tipEquips > 0 then
    local confirmMsgParam = {}
    confirmMsgParam.id = 247
    confirmMsgParam.param = {
      tipEquips[1].equipInfo.refinelv
    }
    return FunctionDialogEvent.EventResult_Type.Result_Wait, confirmMsgParam
  end
  local nowEquiplv = itemData.equipInfo.equiplv
  if equiplv >= itemData.equipInfo.upgrade_MaxLv then
    local productid = upgradeData.Product
    local confirmMsgParam = {}
    confirmMsgParam.id = 25402
    confirmMsgParam.param = {
      Table_Item[productid].NameZh
    }
    return FunctionDialogEvent.EventResult_Type.Result_Wait, confirmMsgParam
  end
  local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
  if not itemData.equipInfo:CanUpgrade_ByClassDepth(classDepth, nowEquiplv + 1) then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_2
  end
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end
function FunctionDialogEvent.CanUpJobLv(param, npc)
  if MyselfProxy.Instance:HasMaxJobBreak() then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_2
  end
  local itemConfig = GameConfig.Peak.itemaddlevel
  local itemid, num = itemConfig[1].item, itemConfig[1].num
  local searchNum = BagProxy.Instance:GetItemNumByStaticID(itemid)
  if num > searchNum then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end
function FunctionDialogEvent.DoReplace(parama, npc)
  local itemData = parama.itemData
  if npc then
    npc:Client_PlayAction(FunctionDialogEvent.ReplaceAction, nil, false)
  end
  ServiceItemProxy.Instance:CallEquipExchangeItemCmd(itemData.id, SceneItem_pb.EEXCHANGETYPE_EXCHANGE)
end
function FunctionDialogEvent.DoUpgrade(parama, npc)
  local itemData = parama.itemData
  ServiceItemProxy.Instance:CallEquipExchangeItemCmd(itemData.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP)
end
function FunctionDialogEvent.DoUpJobLv(param, npc)
  local itemConfig = GameConfig.Peak.itemaddlevel
  local itemid, num = itemConfig[1].item, itemConfig[1].num
  helplog("Call-->AddJobLevelItemCmd", itemid, num)
  ServiceItemProxy.Instance:CallAddJobLevelItemCmd(itemid, num)
end
function FunctionDialogEvent.ConsumeDeadCoin(param, npc)
  if Game.Myself.data.userdata:Get(UDEnum.DEADCOIN) < 1 then
    return FunctionDialogEvent.EventResult_Type.Result_Fail_1
  end
  ServiceUserEventProxy.Instance:CallLevelupDeadUserEvent()
  local animParams = Asset_Role.GetPlayActionParams("use_skill2")
  animParams[7] = function()
    npc.assetRole:PlayAction_Simple(Asset_Role.ActionName.Idle)
  end
  npc.assetRole:PlayAction(animParams)
  return FunctionDialogEvent.EventResult_Type.Result_Succes
end
function FunctionDialogEvent:GetFuncByConfig(key, npc)
  return self.eventMap[key]
end
function FunctionDialogEvent.ShowUpgradeItemEvent(viewPreferb, param)
  local itemData = param.itemData
  if not itemData then
    return
  end
  local equipInfo = itemData.equipInfo
  local upgradeData = equipInfo and equipInfo.upgradeData
  if not upgradeData then
    return
  end
  local upgradeItem
  if equipInfo.equiplv < equipInfo.upgrade_MaxLv then
    upgradeItem = ItemData.new("Upgrade", itemData.staticData.id)
    upgradeItem.equipInfo.equiplv = equipInfo.equiplv + 1
  else
    local productid = upgradeData.Product
    if not productid then
      return
    end
    upgradeItem = ItemData.new("Upgrade", productid)
  end
  local mid = GameObjectUtil.Instance:DeepFind(viewPreferb, "Anchor_Middle")
  local tipRid = ResourcePathHelper.UICell("ItemTipComCell")
  local tipObj = Game.AssetManager_UI:CreateAsset(tipRid, mid)
  tempV3:Set(-300, 30, 0)
  tipObj.transform.localPosition = tempV3
  local nowTipCell = ItemTipComCell.new(tipObj)
  nowTipCell:UpdateTipButtons({})
  nowTipCell:SetData(itemData)
  nowTipCell:HideGetPath()
  nowTipCell:HidePreviewButton()
  local upRid = ResourcePathHelper.UICell("ItemTipUpgradeCell")
  local upObj = Game.AssetManager_UI:CreateAsset(upRid, mid)
  tempV3:Set(170, 30, 0)
  upObj.transform.localPosition = tempV3
  local upTipCell = ItemTipComCell.new(upObj)
  upTipCell:UpdateTipButtons({})
  upTipCell:SetData(upgradeItem)
  upTipCell:HideGetPath()
  upTipCell:HidePreviewButton()
  local hideFunc = function()
    GameObject.Destroy(tipObj)
    GameObject.Destroy(upObj)
    upTipCell:Exit()
    nowTipCell:Exit()
  end
  return hideFunc
end
function FunctionDialogEvent._SetEventDialogEvent(npcInfo, eventParam, ignoreConfirm)
  local optCfg, param = eventParam[1], eventParam[2]
  local result
  if optCfg.FuncType then
    local func = FunctionDialogEvent.Me():GetFuncByConfig(optCfg.FuncType)
    if func then
      local eventResult, confirmMsgParam = func(param, npcInfo)
      if not ignoreConfirm then
        if confirmMsgParam then
          local confirm_confirmFunc = function()
            FunctionDialogEvent._SetEventDialogEvent(npcInfo, eventParam, true)
          end
          MsgManager.ConfirmMsgByID(confirmMsgParam.id, confirm_confirmFunc, nil, nil, unpack(confirmMsgParam.param))
          return true
        end
        if eventResult == FunctionDialogEvent.EventResult_Type.Result_Wait then
          return true
        elseif eventResult == FunctionDialogEvent.EventResult_Type.Result_Close then
          return false
        end
      end
      result = optCfg[eventResult] or optCfg.Result1
    end
  else
    result = optCfg.Result1
  end
  if result then
    if result.NextDialog then
      FunctionDialogEvent.Me():SetEventDialog(result.NextDialog, param, npcInfo)
    elseif result.DialogEventType then
      FunctionDialogEvent.SetDialogEventEnter(result.DialogEventType, npcInfo)
      return true
    end
  end
end
function FunctionDialogEvent:SetEventDialog(dialogId, param, npcInfo)
  local viewdata = {viewname = "DialogView"}
  local dcfg = EventDialog[dialogId]
  if not dcfg then
    return
  end
  local text = dcfg.DialogText
  for key, func in pairs(self.paramaMap) do
    if string.find(text, key) then
      local replaceStr = func(param, npcInfo)
      text = string.gsub(text, key, replaceStr)
    end
  end
  viewdata.dialoglist = {text}
  local optionIds = dcfg.Option
  if optionIds then
    local addfunc = {}
    for i = 1, #optionIds do
      local optId = optionIds[i]
      local optCfg = EventDialogOption[optId]
      if optCfg then
        local func = {}
        func.NameZh = optCfg.Name
        func.event = FunctionDialogEvent._SetEventDialogEvent
        func.eventParam = {optCfg, param}
        table.insert(addfunc, func)
      end
    end
    viewdata.addfunc = addfunc
  end
  viewdata.npcinfo = npcInfo
  if dcfg.ShowEvent then
    viewdata.midShowFunc = self.showEventMap[dcfg.ShowEvent]
    viewdata.midShowFuncParam = param
  end
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end
function FunctionDialogEvent.SetDialogEventEnter(type, npcInfo)
  FunctionDialogEvent.Me().npcguid = npcInfo.data.id
  if type and Func_Type_Map[type] then
    Func_Type_Map[type](npcInfo)
  end
end
function FunctionDialogEvent._DoReplaceOptEvent(npcInfo, eventParam)
  local siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[1])
  if eventParam[2] and (not siteEquip or not siteEquip.equipInfo.equipData.SubstituteID) then
    siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[2])
  end
  local param = {itemData = siteEquip}
  if siteEquip then
    if siteEquip.equipInfo.equipData.SubstituteID then
      FunctionDialogEvent.Me():SetEventDialog(51, param, npcInfo)
    else
      FunctionDialogEvent.Me():SetEventDialog(52, param, npcInfo)
    end
  else
    FunctionDialogEvent.Me():SetEventDialog(2, param, npcInfo)
  end
end
function FunctionDialogEvent.SetEquipReplace(npcInfo)
  local replaceSites = {}
  local npcfunction = npcInfo.data.staticData.NpcFunction
  local replaceFunc = npcfunction and npcfunction[1]
  if not replaceFunc then
    return
  end
  local parts, partsStr = replaceFunc.param, ""
  if not parts then
    return
  end
  local addfunc = {}
  for i = 1, #parts do
    local part = parts[i]
    local partConfig = GameConfig.EquipParts[part]
    local event = {}
    event.NameZh = partConfig.name .. ZhString.FunctionDialogEvent_Replace
    event.event = FunctionDialogEvent._DoReplaceOptEvent
    event.eventParam = partConfig.site
    table.insert(addfunc, event)
    partsStr = partsStr .. partConfig.name
    if i < #parts then
      partsStr = partsStr .. "\227\128\129"
    end
  end
  local viewdata = {viewname = "DialogView", npcinfo = npcInfo}
  local dialogText = ""
  if #addfunc > 0 then
    dialogText = EventDialog[1].DialogText
  else
    dialogText = EventDialog[2].DialogText
  end
  dialogText = string.format(dialogText, partsStr)
  viewdata.dialoglist = {dialogText}
  viewdata.addfunc = addfunc
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end
function FunctionDialogEvent.HelpCheckCanUpGradeEquip(npcInfo, item)
  if not item or not npcInfo then
    return false
  end
  local equipInfo = item.equipInfo
  if not equipInfo.upgradeData then
    return false
  end
  if equipInfo.equiplv > equipInfo.upgrade_MaxLv then
    return false
  end
  if equipInfo.equiplv == equipInfo.upgrade_MaxLv and equipInfo.upgradeData.Product == nil then
    return false
  end
  return equipInfo.upgradeData.NpcId == npcInfo.data.staticData.id
end
function FunctionDialogEvent._DoEquipUpgradeOpt(npcInfo, eventParam)
  local npcData = npcInfo.data.staticData
  local haveUpgradeEquip = false
  local siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[1])
  if not FunctionDialogEvent.HelpCheckCanUpGradeEquip(npcInfo, siteEquip) and eventParam[2] then
    siteEquip = _BagProxy.roleEquip:GetEquipBySite(eventParam[2])
  end
  if siteEquip then
    local param = {itemData = siteEquip}
    if FunctionDialogEvent.HelpCheckCanUpGradeEquip(npcInfo, siteEquip) then
      FunctionDialogEvent.Me():SetEventDialog(61, param, npcInfo)
    else
      FunctionDialogEvent.Me():SetEventDialog(62, param, npcInfo)
    end
  else
    FunctionDialogEvent.Me():SetEventDialog(60, nil, npcInfo)
  end
end
function FunctionDialogEvent.SetEquipUpgrade(npcInfo)
  local npcfunction = npcInfo.data.staticData.NpcFunction
  local upgradeFunc = npcfunction and npcfunction[1]
  local parts = upgradeFunc.param
  if not parts then
    return
  end
  local addfunc = {}
  for i = 1, #parts do
    local part = parts[i]
    local partConfig = GameConfig.EquipParts[part]
    local event = {}
    event.NameZh = partConfig.name .. ZhString.FunctionDialogEvent_Upgrade
    event.event = FunctionDialogEvent._DoEquipUpgradeOpt
    event.eventParam = partConfig.site
    table.insert(addfunc, event)
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      EventDialog[3].DialogText
    },
    npcinfo = npcInfo,
    addfunc = addfunc
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end
function FunctionDialogEvent.UpJobLevel(npcInfo)
  local dialogId
  helplog("UpJobLevel", MyselfProxy.Instance:HasJobBreak())
  if MyselfProxy.Instance:HasJobBreak() then
    dialogId = 81
  else
    dialogId = 80
  end
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end
function FunctionDialogEvent.SetDialogGoddessOfferDead(npcInfo)
  local curDeadLv = Game.Myself.data.userdata:Get(UDEnum.DEADLV) or 0
  local dialogId = curDeadLv < GameConfig.Dead.max_deadlv and 90 or 95
  FunctionDialogEvent.Me():SetEventDialog(dialogId, nil, npcInfo)
end
