WholeQuestData = class("WholeQuestData")
function WholeQuestData:ctor(questId,time,map,complete,trace,detailList)
	if(questId)then	
		self:update(questId,time,map,complete,trace,detailList)
	end
end

function WholeQuestData:setQuestData(questData )
	-- body
	self:update(questData.id,questData.time,questData.map,questData.complete,questData.trace,questData.details)
end

function WholeQuestData:update(questId,time,map,complete,trace,detailList )
	-- body
	self.questId = questId
	self.time = time
	self.map = map
	self.complete = complete
	self.trace = trace
	self.detailList = {}
	if(detailList and #detailList >0)then
		for i=1,#detailList do
			table.insert(self.detailList,detailList[i])
		end
	end	
	
	local questData = QuestProxy.Instance.sameQuestDatas[questId]
	if(not questData)then
		printRed("error!!!!!!questID don't exit in table_Quest:"..questId)
		return
	end
	for k,v in pairs(questData) do
		self.questName = v[1].QuestName
		self.type = v[1].Type
		break
	end
	self.orderId = questData.id
	local mapData = Table_Map[map]
	if(mapData)then
		self.mapName = Table_Map[map].NameZh
	else
		if(map)then
			self.mapName = "can't find mapData by mapId:"..map.." in questId:"..questId
		else
			self.mapName = "mapId is nil id questId:"..questId
		end
	end
end