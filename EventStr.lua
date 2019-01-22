StartEvent = {
	StartUp = "StartEvent_StartUp",
}

AppStateEvent = {
	Quit = "AppStateEvent_Quit",
	Focus = "AppStateEvent_Focus",
	Pause = "AppStateEvent_Pause",
	BackToLogo = "AppStateEvent_BackToLogo",
}

MaskPlayerUIType = {	
	BloodType = 1,
	NameType = 2,
	NameHonorFactionType = 3,
	ChatSkillWord = 4,
	Emoji = 5,
	BloodNameHonorFactionEmojiType = 6,
	TopFrame = 7,
	QuestUI = 8,
	--????????????
	FloatRoleTop = 9,
	HurtNum = 100,	--???????????????/?????????/??????/??????/????????????/????????????/??????UI??????/??????NPC??????????????????????????????
}

UIEvent = {
	ShowUI = "UIEvent_ShowUI",
	CloseUI = "UIEvent_CloseUI",
	JumpPanel = "UIEvent_JumpPanel",
	UIStart = "UIEvent_StartUI",

	--Command send
	EnterView = "UIEvent_EnterView",
	ExitView = "UIEvent_ExitView",

	View1Test = "UIEvent_View1Test",
}

UIMenuEvent = {
	UnRegisitButton = "UIMenuEvent_UnRegisitButton",
}

PanelEvent = {
	TabChange = "PanelEvent_TabChange",
}

SecurityEvent = {
	Close = "SecurityPanel_Close",
}

SceneUIEvent = {
	VisiblePlayerUI = "SceneUIEvent_VisiblePlayerUI",
	InVisiblePlayerUI = "SceneUIEvent_InVisiblePlayerUI",
	
	MaskPlayersUI = "SceneUIEvent_MaskPlayerUI",
	UnMaskPlayersUI= "SceneUIEvent_UnMaskPlayerUI",
	
	SceneUIEnable = "SceneUIEvent_SceneUIEnable",
	SceneUIDisable = "SceneUIEvent_SceneUIDisable",

	AddMonsterNamePre = "SceneUIEvent_AddMonsterNamePre",
	RemoveMonsterNamePre = "SceneUIEvent_RemoveMonsterNamePre",

}

HandEvent = {
	StartHandInHand = "HandEvent_StartHandInHand",
	StopHandInHand = "HandEvent_StopHandInHand",
	MyStartHandInHand = "HandEvent_MyStartHandInHand",
	MyStopHandInHand = "HandEvent_MyStopHandInHand",
}

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.LoginInit = "ServiceEvent_LoginInit"
ServiceEvent.ReconnInit = "ServiceEvent_ReconnInit"

ServiceEvent.ConnSuccess = "ServiceEvent_ConnSuccess"
ServiceEvent.ConnReconnect = "ServiceEvent_ConnReconnect"
ServiceEvent.ConnNetDelay = "ServiceEvent_ConnNetDelay"
ServiceEvent.ConnNetDown = "ServiceEvent_ConnNetDown"

ServiceEvent.UserLoginSuccess = "ServiceEvent_UserLoginSuccess"
ServiceEvent.UserRecvRoleInfo = "ServiceEvent_UserRecvRoleInfo"
ServiceEvent.UserSelectSuccess = "ServiceEvent_UserSelectSuccess"

ServiceEvent.PlayerMapOtherUserIn = "ServiceEvent_PlayerMapOtherUserIn"
ServiceEvent.PlayerMapOtherUserOut = "ServiceEvent_PlayerMapOtherUserOut"
ServiceEvent.PlayerMapChange = "ServiceEvent_PlayerMapChange"
ServiceEvent.PlayerMapObjectData = "ServiceEvent_PlayerMapObjectData"
ServiceEvent.PlayerChangeDress = "ServiceEvent_PlayerChangeDress"
ServiceEvent.PlayerMoveTo = "ServiceEvent_PlayerMoveTo"
ServiceEvent.PlayerAddMapNpc = "ServiceEvent_PlayerAddMapNpc"
ServiceEvent.PlayerSAttrSyncData = "ServiceEvent_PlayerSAttrSyncData"
ServiceEvent.PlayerSkillBroadcast = "ServiceEvent_PlayerSkillBroadcast"

ServiceEvent.SceneUserActionNtf = "ServiceEvent_SceneUserActionNtf"
ServiceEvent.SceneShortcutBar = "ServiceEvent_SceneShortcutBar"
ServiceEvent.SceneGoToUserCmd = "ServiceEvent_SceneGoToUserCmd"

