GuidePanel = class("GuidePanel", BaseView)
GuidePanel.ViewType = UIViewType.GOGuideLayer
function GuidePanel:Init()
  self:initView()
  self:addViewListener()
  self:initData()
end
function GuidePanel:initView()
  self.des = self:FindGO("des"):GetComponent(UILabel)
end
function GuidePanel:addViewListener()
  self:AddButtonEvent("ConfirmBtn", function()
    if self.questData and self.questData.staticData then
      local questData = self.questData
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      self.isSuccess = true
      self:CloseSelf()
    else
      printRed("questData or FailJump is nil")
    end
  end)
end
function GuidePanel:initData()
  if self.viewdata.viewdata then
    self.questData = self.viewdata.viewdata.questData
    self.des.text = self.questData.params.text
    xdlog(self.questData.params.text, string.len(self.questData.params.text))
    if string.len(self.questData.params.text) > 70 then
      self:HandleLongText()
    end
  else
    printRed("questData is nil")
  end
  self.isSuccess = false
end
function GuidePanel:OnExit()
  GuidePanel.super.OnExit(self)
  if not self.isSuccess then
    if self.questData and self.questData.staticData.FailJump then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
    else
      printRed("quest faild questData or FailJump is nil")
    end
  end
end
function GuidePanel:HandleLongText()
  self.des.fontSize = 19
  self.des.transform.localPosition = Vector3(-141, 45, 0)
  self.des.spacingY = 8
  local btn = self:FindGO("ConfirmBtn")
  btn.transform.localPosition = Vector3(171, -112, 0)
end
