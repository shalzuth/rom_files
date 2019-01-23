FunctionNpcFunc = class("FunctionNpcFunc")

autoImport('FuncLaboratoryShop')
autoImport('FuncAdventureSkill')
autoImport('FunctionMiyinStrengthen')
autoImport('FuncZenyShop')
autoImport('UIModelZenyShop')
autoImport('UIMapAreaList')
autoImport('UIMapMapList')

autoImport("RaidEnterWaitView");

NpcFuncState = {
	Active = 1,
	InActive = 2,
	Grey = 3,
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
}

function FunctionNpcFunc:ctor()
	self.funcMap = {};
	self.checkMap = {};
	self.updateCheckMap = {};
	-- common npcfunc by Type
	local handles = {}
	handles[NpcFuncType.Common_Shop] = FunctionNpcFunc.TypeFunc_Shop
	handles[NpcFuncType.Common_NotifyServer] = FunctionNpcFunc.TypeFunc_NotifyServer
	handles[NpcFuncType.Common_GuildRaid] = FunctionNpcFunc.TypeFunc_GuildRaid
	handles[NpcFuncType.Common_InvitethePersonoflove] = FunctionNpcFunc.TypeFunc_InvitethePersonoflove
	handles[NpcFuncType.Common_AboutDateLand] = FunctionNpcFunc.TypeFunc_AboutDateLand
	handles[NpcFuncType.Common_Augury] = FunctionNpcFunc.TypeFunc_Augury
	handles[NpcFuncType.Common_AboutAugury] = FunctionNpcFunc.TypeFunc_AboutAugury
	handles[NpcFuncType.Common_Hyperlink] = FunctionNpcFunc.TypeFunc_Hyperlink
	self:PreprocessNpcFunctionConfig(handles) 
	-- common check npcFunc by Type
	local checkHandles = {};
	self:PreprocessNpcFuncCheckConfig(checkHandles);
	
	self.funcMap.MagicLottery = FunctionNpcFunc.LotteryMagic

	-- npc Func
	self.funcMap.Close = FunctionNpcFunc.Close;
	self.funcMap.storehouse = FunctionNpcFunc.storehouse;
	self.funcMap.Transfer = FunctionNpcFunc.Transfer;
	self.funcMap.Refine = FunctionNpcFunc.Refine;
	self.funcMap.DeCompose=FunctionNpcFunc.DeCompose;
	self.funcMap.Transmit = FunctionNpcFunc.Transmit;
	self.funcMap.EndLessTower=FunctionNpcFunc.EndLessTower;
	self.funcMap.EndLessTeam=FunctionNpcFunc.EndLessTeam;
	self.funcMap.Repair=FunctionNpcFunc.Repair;
	self.funcMap.Laboratory=FunctionNpcFunc.Laboratory;
	self.funcMap.LaboratoryTeam=FunctionNpcFunc.LaboratoryTeam;
	self.funcMap.LaboratoryShop=FunctionNpcFunc.LaboratoryShop;
	self.funcMap.Sell=FunctionNpcFunc.Sell;
	self.funcMap.Teleporter=FunctionNpcFunc.Teleporter;
	self.funcMap.QueryDefeatBossTime=FunctionNpcFunc.QueryDefeatBossTime;
	self.funcMap.DefeatBoss=FunctionNpcFunc.DefeatBoss;
	self.funcMap.PicMake = FunctionNpcFunc.PicMake;
	self.funcMap.strengthen = FunctionNpcFunc.strengthen;
	self.funcMap.CreateGuild = FunctionNpcFunc.CreateGuild;
	self.funcMap.ApplyGuild = FunctionNpcFunc.ApplyGuild;
	self.funcMap.GuildManor = FunctionNpcFunc.GuildManor;
	self.funcMap.UpgradeGuild = FunctionNpcFunc.UpgradeGuild;
	self.funcMap.DisMissGuild = FunctionNpcFunc.DisMissGuild;
	self.funcMap.OpenGuildRaid = FunctionNpcFunc.OpenGuildRaid;
	self.funcMap.ReadyToGuildRaid = FunctionNpcFunc.ReadyToGuildRaid;
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
	self.funcMap.ChangeHairStyle=FunctionNpcFunc.ChangeHairStyle
	self.funcMap.ChangeEyeLenses=FunctionNpcFunc.ChangeEyeLenses
	self.funcMap.ChangeClothColor = FunctionNpcFunc.ChangeClothColor
	self.funcMap.GuildPary=FunctionNpcFunc.GuildPray
	if not GameConfig.SystemForbid.GvGPvP_Pray then
		self.funcMap.GvGPvPPray=FunctionNpcFunc.GvGPvpPray
	end 
	self.funcMap.DyeCloth=FunctionNpcFunc.DyeCloth
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

	self.funcMap.OpenGuildFunction = FunctionNpcFunc.OpenGuildFunction;
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

	-- 卡牌副本
	self.funcMap.EnterPveCard = FunctionNpcFunc.EnterPveCard;
	self.funcMap.ShowPveCard = FunctionNpcFunc.ShowPveCard;
	self.funcMap.OpenKFCShareView = FunctionNpcFunc.OpenKFCShareView;
	self.funcMap.SelectPveCard = FunctionNpcFunc.SelectPveCard;
	-- 卡牌副本

	self.funcMap.GVGPortal = FunctionNpcFunc.OpenGVGPortal;
	self.funcMap.EnterAltmanRaid = FunctionNpcFunc.EnterAltmanRaid;
	self.funcMap.GetAltmanRankInfo = FunctionNpcFunc.GetAltmanRankInfo;

	--波利大乱斗
	self.funcMap.EnterPoringFight = FunctionNpcFunc.EnterPoringFight;

	-- npcCheck Func
	self.checkMap.QuickTeam = FunctionNpcFunc.CheckQuickTeam
	self.checkMap.ExitGuild = FunctionNpcFunc.CheckExitGuild
	self.checkMap.OpenGuildRaid = FunctionNpcFunc.CheckOpenGuildRaid
	self.checkMap.ReadyToGuildRaid = FunctionNpcFunc.CheckOpenGuildRaid
	self.checkMap.LaboratoryTeam = FunctionNpcFunc.CheckLaboratoryTeam
	self.checkMap.DojoTeam = FunctionNpcFunc.CheckDojoTeam;
	self.checkMap.EndLessTeam = FunctionNpcFunc.CheckEndLessTeam;

	self.checkMap.GetOldConsume = FunctionNpcFunc.InActiveNpcFunc;
	self.checkMap.GetAutumnEquip = FunctionNpcFunc.InActiveNpcFunc
	self.checkMap.GetIceCream = FunctionNpcFunc.InActiveNpcFunc
	self.checkMap.MillionHitThanks = FunctionNpcFunc.InActiveNpcFunc
	self.checkMap.AppointmentThanks = FunctionNpcFunc.InActiveNpcFunc
	self.checkMap.ChinaNewYear = FunctionNpcFunc.InActiveNpcFunc
	-- self.checkMap.Safetyrewards = FunctionNpcFunc.InActiveNpcFunc
	self.checkMap.MonthCard = FunctionNpcFunc.InActiveNpcFunc
	self.checkMap.GiveUpGuildLand = FunctionNpcFunc.CheckGiveUpGuildLand
	self.checkMap.BuildingSubmitMaterial = FunctionNpcFunc.CheckOpenBuildingSubmitMat;
	self.checkMap.CatLitterBox = FunctionNpcFunc.CheckCatLitterBox
	self.checkMap.GuildStoreCat = FunctionNpcFunc.CheckGuildStoreAuto
	self.checkMap.GuildStoreAuto = FunctionNpcFunc.CheckStoreAuto
	self.checkMap.SewingRefine = FunctionNpcFunc.CheckSewing
	self.checkMap.SewingStrengthen =FunctionNpcFunc.CheckSewing
	self.checkMap.OpenGuildFunction = FunctionNpcFunc.CheckOpenGuildFunction;
	self.checkMap.OpenGuildChallengeTaskView = FunctionNpcFunc.CheckOpenGuildChallengeTaskView;
	self.checkMap.HighRefine = FunctionNpcFunc.CheckHighRefine;
	self.checkMap.EndLessTower = FunctionNpcFunc.CheckEndLessTower;
	self.checkMap.ArtifactMake = FunctionNpcFunc.CheckArtifactMake;
	
	self.checkMap.WeddingDay = FunctionNpcFunc.CheckWeddingDay;
	self.checkMap.BookingWedding = FunctionNpcFunc.CheckBookingWedding;
	self.checkMap.CancelWedding = FunctionNpcFunc.CheckCancelWedding;
	self.checkMap.WeddingCememony = FunctionNpcFunc.CheckWeddingCememony
	self.checkMap.ConsentDivorce = FunctionNpcFunc.CheckConsentDivorce
	self.checkMap.UnilateralDivorce = FunctionNpcFunc.CheckUnilateralDivorce
	self.checkMap.GuildHoldTreasure = FunctionNpcFunc.CheckGuildHoldTreasure;
	self.checkMap.EnterRollerCoaster = FunctionNpcFunc.CheckEnterRollerCoaster
	self.checkMap.EnterWeddingMap = FunctionNpcFunc.CheckEnterWeddingMap
	self.checkMap.TakeMarryCarriage = FunctionNpcFunc.CheckTakeMarryCarriage
	self.checkMap.EnterPveCard = FunctionNpcFunc.CheckEnterPveCard;
	self.checkMap.PveCard_StartFight = FunctionNpcFunc.CheckEnterPveCard;
	self.checkMap.ChangeClothColor = FunctionNpcFunc.CheckChangeClothColor;
	self.checkMap.EnterCapraActivity = FunctionNpcFunc.CheckEnterCapraActivity;

	-- npc Update Check
	self.updateCheckMap.TestCheck = FunctionNpcFunc.CheckTestCheck;
	-- self.updateCheckMap.AuctionShop = FunctionNpcFunc.UpdateCheckAuction;

	self.updateCheckCache = {};
