FunctionItemFunc = class("FunctionItemFunc")
ItemFuncState = {
  Active = 1,
  InActive = 2,
  Grey = 3
}
FunctionItemFunc_Source = {
  MainBag = 1,
  RoleEquipBag = 2,
  StorageBag = 4,
  CommonStorageBag = 8,
  TempBag = 16,
  BarrowBag = 32
}
local ItemFunction = GameConfig.ItemFunction
function FunctionItemFunc.Me()
  if nil == FunctionItemFunc.me then
    FunctionItemFunc.me = FunctionItemFunc.new()
  end
  return FunctionItemFunc.me
end
function FunctionItemFunc:ctor()
  self.funcMap = {}
  self.checkMap = {}
  self.funcMap.GetTask = FunctionItemFunc.GetQuestByItem
  self.funcMap.MakePic = FunctionItemFunc.MakePicEvt
  self.funcMap.DepositFashion = FunctionItemFunc.DepositFashionEvt
  self.funcMap.Dress = FunctionItemFunc.EquipEvt
  self.funcMap.Apply = FunctionItemFunc.ItemUseEvt
  self.funcMap.Shortcutkey = FunctionItemFunc.ShortcutkeyEvt
  self.funcMap.Sale = FunctionItemFunc.SaleEvt
  self.funcMap.Discharge = FunctionItemFunc.DischargeEvt
  self.funcMap.GetoutFashion = FunctionItemFunc.GetoutEvt
  self.funcMap.Combine = FunctionItemFunc.CombineEvt
  self.funcMap.CombineMultiple = FunctionItemFunc.CombineMultipleEvt
  self.funcMap.DepositRepository = FunctionItemFunc.DepositRepositoryEvt
  self.funcMap.WthdrawnRepository = FunctionItemFunc.WthdrawnRepositoryEvt
  self.funcMap.PersonalDepositRepository = FunctionItemFunc.PersonalDepositRepositoryEvt
  self.funcMap.PersonalWthdrawnRepository = FunctionItemFunc.PersonalWthdrawnRepositoryEvt
  self.funcMap.RemoveEquipCard = FunctionItemFunc.RemoveEquipCardEvt
  self.funcMap.Active = FunctionItemFunc.ActiveEvt
  self.funcMap.Inlay = FunctionItemFunc.InlayEvt
  self.funcMap.Pitch = FunctionItemFunc.PitchEvt
  self.funcMap.PickUpFromTempBag = FunctionItemFunc.PickUpFromTempBag
  self.funcMap.OpenBarrowBag = FunctionItemFunc.OpenBarrowBag
  self.funcMap.Adventure = FunctionItemFunc.Adventure
  self.funcMap.Hatch = FunctionItemFunc.Hatch
  self.funcMap.PutInBarrow = FunctionItemFunc.PutInBarrow
  self.funcMap.PutBackBarrow = FunctionItemFunc.PutBackBarrow
  self.funcMap.PutFood_Public = FunctionItemFunc.PutFood_Public
  self.funcMap.PutFood_Team = FunctionItemFunc.PutFood_Team
  self.funcMap.PutFood_Self = FunctionItemFunc.PutFood_Self
  self.funcMap.PutFood_Pet = FunctionItemFunc.PutFood_Pet
  self.funcMap.Open_Letter = FunctionItemFunc.Open_Letter
  self.funcMap.UnloadPetEquip = FunctionItemFunc.UnloadPetEquip
  self.funcMap.Open_MarriageManual = FunctionItemFunc.Open_MarriageManual
  self.funcMap.Open_MarriageCertificate = FunctionItemFunc.Open_MarriageCertificate
  self.funcMap.Send_WeddingDress = FunctionItemFunc.Send_WeddingDress
  self.funcMap.OpenRegistTicket = FunctionItemFunc.OpenRegistTicket
  self.funcMap.UnlockPetWork = FunctionItemFunc.UnlockPetWork
  self.checkMap.Inlay = FunctionItemFunc.CheckInlay
  self.checkMap.Combine = FunctionItemFunc.CheckCombine
  self.checkMap.MakePic = FunctionItemFunc.CheckCombine
  self.checkMap.CombineMultiple = FunctionItemFunc.CheckCombineMultiple
  self.checkMap.DepositFashion = FunctionItemFunc.CheckEquip
  self.checkMap.Dress = FunctionItemFunc.CheckEquip
  self.checkMap.Apply = FunctionItemFunc.CheckApply
  self.checkMap.GotoUse = FunctionItemFunc.CheckGotoUse
  self.checkMap.Send_WeddingDress = FunctionItemFunc.CheckSend_WeddingDress
  self.checkMap.PutFood = FunctionItemFunc.CheckPutFood
  self.checkMap.PutFood_Pet = FunctionItemFunc.CheckPutFoodPet
