BossView = class("BossView", BaseView)
autoImport("BossCell")
autoImport("BaseItemCell")
BossView.ViewType = UIViewType.NormalLayer
BossFliterOptIndex = {
  All = 1,
  Mvp = 2,
  Mini = 3,
  Death = 4
}
BossFliterOpt = {
  ZhString.BossView_All,
  "Mvp",
  "Mini"
}
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail",
  "Tutor_InviteBeStudent",
  "Tutor_InviteBeTutor"
}
local deathBossHelpId = 640
function BossView:Init()
  self:FindObjs()
  self:MapViewListen()
  self.tipOffset = {300, 60}
  self.playerTipData = {}
end
local tempArgs = {}
function BossView:FindObjs()
  local miniTogGO = self:FindGO("ShowMiniTog")
  self.showMiniTog = self:FindComponent("Tog", UIToggle)
  self.showMiniTog_Collider = miniTogGO:GetComponent(BoxCollider)
  self.showMiniTog_Label = self:FindComponent("Label", UILabel, miniTogGO)
  self.showMiniTog_CheckBg = self:FindComponent("Checkmark", UISprite, miniTogGO)
  self.showMiniTog_Bg = miniTogGO:GetComponent(UISprite)
  self.listbg = self:FindGO("listBg")
  self:AddTabEvent(miniTogGO, function(go, value)
    self:UpdateMini()
  end)
  local bossScroll = self:FindGO("BossScroll")
  self.bossLoading = self:FindGO("BossLoadingRoot")
  self.bossTexture = self:FindComponent("BossTexture", UITexture)
  self.bossname = self:FindComponent("BossName", UILabel)
  self.bossElement = self:FindComponent("BossElement", UISprite)
  local bossInfo = self:FindGO("BossInfo")
  self.bossPosition = self:FindComponent("position", UILabel, bossInfo)
  self.bossDesc = self:FindComponent("Desc", UILabel, bossInfo)
  self.chooseSymbol = self:FindGO("BossChooseSymbol")
  local gobutton = self:FindGO("goButton")
  self:AddClickEvent(gobutton, function(go)
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
    elseif self.chooseBoss ~= nil then
      TableUtility.TableClear(tempArgs)
      tempArgs.targetMapID = self.chooseBoss.mapid
      local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
      if cmd then
        Game.Myself:Client_SetMissionCommand(cmd)
      end
      self:CloseSelf()
    end
  end)
  local container = self:FindGO("BossWrap")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "BossCell",
    control = BossCell,
    dir = 1
  }
  self.bosslist = WrapCellHelper.new(wrapConfig)
  self.bosslist:AddEventListener(MouseEvent.MouseClick, self.ClickBossCell, self)
  self.selected = BossFliterOptIndex.Mvp
  local bossToggle = self:FindGO("BossToggle"):GetComponent(UIButton)
  self.bosstoggle = true
  bossToggle.normalSprite = "ui_mvp_dead2_JM"
  self.listbg:SetActive(false)
  miniTogGO:SetActive(true)
  self:AddClickEvent(bossToggle.gameObject, function(go)
    if not self.deathlist or #self.deathlist == 0 then
      MsgManager.ShowMsgByID(26113)
      return
    end
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_DEAD_BOSS)
    if not self.bosstoggle then
      bossToggle.normalSprite = "ui_mvp_dead2_JM"
      self.listbg:SetActive(false)
      miniTogGO:SetActive(true)
    else
      bossToggle.normalSprite = "ui_mvp_dead1_JM"
      self.listbg:SetActive(true)
      miniTogGO:SetActive(false)
    end
    self.bosstoggle = not self.bosstoggle
    self:UpdateBossList()
  end)
  self:QueryMVPBoss()
  self.helpBtn = self:FindGO("helpBtn")
  self:AddClickEvent(self.helpBtn, function()
    local Desc = Table_Help[deathBossHelpId] and Table_Help[deathBossHelpId].Desc or ZhString.Help_RuleDes
    TipsView.Me():ShowGeneralHelp(Desc)
  end)
  RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_DEAD_BOSS, bossToggle.gameObject, 6, {-15, -10})
  local menuid = GameConfig.SystemOpen_MenuId and GameConfig.SystemOpen_MenuId.DeadBoss or 9
  local deadBossOpen = FunctionUnLockFunc.Me():CheckCanOpen(menuid)
  bossToggle.gameObject:SetActive(deadBossOpen == true)
  self.helpBtn:SetActive(deadBossOpen == true)
