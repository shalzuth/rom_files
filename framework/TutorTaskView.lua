autoImport("TutorTaskCell")
TutorTaskView = class("TutorTaskView", ContainerView)
TutorTaskView.ViewType = UIViewType.PopUpLayer
local emptyList = {}
local pos = LuaVector3.zero
function TutorTaskView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end
function TutorTaskView:FindObj()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.empty = self:FindGO("Empty")
  self.proficiencyTip = self:FindGO("ProficiencyTip"):GetComponent(UILabel)
  self.loading = self:FindGO("Loading")
end
function TutorTaskView:AddButtonEvt()
end
function TutorTaskView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.TutorTutorTaskUpdateNtf, self.UpdateView)
  self:AddListenEvt(ServiceEvent.TutorTutorTaskQueryCmd, self.RecvTutorTaskQuery)
  self:AddListenEvt(ServiceEvent.TutorTutorTaskTeacherRewardCmd, self.UpdateView)
end
function TutorTaskView:InitShow()
  local container = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 5,
    cellName = "TutorTaskCell",
    control = TutorTaskCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  local viewdata = self.viewdata.viewdata
  if viewdata ~= nil then
    self.ownerGuid = viewdata
    local socialData = Game.SocialManager:Find(viewdata)
    if socialData ~= nil then
      self.title.text = string.format(ZhString.Tutor_TaskTitle, socialData.name)
      self.proficiencyTip.gameObject:SetActive(false)
    end
  else
    self:UpdateProficiency()
  end
  local guid = self.ownerGuid or Game.Myself.data.id
  self.isQueryTask = TutorProxy.Instance:CallTutorTaskQueryCmd(guid)
  self.loading:SetActive(self.isQueryTask)
  self:UpdateView()
end
function TutorTaskView:UpdateView()
  if self.ownerGuid == nil then
    local isFull = TutorProxy.Instance:GetTutorProfic() >= GameConfig.Tutor.max_proficiency
    if not isFull then
      self:UpdateTask(Game.Myself.data.id)
    else
      self.itemWrapHelper:UpdateInfo(emptyList)
    end
    self.empty:SetActive(isFull)
  else
    self:UpdateTask(self.ownerGuid)
  end
end
function TutorTaskView:UpdateTask(guid)
  if self.isQueryTask then
    return
  end
  if guid ~= nil then
    local data = TutorProxy.Instance:GetTutorTaskItems(guid)
    if data then
      self.itemWrapHelper:UpdateInfo(data)
    end
  end
end
function TutorTaskView:UpdateProficiency()
  local proficiency = TutorProxy.Instance:GetTutorProfic()
  self.proficiencyTip.text = string.format(ZhString.Tutor_TaskProficiency, TutorProxy.Instance:GetProficiency(proficiency))
end
function TutorTaskView:RecvTutorTaskQuery(note)
  local data = note.body
  if data then
    self.isQueryTask = false
    self.loading:SetActive(false)
    self:UpdateView()
  end
end