end
function FunctionItemFunc:GetItemDefaultFunc(data, source, dest_isfashion)
  local funcKey = ""
  if data and data.staticData then
    if source == FunctionItemFunc_Source.RoleEquipBag then
      return self.funcMap.Discharge
    else
      local fids = FunctionItemFunc.GetItemFuncIds(data.staticData.id, source, dest_isfashion)
      if fids then
        for i = 1, #fids do
          local default = ItemFunction[fids[i]]
          local ftype = default and default.type
          if default and FunctionItemFunc.Me():CheckFuncState(ftype, data) == ItemFuncState.Active then
            return self.funcMap[ftype], fids[i]
          end
        end
      end
    end
  end
end
local FashionEquipMap = {
  [6] = 5,
  [8] = 7
}
local EquipFashionMap = {
  [5] = 6,
  [7] = 8
}
function FunctionItemFunc.GetItemFuncIds(itemId, surtype, dest_isfashion)
  local Function
  if GameConfig.SpecialItemFunction and GameConfig.SpecialItemFunction[itemId] then
    Function = GameConfig.SpecialItemFunction[itemId]
  end
  if Function == nil then
    local sData = Table_Item[itemId]
    if sData == nil then
      return
    end
    local typeConfig = Table_ItemType[sData.Type]
    if typeConfig == nil then
      return
    end
    Function = typeConfig.Function
  end
  if Function == nil then
    return
  end
  surtype = surtype or FunctionItemFunc_Source.MainBag
  local result, itemFunction = {}, nil
  for i = 1, #Function do
    local fid = Function[i]
    itemFunction = ItemFunction[fid]
    if itemFunction and itemFunction.showtype & surtype > 0 then
      if dest_isfashion then
        if FashionEquipMap[fid] then
          fid = FashionEquipMap[fid]
        end
      elseif EquipFashionMap[fid] then
        fid = EquipFashionMap[fid]
      end
      table.insert(result, fid)
    end
  end
  return result
end
function FunctionItemFunc:GetFuncById(id)
  if id then
    local config = GameConfig.ItemFunction[id]
    if config then
      return self:GetFunc(config.type)
    end
  end
  return nil
end
function FunctionItemFunc:GetFunc(key)
  return self.funcMap[key]
end
function FunctionItemFunc.GetQuestByItem(data)
  local canGo = FunctionItemFunc.bGetTaskItemType(data.staticData)
  if canGo then
    return
  end
  local itemData = BagProxy.Instance:GetItemByStaticID(data.staticData.id)
  if itemData then
    FunctionItemFunc.TryUseItem(itemData)
  end
end
function FunctionItemFunc.bGetTaskItemType(staticData)
  if not Table_UseItem[staticData.id] or not Table_UseItem[staticData.id].UseEffect then
    return false
  end
  local questID = Table_UseItem[staticData.id].UseEffect.id
  if questID then
    local bGet = QuestProxy.Instance:checkQuestHasAccept(questID)
    if bGet then
      return true
    end
  end
  return false
end
function FunctionItemFunc.MakePicEvt(data)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "PicTipPopUp",
    data = data
  })
end
function FunctionItemFunc.DepositFashionEvt(data)
  local limitlv = data.staticData.Level
  if limitlv and limitlv > 0 then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if limitlv > mylv then
      MsgManager.ShowMsgByIDTable(40, limitlv)
      return
    end
  end
  ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTFASHION, nil, data.id)
  GameFacade.Instance:sendNotification(ItemEvent.Equip)
end
function FunctionItemFunc.CombineEvt(data)
  if data ~= nil and data.staticData ~= nil then
    local composeid = data.staticData.ComposeID
    if composeid ~= nil then
      local composeData = Table_Compose[composeid]
      if composeData then
        local canCompose = true
        for i = 1, #composeData.BeCostItem do
          local v = composeData.BeCostItem[i]
          local hasnum = BagProxy.Instance:GetItemNumByStaticID(v.id)
          if hasnum < v.num then
            canCompose = false
            break
          end
        end
        if canCompose then
          ServiceItemProxy.Instance:CallProduce(nil, composeid)
        else
          MsgManager.ShowMsgByIDTable(3004)
        end
      end
    end
  end
end
function FunctionItemFunc._GetCombineMaxNum(itemid)
  if itemid == nil then
    return 0
  end
  local cid = Table_Item[itemid].ComposeID
  if cid == nil then
    return 0
  end
  local maxNum
  local beCostItem = Table_Compose[cid].BeCostItem
  local _BagProxy = BagProxy.Instance
  local hasleft = false
  for i = 1, #beCostItem do
    local cost = beCostItem[i]
    if cost.id ~= 100 then
      local num = _BagProxy:GetItemNumByStaticID(cost.id)
      local cNum = math.floor(num / cost.num)
      maxNum = maxNum == nil and cNum or math.min(cNum, maxNum)
      if hasleft == false and 0 < num % cost.num then
        hasleft = true
      end
    end
  end
  return maxNum, hasleft
end
function FunctionItemFunc.CombineMultipleEvt(data)
  if data ~= nil and data.staticData ~= nil then
    local composeid = data.staticData.ComposeID
    local maxNum = FunctionItemFunc._GetCombineMaxNum(data.staticData.id)
    if maxNum > 0 then
      ServiceItemProxy.Instance:CallProduce(nil, composeid, nil, nil, maxNum)
    else
      MsgManager.ShowMsgByIDTable(3004)
    end
  end