end
function BossView:QueryMVPBoss()
  ServiceBossCmdProxy.Instance:CallBossListUserCmd()
end
function BossView:UpdateMini()
  if self.updateMini_InCD then
    MsgManager.ShowMsgByIDTable(952)
    return
  end
  self.updateMini_InCD = true
  if self.lt then
    self.lt:cancel()
  end
  self.lt = LeanTween.delayedCall(5, function()
    self.updateMini_InCD = false
    self.lt = nil
  end)
  self.showMiniTog.value = not self.showMiniTog.value
  self:UpdateBossList()
  LocalSaveProxy.Instance:SetBossView_ShowMini(self.showMiniTog.value)
end
local currentMonsterLv = 1
function BossView:ClickBossCell(cellctl, forceUpdate)
  local data = cellctl and cellctl.data
  if data then
    self.chooseBoss = data
    currentMonsterLv = data.lv
    if self.chooseId ~= data.id or self.chooseMap ~= data.mapid or forceUpdate == true then
      local obj = cellctl.gameObject
      self:UpdateBossInfo(data)
      self.chooseId = data.id
      self.chooseMap = data.mapid
      for _, cell in pairs(self.bossCells) do
        cell:SetChoose(self.chooseId, self.chooseMap)
      end
    else
      self.chooseId = 0
      self.chooseMap = 0
    end
  end
end
function BossView:UpdateBossList()
  if self.mvplist == nil then
    helplog("BossList is nil!")
    return
  end
  if self.datas == nil then
    self.datas = {}
  else
    TableUtility.TableClear(self.datas)
  end
  self.bosslist:ResetPosition()
  if self.bosstoggle then
    TableUtility.ArrayShallowCopy(self.datas, self.mvplist)
  elseif self.deathlist and #self.deathlist ~= 0 then
    TableUtility.ArrayShallowCopy(self.datas, self.deathlist)
  else
    TableUtility.TableClear(self.datas)
  end
  if self.showMiniTog.value and self.minilist and self.bosstoggle then
    for i = 1, #self.minilist do
      table.insert(self.datas, self.minilist[i])
    end
  end
  table.sort(self.datas, BossView.BossSortFunc)
  self.bosslist:UpdateInfo(self.datas)
  if self.bossCells == nil then
    self.bossCells = self.bosslist:GetCellCtls()
  end
  self:ClickBossCell(self.bossCells[1], true)
  for i = 1, #self.bossCells do
    self.bossCells[i]:SetView(self)
  end
end
function BossView.BossSortFunc(a, b)
  if a.priority == b.priority then
    local bossA = Table_Boss[a.id]
    local bossB = Table_Boss[b.id]
    local monsterA = Table_Monster[a.id]
    local monsterB = Table_Monster[b.id]
    if bossA.MvpID and bossA.Type == 3 then
      monsterA = Table_Monster[bossA.MvpID]
    end
    if bossB.MvpID and bossB.Type == 3 then
      monsterB = Table_Monster[bossB.MvpID]
    end
    local levela = monsterA.Level
    local levelb = monsterB.Level
    if levela ~= levelb then
      return levela < levelb
    end
    local isAMvp = monsterA.Type == "MVP"
    local isBMvp = monsterB.Type == "MVP"
    if isAMvp ~= isBMvp then
      return isAMvp
    end
    return a.id < b.id
  else
    return a.priority > b.priority
  end
