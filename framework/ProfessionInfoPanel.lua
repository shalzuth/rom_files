autoImport("ProfessionInfoView")
ProfessionInfoPanel = class("ProfessionInfoPanel",ProfessionInfoView)
ProfessionInfoPanel.ViewType = UIViewType.DialogLayer;

function ProfessionInfoPanel:Init()
	ProfessionInfoPanel.super.Init(self)
	self:AddCloseButtonEvent()
end



function ProfessionInfoPanel:initData(  )
	-- body
	ProfessionInfoPanel.super.initData(self)
	local questId = self.viewdata.questId
	local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
	if(questData)then
		local profession = questData.params.profession
		local pData = Table_Class[profession]
		self.currentPfn = pData
		if(pData == nil)then	
			printRed("the profession id is invalid!!!!!")
			printRed(profession)
			-- self:Hide()
			return
		end
	end
end

function ProfessionInfoPanel:AddCloseButtonEvent()
	local buttonobj = self:FindGO("CloseButton");
	self:Hide(buttonobj)
end