end
function FunctionItemFunc.EquipEvt(data)
  local site = BagProxy.Instance:GetToEquipPos()
  FunctionItemFunc.CallEquipEvt(data, site)
end
function FunctionItemFunc.ActiveEvt(data)
  FunctionItemFunc.ItemUseEvt(data)
end
function FunctionItemFunc.ItemUseEvt(data, count)
  FunctionSecurity.Me():UseItem(function()
    FunctionItemFunc.TryUseItem(data, nil, count)
  end, {itemData = data})
end
function FunctionItemFunc.ShortcutkeyEvt(data)
end
function FunctionItemFunc.SaleEvt(data)
  AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.Coin))
  ServiceItemProxy.Instance:CallSellItem(data.id, data.num)
end
function FunctionItemFunc.DischargeEvt(data)
  if not data or not data.staticData then
    return
  end
  ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFF, nil, data.id)
end
function FunctionItemFunc.GetoutEvt(data)
  if not data or not data.staticData then
    return
  end
  ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFFASHION, nil, data.id)
end
function FunctionItemFunc.DepositRepositoryEvt(data, count)
  if data then
    if not data:CanStorage(BagProxy.BagType.Storage) then
      MsgManager.ShowMsgByID(38)
      return
    end
    RepositoryViewProxy.Instance.curOperation = RepositoryViewProxy.Operation.DepositRepositoryEvt
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.WthdrawnRepositoryEvt(data, count)
  if data then
    if RepositoryViewProxy.Instance:GetViewTab() == RepositoryView.Tab.CommonTab then
      local itemdata = BagProxy.Instance:GetItemByGuid(data.id, BagProxy.BagType.Storage)
      if itemdata ~= nil then
        local roleLevel = MyselfProxy.Instance:RoleLevel()
        if itemdata.petEggInfo ~= nil and roleLevel < itemdata.petEggInfo.lv then
          MsgManager.ConfirmMsgByID(8024, function()
            RepositoryViewProxy.Instance.curOperation = RepositoryViewProxy.Operation.WthdrawnRepositoryEvt
            ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFSTORE, nil, data.id, nil, count)
          end, nil, nil, roleLevel)
          return
        end
      end
    end
    RepositoryViewProxy.Instance.curOperation = RepositoryViewProxy.Operation.WthdrawnRepositoryEvt
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.PersonalDepositRepositoryEvt(data, count)
  if data then
    if not data:CanStorage(BagProxy.BagType.PersonalStorage) then
      MsgManager.ShowMsgByID(38)
      return
    end
    RepositoryViewProxy.Instance.curOperation = RepositoryViewProxy.Operation.DepositRepositoryEvt
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTPSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.PersonalWthdrawnRepositoryEvt(data, count)
  if data then
    RepositoryViewProxy.Instance.curOperation = RepositoryViewProxy.Operation.WthdrawnRepositoryEvt
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFPSTORE, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.RemoveEquipCardEvt(data)
  if data and data.equipedCardInfo then
    for k, v in pairs(data.equipedCardInfo) do
      ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPOFF, v.guid, data.id)
    end
  end
end
function FunctionItemFunc.InlayEvt(data)
  if data then
    if data.cardInfo then
      local filterDatas = BagProxy.Instance:FilterEquipedCardItems(data.cardInfo.Position)
      if #filterDatas > 0 then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.UseCardPopUp,
          viewdata = {carddata = data, equipdatas = filterDatas}
        })
      else
        MsgManager.ShowMsgByIDTable(510)
      end
    else
      local cardSlotNum = data.cardSlotNum
      local equipCards = data.equipedCardInfo or {}
      if cardSlotNum > 0 then
        local filterCards = {}
        local pos = ItemUtil.getEquipPos(data.staticData.id)
        local items = BagProxy.Instance.bagData:GetItems()
        for i = 1, #items do
          if items[i].cardInfo and items[i].cardInfo.Position == pos then
            table.insert(filterCards, items[i])
          end
        end
        if #filterCards > 0 then
          GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
            viewname = "SetCardPopUp",
            viewdata = {itemdata = data, carddatas = filterCards}
          })
        else
          MsgManager.ShowMsgByIDTable(512)
        end
      end
    end
  end