end
function BossView:UpdateBossInfo(data)
  local bossStaticdata = data.staticData
  self.bossname.text = bossStaticdata.NameZh
  local mapid = data.mapid or bossStaticdata.Map
  local mapIds = {}
  if type(mapid) == "number" then
    table.insert(mapIds, mapid)
  elseif type(mapid) == "table" then
    mapIds = mapid
  end
  local posDesc = ""
  for i = 1, #mapIds do
    local id = mapIds[i]
    if Table_Map[id] then
      posDesc = Table_Map[id].CallZh
    end
    if i < #mapIds then
      posDesc = posDesc .. ", "
    end
  end
  self.bossPosition.text = posDesc
  local mdata
  mdata = Table_Monster[bossStaticdata.id]
  local deadreward = {}
  local dID
  if bossStaticdata.Type ~= 3 then
    deadreward = mdata.Dead_Reward
  else
    dID = bossStaticdata.id * 100 + data.lv
    if Table_Deadboss[dID] then
      deadreward = Table_Deadboss[dID].Dead_Reward
    else
      return
    end
  end
  local dropItems = {}
  if deadreward then
    for k, v in pairs(deadreward) do
      local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(v)
      for _, data in pairs(rewardTeamids) do
        local item = ItemData.new("Reward", data.id)
        item.num = data.num
        local iStaticdata = item.staticData
        if iStaticdata and iStaticdata.MonsterLevel and iStaticdata.MonsterLevel > currentMonsterLv then
          item.needLocker = true
        else
          item.needLocker = false
        end
        table.insert(dropItems, item)
      end
    end
  end
  table.sort(dropItems, function(a, b)
    if a.staticData and b.staticData then
      return a.staticData.Quality > b.staticData.Quality
    else
      return false
    end
  end)
  if self.drop == nil then
    local dropScrollObj = self:FindGO("DropItemScroll")
    self.dropScroll = dropScrollObj:GetComponent(UIScrollView)
    local dropGrid = self:FindGO("Grid", dropScrollObj):GetComponent(UIGrid)
    self.drop = UIGridListCtrl.new(dropGrid, BaseItemCell, "DropItemCell")
    self.drop:AddEventListener(MouseEvent.MouseClick, self.ClickDropItem, self)
  end
  self.dropScroll:ResetPosition()
  self.drop:ResetDatas(dropItems)
  self.bossDesc.text = mdata.Desc
  UIUtil.WrapLabel(self.bossDesc)
  self:UpdateBossAgent(mdata, data.bosstype)
  self.bossElement.spriteName = ""
end
function BossView:ClickDropItem(cellctl)
  if cellctl and cellctl ~= self.chooseItem then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponentInChildren(UISprite)
    if data then
      local callback = function()
        self:CancelChoose()
      end
      local iStaticdata = data.staticData
      local locker = false
      if iStaticdata and iStaticdata.MonsterLevel and iStaticdata.MonsterLevel > currentMonsterLv then
        locker = true
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        },
        needLocker = locker
      }
      self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseItem = cellctl
  else
    self:CancelChoose()
  end
end
function BossView:CancelChoose()
  self.chooseItem = nil
  self:ShowItemTip()