ServiceEvent.NpcDie = "ServiceEvent_NpcDie"
ServiceEvent.NpcRelive = "ServiceEvent_NpcRelive"
ServiceEvent.PlayerDie = "ServiceEvent_PlayerDie"
ServiceEvent.PlayerRelive = "ServiceEvent_PlayerRelive"
ServiceEvent.NpcChangeHp = "ServiceEvent_NpcChangeHp"
ServiceEvent.ChooseServer = "ServiceEvent_ChooseServer"

ServiceEvent.Error = "ServiceEvent_Error"

ServiceEvent.ChatCmdBarrageMsgChatCmd = 'ServiceEvent_ChatCmdBarrageMsgChatCmd'

CreatureEvent = {
	Player_CampChange = "Player_CampChange",
	PVP_TeamChange = "PVP_TeamChange",
	Hiding_Change = "Hiding_Change",
	Name_Change = "CreatureEvent_Name_Change",
}

PlayerEvent = {
	CapturedCamera = "PlayerEvent_CapturedCamera",
	GuildInfoChange = "PlayerEvent_GuildInfoChange",
	DeathStatusChange = "PlayerEvent_DeathStatusChange",
}

PVPEvent = {
--????????????????????????
	PVPDungeonLaunch = "PVPEvent_PVPDungeonLaunch",
	PVPDungeonShutDown = "PVPEvent_PVPDungeonShutDown",
--?????????
	PVP_ChaosFightLaunch = "PVP_ChaosFightLaunch",
	PVP_ChaosFightShutDown = "PVP_ChaosFightShutDown",
--?????????
	PVP_DesertWolfFightLaunch = "PVP_DesertWolfFightLaunch",
	PVP_DesertWolfFightShutDown = "PVP_DesertWolfFightShutDown",
--????????????
	PVP_GlamMetalFightLaunch = "PVP_GlamMetalFightLaunch",
	PVP_GlamMetalFightShutDown = "PVP_GlamMetalFightShutDown",
--???????????????
	PVP_PoringFightLaunch = "PVP_PoringFightLaunch",
	PVP_PoringFightShutdown = "PVP_PoringFightShutdown",
--MVP?????????
	PVP_MVPFightLaunch = "PVP_MVPFightLaunch",
	PVP_MVPFightShutDown = "PVP_MVPFightShutDown",

}

PVEEvent = {
	--????????????
	PVE_CardLaunch = "PVE_CardLaunch",
	PVE_CardShutdown = "PVE_CardShutdown",
	Altman_Launch = "Altman_Launch",
	Altman_Shutdown = "Altman_Shutdown",
}

GVGEvent = {
--???????????????GVG
	GVGDungeonLaunch = "GVGEvent_GVGDungeonLaunch",
	GVGDungeonShutDown = "GVGEvent_GVGDungeonShutDown",
	ShowNewAchievemnetEffect = "GVGEvent_ShowNewAchievemnetEffect",
	GVG_FinalFightLaunch = "GVGEvent_GVG_FinalFightLaunch",
	GVG_FinalFightShutDown = "GVGEvent_GVG_FinalFightShutDown",
}

-- ??????????????????????????????
YoyoJoinRoomEvent={
	JoinRoom="YoyoJoinRoomEvent_JoinRoom",
}