end
function FunctionItemFunc.PitchEvt(data)
  local viewdata = {
    view = PanelConfig.ShopMallExchangeView,
    viewdata = {
      exchange = ShopMallExchangeEnum.Sell
    }
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, viewdata)
end
function FunctionItemFunc.CallEquipEvt(data, site)
  if data and (data.equipInfo or data:IsMount()) then
    local poses = data.equipInfo:GetEquipSite()
    if poses then
      local posIsRight = false
      for _, sc in pairs(poses) do
        if sc == site then
          posIsRight = true
          break
        end
      end
      if not posIsRight then
        local nullPos, lowPos, lowEquipScore
        for _, pos in pairs(poses) do
          local equip = BagProxy.Instance.roleEquip:GetEquipBySite(pos)
          if not equip then
            nullPos = pos
            break
          else
            local score = equip.equipInfo:GetReplaceValues()
            if not lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            elseif score < lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            end
          end
        end
        site = nullPos or lowPos
      end
    end
    local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local isValid = data.equipInfo:CanUseByProfess(myPro)
    if not isValid then
      MsgManager.ShowMsgByIDTable(18)
      return
    end
    local limitlv = data.staticData.Level
    if limitlv and limitlv > 0 then
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      if limitlv > mylv then
        MsgManager.ShowMsgByIDTable(40, limitlv)
        return
      end
    end
    local transfer = data.equipInfo:CanStrength() and 0 >= data.equipInfo.strengthlv
    if transfer and type(site) == "number" then
      local roleEquipData = BagProxy.Instance.roleEquip:GetEquipBySite(site)
      transfer = roleEquipData and 0 < roleEquipData.equipInfo.strengthlv
    end
    if transfer then
      MsgManager.ConfirmMsgByID(1704, function()
        ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON, site, data.id, true)
      end, function()
        ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON, site, data.id, false)
      end, nil)
    else
      ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_ON, site, data.id, false)
    end
    GameFacade.Instance:sendNotification(ItemEvent.Equip)
  end
