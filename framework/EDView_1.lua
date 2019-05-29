EDView = class("EDView", ContainerView)
EDView.ViewType = UIViewType.SystemOpenLayer
autoImport("Table_ED_Story")
function EDView:Init()
  self.edStoryConfig = {}
  if Table_ED_Story then
    for _, storyData in pairs(Table_ED_Story) do
      if storyData.Chapter == nil or storyData.Chapter == 1 then
        table.insert(self.edStoryConfig, storyData)
      end
    end
    table.sort(self.edStoryConfig, function(a, b)
      return a.id < b.id
    end)
  end
  self.stroyLength = #self.edStoryConfig
  self.context = self:FindComponent("Context", UIWidget)
  self.midAnim = self:FindComponent("MidAnim", UIWidget)
  self.midContext = self:FindComponent("Context", UIWidget, self.midAnim.gameObject)
  self.midText = self:FindComponent("Text", UILabel, self.midAnim.gameObject)
  self.mask = self:FindGO("Mask")
  self.jumpButton = self:FindGO("JumpButton")
  self:AddClickEvent(self.jumpButton, function()
    if not self.excuteExit then
      self.excuteExit = true
      ServiceNUserProxy.Instance:ReturnToHomeCity()
    end
  end)
  self.endAnim = self:FindComponent("EndAnim", UIWidget)
  self.endContext = self:FindComponent("Context", UIWidget, self.endAnim.gameObject)
  local lbl = self:FindComponent("Text", UILabel, self.endAnim.gameObject)
  lbl.fontSize = 25
  self:MapEvent()
end
function EDView:OnEnter()
  EDView.super.OnEnter(self)
  Game.HandUpManager:MaunalClose()
  CameraController.singletonInstance.updateCameras = true
  Game.AssetManager_Role:SetForceLoadAll(true)
  self:RemoveLeanTween()
  self.lt = LeanTween.delayedCall(self.gameObject, 13, function()
    self.count = #self.edStoryConfig
    self.midAnim.alpha = 1
    self:RemoveLeanTween()
    self:PlayStoryAnim()
  end)
  Game.AreaTrigger_Mission:Launch()
  Game.AreaTrigger_Common:Launch()
  TimeTickManager.Me():CreateTick(0, 33, self.UpdateAreaTrigger, self, 1)
  self.excuteExit = false
end
local AreaTriggerManager = Game.AreaTriggerManager
function EDView:UpdateAreaTrigger()
  if not AreaTriggerManager.running then
    AreaTriggerManager.atMission:Update(Time.time, Time.deltaTime)
    AreaTriggerManager.atCommon:Update(Time.time, Time.deltaTime)
  end
end
function EDView:PlayStoryAnim()
  local index = self.stroyLength + 1 - self.count
  local storyData = self.edStoryConfig[index]
  if storyData then
    self.midText.text = storyData.Text
    self:DisPlayWidgetAnim(self.midContext, storyData.FadeinTime, storyData.StayTime, storyData.FadeOutTime, function()
      self.count = self.count - 1
      if self.count > 0 then
        self:PlayStoryAnim()
      else
        self.midAnim.alpha = 0
        self:DisPlayEndAnim()
      end
    end)
  end
end
function EDView:DisPlayWidgetAnim(uiWidget, showTime, stayTime, hideTime, endCall)
  self:RemoveLeanTween()
  local go = uiWidget.gameObject
  self.lt = LeanTween.value(go, function(v)
    uiWidget.alpha = v
  end, 0, 1, showTime):setOnComplete(function()
    self:RemoveLeanTween()
    self.lt = LeanTween.delayedCall(go, stayTime, function()
      self:RemoveLeanTween()
      self.lt = LeanTween.value(go, function(v)
        uiWidget.alpha = v
      end, 1, 0, hideTime):setDestroyOnComplete(true):setOnComplete(function()
        self:RemoveLeanTween()
        if endCall then
          endCall()
        end
      end)
    end):setDestroyOnComplete(true)
  end):setDestroyOnComplete(true)
end
function EDView:RemoveLeanTween()
  if self.lt then
    self.lt:cancel()
  end
  self.lt = nil
end
function EDView:DisPlayEndAnim()
  self:RemoveLeanTween()
  self.lt = LeanTween.delayedCall(35, function()
    self.mask:SetActive(true)
    self:RemoveLeanTween()
    local uisprite = self.mask:GetComponent(UISprite)
    uisprite.alpha = 0
    self.lt = LeanTween.value(self.gameObject, function(v)
      uisprite.alpha = v
    end, 0, 1, 1):setOnComplete(function()
      self:RemoveLeanTween()
    end):setDestroyOnComplete(true)
  end)
end
function EDView:MapEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
  self:AddListenEvt(EDViewEvent.ActiveLuPinWord, self.ActiveLuPinWord)
end
function EDView:ActiveLuPinWord(note)
  local active = note.body
  self.midAnim.gameObject:SetActive(active == true)
end
function EDView:HandleMapChange(note)
  if note.type == LoadSceneEvent.FinishLoad then
    if Game.MapManager:GetMapID() ~= 10005 then
      self:CloseSelf()
    end
  elseif note.type == LoadSceneEvent.FinishLoad then
  end
end
function EDView:OnExit()
  EDView.super.OnExit(self)
  self:RemoveLeanTween()
  CameraController.singletonInstance.updateCameras = false
  Game.AssetManager_Role:SetForceLoadAll(false)
  TimeTickManager.Me():ClearTick(self)
  Game.HandUpManager:MaunalOpen()
end
