autoImport('ServiceItemAutoProxy')
ServiceItemProxy = class('ServiceItemProxy', ServiceItemAutoProxy)
ServiceItemProxy.Instance = nil
ServiceItemProxy.NAME = 'ServiceItemProxy'

function ServiceItemProxy:ctor(proxyName)
	if ServiceItemProxy.Instance == nil then
		self.proxyName = proxyName or ServiceItemProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceItemProxy.Instance = self
	end
	NetProtocol.NeedCacheReceive(6,1)
	NetProtocol.NeedCacheReceive(6,2)
end

function ServiceItemProxy:CallItemUse(item, targetId, count) 
	if(item.staticData.Type == 40) then
		if(Game.Myself:IsDead()) then
			return
		end
	end
--	LogUtility.Info(string.format("CallItemUse itemid:%s name:%s targetId:%s count:%s", tostring(item.id), tostring(item.staticData.NameZh), targetId, tostring(count)));
	ServiceItemProxy.super.CallItemUse(self,item.id, {targetId}, count)
end

function ServiceItemProxy:CallQueryEquipData(guid,data)
	printOrange(string.format("CallQueryEquipData guid:%s", guid));
	if(data == nil)then
		data = {}
	end
	ServiceItemProxy.super.CallQueryEquipData(self,guid,data)
end

function ServiceItemProxy:CallEquipDecompose(guid, result)
	helplog("Call-->EquipDecompose", guid);
	ServiceItemProxy.super.CallEquipDecompose(self,guid, result)
end

function ServiceItemProxy:RecvEquipDecompose(data)
	helplog("Recv-->EquipDecompose!", data.result)
	self:Notify(ServiceEvent.ItemEquipDecompose, data)
	local list = self:_ParseItems(data.items)
	local modelShowList = {}
	local itemShowList = {}
	local coinShowList = {}
	for i=1,#list do
		local single = list[i]
		if(single.staticData.Share == 1)then
			table.insert(modelShowList,single)
		elseif(BagProxy.CheckIsCoinTypeItem(single.staticData.Type))then
			table.insert(coinShowList,single)
		elseif(BagProxy.CheckIs3DTypeItem(single.staticData.Type) or BagProxy.CheckIsCardTypeItem(single.staticData.Type))then
			table.insert(modelShowList,single)		
		else
			table.insert(itemShowList,single)	
		end
	end
	if(#itemShowList>0 or #coinShowList>0) then
		GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "PopUp10View"});
		--1.show item first
		self:HandleShowItems(itemShowList,PopUp10View.ItemCoinShowType.Decompose,data.result)
		--2.show coins
		self:HandleShowCoins(coinShowList,PopUp10View.ItemCoinShowType.Decompose,data.result)
	end
end

function ServiceItemProxy:RecvQueryEquipData(data) 
	ResolveEquipProxy.Instance:UpdateQueryEquipData(data)
	self:Notify(ServiceEvent.ItemQueryEquipData, data)
end

function ServiceItemProxy:CallBrowsePackage(type) 
	ServiceItemProxy.super.CallBrowsePackage(self,type)
	BagProxy.Instance:SetIsNewFlag(type,false)
end

function ServiceItemProxy:CallEnchantEquip(type, guid) 
	printOrange(string.format("Call-->EnchantEquip (type:%s guild:%s) ", tostring(type), tostring(guid)))
	ServiceItemProxy.super.CallEnchantEquip(self, type, guid)
end

function ServiceItemProxy:RecvItemShow64(data)
	self:RecvItemShow({items = {{id = data.id,count = data.count}}})
end