end


-- {key1=handler1,key2=handler2...}
-- key="[Npcfunction表里的type]",handler = 回调方法
function FunctionNpcFunc:PreprocessNpcFunctionConfig(handles)
	local configs = Table_NpcFunction
	local handle
	for k,config in pairs(configs) do
		handle = handles[config.Type]
		if(handle~=nil) then
			self.funcMap[config.NameEn] = handle
		end
	end
end

function FunctionNpcFunc:PreprocessNpcFuncCheckConfig(handles)
	local handle
	for k,config in pairs(Table_NpcFunction) do
		handle = handles[config.Type]
		if(handle~=nil) then
			self.checkMap[config.NameEn] = handle
		end
	end
end

function FunctionNpcFunc:DoNpcFunc( npcFunctionData, lnpc, param )
	if(npcFunctionData == nil)then
		return;
	end

	local event = self:getFunc(npcFunctionData.id);
	if(not event)then
		return;
	end

	-- if not transfer npc, then get now VisitingNPC
	if(not lnpc)then
		lnpc = FunctionVisitNpc.Me():GetTarget();
	end

	-- 实名制认证
	if(npcFunctionData.id == 5001 or npcFunctionData.id == 5000)then
		FunctionSecurity.Me():TryDoRealNameCentify( function ()
			event(lnpc, param, npcFunctionData);
		end);
		return;
	end

	return event(lnpc, param, npcFunctionData);
end

function FunctionNpcFunc:GetConfigByKey(key)
	for _,config in pairs(Table_NpcFunction)do
		if(key == config.NameEn)then
			return config;
		end
	end
end

function FunctionNpcFunc:getFunc(id)
	local config = Table_NpcFunction[id];
	return config and self.funcMap[config.NameEn];
end

function FunctionNpcFunc:CheckFuncState(key, npcdata, param)
	if(not key)then
		return;
	end

	local updateCheckState = self:AddUpdateCheckFunc(key, npcdata.data.id, param);
	if(updateCheckState~=nil)then
		return updateCheckState;
	end

	if(self.checkMap[key])then
		return self.checkMap[key](npcdata, param)
	end

	return NpcFuncState.Active;
end



--- update Check begin
function FunctionNpcFunc:AddUpdateCheckFunc(key, npcguid, param)
	local func = self.updateCheckMap[key];
	if(func == nil)then
		return;
	end

	local state, name = func(npcguid, param);
	self.updateCheckCache[key] = { 
		key = key, 
		state = state, 
		name = name,
		npcguid = npcguid, 
		param = param 
	};

	if(self.updateCheck_Tick == nil)then
		self.updateCheck_Tick = TimeTickManager.Me():CreateTick(0, 1000, self._updateCheckFunc,self, 1)
	end
	return state, name;
end

local stateChangeFuncs = {};
function FunctionNpcFunc:_updateCheckFunc()
	TableUtility.ArrayClear(stateChangeFuncs);

	for key,cache in pairs(self.updateCheckCache)do
		local newV, newName = self.updateCheckMap[key](cache.npcguid, cache.param)
		if(newV ~= cache.state)then
			cache.state, cache.name = newV, newName;
			table.insert(stateChangeFuncs, cache);
		end
	end
	if(#stateChangeFuncs > 0)then
		GameFacade.Instance:sendNotification(DialogEvent.NpcFuncStateChange, stateChangeFuncs);
	end
end

function FunctionNpcFunc:RemoveUpdateCheckTick()
	if(self.updateCheck_Tick)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.updateCheck_Tick = nil;
	end
end

function FunctionNpcFunc:RemoveUpdateCheck(key)
	self.updateCheckCache[key] = nil;

	if(next(self.updateCheckCache) == nil)then
		self:RemoveUpdateCheckTick();
	end
end

function FunctionNpcFunc:ClearUpdateCheck()
	TableUtility.TableClear(self.updateCheckCache);

	self:RemoveUpdateCheckTick();
end
--- update Check end




-- Function Type PreFunc Implemented Begin
function FunctionNpcFunc.TypeFunc_Shop(nnpc, params, npcFunctionData)
	if npcFunctionData.id == 650 then
		UIModelZenyShop.ItemShopID = params
		FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShopItem)
	else
		HappyShopProxy.Instance:InitShop(nnpc , params , npcFunctionData.id)
		FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {npcdata = nnpc});
	end
end

function FunctionNpcFunc.TypeFunc_NotifyServer(nnpc, param, npcFunctionData)
	ServiceUserEventProxy.Instance:CallTrigNpcFuncUserEvent(nnpc.data.id, npcFunctionData.id);
end

function FunctionNpcFunc.TypeFunc_GuildRaid(nnpc, param, npcFunctionData)
	if(npcFunctionData.NameEn == "Unlock")then
		local chooselevel = npcFunctionData.Parama[1];

		local npcid = nnpc.data.staticData.id;
		local unlockConfig = GameConfig.GuildRaid[npcid];
		local costTip = "";
		for i=1,#unlockConfig.UnlockItem do
			local cfg = unlockConfig.UnlockItem[i];
			if(cfg and cfg[1] and cfg[2])then
				local itemCfg = Table_Item[cfg[1]];
				if(itemCfg)then
					costTip = costTip .. itemCfg.NameZh .. cfg[2];
				end
			end
		end

		local unlockText = string.format(ZhString.FunctionNpcFunc_UnlockTip, chooselevel, costTip);
		local viewdata = {
			viewname = "DialogView",
			dialoglist = {unlockText},
			npcinfo = nnpc,
		};
		viewdata.addfunc = {};
		viewdata.addfunc[1] = {
			event = function ()
				ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_UNLOCK, chooselevel);
			end,
			closeDialog = true,
			NameZh = ZhString.FunctionNpcFunc_Unlock,
		};
		viewdata.addfunc[2] = {
			event = function ()
				return true;
			end,
			NameZh = ZhString.FunctionNpcFunc_Cancel,
		};
		FunctionNpcFunc.ShowUI(viewdata)

	elseif(npcFunctionData.NameEn == "Open")then
		ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_OPEN);
	elseif(npcFunctionData.NameEn == "Enter")then
		local gateInfo = GuildProxy.Instance:GetGuildGateInfoByNpcId(nnpc.data.id);
		if(gateInfo and gateInfo.state == Guild_GateState.Open)then
			ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(nnpc.data.id, FuBenCmd_pb.EGUILDGATEOPT_ENTER);
		else
			MsgManager.ShowMsgByIDTable(7202);
		end
	end
