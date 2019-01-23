
local baseCell = autoImport("BaseCell")
AchievementSocialCell = class("AchievementSocialCell",baseCell)

function AchievementSocialCell:Init()
	self:initView()	
end

function AchievementSocialCell:initView(  )
	-- body
	self.content = self.gameObject:GetComponent(UILabel)
end

function AchievementSocialCell:SetData(data)
	-- self.level.text = data:GetLevelText()
	local text = ""

	if(data.id == AdventureAchievementPage.SocialIDPair.max_team and #data.value>0)then
		for i=1,#data.value do
			local single = data.value[i]
			if(text == "")then
				text = single
			else
				text = text.."、"..single
			end
		end
		text = string.format(ZhString.AdventureAchievePage_Max_team,text)
	elseif(data.id == AdventureAchievementPage.SocialIDPair.max_hand and #data.value>0)then
		text = string.format(ZhString.AdventureAchievePage_Max_hand,data.value[1]) 
	elseif(data.id == AdventureAchievementPage.SocialIDPair.max_wheel and #data.value>0)then
		text = string.format(ZhString.AdventureAchievePage_Max_wheel,data.value[1]) 
	elseif(data.id == AdventureAchievementPage.SocialIDPair.max_chat and #data.value>0)then
		text = string.format(ZhString.AdventureAchievePage_Max_chat,data.value[1]) 
	elseif(data.id == AdventureAchievementPage.SocialIDPair.max_music and #data.value>0)then
		text = string.format(ZhString.AdventureAchievePage_Max_music,data.value[1]) 
	elseif(data.id == AdventureAchievementPage.SocialIDPair.max_save and #data.value>0)then
		text = string.format(ZhString.AdventureAchievePage_Max_save,data.value[1]) 
	elseif(data.id == AdventureAchievementPage.SocialIDPair.max_besave and #data.value>0)then
		text = string.format(ZhString.AdventureAchievePage_Max_besave,data.value[1])
	end
	self.content.text = text
end