end
local monsterPos = LuaVector3()
function BossView:UpdateBossAgent(monsterData, bosstype)
  if bosstype == 3 then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing_1", self.bossTexture)
  else
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.bossTexture)
  end
  local model = UIModelUtil.Instance:SetMonsterModelTexture(self.bossTexture, monsterData.id)
  local showPos = monsterData.LoadShowPose
  monsterPos:Set(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
  model:SetPosition(monsterPos)
  model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
  local size = monsterData.LoadShowSize or 1
  model:SetScale(size)
end
function BossView:MapViewListen()
  self:AddListenEvt(ServiceEvent.BossCmdBossListUserCmd, self.HandleBosslstUpdate)
  self:AddListenEvt(ServiceEvent.BossCmdQueryKillerInfoBossCmd, self.OnRecvQueryKillerInfoBoss)
end
function BossView:HandleBosslstUpdate(note)
  local bossDatas = note.body
  self.mvplist = bossDatas[1]
  self.minilist = bossDatas[2]
  self.deathlist = bossDatas[3]
  self:UpdateBossList()
end
local tempColor = LuaColor.New(1, 1, 1, 1)
function BossView:ActiveShowMiniTog(b)
  if b then
    self.showMiniTog_Collider.enabled = true
    tempColor:Set(1, 1, 1, 1)
    self.showMiniTog_Bg.color = tempColor
    self.showMiniTog_CheckBg.color = tempColor
    tempColor:Set(0, 0, 0, 1)
    self.showMiniTog_Label.color = tempColor
  else
    self.showMiniTog_Collider.enabled = false
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.showMiniTog_Bg.color = tempColor
    self.showMiniTog_CheckBg.color = tempColor
    tempColor:Set(0.615686274509804, 0.615686274509804, 0.615686274509804, 1)
    self.showMiniTog_Label.color = tempColor
  end
end
function BossView:OnClickCellKillerName(cell)
  FunctionPlayerTip.Me():CloseTip()
  local id = cell.killerID
  if not id or 0 == id then
    return
  end
  self.queryCell = cell
  local data = self.playerTipData[id]
  if data then
    self:ShowPlayerTip(data)
  else
    self.bossLoading:SetActive(true)
    ServiceBossCmdProxy.Instance:CallQueryKillerInfoBossCmd(id)
    self.killerInfoLt = LeanTween.delayedCall(10, function()
      self.killerInfoLt = nil
      if self.bossLoading.gameObject then
        self.bossLoading:SetActive(false)
      end
    end)
  end
end
function BossView:OnRecvQueryKillerInfoBoss(note)
  if self.killerInfoLt then
    self.killerInfoLt:cancel()
    self.killerInfoLt = nil
  end
  self.bossLoading:SetActive(false)
  local id = note.body and note.body.charid
  if not id or id == 0 then
    MsgManager.ShowMsgByID(5030)
    return
  end
  local player = PlayerTipData.new()
  player:SetByBossKillerData(note.body)
  local tipData = ReusableTable.CreateTable()
  tipData.playerData = player
  tipData.funckeys = FriendProxy.Instance:IsFriend(id) and playerTipFunc_Friend or playerTipFunc
  if self.playerTipData[id] then
    ReusableTable.DestroyTable(self.playerTipData[id])
  end
  self.playerTipData[id] = tipData
  if self.queryCell.killerID == id then
    self:ShowPlayerTip(tipData)
  end
end
function BossView:ShowPlayerTip(data)
  FunctionPlayerTip.Me():CloseTip()
  FunctionPlayerTip.Me():GetPlayerTip(self.queryCell.icon, NGUIUtil.AnchorSide.Right, self.tipOffset, data)
end
function BossView:ClearPlayerTipDatas()
  for k, v in pairs(self.playerTipData) do
    if v then
      ReusableTable.DestroyAndClearTable(v)
    end
  end
end
function BossView:OnEnter()
  self.super.OnEnter(self)
  local amIMonthlyVIP = UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
  if amIMonthlyVIP then
    self:ActiveShowMiniTog(true)
    self.showMiniTog.value = LocalSaveProxy.Instance:GetBossView_ShowMini()
  else
    self:ActiveShowMiniTog(false)
    self.showMiniTog.value = false
  end
end
function BossView:OnExit()
  self:ClearPlayerTipDatas()
  if self.bossCells then
    for i = 1, #self.bossCells do
      self.bossCells[i]:RemoveUpdateTime()
    end
    self.bossCells = nil
  end
  if self.lt then
    self.lt:cancel()
  end
  if self.bossTexture then
    UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.bossTexture)
  end
  self.super.OnExit(self)
end