function ServiceItemProxy:RecvItemShow(data)
	helplog("Recv-->ItemShow");
	local list = {}
	for i=1,#data.items do
		local single = data.items[i]
		local itemData = ItemData.new(single.guid,single.id)
		helplog("Recv-->ItemShow", single.id);
		if(itemData.staticData)then
			itemData.num = single.count
			-- helplog("RecvItemShow:id:"..(single.guid or 0).." staticId:"..(single.id or 0).." count:"..(single.count or 0) )
			table.insert(list,itemData)
		end
	end
	local modelShowList = {}
	local itemShowList = {}
	local coinShowList = {}
	local foodShowList = {}
	for i=1,#list do
		local single = list[i]
		if(single.staticData.Share == 1)then
			table.insert(modelShowList,single)
		elseif(BagProxy.CheckIsCoinTypeItem(single.staticData.Type))then
			table.insert(coinShowList,single)
		elseif(BagProxy.CheckIs3DTypeItem(single.staticData.Type) or BagProxy.CheckIsCardTypeItem(single.staticData.Type))then
			table.insert(modelShowList,single)		
		elseif(BagProxy.CheckIsFoodTypeItem(single.staticData.Type))then
			table.insert(foodShowList,single)		
		else
			table.insert(itemShowList,single)	
		end
	end

	local count = #coinShowList%2 == 0 and #coinShowList/2 or math.floor(#coinShowList/2)+1
	-- printGreen(count)
	local hasShow = false
	for i=1,count do
		local tmpList = {}
		table.insert(tmpList,coinShowList[2*i-1])
		if(2*i <= #coinShowList)then
			table.insert(tmpList,coinShowList[2*i])
		end
		if(not hasShow)then
			hasShow = true
			GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "PopUp10View"});
		end
		GameFacade.Instance:sendNotification(SystemMsgEvent.MenuCoinPop,tmpList)

	end
	if(#itemShowList >0)then
		if(not hasShow)then
			hasShow = true			
			GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "PopUp10View"});
		end
		GameFacade.Instance:sendNotification(SystemMsgEvent.MenuItemPop,itemShowList)
	end
	if(#modelShowList >0)then		
		FloatAwardView.addItemDatasToShow(modelShowList);	
	end
	if(#foodShowList>0)then
		FoodProxy.Instance.foodGetCount = #foodShowList
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.FoodGetPopUp, viewdata = {items = foodShowList}});
	end
end

--start ??????????????????,???????????????????????????
function ServiceItemProxy:_ParseItems(serverItemInfos)
	local list = {}
	for i=1,#serverItemInfos do
		local single = serverItemInfos[i]
		local itemData =  ItemData.new(single.guid,single.id)
		if(itemData.staticData)then
			itemData.num = single.count
			-- printGreen("RecvItemShow:id:"..(single.guid or 0).." staticId:"..(single.id or 0).." count:"..(single.count or 0) )
			table.insert(list,itemData)
		end
	end
	return list
end

