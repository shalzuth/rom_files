FunctionNpcFunc = class("FunctionNpcFunc")
autoImport("FuncLaboratoryShop")
autoImport("FuncAdventureSkill")
autoImport("FunctionMiyinStrengthen")
autoImport("FuncZenyShop")
autoImport("UIModelZenyShop")
autoImport("UIMapAreaList")
autoImport("UIMapMapList")
autoImport("RaidEnterWaitView")
NpcFuncState = {
  Active = 1,
  InActive = 2,
  Grey = 3
}
function FunctionNpcFunc.Me()
  if nil == FunctionNpcFunc.me then
    FunctionNpcFunc.me = FunctionNpcFunc.new()
  end
  return FunctionNpcFunc.me
end
local NpcFuncType = {
  Common_Shop = "Common_Shop",
  Common_NotifyServer = "NotifyServer",
  Common_GuildRaid = "Common_GuildRaid",
  Common_InvitethePersonoflove = "Common_InvitethePersonoflove",
  Common_AboutDateLand = "Common_AboutDateLand",
  Common_Augury = "Common_Augury",
  Common_AboutAugury = "Common_AboutAugury",
  Common_Hyperlink = "Common_Hyperlink",
  JoinStage = "JoinStage",
  BeatBoli = "BeatBoli"
}
function FunctionNpcFunc:ctor()
  self.funcMap = {}
  self.checkMap = {}
  self.updateCheckMap = {}
  local handles = {}
  handles[NpcFuncType.Common_Shop] = FunctionNpcFunc.TypeFunc_Shop
  handles[NpcFuncType.Common_NotifyServer] = FunctionNpcFunc.TypeFunc_NotifyServer
  handles[NpcFuncType.Common_GuildRaid] = FunctionNpcFunc.TypeFunc_GuildRaid
  handles[NpcFuncType.Common_InvitethePersonoflove] = FunctionNpcFunc.TypeFunc_InvitethePersonoflove
  handles[NpcFuncType.Common_AboutDateLand] = FunctionNpcFunc.TypeFunc_AboutDateLand
  handles[NpcFuncType.Common_Augury] = FunctionNpcFunc.TypeFunc_Augury
  handles[NpcFuncType.Common_AboutAugury] = FunctionNpcFunc.TypeFunc_AboutAugury
  handles[NpcFuncType.Common_Hyperlink] = FunctionNpcFunc.TypeFunc_Hyperlink
  handles[NpcFuncType.JoinStage] = FunctionNpcFunc.JoinStage
  handles[NpcFuncType.BeatBoli] = FunctionNpcFunc.BeatBoli
  self:PreprocessNpcFunctionConfig(handles)
  local checkHandles = {}
  checkHandles[NpcFuncType.Common_Shop] = FunctionNpcFunc.CheckTypeFunc_Shop
  self:PreprocessNpcFuncCheckConfig(checkHandles)
  self.funcMap.MagicLottery = FunctionNpcFunc.LotteryMagic
  self.funcMap.Close = FunctionNpcFunc.Close
  self.funcMap.storehouse = FunctionNpcFunc.storehouse
  self.funcMap.Transfer = FunctionNpcFunc.Transfer
  self.funcMap.Refine = FunctionNpcFunc.Refine
  self.funcMap.DeCompose = FunctionNpcFunc.DeCompose
  self.funcMap.Transmit = FunctionNpcFunc.Transmit
  self.funcMap.EndLessTower = FunctionNpcFunc.EndLessTower
  self.funcMap.EndLessTeam = FunctionNpcFunc.EndLessTeam
  self.funcMap.Repair = FunctionNpcFunc.Repair
  self.funcMap.Laboratory = FunctionNpcFunc.Laboratory
  self.funcMap.LaboratoryTeam = FunctionNpcFunc.LaboratoryTeam
  self.funcMap.LaboratoryShop = FunctionNpcFunc.LaboratoryShop
  self.funcMap.Sell = FunctionNpcFunc.Sell
  self.funcMap.Teleporter = FunctionNpcFunc.Teleporter
  self.funcMap.JoinStage = FunctionNpcFunc.JoinStage
  self.funcMap.QueryDefeatBossTime = FunctionNpcFunc.QueryDefeatBossTime
  self.funcMap.DefeatBoss = FunctionNpcFunc.DefeatBoss
  self.funcMap.PicMake = FunctionNpcFunc.PicMake
  self.funcMap.strengthen = FunctionNpcFunc.strengthen
  self.funcMap.CreateGuild = FunctionNpcFunc.CreateGuild
  self.funcMap.ApplyGuild = FunctionNpcFunc.ApplyGuild
  self.funcMap.GuildManor = FunctionNpcFunc.GuildManor
  self.funcMap.UpgradeGuild = FunctionNpcFunc.UpgradeGuild
  self.funcMap.DisMissGuild = FunctionNpcFunc.DisMissGuild
  self.funcMap.OpenGuildRaid = FunctionNpcFunc.OpenGuildRaid
  self.funcMap.ReadyToGuildRaid = FunctionNpcFunc.ReadyToGuildRaid
  self.funcMap.AdventureSkill = FunctionNpcFunc.AdventureSkill
  self.funcMap.SewingStrengthen = FunctionNpcFunc.SewingStrengthen
  self.funcMap.CancelDissolution = FunctionNpcFunc.CancelDissolution
  self.funcMap.Dojo = FunctionNpcFunc.Dojo
  self.funcMap.ExitGuild = FunctionNpcFunc.ExitGuild
  self.funcMap.QuickTeam = FunctionNpcFunc.QuickTeam
  self.funcMap.DojoTeam = FunctionNpcFunc.DojoTeam
  self.funcMap.PrimaryEnchant = FunctionNpcFunc.PrimaryEnchant
  self.funcMap.MediumEnchant = FunctionNpcFunc.MediumEnchant
  self.funcMap.SeniorEnchant = FunctionNpcFunc.SeniorEnchant
  self.funcMap.seal = FunctionNpcFunc.seal
  self.funcMap.GuildDonate = FunctionNpcFunc.GuildDonate
  self.funcMap.EquipMake = FunctionNpcFunc.EquipMake
  self.funcMap.EquipRecover = FunctionNpcFunc.EquipRecover
  self.funcMap.Exchange = FunctionNpcFunc.Exchange
  self.funcMap.ChangeGuildLine = FunctionNpcFunc.ChangeGuildLine
  self.funcMap.ReleaseActivity = FunctionNpcFunc.ReleaseActivity
  self.funcMap.GetIceCream = FunctionNpcFunc.GetIceCream
  self.funcMap.GetCdkey = FunctionNpcFunc.GetCdkey
  self.funcMap.FindGM = FunctionNpcFunc.FindGM
  self.funcMap.QuestionSurvey = FunctionNpcFunc.QuestionSurvey
  self.funcMap.QuestActAnswer = FunctionNpcFunc.QuestActAnswer
  self.funcMap.AutumnAdventure = FunctionNpcFunc.AutumnAdventure
  self.funcMap.GetOldConsume = FunctionNpcFunc.GetOldConsume
  self.funcMap.GetAutumnEquip = FunctionNpcFunc.GetAutumnEquip
  self.funcMap.MillionHitThanks = FunctionNpcFunc.MillionHitThanks
  self.funcMap.AppointmentThanks = FunctionNpcFunc.AppointmentThanks
  self.funcMap.ChinaNewYear = FunctionNpcFunc.ChinaNewYear
  self.funcMap.ChangeHairStyle = FunctionNpcFunc.ChangeHairStyle
  self.funcMap.ChangeEyeLenses = FunctionNpcFunc.ChangeEyeLenses
  self.funcMap.ChangeClothColor = FunctionNpcFunc.ChangeClothColor
  self.funcMap.GuildPary = FunctionNpcFunc.GuildPray
  if not GameConfig.SystemForbid.GvGPvP_Pray then
    self.funcMap.GvGPvPPray = FunctionNpcFunc.GvGPvpPray
  end
  self.funcMap.DyeCloth = FunctionNpcFunc.DyeCloth
  self.funcMap.GuildBuilding = FunctionNpcFunc.GuildBuilding
  self.funcMap.BuildingSubmitMaterial = FunctionNpcFunc.BuildingSubmitMaterial
  self.funcMap.Safetyrewards = FunctionNpcFunc.Safetyrewards
  self.funcMap.MonthCard = FunctionNpcFunc.MonthCard
  self.funcMap.Opengift = FunctionNpcFunc.Opengift
  self.funcMap.HireCatInfo = FunctionNpcFunc.HireCatInfo
  self.funcMap.HelpGuildChallenge = FunctionNpcFunc.HelpGuildChallenge
  self.funcMap.CardRandomMake = FunctionNpcFunc.CardRandomMake
  self.funcMap.CardMake = FunctionNpcFunc.CardMake
  self.funcMap.CardDecompose = FunctionNpcFunc.CardDecompose
  self.funcMap.Astrolabe = FunctionNpcFunc.Astrolabe
  self.funcMap.Lottery = FunctionNpcFunc.LotteryHeadwear
  self.funcMap.Lottery2 = FunctionNpcFunc.LotteryEquip
  self.funcMap.Lottery3 = FunctionNpcFunc.LotteryCard
  self.funcMap.CatLitterBox = FunctionNpcFunc.CatLitterBox
  self.funcMap.MagicLottery = FunctionNpcFunc.LotteryMagic
  self.funcMap.MagicLottery2 = FunctionNpcFunc.LotteryMagicSec
  self.funcMap.TestCheck = FunctionNpcFunc.TestCheck
  self.funcMap.ChangeGuildName = FunctionNpcFunc.ChangeGuildName
  self.funcMap.GiveUpGuildLand = FunctionNpcFunc.GiveUpGuildLand
  self.funcMap.EquipAlchemy = FunctionNpcFunc.EquipAlchemy
  self.funcMap.EnterCapraActivity = FunctionNpcFunc.EnterCapraActivity
  self.funcMap.ReportPoringFight = FunctionNpcFunc.ReportPoringFight
  self.funcMap.ReportMvpFight = FunctionNpcFunc.ReportMvpFight
  if not GameConfig.SystemForbid.Auction then
    self.funcMap.AuctionShop = FunctionNpcFunc.AuctionShop
  end
  self.funcMap.OpenGuildFunction = FunctionNpcFunc.OpenGuildFunction
  self.funcMap.OpenGuildChallengeTaskView = FunctionNpcFunc.OpenGuildChallengeTaskView
  self.funcMap.HighRefine = FunctionNpcFunc.HighRefine
  self.funcMap.SewingRefine = FunctionNpcFunc.SewingRefine
  self.funcMap.ArtifactMake = FunctionNpcFunc.ArtifactMake
  self.funcMap.ReturnArtifact = FunctionNpcFunc.ReturnArtifact
  self.funcMap.ServerOpenFunction = FunctionNpcFunc.ServerOpenFunction
  self.funcMap.YoyoSeat = FunctionNpcFunc.YoyoSeat
  self.funcMap.UpJobLevel = FunctionNpcFunc.UpJobLevel
  self.funcMap.WeddingCememony = FunctionNpcFunc.WeddingCememony
  self.funcMap.WeddingDay = FunctionNpcFunc.WeddingDay
  self.funcMap.BookingWedding = FunctionNpcFunc.BookingWedding
  self.funcMap.CancelWedding = FunctionNpcFunc.CancelWedding
  self.funcMap.ConsentDivorce = FunctionNpcFunc.ConsentDivorce
  self.funcMap.UnilateralDivorce = FunctionNpcFunc.UnilateralDivorce
  self.funcMap.GuildHoldTreasure = FunctionNpcFunc.GuildHoldTreasure
  self.funcMap.GuildTreasure = FunctionNpcFunc.GuildTreasure
  self.funcMap.GuildTreasurePreview = FunctionNpcFunc.GuildTreasurePreview
  self.funcMap.EnterRollerCoaster = FunctionNpcFunc.EnterRollerCoaster
  self.funcMap.TakeMarryCarriage = FunctionNpcFunc.TakeMarryCarriage
  self.funcMap.EnterWeddingMap = FunctionNpcFunc.EnterWeddingMap
  self.funcMap.WeddingRingShop = FunctionNpcFunc.WeddingRingShop
  self.funcMap.PveCard_StartFight = FunctionNpcFunc.PveCard_StartFight
  self.funcMap.EquipCompose = FunctionNpcFunc.EquipCompose
  self.funcMap.EnterPoringFight = FunctionNpcFunc.EnterPoringFight
  self.funcMap.HireCatConfirm = FunctionNpcFunc.HireCatConfirm
  self.funcMap.DialogGoddessOfferDead = FunctionNpcFunc.DialogGoddessOfferDead
  self.funcMap.DeathTransfer = FunctionNpcFunc.DeathTransfer
  self.funcMap.CourageRanking = FunctionNpcFunc.CourageRanking
  self.funcMap.EnterPveCard = FunctionNpcFunc.EnterPveCard
  self.funcMap.ShowPveCard = FunctionNpcFunc.ShowPveCard
  self.funcMap.OpenKFCShareView = FunctionNpcFunc.OpenKFCShareView
  self.funcMap.SelectPveCard = FunctionNpcFunc.SelectPveCard
  self.funcMap.OpenConcertShareView = FunctionNpcFunc.OpenConcertShareView
  if not GameConfig.SystemForbid.BossCardCompose then
    self.funcMap.BossCardCompose = FunctionNpcFunc.BossCardCompose
  end
  self.funcMap.GVGPortal = FunctionNpcFunc.OpenGVGPortal
  self.funcMap.EnterAltmanRaid = FunctionNpcFunc.EnterAltmanRaid
  self.funcMap.GetAltmanRankInfo = FunctionNpcFunc.GetAltmanRankInfo
  self.funcMap.SummonDeadBoss = FunctionNpcFunc.SummonDeadBoss
  self.funcMap.SelectTeamPwsEffect = FunctionNpcFunc.SelectTeamPwsEffect
  self.funcMap.GetPveCardReward = FunctionNpcFunc.GetPveCardReward
  self.funcMap.MoroccSeal = FunctionNpcFunc.MoroccSeal
  self.funcMap.ExpRaidShop = FunctionNpcFunc.ExpRaidShop
  self.funcMap.ExpRaidBegin = FunctionNpcFunc.ExpRaidBegin
  self.funcMap.ExpRaidEntrance = FunctionNpcFunc.ExpRaidEntrance
  self.funcMap.EvaRaid = FunctionNpcFunc.EvaRaid
  self.checkMap.QuickTeam = FunctionNpcFunc.CheckQuickTeam
  self.checkMap.ExitGuild = FunctionNpcFunc.CheckExitGuild
  self.checkMap.OpenGuildRaid = FunctionNpcFunc.CheckOpenGuildRaid
  self.checkMap.ReadyToGuildRaid = FunctionNpcFunc.CheckOpenGuildRaid
  self.checkMap.LaboratoryTeam = FunctionNpcFunc.CheckLaboratoryTeam
  self.checkMap.DojoTeam = FunctionNpcFunc.CheckDojoTeam
  self.checkMap.EndLessTeam = FunctionNpcFunc.CheckEndLessTeam
  self.checkMap.GetOldConsume = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.GetAutumnEquip = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.GetIceCream = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.MillionHitThanks = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.AppointmentThanks = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.ChinaNewYear = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.MonthCard = FunctionNpcFunc.InActiveNpcFunc
  self.checkMap.GiveUpGuildLand = FunctionNpcFunc.CheckGiveUpGuildLand
  self.checkMap.BuildingSubmitMaterial = FunctionNpcFunc.CheckOpenBuildingSubmitMat
  self.checkMap.CatLitterBox = FunctionNpcFunc.CheckCatLitterBox
  self.checkMap.GuildStoreCat = FunctionNpcFunc.CheckGuildStoreAuto
  self.checkMap.GuildStoreAuto = FunctionNpcFunc.CheckStoreAuto
  self.checkMap.SewingRefine = FunctionNpcFunc.CheckSewing
  self.checkMap.SewingStrengthen = FunctionNpcFunc.CheckSewing
  self.checkMap.OpenGuildFunction = FunctionNpcFunc.CheckOpenGuildFunction
  self.checkMap.OpenGuildChallengeTaskView = FunctionNpcFunc.CheckOpenGuildChallengeTaskView
  self.checkMap.HighRefine = FunctionNpcFunc.CheckHighRefine
  self.checkMap.EndLessTower = FunctionNpcFunc.CheckEndLessTower
  self.checkMap.ArtifactMake = FunctionNpcFunc.CheckArtifactMake
  self.checkMap.WeddingDay = FunctionNpcFunc.CheckWeddingDay
  self.checkMap.BookingWedding = FunctionNpcFunc.CheckBookingWedding
  self.checkMap.CancelWedding = FunctionNpcFunc.CheckCancelWedding
  self.checkMap.WeddingCememony = FunctionNpcFunc.CheckWeddingCememony
  self.checkMap.ConsentDivorce = FunctionNpcFunc.CheckConsentDivorce
  self.checkMap.UnilateralDivorce = FunctionNpcFunc.CheckUnilateralDivorce
  self.checkMap.GuildHoldTreasure = FunctionNpcFunc.CheckGuildHoldTreasure
  self.checkMap.EnterRollerCoaster = FunctionNpcFunc.CheckEnterRollerCoaster
  self.checkMap.EnterWeddingMap = FunctionNpcFunc.CheckEnterWeddingMap
  self.checkMap.TakeMarryCarriage = FunctionNpcFunc.CheckTakeMarryCarriage
  self.checkMap.EnterPveCard = FunctionNpcFunc.CheckEnterPveCard
  self.checkMap.PveCard_StartFight = FunctionNpcFunc.CheckEnterPveCard
  self.checkMap.ShowPveCard = FunctionNpcFunc.CheckShowPveCard
  self.checkMap.ChangeClothColor = FunctionNpcFunc.CheckChangeClothColor
  self.checkMap.EnterCapraActivity = FunctionNpcFunc.CheckEnterCapraActivity
  self.checkMap.EquipCompose = FunctionNpcFunc.CheckEquipCompose
  self.checkMap.HireCatConfirm = FunctionNpcFunc.CheckHireCatConfirm
  self.checkMap.SummonDeadBoss = FunctionNpcFunc.CheckSummonDeadBoss
  self.checkMap.SelectTeamPwsEffect = FunctionNpcFunc.CheckSelectTeamPwsEffect
  self.checkMap.ExpRaidShop = FunctionNpcFunc.CheckExpRaid
  self.checkMap.ExpRaidBegin = FunctionNpcFunc.CheckExpRaid
  self.updateCheckMap.TestCheck = FunctionNpcFunc.CheckTestCheck
  self.updateCheckCache = {}
