QuestCountDownManager = class("QuestCountDownManager")

local tempArray = {}

function QuestCountDownManager:ctor()
	self.deltaTime = 0
	self.questMap = {}
end

function QuestCountDownManager:RemoveQuestEffect(id)	
	self.questMap[id] = nil
end

function QuestCountDownManager:RemoveAllQuestEffect()	
	self:_Destroy()
end

function QuestCountDownManager:AddQuestEffect(questData)
	self.questMap[questData.id] = questData
end

function QuestCountDownManager:Update(time, deltaTime)

	if(not next(self.questMap))then
		return
	end
	if(self.deltaTime < 2 and deltaTime)then
		self.deltaTime = self.deltaTime +deltaTime
		return
	end
	-- helplog("time:"..tostring(time).." deltaTime:"..tostring(deltaTime))
	
	self.deltaTime = 0
	local serverT = ServerTime.CurServerTime()/1000
	TableUtility.TableClear(tempArray)
	for k,v in pairs(self.questMap) do
			-- helplog("IHaveGuild",v.time,serverT)
		if(v.time <= serverT )then
			tempArray[v.id] = v
			self:RemoveQuestEffect(v.id)
			QuestProxy.Instance:tryRemoveQuestId(v.id)
		end
	end
	if(next(tempArray))then
		GameFacade.Instance:sendNotification(QuestEvent.RemoveGuildQuestList,tempArray)
	end
	
	GameFacade.Instance:sendNotification(QuestEvent.UpdateGuildQuestList,self.questMap)
end

function QuestCountDownManager:_Destroy()	
	TableUtility.TableClear(self.questMap)
end