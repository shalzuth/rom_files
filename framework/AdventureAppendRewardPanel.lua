AdventureAppendRewardPanel = class("AdventureAppendRewardPanel", ContainerView)
autoImport("AdventureAppendView")
AdventureAppendRewardPanel.ViewType = UIViewType.PopUpLayer

function AdventureAppendRewardPanel:Init()
	self:initView()	
	self:initData()
	self:addViewEventListener()	
end

function AdventureAppendRewardPanel:initData(  )
	-- body
	local appendData = self.viewdata.viewdata
	self.appendView:SetData(appendData)
end

function AdventureAppendRewardPanel:initView(  )
	-- body
	-- self.titleName = self:FindGO("Label",self:FindGO("panelTitle")):GetComponent(UILabel)
	self.appendView = AdventureAppendView.new(self)
	local rewardLabel = self:FindGO("rewardLabel"):GetComponent(UILabel)
	rewardLabel.text = ZhString.AdventureAppendRewardPanel_Reward
end

function AdventureAppendRewardPanel:addViewEventListener(  )
	-- body
	self:AddButtonEvent("rewardBtn",function ( obj )
	-- body
		if(self.appendView.data)then
			ServiceSceneManualProxy.Instance:CallGetQuestReward(self.appendView.data.staticId)
		end
		self:CloseSelf()
	end)
end