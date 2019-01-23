AdventureAppendView = class("AdventureAppendView", SubView)
autoImport("AdventureAppendRewardCell")

function AdventureAppendView:Init()
	self:initView()	
end

function AdventureAppendView:initView(  )
	-- body
	-- self.titleName = self:FindGO("Label",self:FindGO("panelTitle")):GetComponent(UILabel)

	local normalGrid = self:FindGO("normalGrid"):GetComponent(UIGrid)
	self.rewardList = UIGridListCtrl.new(normalGrid,AdventureAppendRewardCell,"AdventureAppendRewardCell")
	self.appendTarget = self:FindGO("appendTarget"):GetComponent(UILabel)
	self.appendTargetDes = self:FindGO("appendTargetDes"):GetComponent(UILabel)	
end

function AdventureAppendView:SetData( data )
	-- body
	self.data = data
	if(self.data)then
		self.rewardList:ResetDatas(data:getRewardItems())
		self.appendTarget.text = ZhString.AdventureAppendRewardPanel_AppendTarget
		self.appendTargetDes.text = data:getProcessInfo()		
	end
end