end
local Adventure_Card_MenuId = 29
function FunctionItemFunc.TryUseItem(data, target, count)
  local sdata = data and data.staticData
  local myPro = MyselfProxy.Instance:GetMyProfession()
  local bUnlock = false
  local classTab = Table_UseItem[sdata.id] and Table_UseItem[sdata.id].Class
  if nil ~= classTab and #classTab > 0 then
    for k, v in pairs(classTab) do
      if myPro == v then
        bUnlock = true
      end
    end
  else
    bUnlock = true
  end
  if not bUnlock then
    MsgManager.ShowMsgByID(18)
    return
  end
  if 0 < data.cdTime then
    return
  end
  if sdata.Level and 0 < sdata.Level then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    if mylv < sdata.Level then
      MsgManager.ShowMsgByIDTable(40, sdata.Level)
      return
    end
  end
  if (sdata.id == 500503 or sdata.id == 500516) and not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  if data:IsMarryInviteLetter() then
    local nowZoneId = MyselfProxy.Instance:GetZoneId()
    if nowZoneId ~= data.weddingData.zoneid then
      MsgManager.ShowMsgByID(9619)
      return
    end
  end
  if sdata.id == 5542 then
    local Unlock = PetWorkSpaceProxy.Instance:IsFuncUnlock()
    if not Unlock then
      ServiceScenePetProxy.Instance:CallUnlockPetWorkManualPetCmd()
      return
    end
  end
  if sdata.UseMode ~= nil and sdata.Type ~= 75 then
    if sdata.id == 5501 then
      local myClass = MyselfProxy.Instance:GetMyProfession()
      local depth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
      if myClass == 143 or myClass == 144 then
        helplog("\233\152\191\232\144\168\231\165\158\231\162\145 \194\160\232\182\133\229\136\157\229\164\132\231\144\134")
      elseif depth <= 1 then
        MsgManager.ShowMsgByID(25438)
        return
      end
    end
    FuncShortCutFunc.Me():CallByID(sdata.UseMode, data.id)
    return
  end
  if not ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(sdata.Type) then
    return
  end
  if data:IsLimitUse() then
    return
  end
  local useItem = Table_UseItem[sdata.id]
  if useItem then
    local uselimit = useItem.UseLimit
    if uselimit then
      if 0 < uselimit & 1 and Game.MapManager:IsPVPMode_GVGDetailed() then
        MsgManager.ShowMsgByIDTable(2213)
        return
      end
      if 0 < uselimit & 4 and not Game.MapManager:IsPVPMode() then
        MsgManager.ShowMsgByIDTable(3795)
        return
      end
      if 0 < uselimit & 16 and Game.MapManager:IsPVPMode_MvpFight() then
        MsgManager.ShowMsgByIDTable(3795)
        return
      end
      if 0 < uselimit & 64 and Game.MapManager:IsPVPMode_TeamPws() then
        MsgManager.ShowMsgByIDTable(3795)
        return
      end
      if 0 < uselimit & 256 and not Game.MapManager:IsPVEMode_ExpRaid() then
        MsgManager.ShowMsgByIDTable(3795)
        return
      end
    end
    local useEffect = useItem.UseEffect
    helplog("useEffect.type is", useEffect.type)
    if useEffect.type == "equip" then
      if useEffect.refine ~= nil and useEffect.pos ~= nil then
        local euqipData = BagProxy.Instance.roleEquip:GetEquipBySite(useEffect.pos)
        if euqipData == nil then
          MsgManager.ShowMsgByID(8001)
          return
        end
        local refinelv = useEffect.refinelv
        if refinelv < euqipData.equipInfo.refinelv then
          MsgManager.ShowMsgByID(1358)
          return
        end
        local maxRefinelv = BlackSmithProxy.Instance:MaxRefineLevelByData(euqipData.staticData)
        if maxRefinelv < useEffect.refinelv then
          MsgManager.ShowMsgByID(1358)
          return
        end
        if type(useItem.UsingSys) == "number" then
          MsgManager.ConfirmMsgByID(useItem.UsingSys, function()
            FunctionItemFunc.DoUseItem(data, target, count)
          end, nil, nil, euqipData:GetName(), refinelv)
        else
          FunctionItemFunc.DoUseItem(data, target, count)
        end
        return
      end
    elseif useEffect.type == "manual" then
      if useEffect.method == "card" then
        if not FunctionUnLockFunc.Me():CheckCanOpen(Adventure_Card_MenuId) then
          MsgManager.FloatMsgTableParam(nil, ZhString.FunctionItemFunc_UseFail)
          return
        end
        local quality = useEffect.quality
        local cardtype = useEffect.cardtype
        local hasUnlockCard = false
        for i = 1, #quality do
          local sq = quality[i]
          for j = 1, #cardtype do
            local ct = cardtype[j]
            if AdventureDataProxy.Instance:hasUnlockCard(sq, ct) == true then
              hasUnlockCard = true
              break
            end
          end
        end
        if not hasUnlockCard then
          if useItem.UsingSys then
            local apology = useEffect.apology
            MsgManager.ConfirmMsgByID(useItem.UsingSys, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end, nil, nil, apology)
          else
            FunctionItemFunc.DoUseItem(data, target, count)
          end
        else
          FunctionItemFunc.DoUseItem(data, target, count)
        end
        return
      end
    elseif useEffect.type == "lottery" then
      if useEffect.method == "bag" then
        local c = LotteryProxy.Instance:GetLotteryBuyCnt()
        count = count or 1
        ServiceItemProxy.Instance:CallLotteryCmd(nil, nil, nil, true, nil, nil, LotteryType.Head, count, nil, nil, data.id, c)
      elseif type(useItem.UsingSys) == "number" then
        local viewdata = {
          viewname = "UseLotteryItemPopUp",
          itemdata = data,
          count = count,
          sysMsgId = useItem.UsingSys,
          rarity = useEffect.rarity
        }
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
      else
        FunctionItemFunc.DoUseItem(data, target, count)
      end
      return
    elseif useEffect.type == "redeemCode" then
      FunctionSecurity.Me():RedeemCode(function()
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.RedeemCodeView,
          viewdata = {
            id = sdata.id
          }
        })
      end)
      return
    elseif useEffect.type == "marriageproposal" then
      if target ~= nil and FriendProxy.Instance:IsInBlacklist(target.id) then
        MsgManager.ShowMsgByIDTable(464)
        return
      end
    elseif useEffect.type == "tower" then
      if not FunctionUnLockFunc.Me():CheckCanOpen(26) then
        MsgManager.ShowMsgByID(56)
        return false
      end
      local sysId = useItem.UsingSys
      local min, max = useEffect.min, useEffect.max
      local effectlayers = ""
      local endlessTowerProxy = EndlessTowerProxy.Instance
      local allWeekChallenged = true
      local allHistoryNoChallenged = true
      for i = min, max do
        local hasChallenged = endlessTowerProxy:IsCurLayerHasChallenged(i)
        if hasChallenged then
          allHistoryNoChallenged = false
          local mylayerInfo = endlessTowerProxy:GetMyLayersInfo(i)
          if mylayerInfo == nil or not mylayerInfo.rewarded then
            allWeekChallenged = false
            if effectlayers == "" then
              effectlayers = tostring(i)
            else
              effectlayers = effectlayers .. "," .. i
            end
          end
        end
      end
      if allHistoryNoChallenged then
        MsgManager.ShowMsgByID(59)
        return false
      end
      if allWeekChallenged then
        MsgManager.ShowMsgByID(57)
        return false
      end
      MsgManager.ConfirmMsgByID(65, function()
        ServiceItemProxy.Instance:CallItemUse(data, nil, count)
      end, nil, nil, effectlayers)
      return true
    elseif useEffect.type == "loveletter" then
      local pTarget = Game.Myself:GetLockTarget()
      local pGuild
      if pTarget then
        pGuild = pTarget.data.id
      end
      StarProxy.Instance:CacheData(data, pTarget)
      ServiceNUserProxy.Instance:CallCheckRelationUserCmd(pGuild, SocialManager.PbRelation.Friend)
      return
    elseif useEffect.type == "addhandnpc" then
      local isholding = Game.Myself:IsPlayingHoldAction() or Game.Myself:IsPlayingHoldMoveAction()
      helplog("isholding:", isholding)
      if isholding then
        MsgManager.ShowMsgByID(933)
        return
      end
      FunctionItemFunc.DoUseItem(data, target, count)
      return
    elseif useEffect.type == "addresist" then
      local confirmMsg = useItem.UsingSys
      local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
      if dailyData then
        local pcount = dailyData.param1
        local pcurCount = dailyData.param2
        if pcount and pcurCount then
          local leftCount = pcount - pcurCount
          if leftCount >= 6 then
            MsgManager.ShowMsgByIDTable(26017)
            return
          elseif leftCount > 4 then
            MsgManager.ConfirmMsgByID(confirmMsg, function()
              FunctionItemFunc.DoUseItem(data, target, count)
            end, nil, nil, leftCount)
            return
          end
        end
      end
      FunctionItemFunc.DoUseItem(data, target, count)
      return
    end
    if type(useItem.UsingSys) == "number" then
      MsgManager.ConfirmMsgByID(useItem.UsingSys, function()
        FunctionItemFunc.DoUseItem(data, target, count)
      end, nil, nil)
    else
      FunctionItemFunc.DoUseItem(data, target, count)
    end
  else
    errorLog(string.format("Item:%s not Config in Table_UseItem", sdata.id))
    ServiceItemProxy.Instance:CallItemUse(data)
  end
