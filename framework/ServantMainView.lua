autoImport("ServantRecommendView")
autoImport("FinanceView")
autoImport("ServantImproveView")
autoImport("ERProfessionCell")
autoImport("RecommendEquipCell")
autoImport("PetWorkSpaceEmoji")
autoImport("EquipRecommendMainNew")
local waitAnimName = "wait"
ServantMainView = class("ServantMainView", ContainerView)
ServantMainView.ViewType = UIViewType.NormalLayer
local max_favor = GameConfig.Servant.max_favorability
if not GameConfig.Servant.Filter then
  local UI_FLITER = {11, 12}
end
local reusableTable = {}
local path = ResourcePathHelper.UICell("PetWorkSpaceEmoji")
local actionName = {
  "functional_action",
  "functional_action2",
  "functional_action3",
  "Tap",
  "Untap"
}
ServantMainView.ProfessionTypeKey = "ServantMainView_ProfessionTypeKey"
ServantMainView.IsERShowKey = "ServantMainView_IsERShowKey"
function ServantMainView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
  self:InitData()
end
function ServantMainView:InitData()
  self.myId = Game.Myself.data.id
  self:UpdateRecomProfessionList()
  self:UpdateReward()
end
function ServantMainView:FindObjs()
  self.recommendToggle = self:FindGO("RecommendBtn")
  self.financeToggle = self:FindGO("FinanceBtn")
  self.improveToggle = self:FindGO("ImproveBtn")
  self.recommendObj = self:FindGO("recommendView")
  self.financeObj = self:FindGO("financeView")
  self.strenghtenObj = self:FindGO("strengthenView")
  self.improveObj = self:FindGO("improveView")
  self.favorProcess = self:FindComponent("FavorProcess", UILabel)
  self.servantName = self:FindComponent("ServantName", UILabel)
  self.equipRecommend = self:FindGO("EquipRecommend")
  self.erPoplistPanel = self:FindGO("ERPoplistPanel")
  self.equipRecommendMain = self:FindGO("EquipRecommendMain")
  self.selectProfessionName = self:FindComponent("SelectProfessionName", UILabel)
  self.eERPoplist = self:FindComponent("ERPoplist", UISprite)
  self.poplistGrid = self:FindComponent("ERPoplistGrid", UIGrid)
  self.poplistCtl = UIGridListCtrl.new(self.poplistGrid, ERProfessionCell, "ERProfessionCell")
  self.poplistCtl:AddEventListener(MouseEvent.MouseClick, self.ChosseRecomProfession, self)
  self.equipRecommendGrid = self:FindComponent("EquipRecommendGrid", UIGrid)
  self.equipRecommendCtl = UIGridListCtrl.new(self.equipRecommendGrid, RecommendEquipCell, "RecommendEquipCell")
  self.equipRecommendCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEquipItem, self)
  self.triggerShowButtonArrowRight = self:FindGO("TriggerShowButtonArrowRight")
  self.triggerShowButtonArrowLeft = self:FindGO("TriggerShowButtonArrowLeft")
  self:AddButtonEvent("TriggerShowButton", function()
    helplog("=======TriggerShowButton")
    self:TriggerERMainPanel(self.triggerShowButtonArrowLeft.activeSelf)
    self.EquipRecommendMainNewPanel:SelfShow()
  end)
  self.EquipRecommendMainNewPanel = self:AddSubView("EquipRecommendMainNew", EquipRecommendMainNew)
  local isERShow = FunctionPlayerPrefs.Me():GetBool(ServantMainView.IsERShowKey)
  self:TriggerERMainPanel(isERShow)
  self:AddButtonEvent("PopButton", function()
    self.erPoplistPanel:SetActive(not self.erPoplistPanel.activeSelf)
  end)
  self.emojiRoot = self:FindGO("emojiRoot")
  self:Hide(self.emojiRoot)
  self.emoji = self:LoadPreferb_ByFullPath(path, self.emojiRoot)
  self.emoji.transform.localPosition = Vector3.zero
  self.spaceEmoji = PetWorkSpaceEmoji.new(self.emoji)
  self.spaceEmoji:AddEventListener(MouseEvent.MouseClick, self.OnReward, self)
  self.improveToggle:SetActive(true)
  self.equipRecommend:SetActive(true)