end

function FunctionNpcFunc.TypeFunc_InvitethePersonoflove(nnpc, param, npcFunctionData)
	local parama = npcFunctionData.Parama
	local data = Table_DateLand[parama.id]
	local item = BagProxy.Instance:GetItemByStaticID(data.ticket_item)
	if item == nil then
		MsgManager.ShowMsgByID(874, data.Name)
		return
	end

	local viewdata = {
		viewname = "DialogView",
		dialoglist = {parama.dialog},
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
	if isHandFollow == false then
		if Game.Myself:Client_GetHandInHandFollower() == 0 then
			MsgManager.ShowMsgByID(927)
			return
		end
	end

	local parama = npcFunctionData.Parama
	ServiceSceneAuguryProxy.Instance:CallAuguryInvite(nil , nil , nnpc.data.id, parama.type)

	local dialog = DialogUtil.GetDialogData(GameConfig.Augury.WaitWord)

	local viewdata = {
		viewname = "DialogView",
		dialoglist = {dialog.Text},
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
	local funcParam = npcFunctionData.Parama;
	if(funcParam.url)then
		-- Application.OpenURL(funcParam.url);
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.WebviewPanel, viewdata = {url = funcParam.url}})
	end
end

function FunctionNpcFunc.Astrolabe(nnpc, param, npcFunctionData)
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, PanelConfig.AstrolabeView);
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
-- Function Type PreFunc Implemented End





-- FunctionNpcFunc Implemented begin
function FunctionNpcFunc.Close()
	return false;
end

function FunctionNpcFunc.DefeatBoss( nnpc, params )
	-- body
	local hasAccepted = QuestProxy.Instance:hasQuestAccepted(params)
	if(hasAccepted)then
		MsgManager.ShowMsgByID(704)
	else
		ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT,params)
	end
end

function FunctionNpcFunc.QueryDefeatBossTime( nnpc, params )
	-- body
	--TODO
	local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
	local count = 0
	local curCount = 0
	if(dailyData)then
		count = dailyData.param1
		curCount = dailyData.param2
	end
	local unCount = count - curCount
	local str = string.format(ZhString.NpcFun_DefeatBossCount,curCount,unCount)
	local dialoglist = {str}
	local viewdata = {
		viewname = "DialogView",
		dialoglist = dialoglist,
		npcinfo = nnpc
	}
	FunctionNpcFunc.ShowUI(viewdata);
	return true
end

function FunctionNpcFunc.storehouse(nnpc, params)
	if MyselfProxy.Instance:GetROB() < GameConfig.System.warehouseZeny and BagProxy.Instance:GetItemNumByStaticID(GameConfig.Item.store_item) < 1 then
		MsgManager.ShowMsgByIDTable(1)
		return
	end
	FunctionNpcFunc.JumpPanel(PanelConfig.RepositoryView, {npcdata = nnpc});
end

function FunctionNpcFunc.Transfer(nnpc, params)
	FunctionNpcFunc.JumpPanel(PanelConfig.CharactorProfession, {npcdata = nnpc});
end

function FunctionNpcFunc.Refine(nnpc, params)
	local isfashion = params and params.isfashion;
	FunctionNpcFunc.JumpPanel(PanelConfig.NpcRefinePanel, {npcdata = nnpc, isfashion = isfashion});
end

function FunctionNpcFunc.Transmit(nnpc, params)
	printRed("竞技场传送~");
end

function FunctionNpcFunc.EndLessTower(nnpc, params)
	if MyselfProxy.Instance:RoleLevel() >= GameConfig.EndlessTower.limit_user_lv then
		if(TeamProxy.Instance:IHaveTeam())then
			local myTeam = TeamProxy.Instance.myTeam
			print("CallTeamTowerInfoCmd,team id is "..myTeam.id)
			ServiceInfiniteTowerProxy.Instance:CallTeamTowerInfoCmd(myTeam.id)
		else
			print("CallTowerInfoCmd")
			ServiceInfiniteTowerProxy.Instance:CallTowerInfoCmd()
		end
	else
		MsgManager.ShowMsgByID(1315)
	end
end

function FunctionNpcFunc.EndLessTeam(nnpc, params)
	if(TeamProxy.Instance:IHaveTeam())then
		FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc});
	else
		if(FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id))then
			local target = params;
			if(not target)then
				local config = FunctionNpcFunc.Me():GetConfigByKey("EndLessTeam");
				if(config.Parama.teamGoal)then
					target = config.Parama.teamGoal
				end
			end
			FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = target});
		end
	end
end

function FunctionNpcFunc.Repair(nnpc,params)
	
end

function FunctionNpcFunc.DeCompose(nnpc,params)
	FunctionNpcFunc.JumpPanel(PanelConfig.DeComposeView, {npcdata = nnpc, params = params});
end

function FunctionNpcFunc.Laboratory(nnpc,params)
	if(TeamProxy.Instance:IHaveTeam())then
		local funcid;
		for _,funcCfg in pairs(Table_NpcFunction)do
			if(funcCfg.NameEn == "Laboratory")then
				funcid = funcCfg.id;
				break;
			end
		end
		ServiceNUserProxy.Instance:CallGotoLaboratoryUserCmd(funcid)
	else
		MsgManager.FloatMsgTableParam(nil,ZhString.InstituteChallenge_notTeam)
	end
end

function FunctionNpcFunc.LaboratoryTeam(nnpc,params)
	if(TeamProxy.Instance:IHaveTeam())then
		FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc});
	else
		if(FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.TeamMemberListPopUp.id))then
			local target = params;
			if(not target)then
				local config = FunctionNpcFunc.Me():GetConfigByKey("LaboratoryTeam");
				if(config.Parama.teamGoal)then
					target = config.Parama.teamGoal
				end
			end
			FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = target});
		end
	end
end

function  FunctionNpcFunc.LaboratoryShop(nnpc,params)
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

function  FunctionNpcFunc.Sell(nnpc,params)
	if params == nil then
		params = 1
	end
	ShopSaleProxy.Instance:SetParams(params)
	FunctionNpcFunc.JumpPanel(PanelConfig.ShopSale, {npcdata = nnpc, params = params});
end

function FunctionNpcFunc.Teleporter(nnpc,params)
	if TeamProxy.Instance:IHaveTeam() then
		local viewdata = {
			viewname = 'DialogView',
			dialoglist = {ZhString.KaplaTransmit_SelectTransmitType},
			npcinfo = nnpc,
			addfunc = {
				[1] = {
					event = function ()
						UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Single
						UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Single
						FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params});
					end,
					closeDialog = true,
					NameZh = ZhString.Transmit,
				},
			}
		}
		viewdata.addfunc[2] = {
			event = function ()
				if TeamProxy.Instance:IHaveTeam() then
					UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Team
					UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Team
					FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params});
				else
					MsgManager.ShowMsgByID(352)
				end
			end,
			closeDialog = true,
			NameZh = ZhString.TeammateTransmit,
		}
		FunctionNpcFunc.ShowUI(viewdata)
		return true
	else
		UIMapMapList.transmitType = UIMapMapList.E_TransmitType.Single
		UIMapAreaList.transmitType = UIMapAreaList.E_TransmitType.Single
		FunctionNpcFunc.JumpPanel(PanelConfig.UIMapAreaList, {npcdata = nnpc, params = params});
	end
	return nil
end

