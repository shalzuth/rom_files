UIAchievementPopupTipView = class('UIAchievementPopupTipView', BaseView)

function UIAchievementPopupTipView:ctor()
	
end

function UIAchievementPopupTipView:Init()
	if self.uiWidget ~= nil then
		self.uiWidget.alpha = 0
	end
end

function UIAchievementPopupTipView:SetGameObject(game_object)
	self.gameObject = game_object
end

function UIAchievementPopupTipView:GetGameObjects()
	self.uiWidget = self.gameObject:GetComponent(UIWidget)
	local tempGO = self:FindGO('Icon', self.gameObject)
	self.goIcon = self:FindGO('Icon', tempGO)
	self.spIcon = self.goIcon:GetComponent(UISprite)
	self.goName = self:FindGO('Name', self.gameObject)
	--todo xde
	local l = self.goName:GetComponent(UILabel)
	l.fontSize = 20
	OverseaHostHelper:FixLabelOverV1(l,3,200)
	self.labName = self.goName:GetComponent(UILabel)
	self.goDetail = self:FindGO('Detail', self.gameObject)
	self.labDetail = self.goDetail:GetComponent(UILabel)
	--todo xde
	self.labDetail.fontSize = 20
	self.goButtonClose = self:FindGO('BTN_Close', self.gameObject)
	self.goReward = self:FindGO('Reward', self.gameObject)
	self.spReward1 = self:FindGO('1', self.goReward):GetComponent(UISprite)
	self.spReward2 = self:FindGO('2', self.goReward):GetComponent(UISprite)
	self.spReward3 = self:FindGO('3', self.goReward):GetComponent(UISprite)
	self.tabSpReward = {}
	table.insert(self.tabSpReward, self.spReward1)
	table.insert(self.tabSpReward, self.spReward2)
	table.insert(self.tabSpReward, self.spReward3)
end

function UIAchievementPopupTipView:SetAchievementConfID(achievement_conf_id)
	self.achievementConfID = achievement_conf_id
end

function UIAchievementPopupTipView:GetModelSet()
	self.achievementConf = Table_Achievement[self.achievementConfID]
end

function UIAchievementPopupTipView:LoadView()
	if self.spIcon ~= nil then
		local atlasGroupName = self.achievementConf.Atlas
		if atlasGroupName ~= nil and string.len(atlasGroupName) > 0 then
			local atlasesPath = UIAtlasConfig.IconAtlas[atlasGroupName]
			if atlasesPath ~= nil then
				local spriteName = self.achievementConf.Icon
				if spriteName ~= nil and string.len(spriteName) > 0 then
					IconManager:SetIcon(spriteName, self.spIcon, atlasesPath)
					self.spIcon:MakePixelPerfect()
				end
			end
		end
	end
	self.labName.text = self.achievementConf.Name
	local combination = self.achievementConf.combination
    -- todo xde start ??????????????????
    combination = OverSea.LangManager.Instance():GetLangByKey(combination)
	local strDetail = string.gsub(combination, '/', '')
	strDetail = string.gsub(strDetail, '%%s', '')
	self.labDetail.text = strDetail
	local rewards = self.achievementConf.RewardItems
	self.spReward1.atlas = nil; self.spReward2.atlas = nil; self.spReward3.atlas = nil
	for i = 1, #rewards do
		local spReward = self.tabSpReward[i]
		local reward = rewards[i]
		local itemConfID = reward[1]
		local itemConf = Table_Item[itemConfID]
		local itemType = itemConf.Type
		if itemType == 10 then
			local ui1Atlas = RO.AtlasMap.GetAtlas('NewUI1')
			spReward.atlas = ui1Atlas
			spReward.spriteName = 'Adventure_icon_badge'
			spReward.width = 28; spReward.height = 36
		else
			IconManager:SetItemIcon(itemConf.Icon, spReward)
			spReward.width = 30; spReward.height = 30; 
		end
	end
end

function UIAchievementPopupTipView:Show(achievement_conf_id)
	self:SetAchievementConfID(achievement_conf_id)
	self:GetModelSet()
	self:LoadView()

	if self.timer == nil then
		self.timer = TimeTickManager.Me():CreateTick(0, 100, self.OnTick, self, 1)
	end
	self.timer:StartTick()
	self.fadeInFlag = true
	self.showFlag = false
	self.fadeOutFlag = false
end

function UIAchievementPopupTipView:SetOnComplete(on_complete)
	self.onComplete = on_complete
end

function UIAchievementPopupTipView:ShowStraightly()
	self.uiWidget.alpha = 1
end

function UIAchievementPopupTipView:StopShow()
	local ta = self.gameObject:GetComponent(TweenAlpha)
	ta.value = 0
	if ta ~= nil then
		ta.enabled = false
	end
	self.fadeInFlag = false
	self.showFlag = false
	self.fadeOutFlag = false
end

function UIAchievementPopupTipView:OnTick()
	if self.fadeInFlag then
		local fadeInDuration = 1
		local originAlpha = 0
		local destinationAlpla = 1
		self.uiWidget.alpha = originAlpha
		local ta = TweenAlpha.Begin(self.gameObject, fadeInDuration, destinationAlpla)
		ta:SetOnFinished(function ()
			self.showFlag = true
		end)
		self.fadeInFlag = false
	elseif self.showFlag then
		local showDuration = 3
		local destinationAlpla = 1
		local ta = TweenAlpha.Begin(self.gameObject, showDuration, destinationAlpla)
		ta:SetOnFinished(function ()
			self.fadeOutFlag = true
		end)
		self.showFlag = false
	elseif self.fadeOutFlag then
		local fadeOutDuration = 1
		local destinationAlpla = 0
		local ta = TweenAlpha.Begin(self.gameObject, fadeOutDuration, destinationAlpla)
		ta:SetOnFinished(function ()
			if self.onComplete ~= nil then
				self.onComplete()
			end
		end)
		self.fadeOutFlag = false
		self.timer:StopTick()
	end
end

function UIAchievementPopupTipView:RegisterClickEvent()
	self:AddClickEvent(self.goButtonClose, function (go)
		if(Game.MapManager:Previewing())then
			return;
		end
		self:OnButtonCloseClick()
	end)
	self:AddClickEvent(self.gameObject, function ()
		if(Game.MapManager:Previewing())then
			return;
		end
		self:OnViewClick()
	end)
end

function UIAchievementPopupTipView:OnButtonCloseClick()
	UIViewAchievementPopupTip.Instance:StopShowAchievementPopupTip()
	UIViewAchievementPopupTip.Instance:ShowTopAchievementPopupTip()
end

function UIAchievementPopupTipView:OnViewClick()
	UIViewAchievementPopupTip.Instance:StopShowAchievementPopupTip()
	UIViewAchievementPopupTip.Instance:OpenAchievementDetailUI(self.achievementConfID)
end