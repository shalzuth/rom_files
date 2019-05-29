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
  self:AddClickEvent(self.getRewardBtn, function()
    self:GetReward()
  end)
end
function TutorTaskCell:InitShow()
  local studentGrid = self:FindGO("StudentGrid"):GetComponent(UIGrid)
  self.studentCtl = UIGridListCtrl.new(studentGrid, TutorTaskRewardCell, "TutorTaskRewardCell")
  local tutorGrid = self:FindGO("TutorGrid"):GetComponent(UIGrid)
  self.tutorCtl = UIGridListCtrl.new(tutorGrid, TutorTaskRewardCell, "TutorTaskRewardCell")
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