end
function FunctionNpcFunc:PreprocessNpcFunctionConfig(handles)
  local configs = Table_NpcFunction
  local handle
  for k, config in pairs(configs) do
    handle = handles[config.Type]
    if handle ~= nil then
      self.funcMap[config.NameEn] = handle
    end
  end
end
function FunctionNpcFunc:PreprocessNpcFuncCheckConfig(handles)
  local handle
  for k, config in pairs(Table_NpcFunction) do
    handle = handles[config.Type]
    if handle ~= nil then
      self.checkMap[config.NameEn] = handle
    end
  end
end
function FunctionNpcFunc:DoNpcFunc(npcFunctionData, lnpc, param)
  if npcFunctionData == nil then
    return
  end
  local event = self:getFunc(npcFunctionData.id)
  if not event then
    return
  end
  lnpc = lnpc or FunctionVisitNpc.Me():GetTarget()
  if npcFunctionData.id == 5001 or npcFunctionData.id == 5000 then
    FunctionSecurity.Me():TryDoRealNameCentify(function()
      event(lnpc, param, npcFunctionData)
    end)
    return
  end
  return event(lnpc, param, npcFunctionData)
end
function FunctionNpcFunc:GetConfigByKey(key)
  for _, config in pairs(Table_NpcFunction) do
    if key == config.NameEn then
      return config
    end
  end
