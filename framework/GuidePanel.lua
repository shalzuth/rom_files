GuidePanel = class("GuidePanel",BaseView)
GuidePanel.ViewType = UIViewType.GOGuideLayer


function GuidePanel:Init()
  self:initView()
  self:addViewListener()
  self:initData()
end
function GuidePanel:initView(  )
	-- body	
	self.des = self:FindGO("des"):GetComponent(UILabel)
end

function GuidePanel:addViewListener( )
	-- body
	self:AddButtonEvent("ConfirmBtn",function (  )
		-- body
		if(self.questData and self.questData.staticData)then
			local questData = self.questData
			QuestProxy.Instance:notifyQuestState(questData.id,questData.staticData.FinishJump)
			self.isSuccess = true
			self:CloseSelf()
		else
			printRed("questData or FailJump is nil")
		end
	end)
end

function GuidePanel:initData(  )
	-- body	
	if(self.viewdata.viewdata)then
		self.questData = self.viewdata.viewdata.questData
		self.des.text = self.questData.params.text
	else
		printRed("questData is nil")
	end
	self.isSuccess = false
end

function GuidePanel:OnExit()
	-- body	
	GuidePanel.super.OnExit(self)
	if(not self.isSuccess)then
		if(self.questData and self.questData.staticData.FailJump)then
			QuestProxy.Instance:notifyQuestState(self.questData.id,self.questData.staticData.FailJump)
		else
			printRed("quest faild questData or FailJump is nil")
		end
	end
end