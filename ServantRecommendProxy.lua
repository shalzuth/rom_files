autoImport("ServantRecommendItemData")

ServantRecommendProxy = class('ServantRecommendProxy', pm.Proxy)
ServantRecommendProxy.Instance = nil;
ServantRecommendProxy.NAME = "ServantRecommendProxy"

ServantRecommendProxy.STATUS=
{
	GO = SceneUser2_pb.ERECOMMEND_STATUS_GO,			-- ?????????
	RECEIVE = SceneUser2_pb.ERECOMMEND_STATUS_RECEIVE, 	-- ?????????
	FINISHED = SceneUser2_pb.ERECOMMEND_STATUS_FINISH, 	-- ?????????
}

function ServantRecommendProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ServantRecommendProxy.NAME
	if(ServantRecommendProxy.Instance == nil) then
		ServantRecommendProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function ServantRecommendProxy:Init()
	self.rewardStatusMap = {}
	self.classifiedData = {}
end

function ServantRecommendProxy:HandleRecommendData(data)
	if(nil==self.recommendMap)then
		self.recommendMap={}
	end
	TableUtility.TableClear(self.classifiedData)
	local finished = SceneUser2_pb.ERECOMMEND_STATUS_FINISH
	for i=1,#data do
		local cell_data = ServantRecommendItemData.new(data[i])
		if(nil~=cell_data.staticData)then
			local needDel = cell_data.staticData.NeedDel
			if(cell_data.status == finished and needDel and needDel==1)then
				self.recommendMap[cell_data.id] = nil
			else
				self.recommendMap[cell_data.id] = cell_data
			end
		else
			redlog("??????---> ???????????????ID??????recommend?????????????????????id??? ",cell_data.id)
		end
	end
	self.classifiedData[0]={}
	for _,data in pairs(self.recommendMap) do
		TableUtility.ArrayPushBack(self.classifiedData[0],data)
	end
	for id,data in pairs(self.recommendMap) do
		local pageType = data.staticData and data.staticData.PageType
		if(pageType)then
			for i=1,#pageType do
				local singleType = pageType[i]
				if(nil==self.classifiedData[singleType])then
					self.classifiedData[singleType]={}
				end
				TableUtility.ArrayPushBack(self.classifiedData[singleType],data)
			end
		end
	end
end

function ServantRecommendProxy:HandleRewardStatus(data)
	for i=1,#data do
		local serviceItem = data[i]
		-- helplog("ServantRecommendProxy HandleRewardStatus serviceItem.favorability: ",serviceItem.favorability,"status: ",serviceItem.status)
		self.rewardStatusMap[serviceItem.favorability]=serviceItem.status
	end
end

function ServantRecommendProxy:GetRecommendMap()
	return self.recommendMap
end

function ServantRecommendProxy:GetRecommendById(id)
	return self.recommendMap[id]
end

function ServantRecommendProxy:GetRewardStatusMap()
	return self.rewardStatusMap
end

-- 0 ???????????? 1 ????????? 2 ?????????
local rewardCfg = GameConfig.Servant.reward
function ServantRecommendProxy:GetFavorRewardID()
	for i=1,#rewardCfg do
		local cell = rewardCfg[i]
		if(cell and cell.value)then
			if(self.rewardStatusMap[cell.value]==1)then
				return cell.rewardid
			end
		end
	end
	return nil
end

function ServantRecommendProxy:GetRecommendDataByType(t,sort)
	local typeData = self.classifiedData[t]
	if(typeData)then
		if(sort)then
			table.sort(typeData,function (l,r)
				return self:_sortData(l,r)
			end)
		end
	end
	return typeData
end

function ServantRecommendProxy:_sortData(left,right)
	if left == nil or right == nil then 
	   return false 
	end
	local lReceive = left.status == ServantRecommendProxy.STATUS.RECEIVE
	local rReceive = right.status == ServantRecommendProxy.STATUS.RECEIVE

	local lFinished = left.status == ServantRecommendProxy.STATUS.FINISHED
	local rFinished = right.status == ServantRecommendProxy.STATUS.FINISHED

	local lGo = left.status == ServantRecommendProxy.STATUS.GO
	local rGo = right.status == ServantRecommendProxy.STATUS.GO

	local lData = left.staticData
	local rData = right.staticData
	local sameRecycle = lData.Recycle == rData.Recycle

	local lOpen = left:isActiveOpen()
	local rOpen = right:isActiveOpen()

	if(lOpen and rOpen)then
		return lData.id<rData.id
	end
	if(lOpen or rOpen)then
		return lOpen==true
	end
	
	if(lReceive and rReceive)then
		if(sameRecycle)then
			return  lData.id<rData.id
		else
			return lData.Recycle<rData.Recycle
		end 
	end
	if(lReceive or rReceive)then
		return lReceive ==true
	end
	
	if(lGo and rGo)then
		if(sameRecycle)then
			return lData.id<rData.id
		else
			return lData.Recycle<rData.Recycle
		end
	end
	if(lGo or rGo)then
		return lGo==true
	end
	return lData.id<rData.id
end