function FunctionNpcFunc.PicMake(nnpc, params)

	local bagProxy = BagProxy.Instance;
	local bagTypes = bagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce);

	local picType = 50;
	local picDatas = {};
	for i=1,#bagTypes do
		local bagdatas = bagProxy:GetBagItemsByType(picType, bagTypes[i])
		for _,item in pairs(bagdatas)do
			-- 判断是否为图纸
			local sdata = item.staticData;
			if(item:IsPic())then
				if(sdata.ComposeID and Table_Compose[sdata.ComposeID])then
					table.insert(picDatas, item);
				end
			end
		end
	end
	
	if(#picDatas>0)then
		FunctionNpcFunc.JumpPanel(PanelConfig.PicMakeView, {npcdata = nnpc, params = params, datas = picDatas, isNpcFuncView = true});
	else
		MsgManager.ShowMsgByIDTable(703);
	end
end

function FunctionNpcFunc.strengthen(nnpc, params)
	FunctionNpcFunc.JumpPanel(PanelConfig.EquipStrengthen, {npcdata = nnpc, params = params});
end

function FunctionNpcFunc.CreateGuild( nnpc, params )
	FunctionNpcFunc.JumpPanel(PanelConfig.CreateGuildPopUp, {npcdata = nnpc, params = params});
end

function FunctionNpcFunc.ApplyGuild( nnpc, params )
	FunctionNpcFunc.JumpPanel(PanelConfig.GuildFindPopUp, {npcdata = nnpc, params = params});
end

function FunctionNpcFunc.GuildManor( nnpc, params )
	if(GuildProxy.Instance:IHaveGuild())then
		ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd();
	else
		MsgManager.ShowMsgByIDTable(2620);
	end
end

function FunctionNpcFunc.UpgradeGuild( nnpc, params )
	local guildData = GuildProxy.Instance.myGuildData;
	if(not guildData)then
		return;
	end
	local upConfig = guildData:GetUpgradeConfig()
	if(not upConfig)then
		return;
	end
	local guildLevel = GuildProxy.Instance.myGuildData.level;
	if(guildLevel>=GuildProxy.Instance:GetGuildMaxLevel())then
		MsgManager.ShowMsgByIDTable(2637);
		return;
	end
	FunctionGuild.Me():QueryGuildItemList();

	local upItemId, upItemNum = upConfig.DeductItem[1], upConfig.DeductItem[2];
	local upItemName = upItemId and Table_Item[upItemId] and Table_Item[upItemId].NameZh;
	local tipText = string.format(ZhString.FunctionNpcFunc_GuildUpgradeConfirm, 
		tostring(upConfig.ReviewFund), tostring(upItemNum), tostring(upItemName));
	local dialog = {Text = tipText};

	local guildUpEvent = function (npcinfo)
		FunctionGuild.Me():MakeGuildUpgrade();
	end
	local guildUpFunc = {
		event = guildUpEvent,
		closeDialog = true,
		NameZh = ZhString.FunctionNpcFunc_GuildUpgrade,
	};
	local viewdata = {
		viewname = "DialogView",
		dialoglist = {dialog},
		addconfig = guildFunc,
		npcinfo = nnpc,
		addfunc = {guildUpFunc},
		addleft = true,
	};
	FunctionNpcFunc.ShowUI(viewdata);
	return true;
end

function FunctionNpcFunc.DisMissGuild( nnpc, params )
	local guildData = GuildProxy.Instance.myGuildData;
	local createTime = ClientTimeUtil.FormatTimeTick(ServerTime.CurServerTime()/1000, "yyyy-MM-dd")
	MsgManager.DontAgainConfirmMsgByID(2803, function ()
		-- 按照解散前一天公会中上线玩家的数量（反复上线不算）＞10，则=48+（5*上线人数）小时，小于10人则为48小时。
		-- 例外：当公会只有会长一人时，三次确认后直接可以解散
		local memberlist = guildData:GetMemberList();
		local baseDismissTime = GameConfig.Guild.dismisstime/3600;
		local lastDayOnlineMemeberNum = 0;
		for i=1,#memberlist do
			local offlinetime = memberlist[i].offlinetime;
			if(offlinetime == 0)then
				lastDayOnlineMemeberNum = lastDayOnlineMemeberNum + 1;
			else
				local offlineSec = ServerTime.CurServerTime()/1000 - offlinetime;
				if(offlineSec <= 60*60*24)then
					lastDayOnlineMemeberNum = lastDayOnlineMemeberNum + 1;
				end
			end
		end
		local dismisstime = #memberlist <= 1 and 0 or baseDismissTime + math.floor(lastDayOnlineMemeberNum/10);
		MsgManager.DontAgainConfirmMsgByID(2804,function ()
			if(#memberlist == 1)then
				ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd()
			else
				ServiceGuildCmdProxy.Instance:CallDismissGuildCmd(true) 
			end
		end, nil,nil, guildData.name, tostring(dismisstime))
	end, nil, nil, guildData.name, createTime);
end

function FunctionNpcFunc.CancelDissolution(nnpc, params)
	ServiceGuildCmdProxy.Instance:CallDismissGuildCmd(false) 
end

function FunctionNpcFunc.ExitGuild(npc,param)
	local myGuildData = GuildProxy.Instance.myGuildData;
	local myMemberData = GuildProxy.Instance:GetMyGuildMemberData();
	local contribute = myMemberData.contribution;
	MsgManager.DontAgainConfirmMsgByID(2802, function ()
		ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd();
	end, nil, nil, myGuildData.name, contribute * 0.5);
end

function FunctionNpcFunc.OpenGuildRaid(npc, param)
	helplog("do Open Guild Raid");
end

function FunctionNpcFunc.ReadyToGuildRaid( npc, param )
	helplog("Ready To Guild Raid");
end

function FunctionNpcFunc.AdventureSkill(nnpc, params)
	FuncAdventureSkill.Instance():SetNPCCreature(nnpc)
	FuncAdventureSkill.Instance():OpenUI(1)
end

function FunctionNpcFunc.Dojo(nnpc, params)
	ServiceDojoProxy.Instance:CallDojoQueryStateCmd()
end

function FunctionNpcFunc.QuickTeam(nnpc, param)
	local teamGoal = param or 10000;
	if(not TeamProxy.Instance:IHaveTeam())then
		FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {goalid = teamGoal} );
	end
end

function FunctionNpcFunc.DojoTeam(nnpc, params)
	if(not TeamProxy.Instance:IHaveTeam())then
		FunctionNpcFunc.JumpPanel(PanelConfig.TeamFindPopUp, {npcdata = nnpc, goalid = TeamGoalType.Dojo});
	else
		FunctionNpcFunc.JumpPanel(PanelConfig.TeamMemberListPopUp, {npcdata = nnpc });
	end
end

function FunctionNpcFunc.PrimaryEnchant(nnpc, params)
	FunctionNpcFunc.JumpPanel(PanelConfig.EnchantView, {enchantType = EnchantType.Primary, npcdata = nnpc});
end

function FunctionNpcFunc.MediumEnchant(nnpc, params)
	FunctionNpcFunc.JumpPanel(PanelConfig.EnchantView, {enchantType = EnchantType.Medium, npcdata = nnpc});
end

function FunctionNpcFunc.SeniorEnchant(nnpc, params)
	FunctionNpcFunc.JumpPanel(PanelConfig.EnchantView, {enchantType = EnchantType.Senior, npcdata = nnpc});
end

function FunctionNpcFunc.seal(nnpc, params)
	if(not TeamProxy.Instance:IHaveTeam())then
		MsgManager.ShowMsgByIDTable(1607);
	else
		FunctionNpcFunc.JumpPanel(PanelConfig.SealTaskPopUp, {enchantType = EnchantType.Senior, npcdata = nnpc});
	end
end

function FunctionNpcFunc.GuildDonate(nnpc, params)
	local guildData = GuildProxy.Instance.myGuildData;
	if(guildData)then
		local myGuildMembData = GuildProxy.Instance:GetMyGuildMemberData();
		if(myGuildMembData)then
			local entertime = myGuildMembData.entertime;
			local donatelimit = GameConfig.Guild.donate_limittime or 24;
			donatelimit = donatelimit * 3600;
			if(ServerTime.CurServerTime()/1000 - entertime >= donatelimit)then
				FunctionNpcFunc.JumpPanel(PanelConfig.GuildDonateView, {npcdata = nnpc});
			else
				MsgManager.ShowMsgByIDTable(2647);
			end
		end
	else
		MsgManager.ShowMsgByIDTable(2620);
	end
end

local npcFunction,shopType
local function GetShopType(npc,param)
	npcFunction=npc and npc.data and npc.data.staticData and npc.data.staticData.NpcFunction
	if(npcFunction) then
		for _,v in pairs(npcFunction) do
			if v.param and v.param == param then
				return v.type
			end
		end
	end
	return nil
end

function FunctionNpcFunc.ChangeHairStyle(nnpc,params)
	shopType = GetShopType(nnpc,params)
	if(shopType)then
		ShopDressingProxy.Instance:InitProxy(params,shopType);
		FunctionNpcFunc.JumpPanel(PanelConfig.HairDressingView);
	end
end

function FunctionNpcFunc.ChangeEyeLenses(nnpc,params)
	shopType = GetShopType(nnpc,params)
	if(shopType)then
		ShopDressingProxy.Instance:InitProxy(params,shopType);
		FunctionNpcFunc.JumpPanel(PanelConfig.EyeLensesView);
	end
end

function FunctionNpcFunc.ChangeClothColor(nnpc,params)
	shopType = GetShopType(nnpc,params)
	if(shopType)then
		ShopDressingProxy.Instance:InitProxy(params,shopType);
		FunctionNpcFunc.JumpPanel(PanelConfig.ClothDressingView);
	end
end

-- 女神祈祷
function FunctionNpcFunc.GuildPray(nnpc,params)
	FunctionNpcFunc.JumpPanel(PanelConfig.GuildPrayDialog,{npcdata=nnpc});
end

-- 公会祈祷2.0
function FunctionNpcFunc.GvGPvpPray(nnpc,params)
	FunctionNpcFunc.JumpPanel(PanelConfig.GvGPvPPrayDialog,{npcdata=nnpc});
end


function FunctionNpcFunc.DyeCloth(nnpc,params)
	MsgManager.FloatMsgTableParam(nil,ZhString.ItemTip_LockCardSlot);
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

	local count = GuildProxy.Instance:GetGuildPackItemNumByItemid( GameConfig.Zone.guild_zone_exchange.cost[1][1] )

	local dialogStr = DialogUtil.GetDialogData(8230).Text
	local str = string.format(dialogStr,count)
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

function FunctionNpcFunc.GetCdkey(nnpc , params)
	FunctionNpcFunc.JumpPanel(PanelConfig.GiftActivePanel)
end

function FunctionNpcFunc.ReleaseActivity(npc, param)
	local viewdata = {
		viewname = "TempActivityView",
		viewdata = {Config = {Params = GameConfig.Activity.ReleaseActivity}},
	};
	FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.FindGM(npc, param )
	local viewdata = {
		viewname = "DialogView",
		dialoglist = { GameConfig.Activity.GMInfo.Text },
		npcinfo = npc,
	};
	FunctionNpcFunc.ShowUI(viewdata)

	return true
end

function FunctionNpcFunc.QuestionSurvey(npc, param)
	local viewdata = {
		viewname = "TempActivityView",
		viewdata = {Config = {Params = GameConfig.Activity.QuestionSurvey}},
	};
	FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.AutumnAdventure(npc, param)
	local viewdata = {
		viewname = "TempActivityView",
		viewdata = {Config = {Params = GameConfig.Activity.AutumnAdventure}},
	};
	FunctionNpcFunc.ShowUI(viewdata)

	-- ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Autumn);