end
function FunctionNpcFunc:getFunc(id)
  local config = Table_NpcFunction[id]
  return config and self.funcMap[config.NameEn]
end
function FunctionNpcFunc:CheckFuncState(key, npcdata, param)
  if not key then
    return
  end
  local updateCheckState = self:AddUpdateCheckFunc(key, npcdata.data.id, param)
  if updateCheckState ~= nil then
    return updateCheckState
  end
  if self.checkMap[key] then
    return self.checkMap[key](npcdata, param)
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc:AddUpdateCheckFunc(key, npcguid, param)
  local func = self.updateCheckMap[key]
  if func == nil then
    return
  end
  local state, name = func(npcguid, param)
  self.updateCheckCache[key] = {
    key = key,
    state = state,
    name = name,
    npcguid = npcguid,
    param = param
  }
  if self.updateCheck_Tick == nil then
    self.updateCheck_Tick = TimeTickManager.Me():CreateTick(0, 1000, self._updateCheckFunc, self, 1)
  end
  return state, name
end
local stateChangeFuncs = {}
function FunctionNpcFunc:_updateCheckFunc()
  TableUtility.ArrayClear(stateChangeFuncs)
  for key, cache in pairs(self.updateCheckCache) do
    local newV, newName = self.updateCheckMap[key](cache.npcguid, cache.param)
    if newV ~= cache.state then
      cache.state, cache.name = newV, newName
      table.insert(stateChangeFuncs, cache)
    end
  end
  if #stateChangeFuncs > 0 then
    GameFacade.Instance:sendNotification(DialogEvent.NpcFuncStateChange, stateChangeFuncs)
  end
end
function FunctionNpcFunc:RemoveUpdateCheckTick()
  if self.updateCheck_Tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateCheck_Tick = nil
  end
end
function FunctionNpcFunc:RemoveUpdateCheck(key)
  self.updateCheckCache[key] = nil
  if next(self.updateCheckCache) == nil then
    self:RemoveUpdateCheckTick()
  end
end
function FunctionNpcFunc:ClearUpdateCheck()
  TableUtility.TableClear(self.updateCheckCache)
  self:RemoveUpdateCheckTick()
end
function FunctionNpcFunc.TypeFunc_Shop(nnpc, params, npcFunctionData)
  if npcFunctionData.id == 650 then
    UIModelZenyShop.ItemShopID = params
    FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShopItem)
  else
    HappyShopProxy.Instance:InitShop(nnpc, params, npcFunctionData.id)
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {npcdata = nnpc})
  end
end
function FunctionNpcFunc.TypeFunc_NotifyServer(nnpc, param, npcFunctionData)
  ServiceUserEventProxy.Instance:CallTrigNpcFuncUserEvent(nnpc.data.id, npcFunctionData.id)
end
function FunctionNpcFunc.TypeFunc_GuildRaid(nnpc, param, npcFunctionData)
  if npcFunctionData.NameEn == "Unlock" then
    local chooselevel = npcFunctionData.Parama[1]
    local npcid = nnpc.data.staticData.id
    local unlockConfig = GameConfig.GuildRaid[npcid]
    local costTip = ""
    for i = 1, #unlockConfig.UnlockItem do
      local cfg = unlockConfig.UnlockItem[i]
      if cfg and cfg[1] and cfg[2] then
        local itemCfg = Table_Item[cfg[1]]
        if itemCfg then
          costTip = costTip .. itemCfg.NameZh .. cfg[2]
        end
      end
    end
    local unlockText = string.format(ZhString.FunctionNpcFunc_UnlockTip, chooselevel, costTip)
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {unlockText},
      npcinfo = nnpc
    }
    viewdata.addfunc = {}
    viewdata.addfunc[1] = {
      event = function()
        ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_UNLOCK, chooselevel)
      end,
      closeDialog = true,
      NameZh = ZhString.FunctionNpcFunc_Unlock
    }
    viewdata.addfunc[2] = {
      event = function()
        return true
      end,
      NameZh = ZhString.FunctionNpcFunc_Cancel
    }
    FunctionNpcFunc.ShowUI(viewdata)
    break
  elseif npcFunctionData.NameEn == "Open" then
    ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_OPEN)
  elseif npcFunctionData.NameEn == "Enter" then
    local gateInfo = GuildProxy.Instance:GetGuildGateInfoByNpcId(nnpc.data.id)
    if gateInfo and gateInfo.state == Guild_GateState.Open then
      ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_ENTER)
    else
      MsgManager.ShowMsgByIDTable(7202)
    end
  end
end
function FunctionNpcFunc.TypeFunc_InvitethePersonoflove(nnpc, param, npcFunctionData)
  local parama = npcFunctionData.Parama
  local data = Table_DateLand[parama.id]
  local hasTicket = false
  for i = 1, #data.ticket_item do
    local item = BagProxy.Instance:GetItemByStaticID(data.ticket_item[i])
    if item ~= nil then
      hasTicket = true
    end
  end
  if hasTicket == false then
    MsgManager.ShowMsgByID(parama.msgId, data.Name)
    return
  end
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      parama.dialog
    },
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.TypeFunc_AboutDateLand(nnpc, param, npcFunctionData)
  local parama = npcFunctionData.Parama
  MsgManager.DontAgainConfirmMsgByID(parama.msgId)
end
function FunctionNpcFunc.TypeFunc_Augury(nnpc, param, npcFunctionData)
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  if isHandFollow == false and Game.Myself:Client_GetHandInHandFollower() == 0 then
    MsgManager.ShowMsgByID(927)
    return
  end
  local parama = npcFunctionData.Parama
  ServiceSceneAuguryProxy.Instance:CallAuguryInvite(nil, nil, nnpc.data.id, parama.type)
  local dialog = DialogUtil.GetDialogData(GameConfig.Augury.WaitWord)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      dialog.Text
    },
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.TypeFunc_AboutAugury(nnpc, param, npcFunctionData)
  local parama = npcFunctionData.Parama
  local data = Table_Help[parama.helpId]
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  end
end
function FunctionNpcFunc.TypeFunc_Hyperlink(nnpc, param, npcFunctionData)
  local funcParam = npcFunctionData.Parama
  if funcParam.url then
    if ApplicationInfo.IsWindows() then
      Application.OpenURL(funcParam.url)
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WebviewPanel,
        viewdata = {
          directurl = funcParam.url
        }
      })
    end
  end
end
function FunctionNpcFunc.Astrolabe(nnpc, param, npcFunctionData)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, PanelConfig.AstrolabeView)
end
function FunctionNpcFunc.LotteryHeadwear(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryHeadwearView, {npcdata = nnpc})
end
function FunctionNpcFunc.LotteryEquip(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryEquipView, {npcdata = nnpc})
end
function FunctionNpcFunc.LotteryCard(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryCardView, {npcdata = nnpc})
end
function FunctionNpcFunc.CatLitterBox(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryCatLitterBoxView, {npcdata = nnpc})
end
function FunctionNpcFunc.LotteryMagic(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryMagicView, {npcdata = nnpc})
end
function FunctionNpcFunc.LotteryMagicSec(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryMagicSecView, {npcdata = nnpc})
end
function FunctionNpcFunc.Close()
  return false
end
function FunctionNpcFunc.DefeatBoss(nnpc, params)
  local hasAccepted = QuestProxy.Instance:hasQuestAccepted(params)
  if hasAccepted then
    MsgManager.ShowMsgByID(704)
  else
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, params)
  end
