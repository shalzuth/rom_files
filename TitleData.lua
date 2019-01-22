TitleData = class("TitleData")

function TitleData:ctor(type,config)
	-- ??????
	self.titleType=type
	--???id??????????????????id 
	-- ???????????????2 id?????????id ????????????3???id??????id
	self.id = config.id
	self.config = config
	self.groupData = nil
	self.unlocked = false
end

function TitleData:SetGroupData(groupData)
	self.groupData = groupData
end

function TitleData:SetLevelIndex(levelIndex)
	self.levelIndex = levelIndex
end

function TitleData:Unlock(value)
	if(value and self.groupData) then
		self.groupData:ActiveTitle(self)
	end
	if(self.unlocked~= value) then
		self.unlocked = value
		return true
	end
	return false
end

function TitleData:GetActiveID()
	return self.id
end

function TitleData:GetSortID()
	return self.config.TitleSort
end

function TitleData:bVisibilyAchievement()
	local data = Game.Config_TitleAchievemnet[self.id]
	if(data and data.Visibility and data.Visibility==1)then
		return true
	end
	return false
end

function TitleData:GetAchievemnetIDByTitle()
	local data = Game.Config_TitleAchievemnet[self.id]
	if(data)then
		return data.id
	end
	return 0
end


TitleLevelGroupData = class("TitleLevelGroupData",TitleData)

function TitleLevelGroupData:ctor(id)
	self.id = id
	self.titleDatas = {}
	self.activeTitleData = nil
	self.unlocked = false
end

function TitleLevelGroupData:ActiveTitle(titleData)
	if(self.activeTitleData==nil or self.activeTitleData.levelIndex > titleData.levelIndex) then
		self.activeTitleData = titleData
	end
	self.unlocked = true
end

function TitleLevelGroupData:AddTitle(titleData)
	local index = #self.titleDatas+1
	self.titleDatas[index] = titleData
	titleData:SetLevelIndex(index)
end


function TitleLevelGroupData:GetSortID()
	return self.activeTitleData.config.TitleSort
end

function TitleLevelGroupData:GetActiveID()
	return  self.activeTitleData.id
end

function TitleLevelGroupData:GetAchievemnetIDByTitle()
	local data = Game.Config_TitleAchievemnet[self.activeTitleData.id]
	if(data)then
		return data.id
	end
	return 0
end

function TitleLevelGroupData:bVisibilyAchievement()
	local data = Game.Config_TitleAchievemnet[self.activeTitleData.id]
	if(data and data.Visibility and data.Visibility==1)then
		return true
	end
	return false
end