end
function FunctionItemFunc.DoUseItem(data, target, count)
  local sdata = data.staticData
  local realTarget = target or Game.Myself:GetLockTarget()
  local itemTarget = data.staticData.ItemTarget
  local st = itemTarget.type
  local needShowTipBord = false
  if st ~= nil then
    if realTarget == nil then
      needShowTipBord = true
    else
      local creatureType = realTarget:GetCreatureType()
      if Creature_Type.Player == creatureType and not data:CanUseForTarget(ItemTarget_Type.Player) then
        needShowTipBord = true
      elseif Creature_Type.Npc == creatureType then
        if realTarget.data:IsNpc() and not data:CanUseForTarget(ItemTarget_Type.Npc) then
          needShowTipBord = true
        elseif realTarget.data:IsMonster() and not data:CanUseForTarget(ItemTarget_Type.Monster) then
          needShowTipBord = true
        end
      end
    end
  end
  if needShowTipBord then
    local useTipData = {}
    useTipData.type = QuickUseProxy.Type.Item
    useTipData.data = data
    GameFacade.Instance:sendNotification(ItemEvent.ItemUseTip, useTipData)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChitchatLayer)
    return false
  end
  local inRange = true
  if itemTarget.range and realTarget ~= nil then
    local myPos, targetPos = Game.Myself:GetPosition(), realTarget:GetPosition()
    inRange = LuaVector3.Distance(myPos, targetPos) <= itemTarget.range
  end
  if not inRange then
    Game.Myself:Client_AccessTarget(realTarget, data, nil, AccessCustomType.UseItem, itemTarget.range)
    return false
  end
  if isCatchNpc and realTarget then
    Game.Myself.assetRole:RotateTo(realTarget:GetPosition())
    Game.Myself:Client_PlayAction("use_magic", nil, false)
  end
  local useItem = Table_UseItem[sdata.id]
  if useItem and useItem.UseEffect then
    if useItem.UseInterval and data.CanIntervalUse and not data:CanIntervalUse() then
      MsgManager.ShowMsgByID(27030)
      return
    end
    local useEffectType = useItem.UseEffect.type
    if useEffectType == "client_useskill" then
      if sdata.id == 50001 then
        FunctionSystem.WeakInterruptMyself()
        FunctionSystem.InterruptMyselfAI()
      end
      FunctionSkill.Me():TryUseSkill(useItem.UseEffect.id, realTarget, true)
      GameFacade.Instance:sendNotification(ItemEvent.ItemUse, useItem)
      return true
    elseif useEffectType == "catchpet" then
      local npcids = useItem.UseEffect.npcid
      local npcIsRight = false
      if realTarget then
        for i = 1, #npcids do
          if npcids[i] == realTarget.data.staticData.id then
            npcIsRight = true
            break
          end
        end
      end
      if not npcIsRight then
        MsgManager.ShowMsgByID(711)
        return false
      end
      local targetId = realTarget and realTarget.data.id
      ServiceItemProxy.Instance:CallItemUse(data, targetId, count)
      return true
    elseif useEffectType == "settowermaxlayer" then
      if not FunctionUnLockFunc.Me():CheckCanOpen(26) then
        MsgManager.ShowMsgByID(3400)
        return false
      end
      MsgManager.ConfirmMsgByID(3403, function()
        ServiceItemProxy.Instance:CallItemUse(data, nil, count)
      end, nil, nil, data:GetName())
      return true
    elseif useEffectType == "random_effect" then
      local mySceneUI = Game.Myself:GetSceneUI()
      if not mySceneUI then
        LogUtility.Warning("Cannot find SceneUI of myself when throwing the dice!!")
        return false
      end
      local result = Game.Myself.data:GetRandom() % 6 + 1
      if result > 6 then
        result = 6
      elseif result < 1 then
        result = 1
      end
      mySceneUI.roleTopUI:PlayTopSpine(ResourcePathHelper.Emoji("Emoji_dice"), "animation" .. result, 1, 2, Game.Myself)
    end
  end
  local targetId = realTarget and realTarget.data.id
  ServiceItemProxy.Instance:CallItemUse(data, targetId, count)
  GameFacade.Instance:sendNotification(ItemEvent.ItemUse, useItem)
  return true
end
function FunctionItemFunc.PickUpFromTempBag(data)
  if data and BagProxy.Instance:CheckItemCanPutIn(nil, data.staticData.id, nil, true) then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFTEMP, nil, data.id)
  end
