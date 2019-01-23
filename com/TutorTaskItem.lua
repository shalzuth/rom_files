TutorTaskItem = class("TutorTaskItem")

function TutorTaskItem:ctor(serverData)
	self:ResetData()

	self:UpdateData(serverData)
end

function TutorTaskItem:ResetData()
	self.progress = 0
	self.canReward = false	--导师是否可领奖
end

function TutorTaskItem:UpdateData(serverData)
	if serverData ~= nil then
		if serverData.id ~= nil then
			self.id = serverData.id
		end
		if serverData.progress ~= nil then
			self.progress = serverData.progress
		end
	end
end

function TutorTaskItem:SetId(id, ownId)
	self.id = id
	self.ownId = ownId
end

function TutorTaskItem:SetCanReward(canReward)
	self.canReward = canReward

	--后端缓存没更新
	if self.canReward then
		local staticData = Table_StudentAdventureQuest[self.id]
		if staticData and staticData.Target then
			self.progress = staticData.Target
		end
	end
end

function TutorTaskItem:GetStudentRewardLevel()
	local staticData = Table_StudentAdventureQuest[self.id]
	if staticData ~= nil then
		--处理数据
		local temp = ReusableTable.CreateArray()
		for k,v in pairs(staticData.StudentReward) do
			TableUtility.ArrayPushBack(temp, k)
		end
		table.sort(temp, TutorTaskItem.Sort)

		--等级
		local level = 1
		if self:IsMySelf() then
			level = MyselfProxy.Instance:RoleLevel()
		else
			local socialData = Game.SocialManager:Find(self.ownId)
			if socialData and socialData.level ~= 0 then
				level = socialData.level
			end
		end
		local rewardLevel
		for i=1,#temp do
			if level <= temp[i] then
				rewardLevel = temp[i]
				break
			end
		end
		ReusableTable.DestroyArray(temp)

		return rewardLevel
	end

	return nil
end

function TutorTaskItem.Sort(l,r)
	return l < r
end

function TutorTaskItem:CanTake()
	if self:IsMySelf() then
		return false
	end

	if self.canReward then
		return true
	end

	return false
end

--导师任务是否完成
function TutorTaskItem:IsComplete()
	local staticData = Table_StudentAdventureQuest[self.id]
	if staticData and staticData.Target and self.progress then
		return self.progress >= staticData.Target
	end
end

function TutorTaskItem:IsMySelf()
	return self.ownId == Game.Myself.data.id
end