end

function FunctionNpcFunc.GetIceCream(npc, param)
	-- ServiceNUserProxy.Instance:CallOperateQueryUserCmd(npc.data.id);
	ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Summer);
	return true;
end

function FunctionNpcFunc.GetAutumnEquip(npc, param)
	ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Autumn);
	return true;
end

function FunctionNpcFunc.MillionHitThanks(npc, param)
	ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_CodeBW);
	return true;
end

function FunctionNpcFunc.AppointmentThanks(npc, param )
	ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_CodeMX);
	return true;
end

function FunctionNpcFunc.ChinaNewYear(npc, param)
	ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_RedBag);
	return true;
end

function FunctionNpcFunc.Safetyrewards(npc, param)
	ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Phone);
	return true;
end

function FunctionNpcFunc.MonthCard(npc, subKey)
	if(subKey)then
		ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_MonthCard, nil, subKey);
		return true;
	end
	
end

function FunctionNpcFunc.QuestActAnswer(npc, param)
	if(npc)then
		FunctionXO.Me():QueryQuestion( npc.data.id )
	end
	return true
end

function FunctionNpcFunc.GetOldConsume(npc, param)
	helplog("param", param[1], param[2], param[3]);
	local viewdata = {
		viewname = "DialogView",
		npcinfo = npc,
	};

	local oldConsumeTip = string.format(ZhString.FunctionNpcFunc_GetOldConsumeTip, param[1], param[3] or 0);
	viewdata.dialoglist = { oldConsumeTip };


	-- add func
	local getEvent = function ()
		ServiceSessionSocialityProxy.Instance:CallOperateTakeSocialCmd(SessionSociality_pb.EOperateType_Charge);
	end
	local laterGetEvent = function ()
		local lgviewdata = { viewname = "DialogView" };
		local timeDateInfo = os.date("*t", param[2]);
		local text = string.format(ZhString.FunctionNpcFunc_LaterGetOldConsumeTip, timeDateInfo.month, timeDateInfo.day, timeDateInfo.hour);
		lgviewdata.dialoglist = { text };
		lgviewdata.npcinfo = npc;
		FunctionNpcFunc.ShowUI(lgviewdata);
	end
	viewdata.addfunc = {};
	viewdata.addfunc[1] = {
		event = getEvent,
		closeDialog = true,
		NameZh = ZhString.FunctionNpcFunc_GetOldConsumeButton,
	};
	viewdata.addfunc[2] = {
		event = laterGetEvent,
		NameZh = ZhString.FunctionNpcFunc_LaterGetOldConsumeButton,
	};

	FunctionNpcFunc.ShowUI(viewdata);
	return true
end

function FunctionNpcFunc.Opengift(npc, parama)
	if(npc.data.type==SceneMap_pb.EGiveType_Trade)then
		ServiceRecordTradeProxy.Instance:CallReqGiveItemInfoCmd( npc.data.giveid )
	else 
		-- 扭蛋
		ServiceSessionMailProxy.Instance:CallGetMailAttach(npc.data.giveid)
	end
end

function FunctionNpcFunc.HireCatInfo(npc, param)
	FunctionNpcFunc.JumpPanel(PanelConfig.HireCatInfoView, {catid = param});
end

function FunctionNpcFunc.HelpGuildChallenge(npc, param)
	FunctionNpcFunc.JumpPanel(PanelConfig.CreateGuildPopUp, {npcdata = nnpc});
	return true;
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
	helplog("TestCheck");
end

function FunctionNpcFunc.ChangeGuildName(npc, param)
	-- local canChangeName = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.ChangeName);
	-- if(not canChangeName)then
	-- 	MsgManager.ShowMsgByIDTable(2700);
	-- 	return;
	-- end

	FunctionNpcFunc.JumpPanel(PanelConfig.GuildChangeNamePopUp, {npcdata = npc})
end