MyselfEvent= {
	Inited = "MyselfEvent_Inited",
	PlaceTo = "MyselfEvent_PlaceTo",
	LeaveScene = "MyselfEvent_LeaveScene",
	SelectTargetChange = "MyselfEvent_SelectTargetChange",
	SelectTargetClassChange = "MyselfEvent_SelectTargetClassChange",
	--???????????????????????????????????????????????????
	MyPropChange = "MyselfEvent_MyPropChange",
	--????????????????????????????????????
	MyDataChange = "MyselfEvent_MyDataChange",
	--?????????????????????????????????
	MyAttrChange = "MyselfEvent_MyAttrChange",
	MyProfessionChange = "MyselfEvent_MyProfessionChange",
	ScaleChange = "MyselfEvent_ScaleChange",
	AskUseSkill = "MyselfEvent_AskUseSkill",
	CancelAskUseSkill = "MyselfEvent_CancelAskUseSkill",
	LevelUp = "MyselfEvent_LevelUp",
	JobExpChange = "MyselfEvent_JobExpChange",
	BaseExpChange = "MyselfEvent_BaseExpChange",
	ZenyChange = "MyselfEvent_ZenyChange",
	ContributeChange = "MyselfEvent_ContributeChange",
	BattlePointChange = "MyselfEvent_BattlePointChange",
	MusicInfoChange = "MyselfEvent_MusicInfoChange",
	ResetHpShortCut = "MyselfEvent_ResetHpShortCut",
	MyRoleChange = "MyselfEvent_MyRoleChange",
	ChangeDress = "MyselfEvent_ChangeDress",
	--???npc????????????
	HitTargets = "MyselfEvent_HitTargets",
	BeHited = "MyselfEvent_BeHited",
	-- ??????????????????
	AccessTarget = "MyselfEvent_AccessTarget",
	AccessSealNpc = "MyselfEvent_AccessSealNpc",
	-- ????????????????????????
	ManualControlled = "MyselfEvent_ManualControlled",
	SyncBuffs = "MyselfEvent_SyncBuffs",
	AddBuffs = "MyselfEvent_AddBuffs",
	RemoveBuffs = "MyselfEvent_RemoveBuffs",
	DeathBegin = "MyselfEvent_DeathBegin",
	DeathEnd = "MyselfEvent_DeathEnd",
	ReliveStatus = "MyselfEvent_ReliveStatus",
	DeathStatus = "MyselfEvent_DeathStatus",
	LeaveCarrier = "MyselfEvent_LeaveCarrier",
	SkillPointChange = "MyselfEvent_SkillPointChange",
	SpChange = "MyselfEvent_SpChange",
	HpChange = "MyselfEvent_HpChange",
	EnableUseSkillStateChange = "MyselfEvent_EnableUseSkillStateChange",
	UsedSkill = "MyselfEvent_UsedSkill",
	ChangeJobReady = "MyselfEvent_ChangeJobReady",
	ChangeJobBegin = "MyselfEvent_ChangeJobBegin",
	ChangeJobEnd = "MyselfEvent_ChangeJobEnd",
	PartnerChange = "MyselfEvent_PartnerChange",
	MyselfSceneUIClear = "MyselfSceneUIClear",
	TransformChange = "MyselfEvent_TransformChange",
	UpdateAttrEffect = "MyselfEvent_UpdateAttrEffect",
	AddWeakDialog = "MyselfEvent_AddWeakDialog",

	--skill
	SkillGuideBegin = "MyselfEvent_SkillGuideBegin",
	SkillGuideEnd = "MyselfEvent_SkillGuideEnd",

	--new
	TargetPositionChange = "MyselfEvent_TargetPositionChange",

	ZoneIdChange = "MyselfEvent_ZoneIdChange",

	MissionCommandChanged = "MyselfEvent_MissionCommandChanged",
	SceneGoToUserCmdHanded = "MyselfEvent_SceneGoToUserCmd",
	BuffChange = "MyselfEvent_BuffChange",

	CookerLvChange = "MyselfEvent_CookerLvChange",
	TasterLvChange = "MyselfEvent_TasterLvChange",
	Pet_HpChange = "MyselfEvent_Pet_HpChange",
	ServantFavorChange = "MyselfEvent_ServantFavorChange",

	TwinActionStart = "MyselfEvent_TwinActionStart",
}

ItemEvent = {
	ItemCmd = "ItemEvent_ItemCmd",
	--????????????
	ItemUpdate = "ItemEvent_ItemUpdate",

	BarrowUpdate = "ItemEvent_BarrowUpdate",
	--????????????
	ItemReArrage = "ItemEvent_ItemReArrage",
	--??????????????????
	EquipUpdate = "ItemEvent_EquipUpdate",
	--????????????
	FashionUpdate = "ItemEvent_FashionUpdate",
	--????????????
	ItemUse = "ItemEvent_ItemUse",
	--??????????????????
	BetterEquipAdd = "ItemEvent_BetterEquipAdd",
	CardBagUpdate = "ItemEvent_CardBagUpdate",
	--????????????
	TempBagUpdate = "ItemEvent_TempBagUpdate",

	ClickItem = "ItemEvent_ClickItem",
	DoubleClickItem = "ItemEvent_DoubleClickItem",

	GoTraceItem = "ItemEvent_GoTraceItem",

	Equip = "ItemEvent_Equip",
	--??????????????????
	ReviveItemAdd = "ItemEvent_ReviveItemAdd",
	--??????????????????
	ReviveItemRemove = "ItemEvent_ReviveItemRemove",

	ItemUseTip = "ItemEvent_ItemUseTip",

	QuestUpdate = "ItemEvent_QuestUpdate",

	FoodUpdate = "ItemEvent_FoodUpdate",
}

PackageEvent = {
	OpenBarrowBag = "PackageEvent_OpenBarrowBag",
}

ItemTradeEvent = {
	TradePriceChange = "ItemTradeEvent_TradePriceChange",
}

