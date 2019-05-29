local MainView = class("MainView", ContainerView)
MainView.ViewType = UIViewType.MainLayer
autoImport("HeadImageData")
autoImport("MainViewSkillPage")
autoImport("MainViewItemPage")
autoImport("MainViewInfoPage")
autoImport("MainViewMenuPage")
autoImport("MainUseEquipPopup")
autoImport("MainViewTeamPage")
autoImport("MainViewHeadPage")
autoImport("EndlessTowerConform")
autoImport("MainViewMiniMap")
autoImport("MainviewRaidTaskPage")
autoImport("MainViewAddTrace")
autoImport("MainViewChatMsgPage")
autoImport("MainViewAutoAimMonster")
autoImport("MainViewTraceInfoPage")
autoImport("MainViewAuctionPage")
autoImport("RaidCountMsg")
autoImport("MainviewActivityPage")
autoImport("MainViewRecallPage")
autoImport("MainviewInteractPage")
autoImport("QuestTraceCell")
autoImport("MainViewPlayerSelectBoard")
autoImport("AdventureItemData")
MainViewShortCutBord = {
  "ShortCutGrid",
  "SkillBord"
}
autoImport("OverseaHostHelper")
function MainView:Init()
  FunctionCDCommand.Me():StartCDProxy(ShotCutItemCDRefresher)
  self:AddSubView("skillShortCutPage", MainViewSkillPage)
  self.infoPage = self:AddSubView("infoPage", MainViewInfoPage)
  self.menuPage = self:AddSubView("menu", MainViewMenuPage)
  self:AddSubView("MainUseEquipPopup", MainUseEquipPopup)
  self:AddSubView("TeamPage", MainViewTeamPage)
  self:AddSubView("HeadPage", MainViewHeadPage)
  self:AddSubView("MainViewItemPage", MainViewItemPage)
  self:AddSubView("MainViewMiniMap", MainViewMiniMap)
  self:AddSubView("MainviewRaidTaskPage", MainviewRaidTaskPage)
  self:AddSubView("MainViewAddTrace", MainViewAddTrace)
  self.chatMsgPage = self:AddSubView("MainViewChatMsgPage", MainViewChatMsgPage)
  self:AddSubView("TraceInfoBord", MainViewTraceInfoPage)
  self:AddSubView("MainviewActivityPage", MainviewActivityPage)
  self.autoAimMonster = self:AddSubView("MainViewAutoAimMonster", MainViewAutoAimMonster)
  self:AddSubView("MainViewRecallPage", MainViewRecallPage)
  if not GameConfig.SystemForbid.Auction then
    self:AddSubView("MainViewAuctionPage", MainViewAuctionPage)
  end
  self:AddSubView("MainviewInteractPage", MainviewInteractPage)
  self:AddSubView("MainViewPlayerSelectBoard", MainViewPlayerSelectBoard)
  self.mainBord = self:FindChild("MainBord")
  self.showViews = {}
  self:FindObjs()
  self:AddBtnListener()
  self:MapViewListener()
  self:TestFloat()
  OverseaHostHelper:TryShowQualitySelect()
end
function MainView:TestFloat()
  local testButton = self:FindGO("TestFloat")
  self.index = 0
  self:AddClickEvent(testButton, function(g)
  end)
  self:AddDoubleClickEvent(testButton, function(g)
    self:sendNotification(PVPEvent.PVPDungeonShutDown)
    self:sendNotification(ServiceEvent.FuBenCmdMonsterCountUserCmd, {num = 0})
  end)
end
function MainView:CheckMaskName()
  if FunctionMaskWord.Me():CheckMaskWord(Game.Myself.data.name, GameConfig.MaskWord.PlayerName) then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeNameView
    })
  end
end
function MainView:FindObjs()
  self.topFuncs = self:FindChild("TopRightFunc")
  self.moreBord = self:FindChild("MoreBord")
  self.mapBord = self:FindChild("MapBord")
  self.Anchor_DownLeft = self:FindGO("Anchor_DownLeft")
  self.raidMsgRoot = self:FindGO("RaidMsgPos")
  self.questTraceBoard = self:FindGO("QuestTraceBoard")
  self.questTraceBoardCell = QuestTraceCell.new(self.questTraceBoard)
  self:AddButtonEvent("QuestTraceClickDisappear", function()
    self.questTraceBoard:SetActive(false)
  end)
end
function MainView:SetMainViewState(stateIndex)
  if stateIndex == 1 then
    self.moreBord:SetActive(false)
    self.mapBord:SetActive(false)
  end
end
function MainView:OnEnter()
  MainView.super.OnEnter(self)
end
function MainView:OnExit()
  MainView.super.OnExit(self)
  FunctionCDCommand.Me():GetCDProxy(ShotCutItemCDRefresher):RemoveAll()
