autoImport("CompareItemData")

QuickUseProxy = class('QuickUseProxy', pm.Proxy)

QuickUseProxy.Instance = nil;

QuickUseProxy.NAME = "QuickUseProxy"

QuickUseProxy.CommonUseEvent = "QuickUseProxy.CommonUseEvent"

QuickUseProxy.Type={
	Common = 0,
	Quest = 1,
	Equip = 2,
	Fashion = 3,
	Trigger = 4,
	Item = 5,
	CatchPet = 6,
}

function QuickUseProxy:ctor(proxyName, data)
	self.proxyName = proxyName or QuickUseProxy.NAME
	if(QuickUseProxy.Instance == nil) then
		QuickUseProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function QuickUseProxy:Init()
	self.priorityQueues = {}
	self.fashionsMap = {}
	self.betterEquipsMap = {}
	self.itemUse = {}
	self.priorityQueues[1] = {}
	self.priorityQueues[2] = {}
end

function QuickUseProxy:GetFirstNotEmptyQueue()
	for i=1,#self.priorityQueues do
		if(#self.priorityQueues[i]>0) then
			return self.priorityQueues[i]
		end
	end
	return self:GetQueue(1)
end

function QuickUseProxy:GetQueue(index,autoCreate)
	autoCreate = autoCreate or true
	local queue = self.priorityQueues[index]
	if(not queue and autoCreate) then
		queue = {}
		self.priorityQueues[index] = queue
	end
	return queue
end

function QuickUseProxy:onRegister()
end

function QuickUseProxy:onRemove()
end

function QuickUseProxy:ContainsFashion(staticID)
	local map = self.fashionsMap[staticID]
	return map~=nil and #map >0 or false
end

function QuickUseProxy:ContainsEquip(item)
	if(item~=nil and item.equipInfo~=nil) then
		local sites = item.equipInfo:GetEquipSite()
		for i=1,#sites do
			local find = self.betterEquipsMap[sites[i]]
			if(find~=nil and find.staticData == item.staticData) then
				return true
			end
		end
	end
	return false
end

--canClose=true/false是否显示关闭按钮,iconStr="xxxx"图标下方的文字,btnStr="YYY"按钮文字,iconType = "itemIcon/npcIcon/skillIcon"选择一个图集
--iconID ="item_100"图集中spritename,ClickCall点击回调
function QuickUseProxy:AddCommonCallBack(data)
	if(data) then
		self:AddQuickDataToQueue(QuickUseProxy.Type.Common,data,2)
		GameFacade.Instance:sendNotification(QuickUseProxy.CommonUseEvent)
	end
end

function QuickUseProxy:AddNeverEquipedFashion(item)
	if(item) then
		local sameFashions = self.fashionsMap[item.staticData.id]
		if(sameFashions==nil) then
			sameFashions = {}
			self.fashionsMap[item.staticData.id] = sameFashions
		end
		if(TableUtil.ArrayIndexOf(sameFashions,item)==0) then
			sameFashions[#sameFashions + 1] = item
			self:AddQuickDataToQueue(QuickUseProxy.Type.Fashion,item.staticData.id,2)
			return true
		end
	end
	return false
end

function QuickUseProxy:AddBetterEquip(item,site)
	if(item) then
		local oldItem = self.betterEquipsMap[site]
		if(item:CompareTo(oldItem)) then
			self:RemoveBetterEquip(oldItem)
			if(item.staticData) then
				local compare = CompareItemData.new(item.id,item.staticData.id)
				compare:SetComparedSite(site)
				self.betterEquipsMap[site] = compare
				self:AddQuickDataToQueue(QuickUseProxy.Type.Equip,compare,2)
				return true
			end
		end
		
	end
	return false
end

function QuickUseProxy:AddItemUse(item)
	if(item) then
		local find = self.itemUse[item.id]
		if(find==nil) then
			self.itemUse[item.id] = item
			self:AddQuickDataToQueue(QuickUseProxy.Type.Item,item,2)
			return true
		end
	end
	return false
end

function QuickUseProxy:AddQuestEnterAreaData(data)
	self:AddQuickDataToQueue(QuickUseProxy.Type.Quest,data,2)
	GameFacade.Instance:sendNotification(QuestEvent.QuestEnterArea)
end

function QuickUseProxy:AddTriggerData(trigger)
	self:AddQuickDataToQueue(QuickUseProxy.Type.Trigger,trigger,1)
	GameFacade.Instance:sendNotification(TriggerEvent.AddTrigger)
end

function QuickUseProxy:AddCatchPetData(npcguid, data)
	if(self.cacheCatchPetMap == nil)then
		self.cacheCatchPetMap = {}
	end

	if(self.cacheCatchPetMap[npcguid] == nil)then
		self.cacheCatchPetMap[npcguid] = data;

		self:AddQuickDataToQueue(QuickUseProxy.Type.CatchPet, data, 1)
		GameFacade.Instance:sendNotification(PetEvent.AddCatchPetBord)
	end
end

function QuickUseProxy:AddQuickDataToQueue(t,data,queueIndex)
	queueIndex = queueIndex or 1
	local queue = self:GetQueue(queueIndex)
	if(queue) then
		local found = 0
		local queueData
		for i=1,#queue do
			queueData = queue[i]
			if(queueData.type == t and queueData.data ==data) then
				found = i
				break
			end
		end
		if(found==0) then
			queue[#queue+1] = {type=t,data=data}
		end
	end
end

function QuickUseProxy:RemoveCommon(data)
	if(data) then
		self:RemoveQuickData(data,2)
		local queue = self:GetQueue(2)
		printOrange(#queue)
	end
	return false
end

function QuickUseProxy:RemoveItemUse(item)
	if(item) then
		local find = self.itemUse[item.id]
		if(find~=nil) then
			item.tempHint = false
			self.itemUse[item.id] = nil
			self:RemoveQuickData(item,2)
			return true
		end
	end
	return false
end

function QuickUseProxy:RemoveBetterEquip(item)
	if(item) then
		local sites = item.equipInfo:GetEquipSite()
		for i=1,#sites do
			local current = self.betterEquipsMap[sites[i]]
			if(current and (current == item or current.id == item.id)) then
				self.betterEquipsMap[sites[i]] = nil
				-- print("remove success")
				self:RemoveQuickData(current,2)
				return true
			end
		end
	end
	return false
end

function QuickUseProxy:RemoveNeverEquipedFashion(item,removeAll)
	if(item) then
		-- print(string.format("移除%s..全部:%s",item,tostring(removeAll)))
		local sameFashions = self.fashionsMap[item]
		if(sameFashions) then
			if(removeAll) then
				sameFashions = {}
				self.fashionsMap[item] = sameFashions
			else
				table.remove(sameFashions, 1)
			end
			if(#sameFashions == 0) then
				self:RemoveQuickData(item,2)
				return true
			end
		end
	end
	return false
end

function QuickUseProxy:RemoveQuestData(data)
	self:RemoveQuickData(data,2)
	GameFacade.Instance:sendNotification(QuestEvent.QuestExitArea,data)
end

function QuickUseProxy:RemoveTrigger(trigger)
	self:RemoveQuickData(trigger,1)
	GameFacade.Instance:sendNotification(TriggerEvent.RemoveTrigger,trigger)
end

function QuickUseProxy:RemoveCatchPetData(npcguid)
	if(self.cacheCatchPetMap == nil)then
		self.cacheCatchPetMap = {}
	end
	
	local data = self.cacheCatchPetMap[npcguid];
	if(data)then
		self.cacheCatchPetMap[npcguid] = nil;

		self:RemoveQuickData(data, 1)
		GameFacade.Instance:sendNotification(PetEvent.RemoveCatchPetBord,npcguid)
	end
end

function QuickUseProxy:RemoveQuickData(data,queueIndex)
	queueIndex = queueIndex or 1
	local queue = self:GetQueue(queueIndex)
	if(queue) then
		local queueData
		local found = 0
		for i=1,#queue do
			queueData = queue[i]
			if(queueData.data ==data) then
				found = i
				break
			end
		end
		if(found~=0) then
			return table.remove(queue, found)
		end
	end
end