RoleEquipEvent = {
	TakeOn = "RoleEquipEvent_TakeOn",
	TakeOff = "RoleEquipEvent_TakeOff",

	OffPosBegin = "RoleEquipEvent_OffPosBegin",
	OffPosEnd = "RoleEquipEvent_OffPosEnd",
	AllOffPosEnd = "RoleEquipEvent_AllOffPosEnd",

	ProtectPosBegin = "RoleEquipEvent_ProtectPosBegin",
	ProtectPosEnd = "RoleEquipEvent_ProtectPosEnd",
	AllProtectPosEnd = "RoleEquipEvent_AllProtectPosEnd",

	BreakEquipBegin = "RoleEquipEvent_BreakEquipBegin",
	BreakEquipEnd = "RoleEquipEvent_BreakEquipEnd",
	AllBreakEquipEnd = "RoleEquipEvent_AllBreakEquipEnd",
}

ItemTipEvent = {
	ClickTipFuncEvent = "ItemTipEvent_ClickTipFuncEvent",
	ShowGetPath = "ItemTipEvent_ShowGetPath",
	ShowEquipUpgrade = "ItemTipEvent_ShowEquipUpgrade",
	ShowFashionPreview = "ItemTipEvent_ShowFashionPreview",
	ClickGotoUse = "ItemTipEvent_ClickGotoUse",
	ShowGotoUse = "ItemTipEvent_ShowGotoUse",
	CloseShowGotoUse = "ItemTipEvent_CloseShowGotoUse",
	CloseTip = "ItemTipEvent_CloseTip",
}

LoadSceneEvent = {
	StartLoad = "LoadSceneEvent_StartLoad",
	FinishLoad = "LoadSceneEvent_FinishLoad",
	BeginLoadScene = "LoadEvent_BeginLoadScene",
	FinishLoadScene = "LoadEvent_FinishLoadScene",
	SceneAnimEnd = "LoadEvent_SceneAnimEnd",
}

GameEvent = {
	RestartGame = "GameEvent_RestartGame",
}

SceneUserEvent = {
	SceneAddRoles = "SceneEvent_SceneAddRoles",
	SceneAddNpcs = "SceneEvent_SceneAddNpcs",
	SceneAddPets = "SceneEvent_SceneAddPets",
	SceneRemoveRoles = "SceneEvent_SceneRemoveRoles",
	SceneRemoveNpcs = "SceneEvent_SceneRemoveNpcs",
	SceneRemovePets = "SceneEvent_SceneRemovePets",
	LevelUp = "SceneUserEvent_LevelUp",
	EatHp = "SceneUserEvent_EatHp",
	BaseLevelUp = "SceneUserEvent_BaseLevelUp",
	JobLevelUp = "SceneUserEvent_JobLevelUp",
	ChangeProfession = "SceneUserEvent_ChangeProfession",
	FloatMsg = "SceneUserEvent_FloatMsg",
	ManualLevelUp = "SceneUserEvent_ManualLevelUp",
	AppellationUp = "SceneUserEvent_AppellationUp",
	AchievementTitleChanged = "SceneUserEvent_AchievementTitleChanged",
}

SceneItemEvent = {
	AddSceneItems = "SceneItemEvent_AddSceneItems",
	RemoveSceneItems = "SceneItemEvent_RemoveSceneItems",
}

SceneCreatureEvent = {
	PropChange = "SceneCreatureEvent_PropChange",
	PropHpChange = "SceneCreatureEvent_PropHpChange",
	CreatureRemove = "SceneCreatureEvent_CreatureRemove",
	DeathBegin = "SceneCreatureEvent_DeathBegin",
}

SceneGlobalEvent = {
	Map2DChanged = "SceneGlobalEvent_Map2DChanged"
}

LoadEvent = {
	StartLoadScene = "StartLoadScene",
	FinishLoadScene = "FinishLoadScene",
	SceneFadeOut = "LoadSceneEvent_SceneFadeOut",
}

MouseEvent = {
	MouseClick = "MouseEvent_MouseClick",
	DoubleClick = "MouseEvent_DoubleClick",
	MousePress = "MouseEvent_MousePress",
	LongPress = "MouseEvent_LongPress",
}

DragDropEvent = {
	SwapObj = "DragDropEvent_SwapObj",
	DropEmpty = "DragDropEvent_DropEmpty",
	StartDrag = "DragDropEvent_StartDrag",
}

SkillEvent= {
	SkillStartEvent = "SkillEvent_SkillStartEvent", 
	SkillUpdate = "SkillEvent_SkillUpdate",
	SkillCastBegin = "SkillEvent_SkillCastBegin",
	SkillCastEnd = "SkillEvent_SkillCastEnd",
	SkillWithUseTimesChanged = "SkillEvent_SkillWithUseTimesChanged",
	SkillUnlockPos = "SkillEvent_SkillUnlockPos",
	SkillEquip = "SkillEvent_SkillEquip",
	SkillDisEquip = "SkillEvent_SkillDisEquip",
	SkillFitPreCondtion = "SkillEvent_SkillFitPreCondtion",
	SkillWaitNextUse = "SkillEvent_SkillWaitNextUse",
	SkillCancelWaitNextUse = "SkillEvent_SkillCancelWaitNextUse",
	SkillSelectPhaseStateChange = "SkillEvent_SkillSelectPhaseStateChange",
}

