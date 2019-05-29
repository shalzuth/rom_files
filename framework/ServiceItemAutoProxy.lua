ServiceItemAutoProxy = class("ServiceItemAutoProxy", ServiceProxy)
ServiceItemAutoProxy.Instance = nil
ServiceItemAutoProxy.NAME = "ServiceItemAutoProxy"
function ServiceItemAutoProxy:ctor(proxyName)
  if ServiceItemAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceItemAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceItemAutoProxy.Instance = self
  end
end
function ServiceItemAutoProxy:Init()
end
function ServiceItemAutoProxy:onRegister()
  self:Listen(6, 1, function(data)
    self:RecvPackageItem(data)
  end)
  self:Listen(6, 2, function(data)
    self:RecvPackageUpdate(data)
  end)
  self:Listen(6, 3, function(data)
    self:RecvItemUse(data)
  end)
  self:Listen(6, 4, function(data)
    self:RecvPackageSort(data)
  end)
  self:Listen(6, 5, function(data)
    self:RecvEquip(data)
  end)
  self:Listen(6, 6, function(data)
    self:RecvSellItem(data)
  end)
  self:Listen(6, 7, function(data)
    self:RecvEquipStrength(data)
  end)
  self:Listen(6, 9, function(data)
    self:RecvProduce(data)
  end)
  self:Listen(6, 10, function(data)
    self:RecvProduceDone(data)
  end)
  self:Listen(6, 11, function(data)
    self:RecvEquipRefine(data)
  end)
  self:Listen(6, 12, function(data)
    self:RecvEquipDecompose(data)
  end)
  self:Listen(6, 27, function(data)
    self:RecvQueryDecomposeResultItemCmd(data)
  end)
  self:Listen(6, 13, function(data)
    self:RecvQueryEquipData(data)
  end)
  self:Listen(6, 14, function(data)
    self:RecvBrowsePackage(data)
  end)
  self:Listen(6, 15, function(data)
    self:RecvEquipCard(data)
  end)
  self:Listen(6, 16, function(data)
    self:RecvItemShow(data)
  end)
  self:Listen(6, 35, function(data)
    self:RecvItemShow64(data)
  end)
  self:Listen(6, 17, function(data)
    self:RecvEquipRepair(data)
  end)
  self:Listen(6, 18, function(data)
    self:RecvHintNtf(data)
  end)
  self:Listen(6, 19, function(data)
    self:RecvEnchantEquip(data)
  end)
  self:Listen(6, 20, function(data)
    self:RecvProcessEnchantItemCmd(data)
  end)
  self:Listen(6, 21, function(data)
    self:RecvEquipExchangeItemCmd(data)
  end)
  self:Listen(6, 22, function(data)
    self:RecvOnOffStoreItemCmd(data)
  end)
  self:Listen(6, 23, function(data)
    self:RecvPackSlotNtfItemCmd(data)
  end)
  self:Listen(6, 24, function(data)
    self:RecvRestoreEquipItemCmd(data)
  end)
  self:Listen(6, 25, function(data)
    self:RecvUseCountItemCmd(data)
  end)
  self:Listen(6, 28, function(data)
    self:RecvExchangeCardItemCmd(data)
  end)
  self:Listen(6, 29, function(data)
    self:RecvGetCountItemCmd(data)
  end)
  self:Listen(6, 30, function(data)
    self:RecvSaveLoveLetterCmd(data)
  end)
  self:Listen(6, 31, function(data)
    self:RecvItemDataShow(data)
  end)
  self:Listen(6, 32, function(data)
    self:RecvLotteryCmd(data)
  end)
  self:Listen(6, 33, function(data)
    self:RecvLotteryRecoveryCmd(data)
  end)
  self:Listen(6, 34, function(data)
    self:RecvQueryLotteryInfo(data)
  end)
  self:Listen(6, 40, function(data)
    self:RecvReqQuotaLogCmd(data)
  end)
  self:Listen(6, 41, function(data)
    self:RecvReqQuotaDetailCmd(data)
  end)
  self:Listen(6, 42, function(data)
    self:RecvEquipPosDataUpdate(data)
  end)
  self:Listen(6, 36, function(data)
    self:RecvHighRefineMatComposeCmd(data)
  end)
  self:Listen(6, 37, function(data)
    self:RecvHighRefineCmd(data)
  end)
  self:Listen(6, 38, function(data)
    self:RecvNtfHighRefineDataCmd(data)
  end)
  self:Listen(6, 39, function(data)
    self:RecvUpdateHighRefineDataCmd(data)
  end)
  self:Listen(6, 43, function(data)
    self:RecvUseCodItemCmd(data)
  end)
  self:Listen(6, 44, function(data)
    self:RecvAddJobLevelItemCmd(data)
  end)
  self:Listen(6, 46, function(data)
    self:RecvLotterGivBuyCountCmd(data)
  end)
  self:Listen(6, 47, function(data)
    self:RecvGiveWeddingDressCmd(data)
  end)
  self:Listen(6, 48, function(data)
    self:RecvQuickStoreItemCmd(data)
  end)
  self:Listen(6, 49, function(data)
    self:RecvQuickSellItemCmd(data)
  end)
  self:Listen(6, 50, function(data)
    self:RecvEnchantTransItemCmd(data)
  end)
  self:Listen(6, 51, function(data)
    self:RecvQueryLotteryHeadItemCmd(data)
  end)
  self:Listen(6, 52, function(data)
    self:RecvLotteryRateQueryCmd(data)
  end)
  self:Listen(6, 53, function(data)
    self:RecvEquipComposeItemCmd(data)
  end)
  self:Listen(6, 54, function(data)
    self:RecvQueryDebtItemCmd(data)
  end)
  self:Listen(6, 57, function(data)
    self:RecvLotteryActivityNtfCmd(data)
  end)
  self:Listen(6, 56, function(data)
    self:RecvFavoriteItemActionItemCmd(data)
  end)