end
function FunctionNpcFunc.QueryDefeatBossTime(nnpc, params)
  local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
  local count = 0
  local curCount = 0
  if dailyData then
    count = dailyData.param1
    curCount = dailyData.param2
  end
  local unCount = count - curCount
  local str = string.format(ZhString.NpcFun_DefeatBossCount, curCount, unCount)
  local dialoglist = {str}
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.storehouse(nnpc, params)
  if MyselfProxy.Instance:GetROB() < GameConfig.System.warehouseZeny and BagProxy.Instance:GetItemNumByStaticID(GameConfig.Item.store_item) < 1 then
    MsgManager.ShowMsgByIDTable(1)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.RepositoryView, {npcdata = nnpc})
end
function FunctionNpcFunc.Transfer(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.CharactorProfession, {npcdata = nnpc})
end
function FunctionNpcFunc.Refine(nnpc, params)
  local isfashion = params and params.isfashion
  FunctionNpcFunc.JumpPanel(PanelConfig.NpcRefinePanel, {npcdata = nnpc, isfashion = isfashion})
end
function FunctionNpcFunc.Transmit(nnpc, params)
  printRed("\231\171\158\230\138\128\229\156\186\228\188\160\233\128\129~")
end
function FunctionNpcFunc.EndLessTower(nnpc, params)
  if MyselfProxy.Instance:RoleLevel() >= GameConfig.EndlessTower.limit_user_lv then
    if TeamProxy.Instance:IHaveTeam() then
      local myTeam = TeamProxy.Instance.myTeam
      ServiceInfiniteTowerProxy.Instance:CallTeamTowerInfoCmd(myTeam.id)
    else
      ServiceInfiniteTowerProxy.Instance:CallTowerInfoCmd()
    end
  else
    MsgManager.ShowMsgByID(1315)
  end
end
function FunctionNpcFunc.EndLessTeam(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc})
  elseif FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id) then
    local target = params
    if not target then
      local config = FunctionNpcFunc.Me():GetConfigByKey("EndLessTeam")
      if config.Parama.teamGoal then
        target = config.Parama.teamGoal
      end
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = target})
  end
end
function FunctionNpcFunc.Repair(nnpc, params)
end
function FunctionNpcFunc.DeCompose(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.DeComposeView, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.Laboratory(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    local funcid
    for _, funcCfg in pairs(Table_NpcFunction) do
      if funcCfg.NameEn == "Laboratory" then
        funcid = funcCfg.id
        break
      end
    end
    ServiceNUserProxy.Instance:CallGotoLaboratoryUserCmd(funcid)
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.InstituteChallenge_notTeam)
  end
end
function FunctionNpcFunc.LaboratoryTeam(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc})
  elseif FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id) then
    local target = params
    if not target then
      local config = FunctionNpcFunc.Me():GetConfigByKey("LaboratoryTeam")
      if config.Parama.teamGoal then
        target = config.Parama.teamGoal
      end
    end
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = target})
  end
end
function FunctionNpcFunc.LaboratoryShop(nnpc, params)
  HappyShopProxy.Instance:SetNPC(nnpc)
  HappyShopProxy.Instance:SetParams(params)
  local npcFunction = nnpc.npcData.NpcFunction
  local shopType = 800
  if npcFunction ~= nil then
    for _, v in pairs(npcFunction) do
      local param = v.param
      if param and param == params then
        shopType = v.type
      end
    end
  end
  FuncLaboratoryShop.Instance():OpenUI(shopType, params)
end
function FunctionNpcFunc.Sell(nnpc, params)
  if params == nil then
    params = 1
  end
  ShopSaleProxy.Instance:SetParams(params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ShopSale, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.Teleporter(nnpc, params)
  if TeamProxy.Instance:IHaveTeam() then
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {
        ZhString.KaplaTransmit_SelectTransmitType
      },
      npcinfo = nnpc,
      addfunc = {
        [1] = {
          event = function()
            UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Single
            UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Single
            FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params})
          end,
          closeDialog = true,
          NameZh = ZhString.Transmit
        }
      }
    }
    viewdata.addfunc[2] = {
      event = function()
        if TeamProxy.Instance:IHaveTeam() then
          UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Team
          UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Team
          FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params})
        else
          MsgManager.ShowMsgByID(352)
        end
      end,
      closeDialog = true,
      NameZh = ZhString.TeammateTransmit
    }
    FunctionNpcFunc.ShowUI(viewdata)
    return true
  else
    UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Single
    UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Single
    FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params})
  end
  return nil
end
function FunctionNpcFunc.JoinStage(nnpc, params)
  ServiceNUserProxy.Instance:CallQueryStageUserCmd(0)
  StageProxy.Instance:TakeNpcData(nnpc)
end
function FunctionNpcFunc.PicMake(nnpc, params)
  local bagProxy = BagProxy.Instance
  local bagTypes = bagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce)
  local picType = 50
  local picDatas = {}
  for i = 1, #bagTypes do
    local bagdatas = bagProxy:GetBagItemsByType(picType, bagTypes[i])
    for _, item in pairs(bagdatas) do
      local sdata = item.staticData
      if item:IsPic() and sdata.ComposeID and Table_Compose[sdata.ComposeID] then
        table.insert(picDatas, item)
      end
    end
  end
  local picCount = #picDatas
  if picCount == 0 then
    MsgManager.ShowMsgByIDTable(703)
  elseif picCount == 1 then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PicTipPopUp",
      data = picDatas[1]
    })
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.PicMakeView, {
      npcdata = nnpc,
      params = params,
      datas = picDatas,
      isNpcFuncView = true
    })
  end