QuestEvent = {
	QuestDelete = "QuestEvent_QuestDelete",
	QuestAdd = "QuestEvent_QuestAdd",
	QuestEnterArea = "QuestEvent_QuestEnterArea",
	QuestExitArea = "QuestEvent_QuestExitArea",
	ProcessChange = "QuestEvent_ProcessChange",
	RemoveHelpQuest = "QuestEvent_RemoveHelpQuest",
	UpdateAnnounceQuest = "QuestEvent_UpdateAnnounceQuest",
	UpdateAnnounceQuestList = "QuestEvent_UpdateAnnounceQuestList",
	RemoveGuildQuestList = "QuestEvent_RemoveGuildQuestList",
	UpdateGuildQuestList = "QuestEvent_UpdateGuildQuestList",
}

DialogEvent = {
	DialogEnd = "DialogEvent_DialogEnd",
	AddMenuEvent = "DialogEvent_AddMenuEvent",
	CameraFoucsOffNpc = "DialogEvent_CameraFoucsOffNpc",
	NpcFuncStateChange = "DialogEvent_NpcFuncStateChange",
	AddUpdateSetTextCall = "DialogEvent_AddUpdateSetTextCall",
	ServerOpenFunction = "DialogEvent_ServerOpenFunction",
}

MainViewEvent = {
	ShowOrHide = "MainViewEvent_ShowOrHide",
	ActiveShortCutBord = "MainViewEvent_ActiveShortCutBord",
	TopFuncActive = "MainViewEvent_TopFuncActive",

	AddQuestFocus = "MainViewEvent_AddQuestFocus",
	RemoveQuestFocus = "MainViewEvent_RemoveQuestFocus",

	AddItemTrace = "MainViewEvent_AddItemTrace",
	CancelItemTrace = "MainViewEvent_CancelItemTrace",
	EmojiViewShow = "MainViewEvent_EmojiViewShow",

	MenuActivityOpen = "MainViewEvent_MenuActivityOpen",
	MenuActivityClose = "MainViewEvent_MenuActivityClose",
	UpdateMatchBtn = "MainViewEvent_UpdateMatchBtn",
	UpdateTutorMatchBtn = "MainViewEvent_UpdateTutorMatchBtn"
}

InviteConfirmEvent = {
	AddInvite = "InviteConfirmEvent_AddInvite",
	RemoveInviteByType = "InviteConfirmEvent_RemoveInviteByType",
	
	Agree = "InviteConfirmEvent_Agree",
	Refuse = "InviteConfirmEvent_Refuse",
    TimeOver = "InviteConfirmEvent_TimeOver",

    Courtship_OutDistance = "InviteConfirmEvent_Courtship_OutDistance",
}

EmojiEvent = {
	PlayEmoji = "EmojiEvent_PlayEmoji",
	
	ShowBord = "EmojiEvent_ShowBord",
	HideBord = "EmojiEvent_HideBord",
}

ActionEvent = {
	PlayEmojiAction = "ActionEvent_PlayEmojiAction",
	PlayNormalAction = "ActionEvent_PlayNormalAction",
}

WorldMapEvent = {
	ShowLevelDetail = "WorldMapEvent_ShowLevelDetail",
	NewKnownMap="WorldMapEvent_NewKnownMap",
}

ChangeProfessionPanelEvent = {
	SelectTargetChange = "ChangeProfessionPanelEvent_SelectTargetChange",
}

TeamEvent = {
	NewApply = "TeamEvent_NewApply",	
	MemberChangeMap = "TeamEvent_MemberChangeMap",
	MemberEnterTeam = "TeamEvent_MemberEnterTeam",
	MemberExitTeam = "TeamEvent_MemberExitTeam",
	MemberOffline = "TeamEvent_MemberOffline",
	MemberOnline = "TeamEvent_MemberOnline",
	MyLeaderChange = "TeamEvent_MyLeaderChange",
	ChangeMap = "TeamEvent_ChangeMap",
	ExitTeam = "TeamEvent_ExitTeam",
}

ShortCut ={
	MoveToPos = "MoveToPos",
}

GuildEvent = {
	GuildUpgrade = "GuildEvent_GuildUpgrade",
}

GuildChallengeEvent = 
{
	CloseUI = "GuildChallengeEvent_CloseUI",
}

CarrierEvent = {
	ShowUI = "CarrierEvent_ShowUI",
	MyCarrierStart = "CarrierEvent_MyCarrierStart",
	MyCarrierLeaveMember = "CarrierEvent_MyCarrierLeaveMember",
}

