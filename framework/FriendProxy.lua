autoImport("SocialData")
autoImport("SocialRecallData")

FriendProxy = class('FriendProxy', pm.Proxy)
FriendProxy.Instance = nil;
FriendProxy.NAME = "FriendProxy"

FriendProxy.PresentMode=
{
	Exchange=1,	-- 交易所赠送
	Lottery=2,	-- 扭蛋盒赠送
}

function FriendProxy:ctor(proxyName, data)
	self.proxyName = proxyName or FriendProxy.NAME
	if(FriendProxy.Instance == nil) then
		FriendProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function FriendProxy:Init()
	self.FriendData = {}
	self.ApplyData = {}
	self.SearchData = {}
	self.blacklistData = {}
	self.foreverBlacklistData = {}
	self.blacklist = {}
	self.recentTMember = {}
	self.contractData = {}
	self.recallList = {}
end

function FriendProxy:CallAddFriend(friendGuid)
	local count = #self.FriendData + #friendGuid
	if count > GameConfig.Social.maxfriend then
		MsgManager.ShowMsgByID(429)
		return
	end

	for i=1,#friendGuid do
		local guid = friendGuid[i]
		if Game.Myself.data.id == guid then
			MsgManager.ShowMsgByID(416)
			return
		end

		if self:IsFriend(guid) then
			MsgManager.ShowMsgByID(417)
			return
		end
	end

	ServiceSessionSocialityProxy.Instance:CallAddRelation(friendGuid, SocialManager.PbRelation.Friend)
end

function FriendProxy:_AddData(array, data)
	if not self:IsInTable(array, data.guid) then
		TableUtility.ArrayPushBack(array, data)
	end
end

function FriendProxy:_RemoveData(array, guid)
	for i=1, #array do
		if array[i].guid == guid then
			table.remove(array, i)
			return i
		end
	end
	return 0
end

--好友名册
function FriendProxy:AddFriend(socialData)
	self:_AddData(self.FriendData, socialData)

	local scenePlayer = NSceneUserProxy.Instance:Find(socialData.guid)
	if scenePlayer then
		scenePlayer:OnAvatarPriorityChanged()
	end
end

function FriendProxy:SetPresentMode(type)
	self.presentMode=type
end

function FriendProxy:GetPresentMode()
	if(not self.presentMode)then
		return FriendProxy.PresentMode.Exchange
	end
	return self.presentMode
end

function FriendProxy:RemoveFriend(guid)
	self:_RemoveData(self.FriendData, guid)	
end

function FriendProxy:SortFriendData()
	self:SortData(self.FriendData, SocialManager.SocialRelation.Friend)
end

function FriendProxy:GetFriendData()
	ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
	return self.FriendData
end

local onlineData = {}
function FriendProxy:GetOnlineFriendData()
	local friendData = self:GetFriendData();
	TableUtility.TableClear(onlineData)
	for i=1,#friendData do
		local data = friendData[i];
		if(data:IsOnline())then
			table.insert(onlineData, data);
		end
	end
	return onlineData;
end

--搜索好友
function FriendProxy:SetSearchData(data)
	self.SearchData = {}
	for i=1,#data.datas do
		local friend = SocialData.CreateAsTable(data.datas[i])
		TableUtility.ArrayPushBack(self.SearchData, friend)
	end
end

function FriendProxy:GetSearchData()
	return self.SearchData
end

function FriendProxy:ClearSearchData()
	for i = #self.SearchData, 1, -1  do
		self.SearchData[i]:Destroy()
		self.SearchData[i] = nil
	end
end

--申请信息
function FriendProxy:AddApply(socialData)
	self:_AddData(self.ApplyData, socialData)
end

function FriendProxy:RemoveApply(guid)
	self:_RemoveData(self.ApplyData, guid)
end

function FriendProxy:SortApplyData()
	if #self.ApplyData > 1 then
		local relation = SocialManager.SocialRelation.Apply
		table.sort(self.ApplyData,function(l,r)
			return l:GetCreatetime(relation) > r:GetCreatetime(relation)
		end)
	end
end

function FriendProxy:GetApplyData()
	return self.ApplyData
end

function FriendProxy:IsFriend(guid)

	for i=1,#self.FriendData do
		if self.FriendData[i].guid == guid then
			return true
		end
	end
	return false

end

function FriendProxy:GetFriendById(guid)
	for i=1,#self.FriendData do
		local data = self.FriendData[i]
		if data.guid == guid then
			return data
		end
	end
end

