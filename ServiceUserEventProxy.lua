autoImport('ServiceUserEventAutoProxy')
ServiceUserEventProxy = class('ServiceUserEventProxy', ServiceUserEventAutoProxy)
ServiceUserEventProxy.Instance = nil
ServiceUserEventProxy.NAME = 'ServiceUserEventProxy'
autoImport('UIModelMonthlyVIP')
autoImport('UIModelZenyShop')
autoImport('MonthlyVIPTip')

function ServiceUserEventProxy:ctor(proxyName)
	if ServiceUserEventProxy.Instance == nil then
		self.proxyName = proxyName or ServiceUserEventProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceUserEventProxy.Instance = self
	end
end

function ServiceUserEventProxy:RecvFirstActionUserEvent(data) 
	FunctionFirstTime.Me():SyncServerRecord(data.firstaction)
	-- self:Notify(ServiceEvent.UserEventFirstActionUserEvent, data)
end

function ServiceUserEventProxy:RecvNewTitle(data) 
	-- printRed("RecvNewTitle",data.title_data.id)
	MyselfProxy.Instance:newTitle(data)	
	self:Notify(ServiceEvent.UserEventNewTitle, data)
end

function ServiceUserEventProxy:RecvAllTitle(data) 
	-- printRed("RecvAllTitle",#data.title_datas)
	MyselfProxy.Instance:initAllTitle(data)
	TitleProxy.Instance:SetServiceData(data.title_datas)
end

function ServiceUserEventProxy:RecvChangeTitle(data) 
	-- helplog("RecvChangeTitle:",data.charid,Game.Myself.data.id,data.title_data.id)	
	local player = NSceneUserProxy.Instance:Find(data.charid);
	if(player)then
		player:Sever_SetTitleID(data.title_data)
		TitleProxy.Instance:SetServiceData(data.title_data)
	end
	 EventManager.Me():DispatchEvent(ServiceEvent.UserEventChangeTitle, data);
	self:Notify(ServiceEvent.UserEventChangeTitle, data)
end

function ServiceUserEventProxy:RecvUpdateRandomUserEvent(data) 
	MyselfProxy.Instance:UpdateRandomFunc(data.randoms, data.beginindex, data.endindex)
	self:Notify(ServiceEvent.UserEventUpdateRandomUserEvent, data)
end

function ServiceUserEventProxy:RecvBuffDamageUserEvent(data) 
	local creature = SceneCreatureProxy.FindCreature(data.charid)
	if(creature) then
		creature:PlayDamage_Effect(data.damage,data.etype)
	end
end

function ServiceUserEventProxy:RecvDepositCardInfo(data) 
	self:Notify(ServiceEvent.UserEventDepositCardInfo, data)

	local monthCardData = nil
	local cardDatas = data.card_datas
	for _, v in ipairs(cardDatas) do
		if v.type == ProtoCommon_pb.ETITLE_TYPE_MONTH then
			monthCardData = v
			break
		end
	end
	if monthCardData ~= nil then
		UIModelMonthlyVIP.Instance():Set_TimeOfLatestPurchaseMonthlyVIP(monthCardData.starttime)
		UIModelMonthlyVIP.Instance():Set_TimeOfExpirationMonthlyVIP(monthCardData.expiretime)
	end
end

function ServiceUserEventProxy:AmIMonthlyVIP()
	return UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
end

function ServiceUserEventProxy:CallDelTransformUserEvent()
	ServiceUserEventProxy.super.CallDelTransformUserEvent(self)
end

function ServiceUserEventProxy:CallChangeTitle(title_data, charid)
	ServiceUserEventProxy.super.CallChangeTitle(self,title_data,charid)
end

function ServiceUserEventProxy:RecvChargeNtfUserEvent(data) 
	self:Notify(ServiceEvent.UserEventChargeNtfUserEvent, data)
	EventManager.Me():PassEvent(ServiceEvent.UserEventChargeNtfUserEvent, data)
end

function ServiceUserEventProxy:RecvQueryChargeCnt(data)
	-- this protocol only be used for lucky bag and ep card
	local info = data.info
	for i = 1, #info do
		local purchaseInfo = info[i]
		local productConfID = purchaseInfo.dataid
		local purchaseTimes = purchaseInfo.count
		local purchaseLimit = purchaseInfo.limit
		local productConf = Table_Deposit[productConfID]
		if productConf.LimitType ~= 6 -- is sold
			and productConf.Type == 4
			and productConf.Switch == 1 then -- is being sold
			UIModelZenyShop.Ins():SetLuckyBagPurchaseTimes(productConfID, purchaseTimes)
			UIModelZenyShop.Ins():SetLuckyBagPurchaseLimit(productConfID, purchaseLimit)
		end
	end
	self:Notify(ServiceEvent.UserEventQueryChargeCnt, data)
	EventManager.Me():PassEvent(ServiceEvent.UserEventQueryChargeCnt, data)
end

function ServiceUserEventProxy:RecvNTFMonthCardEnd(data) 
	self:Notify(ServiceEvent.UserEventNTFMonthCardEnd, data)
	MonthlyVIPTip.Ins():ShowTip()
end



function ServiceUserEventProxy:RecvQueryResetTimeEventCmd(data) 
	if(data.etype == AERewardType.Tower)then
		EndlessTowerProxy.Instance:Server_SerResetTime(data.resettime);
		EventManager.Me():PassEvent(ServiceEvent.UserEventQueryResetTimeEventCmd, data.resettime)
	end
	self:Notify(ServiceEvent.UserEventQueryResetTimeEventCmd, data)
end

function ServiceUserEventProxy:RecvQueryActivityCnt(data)
	self:Notify(ServiceEvent.UserEventQueryActivityCnt, data)

	local purchaseActivityInfos = data.info
	for i = 1, #purchaseActivityInfos do
		local activityID = purchaseActivityInfos[i].activityid
		local activityUsedTimes = purchaseActivityInfos[i].count
		UIModelZenyShop.Ins():SetActivityUsedTimes(activityID, activityUsedTimes)
	end
end

function ServiceUserEventProxy:RecvUpdateActivityCnt(data) 
	local purchaseActivityInfo = data.info
	local activityID = purchaseActivityInfo.activityid
	local activityUsedTimes = purchaseActivityInfo.count
	UIModelZenyShop.Ins():SetActivityUsedTimes(activityID, activityUsedTimes)

	self:Notify(ServiceEvent.UserEventUpdateActivityCnt, data)
	EventManager.Me():PassEvent(ServiceEvent.UserEventUpdateActivityCnt, data)
end

function ServiceUserEventProxy:RecvDieTimeCountEventCmd(data)
	MyselfProxy.Instance:HandleRelieveCd(data)
	self:Notify(ServiceEvent.UserEventDieTimeCountEventCmd, data)
end

function ServiceUserEventProxy:RecvNtfVersionCardInfo(data)
	UIModelZenyShop.Ins():SetEPVIPCards(data.info)

	self:Notify(ServiceEvent.UserEventNtfVersionCardInfo, data)
end

function ServiceUserEventProxy:RecvChargeQueryCmd(data) 
	self:Notify(ServiceEvent.UserEventChargeQueryCmd, data)
	EventManager.Me():PassEvent(ServiceEvent.UserEventChargeQueryCmd, data)
end