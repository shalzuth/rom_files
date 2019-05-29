autoImport("PetWorkSpaceCell")
autoImport("PetWorkCombinePetCell")
autoImport("PetSpaceDescCell")
autoImport("PetSpaceRewardCell")
PetWorkSpaceView = class("PetWorkSpaceView", ContainerView)
PetWorkSpaceView.ViewType = UIViewType.NormalLayer
local _PetWorkSpaceProxy = PetWorkSpaceProxy.Instance
local _PictureManager = PictureManager.Instance
local SINGLE_SPACE_PETNUMBER = 1
local Color = LuaColor.New(1, 1, 1, 0)
local textureName = {
  Bg = "pet_bg_scene",
  MainView = "pet_bg_paper"
}
local FIXED_TEX = "shop_bg_05"
local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
function PetWorkSpaceView:Init()
  self:FindObjs()
  self:AddEvts()
  self:MapListenEvt()
  self:InitUIView()
  _PictureManager:SetPetWorkSpace(textureName.Bg, self.bgTexture)
  _PictureManager:SetUI(FIXED_TEX, self.fixedTexture)
  self:Hide(self.root)
end
function PetWorkSpaceView:FindObjs()
  self.root = self:FindGO("Root")
  self.loading = self:FindGO("Loading")
  self.pageScrollView = self:FindComponent("PageScrollView", UIScrollView)
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.pageTexture = self:FindComponent("PageTexture", UITexture)
  self.spaceName = self:FindComponent("spaceName", UILabel)
  self.introducePos = self:FindGO("IntroducePos")
  self.introduceTable = self:FindComponent("IntroduceTable", UITable)
  self.pagePos = self:FindGO("PagePos")
  self.startPos = self:FindGO("StartPos")
  self.stopPos = self:FindGO("StopPos")
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.frequencyLab = self:FindComponent("FrequencyLab", UILabel)
  self.tipsLab = self:FindComponent("TipsLab", UILabel)
  self.startBtn = self:FindGO("StartBtn")
  self.stopBtn = self:FindGO("StopBtn")
  self.petNameLab = self:FindComponent("PetName", UILabel)
  self.workTimeLab = self:FindComponent("WorkTime", UILabel)
  self.RewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.RewardGrid = UIGridListCtrl.new(self.RewardGrid, PetSpaceRewardCell, "PetSpaceRewardCell")
  self.titleTipLab = self:FindComponent("TitleTipLab", UILabel)
  self.workPos = self:FindGO("workPos")
  local noPetTip = self:FindComponent("NoPet", UILabel)
  noPetTip.text = ZhString.PetWorkSpace_NoPets
  self.emptyPet = self:FindGO("EmptyPet")
  self.lvLimitedLab = self:FindComponent("LevelLab", UILabel)
  self.fixedTexture = self:FindComponent("FixedTexture", UITexture)
  self.modelPos = self:FindGO("Model")
  OverseaHostHelper:FixLabelOverV1(self.tipsLab, 3, 320)
end
function PetWorkSpaceView:AddEvts()
  self:AddClickEvent(self.startBtn, function(g)
    self:OnStartBtn()
  end)
  self:AddClickEvent(self.stopBtn, function(g)
    self:OnStopBtn()
  end)
