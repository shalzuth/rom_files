QuestDataStepType = 
{
	QuestDataStepType_VISIT = "visit",
	QuestDataStepType_KILL = "kill",
	QuestDataStepType_COLLECT = "collect",
	QuestDataStepType_USE = "use",
	QuestDataStepType_CAMERA = "camera",
	QuestDataStepType_GATHER = "gather",
	QuestDataStepType_RAID = "raid",
	QuestDataStepType_LEVEL = 'level',
	QuestDataStepType_MOVE = 'move',
	QuestDataStepType_WAIT = 'wait',
	QuestDataStepType_TALK = 'dialog',
	QuestDataStepType_SELFIE = "selfie",
	QuestDataStepType_PURIFY = "purify",
	QuestDataStepType_REWARD = "reward",
	QuestDataStepType_GUIDE = "guide",
	QuestDataStepType_GUIDECHECK = "guide_check",
	QuestDataStepType_MEDIA = "play_video",
	QuestDataStepType_ILLUSTRATION = "illustration",
	QuestDataStepType_DAILY = "daily",
	QuestDataStepType_ITEM = "item",
	QuestDataStepType_SEAL = "seal",
	QuestDataStepType_INVADE = "invade",
	QuestDataStepType_ADVENTURE = "adventure",
	QuestDataStepType_CHECKPROGRESS = "check_progress",
	QuestDataStepType_GUIDELOCKMONSTER = "guideLockMonster",
	QuestDataStepType_MONEY = "money",
	QuestDataStepType_CLIENT_PLOT = "client_plot",
	QuestDataStepType_PHOTO = "photo",
	QuestDataStepType_HAND = "hand",
	QuestDataStepType_ITEM_USE = "item_use",
	QuestDataStepType_MUSIC = "music",
	QuestDataStepType_CARRIER = "carrier",
	QuestDataStepType_BATTLE = "battle",
	QuestDataStepType_PLAY_CG = "play_cg",
}

QuestDataType = {
	QuestDataType_MAIN = "main",
	QuestDataType_BRANCH = "branch",
	QuestDataType_TALK = "talk",
	QuestDataType_WANTED = "wanted",
	QuestDataType_MANUAL= "manual",
	QuestDataType_DAILY= "daily",
	QuestDataType_SEALTR= "sealTr",
	QuestDataType_ITEMTR= "itemTr",
	QuestDataType_HelpTeamQuest= "HelpTeamQuest",
	QuestDataType_STORY= "story",
	QuestDataType_DAILY_1 = "daily_1",
	QuestDataType_DAILY_3 = "daily_3",
	QuestDataType_DAILY_7 = "daily_7",
	QuestDataType_SCENE = "scene",
	QuestDataType_HEAD = "head",
	QuestDataType_INVADE = "invade",
	QuestDataType_COUNT_DOWN = "count_down",
	QUESTDATATYPE_SATISFACTION = "satisfaction",
	QUESTDATATYPE_STORY_CCRASTEHAM = "story_ccrasteham",
	QuestDataType_ELITE = "elite",
	-- ????????????
	QuestDataType_CCRASTEHAM = "ccrasteham",
	QuestDataType_Raid_Talk =  "raid_talk",
	QuestDataType_GUILDQUEST =  "guild",
	QuestDataType_CHILD =  "child",
	QuestDataType_DAILY_RESET =  "daily_reset",
	QuestDataType_ACC =  "acc",
	QuestDataType_ACC_NORMAL  =  "acc_normal",
	QuestDataType_ACC_DAILY =  "acc_daily",
	QuestDataType_ACC_CHOICE =  "acc_choice",
	QuestDataType_ACTIVITY_TRACEINFO =  "activity_traceinfo",
	QuestDataType_DAILY_MAPRAND =  "daily_maprand",
	QuestDataType_DAILY_BOX =  "daily_box",

	QuestDataType_ACC_MAIN =  "acc_main",
	QuestDataType_ACC_BRANCH =  "acc_branch",
	QuestDataType_ACC_SATISFACTION = "acc_satisfaction",

	QuestDataType_ACC_DAILY_1 = "acc_daily_1",
	QuestDataType_ACC_DAILY_3 = "acc_daily_3",
	QuestDataType_ACC_DAILY_7 = "acc_daily_7",

	QuestDataType_ACC_RESET = "acc_reset",
	
	QuestDataType_NIGHT = "night",
	QuestDataType_DAY = "day",

	QuestDataType_SIGN = "sign",

	QuestDataType_ARTIFACT = "artifact",
	QuestDataType_WEDDING = "wedding",
	QuestDataType_WEDDING_DAILY = "wedding_daily",
	QuestDataType_CAPRA = "capra",
}

QuestSymbolType = {
	TraceTalk = 1,
	Main = 2,
	Branch = 3,
	Daily = 4,
	Stroy = 5,
	Scene = 6,
	Head = 7,
	Satisfaction = 8,
	Elite = 9,
	-- ????????????
	Ccrasteham = 10,
	CcrasteStory = 11,
	GuildQuest = 12,

	New_Daily = 13,
	Gift = 14,
}

