QuestReward = class("QuestReward")

function QuestReward:ctor(serverData)	
	self.id = serverData.id
	self.count = serverData.count
end