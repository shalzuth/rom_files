local baseCell = autoImport("BaseCell")
AchievementChangeProCell = class("AdventureAchievementCell",baseCell)

function AchievementChangeProCell:Init()
	self:initView()	
end

function AchievementChangeProCell:initView(  )
	-- body
	self.content = self.gameObject:GetComponent(UILabel)
end

function AchievementChangeProCell:SetData(data)
	-- self.level.text = data:GetLevelText()
	local time = data.time
	time = os.date("%Y.%m.%d",time)
	local name = data.name
	self.content.text = string.format(ZhString.AdventureAchievePage_ChangeProfessionInfo,time,name)
end