QuestSymbolConfig = {
	[1] = { SceneSymbol = EffectMap.UI.QuestWait, UISymbol = "44map_icon_talk", UISpriteName = "map_icon_talk" },
	[2] = { SceneSymbol = EffectMap.UI.QuestWaitRed, UISymbol = "41map_icon_task_red", UISpriteName = "map_icon_task_red" },
	[3] = { SceneSymbol = EffectMap.UI.QuestWaitGreen, UISymbol = "43map_icon_task_greed", UISpriteName = "map_icon_task_greed" },
	[4] = { SceneSymbol = EffectMap.UI.QuestWaitBlue, UISymbol = "42map_icon_task_blue", UISpriteName = "map_icon_task_blue" },
	[5] = { SceneSymbol = EffectMap.UI.QuestStory, UISymbol = "52map_icon_task_story", UISpriteName = "map_quest" },
	[6] = { SceneSymbol = EffectMap.UI.Exclamationphoto, UISymbol = "65map_icon_task_phono" },
	[7] = { SceneSymbol = EffectMap.UI.Exclamationhead, UISymbol = "66map_icon_task_head" },
	[8] = { SceneSymbol = EffectMap.UI.Exclamaation_duel, UISymbol = "73map_icon_task_duel" },
	[9] = { SceneSymbol = EffectMap.UI.Exclamaation_hig, UISymbol = "72map_icon_task_hig" },
	[10] = { SceneSymbol = EffectMap.UI.ExclamationCcrasteham, UISymbol = "79map_icon_task_Ccrasteham" },
	[11] = { SceneSymbol = EffectMap.UI.QuestStory2, UISymbol = "84map_icon_task_story2" },
	[12] = { SceneSymbol = EffectMap.UI.Exclamaation_guild, UISymbol = "131map_icon_task_guild" },
	[13] = { SceneSymbol = EffectMap.UI.ExclamationDaily, UISymbol = "map_icon_task_daily" },
	[14] = { SceneSymbol = EffectMap.UI.ExclamationGift, UISymbol = "map_icon_task_gift" },
}

QuestDataTypeSymbolMap = {
	[QuestDataType.QuestDataType_MAIN] = QuestSymbolType.Main,

	[QuestDataType.QuestDataType_BRANCH] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_MANUAL] = QuestSymbolType.Branch,

	[QuestDataType.QuestDataType_DAILY] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_DAILY_1] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_DAILY_3] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_DAILY_7] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_WANTED] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_DAILY_RESET] = QuestSymbolType.Daily,

	[QuestDataType.QuestDataType_STORY] = QuestSymbolType.Stroy,

	[QuestDataType.QuestDataType_SCENE] = QuestSymbolType.Scene,

	[QuestDataType.QuestDataType_HEAD] = QuestSymbolType.Head,

	[QuestDataType.QUESTDATATYPE_SATISFACTION] = QuestSymbolType.Satisfaction,

	[QuestDataType.QuestDataType_ELITE] = QuestSymbolType.Elite,
	-- ????????????
	[QuestDataType.QuestDataType_CCRASTEHAM] = QuestSymbolType.Ccrasteham,
	-- ????????????
	[QuestDataType.QUESTDATATYPE_STORY_CCRASTEHAM] = QuestSymbolType.CcrasteStory,
	-- ????????????
	[QuestDataType.QuestDataType_GUILDQUEST] = QuestSymbolType.GuildQuest,
	-- ???????????????
	[QuestDataType.QuestDataType_CHILD] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_ACC] = QuestSymbolType.Branch,

	[QuestDataType.QuestDataType_ACC_NORMAL] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_ACC_DAILY] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_ACC_CHOICE] = QuestSymbolType.Branch,

	[QuestDataType.QuestDataType_DAILY_MAPRAND] = QuestSymbolType.New_Daily,
	[QuestDataType.QuestDataType_DAILY_BOX] = QuestSymbolType.Gift,

	[QuestDataType.QuestDataType_ACC_MAIN] = QuestSymbolType.Main,
	[QuestDataType.QuestDataType_ACC_BRANCH] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_ACC_SATISFACTION] = QuestSymbolType.Satisfaction,

	[QuestDataType.QuestDataType_ACC_DAILY_1] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_ACC_DAILY_3] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_ACC_DAILY_7] = QuestSymbolType.Daily,
	[QuestDataType.QuestDataType_ACC_RESET] = QuestSymbolType.Daily,

	[QuestDataType.QuestDataType_NIGHT] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_DAY] = QuestSymbolType.Branch,
	
	[QuestDataType.QuestDataType_SIGN] = QuestSymbolType.Branch,
	
	[QuestDataType.QuestDataType_ARTIFACT] = QuestSymbolType.Branch,

	[QuestDataType.QuestDataType_WEDDING] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_WEDDING_DAILY] = QuestSymbolType.Branch,
	[QuestDataType.QuestDataType_CAPRA] = QuestSymbolType.Branch,
}