function FunctionNpcFunc.GiveUpGuildLand(npc, param)
	local myGuildData = GuildProxy.Instance.myGuildData;

	local giveUpCd = myGuildData.citygiveuptime;
	local cityid = myGuildData.cityid;

	if(cityid == nil or cityid == 0)then
		if(giveUpCd == nil or giveUpCd == 0)then
			MsgManager.ShowMsgByID(2209);
			return;
		end
	end
	local viewdata = {};

	if(giveUpCd and giveUpCd > 0)then
		viewdata.iscancel = true;
		viewdata.msgId = 2200;
		viewdata.confirmHandler = function ()
			helplog("CallCityActionGuildCmd", GuildCmd_pb.ECITYACTION_CANCEL_GIVEUP);
			ServiceGuildCmdProxy.Instance:CallCityActionGuildCmd(GuildCmd_pb.ECITYACTION_CANCEL_GIVEUP) 
		end
	else
		viewdata.iscancel = false;
		viewdata.msgId = 2199;
		viewdata.confirmHandler = function ()
			helplog("CallCityActionGuildCmd", GuildCmd_pb.ECITYACTION_GIVEUP);
			ServiceGuildCmdProxy.Instance:CallCityActionGuildCmd(GuildCmd_pb.ECITYACTION_GIVEUP) 
		end
	end
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, 
		{view = PanelConfig.UniqueConfirmView_GvgLandGiveUp, viewdata = viewdata});
end

function FunctionNpcFunc.EquipAlchemy(npc, param)
	FunctionNpcFunc.JumpPanel(PanelConfig.EquipAlchemyView, {npcdata = npc, groupid = param});
end

function FunctionNpcFunc.EnterCapraActivity( npc, param )
	local actId = GameConfig.Activity.SaveCapra and GameConfig.Activity.SaveCapra.ActivityID or 6;
	local actData = FunctionActivity.Me():GetActivityData( actId )
	if(actData)then
		ServiceNUserProxy.Instance:CallEnterCapraActivityCmd() 
	else
		MsgManager.ShowMsgByIDTable(7202);
	end
end

function FunctionNpcFunc.EnterAltmanRaid( npc, param)
	if(not TeamProxy.Instance:IHaveTeam())then
		MsgManager.ShowMsgByIDTable(332);
		return;
	end

	local myTeam = TeamProxy.Instance.myTeam;

	local memberlist = myTeam:GetMembersList();

	local hasMemberInRaid = false;
	for i=1,#memberlist do
		local raid = memberlist[i].raid;
		local raidData = raid and Table_MapRaid[raid];
		if(raidData and raidData.Type == FuBenCmd_pb.ERAIDTYPE_ALTMAN)then
			hasMemberInRaid = true;
			break;
		end
	end
	if(hasMemberInRaid)then
		ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN);
		return;
	end

	if(not TeamProxy.Instance:CheckIHaveLeaderAuthority())then
		MsgManager.ShowMsgByIDTable(7303);
		return;
	end

	RaidEnterWaitView.SetListenEvent(ServiceEvent.TeamRaidCmdTeamRaidReplyCmd, function (view, note)
		local charid, agree = note.body.charid, note.body.reply;
		view:UpdateMemberEnterState(charid, agree);
		view:UpdateWaitList();
	end)

	local configid = params;
	RaidEnterWaitView.SetStartFunc(function (view)
		-- 进入奥特曼副本
		ServiceTeamRaidCmdProxy.Instance:CallTeamRaidEnterCmd(FuBenCmd_pb.ERAIDTYPE_ALTMAN);
		view:CloseSelf();
	end);
	RaidEnterWaitView.SetCancelFunc(function (view)
		view:CloseSelf();
	end);

	ServiceTeamRaidCmdProxy.Instance:CallTeamRaidInviteCmd(nil, FuBenCmd_pb.ERAIDTYPE_ALTMAN) 

	FunctionNpcFunc.JumpPanel(PanelConfig.RaidEnterWaitView);
end

function FunctionNpcFunc.GetAltmanRankInfo(nnpc,param)
	ServiceNUserProxy.Instance:CallQueryAltmanKillUserCmd()
end

function FunctionNpcFunc.GuildBuilding(nnpc,param)
	FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingView, {npcdata = nnpc});
end

function FunctionNpcFunc.BuildingSubmitMaterial(nnpc,param)
	local data = GuildBuildingProxy.Instance:GetCurBuilding()
	if(data and param==data.type)then
		GuildBuildingProxy.Instance:InitBuilding(nnpc,param)
		FunctionNpcFunc.JumpPanel(PanelConfig.GuildBuildingMatSubmitView, {npcdata = nnpc});
	end
end

function FunctionNpcFunc.ReportPoringFight( npc, param )

	if(PvpProxy.Instance:Is_polly_match())then
		MsgManager.ShowMsgByIDTable(3609);
		return;
	end

	local actData = FunctionActivity.Me():GetActivityData( GameConfig.PoliFire.PoringFight_ActivityId or 111 );
	helplog("FunctionNpcFunc ReportPoringFight", actData);
	if(actData)then
		ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.PoringFight) 
	else
		MsgManager.ShowMsgByIDTable(3605);
	end

end

function FunctionNpcFunc.ReportMvpFight( npc, param )
	-- 未开启提示
	local tipActID = GameConfig.MvpBattle.ActivityID or 4000000;
	local actData = FunctionActivity.Me():GetActivityData( tipActID );
	if(actData == nil)then
		MsgManager.ShowMsgByIDTable(7300);
		return;
	end
	-- 进入等级判定
	local baselv = GameConfig.MvpBattle.BaseLevel;
	local rolelv = MyselfProxy.Instance:RoleLevel();
	if(rolelv < baselv)then
		MsgManager.ShowMsgByID(7301, baselv);
		return;
	end

	local teamProxy = TeamProxy.Instance;
	-- 队伍判定
	if(not teamProxy:IHaveTeam())then
		MsgManager.ShowMsgByID(332);
		return;
	end
	-- 队长判定
	if(not teamProxy:CheckIHaveLeaderAuthority())then
		MsgManager.ShowMsgByID(7303);
		return;
	end
	-- 队员等级判定
	local mblsts = teamProxy.myTeam:GetMembersListExceptMe();
	for i=1,#mblsts do
		if(mblsts[i].baselv < baselv)then
			MsgManager.ShowMsgByID(7305, baselv);
			return;
		end
	end
	
	local matchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.MvpFight)
	if matchStatus and matchStatus.ismatch then
		MsgManager.ShowMsgByIDTable(3609)
		return
	end
	ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.MvpFight) 
end

function FunctionNpcFunc.OpenGuildFunction( npc, param )
	ServiceGuildCmdProxy.Instance:CallOpenFunctionGuildCmd(GuildCmd_pb.EGUILDFUNCTION_BUILDING);
end

function FunctionNpcFunc.SewingStrengthen(npc, param)
	FunctionMiyinStrengthen.Ins():SetNPCCreature(npc)
	FunctionMiyinStrengthen.Ins():OpenUI()
end

function FunctionNpcFunc.OpenGuildChallengeTaskView( npc, param )
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.GuildChallengeTaskPopUp});
end

function FunctionNpcFunc.HighRefine(npc, param)
	local unlockPoses = BlackSmithProxy.Instance:GetHighRefinePoses();
	if(unlockPoses == nil or #unlockPoses == 0)then
		MsgManager.ShowMsgByIDTable(3605);
		return;
	end
	FunctionNpcFunc.JumpPanel(PanelConfig.HighRefinePanel, {npcdata = npc});
end

function FunctionNpcFunc.SewingRefine(npc, param)
	FunctionNpcFunc.JumpPanel(PanelConfig.NpcRefinePanel, {npcdata = nnpc, isfashion = true});
end


function FunctionNpcFunc.ArtifactMake(npc,param)
	ArtifactProxy.Instance:InitParam(param)
	FunctionNpcFunc.JumpPanel(PanelConfig.ArtifactMakeView, {npcdata = npc});
end

function FunctionNpcFunc.GuildHoldTreasure(npc,param)
	ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil,nil,nil,GuildTreasureProxy.ActionType.GVG_FRAME_ON)
end

function FunctionNpcFunc.GuildTreasure(npc,param)
	ServiceGuildCmdProxy.Instance:CallTreasureActionGuildCmd(nil,nil,nil,GuildTreasureProxy.ActionType.GUILD_FRAME_ON)
end

function FunctionNpcFunc.GuildTreasurePreview(npc,param)
	GuildTreasureProxy.Instance:SetViewType(3)
	FunctionNpcFunc.JumpPanel(PanelConfig.GuildTreasureView, {npcdata = npc})