RefineEvent={
	SelectEquip="RefineEvent_SelectEquip",
}

HappyShopEvent={
	SelectIconSprite="HappyShopEvent_SelectIconSprite",
}

TriggerEvent = {
	AddTrigger = "TriggerEvent_AddTrigger",
	RemoveTrigger = "TriggerEvent_RemoveTrigger",

	Enter_GDFightForArea = "TriggerEvent_Enter_GDFightForArea",
	Leave_GDFightForArea = "TriggerEvent_Leave_GDFightForArea",
	Remove_GDFightForArea = "TriggerEvent_Remove_GDFightForArea",
}

ChatRoomEvent={
	PresetText="ChatRoomEvent_PresetText",
	OpenPopWindow="ChatRoomEvent_OpenPopWindow",
	UpdateSelectChat = "ChatRoomEvent_UpdateSelectChat",
	SystemMessage = "ChatRoomEvent_SystemMessage",
	PrivateSelfMessage = "ChatRoomEvent_PrivateSelfMessage",
	SelectHead = "ChatRoomEvent_SelectHead",
	CancelCreateChatRoom = "ChatRoomEvent_CancelCreateChatRoom",
	KeywordEffect = "ChatRoomEvent_KeywordEffect",
	StopRecognizer = "ChatRoomEvent_StopRecognizer",
	SendSpeech = "ChatRoomEvent_SendSpeech",
	StartVoice = "ChatRoomEvent_StartVoice",
	StopVoice = "ChatRoomEvent_StopVoice",
	BarrageEffect = "ChatRoomEvent_BarrageEffect",
	ChangeChannel = "ChatRoomEvent_ChangeChannel",
	ForceChannel = "ChatRoomEvent_ForceChannel",
}

ChatZoomEvent = {
	ShowTip = "ChatZoomEvent_ShowTip",
	HideTip = "ChatZoomEvent_HideTip",
	-- when protocol ChatZoomSync&AddMapUser, transmit chatZoomSummary to inputSecretChatZoomPanel
	TransmitChatZoomSummary = "ChatZoomEvent_TransmitChatZoomSummary",
	TranslateMemberTipStyle = "ChatZoomEvent_TranslateMemberTipStyle"
}

CreateRoleViewEvent = {
	HairStyleClick = "CreateRoleViewEvent_HairStyleClick",
	HeadwearClick = "CreateRoleViewEvent_HeadwearClick",
	PlayerMapChange = 'CreateRoleViewEvent_PlayerMapChange'
}

EquipRepairEvent={
	SelectIconSprite="EquipRepairEvent_SelectIconSprite",
}

EquipRecoverEvent={
	Select="EquipRecoverEvent_Select",
}

ShopSaleEvent={
	canelSale="ShopSaleEvent_canelSale",
	SelectIconSprite="ShopSaleEvent_SelectIconSprite",
	SaleSuccess = "ShopSaleEvent_SaleSuccess"
}

PictureWallDataEvent = {
	PhotoCompleteCallback = "PictureWallDataEvent_PhotoCompleteCallback",
	PhotoProgressCallback = "PictureWallDataEvent_PhotoProgressCallback",
	MapEnd = "PictureWallDataEvent_MapEnd",
	ShowRedTip = "PictureWallDataEvent_ShowRedTip",
	SelectedPicChange = "PictureWallDataEvent_SelectedPicChange",

}
AdventureDataEvent = {
	AdDataFashUpdate = "AdventureDataEvent_AdDataFashUpdate",
	--????????????
	AdDataCardUpdate = "AdventureDataEvent_AdDataCardUpdate",
	--????????????
	AdDataEquipUpdate = "AdventureDataEvent_AdDataEquipUpdate",
	--??????????????????
	AdDataItemUpdate = "AdventureDataEvent_AdDataItemUpdate",
	--????????????
	AdDataMountUpdate = "AdventureDataEvent_AdDataMountUpdate",
	--????????????
	AdDataMonsterUpdate = "AdventureDataEvent_AdDataMonsterUpdate",

	AdDataNpcUpdate = "AdventureDataEvent_AdDataNpcUpdate",
	SceneManualQueryManualData = "AdventureDataEvent_SceneManualManualUpdate",
	SceneManualManualUpdate = "AdventureDataEvent_SceneManualManualUpdate",
	SceneItemsUpdate = "AdventureDataEvent_SceneItemsUpdate",
	ThumbnailCompleteCallback = "AdventureDataEvent_ThumbnailCompleteCallback",
	ThumbnailTextureCompleteCallback = "AdventureDataEvent_ThumbnailTextureCompleteCallback",
	ThumbnailErrorCallback = "AdventureDataEvent_ThumbnailErrorCallback",
	ThumbnailProgressCallback = "AdventureDataEvent_ThumbnailProgressCallback",
	PhotoCompleteCallback = "AdventureDataEvent_PhotoCompleteCallback",
	PhotoProgressCallback = "AdventureDataEvent_PhotoProgressCallback",
	PhotoErrorCallback = "AdventureDataEvent_PhotoErrorCallback",
	SceneManualManualInit = "AdventureDataEvent_SceneManualManualInit",
}

