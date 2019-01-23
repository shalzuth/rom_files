TutorGrowthReward = class("TutorGrowthReward")

function TutorGrowthReward:ctor()
	self.id = 0
	self.MaxLevel = 0
	self.Type = 0	--1:成长奖励 2：毕业奖励
	self.StudentReward = 0
	self.canGet = 0	
end

function TutorGrowthReward:SetData(index,data)
	self.id = data.id
	self.MaxLevel = data.MaxLevel
	self.Type = data.Type
	self.StudentReward = data.StudentReward
end

function TutorGrowthReward:UpdateStatus(state)
	self.canGet = state
end