end

function FunctionNpcFunc.ReturnArtifact(npc,param)
	local myArt = ArtifactProxy.Instance:GetMySelfArtifact()
	if(myArt and #myArt>0)then
		FunctionNpcFunc.JumpPanel(PanelConfig.ReturnArtifactView, {npcdata = npc});
	else
		MsgManager.ShowMsgByID(3787)
	end
end

function FunctionNpcFunc.ServerOpenFunction(npc, param)
	GameFacade.Instance:sendNotification(DialogEvent.ServerOpenFunction, {npcdata = nnpc, param = param});
end

function FunctionNpcFunc.YoyoSeat(npc, param)
	ServiceNUserProxy.Instance:CallYoyoSeatUserCmd(npc.data.id);
end

function FunctionNpcFunc.UpJobLevel(npc, param)
	local userdata = Game.Myself.data.userdata
	local jobLv = userdata:Get(UDEnum.JOBLEVEL)
	if jobLv < 91 then
		MsgManager.ShowMsgByID(25442)
		return
	end
	FunctionDialogEvent.SetDialogEventEnter( "UpJobLevel", npc )
	return true;
end

function FunctionNpcFunc.WeddingCememony(npc, param)
	if(not WeddingProxy.Instance:IsHandPartner())then
		MsgManager.ShowMsgByIDTable(9644);
		return;
	end
	helplog("Call-->InviteBeginWeddingCCmd");
	ServiceWeddingCCmdProxy.Instance:CallInviteBeginWeddingCCmd();
end

function FunctionNpcFunc.WeddingDay(npc, param)
	FunctionNpcFunc.JumpPanel(PanelConfig.EngageMainView, {viewEnum = WeddingProxy.EngageViewEnum.Check}) 
end

function FunctionNpcFunc.BookingWedding(npc, param)
	if not WeddingProxy.Instance:IsSelfSingle() then
		MsgManager.ShowMsgByID(9601)
		return
	end

	local _Myself = Game.Myself
	local isHandFollow = _Myself:Client_IsFollowHandInHand()
	if isHandFollow == false then
		if _Myself:Client_GetHandInHandFollower() == 0 then
			MsgManager.ShowMsgByID(9600)
			return
		end
	end

	FunctionNpcFunc.JumpPanel(PanelConfig.EngageMainView, {viewEnum = WeddingProxy.EngageViewEnum.Book})
end

function FunctionNpcFunc.CancelWedding(npc, param)
	local weddingInfo = WeddingProxy.Instance:GetWeddingInfo()
	if weddingInfo ~= nil then
		if weddingInfo.status == WeddingInfoData.Status.Reserve then
			MsgManager.ConfirmMsgByID(9611, function ()
				ServiceWeddingCCmdProxy.Instance:CallGiveUpReserveCCmd(weddingInfo.id)
			end)
		end
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
	if creature == nil or 
		VectorUtility.DistanceXZ( Game.Myself:GetPosition(), creature:GetPosition() ) > GameConfig.Wedding.Divorce_NpcDistance then
		MsgManager.ShowMsgByID(9623)
		return
	end

	local weddingInfo = _WeddingProxy:GetWeddingInfo()
	if weddingInfo ~= nil then
		local _Myself = Game.Myself
		local canDivorce = _Myself and _Myself.data.userdata:Get(UDEnum.DIVORCE_ROLLERCOASTER) or 0
		if canDivorce == 1 then
			MsgManager.ConfirmMsgByID(9613, function ()
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
		MsgManager.ConfirmMsgByID(9621, function ()
			ServiceWeddingCCmdProxy.Instance:CallReqDivorceCCmd(weddingInfo.id, WeddingCCmd_pb.EGiveUpType_Single)
		end, nil, nil, _WeddingProxy:GetPartnerName())
	end	
end

function FunctionNpcFunc.EnterRollerCoaster(npc, param)
	if(not WeddingProxy.Instance:IsHandPartner())then
		MsgManager.ShowMsgByID(927)
		return;
	end
	ServiceWeddingCCmdProxy.Instance:CallEnterRollerCoasterCCmd()
end

function FunctionNpcFunc.TakeMarryCarriage(npc, param)
	if(not WeddingProxy.Instance:IsHandPartner())then
		MsgManager.ShowMsgByID(927)
		return;
	end

	ServiceWeddingCCmdProxy.Instance:CallWeddingCarrierCCmd();
end

function FunctionNpcFunc.EnterWeddingMap(npc, param)
	local letters = {};
	local marryInviteLetters = BagProxy.Instance:GetMarryInviteLetters();
	for i=1,#marryInviteLetters do
		local weddingData = marryInviteLetters[i].weddingData;
		if(weddingData and weddingData:CheckInWeddingTime())then
			table.insert(letters, marryInviteLetters[i]);
		end
	end

	local curline = MyselfProxy.Instance:GetZoneId();
	if(#letters > 0)then
		local sameline = false;
		for i=1,#letters do
			if(letters[i].weddingData.zoneid == curline)then
				sameline = true;
			end
		end
		if(not sameline)then
			MsgManager.ShowMsgByID(9619);
			return;
		end
	else
		local weddingInfo = WeddingProxy.Instance:GetWeddingInfo();
		if(weddingInfo.zoneid % 10000 ~= curline)then
			MsgManager.ShowMsgByID(9650);
			return;
		end
	end

	ServiceWeddingCCmdProxy.Instance:CallEnterWeddingMapCCmd()
end

function FunctionNpcFunc.WeddingRingShop(nnpc, params, npcFunctionData)
	HappyShopProxy.Instance:InitShop(nnpc , params , npcFunctionData.id)
	FunctionNpcFunc.JumpPanel(PanelConfig.WeddingRingView, {npcdata = nnpc})
end


function FunctionNpcFunc.EnterPveCard(nnpc, params)
	-- local enterlv = GameConfig.CardRaid and GameConfig.CardRaid.enterlevel or 10;
	-- local rolelv = MyselfProxy.Instance:RoleLevel();
	-- if(rolelv < enterlv)then
	-- 	MsgManager.ShowMsgByID(116);
	-- 	return;
	-- end

	RaidEnterWaitView.SetListenEvent(ServiceEvent.PveCardReplyPveCardCmd, function (view, note)
		local charid,agree = note.body.charid, note.body.agree;
		helplog("EnterPveCard:", charid, agree);
		view:UpdateMemberEnterState(charid, agree);
		view:UpdateWaitList();
	end)

	local configid = params;
	RaidEnterWaitView.SetStartFunc(function (view)
		ServicePveCardProxy.Instance:CallSelectPveCardCmd(configid);
		ServicePveCardProxy.Instance:CallEnterPveCardCmd(configid) 
		view:CloseSelf();
	end);
	RaidEnterWaitView.SetCancelFunc(function (view)
		view:CloseSelf();
	end);

	ServicePveCardProxy.Instance:CallInvitePveCardCmd(configid)

	FunctionNpcFunc.JumpPanel(PanelConfig.RaidEnterWaitView);
end

function FunctionNpcFunc.ShowPveCard(nnpc, params)
	local configid = params;
	FunctionNpcFunc.JumpPanel(PanelConfig.OricalCardInfoView, {index = configid});
end

function FunctionNpcFunc.SelectPveCard(nnpc, params)
	local configid = params;
	ServicePveCardProxy.Instance:CallSelectPveCardCmd(configid);
end

function FunctionNpcFunc.PveCard_StartFight(nnpc)
	ServicePveCardProxy.Instance:CallBeginFirePveCardCmd();
end

function FunctionNpcFunc.OpenGVGPortal(npc, param)
	local viewdata = {
		viewname = "GVGPortalView",
		view = PanelConfig.GVGPortalView,
		npcinfo = nnpc,
	};
	FunctionNpcFunc.ShowUI(viewdata)
end

function FunctionNpcFunc.EnterPoringFight(npc, param)
	ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(ProtoCommon_pb.ERAIDTYPE_PVP_POLLY);
end
-- FunctionNpcFunc Implemented end




function FunctionNpcFunc.ShowUI(viewdata)
	if(viewdata)then
		local vdata = viewdata.viewdata or {};
		vdata.isNpcFuncView = true;
		GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata);
	end
end

function FunctionNpcFunc.JumpPanel(panel, viewdata)
	if(panel)then
		viewdata = viewdata or {};
		viewdata.isNpcFuncView = true;
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panel, viewdata = viewdata})	
	end
