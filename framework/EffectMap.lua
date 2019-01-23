--[[
特效匹配相关配置文件
]]

EffectMap = {}

EffectMap.Maps = {
	LockedTarget = "Common/8SelectTarget",
	ClickGround = "Common/3ClickGround",
	RoleLevelUp = "Common/17Base_Lvup",
	JobLevelUp = "Common/18Job_Lvup",
	JobChange="Common/65JobChange",
	JobChangeHorn="10001JobChange_Horn",

	NormalHit = "Common/5NormalHit",
	CriticalHit = "Common/4CriticalHit",
	HurtNum = "Common/6DammageNum",
	HurtNumMiss = "Common/76Miss",

	MagicCircle = {"Common/9MagicCircle","Common/45Monster_MagicCircle"},
	MagicCircleLow = {"Common/100LowMagicCircle_B","Common/101LowMagicCircle_R"},
	LockOn = "Common/10LockOn",
	LockOnLow = "Common/102LowLockOn",
	HpUp = "Common/19HP_up",
	ItemSmoke = "Common/21ItemSmoke",
	
	ForgingSuccess = "Common/24ForgingSuccess",
	EquipUpgrade_Success = "Common/EquipeLVUP",
	ForgingFailure = 25,
	Forging_surprised=50,

	HumanDead = "Common/30dead",
	NPCDead = "Common/42Smoke_die",
	MVPKilled = "Common/44Mvp",
	DarkLight = 51,
	HairChange_success="Common/53HairChange_success",
	HairColored_success="Common/54HairColored_success",
	EyeLenses_success="Common/EyeReplace",
	photo_flashlight = "Common/56photo_flashlight",
	VisionScope="Common/70VisionScope",
	Barrage="Common/72BulletScreen",
	GuideArea="Common/73GuideArea",
	GuideArrow="Common/74GuideArrow",
	AdventureLv_up = "Common/75AdventureLv_up",
	PropertiesUp = "Common/77PropertiesUp",
	Headmusic = "Common/95Headmusic",
	TaskAperture = "Common/113TaskAperture",

	InteractionPlant_Wheat = 'Common/112Grain',

	DivineHand = "Common/DivineHand_1",
	DivineFire = "Common/DivineFire",
	CrystalBall = "Common/CrystalBall",

	PVPTeamCircl = {"Common/TeamFlag2","Common/TeamFlag1","Common/TeamFlag3"},
	SuperGVGTeamCircl = {"Common/TeamFlag4","Common/TeamFlag5","Common/TeamFlag6","Common/TeamFlag7"},

	Randomcard = "Common/randomcard",
	Compoundcard = "Common/compoundcard",

	Lottery = "Common/Lottery",

	CookLvUp = "Common/eatlvup",
	EatLvUp = "Common/cooklvup",
	StartPetAdventure = "Common/Pet_AdventureStart",

	Peak = "Common/29Top",
	Change_Job = "Common/Change_Job",
	ClothGraffiti = "Common/ClothGraffiti",
}

EffectMap.UI = {
	AutoFight = "1AutoBattleOn",
	ItemFly = "2ItemFly",
	SkillsPlay = "5SkillsPlay",
	SkillWait = "SkillWait",
	MapPoint = "8MapPoint",
	MapPoint2 = "69MapPoint2",
	PicMakeLose = "15Drawinglose",
	EatHp = "19HP_up",
	upgrade_success="9upgrade_success",

	ForgingSuccess="11ForgingSuccess",
	upgrade_surprised="10upgrade_surprised",
	decompose_success="12decompose_success",
	Forging_lvup="17Forging_lvup",

	Score_Up="18Score_up",
	UIPoint="21UIPoint",
	CardLvup = "22CardLvup",
	CardAdd = "23CardAdd",
	FlashLight = "24FlashLight",
	Focus = "25focus",
	warning = "26Warning",
	complete="27complete",
	accept="28accept",
	question="29question",
	HlightBox = "31HlightBox",
	Activation = "33Activation",
	Adventure = "34Adventure",
	-- 任务相关
	QuestWait = "38wait",
	QuestWaitRed="30exclamation",
	QuestWaitGreen = "37Exclamationgreen",
	QuestWaitBlue = "35ExclamationBlue",
	QuestWaitYellow = "36ExclamationYellow",
	WorldMapUnlock = "40WorldMapUnlock",
	QuestStory = "51ExclamationStory",
	QuestStory2 = "83ExclamationStory2",
	Exclamaation_guild = "132Exclamaation_guild",
	ExclamationDaily = "ExclamationDaily",
	ExclamationGift = "ExclamationGift",
	Exclamaation_hig = "74exclamaation_hig",
	Exclamaation_duel = "75exclamaation_duel",
	Exclamationphoto = "63Exclamationphoto",
	Exclamationhead = "64Exclamationhead",
	ExclamationCcrasteham = "80ExclamationCcrasteham",
	MapIndicates = "71MapIndicates",
	ExclamationStory = "51ExclamationStory",
	Headdress_Made_Success = "47Headdress_Made_Success",
	
	stamp = "39stamp",
	TasksAppear = "48TasksAppear",
	UIAdventureLv_up = "49UIAdventureLv_up",
	Refresh = "50Refresh",

	GodlessBlessing = "58GoddessBlessing_UI",

	GuildUpgrade = "60GuildUpgrade",
	Yggdrasilberry = "61yggdrasilberry",
	Blue_Gemstone = "62Blue_Gemstone",
	GameStart = "82GameStart",
	PVPCombo = "PVPCombo",
	PVP_Win="PVP_Win",
	PVP_Lose="PVP_Lost",
	PetAdventureVictory = "PetAdventureVictory",
	Pet_RewardUp="Pet_RewardUp",
	Pet_SkillUp = "Pet_SkillUp",
	UltimateLvUp = "UltimateLvUp",
	UltimateSuccess = "UltimateSuccess",
	Expel = "Expel",
	LotteryCard = "LotteryCard",
	Selected = "57MapSelected", 
	PetWork = "Petwork",
	EnchantTransfer = "MagicSwitch",
}

EffectMap.UIEffect_IdMap = {
	[76] = "76BigCat_Warnning",
	[81] = "81Happy_2017",
}