end
function ServantMainView:AddViewEvts()
  self:AddListenEvt(SceneUserEvent.SceneAddPets, self.HandleAddNpcs)
  self:AddListenEvt(SceneUserEvent.SceneRemovePets, self.HandleRemoveNpcs)
  self:AddListenEvt(MyselfEvent.ServantFavorChange, self.UpdateFavorAbility)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleEvt)
  self:AddListenEvt(ShortCut.MoveToPos, self.HandleEvt)
  self:AddListenEvt(ServiceEvent.NUserServantRewardStatusUserCmd, self.RecvRewardStatus)
end
function ServantMainView:HandleEvt()
  self:CloseSelf()
end
function ServantMainView:PlayNpcAction(actionName)
  local isMoving = self.npcCreature and self.npcCreature:IsMoving()
  if isMoving then
    return
  end
  local animParams = Asset_Role.GetPlayActionParams(actionName, nil, 1)
  animParams[7] = function()
    animParams = Asset_Role.GetPlayActionParams(waitAnimName, nil, 1)
    self.npc:PlayActionRaw(animParams)
  end
  if self.npc then
    self.npc:PlayActionRaw(animParams)
  end
end
function ServantMainView:UpdateFavorAbility()
  local servantFavor = MyselfProxy.Instance:GetServantFavorability()
  self.favorProcess.text = string.format(ZhString.GuildBuilding_Submit_MatNum, servantFavor, max_favor)
end
function ServantMainView:InitShow()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED, self.recommendToggle, 4, {-5, -5})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_GROWTH, self.improveToggle, 4, {-5, -5})
  self.recommendView = self:AddSubView("ServantRecommendView", ServantRecommendView)
  self.financeView = self:AddSubView("FinanceView", FinanceView)
  self.improveView = self:AddSubView("ServantImproveView", ServantImproveView)
  self:AddTabChangeEvent(self.recommendToggle, self.recommendObj, PanelConfig.ServantRecommendView)
  self:AddTabChangeEvent(self.financeToggle, self.financeObj, PanelConfig.FinanceView)
  self:AddTabChangeEvent(self.improveToggle, self.improveObj, PanelConfig.ServantImproveView)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(PanelConfig.ServantRecommendView.tab)
  end
  local servantID = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
  self.servantName.text = Table_Npc[servantID].NameZh
  self:UpdateFavorAbility()
end
function ServantMainView:TabChangeHandler(key)
  if self.currentKey ~= key then
    ServantMainView.super.TabChangeHandler(self, key)
    if key == PanelConfig.ServantRecommendView.tab then
    elseif key == PanelConfig.FinanceView.tab then
    end
    self.currentKey = key
  end
end
local selfFilter = 12
function ServantMainView:OnEnter()
  FunctionSceneFilter.Me():StartFilter(UI_FLITER)
  ServiceNUserProxy.Instance:CallShowServantUserCmd(true)
  ServantMainView.super.OnEnter(self)
  FunctionSceneFilter.Me():StartFilter(selfFilter)
end
function ServantMainView:OnExit()
  FunctionSceneFilter.Me():EndFilter(UI_FLITER)
  self:RemoveLeanTween()
  ServiceNUserProxy.Instance:CallShowServantUserCmd(false)
  ServantMainView.super.OnExit(self)
  self:CameraReset()
  FunctionSceneFilter.Me():EndFilter(selfFilter)
end
function ServantMainView:HandleAddNpcs(note)
  local npcs = note.body
  if not npcs then
    return
  end
  for _, npc in pairs(npcs) do
    if npc.data and npc.data.ownerID == self.myId then
      self.npc = npc.assetRole
      self.npcCreature = npc
      self:delayFocus(npc.assetRole.completeTransform)
      break
    end
  end
end
function ServantMainView:HandleRemoveNpcs(note)
  local npcs = note.body
  if not npcs then
    return
  end
  for _, npc in pairs(npcs) do
    if "table" == type(npc) and npc.data and npc.data.ownerID == self.myId then
      self.npc = nil
      self.npcCreature = nil
      self:ShowServantEffect()
      self:CloseSelf()
      break
    end
  end
end
function ServantMainView:RemoveLeanTween()
  if self.DelayFocusTwId then
    LeanTween.cancel(self.gameObject, self.DelayFocusTwId)
    self.DelayFocusTwId = nil
  end
end
function ServantMainView:delayFocus(trans)
  self:RemoveLeanTween()
  helplog("delayFocus In")
  local ret = LeanTween.delayedCall(self.gameObject, 0.1, function()
    self.DelayFocusTwId = nil
    local viewPort = CameraConfig.Servant_ViewPort
    local rotation = CameraConfig.Servant_Rotation
    self:CameraFaceTo(trans, viewPort, rotation)
    self:ShowServantEffect()
  end)
  self.DelayFocusTwId = ret.uniqueId