function FriendProxy:SortData(data, relation)
	if #data > 1 then
		local lcreatetime,rcreatetime
		table.sort(data,function(l,r)
			if l:IsOnline() == r:IsOnline() then
				lcreatetime= l:GetCreatetime(relation)
				rcreatetime = r:GetCreatetime(relation)
				if lcreatetime and rcreatetime then
					return lcreatetime < rcreatetime
				end
			else
				if l.offlinetime and r.offlinetime then
					return l.offlinetime < r.offlinetime
				end
			end
		end)
	end
end

function FriendProxy:IsInTable(table,key)
	local data

	for i=1,#table do
		if table[i].guid == key then
			data = table[i]
		end
	end

	return data
end

-- 最近队友
function FriendProxy:AddRecentTeam(socialData)
	self:_AddData(self.recentTMember, socialData)
end

function FriendProxy:RemoveRecentTeam(guid)
	self:_RemoveData(self.recentTMember, guid)
end

function FriendProxy:SortRecentTeamMember()
	if(#self.recentTMember>1)then
		table.sort(self.recentTMember, function (ta, tb)
			-- 稍后改掉
			return ta.offlinetime<tb.offlinetime;
		end);
	end	
end

function FriendProxy:GetRecentTeamMember()
	ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
	return self.recentTMember
end

-- 黑名单
function FriendProxy:AddBlack(socialData)
	self:_AddData(self.blacklistData, socialData)
end

function FriendProxy:RemoveBlack(guid)
	self:_RemoveData(self.blacklistData, guid)
end

function FriendProxy:SortBlacklistData()
	self:SortData(self.blacklistData, SocialManager.SocialRelation.Black)
end

function FriendProxy:GetBlacklistData()
	return self.blacklistData
end

function FriendProxy:IsInBlacklist(guid)
	local list = self.blacklistData
	if nil ~= list then
		for i=1,#list do
			if list[i].guid == guid then
				return true
			end
		end
	end
	list = self.foreverBlacklistData
	if nil ~= list then
		for i=1,#list do
			if list[i].guid == guid then
				return true
			end
		end
	end
	return false
end

-- 永久黑名单
function FriendProxy:AddForeverBlack(socialData)
	self:_AddData(self.foreverBlacklistData, socialData)
end

function FriendProxy:RemoveForeverBlack(guid)
	self:_RemoveData(self.foreverBlacklistData, guid)
end

function FriendProxy:SortForeverBlacklistData()
	self:SortData(self.foreverBlacklistData, SocialManager.SocialRelation.BlackForever)
end

function FriendProxy:GetForeverBlacklistData()
	return self.foreverBlacklistData
end

-- 获取黑名单+永久黑名单
function FriendProxy:GetBlacklist(isNeedCompleteData)
	if isNeedCompleteData then
		ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
	end

	TableUtility.ArrayClear(self.blacklist)

	for i=1,#self.blacklistData do
		TableUtility.ArrayPushBack(self.blacklist, self.blacklistData[i])
	end
	for i=1,#self.foreverBlacklistData do
		TableUtility.ArrayPushBack(self.blacklist, self.foreverBlacklistData[i])
	end

	return self.blacklist
end

function FriendProxy:IsBlacklist(id)
	local list = self:GetBlacklist()
	for i=1,#list do
		if list[i].guid == id then
			return true
		end
	end

	return false
end

--契约
function FriendProxy:AddContract(socialData)
	self:_AddData(self.contractData, socialData)
end

function FriendProxy:RemoveContract(guid)
	self:_RemoveData(self.contractData, guid)
end

function FriendProxy:AddContractResult(guid, success)
	if success then
		MsgManager.ShowMsgByID(3619, Game.SocialManager:GetName(guid))
	else
		for i=1,#self.recallList do
			if self.recallList[i].guid == guid then
				table.remove(self.recallList, i)
				return
			end
		end
		
		MsgManager.ShowMsgByID(3618)
	end
end

function FriendProxy:GetContractData()
	return self.contractData
end

--被召回列表
function FriendProxy:RecvQueryRecallListSocialCmd(data)
	TableUtility.ArrayClear(self.recallList)
	for i=1,#data.items do
		local recall = SocialRecallData.new(data.items[i])
		TableUtility.ArrayPushBack(self.recallList, recall)
	end
end

function FriendProxy:ClearRecallList()
	TableUtility.ArrayClear(self.recallList)
end

function FriendProxy:GetRecallList()
	return self.recallList
end

function FriendProxy:SetRecallActivity(data)
	if data.type == GameConfig.Recall.ActivityType then
		self.isRecallActivity = data.open
	end
end

function FriendProxy:CheckRecallActivity()
	return self.isRecallActivity
end