end
function FunctionNpcFunc.strengthen(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipStrengthen, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.CreateGuild(nnpc, params)
  if GuildProxy.Instance:IsInJoinCD() then
    MsgManager.ShowMsgByIDTable(4046)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.CreateGuildPopUp, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.ApplyGuild(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildFindPopUp, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.GuildManor(nnpc, params)
  if GuildProxy.Instance:IHaveGuild() then
    ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
  else
    MsgManager.ShowMsgByIDTable(2620)
  end
end
function FunctionNpcFunc.UpgradeGuild(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if not guildData then
    return
  end
  local upConfig = guildData:GetUpgradeConfig()
  if not upConfig then
    return
  end
  local guildLevel = GuildProxy.Instance.myGuildData.level
  if guildLevel >= GuildProxy.Instance:GetGuildMaxLevel() then
    MsgManager.ShowMsgByIDTable(2637)
    return
  end
  FunctionGuild.Me():QueryGuildItemList()
  local upItemId, upItemNum = upConfig.DeductItem[1], upConfig.DeductItem[2]
  local upItemName = upItemId and Table_Item[upItemId] and Table_Item[upItemId].NameZh
  local tipText = string.format(ZhString.FunctionNpcFunc_GuildUpgradeConfirm, tostring(upConfig.ReviewFund), tostring(upItemNum), tostring(upItemName))
  local dialog = {Text = tipText}
  local guildUpEvent = function(npcinfo)
    FunctionGuild.Me():MakeGuildUpgrade()
  end
  local guildUpFunc = {
    event = guildUpEvent,
    closeDialog = true,
    NameZh = ZhString.FunctionNpcFunc_GuildUpgrade
  }
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {dialog},
    addconfig = guildFunc,
    npcinfo = nnpc,
    addfunc = {guildUpFunc},
    addleft = true
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.DisMissGuild(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  local createTime = ClientTimeUtil.FormatTimeTick(ServerTime.CurServerTime() / 1000, "yyyy-MM-dd")
  MsgManager.DontAgainConfirmMsgByID(2803, function()
    local memberlist = guildData:GetMemberList()
    local baseDismissTime = GameConfig.Guild.dismisstime / 3600
    local lastDayOnlineMemeberNum = 0
    for i = 1, #memberlist do
      local offlinetime = memberlist[i].offlinetime
      if offlinetime == 0 then
        lastDayOnlineMemeberNum = lastDayOnlineMemeberNum + 1
      else
        local offlineSec = ServerTime.CurServerTime() / 1000 - offlinetime
        if offlineSec <= 86400 then
          lastDayOnlineMemeberNum = lastDayOnlineMemeberNum + 1
        end
      end
    end
    local dismisstime = #memberlist <= 1 and 0 or baseDismissTime + math.floor(lastDayOnlineMemeberNum / 10)
    MsgManager.DontAgainConfirmMsgByID(2804, function()
      if #memberlist == 1 then
        ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd()
      else
        ServiceGuildCmdProxy.Instance:CallDismissGuildCmd(true)
      end
    end, nil, nil, guildData.name, tostring(dismisstime))
  end, nil, nil, guildData.name, createTime)
end
function FunctionNpcFunc.CancelDissolution(nnpc, params)
  ServiceGuildCmdProxy.Instance:CallDismissGuildCmd(false)
end
function FunctionNpcFunc.ExitGuild(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
  local contribute = myMemberData.contribution
  MsgManager.DontAgainConfirmMsgByID(2802, function()
    ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd()
  end, nil, nil, myGuildData.name, contribute * 0.5)
end
function FunctionNpcFunc.OpenGuildRaid(npc, param)
  helplog("do Open Guild Raid")
end
function FunctionNpcFunc.ReadyToGuildRaid(npc, param)
  helplog("Ready To Guild Raid")
end
function FunctionNpcFunc.AdventureSkill(nnpc, params)
  FuncAdventureSkill.Instance():SetNPCCreature(nnpc)
  FuncAdventureSkill.Instance():OpenUI(1)
end
function FunctionNpcFunc.Dojo(nnpc, params)
  ServiceDojoProxy.Instance:CallDojoQueryStateCmd()
end
function FunctionNpcFunc.QuickTeam(nnpc, param)
  local teamGoal = param or 10000
  if not TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {goalid = teamGoal})
  end
end
function FunctionNpcFunc.DojoTeam(nnpc, params)
  if not TeamProxy.Instance:IHaveTeam() then
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {
      npcdata = nnpc,
      goalid = TeamGoalType.Dojo
    })
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc})
  end
end
function FunctionNpcFunc.PrimaryEnchant(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantView, {
    enchantType = EnchantType.Primary,
    npcdata = nnpc
  })
end
function FunctionNpcFunc.MediumEnchant(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantView, {
    enchantType = EnchantType.Medium,
    npcdata = nnpc
  })
end
function FunctionNpcFunc.SeniorEnchant(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EnchantView, {
    enchantType = EnchantType.Senior,
    npcdata = nnpc
  })
end
function FunctionNpcFunc.seal(nnpc, params)
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByIDTable(1607)
  else
    FunctionNpcFunc.JumpPanel(PanelConfig.SealTaskPopUp, {
      enchantType = EnchantType.Senior,
      npcdata = nnpc
    })
  end
end
function FunctionNpcFunc.GuildDonate(nnpc, params)
  local guildData = GuildProxy.Instance.myGuildData
  if guildData then
    local myGuildMembData = GuildProxy.Instance:GetMyGuildMemberData()
    if myGuildMembData then
      local entertime = myGuildMembData.entertime
      local donatelimit = GameConfig.Guild.donate_limittime or 24
      donatelimit = donatelimit * 3600
      if donatelimit <= ServerTime.CurServerTime() / 1000 - entertime then
        FunctionNpcFunc.JumpPanel(PanelConfig.GuildDonateView, {npcdata = nnpc})
      else
        MsgManager.ShowMsgByIDTable(2647)
      end
    end
  else
    MsgManager.ShowMsgByIDTable(2620)
  end
end
local npcFunction, shopType
local GetShopType = function(npc, param)
  npcFunction = npc and npc.data and npc.data.staticData and npc.data.staticData.NpcFunction
  if npcFunction then
    for _, v in pairs(npcFunction) do
      if v.param and v.param == param then
        return v.type
      end
    end
  end
  return nil
end
function FunctionNpcFunc.ChangeHairStyle(nnpc, params)
  shopType = GetShopType(nnpc, params)
  if shopType then
    ShopDressingProxy.Instance:InitProxy(params, shopType)
    FunctionNpcFunc.JumpPanel(PanelConfig.HairDressingView)
  end
end
function FunctionNpcFunc.ChangeEyeLenses(nnpc, params)
  shopType = GetShopType(nnpc, params)
  if shopType then
    ShopDressingProxy.Instance:InitProxy(params, shopType)
    FunctionNpcFunc.JumpPanel(PanelConfig.EyeLensesView)
  end
end
function FunctionNpcFunc.ChangeClothColor(nnpc, params)
  shopType = GetShopType(nnpc, params)
  if shopType then
    ShopDressingProxy.Instance:InitProxy(params, shopType)
    FunctionNpcFunc.JumpPanel(PanelConfig.ClothDressingView)
  end
end
function FunctionNpcFunc.GuildPray(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildPrayDialog, {npcdata = nnpc})
end
function FunctionNpcFunc.GvGPvpPray(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GvGPvPPrayDialog, {npcdata = nnpc})
end
function FunctionNpcFunc.DyeCloth(nnpc, params)
  MsgManager.FloatMsgTableParam(nil, ZhString.ItemTip_LockCardSlot)
end
function FunctionNpcFunc.EquipMake(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipMakeView, {npcdata = nnpc})
end
function FunctionNpcFunc.EquipRecover(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipRecoverView, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.Exchange(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.ShopMallMainView)
end
function FunctionNpcFunc.ChangeGuildLine(nnpc, params)
  ServiceNUserProxy.Instance:CallQueryZoneStatusUserCmd()
  local count = GuildProxy.Instance:GetGuildPackItemNumByItemid(GameConfig.Zone.guild_zone_exchange.cost[1][1])
  local dialogStr = DialogUtil.GetDialogData(8230).Text
  local str = string.format(dialogStr, count)
  local dialoglist = {str}
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    npcinfo = nnpc,
    subViewId = 3
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.GetCdkey(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.GiftActivePanel)
end
function FunctionNpcFunc.ReleaseActivity(npc, param)
  local viewdata = {
    viewname = "TempActivityView",
    viewdata = {
      Config = {
        Params = GameConfig.Activity.ReleaseActivity
      }
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
end
function FunctionNpcFunc.FindGM(npc, param)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      GameConfig.Activity.GMInfo.Text
    },
    npcinfo = npc
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.QuestionSurvey(npc, param)
  local viewdata = {
    viewname = "TempActivityView",
    viewdata = {
      Config = {
        Params = GameConfig.Activity.QuestionSurvey
      }
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
end
function FunctionNpcFunc.AutumnAdventure(npc, param)
  local viewdata = {
    viewname = "TempActivityView",
    viewdata = {
      Config = {
        Params = GameConfig.Activity.AutumnAdventure
      }
    }
  }
  FunctionNpcFunc.ShowUI(viewdata)
end
function FunctionNpcFunc.GetIceCream(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Summer)
  return true
end
function FunctionNpcFunc.GetAutumnEquip(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Autumn)
  return true
end
function FunctionNpcFunc.MillionHitThanks(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_CodeBW)
  return true
end
function FunctionNpcFunc.AppointmentThanks(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_CodeMX)
  return true
end
function FunctionNpcFunc.ChinaNewYear(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_RedBag)
  return true
end
function FunctionNpcFunc.Safetyrewards(npc, param)
  ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Phone)
  return true
end
function FunctionNpcFunc.MonthCard(npc, subKey)
  if subKey then
    ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_MonthCard, nil, subKey)
    return true
  end
end
function FunctionNpcFunc.QuestActAnswer(npc, param)
  if npc then
    FunctionXO.Me():QueryQuestion(npc.data.id)
  end
  return true
end
function FunctionNpcFunc.GetOldConsume(npc, param)
  helplog("param", param[1], param[2], param[3])
  local viewdata = {viewname = "DialogView", npcinfo = npc}
  local oldConsumeTip = string.format(ZhString.FunctionNpcFunc_GetOldConsumeTip, param[1], param[3] or 0)
  viewdata.dialoglist = {oldConsumeTip}
  local getEvent = function()
    ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Charge)
  end
  local laterGetEvent = function()
    local lgviewdata = {viewname = "DialogView"}
    local timeDateInfo = os.date("*t", param[2])
    local text = string.format(ZhString.FunctionNpcFunc_LaterGetOldConsumeTip, timeDateInfo.month, timeDateInfo.day, timeDateInfo.hour)
    lgviewdata.dialoglist = {text}
    lgviewdata.npcinfo = npc
    FunctionNpcFunc.ShowUI(lgviewdata)
  end
  viewdata.addfunc = {}
  viewdata.addfunc[1] = {
    event = getEvent,
    closeDialog = true,
    NameZh = ZhString.FunctionNpcFunc_GetOldConsumeButton
  }
  viewdata.addfunc[2] = {
    event = laterGetEvent,
    NameZh = ZhString.FunctionNpcFunc_LaterGetOldConsumeButton
  }
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.Opengift(npc, parama)
  if npc.data.type == SceneMap_pb.EGiveType_Trade then
    ServiceRecordTradeProxy.Instance:CallReqGiveItemInfoCmd(npc.data.giveid)
  else
    ServiceSessionMailProxy.Instance:CallGetMailAttach({
      npc.data.giveid
    })
  end
end
function FunctionNpcFunc.HireCatInfo(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.HireCatInfoView, {catid = param})
end
function FunctionNpcFunc.HelpGuildChallenge(npc, param)
  if GuildProxy.Instance:IsInJoinCD() then
    MsgManager.ShowMsgByIDTable(4046)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.CreateGuildPopUp, {
    npcdata = nnpc
  })
  return true
end
function FunctionNpcFunc.CardRandomMake(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardRandomMakeView, {npcdata = npc})
end
function FunctionNpcFunc.CardMake(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardMakeView, {npcdata = npc})
end
function FunctionNpcFunc.CardDecompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.CardDecomposeView, {npcdata = npc})
end
function FunctionNpcFunc.AuctionShop(npc, param)
  ServiceAuctionCCmdProxy.Instance:CallReqAuctionInfoCCmd()
end
function FunctionNpcFunc.TestCheck(npc, param)
  helplog("TestCheck")