end
function ServantMainView:ChosseRecomProfession(cell)
  if self.currntSelectedPro ~= cell then
    self.currntSelectedPro = cell
    self.selectProfessionName.text = cell.data.genre
    FunctionPlayerPrefs.Me():SetInt(ServantMainView.ProfessionTypeKey, cell.indexInList)
    self:UpdateRecomEquipList(cell)
  end
  self.erPoplistPanel:SetActive(false)
end
function ServantMainView:ClickEquipItem(cell)
  local data = {
    itemdata = cell.data,
    funcConfig = {},
    noSelfClose = false
  }
  self:ShowItemTip(data, cell.itemCell.icon, NGUIUtil.AnchorSide.Right, {210, -220})
end
function ServantMainView:UpdateRecomEquipList(cell)
  TableUtility.TableClear(reusableTable)
  local equipList = cell.data.equip
  for i = 1, #equipList do
    local tempItem = ItemData.new("", equipList[i])
    table.insert(reusableTable, tempItem)
  end
  self.equipRecommendCtl:ResetDatas(reusableTable)
  local cells = self.equipRecommendCtl:GetCells()
  for i = 1, #cells do
    cells[i].gameObject:AddComponent(UIDragScrollView)
    cells[i]:AddCellClickEvent()
  end
end
function ServantMainView:UpdateRecomProfessionList()
  local nowOcc = Game.Myself.data:GetCurOcc()
  if nowOcc.profession ~= 1 then
    local professiondata = Table_Class[nowOcc.profession]
    local branchList = {}
    if professiondata then
      for k, v in pairs(Table_Equip_recommend) do
        if v.branch == professiondata.TypeBranch then
          branchList[#branchList + 1] = v
        end
      end
    end
    self.poplistCtl:ResetDatas(branchList)
    local cells = self.poplistCtl:GetCells()
    self.eERPoplist.height = 37 * #cells + 53
    local choosedProfession = FunctionPlayerPrefs.Me():GetInt(ServantMainView.ProfessionTypeKey, 1)
    if choosedProfession > #branchList then
      choosedProfession = 1
    end
    self:ChosseRecomProfession(cells[choosedProfession])
  else
    self.equipRecommend:SetActive(false)
  end
end
local item = {}
local CONST_GIFT_ID, CONST_GIFT_NUM = 700108, 1
function ServantMainView:RecvRewardStatus(note)
  local items = note.body.items
  local favorState = note.body.stayfavo
  if favorState ~= 0 then
    if favorState == 1 then
    elseif favorState == 2 then
      self:Show(self.emojiRoot)
      self.spaceEmoji:SetFavorData()
      self.isFavorEmoji = true
    elseif favorState == 3 then
      self:PlayNpcAction(actionName[5])
      self:Hide(self.emojiRoot)
    end
  else
    self:UpdateReward()
    self.isFavorEmoji = false
  end
end
function ServantMainView:UpdateReward()
  local rewardId = ServantRecommendProxy.Instance:GetFavorRewardID()
  if rewardId then
    self:Show(self.emojiRoot)
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
    if rewards then
      if #rewards == 1 then
        item.num = rewards[1].num
        item.id = rewards[1].id
      elseif #rewards > 1 then
        item.num = CONST_GIFT_NUM
        item.id = CONST_GIFT_ID
      end
      self.spaceEmoji:SetData(item)
    end
  else
    self:Hide(self.emojiRoot)
  end
end
function ServantMainView:OnReward()
  if self.isFavorEmoji then
    self:PlayNpcAction(actionName[4])
    ServiceNUserProxy.Instance:CallReceiveServantUserCmd(true, 1)
  else
    self:PlayNpcAction(actionName[3])
    ServiceNUserProxy.Instance:CallReceiveServantUserCmd(true)
  end
end
function ServantMainView:ShowServantEffect()
  if self.npc then
    local servantPos = self.npc.completeTransform.localPosition
    local diffpos = LuaVector3(servantPos.x, servantPos.y + 0.5, servantPos.z)
    Asset_Effect.PlayOneShotAt(EffectMap.Maps.ServantShow, diffpos)
  end
end
function ServantMainView:TriggerERMainPanel(isPanelShow)
  self.triggerShowButtonArrowRight:SetActive(isPanelShow)
  self.triggerShowButtonArrowLeft:SetActive(not isPanelShow)
  self.equipRecommendMain:SetActive(isPanelShow)
  FunctionPlayerPrefs.Me():SetBool(ServantMainView.IsERShowKey, isPanelShow)
end
