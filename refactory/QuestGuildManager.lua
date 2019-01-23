QuestGuildManager = class("QuestGuildManager")

local tempArray = {}

function QuestGuildManager:ctor()
	self.deltaTime = 0
	self.questMap = {}
end

function QuestGuildManager:RemoveQuestEffect(id)	
	self.questMap[id] = nil
end

function QuestGuildManager:RemoveAllQuestEffect()	
	self:_Destroy()
end

function QuestGuildManager:AddQuestEffect(questData)
	self.questMap[questData.id] = questData
end

function QuestGuildManager:Update(time, deltaTime)

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
	if(not GuildProxy.Instance:IHaveGuild())then
		TableUtility.TableShallowCopy(tempArray,self.questMap)
		self:RemoveAllQuestEffect()
	else
		for k,v in pairs(self.questMap) do
				-- helplog("IHaveGuild",v.time,serverT)
			if(v.time <= serverT )then
				tempArray[v.id] = v
				self:RemoveQuestEffect(v.id)
				QuestProxy.Instance:tryRemoveQuestId(v.id)
			end
		end
	end
	if(next(tempArray))then
		GameFacade.Instance:sendNotification(QuestEvent.RemoveGuildQuestList,tempArray)
	end
	
	GameFacade.Instance:sendNotification(QuestEvent.UpdateGuildQuestList,self.questMap)
end

function QuestGuildManager:_Destroy()	
	TableUtility.TableClear(self.questMap)
end