end
local choosenPets = {}
function PetWorkSpaceView:OnStartBtn()
  local chooseSpace = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if chooseSpace and chooseSpace.activeForbiddenFlag then
    MsgManager.ShowMsgByID(25716)
    return
  end
  if nil == chooseSpace.staticData.ActID then
    local curWork = _PetWorkSpaceProxy:GetWorkingSpace(true)
    local curRest = _PetWorkSpaceProxy:GetRestSpace(true)
    curWork = #curWork + #curRest
    local maxWorkCount = _PetWorkSpaceProxy:GetMaxSpace()
    if curWork >= maxWorkCount then
      local msgID = maxWorkCount == GameConfig.PetWorkSpace.pet_work_max_workcount and 8104 or 8108
      MsgManager.ShowMsgByID(msgID)
      return
    end
  end
  if not self.choosePetID then
    MsgManager.ShowMsgByID(8105)
    return
  end
  TableUtility.ArrayClear(choosenPets)
  choosenPets[#choosenPets + 1] = self.choosePetID
  ServiceScenePetProxy.Instance:CallStartWorkPetCmd(self.chooseSpaceID, choosenPets)
end
function PetWorkSpaceView:OnStopBtn()
  local spaceData = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if not spaceData then
    return
  end
  if spaceData.activeForbiddenFlag then
    MsgManager.ShowMsgByID(25716)
    return
  end
  local petName = spaceData:GetPetNameByIndex(SINGLE_SPACE_PETNUMBER)
  MsgManager.ConfirmMsgByID(8106, function()
    ServiceScenePetProxy.Instance:CallStopWorkPetCmd(self.chooseSpaceID)
  end, nil, nil, petName)
end
function PetWorkSpaceView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.ScenePetWorkSpaceUpdate, self.HandleNtf)
  self:AddListenEvt(ServiceEvent.ScenePetQueryPetWorkDataPetCmd, self.HandleNtf)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleNtf)
  self:AddListenEvt(ServiceEvent.ScenePetQueryBattlePetCmd, self.HandleBattlePet)
  self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.HandleStopAct)
end
function PetWorkSpaceView:InitRoot()
  if self.loading.activeSelf then
    self:Hide(self.loading)
  end
  if not self.root.activeSelf then
    self:Show(self.root)
  end
end
function PetWorkSpaceView:HandleNtf(note)
  self:InitRoot()
  self:UpdataView()
end
function PetWorkSpaceView:HandleBattlePet(note)
  local data = note.body
  if data and data.pets then
    _PetWorkSpaceProxy:GetBattlePet(data.pets)
  end
end
function PetWorkSpaceView:HandleStopAct(note)
  local data = note.body
  if data then
    PetWorkSpaceProxy.Instance:HandleStopAct(data.id)
  end
end
function PetWorkSpaceView:InitUIView()
  self:Init3DModel()
  self.introduceCtl = UIGridListCtrl.new(self.introduceTable, PetSpaceDescCell, "PetSpaceDescCell")
  self.tipsLab.text = ZhString.PetWorkSpace_Tips
  _PictureManager:SetPetWorkSpace(textureName.MainView, self.pageTexture)
  local spaceGrid = self:FindComponent("SpaceGrid", UIGrid)
  self.spaceCtl = UIGridListCtrl.new(spaceGrid, PetWorkSpaceCell, "PetWorkSpaceCell")
  self.spaceCtl:AddEventListener(MouseEvent.MouseClick, self.showView, self)
  self.petWrapContainer = self:FindGO("PetWrap")
  local wrapConfig = {
    wrapObj = self.petWrapContainer,
    pfbNum = 3,
    cellName = "PetWorkCombinePetCell",
    control = PetWorkCombinePetCell
  }
  self.petWraplist = WrapCellHelper.new(wrapConfig)
  self.petWraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickPetItem, self)
  self:UpdataView()
  self:_startTimeTick()
end
function PetWorkSpaceView:SetIntroduceDesc()
  local datas = PetWorkSpaceProxy.Instance:GetIntroduceDescData()
  if datas and #datas > 0 then
    self.introduceCtl:ResetDatas(datas)
  end
end
function PetWorkSpaceView:SetPetData(datas)
  local newdata = self:ReUnitData(datas, 4)
  self.petWraplist:UpdateInfo(newdata)
  self.petWraplist:ResetPosition()
end
function PetWorkSpaceView:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      if datas[i] == nil then
        self.unitData[i1][i2] = nil
      else
        self.unitData[i1][i2] = datas[i]
      end
    end
  end
  return self.unitData
