RepositoryViewProxy = class('RepositoryViewProxy', pm.Proxy)
RepositoryViewProxy.Instance = nil;
RepositoryViewProxy.NAME = "RepositoryViewProxy"

function RepositoryViewProxy:ctor(proxyName, data)
	self.proxyName = proxyName or RepositoryViewProxy.NAME
	if(RepositoryViewProxy.Instance == nil) then
		RepositoryViewProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

RepositoryViewProxy.Operation = {
	Default=1,
	DepositRepositoryEvt = 2,
	WthdrawnRepositoryEvt = 3,
}

function RepositoryViewProxy:Init()
	self.curOperation=RepositoryViewProxy.Operation.Default
end

function RepositoryViewProxy:SetViewTab(tab)
	self.viewTab = tab
end

function RepositoryViewProxy:GetViewTab()
	return self.viewTab
end

function RepositoryViewProxy:CheckItemExist(bagType,itemId)
	if bagType == nil or itemId == nil then
		return false
	end

	local bagItems
	if bagType == BagProxy.BagType.MainBag then
		bagItems = BagProxy.Instance.bagData:GetItems()
	elseif bagType == BagProxy.BagType.PersonalStorage then
		bagItems = BagProxy.Instance:GetPersonalRepositoryBagData():GetItems()
	elseif bagType == BagProxy.BagType.Storage then
		bagItems = BagProxy.Instance:GetRepositoryBagData():GetItems()
	end

	if bagItems then
		for i=1,#bagItems do
			if bagItems[i].id == itemId then
				return true
			end
		end
	end

	return false
end

function RepositoryViewProxy:CheckData(data)
	if data == nil then
		return false
	end
	if data == BagItemEmptyType.Empty then
		return false
	end
	if data == BagItemEmptyType.Grey then
		return false
	end

	return true
end

--是否可以取出
function RepositoryViewProxy:CanTakeOut()
	if self.viewTab == RepositoryView.Tab.CommonTab and 
		not UIModelMonthlyVIP.Instance():AmIMonthlyVIP() then
		return MyselfProxy.Instance:RoleLevel() >= GameConfig.Item.store_takeout_baselv_req
	end
	return true	
end