FollowEvent = {
	Follow = "FollowEvent_Follow",
	CancelFollow = "FollowEvent_CancelFollow",
}

ChooseEquipEvent = {
	ChooseEquip = "ChooseEquipEvent",
}

SystemMsgEvent = {
	MenuMsg = "SystemMsgEvent.MenuMsg",
	MenuCoinPop = "SystemMsgEvent.MenuCoinPop",
	MenuItemPop = "SystemMsgEvent.MenuItemPop",
	NoticeMsg = "SystemMsgEvent.NoticeMsg",
	RaidAdd = "SystemMsgEvent.RaidAddMsg",
	RaidRemove = "SystemMessage.RaidRemove",
}

SealEvent = {
	ShowSlider = "SealEvent_ShowSlider",
	HideSlider = "SealEvent_HideSlider",
}

MissionCommandEvent = {
	MissionCommandEvent = "MissionCommandEvent",
}

PhotographModeChangeEvent = {
	ModeChangeEvent = "PhotographModeChangeEvent_ModeChangeEvent",
}

MiniMapEvent = {
	ExitPointStateChange = "MiniMapEvent_ExitPointStateChange",
	ShowMiniMapDirEffect = "MiniMapEvent_ShowMiniMapDirEffect",
	ExitPointReInit = "MiniMapEvent_ExitPointReInit",
	CreatureScenicChange = "MiniMapEvent_CreatureScenicChange",
	CreatureScenicAdd = "MiniMapEvent_CreatureScenicAdd",
	CreatureScenicRemove = "MiniMapEvent_CreatureScenicRemove",
	GvgDroiyan_ = "",
	GvgDroiyan_ = "",
}

FriendEvent = {
	SelectHead = "FriendEvent_SelectHead",
}

BlacklistEvent = {
	SelectHead = "BlacklistEvent_SelectHead",
}

GuideEvent = {
	ShowBubble = "GuideEvent_ShowBubble",
	ShowAutoFightBubble = "GuideEvent_ShowAutoFightBubble",
	AutoFightMonster = "GuideEvent_AutoFightMonster",
	MiniMapAnim = "GuideEvent_MiniMapAnim",
	SessionShopQueryShopConfigCmd = "GuideEvent_SessionShopQueryShopConfigCmd",

	MapGuide_Change = "GuideEvent_MapGuide_Change",
}

BeautifulAreaPhotoNeting = 
{
	OnProgress = "BeautifulAreaPhotoNeting_OnProgress",
	OnComplete = "BeautifulAreaPhotoNeting_OnComplete"
}

SystemUnLockEvent = {
	ShowNextEvent = "SystemUnLockEvent.ShowNextEvent",
	UnLockMenuEvent = "SystemUnLockEvent.UnLockMenuEvent",
	NUserNewMenu = "SystemUnLockEvent.NUserNewMenu",
	CommonUnlockInfo = "SystemUnLockEvent_CommonUnlockInfo",
}

ShopMallEvent = {
	ExchangeClickFatherTypes = "ShopMallEvent_ExchangeClickFatherTypes",
	ExchangeCloseBuyInfo = "ShopMallEvent_ExchangeCloseBuyInfo",
	ExchangeCloseSellInfo = "ShopMallEvent_ExchangeCloseSellInfo",
	ExchangeSearchOpenDetail = "ShopMallEvent_ExchangeSearchOpenDetail",
	ExchangeUpdateBuyView = "ShopMallEvent_ExchangeUpdateBuyView",
	ExchangeSelectFriend = "ShopMallEvent_ExchangeSelectFriend",
}

NewLoginEvent = {
	LoginFailure = "NewLoginEvent_LoginFailure",
	StartLogin = "NewLoginEvent_StartLogin",
	UpdateServerList = "NewLoginEvent_UpdateServerList",
	StartSdkLogin = "NewLoginEvent_StartSdkLogin",
	EndSdkLogin = "NewLoginEvent_EndSdkLogin",
	ConnectServerFailure = "NewLoginEvent_ConnectServerFailure",
	ReqLoginUserCmd = "NewLoginEvent_ReqLoginUserCmd",
	StopReconnect = "NewLoginEvent_StopReconnect",
	StartReconnect = "NewLoginEvent_StartReconnect",
	StartShowWaitingView = "NewLoginEvent_StartShowWaitingView",
	StopShowWaitingView = "NewLoginEvent_StopShowWaitingView",
	LaunchFailure = "NewLoginEvent_LaunchFailure",
	SDKLoginFailure = "NewLoginEvent_SDKLoginFailure",
}