end
function PetWorkSpaceView:HandleClickPetItem(cellctl)
  if cellctl and cellctl.data and cellctl.data.guid then
    local petState = cellctl.data.state
    if nil == cellctl.data.petWorkSkillID or 0 == cellctl.data.petWorkSkillID then
      MsgManager.ShowMsgByID(8110)
      return
    end
    if petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_FIGHT or petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_Scene then
      MsgManager.ShowMsgByID(8101)
      return
    end
    if petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_REJECT then
      MsgManager.ShowMsgByID(8103)
      return
    end
    if petState == PetWorkSpaceProxy.EPetStatus.EPETWORK_SPACE_LIMITED then
      local param = GameConfig.PetWorkSpace.pet_work_max_exchange
      MsgManager.ShowMsgByID(8102, param)
      return
    end
    local curPetId = cellctl.data.guid
    if curPetId == self.choosePetID then
      self.choosePetID = nil
      self:_UpdateFrequency(nil)
    else
      self.choosePetID = curPetId
      self:_UpdateFrequency(cellctl.data)
    end
    self:_UpdateChoosePet()
  end
end
function PetWorkSpaceView:_UpdateChoosePet()
  local cellCtls = self.petWraplist:GetCellCtls()
  for i = 1, #cellCtls do
    local cells = cellCtls[i]:GetCells()
    for j = 1, #cells do
      cells[j]:SetChoosePetID(self.choosePetID)
    end
  end
end
function PetWorkSpaceView:_UpdateFrequency(pet)
  local chooseSpace = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if nil == chooseSpace then
    return
  end
  local isCurDay = false
  local desc = chooseSpace.staticData.Desc
  local max_reward = chooseSpace.staticData.Max_reward
  local petFrequency = chooseSpace:GetFrequency(pet)
  local unused = chooseSpace:Unused()
  local own
  local startTime = chooseSpace.startTime
  local endTime = chooseSpace:GetEndTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local endTimeRefreshTime = os.date("*t", endTime)
  endTimeRefreshTime = os.time({
    year = endTimeRefreshTime.year,
    month = endTimeRefreshTime.month,
    day = endTimeRefreshTime.day,
    hour = 5
  })
  local lastCount = chooseSpace.lastCounts
  lastCount = lastCount and #lastCount > 0 and lastCount[1] or 0
  if chooseSpace:IsOverCfgTime() then
    own = 0
  else
    local refreshTime = PetWorkSpaceProxy.GetRefreshTime(startTime)
    own, isCurDay = PetWorkSpaceProxy.calcPetWorkCurDayRewardCount(startTime, endTime, petFrequency, max_reward, lastCount)
  end
  if unused then
    own = lastCount
  elseif isCurDay == true then
    own = own + lastCount
  end
  own = math.min(own, max_reward)
  self.frequencyLab.text = string.format(ZhString.PetWorkSpace_DescFrequency, petFrequency, own, max_reward)