function ServiceItemProxy:HandleShowItems(itemShowList,showType,params)
	if(#itemShowList >0)then
		itemShowList.showType = showType
		itemShowList.params = params
		GameFacade.Instance:sendNotification(SystemMsgEvent.MenuItemPop,itemShowList)
	end
end

function ServiceItemProxy:HandleShowCoins(coinShowList,showType,params)
	local count = #coinShowList%2 == 0 and #coinShowList/2 or math.floor(#coinShowList/2)+1
	for i=1,count do
		local tmpList = {}
		table.insert(tmpList,coinShowList[2*i-1])
		if(2*i <= #coinShowList)then
			table.insert(tmpList,coinShowList[2*i])
		end
		tmpList.showType = showType
		tmpList.params = params
		GameFacade.Instance:sendNotification(SystemMsgEvent.MenuCoinPop,tmpList)
	end
end
--end ??????????????????

function ServiceItemProxy:CallSellItem(npcid)
	items={}
	for k,v in pairs(ShopSaleProxy.Instance.waitSaleItemsDic) do
		local msg = SceneItem_pb.SItem()
		msg.guid=k
		msg.count=v
		table.insert(items,msg)
	end
	ServiceItemProxy.super.CallSellItem(self,npcid,items)
end

function ServiceItemProxy:CallEquipCard(oper, cardguid, equipguid, pos)
	helplog(string.format("CallEquipCard-->oper:%d cardguid:%s equipguid:%s pos:%s", oper, cardguid, equipguid, pos));
	ServiceItemProxy.super.CallEquipCard(self, oper, cardguid, equipguid, pos);
end

function ServiceItemProxy:CallPreProduce(npcid, composeid)
	printGreen("Call-->PreProduce", npcid, composeid);
	ServiceItemProxy.super.CallPreProduce(self, npcid, composeid);
end

function ServiceItemProxy:CallReqQuotaLogCmd(page_index,log)
	printGreen("Call-->CallReqQuotaLogCmd", page_index);
	ServiceItemProxy.super.CallReqQuotaLogCmd(self, page_index, log);
end

function ServiceItemProxy:CallReqQuotaDetailCmd(page_index,detail)
	printGreen("Call-->CallReqQuotaDetailCmd", page_index);
	ServiceItemProxy.super.CallReqQuotaDetailCmd(self, page_index, detail);
end

function ServiceItemProxy:RecvReqQuotaLogCmd(data)
	QuotaCardProxy.Instance:UpdateLog(data.log)
	self:Notify(ServiceEvent.ItemReqQuotaLogCmd, data)
end

function ServiceItemProxy:RecvReqQuotaDetailCmd(data)
	QuotaCardProxy.Instance:UpdateDetail(data.detail)
	self:Notify(ServiceEvent.ItemReqQuotaDetailCmd, data)
end

-- function ServiceItemProxy:CallEquipRefine(guid, composeid, refinelv, eresult, npcid) 
-- 	printGreen(string.format("Call-->EquipRefine(guid:%s, composeid:%s, npcid:%s)", tostring(guid), tostring(composeid), tostring(npcid)));
-- 	ServiceItemProxy.super.CallEquipRefine(self, guid, composeid, refinelv, eresult, npcid);
-- end

function ServiceItemProxy:CallEquipExchangeItemCmd(pos, type) 
	ServiceItemProxy.super.CallEquipExchangeItemCmd(self, pos, type);
end

function ServiceItemProxy:RecvPreProduce(data) 
	printGreen("Recv-->PreProduce");
	self:Notify(ServiceEvent.ItemPreProduce, data)
end

function ServiceItemProxy:RecvProduce(data) 
	printGreen("Recv-->Produce");
	self:Notify(ServiceEvent.ItemProduce, data)
end

function ServiceItemProxy:RecvProduceDone(data) 
	printGreen("Recv-->ProduceDone");
	self:Notify(ServiceEvent.ItemProduceDone, data)
end

function ServiceItemProxy:RecvEnchantEquip(data) 
	self:Notify(ServiceEvent.ItemEnchantEquip, data)
end

function ServiceItemProxy:RecvEquipExchangeItemCmd(data) 
	if(data.type == SceneItem_pb.EEXCHANGETYPE_LEVELUP)then
		-- play effect
		local npcguid = FunctionDialogEvent.Me().npcguid;
		if(npcguid)then
			local target = SceneCreatureProxy.FindCreature(npcguid);
			if(target)then
				target:PlayEffect(nil, EffectMap.Maps.EquipUpgrade_Success, RoleDefines_EP.Top);
			end
		end
	end
	self:Notify(ServiceEvent.ItemEquipExchangeItemCmd, data)
end

function ServiceItemProxy:RecvPackSlotNtfItemCmd(data) 
	-- helplog("Recv-->PackSlotNtfItemCmd", data.type, data.maxslot);
	BagProxy.Instance:ServerSetBagUpLimit(data.type, data.maxslot);
	self:Notify(ServiceEvent.ItemPackSlotNtfItemCmd, data)
end

function ServiceItemProxy:RecvUseCountItemCmd(data) 
	EventManager.Me():DispatchEvent(ServiceEvent.ItemUseCountItemCmd, data);
	-- self:Notify(ServiceEvent.ItemUseCountItemCmd, data)
end

function ServiceItemProxy:CallGetCountItemCmd(itemid, count, source) 
	helplog("Call-->GetCountItemCmd", itemid, count, source);
	ServiceItemProxy.super.CallGetCountItemCmd(self, itemid, count, source) 
end

function ServiceItemProxy:RecvGetCountItemCmd(data) 
	helplog("Recv-->GetCountItemCmd", data.itemid, data.count)
	FunctionPet.Me():SetRewardItemCount(data.itemid, data.count, data.source);
	HappyShopProxy.Instance:SetLimitCount(data.itemid, data.count)
	EventManager.Me():DispatchEvent(ServiceEvent.ItemGetCountItemCmd, data);
	-- self:Notify(ServiceEvent.ItemGetCountItemCmd, data)
end

function ServiceItemProxy:RecvEquipUpgradeItemCmd(data) 
	self:Notify(ServiceEvent.ItemEquipUpgradeItemCmd, data)
end

function ServiceItemProxy:CallQueryDecomposeResultItemCmd(guid, results) 
	helplog("Call-->QueryDecomposeResultItemCmd");
	ServiceItemProxy.super.CallQueryDecomposeResultItemCmd(self, guid);
end

function ServiceItemProxy:RecvQueryDecomposeResultItemCmd(data)
	helplog("Recv-->QueryDecomposeResultItemCmd");
	self:Notify(ServiceEvent.ItemQueryDecomposeResultItemCmd, data)
end

function ServiceItemProxy:CallExchangeCardItemCmd(type, npcid, material, charid, cardid, anim)
	local now = Time.unscaledTime
	if self._callExchangeCardItem == nil or (now - self._callExchangeCardItem >= 2) then
		self._callExchangeCardItem = now
		helplog("CallExchangeCardItemCmd")
		ServiceItemProxy.super.CallExchangeCardItemCmd(self, type, npcid, material, charid, cardid, anim)
	end
end

function ServiceItemProxy:RecvExchangeCardItemCmd(data)
	helplog("RecvExchangeCardItemCmd")
	self:Notify(ServiceEvent.ItemExchangeCardItemCmd, data)
	CardMakeProxy.Instance:RecvExchangeCardItemCmd(data)
end

function ServiceItemProxy:RecvItemDataShow(data) 
	helplog("Recv-->ItemDataShow", #data.items);
	local Function_CheckIsFoodTypeItem = BagProxy.CheckIsFoodTypeItem;

	local foodShowList = {};
	local server_itemes = data.items;
	for i=1,#server_itemes do
		local tempItem = ItemData.new();
		tempItem:ParseFromServerData(server_itemes[i]);
		local type = tempItem.staticData.Type;
		if( Function_CheckIsFoodTypeItem(type) )then
			table.insert(foodShowList, tempItem)
		end
	end
	if(#foodShowList>0)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.FoodGetPopUp, viewdata = {items = foodShowList}});
	end
	self:Notify(ServiceEvent.ItemItemDataShow, data)
end

function ServiceItemProxy:RecvQueryLotteryInfo(data) 
	LotteryProxy.Instance:RecvQueryLotteryInfo(data)
	self:Notify(ServiceEvent.ItemQueryLotteryInfo, data)
end

function ServiceItemProxy:CallLotteryCmd(year, month, npcid, skip_anim, price, ticket, type, count, items, charid,guid,today_cnt) 
	local now = Time.unscaledTime
	if self._callLottery == nil or now - self._callLottery >= 1 then
		self._callLottery = now
		helplog("CallLotteryCmd")
		ServiceItemProxy.super.CallLotteryCmd(self, year, month, npcid, skip_anim, price, ticket, type, count, items, charid,guid,today_cnt)
	end	
end

function ServiceItemProxy:RecvLotterGivBuyCountCmd(data)
	LotteryProxy.Instance:SetLotteryBuyCnt(data.got_count,data.max_count)
end

function ServiceItemProxy:RecvLotteryCmd(data) 
	helplog("RecvLotteryCmd")
	LotteryProxy.Instance:RecvLotteryCmd(data)
	self:Notify(ServiceEvent.ItemLotteryCmd, data)
end

function ServiceItemProxy:RecvNtfHighRefineDataCmd(data)
	helplog("Recv-->NtfHighRefineDataCmd");
	BlackSmithProxy.Instance:SetPlayerHRefineLevels(data.datas)
	self:Notify(ServiceEvent.ItemNtfHighRefineDataCmd, data)
end

function ServiceItemProxy:RecvUpdateHighRefineDataCmd(data) 
	BlackSmithProxy.Instance:SetPlayerHRefineLevel(data.data)
	self:Notify(ServiceEvent.ItemUpdateHighRefineDataCmd, data)
end

function ServiceItemProxy:CallHighRefineMatComposeCmd( dataid, npcid, mainmaterial, vicematerial )
	local server_mms = {};
	for id, num in pairs(mainmaterial) do
		local matInfo = SceneItem_pb.MatItemInfo();
		matInfo.itemid = id;
		matInfo.num = num;
		table.insert(server_mms, matInfo)
	end
	local server_vms = {};
	for id, num in pairs(vicematerial) do
		local matInfo = SceneItem_pb.MatItemInfo();
		matInfo.itemid = id;
		matInfo.num = num;
		table.insert(server_vms, matInfo)
	end
	ServiceItemProxy.super.CallHighRefineMatComposeCmd( self, dataid, npcid, server_mms, server_vms);
end

function ServiceItemProxy:CallRestoreEquipItemCmd(equipid, strengthlv, cardids, enchant, upgrade, strengthlv2) 
	local logStr = "";

	local cardStr = "";
	if cardids ~= nil then
		for i=1,#cardids do
			cardStr = cardStr .. cardids[i] .. " | ";
		end
	end

	logStr = "Call-->RestoreEquipItemCmd:";
	logStr = logStr .. string.format("equipid:%s || strengthlv:%s || cardids:%s || enchant:%s || upgrade:%s || strengthlv2:%s", 
		equipid, 
		strengthlv, 
		cardStr, 
		enchant, 
		upgrade,
		strengthlv2);

	helplog(logStr);

	ServiceItemProxy.super.CallRestoreEquipItemCmd(self, equipid, strengthlv, cardids, enchant, upgrade, strengthlv2) 
end

function ServiceItemProxy:RecvEquipPosDataUpdate(data) 
	-- helplog("Recv-->EquipPosDataUpdate");
	MyselfProxy.Instance:Server_SetEquipPos_StateTime(data.datas);
	self:Notify(ServiceEvent.ItemEquipPosDataUpdate, data)
end

function ServiceItemProxy:RecvQueryLotteryHeadItemCmd(data)
	EnchantTransferProxy.Instance:HandleLotteryHeadItem(data.ids)
	self:Notify(ServiceEvent.ItemQueryLotteryHeadItemCmd, data)
end

function ServiceItemProxy:RecvUseCodItemCmd(data) 
	ItemUtil.HandleUseCodeCmd(data)
	self:Notify(ServiceEvent.ItemUseCodItemCmd, data)
	EventManager.Me():PassEvent(ServiceEvent.ItemUseCodItemCmd, data);
end