end
function FunctionItemFunc.OpenBarrowBag(data)
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if not data.equipInfo:CanUseByProfess(myPro) then
    return
  end
  GameFacade.Instance:sendNotification(PackageEvent.OpenBarrowBag)
end
function FunctionItemFunc.PutInBarrow(data, count)
  if not data:CanStorage(BagProxy.BagType.Barrow) then
    local sBagType = ZhString.ItemTip_BarrowStorage
    MsgManager.ShowMsgByIDTable(3807, sBagType)
    return
  end
  if count == 0 or count == nil then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTBARROW, nil, data.id, nil, data.num)
  else
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_PUTBARROW, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.PutBackBarrow(data, count)
  if count == 0 or count == nil then
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFBARROW, nil, data.id, nil, data.num)
  else
    ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_OFFBARROW, nil, data.id, nil, count)
  end
end
function FunctionItemFunc.Adventure(data)
  FunctionItemFunc.DoUseItem(data)
end
function FunctionItemFunc.PutFood_Public(data, count)
  ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_ALL, count, false)
end
function FunctionItemFunc.PutFood_Team(data, count)
  ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_TEAM, count, false)
end
function FunctionItemFunc.PutFood_Self(data, count)
  local foodList = FoodProxy.Instance:GetEatFoods()
  local currentEatFoodCount = #foodList
  local overrideNotice = LocalSaveProxy.Instance:GetFoodBuffOverrideNoticeShow()
  local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
  local tasteLvInfo = Table_TasterLevel[level]
  local foodMaxCount = 3
  if tasteLvInfo then
    foodMaxCount = tasteLvInfo.AddBuffs
  end
  local item = BagProxy.Instance:GetItemByGuid(data.id)
  local itemId = item.staticData.id
  if overrideNotice and foodMaxCount < currentEatFoodCount + count and itemId ~= 551019 then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "FoodOverridePopView",
      foodItemId = itemId,
      foodGuid = data.id,
      foodCount = count
    })
  else
    ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_SELF, count, false)
  end
end
function FunctionItemFunc.PutFood_Pet(data, count)
  ServiceSceneFoodProxy.Instance:CallPutFood(data.id, SceneFood_pb.EEATPOWR_SELF, count, true)
end
function FunctionItemFunc.Hatch(data)
  local petInfoData = PetProxy.Instance:GetMyPetInfoData()
  if petInfoData ~= nil then
    MsgManager.ShowMsgByIDTable(9003)
    return
  end
  local eggInfo = data.petEggInfo
  if eggInfo ~= nil and eggInfo.name ~= "" then
    ServiceScenePetProxy.Instance:CallEggHatchPetCmd(nil, data.id)
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PetMakeNamePopUp,
      viewdata = {etype = 1, item = data}
    })
  end
end
function FunctionItemFunc.Open_Letter(data)
  if data:IsLoveLetter() then
    local panel = StarProxy.Instance:GetPanelConfig(data.loveLetter.type)
    if panel ~= nil then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = panel,
        viewdata = data.loveLetter
      })
    end
  end
end
function FunctionItemFunc.Open_MarriageManual(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WeddingManualMainView,
    viewdata = data
  })
end
function FunctionItemFunc.Open_MarriageCertificate(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MarriageCertificate,
    viewdata = data
  })
end
function FunctionItemFunc.UnloadPetEquip(data)
  ServiceScenePetProxy.super.CallEquipOperPetCmd(self, ScenePet_pb.EPETEQUIPOPER_OFF, petid, guid)
end
function FunctionItemFunc.Send_WeddingDress(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WeddingDressSendView,
    viewdata = data.id
  })
end
function FunctionItemFunc.OpenRegistTicket(data)
  local codeData = data.CodeData
  local staticData = data.staticData
  if not staticData then
    helplog("\230\156\141\229\138\161\229\153\168\229\143\145\230\157\165\231\154\132\230\149\176\230\141\174\230\152\175 null")
    return
  end
  local id = staticData.id
  local useData = Table_UseItem[id]
  if not useData then
    helplog("Table_UseItem \232\161\168\233\135\140\230\178\161\233\133\141 \232\175\183\231\173\150\229\136\146\230\163\128\230\159\165")
    return
  end
  local startTime = useData.UseStartTime
  local endTime = useData.UseEndTime
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = startTime:match(p)
  local startTs = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  year, month, day, hour, min, sec = endTime:match(p)
  local endTs = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  local server = ServerTime.CurServerTime() / 1000
  helplog("startTime:", startTime, "endTime:", endTime)
  helplog("currentTime:", os.date("%Y-%m-%d %H:%M:%S", server))
  if startTs > server or endTs < server then
    MsgManager.ShowMsgByIDTable(25316)
    return
  end
  if codeData and codeData.code and codeData.code ~= "" then
    local functionSdk = FunctionLogin.Me():getFunctionSdk()
    local url = ""
    if functionSdk and functionSdk:getToken() then
      url = string.format(ZhString.KFCShareURL, Game.Myself.data.id, codeData.code, functionSdk:getToken())
    else
      url = ZhString.KFCShareURL_BeiFen
    end
    if ApplicationInfo.IsWindows() then
      Application.OpenURL(url)
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WebviewPanel,
        viewdata = {directurl = url}
      })
    end
    helplog("kfc url:" .. url)
  else
    ItemUtil.SetUseCodeCmd(data)
    ServiceItemProxy.Instance:CallUseCodItemCmd(data.id)
  end