end
function PetWorkSpaceView:showView(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  local curID = data.id
  local chooseSpace = _PetWorkSpaceProxy:GetWorkSpaceDataById(curID)
  if chooseSpace and chooseSpace.activeForbiddenFlag then
    MsgManager.ShowMsgByID(25716)
    return
  end
  local reward = data:GetUIReward()
  if reward then
    ServiceScenePetProxy.Instance:CallGetPetWorkRewardPetCmd(data.id)
  end
  if not data:IsOpen() then
    return
  end
  if not data:IsUnlock() then
    MsgManager.ShowMsgByID(8107)
    if 0 < #data.petEggs then
      ServiceScenePetProxy.Instance:CallStopWorkPetCmd(curID)
    end
    return
  end
  if curID == self.chooseSpaceID then
    self.chooseSpaceID = nil
  else
    self.chooseSpaceID = curID
    self.choosePetID = nil
    self:_UpdateChoosePet()
  end
  local cells = self.spaceCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetChoose(self.chooseSpaceID)
  end
  self:UpdataPage()
end
local tempVector3 = LuaVector3.zero
function PetWorkSpaceView:UpdataPage()
  self.pageScrollView:ResetPosition()
  if not self.chooseSpaceID then
    self:Hide(self.stopPos)
    self:Hide(self.startPos)
    self:Show(self.introducePos)
    self:Hide(self.pagePos)
    self.spaceName.text = ZhString.PetWorkSpace_IntroduceTitle
    self:SetIntroduceDesc()
    self:Hide(self.emptyPet)
    self:UnloadPetModel()
  else
    self:Hide(self.introducePos)
    self:Show(self.pagePos)
    local pageData = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
    if not pageData then
      return
    end
    local unUsed = PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_UNUSED == pageData.state
    if unUsed then
      self:Show(self.startPos)
      self:Show(self.petWrapContainer)
      self:Hide(self.stopPos)
      self:Hide(self.workPos)
      tempVector3:Set(-166, 92, 0)
      local petsData = _PetWorkSpaceProxy:GetTotalPetsData(pageData.id)
      if petsData and #petsData > 0 then
        self:Show(self.petWrapContainer)
        self:Hide(self.emptyPet)
        self:SetPetData(petsData)
      else
        self:Show(self.emptyPet)
        self:Hide(self.petWrapContainer)
      end
      self:UnloadPetModel()
    else
      local isWorking = pageData:IsWorking()
      tempVector3:Set(-166, 120, 0)
      self:Hide(self.startPos)
      self:Hide(self.petWrapContainer)
      self:Show(self.stopPos)
      self:Show(self.workPos)
      local petName = pageData:GetPetNameByIndex(SINGLE_SPACE_PETNUMBER)
      self.petNameLab.text = string.format(ZhString.PetWorkSpace_PetName, petName)
      local petID = pageData:GetPetIDByIndex(SINGLE_SPACE_PETNUMBER)
      local equips = pageData:GetPetEquips(SINGLE_SPACE_PETNUMBER)
      self:SetPetModel(SINGLE_SPACE_PETNUMBER, petID, equips)
    end
    local staticData = pageData.staticData
    if not staticData then
      return
    end
    self.spaceName.text = staticData.Name
    self.frequencyLab.gameObject.transform.localPosition = tempVector3
    self.lvLimitedLab.gameObject:SetActive(unUsed)
    self.descLab.text = staticData.Desc
    self.lvLimitedLab.text = string.format(ZhString.PetWorkSpace_Level, staticData.Level)
    self:_UpdateFrequency()
    local rewards = pageData:GetRewardArray()
    self.RewardGrid:ResetDatas(rewards)
  end
end
function PetWorkSpaceView:_startTimeTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.Update, self)
end
function PetWorkSpaceView:Update()
  self:UpdatePageView()
  self:UpdateState()
end
function PetWorkSpaceView:UpdateState()
  local workingSpace = _PetWorkSpaceProxy:GetWorkingSpace()
  for i = 1, #workingSpace do
    local data = workingSpace[i]
    if data:IsWorking() and (data:IsOverCfgTime() or data:MaxRewardLimited()) then
      data.state = PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST
      self:UpdataView()
    end
  end
end
function PetWorkSpaceView:UpdatePageView()
  local data = _PetWorkSpaceProxy:GetWorkSpaceDataById(self.chooseSpaceID)
  if not data then
    return
  end
  local duringTime = data:GetDuringTime()
  if 0 == duringTime then
    return
  end
  if data:IsWorking() or data:IsResting() then
    self:_UpdateFrequency(data.petEggs[1])
  end
  if not data:IsWorking() then
    self.workTimeLab.text = ZhString.PetWorkSpace_Rest
    return
  end
  local fre = data:GetFrequency(data.petEggs[1])
  duringTime = duringTime % (fre * 60)
  if data:MaxRewardLimited() or data:IsOverCfgTime() then
    data.state = PetWorkSpaceProxy.ESpaceStatus.EWORKSTATE_REST
    self.workTimeLab.text = ZhString.PetWorkSpace_Rest
    self:UpdataView()
    return
  end
  local t = ClientTimeUtil.FormatTimeTick(duringTime, "mm:ss")
  self.workTimeLab.text = string.format(ZhString.PetWorkSpace_Working, t)