end
function ServiceItemAutoProxy:CallPackageItem(type, data, maxslot)
  local msg = SceneItem_pb.PackageItem()
  if type ~= nil then
    msg.type = type
  end
  if data ~= nil then
    for i = 1, #data do
      table.insert(msg.data, data[i])
    end
  end
  if maxslot ~= nil then
    msg.maxslot = maxslot
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallPackageUpdate(type, updateItems, delItems)
  local msg = SceneItem_pb.PackageUpdate()
  if type ~= nil then
    msg.type = type
  end
  if updateItems ~= nil then
    for i = 1, #updateItems do
      table.insert(msg.updateItems, updateItems[i])
    end
  end
  if delItems ~= nil then
    for i = 1, #delItems do
      table.insert(msg.delItems, delItems[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallItemUse(itemguid, targets, count)
  local msg = SceneItem_pb.ItemUse()
  if itemguid ~= nil then
    msg.itemguid = itemguid
  end
  if targets ~= nil then
    for i = 1, #targets do
      table.insert(msg.targets, targets[i])
    end
  end
  if count ~= nil then
    msg.count = count
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallPackageSort(type, item)
  local msg = SceneItem_pb.PackageSort()
  if type ~= nil then
    msg.type = type
  end
  if item ~= nil then
    for i = 1, #item do
      table.insert(msg.item, item[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquip(oper, pos, guid, transfer, count)
  local msg = SceneItem_pb.Equip()
  if oper ~= nil then
    msg.oper = oper
  end
  if pos ~= nil then
    msg.pos = pos
  end
  if guid ~= nil then
    msg.guid = guid
  end
  if transfer ~= nil then
    msg.transfer = transfer
  end
  if count ~= nil then
    msg.count = count
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallSellItem(npcid, items)
  local msg = SceneItem_pb.SellItem()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipStrength(guid, destcount, count, cricount, oldlv, newlv, result, type)
  local msg = SceneItem_pb.EquipStrength()
  if guid ~= nil then
    msg.guid = guid
  end
  if destcount ~= nil then
    msg.destcount = destcount
  end
  if count ~= nil then
    msg.count = count
  end
  if cricount ~= nil then
    msg.cricount = cricount
  end
  if oldlv ~= nil then
    msg.oldlv = oldlv
  end
  if newlv ~= nil then
    msg.newlv = newlv
  end
  if result ~= nil then
    msg.result = result
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallProduce(type, composeid, npcid, itemid, count, qucikproduce)
  local msg = SceneItem_pb.Produce()
  if type ~= nil then
    msg.type = type
  end
  if composeid ~= nil then
    msg.composeid = composeid
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if qucikproduce ~= nil then
    msg.qucikproduce = qucikproduce
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallProduceDone(type, npcid, charid, delay, itemid)
  local msg = SceneItem_pb.ProduceDone()
  if type ~= nil then
    msg.type = type
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if delay ~= nil then
    msg.delay = delay
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipRefine(guid, composeid, refinelv, eresult, npcid, saferefine, itemguid)
  local msg = SceneItem_pb.EquipRefine()
  if guid ~= nil then
    msg.guid = guid
  end
  if composeid ~= nil then
    msg.composeid = composeid
  end
  if refinelv ~= nil then
    msg.refinelv = refinelv
  end
  if eresult ~= nil then
    msg.eresult = eresult
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if saferefine ~= nil then
    msg.saferefine = saferefine
  end
  if itemguid ~= nil then
    for i = 1, #itemguid do
      table.insert(msg.itemguid, itemguid[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipDecompose(guid, result, items)
  local msg = SceneItem_pb.EquipDecompose()
  if guid ~= nil then
    msg.guid = guid
  end
  if result ~= nil then
    msg.result = result
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQueryDecomposeResultItemCmd(guid, results, sell_price)
  local msg = SceneItem_pb.QueryDecomposeResultItemCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  if results ~= nil then
    for i = 1, #results do
      table.insert(msg.results, results[i])
    end
  end
  if sell_price ~= nil then
    msg.sell_price = sell_price
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQueryEquipData(guid, data)
  local msg = SceneItem_pb.QueryEquipData()
  if guid ~= nil then
    msg.guid = guid
  end
  if data ~= nil and data.strengthlv ~= nil then
    msg.data.strengthlv = data.strengthlv
  end
  if data ~= nil and data.refinelv ~= nil then
    msg.data.refinelv = data.refinelv
  end
  if data ~= nil and data.strengthCost ~= nil then
    msg.data.strengthCost = data.strengthCost
  end
  if data ~= nil and data.refineCompose ~= nil then
    for i = 1, #data.refineCompose do
      table.insert(msg.data.refineCompose, data.refineCompose[i])
    end
  end
  if data ~= nil and data.cardslot ~= nil then
    msg.data.cardslot = data.cardslot
  end
  if data ~= nil and data.buffid ~= nil then
    for i = 1, #data.buffid do
      table.insert(msg.data.buffid, data.buffid[i])
    end
  end
  if data ~= nil and data.damage ~= nil then
    msg.data.damage = data.damage
  end
  if data ~= nil and data.lv ~= nil then
    msg.data.lv = data.lv
  end
  if data ~= nil and data.color ~= nil then
    msg.data.color = data.color
  end
  if data ~= nil and data.breakstarttime ~= nil then
    msg.data.breakstarttime = data.breakstarttime
  end
  if data ~= nil and data.breakendtime ~= nil then
    msg.data.breakendtime = data.breakendtime
  end
  if data ~= nil and data.strengthlv2 ~= nil then
    msg.data.strengthlv2 = data.strengthlv2
  end
  if data ~= nil and data.strengthlv2cost ~= nil then
    for i = 1, #data.strengthlv2cost do
      table.insert(msg.data.strengthlv2cost, data.strengthlv2cost[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallBrowsePackage(type)
  local msg = SceneItem_pb.BrowsePackage()
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipCard(oper, cardguid, equipguid, pos)
  local msg = SceneItem_pb.EquipCard()
  if oper ~= nil then
    msg.oper = oper
  end
  if cardguid ~= nil then
    msg.cardguid = cardguid
  end
  if equipguid ~= nil then
    msg.equipguid = equipguid
  end
  if pos ~= nil then
    msg.pos = pos
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallItemShow(items)
  local msg = SceneItem_pb.ItemShow()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallItemShow64(id, count)
  local msg = SceneItem_pb.ItemShow64()
  if id ~= nil then
    msg.id = id
  end
  if count ~= nil then
    msg.count = count
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipRepair(targetguid, success, stuffguid)
  local msg = SceneItem_pb.EquipRepair()
  if targetguid ~= nil then
    msg.targetguid = targetguid
  end
  if success ~= nil then
    msg.success = success
  end
  if stuffguid ~= nil then
    msg.stuffguid = stuffguid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallHintNtf(itemid)
  local msg = SceneItem_pb.HintNtf()
  if itemid ~= nil then
    msg.itemid = itemid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEnchantEquip(type, guid)
  local msg = SceneItem_pb.EnchantEquip()
  if type ~= nil then
    msg.type = type
  end
  if guid ~= nil then
    msg.guid = guid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallProcessEnchantItemCmd(save, itemid)
  local msg = SceneItem_pb.ProcessEnchantItemCmd()
  if save ~= nil then
    msg.save = save
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipExchangeItemCmd(guid, type)
  local msg = SceneItem_pb.EquipExchangeItemCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallOnOffStoreItemCmd(open)
  local msg = SceneItem_pb.OnOffStoreItemCmd()
  if open ~= nil then
    msg.open = open
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallPackSlotNtfItemCmd(type, maxslot)
  local msg = SceneItem_pb.PackSlotNtfItemCmd()
  if type ~= nil then
    msg.type = type
  end
  if maxslot ~= nil then
    msg.maxslot = maxslot
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallRestoreEquipItemCmd(equipid, strengthlv, cardids, enchant, upgrade, strengthlv2)
  local msg = SceneItem_pb.RestoreEquipItemCmd()
  if equipid ~= nil then
    msg.equipid = equipid
  end
  if strengthlv ~= nil then
    msg.strengthlv = strengthlv
  end
  if cardids ~= nil then
    for i = 1, #cardids do
      table.insert(msg.cardids, cardids[i])
    end
  end
  if enchant ~= nil then
    msg.enchant = enchant
  end
  if upgrade ~= nil then
    msg.upgrade = upgrade
  end
  if strengthlv2 ~= nil then
    msg.strengthlv2 = strengthlv2
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallUseCountItemCmd(itemid, count)
  local msg = SceneItem_pb.UseCountItemCmd()
  msg.itemid = itemid
  if count ~= nil then
    msg.count = count
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallExchangeCardItemCmd(type, npcid, material, charid, cardid, anim, items)
  local msg = SceneItem_pb.ExchangeCardItemCmd()
  if type ~= nil then
    msg.type = type
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if material ~= nil then
    for i = 1, #material do
      table.insert(msg.material, material[i])
    end
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if cardid ~= nil then
    msg.cardid = cardid
  end
  if anim ~= nil then
    msg.anim = anim
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallGetCountItemCmd(itemid, count, source)
  local msg = SceneItem_pb.GetCountItemCmd()
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if source ~= nil then
    msg.source = source
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallSaveLoveLetterCmd(dwID)
  local msg = SceneItem_pb.SaveLoveLetterCmd()
  if dwID ~= nil then
    msg.dwID = dwID
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallItemDataShow(items)
  local msg = SceneItem_pb.ItemDataShow()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallLotteryCmd(year, month, npcid, skip_anim, price, ticket, type, count, items, charid, guid, today_cnt, today_extra_cnt)
  local msg = SceneItem_pb.LotteryCmd()
  if year ~= nil then
    msg.year = year
  end
  if month ~= nil then
    msg.month = month
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if skip_anim ~= nil then
    msg.skip_anim = skip_anim
  end
  if price ~= nil then
    msg.price = price
  end
  if ticket ~= nil then
    msg.ticket = ticket
  end
  if type ~= nil then
    msg.type = type
  end
  if count ~= nil then
    msg.count = count
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if guid ~= nil then
    msg.guid = guid
  end
  if today_cnt ~= nil then
    msg.today_cnt = today_cnt
  end
  if today_extra_cnt ~= nil then
    msg.today_extra_cnt = today_extra_cnt
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallLotteryRecoveryCmd(guids, npcid, type)
  local msg = SceneItem_pb.LotteryRecoveryCmd()
  if guids ~= nil then
    for i = 1, #guids do
      table.insert(msg.guids, guids[i])
    end
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQueryLotteryInfo(infos, type, today_cnt, max_cnt, today_extra_cnt, max_extra_cnt, once_max_cnt)
  local msg = SceneItem_pb.QueryLotteryInfo()
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  if today_cnt ~= nil then
    msg.today_cnt = today_cnt
  end
  if max_cnt ~= nil then
    msg.max_cnt = max_cnt
  end
  if today_extra_cnt ~= nil then
    msg.today_extra_cnt = today_extra_cnt
  end
  if max_extra_cnt ~= nil then
    msg.max_extra_cnt = max_extra_cnt
  end
  if once_max_cnt ~= nil then
    msg.once_max_cnt = once_max_cnt
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallReqQuotaLogCmd(page_index, log)
  local msg = SceneItem_pb.ReqQuotaLogCmd()
  if page_index ~= nil then
    msg.page_index = page_index
  end
  if log ~= nil then
    for i = 1, #log do
      table.insert(msg.log, log[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallReqQuotaDetailCmd(page_index, detail)
  local msg = SceneItem_pb.ReqQuotaDetailCmd()
  if page_index ~= nil then
    msg.page_index = page_index
  end
  if detail ~= nil then
    for i = 1, #detail do
      table.insert(msg.detail, detail[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipPosDataUpdate(datas)
  local msg = SceneItem_pb.EquipPosDataUpdate()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallHighRefineMatComposeCmd(dataid, npcid, mainmaterial, vicematerial)
  local msg = SceneItem_pb.HighRefineMatComposeCmd()
  if dataid ~= nil then
    msg.dataid = dataid
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if mainmaterial ~= nil then
    for i = 1, #mainmaterial do
      table.insert(msg.mainmaterial, mainmaterial[i])
    end
  end
  if vicematerial ~= nil then
    for i = 1, #vicematerial do
      table.insert(msg.vicematerial, vicematerial[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallHighRefineCmd(dataid)
  local msg = SceneItem_pb.HighRefineCmd()
  if dataid ~= nil then
    msg.dataid = dataid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallNtfHighRefineDataCmd(datas)
  local msg = SceneItem_pb.NtfHighRefineDataCmd()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallUpdateHighRefineDataCmd(data)
  local msg = SceneItem_pb.UpdateHighRefineDataCmd()
  if data ~= nil and data.pos ~= nil then
    msg.data.pos = data.pos
  end
  if data ~= nil and data.level ~= nil then
    for i = 1, #data.level do
      table.insert(msg.data.level, data.level[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallUseCodItemCmd(guid, code)
  local msg = SceneItem_pb.UseCodItemCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  if code ~= nil then
    msg.code = code
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallAddJobLevelItemCmd(item, num)
  local msg = SceneItem_pb.AddJobLevelItemCmd()
  if item ~= nil then
    msg.item = item
  end
  if num ~= nil then
    msg.num = num
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallLotterGivBuyCountCmd(got_count, max_count)
  local msg = SceneItem_pb.LotterGivBuyCountCmd()
  if got_count ~= nil then
    msg.got_count = got_count
  end
  if max_count ~= nil then
    msg.max_count = max_count
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallGiveWeddingDressCmd(guid, content, receiverid)
  local msg = SceneItem_pb.GiveWeddingDressCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  if content ~= nil then
    msg.content = content
  end
  if receiverid ~= nil then
    msg.receiverid = receiverid
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQuickStoreItemCmd(items)
  local msg = SceneItem_pb.QuickStoreItemCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQuickSellItemCmd(items)
  local msg = SceneItem_pb.QuickSellItemCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEnchantTransItemCmd(from_guid, to_guid, success)
  local msg = SceneItem_pb.EnchantTransItemCmd()
  if from_guid ~= nil then
    msg.from_guid = from_guid
  end
  if to_guid ~= nil then
    msg.to_guid = to_guid
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQueryLotteryHeadItemCmd(ids)
  local msg = SceneItem_pb.QueryLotteryHeadItemCmd()
  if ids ~= nil then
    for i = 1, #ids do
      table.insert(msg.ids, ids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallLotteryRateQueryCmd(type, infos)
  local msg = SceneItem_pb.LotteryRateQueryCmd()
  if type ~= nil then
    msg.type = type
  end
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallEquipComposeItemCmd(id, materialequips, retmsg)
  local msg = SceneItem_pb.EquipComposeItemCmd()
  if id ~= nil then
    msg.id = id
  end
  if materialequips ~= nil then
    for i = 1, #materialequips do
      table.insert(msg.materialequips, materialequips[i])
    end
  end
  if retmsg ~= nil then
    msg.retmsg = retmsg
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallQueryDebtItemCmd(items)
  local msg = SceneItem_pb.QueryDebtItemCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallLotteryActivityNtfCmd(infos)
  local msg = SceneItem_pb.LotteryActivityNtfCmd()
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:CallFavoriteItemActionItemCmd(action, guids)
  local msg = SceneItem_pb.FavoriteItemActionItemCmd()
  if action ~= nil then
    msg.action = action
  end
  if guids ~= nil then
    for i = 1, #guids do
      table.insert(msg.guids, guids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceItemAutoProxy:RecvPackageItem(data)
  self:Notify(ServiceEvent.ItemPackageItem, data)
end
function ServiceItemAutoProxy:RecvPackageUpdate(data)
  self:Notify(ServiceEvent.ItemPackageUpdate, data)
end
function ServiceItemAutoProxy:RecvItemUse(data)
  self:Notify(ServiceEvent.ItemItemUse, data)
end
function ServiceItemAutoProxy:RecvPackageSort(data)
  self:Notify(ServiceEvent.ItemPackageSort, data)
end
function ServiceItemAutoProxy:RecvEquip(data)
  self:Notify(ServiceEvent.ItemEquip, data)
end
function ServiceItemAutoProxy:RecvSellItem(data)
  self:Notify(ServiceEvent.ItemSellItem, data)
end
function ServiceItemAutoProxy:RecvEquipStrength(data)
  self:Notify(ServiceEvent.ItemEquipStrength, data)
end
function ServiceItemAutoProxy:RecvProduce(data)
  self:Notify(ServiceEvent.ItemProduce, data)
end
function ServiceItemAutoProxy:RecvProduceDone(data)
  self:Notify(ServiceEvent.ItemProduceDone, data)
end
function ServiceItemAutoProxy:RecvEquipRefine(data)
  self:Notify(ServiceEvent.ItemEquipRefine, data)
end
function ServiceItemAutoProxy:RecvEquipDecompose(data)
  self:Notify(ServiceEvent.ItemEquipDecompose, data)
end
function ServiceItemAutoProxy:RecvQueryDecomposeResultItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryDecomposeResultItemCmd, data)
end
function ServiceItemAutoProxy:RecvQueryEquipData(data)
  self:Notify(ServiceEvent.ItemQueryEquipData, data)
end
function ServiceItemAutoProxy:RecvBrowsePackage(data)
  self:Notify(ServiceEvent.ItemBrowsePackage, data)
end
function ServiceItemAutoProxy:RecvEquipCard(data)
  self:Notify(ServiceEvent.ItemEquipCard, data)
end
function ServiceItemAutoProxy:RecvItemShow(data)
  self:Notify(ServiceEvent.ItemItemShow, data)
end
function ServiceItemAutoProxy:RecvItemShow64(data)
  self:Notify(ServiceEvent.ItemItemShow64, data)
end
function ServiceItemAutoProxy:RecvEquipRepair(data)
  self:Notify(ServiceEvent.ItemEquipRepair, data)
end
function ServiceItemAutoProxy:RecvHintNtf(data)
  self:Notify(ServiceEvent.ItemHintNtf, data)
end
function ServiceItemAutoProxy:RecvEnchantEquip(data)
  self:Notify(ServiceEvent.ItemEnchantEquip, data)
end
function ServiceItemAutoProxy:RecvProcessEnchantItemCmd(data)
  self:Notify(ServiceEvent.ItemProcessEnchantItemCmd, data)
end
function ServiceItemAutoProxy:RecvEquipExchangeItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipExchangeItemCmd, data)
end
function ServiceItemAutoProxy:RecvOnOffStoreItemCmd(data)
  self:Notify(ServiceEvent.ItemOnOffStoreItemCmd, data)
end
function ServiceItemAutoProxy:RecvPackSlotNtfItemCmd(data)
  self:Notify(ServiceEvent.ItemPackSlotNtfItemCmd, data)
end
function ServiceItemAutoProxy:RecvRestoreEquipItemCmd(data)
  self:Notify(ServiceEvent.ItemRestoreEquipItemCmd, data)
end
function ServiceItemAutoProxy:RecvUseCountItemCmd(data)
  self:Notify(ServiceEvent.ItemUseCountItemCmd, data)
end
function ServiceItemAutoProxy:RecvExchangeCardItemCmd(data)
  self:Notify(ServiceEvent.ItemExchangeCardItemCmd, data)
end
function ServiceItemAutoProxy:RecvGetCountItemCmd(data)
  self:Notify(ServiceEvent.ItemGetCountItemCmd, data)
end
function ServiceItemAutoProxy:RecvSaveLoveLetterCmd(data)
  self:Notify(ServiceEvent.ItemSaveLoveLetterCmd, data)
end
function ServiceItemAutoProxy:RecvItemDataShow(data)
  self:Notify(ServiceEvent.ItemItemDataShow, data)
end
function ServiceItemAutoProxy:RecvLotteryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryCmd, data)
end
function ServiceItemAutoProxy:RecvLotteryRecoveryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryRecoveryCmd, data)
end
function ServiceItemAutoProxy:RecvQueryLotteryInfo(data)
  self:Notify(ServiceEvent.ItemQueryLotteryInfo, data)
end
function ServiceItemAutoProxy:RecvReqQuotaLogCmd(data)
  self:Notify(ServiceEvent.ItemReqQuotaLogCmd, data)
end
function ServiceItemAutoProxy:RecvReqQuotaDetailCmd(data)
  self:Notify(ServiceEvent.ItemReqQuotaDetailCmd, data)
end
function ServiceItemAutoProxy:RecvEquipPosDataUpdate(data)
  self:Notify(ServiceEvent.ItemEquipPosDataUpdate, data)
end
function ServiceItemAutoProxy:RecvHighRefineMatComposeCmd(data)
  self:Notify(ServiceEvent.ItemHighRefineMatComposeCmd, data)
end
function ServiceItemAutoProxy:RecvHighRefineCmd(data)
  self:Notify(ServiceEvent.ItemHighRefineCmd, data)
end
function ServiceItemAutoProxy:RecvNtfHighRefineDataCmd(data)
  self:Notify(ServiceEvent.ItemNtfHighRefineDataCmd, data)
end
function ServiceItemAutoProxy:RecvUpdateHighRefineDataCmd(data)
  self:Notify(ServiceEvent.ItemUpdateHighRefineDataCmd, data)
end
function ServiceItemAutoProxy:RecvUseCodItemCmd(data)
  self:Notify(ServiceEvent.ItemUseCodItemCmd, data)
end
function ServiceItemAutoProxy:RecvAddJobLevelItemCmd(data)
  self:Notify(ServiceEvent.ItemAddJobLevelItemCmd, data)
end
function ServiceItemAutoProxy:RecvLotterGivBuyCountCmd(data)
  self:Notify(ServiceEvent.ItemLotterGivBuyCountCmd, data)
end
function ServiceItemAutoProxy:RecvGiveWeddingDressCmd(data)
  self:Notify(ServiceEvent.ItemGiveWeddingDressCmd, data)
end
function ServiceItemAutoProxy:RecvQuickStoreItemCmd(data)
  self:Notify(ServiceEvent.ItemQuickStoreItemCmd, data)
end
function ServiceItemAutoProxy:RecvQuickSellItemCmd(data)
  self:Notify(ServiceEvent.ItemQuickSellItemCmd, data)
end
function ServiceItemAutoProxy:RecvEnchantTransItemCmd(data)
  self:Notify(ServiceEvent.ItemEnchantTransItemCmd, data)
end
function ServiceItemAutoProxy:RecvQueryLotteryHeadItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryLotteryHeadItemCmd, data)
end
function ServiceItemAutoProxy:RecvLotteryRateQueryCmd(data)
  self:Notify(ServiceEvent.ItemLotteryRateQueryCmd, data)
end
function ServiceItemAutoProxy:RecvEquipComposeItemCmd(data)
  self:Notify(ServiceEvent.ItemEquipComposeItemCmd, data)
end
function ServiceItemAutoProxy:RecvQueryDebtItemCmd(data)
  self:Notify(ServiceEvent.ItemQueryDebtItemCmd, data)
end
function ServiceItemAutoProxy:RecvLotteryActivityNtfCmd(data)
  self:Notify(ServiceEvent.ItemLotteryActivityNtfCmd, data)
end
function ServiceItemAutoProxy:RecvFavoriteItemActionItemCmd(data)
  self:Notify(ServiceEvent.ItemFavoriteItemActionItemCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ItemPackageItem = "ServiceEvent_ItemPackageItem"
ServiceEvent.ItemPackageUpdate = "ServiceEvent_ItemPackageUpdate"
ServiceEvent.ItemItemUse = "ServiceEvent_ItemItemUse"
ServiceEvent.ItemPackageSort = "ServiceEvent_ItemPackageSort"
ServiceEvent.ItemEquip = "ServiceEvent_ItemEquip"
ServiceEvent.ItemSellItem = "ServiceEvent_ItemSellItem"
ServiceEvent.ItemEquipStrength = "ServiceEvent_ItemEquipStrength"
ServiceEvent.ItemProduce = "ServiceEvent_ItemProduce"
ServiceEvent.ItemProduceDone = "ServiceEvent_ItemProduceDone"
ServiceEvent.ItemEquipRefine = "ServiceEvent_ItemEquipRefine"
ServiceEvent.ItemEquipDecompose = "ServiceEvent_ItemEquipDecompose"
ServiceEvent.ItemQueryDecomposeResultItemCmd = "ServiceEvent_ItemQueryDecomposeResultItemCmd"
ServiceEvent.ItemQueryEquipData = "ServiceEvent_ItemQueryEquipData"
ServiceEvent.ItemBrowsePackage = "ServiceEvent_ItemBrowsePackage"
ServiceEvent.ItemEquipCard = "ServiceEvent_ItemEquipCard"
ServiceEvent.ItemItemShow = "ServiceEvent_ItemItemShow"
ServiceEvent.ItemItemShow64 = "ServiceEvent_ItemItemShow64"
ServiceEvent.ItemEquipRepair = "ServiceEvent_ItemEquipRepair"
ServiceEvent.ItemHintNtf = "ServiceEvent_ItemHintNtf"
ServiceEvent.ItemEnchantEquip = "ServiceEvent_ItemEnchantEquip"
ServiceEvent.ItemProcessEnchantItemCmd = "ServiceEvent_ItemProcessEnchantItemCmd"
ServiceEvent.ItemEquipExchangeItemCmd = "ServiceEvent_ItemEquipExchangeItemCmd"
ServiceEvent.ItemOnOffStoreItemCmd = "ServiceEvent_ItemOnOffStoreItemCmd"
ServiceEvent.ItemPackSlotNtfItemCmd = "ServiceEvent_ItemPackSlotNtfItemCmd"
ServiceEvent.ItemRestoreEquipItemCmd = "ServiceEvent_ItemRestoreEquipItemCmd"
ServiceEvent.ItemUseCountItemCmd = "ServiceEvent_ItemUseCountItemCmd"
ServiceEvent.ItemExchangeCardItemCmd = "ServiceEvent_ItemExchangeCardItemCmd"
ServiceEvent.ItemGetCountItemCmd = "ServiceEvent_ItemGetCountItemCmd"
ServiceEvent.ItemSaveLoveLetterCmd = "ServiceEvent_ItemSaveLoveLetterCmd"
ServiceEvent.ItemItemDataShow = "ServiceEvent_ItemItemDataShow"
ServiceEvent.ItemLotteryCmd = "ServiceEvent_ItemLotteryCmd"
ServiceEvent.ItemLotteryRecoveryCmd = "ServiceEvent_ItemLotteryRecoveryCmd"
ServiceEvent.ItemQueryLotteryInfo = "ServiceEvent_ItemQueryLotteryInfo"
ServiceEvent.ItemReqQuotaLogCmd = "ServiceEvent_ItemReqQuotaLogCmd"
ServiceEvent.ItemReqQuotaDetailCmd = "ServiceEvent_ItemReqQuotaDetailCmd"
ServiceEvent.ItemEquipPosDataUpdate = "ServiceEvent_ItemEquipPosDataUpdate"
ServiceEvent.ItemHighRefineMatComposeCmd = "ServiceEvent_ItemHighRefineMatComposeCmd"
ServiceEvent.ItemHighRefineCmd = "ServiceEvent_ItemHighRefineCmd"
ServiceEvent.ItemNtfHighRefineDataCmd = "ServiceEvent_ItemNtfHighRefineDataCmd"
ServiceEvent.ItemUpdateHighRefineDataCmd = "ServiceEvent_ItemUpdateHighRefineDataCmd"
ServiceEvent.ItemUseCodItemCmd = "ServiceEvent_ItemUseCodItemCmd"
ServiceEvent.ItemAddJobLevelItemCmd = "ServiceEvent_ItemAddJobLevelItemCmd"
ServiceEvent.ItemLotterGivBuyCountCmd = "ServiceEvent_ItemLotterGivBuyCountCmd"
ServiceEvent.ItemGiveWeddingDressCmd = "ServiceEvent_ItemGiveWeddingDressCmd"
ServiceEvent.ItemQuickStoreItemCmd = "ServiceEvent_ItemQuickStoreItemCmd"
ServiceEvent.ItemQuickSellItemCmd = "ServiceEvent_ItemQuickSellItemCmd"
ServiceEvent.ItemEnchantTransItemCmd = "ServiceEvent_ItemEnchantTransItemCmd"
ServiceEvent.ItemQueryLotteryHeadItemCmd = "ServiceEvent_ItemQueryLotteryHeadItemCmd"
ServiceEvent.ItemLotteryRateQueryCmd = "ServiceEvent_ItemLotteryRateQueryCmd"
ServiceEvent.ItemEquipComposeItemCmd = "ServiceEvent_ItemEquipComposeItemCmd"
ServiceEvent.ItemQueryDebtItemCmd = "ServiceEvent_ItemQueryDebtItemCmd"
ServiceEvent.ItemLotteryActivityNtfCmd = "ServiceEvent_ItemLotteryActivityNtfCmd"
ServiceEvent.ItemFavoriteItemActionItemCmd = "ServiceEvent_ItemFavoriteItemActionItemCmd"