end
function MainView:AddBtnListener()
  self.showskill = false
  self:AddButtonEvent("changeBtn", function(go)
    local key = self.showskill and "skill" or "func"
    self.showskill = not self.showskill
  end)
end
function MainView:MapViewListener()
  self:AddListenEvt(UIEvent.EnterView, self.HandleEnterView)
  self:AddListenEvt(UIEvent.ExitView, self.HandleExitView)
  self:AddListenEvt(MainViewEvent.ShowOrHide, self.HandleShowOrHide)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.UpdateQuestTraceBorad)
  self:AddListenEvt(QuestEvent.ProcessChange, self.UpdateQuestTraceBorad)
  self:AddListenEvt(QuestEvent.QuestDelete, self.questDelete)
  self:AddListenEvt(MainViewEvent.ActiveShortCutBord, self.HandleActiveShortCutBord)
  EventManager.Me():AddEventListener(SystemMsgEvent.RaidAdd, self.OnRaidMsg, self)
  EventManager.Me():AddEventListener(SystemMsgEvent.RaidRemove, self.RemoveRaidMsg, self)
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.SceneLoadHandler, self)
  EventManager.Me():AddEventListener(QuestManualEvent.BeforeGoClick, self.ShowQuestTraceBorad, self)
end
function MainView:SceneLoadHandler()
  self:RemoveRaidMsg()
end
function MainView:OnRaidMsg(evt)
  local data = evt.data
  if self.raidMsg == nil then
    self.raidMsg = RaidCountMsg.new(self.raidMsgRoot)
  end
  self.raidMsg:SetData(data)
end
function MainView:RemoveRaidMsg()
  if self.raidMsg then
    self.raidMsg:Exit()
    self.raidMsg = nil
  end
end
function MainView:HandleActiveShortCutBord(note)
  local active = note.body == true
  self:ActiveShortCutBord(active)
end
function MainView:ActiveShortCutBord(b)
  for i = 1, #MainViewShortCutBord do
    local go = self:FindGO(MainViewShortCutBord[i])
    if go then
      go:SetActive(b)
    end
  end
end
function MainView:HandleTopFuncActive(note)
  local data = note.body
  if data == nil then
    return
  end
  if note.type == LoadSceneEvent.FinishLoad then
    self.topFuncs:SetActive(data.dmapID == 0)
    self:SetMainViewState(1)
  end
end
function MainView:HandleShowOrHide(note)
  self:ShowOrHideBord(note.body)
  if note.body == true then
    self.chatMsgPage:OnShow()
  end
end
function MainView:HandleEnterView(note)
  local enterView = note.body
  if enterView.ViewType.hideMainView then
    self.showViews[enterView.ViewType.depth] = enterView
    for k, v in pairs(self.showViews) do
      if v ~= nil then
        self:ShowOrHideBord(false)
        return
      end
    end
  end
end
function MainView:HandleExitView(note)
  local exitView = note.body
  if exitView.ViewType.hideMainView then
    self.showViews[exitView.ViewType.depth] = nil
    local needShow = true
    for k, v in pairs(self.showViews) do
      if v ~= nil then
        needShow = false
      end
    end
    self:ShowOrHideBord(needShow)
  end
end
function MainView:ShowOrHideBord(isShow)
  self.mainBord:SetActive(isShow)
  local skillBord = self:FindGO("SkillBord")
  skillBord:SetActive(isShow)
end
function MainView:OnShow()
  if self.viewMap then
    for _, viewCtl in pairs(self.viewMap) do
      if viewCtl and viewCtl.OnShow then
        viewCtl:OnShow()
      end
    end
  end
end
function MainView:ShowQuestTraceBorad(cell)
  self.questTraceBoard:SetActive(true)
  self.questTraceBoardCell:SetData(cell.data.data)
  self.questTraceBoardCell:SetIsMainViewTrace()
  EventManager.Me():DispatchEvent(QuestManualEvent.GoClick, self)
end
function MainView:QuestUpdateTraceBorad(note)
  if self.questTraceBoard.activeSelf then
    local newQuestData = QuestProxy.Instance:getSameQuestID(self.questTraceBoardCell.questId)
    if newQuestData then
      local cellData = {
        questData = newQuestData,
        type = newQuestData.questListType
      }
      self.questTraceBoardCell:SetData(cellData)
    end
  end
end
function MainView:UpdateQuestTraceBorad(note)
  if self.questTraceBoard.activeSelf then
    local data = note.body
    local questId = data.id
    if questId == self.questTraceBoardCell.questId then
      local newQuestData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
      if newQuestData then
        local cellData = {
          questData = newQuestData,
          type = newQuestData.questListType
        }
        self.questTraceBoardCell:SetData(cellData)
      end
    end
  end
end
function MainView:questDelete(note)
  local data = note.body
  for i = 1, #data do
    local single = data[i]
    if single.id == self.questTraceBoardCell.questId then
      self.questTraceBoard:SetActive(false)
      break
    end
  end
end
return MainView