end
function FunctionNpcFunc.ChangeGuildName(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildChangeNamePopUp, {npcdata = npc})
end
function FunctionNpcFunc.GiveUpGuildLand(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  local giveUpCd = myGuildData.citygiveuptime
  local cityid = myGuildData.cityid
  if (cityid == nil or cityid == 0) and (giveUpCd == nil or giveUpCd == 0) then
    MsgManager.ShowMsgByID(2209)
    return
  end
  local viewdata = {}
  if giveUpCd and giveUpCd > 0 then
    viewdata.iscancel = true
    viewdata.msgId = 2200
    function viewdata.confirmHandler()
      helplog("CallCityActionGuildCmd", GuildCmd_pb.ECITYACTION_CANCEL_GIVEUP)
      ServiceGuildCmdProxy.Instance:CallCityActionGuildCmd(GuildCmd_pb.ECITYACTION_CANCEL_GIVEUP)
    end
  else
    viewdata.iscancel = false
    viewdata.msgId = 2199
    function viewdata.confirmHandler()
      helplog("CallCityActionGuildCmd", GuildCmd_pb.ECITYACTION_GIVEUP)
      ServiceGuildCmdProxy.Instance:CallCityActionGuildCmd(GuildCmd_pb.ECITYACTION_GIVEUP)
    end
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UniqueConfirmView_GvgLandGiveUp,
    viewdata = viewdata
  })
end
function FunctionNpcFunc.EquipAlchemy(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipAlchemyView, {npcdata = npc, groupid = param})
end
function FunctionNpcFunc.EnterCapraActivity(npc, param)
  local actId = GameConfig.Activity.SaveCapra and GameConfig.Activity.SaveCapra.ActivityID or 6
  local running = FunctionActivity.Me():IsActivityRunning(actId)
  if running then
    ServiceNUserProxy.Instance:CallEnterCapraActivityCmd()
  else
    MsgManager.ShowMsgByIDTable(7202)
  end
end
function FunctionNpcFunc.EnterAltmanRaid(npc, param)
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByIDTable(332)
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local memberlist = myTeam:GetMembersList()
  local hasMemberInRaid = false
  for i = 1, #memberlist do
    local raid = memberlist[i].raid
    local raidData = raid and Table_MapRaid[raid]
    if raidData and raidData.Type == FuBenCmd_pb.ERAIDTYPE_ALTMAN then
      hasMemberInRaid = true
      break
    end
  end
  if hasMemberInRaid then
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN)
    return
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByIDTable(7303)
    return
  end
  RaidEnterWaitView.SetListenEvent(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, function(view, note)
    local charid, agree = note.body.charid, note.body.reply
    view:UpdateMemberEnterState(charid, agree)
    view:UpdateWaitList()
  end)
  local configid = params
  RaidEnterWaitView.SetStartFunc(function(view)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN)
    view:CloseSelf()
  end)
  RaidEnterWaitView.SetCancelFunc(function(view)
    view:CloseSelf()
  end)
  ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(nil, FuBenCmd_pb.ERAIDTYPE_ALTMAN)
  FunctionNpcFunc.JumpPanel(PanelConfig.RaidEnterWaitView)
end
function FunctionNpcFunc.GetAltmanRankInfo(nnpc, param)
  ServiceNUserProxy.Instance:CallQueryAltmanKillUserCmd()
end
function FunctionNpcFunc.SummonDeadBoss(nnpc, param)
  ServiceFuBenCmdProxy.Instance:CallInviteSummonBossFubenCmd()
end
function FunctionNpcFunc.SelectTeamPwsEffect(nnpc, param)
  local teamId = TeamProxy.Instance.myTeam.id
  local enemyBall
  local red = PvpProxy.Instance:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Red)
  if red and red.teamid ~= teamId then
    enemyBall = red.balls
  else
    local blue = PvpProxy.Instance:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Blue)
    enemyBall = blue.balls
  end
  local ballCount = 0
  for k, _ in pairs(enemyBall) do
    ballCount = ballCount + 1
  end
  if ballCount <= 2 then
    MsgManager.ShowMsgByIDTable(856)
    return
  end
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  if _PvpTeamRaid == nil then
    _, _PvpTeamRaid = next(GameConfig.PvpTeamRaid)
  end
  local dialogID = _PvpTeamRaid.SelectEffectDialogId
  local text = DialogUtil.GetDialogData(dialogID).Text
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {text},
    npcinfo = nnpc
  }
  viewdata.addfunc = {}
  local elementCombine = _PvpTeamRaid.ElementCombine
  local option_event = function(nnpc, configid)
    ServiceFuBenCmdProxy.Instance:CallSelectTeamPwsMagicFubenCmd(configid)
  end
  for k, v in pairs(elementCombine) do
    local match = true
    for n in tostring(k):gmatch("%d") do
      if not enemyBall[tonumber(n)] then
        match = false
        break
      end
    end
    if match then
      local option = {}
      option.NameZh = v.name
      option.event = option_event
      option.eventParam = k
      option.closeDialog = true
      table.insert(viewdata.addfunc, option)
    end
  end
  table.sort(viewdata.addfunc, function(a, b)
    return a.eventParam < b.eventParam
  end)
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc.GuildBuilding(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingView, {npcdata = nnpc})
end
function FunctionNpcFunc.BuildingSubmitMaterial(nnpc, param)
  local data = GuildBuildingProxy.Instance:GetCurBuilding()
  if data and param == data.type then
    GuildBuildingProxy.Instance:InitBuilding(nnpc, param)
    FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingMatSubmitView, {npcdata = nnpc})
  end
end
function FunctionNpcFunc.ReportPoringFight(npc, param)
  if PvpProxy.Instance:Is_polly_match() then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  local running = FunctionActivity.Me():IsActivityRunning(GameConfig.PoliFire.PoringFight_ActivityId or 111)
  helplog("FunctionNpcFunc ReportPoringFight", running)
  if running then
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.PoringFight)
  else
    MsgManager.ShowMsgByIDTable(3605)
  end
end
function FunctionNpcFunc.ReportMvpFight(npc, param)
  local tipActID = GameConfig.MvpBattle.ActivityID or 4000000
  local running = FunctionActivity.Me():IsActivityRunning(tipActID)
  if not running then
    MsgManager.ShowMsgByIDTable(7300)
    return
  end
  local baselv = GameConfig.MvpBattle.BaseLevel
  local rolelv = MyselfProxy.Instance:RoleLevel()
  if baselv > rolelv then
    MsgManager.ShowMsgByID(7301, baselv)
    return
  end
  local teamProxy = TeamProxy.Instance
  if not teamProxy:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  if not teamProxy:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(7303)
    return
  end
  local mblsts = teamProxy.myTeam:GetMembersListExceptMe()
  for i = 1, #mblsts do
    if baselv > mblsts[i].baselv then
      MsgManager.ShowMsgByID(7305, baselv)
      return
    end
  end
  local matchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.MvpFight)
  if matchStatus and matchStatus.ismatch then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.MvpFight)
end
function FunctionNpcFunc.OpenGuildFunction(npc, param)
  ServiceGuildCmdProxy.Instance:CallOpenFunctionGuildCmd(GuildCmd_pb.EGUILDFUNCTION_BUILDING)
end
function FunctionNpcFunc.SewingStrengthen(npc, param)
  FunctionMiyinStrengthen.Ins():SetNPCCreature(npc)
  FunctionMiyinStrengthen.Ins():OpenUI()
end
function FunctionNpcFunc.OpenGuildChallengeTaskView(npc, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GuildChallengeTaskPopUp
  })
end
function FunctionNpcFunc.HighRefine(npc, param)
  local unlockPoses = BlackSmithProxy.Instance:GetHighRefinePoses()
  if unlockPoses == nil or #unlockPoses == 0 then
    MsgManager.ShowMsgByIDTable(3605)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.HighRefinePanel, {npcdata = npc})
end
function FunctionNpcFunc.SewingRefine(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.NpcRefinePanel, {
    npcdata = nnpc,
    isfashion = true
  })
end
function FunctionNpcFunc.ArtifactMake(npc, param)
  ArtifactProxy.Instance:InitParam(param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ArtifactMakeView, {npcdata = npc})
end
function FunctionNpcFunc.GuildHoldTreasure(npc, param)
  ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil, nil, nil, GuildTreasureProxy.ActionType.GVG_FRAME_ON)
end
function FunctionNpcFunc.GuildTreasure(npc, param)
  ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil, nil, nil, GuildTreasureProxy.ActionType.GUILD_FRAME_ON)
end
function FunctionNpcFunc.GuildTreasurePreview(npc, param)
  GuildTreasureProxy.Instance:SetViewType(3)
  FunctionNpcFunc.JumpPanel(PanelConfig.GuildTreasureView, {npcdata = npc})
end
function FunctionNpcFunc.ReturnArtifact(npc, param)
  local myArt = ArtifactProxy.Instance:GetMySelfArtifact()
  if myArt and #myArt > 0 then
    FunctionNpcFunc.JumpPanel(PanelConfig.ReturnArtifactView, {npcdata = npc})
  else
    MsgManager.ShowMsgByID(3787)
  end
end
function FunctionNpcFunc.ServerOpenFunction(npc, param)
  GameFacade.Instance:sendNotification(DialogEvent.ServerOpenFunction, {
    npcdata = nnpc,
    param = param
  })