end



-- Check Begin
function FunctionNpcFunc.CheckQuickTeam(npc, param)
	if(TeamProxy.Instance:IHaveTeam())then
		return NpcFuncState.Grey;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckLaboratoryTeam(npc, param)
	if(TeamProxy.Instance:IHaveTeam())then
		return NpcFuncState.Grey;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckDojoTeam(npc, param)
	if(TeamProxy.Instance:IHaveTeam())then
		return NpcFuncState.Grey;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckEndLessTeam(npc, param)
	if(TeamProxy.Instance:IHaveTeam())then
		return NpcFuncState.Grey;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckCatLitterBox(npc,param)
	return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX)
end

function FunctionNpcFunc.CheckGuildStoreAuto(npc,param)
	return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_BAR)
end

function FunctionNpcFunc.CheckStoreAuto(npc,param)
	return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_VENDING_MACHINE)
end

function FunctionNpcFunc.CheckSewing(npc,param)
	return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
end

function FunctionNpcFunc.CheckArtifactMake(npc,param)
	if(ArtifactProxy.Type.WeaponArtifact==param)then
		return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
	elseif(ArtifactProxy.Type.HeadBackArtifact==param)then
		return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_ARTIFACT_HEAD)
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckGuildHoldTreasure(npc,param)
	local hasHoldTreasure = GuildTreasureProxy.Instance:HasGuildHoldTreasure()
	if(hasHoldTreasure)then
		if(GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure))then
			return NpcFuncState.Active
		end
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.checkBuildingActiveSelf(type)
	local data = GuildBuildingProxy.Instance:GetCurBuilding()
	if(data and data.type==type and data.level<1)then
		return NpcFuncState.InActive;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckOpenGuildRaid(npc, param)
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData)then
		local myMemberData = GuildProxy.Instance:GetMyGuildMemberData();
		local leftRaidTime = myGuildData.nextraidTime - ServerTime.CurServerTime()/1000;
		local canOpenRaid = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.OpenGuildRaid);
		if(leftRaidTime <= 0 and canOpenRaid)then
			return NpcFuncState.Active;
		end
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.InActiveNpcFunc(npc, param)
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckGiveUpGuildLand(npc, param)
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData == nil)then
		return NpcFuncState.InActive;
	end

	if(GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.GiveUpLand))then
		local cdTime = myGuildData.citygiveuptime;
		if(cdTime and cdTime > 0)then
			return NpcFuncState.Active, ZhString.FunctionNpcFunc_CancelGiveUpGuildLand;
		else
			return NpcFuncState.Active, ZhString.FunctionNpcFunc_GiveUpGuildLand;
		end
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckOpenBuildingSubmitMat(npc,param)
	if(npc and npc.data and npc.data.staticData) then
		npcFunction=npc.data.staticData.NpcFunction;
	end
	if(npcFunction) then
		if(#npcFunction>1)then
			local data = GuildBuildingProxy.Instance:GetCurBuilding()
			if(data and param==data.type and data.level>0)then
				return NpcFuncState.Active;
			end
			return NpcFuncState.InActive;
		else
			return NpcFuncState.Active;
		end
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckOpenGuildFunction( npc, param )
	if(GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.OpenGuildFunction))then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckOpenGuildChallengeTaskView( npc, param )
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData == nil)then
		return NpcFuncState.InActive;
	end
	if(not myGuildData:CheckFunctionOpen(GuildCmd_pb.EGUILDFUNCTION_BUILDING))then
		return NpcFuncState.InActive;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckHighRefine( npc, param )
	return FunctionNpcFunc.checkBuildingActiveSelf(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
end

function FunctionNpcFunc.CheckEndLessTower( npc, param )
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckWeddingDay( npc, param )
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckBookingWedding( npc, param )
	if(not WeddingProxy.Instance:IsSelfEngage())then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckCancelWedding( npc, param )
	local _WeddingProxy = WeddingProxy.Instance
	if(_WeddingProxy:IsSelfEngage() and not _WeddingProxy:IsSelfInWeddingTime())then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckWeddingCememony( npc, param )
	if(WeddingProxy.Instance:IsSelfMarried())then
		return NpcFuncState.InActive;
	end
	if(WeddingProxy.Instance:IsSelfInWeddingTime())then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckConsentDivorce( npc, param )
	if(WeddingProxy.Instance:IsSelfMarried() and 
		not WeddingProxy.Instance:IsSelfInWeddingTime())then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckUnilateralDivorce(npc, param)
	if WeddingProxy.Instance:CanSingleDivorce() then
		return NpcFuncState.Active
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterRollerCoaster( npc, param )
	if(WeddingProxy.Instance:IsSelfMarried())then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterWeddingMap( npc, param )
	if(WeddingProxy.Instance:IsSelfInWeddingTime())then
		return NpcFuncState.Active;
	end

	local marryInviteLetters = BagProxy.Instance:GetMarryInviteLetters();
	for i=1,#marryInviteLetters do
		local weddingData = marryInviteLetters[i].weddingData;
		if(weddingData and weddingData:CheckInWeddingTime())then
			return NpcFuncState.Active;
		end
	end

	return NpcFuncState.InActive;
end

function FunctionNpcFunc.CheckTakeMarryCarriage( npc, param )
	if(WeddingProxy.Instance:IsSelfInWeddingTime())then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterPveCard( npc, param )
	if(not TeamProxy.Instance:CheckIHaveLeaderAuthority())then
		return NpcFuncState.InActive;
	end
	return NpcFuncState.Active
end

function FunctionNpcFunc.CheckChangeClothColor(npc,param)
	local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
	if myClass%10 >=4 then
		return NpcFuncState.Active
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.CheckEnterCapraActivity()
	local actId = GameConfig.Activity.SaveCapra and GameConfig.Activity.SaveCapra.ActivityID or 6;
	local actData = FunctionActivity.Me():GetActivityData( actId )
	if(actData == nil)then
		return NpcFuncState.InActive;
	end
	return NpcFuncState.Active;
end

function FunctionNpcFunc.CheckExitGuild(npc,param)
	if(GuildProxy.Instance:IHaveGuild())then
		return NpcFuncState.Active
	end
	return NpcFuncState.InActive
end

function FunctionNpcFunc.OpenKFCShareView( npc, param )
	autoImport("FloatAwardView")
	if(FloatAwardView.ShareFunctionIsOpen(  ))then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.KFCActivityShowView})
	end
end
-- Check end



-- Time Check Begin
local testTime;
function FunctionNpcFunc.CheckTestCheck(npcguid, param)
	if(testTime == nil)then
		testTime = ServerTime.CurServerTime()/1000 + 20;
	end
	if(ServerTime.CurServerTime()/1000 < testTime)then
		return NpcFuncState.Active;
	end
	return NpcFuncState.InActive;
end

-- function FunctionNpcFunc.UpdateCheckAuction(npcguid, param)
	-- local currentState = AuctionProxy.Instance:GetCurrentState()
	-- if(currentState == AuctionState.Close)then
	-- 	return NpcFuncState.InActive;
	-- end
	-- return NpcFuncState.Active;
-- end
-- Time Check End


function FunctionNpcFunc.LotteryMagic(nnpc, param, npcFunctionData)
	-- FunctionNpcFunc.JumpPanel(PanelConfig.LotteryCardView, {npcdata = nnpc})
	FunctionNpcFunc.JumpPanel(PanelConfig.LotteryMagicView, {npcdata = nnpc})
end
