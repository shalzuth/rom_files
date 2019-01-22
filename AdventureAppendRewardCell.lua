local baseCell = autoImport("BaseCell")
AdventureAppendRewardCell = class("AdventureAppendRewardCell",baseCell)
function AdventureAppendRewardCell:Init()
	self:initView()
	-- self:initData()
end

function AdventureAppendRewardCell:initView(  )
	-- body
	self.RewardIcon = self:FindGO("RewardIcon"):GetComponent(UISprite)
	self.RewardCount = self:FindGO("RewardCount"):GetComponent(UILabel)
	
--	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.RewardCount,3,360)
end

function AdventureAppendRewardCell:SetData( data )
	-- body
	self.data = data
	if(data.type ~= AdventureAppendData.RewardDataType.empty)then
		self.RewardCount.text = data.text
		if(data.type == AdventureAppendData.RewardDataType.normal )then
			-- printRed("AdventureAppendRewardCell,",data.icon)
			IconManager:SetItemIcon(data.icon,self.RewardIcon)
		else
			self.RewardCount.color = Color(116/255,114/255,116/255,1)
		end
		self:Show(self.RewardIcon.gameObject)
		self:Show(self.RewardCount.gameObject)
	else
		self:Hide(self.RewardIcon.gameObject)
		self:Hide(self.RewardCount.gameObject)
	end
end