end
function FunctionNpcFunc.YoyoSeat(npc, param)
  ServiceNUserProxy.Instance:CallYoyoSeatUserCmd(npc.data.id)
end
function FunctionNpcFunc.UpJobLevel(npc, param)
  local userdata = Game.Myself.data.userdata
  local jobLv = userdata:Get(UDEnum.JOBLEVEL)
  if jobLv < 91 then
    MsgManager.ShowMsgByID(25442)
    return
  end
  FunctionDialogEvent.SetDialogEventEnter("UpJobLevel", npc)
  return true
end
function FunctionNpcFunc.WeddingCememony(npc, param)
  if not WeddingProxy.Instance:IsHandPartner() then
    MsgManager.ShowMsgByIDTable(9644)
    return
  end
  helplog("Call-->InviteBeginWeddingCCmd")
  ServiceWeddingCCmdProxy.Instance:CallInviteBeginWeddingCCmd()
end
function FunctionNpcFunc.WeddingDay(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.EngageMainView, {
    viewEnum = WeddingProxy.EngageViewEnum.Check
  })
end
function FunctionNpcFunc.BookingWedding(npc, param)
  if not WeddingProxy.Instance:IsSelfSingle() then
    MsgManager.ShowMsgByID(9601)
    return
  end
  local _Myself = Game.Myself
  local isHandFollow = _Myself:Client_IsFollowHandInHand()
  if isHandFollow == false and _Myself:Client_GetHandInHandFollower() == 0 then
    MsgManager.ShowMsgByID(9600)
    return
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.EngageMainView, {
    viewEnum = WeddingProxy.EngageViewEnum.Book
  })
end
function FunctionNpcFunc.CancelWedding(npc, param)
  local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
  if weddingInfo ~= nil and weddingInfo.status == WeddingInfoData.Status.Reserve then
    MsgManager.ConfirmMsgByID(9611, function()
      ServiceWeddingCCmdProxy.Instance:CallGiveUpReserveCCmd(weddingInfo.id)
    end)
  end
end
function FunctionNpcFunc.ConsentDivorce(npc, param)
  local _TeamProxy = TeamProxy.Instance
  if not _TeamProxy:IHaveTeam() then
    MsgManager.ShowMsgByID(9622)
    return
  end
  local _WeddingProxy = WeddingProxy.Instance
  local partner = _WeddingProxy:GetPartnerData()
  if partner == nil then
    return
  end
  local partnerGuid = partner.charid
  if partnerGuid == nil then
    return
  end
  if _TeamProxy.myTeam.memberNum ~= 2 or not _TeamProxy:IsInMyTeam(partnerGuid) then
    MsgManager.ShowMsgByID(9622)
    return
  end
  local partnerTeamData = _TeamProxy.myTeam:GetMemberByGuid(partnerGuid)
  if partnerTeamData:IsOffline() then
    MsgManager.ShowMsgByID(9624)
    return
  end
  local creature = NSceneUserProxy.Instance:Find(partnerGuid)
  if creature == nil or VectorUtility.DistanceXZ(Game.Myself:GetPosition(), creature:GetPosition()) > GameConfig.Wedding.Divorce_NpcDistance then
    MsgManager.ShowMsgByID(9623)
    return
  end
  local weddingInfo = _WeddingProxy:GetWeddingInfo()
  if weddingInfo ~= nil then
    local _Myself = Game.Myself
    local canDivorce = _Myself and _Myself.data.userdata:Get(UDEnum.DIVORCE_ROLLERCOASTER) or 0
    if canDivorce == 1 then
      MsgManager.ConfirmMsgByID(9613, function()
        ServiceWeddingCCmdProxy.Instance:CallReqDivorceCCmd(weddingInfo.id, WeddingCCmd_pb.EGiveUpType_Together)
      end, nil, nil, partner.name)
    else
      ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterInviteCCmd(nil, partnerGuid)
    end
  end
end
function FunctionNpcFunc.UnilateralDivorce(npc, param)
  local _WeddingProxy = WeddingProxy.Instance
  local weddingInfo = _WeddingProxy:GetWeddingInfo()
  if weddingInfo ~= nil then
    MsgManager.ConfirmMsgByID(9621, function()
      ServiceWeddingCCmdProxy.Instance:CallReqDivorceCCmd(weddingInfo.id, WeddingCCmd_pb.EGiveUpType_Single)
    end, nil, nil, _WeddingProxy:GetPartnerName())
  end
end
function FunctionNpcFunc.EnterRollerCoaster(npc, param)
  if not WeddingProxy.Instance:IsHandPartner() then
    MsgManager.ShowMsgByID(927)
    return
  end
  ServiceWeddingCCmdProxy.Instance:CallEnterRollerCoasterCCmd()
end
function FunctionNpcFunc.TakeMarryCarriage(npc, param)
  if not WeddingProxy.Instance:IsHandPartner() then
    MsgManager.ShowMsgByID(927)
    return
  end
  ServiceWeddingCCmdProxy.Instance:CallWeddingCarrierCCmd()
end
function FunctionNpcFunc.EnterWeddingMap(npc, param)
  local letters = {}
  local marryInviteLetters = BagProxy.Instance:GetMarryInviteLetters()
  for i = 1, #marryInviteLetters do
    local weddingData = marryInviteLetters[i].weddingData
    if weddingData and weddingData:CheckInWeddingTime() then
      table.insert(letters, marryInviteLetters[i])
    end
  end
  local curline = MyselfProxy.Instance:GetZoneId()
  if #letters > 0 then
    local sameline = false
    for i = 1, #letters do
      if letters[i].weddingData.zoneid == curline then
        sameline = true
      end
    end
    if not sameline then
      MsgManager.ShowMsgByID(9619)
      return
    end
  else
    local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
    if weddingInfo.zoneid % 10000 ~= curline then
      MsgManager.ShowMsgByID(9650)
      return
    end
  end
  ServiceWeddingCCmdProxy.Instance:CallEnterWeddingMapCCmd()
end
function FunctionNpcFunc.WeddingRingShop(nnpc, params, npcFunctionData)
  HappyShopProxy.Instance:InitShop(nnpc, params, npcFunctionData.id)
  FunctionNpcFunc.JumpPanel(PanelConfig.WeddingRingView, {npcdata = nnpc})
end
function FunctionNpcFunc.GetPveCardReward(nnpc, params)
  ServicePveCardProxy.Instance:CallGetPveCardRewardCmd()
end
function FunctionNpcFunc.EnterPveCard(nnpc, params)
  local dialoglist = {
    GameConfig.CardRaid.EnterDialogId
  }
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    npcinfo = nnpc
  }
  viewdata.addfunc = {}
  local diffCfg = GameConfig.CardRaid.Diff
  if diffCfg == nil then
    diffCfg = _EmptyTable
    redlog("Not Config PveCard_Diff")
  end
  for i = 1, #params do
    local configid = params[i]
    viewdata.addfunc[i] = {
      event = function()
        FunctionNpcFunc._DoEnterPveCard(configid)
      end,
      closeDialog = true,
      NameZh = diffCfg[i] and diffCfg[i].name or "Not Config PveCard_Diff"
    }
    break
  end
  helplog("FunctionNpcFunc EnterPveCard")
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionNpcFunc._DoEnterPveCard(configid)
  RaidEnterWaitView.SetListenEvent(ServiceEvent.PveCardReplyPveCardCmd, function(view, note)
    local charid, agree = note.body.charid, note.body.agree
    view:UpdateMemberEnterState(charid, agree)
    view:UpdateWaitList()
  end)
  RaidEnterWaitView.SetStartFunc(function(view)
    ServicePveCardProxy.Instance:CallSelectPveCardCmd(configid)
    ServicePveCardProxy.Instance:CallEnterPveCardCmd(configid)
    view:CloseSelf()
  end)
  RaidEnterWaitView.SetCancelFunc(function(view)
    view:CloseSelf()
  end)
  ServicePveCardProxy.Instance:CallInvitePveCardCmd(configid)
  FunctionNpcFunc.JumpPanel(PanelConfig.RaidEnterWaitView)
end
function FunctionNpcFunc.ShowPveCard(nnpc, params)
  local configid = params
  FunctionNpcFunc.JumpPanel(PanelConfig.OricalCardInfoView, {index = configid})
end
function FunctionNpcFunc.SelectPveCard(nnpc, params)
  local configid = params
  ServicePveCardProxy.Instance:CallSelectPveCardCmd(configid)
end
function FunctionNpcFunc.PveCard_StartFight(nnpc)
  ServicePveCardProxy.Instance:CallBeginFirePveCardCmd()
end
function FunctionNpcFunc.OpenGVGPortal(npc, param)
  local viewdata = {
    viewname = "GVGPortalView",
    view = PanelConfig.GVGPortalView,
    npcinfo = nnpc
  }
  FunctionNpcFunc.ShowUI(viewdata)
end
function FunctionNpcFunc.EnterPoringFight(npc, param)
  ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(SceneUser2_pb.EFUNCMAPTYPE_POLLY)
end
function FunctionNpcFunc.EquipCompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipComposeView)
end
function FunctionNpcFunc.HireCatConfirm(npc, param)
  local viewdata = {
    viewname = "HireCatPopUp",
    catid = param[1],
    isNewHire = true
  }
  FunctionNpcFunc.ShowUI(viewdata)