end
function PetWorkSpaceView:Init3DModel()
  self.modelContainer = GameObject("ModelContainer")
  self.modelContainer.transform.parent = self.modelPos.transform
  self.modelContainer.transform.localPosition = Vector3.zero
  self.modelContainer.transform.localEulerAngles = Vector3.zero
  self.modelContainer.layer = self.modelPos.layer
end
local tempVec = LuaVector3.zero
function PetWorkSpaceView:SetPetModel(index, id, equips)
  local monsterParts = PetEggInfo.GetPetDessParts(id, equips)
  if self.modelAssetRole then
    self.modelAssetRole:Redress(monsterParts)
  else
    self.modelAssetRole = Asset_Role.Create(monsterParts)
  end
  self.modelAssetRole:PlayAction_Idle()
  self.modelAssetRole:SetLayer(self.modelContainer.layer)
  self.modelAssetRole:SetParent(self.modelContainer.transform, false)
  self.modelAssetRole:SetRotation(LuaQuaternion.identity)
  local configSize = Table_Monster[id] and Table_Monster[id].LoadShowSize
  if configSize then
    self.modelAssetRole:SetScale(configSize * 0.3)
  else
    self.modelAssetRole:SetScale(0.3)
  end
  local showPos = Table_Monster[id] and Table_Monster[id].LoadShowPose
  if showPos and #showPos == 3 then
    tempVec:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
    self.modelAssetRole:SetPosition(tempVec)
  end
  GameObjectUtil.Instance:ChangeLayersRecursively(self.modelContainer, self.modelPos.gameObject.layer)
  Asset_Role.DestroyPartArray(monsterParts)
end
function PetWorkSpaceView:UnloadPetModel()
  if self.modelAssetRole then
    self.modelAssetRole:Destroy()
    self.modelAssetRole = nil
  end
end
function PetWorkSpaceView:InitPos()
  self:Show(self.introducePos)
  self:Hide(self.pagePos)
end
function PetWorkSpaceView:UpdataView()
  local workingSpaces = _PetWorkSpaceProxy:GetWorkingSpace(true)
  local restSpaces = _PetWorkSpaceProxy:GetRestSpace(true)
  local maxWorkCount = _PetWorkSpaceProxy:GetMaxSpace()
  if workingSpaces then
    local total = restSpaces and #restSpaces + #workingSpaces or #workingSpaces
    self.titleTipLab.text = string.format(ZhString.PetWorkSpace_TitleTip, total, maxWorkCount)
  end
  local data = _PetWorkSpaceProxy:GetSpaceViewData()
  if data then
    self.spaceCtl:ResetDatas(data)
  end
  self.choosePetID = nil
  self:_UpdateChoosePet()
  self:UpdataPage()
end
function PetWorkSpaceView:OnEnter()
  manager_Camera:ActiveMainCamera(false)
  PetWorkSpaceView.super.OnEnter(self)
  _PetWorkSpaceProxy:ClearSpaceData()
  ServiceScenePetProxy.Instance:CallQueryPetWorkDataPetCmd()
  ServiceScenePetProxy.Instance:CallQueryBattlePetCmd()
end
function PetWorkSpaceView:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
function PetWorkSpaceView:OnExit()
  manager_Camera:ActiveMainCamera(true)
  self:ClearTick()
  self:UnloadPetModel()
  _PictureManager:UnloadPetWorkSpace(textureName.Bg, self.bgTexture)
  _PictureManager:UnloadPetWorkSpace(textureName.MainView, self.pageTexture)
  _PictureManager:UnLoadUI(FIXED_TEX, self.fixedTexture)
  PetWorkSpaceView.super.OnExit(self)
  TipsView.Me():HideCurrent()
end