EventFromLogin = {
	ShowAnnouncement = 'EventFromLogin_ShowAnnouncement'
}

VisitNpcEvent = {
	TargetChange = "VisitNpcEvent_TargetChange",
}

SetEvent = {
	ShowOtherName = "SetEvent_ShowOtherName",
}

SkyWheel = {
	Select = "SkyWheel_Select",
	CloseAccept = "SkyWheel_CloseAccept",
	ChangeTarget = "SkyWheel_ChangeTarget",
}

DojoEvent = {
	EnterSuccess = "DojoEvent_EnterSuccess",
}

LoginRoleEvent = {
	UIRoleBeSelected = 'LoginRole_UIRoleBeSelected',
}

EDViewEvent = {
	ActiveLuPinWord = 'EDView_ActiveLuPinWord',
}

TempItemEvent = {
	TempWarnning = "TempItemEvent_TempWarnning",
}

ChangeHeadEvent = {
	Select = "ChangeHead_Select",
}

PlotStoryViewEvent = {
	AddButton = "PlotStoryEvent_AddButton",
}

CardMakeEvent = {
	Select = "CardMakeEvent_Select",
}

AstrolabeEvent = {
	TipClose = "AstrolabeEvent_TipClose",
}

CardPosChoosePopUpEvent = {
	ChoosePos = "CardPosChoosePopUp_ChoosePos",
}

FoodEvent = {
	MakeStateChange = "FoodEvent_MakeStateChange",
	PutMaterials = "FoodEvent_PutMaterials",

	MaterialExp_LvUp = "MaterialExp_LvUp",
	FoodEatExp_LvUp = "FoodEatExp_LvUp",
	FoodCookExp_LvUp = "FoodCookExp_LvUp",

	FoodGetPopUp_Enter = "FoodGetPopUp_Enter",
	FoodGetPopUp_Exit = "FoodGetPopUp_Exit",
}

ShareEvent = {
	ClickPlatform = "ShareEvent_ClickPlatform",
}

LotteryEvent = {
	Select = "LotteryEvent_Select",
	EffectStart = "LotteryEvent_EffectStart",
	EffectEnd = "LotteryEvent_EffectEnd",
	MagicPictureComplete = "LotteryEvent_MagicPictureComplete",
}

PetEvent = {
	AddCatchPetBord = "PetEvent_AddCatchPetBord",
	RemoveCatchPetBord = "PetEvent_RemoveCatchPetBord",

	BeingInfoData_SummonChange = "PetEvent_BeingInfoData_SummonChange",
	BeingInfoData_AliveChange = "PetEvent_BeingInfoData_AliveChange",
	ClickPetAdventureIcon = "PetEvent_ClickIcon",
}

Artifact = {
	Option="Artifact_Option",
}

AuctionEvent = {
	FinishCountdown = "AuctionEvent_FinishCountdown",
}

QuickBuyEvent = {
	Refresh = "QuickBuyEvent_Refresh",
	Select = "QuickBuyEvent_Select",
	Close = "QuickBuyEvent_Close",
}

RecallEvent = {
	Select = "RecallEvent_Select",
}

GuildBuildingEvent = {
	SubmitMaterial = "GuildBuildingEvent_submitMaterial",
	OnClickBuildBtn = "GuildBuildingEvent_OnClickBuildBtn",
}

ZenyShopEvent = {
	CanPurchase = 'ZenyShopEvent_CanPurchase'
}

WeddingEvent = {
	Buy = "WeddingEvent_Buy",
	Select = "WeddingEvent_Select",
}

SelectFriendEvent = {
	Select = "SelectFriendEvent_Select",
}

PushEvent = {
	OnReceiveNotification = "PushEvent_OnReceiveNotification",
	OnReceiveMessage = "PushEvent_OnReceiveMessage",
	OnOpenNotification = "PushEvent_OnOpenNotification",
	OnJPushTagOperateResult = "PushEvent_OnJPushTagOperateResult",
	OnJPushAliasOperateResult = "PushEvent_OnJPushAliasOperateResult",
}

FinanceEvent = {
	ShowDetail = "FinanceEvent_ShowDetail",
}

BoothEvent = {
	ShowMiniBooth = "BoothEvent_ShowMiniBooth",
	AddItem = "BoothEvent_AddItem",
	CloseInfo = "BoothEvent_CloseInfo",
	ConfirmInfo = "BoothEvent_ConfirmInfo",
}