end
function FunctionNpcFunc.DialogGoddessOfferDead(npc, param)
  FunctionDialogEvent.SetDialogEventEnter("DialogGoddessOfferDead", npc)
  return true
end
function FunctionNpcFunc.DeathTransfer(nnpc, params)
  UIMapMapList.transmitType = UIMapMapList.E_TransmitType.DeathKingdom
  UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.DeathKingdom
  FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params})
end
function FunctionNpcFunc.BeatBoli(nnpc, params)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HitBoliView
  })
end
function FunctionNpcFunc.CourageRanking(nnpc, params)
  FunctionNpcFunc.JumpPanel(PanelConfig.CourageRankPopUp)
end
function FunctionNpcFunc.MoroccSeal(nnpc)
  FunctionRepairSeal.Me():DoMoroccConfirmRepair(nnpc.data.staticData.id)
end
function FunctionNpcFunc.ExpRaidShop(nnpc, param)
  ExpRaidProxy.Instance:InitShop(nnpc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ExpRaidShopView)
end
function FunctionNpcFunc.ExpRaidBegin()
  ExpRaidProxy.Instance:CallBeginRaid()
end
function FunctionNpcFunc.ExpRaidEntrance()
  FunctionNpcFunc.JumpPanel(PanelConfig.ExpRaidMapView)
end
function FunctionNpcFunc.EvaRaid(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.ActivityDungeonView, {npcdata = npc})
end
function FunctionNpcFunc.BossCardCompose(npc, param)
  FunctionNpcFunc.JumpPanel(PanelConfig.BossCardComposeView, {npcdata = npc})
end
function FunctionNpcFunc.ShowUI(viewdata)
  if viewdata then
    local vdata = viewdata.viewdata or {}
    vdata.isNpcFuncView = true
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
end
function FunctionNpcFunc.JumpPanel(panel, viewdata)
  if panel then
    viewdata = viewdata or {}
    viewdata.isNpcFuncView = true
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panel, viewdata = viewdata})
  end
end
function FunctionNpcFunc.CheckQuickTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckLaboratoryTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckDojoTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckEndLessTeam(npc, param)
  if TeamProxy.Instance:IHaveTeam() then
    return NpcFuncState.Grey
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckCatLitterBox(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX)
end
function FunctionNpcFunc.CheckGuildStoreAuto(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_BAR)
end
function FunctionNpcFunc.CheckStoreAuto(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_VENDING_MACHINE)
end
function FunctionNpcFunc.CheckSewing(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
end
function FunctionNpcFunc.CheckArtifactMake(npc, param)
  if ArtifactProxy.Type.WeaponArtifact == param then
    return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
  elseif ArtifactProxy.Type.HeadBackArtifact == param then
    return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_ARTIFACT_HEAD)
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckGuildHoldTreasure(npc, param)
  local hasHoldTreasure = GuildTreasureProxy.Instance:HasGuildHoldTreasure()
  if hasHoldTreasure and GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.checkBuildingActiveSelf(type)
  local data = GuildBuildingProxy.Instance:GetCurBuilding()
  if data and data.type == type and data.level < 1 then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckOpenGuildRaid(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    local leftRaidTime = myGuildData.nextraidTime - ServerTime.CurServerTime() / 1000
    local canOpenRaid = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.OpenGuildRaid)
    if leftRaidTime <= 0 and canOpenRaid then
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.InActiveNpcFunc(npc, param)
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckGiveUpGuildLand(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return NpcFuncState.InActive
  end
  if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GiveUpLand) then
    local cdTime = myGuildData.citygiveuptime
    if cdTime and cdTime > 0 then
      return NpcFuncState.Active, ZhString.FunctionNpcFunc_CancelGiveUpGuildLand
    else
      return NpcFuncState.Active, ZhString.FunctionNpcFunc_GiveUpGuildLand
    end
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckOpenBuildingSubmitMat(npc, param)
  if npc and npc.data and npc.data.staticData then
    npcFunction = npc.data.staticData.NpcFunction
  end
  if npcFunction then
    if #npcFunction > 1 then
      local data = GuildBuildingProxy.Instance:GetCurBuilding()
      if data and param == data.type and data.level > 0 then
        return NpcFuncState.Active
      end
      return NpcFuncState.InActive
    else
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckOpenGuildFunction(npc, param)
  if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.OpenGuildFunction) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckOpenGuildChallengeTaskView(npc, param)
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return NpcFuncState.InActive
  end
  if not myGuildData:CheckFunctionOpen(GuildCmd_pb.EGUILDFUNCTION_BUILDING) then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckHighRefine(npc, param)
  return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
end
function FunctionNpcFunc.CheckEndLessTower(npc, param)
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckWeddingDay(npc, param)
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckBookingWedding(npc, param)
  if not WeddingProxy.Instance:IsSelfEngage() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckCancelWedding(npc, param)
  local _WeddingProxy = WeddingProxy.Instance
  if _WeddingProxy:IsSelfEngage() and not _WeddingProxy:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckWeddingCememony(npc, param)
  if WeddingProxy.Instance:IsSelfMarried() then
    return NpcFuncState.InActive
  end
  if WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckConsentDivorce(npc, param)
  if WeddingProxy.Instance:IsSelfMarried() and not WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckUnilateralDivorce(npc, param)
  if WeddingProxy.Instance:CanSingleDivorce() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckEnterRollerCoaster(npc, param)
  if WeddingProxy.Instance:IsSelfMarried() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckEnterWeddingMap(npc, param)
  if WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  local marryInviteLetters = BagProxy.Instance:GetMarryInviteLetters()
  for i = 1, #marryInviteLetters do
    local weddingData = marryInviteLetters[i].weddingData
    if weddingData and weddingData:CheckInWeddingTime() then
      return NpcFuncState.Active
    end
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckTakeMarryCarriage(npc, param)
  if WeddingProxy.Instance:IsSelfInWeddingTime() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckEnterPveCard(npc, param)
  local config = GameConfig.SystemForbid.EnterPveCard
  if config and param == 4 then
    return NpcFuncState.InActive
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckShowPveCard(npc, param)
  local config = GameConfig.SystemForbid.ShowPveCard
  if config and param == 4 then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckChangeClothColor(npc, param)
  local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if myClass % 10 >= 4 then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckEnterCapraActivity()
  local actId = GameConfig.Activity.SaveCapra and GameConfig.Activity.SaveCapra.ActivityID or 6
  local running = FunctionActivity.Me():IsActivityRunning(actId)
  if not running then
    return NpcFuncState.InActive
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.CheckExitGuild(npc, param)
  if GuildProxy.Instance:IHaveGuild() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckEquipCompose(npc, param)
  if FunctionUnLockFunc.Me():CheckCanOpen(param) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckHireCatConfirm(npc, param)
  if FunctionUnLockFunc.Me():CheckCanOpen(param[2]) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckSummonDeadBoss()
  if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckSelectTeamPwsEffect(npc, param)
  if not Game.MapManager:IsPVPMode_TeamPws() then
    return NpcFuncState.InActive
  end
  if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckTypeFunc_Shop(npc, param)
  if npc and npc.data and npc.data.staticData then
    npcFunction = npc.data.staticData.NpcFunction
  end
  if npcFunction then
    for _, v in pairs(npcFunction) do
      local NameEn = v.type and Table_NpcFunction[v.type] and Table_NpcFunction[v.type].NameEn
      if NameEn and NameEn == "GuildMaterialShop" then
        local buildlv = GuildBuildingProxy.Instance:GetBuildingLevelByType(GuildBuildingProxy.Type.EGUILDBUILDING_EGUILDBUILDING_MATERIAL_MACHINE)
        if buildlv and buildlv > 0 then
          return NpcFuncState.Active
        else
          return NpcFuncState.InActive
        end
      end
    end
  end
  return NpcFuncState.Active
end
function FunctionNpcFunc.OpenKFCShareView(npc, param)
  autoImport("FloatAwardView")
  if FloatAwardView.ShareFunctionIsOpen() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.KFCActivityShowView,
      viewdata = param
    })
  end
end
function FunctionNpcFunc.OpenConcertShareView(npc, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SharePanel,
    viewdata = param
  })
end
function FunctionNpcFunc.CheckGetPveCardReward(npc, param)
  local npcSData = npc.data.staticData
  if npcSData == nil then
    return NpcFuncState.InActive
  end
  if QuestSymbolCheck.HasPveCardSymbolCheck(npcSData) then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.CheckExpRaid()
  if Game.MapManager:IsPVEMode_ExpRaid() then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
local testTime
function FunctionNpcFunc.CheckTestCheck(npcguid, param)
  if testTime == nil then
    testTime = ServerTime.CurServerTime() / 1000 + 20
  end
  if ServerTime.CurServerTime() / 1000 < testTime then
    return NpcFuncState.Active
  end
  return NpcFuncState.InActive
end
function FunctionNpcFunc.LotteryMagic(nnpc, param, npcFunctionData)
  FunctionNpcFunc.JumpPanel(PanelConfig.LotteryMagicView, {npcdata = nnpc})
end