end
function FunctionItemFunc.UnlockPetWork(data)
  ServiceScenePetProxy.Instance:CallUnlockPetWorkManualPetCmd()
end
function FunctionItemFunc.RecoverEquips(equipItems, confirmCall, cancelCall)
  if equipItems == nil then
    return false, _EmptyTable
  end
  local equipRecoverProxy = EquipRecoverProxy.Instance
  local recoverNames, recoverCost = "", 0
  local tipEquips = {}
  local rv_Items = {}
  for i = 1, #equipItems do
    local equipItem = equipItems[i]
    if equipItem.equipInfo.refinelv >= GameConfig.Item.material_max_refine then
      table.insert(tipEquips, equipItem)
    end
    local sCost = equipRecoverProxy:GetRecoverCost(equipItem, true, true, true, true, true)
    if sCost > 0 then
      recoverCost = recoverCost + sCost
      recoverNames = recoverNames .. " " .. equipItem:GetName()
      table.insert(rv_Items, equipItem)
    end
  end
  if #rv_Items > 0 then
    local confirmHandler = function()
      local myRob = MyselfProxy.Instance:GetROB()
      if myRob < recoverCost then
        MsgManager.ShowMsgByIDTable(1)
        return
      end
      for i = 1, #rv_Items do
        local item = rv_Items[i]
        local cardids = {}
        local equipedCards = item.equipedCardInfo
        if equipedCards then
          for j = 1, item.cardSlotNum do
            if equipedCards[j] then
              table.insert(cardids, equipedCards[j].id)
            end
          end
        end
        local equipInfo = item.equipInfo
        local hasstrength = equipInfo.strengthlv > 0
        local hasstrength2 = 0 < equipInfo.strengthlv2
        local hasenchant = item.enchantInfo and item.enchantInfo:HasAttri() or false
        local hasupgrade = 0 < equipInfo.equiplv
        ServiceItemProxy.Instance:CallRestoreEquipItemCmd(item.id, hasstrength, cardids, hasenchant, hasupgrade, hasstrength2)
        if confirmCall then
          confirmCall()
        end
      end
    end
    MsgManager.DontAgainConfirmMsgByID(246, confirmHandler, function()
      if cancelCall then
        cancelCall()
      end
    end, nil, recoverNames, recoverCost)
    return true, tipEquips
  end
  return false, tipEquips
end
function FunctionItemFunc:CheckFuncState(key, itemdata)
  if not key then
    return
  end
  if self.checkMap[key] then
    return self.checkMap[key](itemdata)
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckApply(itemdata)
  local sData = itemdata and itemdata.staticData
  if sData then
    local typeData = Table_ItemType[sData.Type]
    if typeData and typeData.UseNumber then
      return ItemFuncState.Active
    end
    local access = GainWayTipProxy.Instance:GetItemAccessByItemId(sData.id)
    if access ~= nil then
      return ItemFuncState.InActive
    end
    if sData.UseMode or Table_UseItem[sData.id] then
      return ItemFuncState.Active
    end
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckEquip(itemdata)
  if itemdata and itemdata:CanEquip() then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckInlay(itemdata)
  if itemdata.cardInfo ~= nil then
    return ItemFuncState.Active
  end
  if itemdata and itemdata.cardSlotNum and itemdata.cardSlotNum > 0 then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckCombine(itemdata)
  local combineid = itemdata and itemdata.staticData.ComposeID
  if combineid and combineid ~= nil and Table_Compose[combineid] then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckCombineMultiple(itemdata)
  local combineid = itemdata and itemdata.staticData.ComposeID
  if combineid then
    local combineNum = FunctionItemFunc._GetCombineMaxNum(itemdata.staticData.id)
    local name = ""
    for k, v in pairs(ItemFunction) do
      if v.type == "CombineMultiple" then
        name = v.name
        break
      end
    end
    if combineNum and combineNum > 1 then
      return ItemFuncState.Active, string.format(name, combineNum)
    end
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckGotoUse(itemdata)
  local access = GainWayTipProxy.Instance:GetItemAccessByItemId(itemdata.staticData.id)
  if access ~= nil then
    return ItemFuncState.Active
  end
  return ItemFuncState.InActive
end
function FunctionItemFunc.CheckSend_WeddingDress(itemdata)
  if itemdata.sender_charid ~= nil then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckPutFoodPet(itemdata)
  local pet = PetProxy.Instance:GetMySceneNpet()
  if pet == nil then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
function FunctionItemFunc.CheckPutFood(itemData)
  if Game.MapManager:IsPVPMode_TeamPws() then
    return ItemFuncState.InActive
  end
  return ItemFuncState.Active
end
