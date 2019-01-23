autoImport("TutorTaskRewardCell")

local baseCell = autoImport("BaseCell")
TutorTaskCell = class("TutorTaskCell", baseCell)

function TutorTaskCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
	self:InitShow()
end

function TutorTaskCell:FindObjs()
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.progress = self:FindGO("Progress"):GetComponent(UILabel)
	self.getRewardBtn = self:FindGO("GetRewardBtn")
end

function TutorTaskCell:AddButtonEvt()
	self:AddClickEvent(self.getRewardBtn, function ()
		self:GetReward()
	end)	
end

function TutorTaskCell:InitShow()
	local studentGrid = self:FindGO("StudentGrid"):GetComponent(UIGrid)
	self.studentCtl = UIGridListCtrl.new(studentGrid, TutorTaskRewardCell, "TutorTaskRewardCell")
	--todo xde
	local studentTitle = self:FindGO("StudentTitle"):GetComponent(UILabel)
	local studentGridWidget = studentGrid.gameObject:AddComponent(UIWidget)
	studentGridWidget.leftAnchor.target =  studentTitle.gameObject.transform
	studentGridWidget.leftAnchor.relative = 1
	studentGridWidget.leftAnchor.absolute = 4	


	local tutorGrid = self:FindGO("TutorGrid"):GetComponent(UIGrid)
	self.tutorCtl = UIGridListCtrl.new(tutorGrid, TutorTaskRewardCell, "TutorTaskRewardCell")
	--todo xde
	local tutorTitle = self:FindGO("TutorTitle"):GetComponent(UILabel)
	local tutorGridWidget = tutorGrid.gameObject:AddComponent(UIWidget)
	tutorGridWidget.leftAnchor.target =  tutorTitle.gameObject.transform
	tutorGridWidget.leftAnchor.relative = 1
	tutorGridWidget.leftAnchor.absolute = 4
	
	--todo xde
	local btnSprite = self.getRewardBtn:GetComponent(UISprite)
	btnSprite.width = 80
	btnSprite.height = 38
	btnSprite.transform.localPosition = Vector3(224,-40,0)
	local btnLabel = self:FindGO("Label",btnSprite.gameObject):GetComponent(UILabel)
	btnLabel.fontSize = 16
	btnLabel.transform.localPosition = Vector3(0,2,0)
end

function TutorTaskCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		local staticData = Table_StudentAdventureQuest[data.id]
		if staticData then
			self.title.text = staticData.Traceinfo

			if data:IsComplete() then
				if data.canReward then
					self.progress.text = ZhString.Tutor_TaskFinish
				else
					self.progress.text = ZhString.Tutor_TaskTake
				end
			else
				self.progress.text = string.format(ZhString.Tutor_TaskProgress, data.progress, staticData.Target)
			end

			local rewardLevel = data:GetStudentRewardLevel()
			if rewardLevel ~= nil then
				local studentReward = ItemUtil.GetRewardItemIdsByTeamId(staticData.StudentReward[rewardLevel])
				if studentReward then
					self.studentCtl:ResetDatas(studentReward)
				end	
			end

			local teacherReward = ItemUtil.GetRewardItemIdsByTeamId(staticData.TeacherReward)
			if teacherReward then
				self.tutorCtl:ResetDatas(teacherReward)
			end

			self.getRewardBtn:SetActive(data:CanTake())
		end
	end
end

function TutorTaskCell:GetReward()
	if self.data then
		ServiceTutorProxy.Instance:CallTutorTaskTeacherRewardCmd(self.data.ownId, self.data.id)
	end
end