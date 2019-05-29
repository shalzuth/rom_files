PanelShowHideMode = {
  CreateAndDestroy = 1,
  ActiveAndDeactive = 2,
  MoveOutAndMoveIn = 3
}
PanelConfig = {
  Charactor = {
    id = 1,
    tab = nil,
    name = "\228\186\186\231\137\169",
    desc = "",
    prefab = "Charactor",
    class = "Charactor",
    hideCollider = true
  },
  CharactorAdventureSkill = {
    id = 3,
    tab = 1,
    name = "\229\134\146\233\153\169\230\138\128\232\131\189",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  CharactorProfessSkill = {
    id = 4,
    tab = 2,
    name = "\232\129\140\228\184\154\230\138\128\232\131\189",
    desc = "",
    prefab = "SkillView",
    class = "SkillView",
    unOpenJump = 3
  },
  CharactorTitle = {
    id = 5,
    tab = 4,
    name = "\228\186\186\231\137\169\231\167\176\229\143\183",
    desc = "",
    prefab = "Charactor1",
    class = "Charactor1"
  },
  CharactorBeingSkill = {
    id = 6,
    tab = 5,
    name = "\231\148\159\229\145\189\228\189\147\230\138\128\232\131\189",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  CharactorPvpTalentSkill = {
    id = 7,
    tab = 6,
    name = "\231\171\158\230\138\128\232\181\155\229\164\169\232\181\139",
    desc = "",
    prefab = "SkillView",
    class = "SkillView"
  },
  Bag = {
    id = 11,
    tab = 1,
    name = "\232\131\140\229\140\133",
    desc = "",
    prefab = "PackageView",
    class = "PackageView",
    hideCollider = true
  },
  EquipStrengthen = {
    id = 91,
    tab = 2,
    name = "\229\188\186\229\140\150",
    desc = "",
    prefab = "PackageView",
    class = "PackageView"
  },
  PackageRefine = {
    id = 12,
    tab = 3,
    name = "\229\188\186\229\140\150",
    desc = "",
    prefab = "PackageRefine",
    class = "PackageRefine"
  },
  PackageHighRefine = {
    id = 13,
    tab = 4,
    name = "\229\188\186\229\140\150",
    desc = "",
    prefab = "PackageHighRefine",
    class = "PackageHighRefine"
  },
  UseCardPopUp = {
    id = 15,
    tab = nil,
    name = "\228\189\191\231\148\168\229\141\161\231\137\135",
    desc = "",
    prefab = "UseCardPopUp",
    class = "UseCardPopUp"
  },
  SetCardPopUp = {
    id = 16,
    tab = nil,
    name = "\233\149\182\229\181\140\229\141\161\231\137\135",
    desc = "",
    prefab = "SetCardPopUp",
    class = "SetCardPopUp"
  },
  CollectSaleConfirmPopUp = {
    id = 17,
    tab = nil,
    name = "\228\184\128\233\148\174\229\135\186\229\148\174",
    desc = "",
    prefab = "CollectSaleConfirmPopUp",
    class = "CollectSaleConfirmPopUp"
  },
  TempPackageView = {
    id = 21,
    tab = nil,
    name = "\228\184\180\230\151\182\232\131\140\229\140\133",
    desc = "",
    prefab = "TempPackageView",
    class = "TempPackageView",
    hideCollider = true
  },
  NpcRefinePanel = {
    id = 31,
    tab = nil,
    name = "\231\178\190\231\130\188\231\149\140\233\157\162",
    desc = "",
    prefab = "NpcRefinePanel",
    class = "NpcRefinePanel"
  },
  HighRefinePanel = {
    id = 41,
    tab = nil,
    name = "\230\158\129\233\153\144\231\178\190\231\130\188",
    desc = "",
    prefab = "HighRefinePanel",
    class = "HighRefinePanel"
  },
  PhotographPanel = {
    id = 71,
    tab = nil,
    name = "\231\133\167\231\155\184\230\168\161\229\188\143",
    desc = "",
    prefab = "PhotographPanel",
    class = "PhotographPanel",
    hideCollider = true
  },
  PhotographResultPanel = {
    id = 81,
    tab = nil,
    name = "\231\133\167\231\155\184\231\187\147\230\158\156",
    desc = "",
    prefab = "PhotographResultPanel",
    class = "PhotographResultPanel",
    hideCollider = true
  },
  PictureDetailPanel = {
    id = 82,
    tab = nil,
    name = "\231\133\167\231\137\135\229\162\153\232\175\166\230\131\133",
    desc = "",
    prefab = "PictureDetailPanel",
    class = "PictureDetailPanel",
    hideCollider = true
  },
  PersonalPicturePanel = {
    id = 83,
    tab = nil,
    name = "\228\184\170\228\186\186\231\155\184\229\134\140",
    desc = "",
    prefab = "PersonalPicturePanel",
    class = "PersonalPicturePanel"
  },
  PersonalPictureDetailPanel = {
    id = 84,
    tab = nil,
    name = "\228\184\170\228\186\186\231\155\184\229\134\140\232\175\166\230\131\133",
    desc = "",
    prefab = "PersonalPictureDetailPanel",
    class = "PersonalPictureDetailPanel"
  },
  PicutureWallSyncPanel = {
    id = 85,
    tab = nil,
    name = "\229\133\172\228\188\154\229\162\153\229\144\140\230\173\165",
    desc = "",
    prefab = "PicutureWallSyncPanel",
    class = "PicutureWallSyncPanel"
  },
  TempPersonalPicturePanel = {
    id = 86,
    tab = nil,
    name = "\228\184\180\230\151\182\231\155\184\229\134\140",
    desc = "",
    prefab = "TempPersonalPicturePanel",
    class = "TempPersonalPicturePanel"
  },
  TempPersonalPictureDetailPanel = {
    id = 87,
    tab = nil,
    name = "\228\184\180\230\151\182\231\155\184\229\134\140\232\175\166\230\131\133",
    desc = "",
    prefab = "TempPersonalPictureDetailPanel",
    class = "TempPersonalPictureDetailPanel"
  },
  WeddingWallPictureDetail = {
    id = 88,
    tab = nil,
    name = "\229\169\154\231\164\188\231\155\184\230\161\134\232\175\166\230\131\133",
    desc = "",
    prefab = "WeddingWallPictureDetail",
    class = "WeddingWallPictureDetail"
  },
  WeddingWallPictureSyncPanel = {
    id = 89,
    tab = nil,
    name = "\229\169\154\231\164\188\231\155\184\230\161\134\228\184\138\228\188\160",
    desc = "",
    prefab = "PicutureWallSyncPanel",
    class = "WeddingWallPictureSyncPanel"
  },
  EnchantView = {
    id = 90,
    tab = nil,
    name = "\232\163\133\229\164\135\233\153\132\233\173\148",
    desc = "",
    prefab = "EnchantView",
    class = "EnchantView"
  },
  DeComposeView = {
    id = 92,
    tab = nil,
    name = "\229\136\134\232\167\163",
    desc = "",
    prefab = "DeComposeView",
    class = "DeComposeView"
  },
  ReplaceView = {
    id = 94,
    tab = nil,
    name = "\232\163\133\229\164\135\231\189\174\230\141\162",
    desc = "",
    prefab = "ReplaceView",
    class = "ReplaceView"
  },
  BossView = {
    id = 101,
    tab = nil,
    name = "Boss",
    desc = "",
    prefab = "BossView",
    class = "BossView"
  },
  AddPointPage = {
    id = 111,
    tab = 2,
    name = "\229\138\160\231\130\185",
    desc = "",
    prefab = "AddPointPage",
    class = "AddPointPage"
  },
  ProfessionPage = {
    id = 121,
    tab = 3,
    name = "\232\129\140\228\184\154",
    desc = "",
    prefab = "ProfessionPage",
    class = "ProfessionPage"
  },
  InfomationPage = {
    id = 122,
    tab = 1,
    name = "\232\167\146\232\137\178\228\191\161\230\129\175",
    desc = "",
    prefab = "InfomationPage",
    class = "InfomationPage"
  },
  ProfessionSaveLoadView = {
    id = 123,
    tab = nil,
    name = "\232\129\140\228\184\154\229\173\152\229\130\168",
    desc = "",
    prefab = "ProfessionInfoViewMP",
    class = "ProfessionContainerView"
  },
  PlayerDetailViewMP = {
    id = 124,
    tab = nil,
    name = "\231\142\169\229\174\182\232\175\166\231\187\134\228\191\161\230\129\175\231\149\140\233\157\162",
    desc = "",
    prefab = "PlayerDetailViewMP",
    class = "PlayerDetailViewMP",
    hideCollider = true
  },
  ChangeSaveNamePopUp = {
    id = 125,
    tab = nil,
    name = "\229\173\152\230\161\163\230\148\185\229\144\141",
    desc = "",
    prefab = "ChangeSaveNamePopUp",
    class = "ChangeSaveNamePopUp"
  },
  PurchaseSaveSlotPopUp = {
    id = 126,
    tab = nil,
    name = "\229\173\152\230\161\163\230\148\185\229\144\141",
    desc = "",
    prefab = "PurchaseSaveSlotPopUp",
    class = "PurchaseSaveSlotPopUp"
  },
  CheckAllProfessionPanel = {
    id = 127,
    tab = nil,
    name = "\230\159\165\231\156\139\232\129\140\228\184\154\233\157\162\230\157\191",
    desc = "",
    prefab = "CheckAllProfessionPanel",
    class = "CheckAllProfessionPanel"
  },
  RepositoryView = {
    id = 141,
    tab = nil,
    name = "\228\187\147\229\186\147",
    desc = "",
    prefab = "RepositoryView",
    class = "RepositoryView"
  },
  HappyShop = {
    id = 151,
    tab = nil,
    name = "\228\185\144\229\155\173\229\155\162\229\149\134\229\186\151",
    desc = "",
    prefab = "HappyShop",
    class = "HappyShop"
  },
  WorldMapView = {
    id = 161,
    tab = nil,
    name = "\228\184\150\231\149\140\229\156\176\229\155\190",
    desc = "",
    prefab = "WorldMapView",
    class = "WorldMapView"
  },
  LowBloodBlinkView = {
    id = 134,
    tab = nil,
    name = "\228\189\142\232\161\128\230\179\155\231\186\162",
    desc = "",
    prefab = "ClickEffectView",
    class = "LowBloodBlinkView"
  },
  FloatAwardView = {
    id = 135,
    tab = nil,
    name = "\229\165\150\229\138\177",
    desc = "",
    prefab = "FloatAwardView",
    class = "FloatAwardView"
  },
  ShareAwardView = {
    id = 136,
    tab = nil,
    name = "\229\136\134\228\186\171",
    desc = "",
    prefab = "ShareAwardView",
    class = "ShareAwardView"
  },
  QuestPanel = {
    id = 137,
    tab = nil,
    name = "\228\187\187\229\138\161\233\157\162\230\157\191",
    desc = "",
    prefab = "QuestPanel",
    class = "QuestPanel"
  },
  RaidInfoPopUp = {
    id = 140,
    tab = nil,
    name = "\229\137\175\230\156\172\228\191\161\230\129\175",
    desc = "",
    prefab = "RaidInfoPopUp",
    class = "RaidInfoPopUp",
    hideCollider = true
  },
  ChatRoomPage = {
    id = 181,
    tab = nil,
    name = "\232\129\138\229\164\169\229\174\164",
    desc = "",
    prefab = "ChatRoom",
    class = "ChatRoomPage",
    hideCollider = false
  },
  ChatBarrageView = {
    id = 182,
    tab = nil,
    name = "\232\129\138\229\164\169\229\188\185\229\185\149",
    desc = "",
    prefab = "ChatBarrageView",
    class = "ChatBarrageView"
  },
  ChatEmojiView = {
    id = 191,
    tab = nil,
    name = "\232\161\168\230\131\133",
    desc = "",
    prefab = "UIEmojiView",
    class = "UIEmojiView",
    hideCollider = false
  },
  AnnounceQuestPanel = {
    id = 201,
    tab = nil,
    name = "\229\133\172\229\145\138\228\187\187\229\138\161\231\137\136",
    desc = "",
    prefab = "AnnounceQuestPanel",
    class = "AnnounceQuestPanel",
    hideCollider = false
  },
  AnnounceQuestActivityPanel = {
    id = 202,
    tab = nil,
    name = "\229\133\172\229\145\138\228\187\187\229\138\161\230\180\187\229\138\168\231\137\136",
    desc = "",
    prefab = "AnnounceQuestActivityPanel",
    class = "AnnounceQuestPanel",
    hideCollider = false
  },
  SoundBoxView = {
    id = 211,
    tab = nil,
    name = "\233\159\179\228\185\144\231\155\146\230\146\173\230\148\190\229\136\151\232\161\168",
    desc = "",
    prefab = "SoundBoxView",
    class = "SoundBoxView",
    hideCollider = false
  },
  SoundItemChoosePopUp = {
    id = 212,
    tab = nil,
    name = "\233\159\179\228\185\144\231\155\146\233\129\147\229\133\183\229\136\151\232\161\168",
    desc = "",
    prefab = "SoundItemChoosePopUp",
    class = "SoundItemChoosePopUp",
    hideCollider = false
  },
  ClickEffectView = {
    id = 310,
    tab = nil,
    name = "\229\133\168\229\177\143\231\130\185\229\135\187",
    desc = "",
    prefab = "ClickEffectView",
    class = "ClickEffectView",
    hideCollider = true
  },
  CreateChatRoom = {
    id = 320,
    tab = nil,
    name = "\232\129\138\229\164\169\229\174\164",
    desc = "",
    prefab = "CreateChatRoom",
    class = "CreateChatRoom",
    hideCollider = false
  },
  EndlessTower = {
    id = 330,
    tab = nil,
    name = "\230\151\160\229\176\189\228\185\139\229\161\148",
    desc = "",
    prefab = "EndlessTower",
    class = "EndlessTower",
    hideCollider = false
  },
  EndlessTowerWaitView = {
    id = 331,
    tab = nil,
    name = "\230\151\160\229\176\189\228\185\139\229\161\148\231\173\137\229\190\133\233\152\159\229\143\139",
    desc = "",
    prefab = "EndlessTowerWaitView",
    class = "EndlessTowerWaitView"
  },
  TeamMemberListPopUp = {
    id = 351,
    tab = nil,
    name = "\233\152\159\228\188\141\228\191\161\230\129\175",
    desc = "",
    prefab = "TeamMemberListPopUp",
    class = "TeamMemberListPopUp",
    hideCollider = false
  },
  TeamFindPopUp = {
    id = 352,
    tab = nil,
    name = "\230\159\165\230\137\190\233\152\159\228\188\141",
    desc = "",
    prefab = "TeamFindPopUp",
    class = "TeamFindPopUp",
    hideCollider = false
  },
  TeamApplyListPopUp = {
    id = 353,
    tab = nil,
    name = "\231\148\179\232\175\183\229\136\151\232\161\168",
    desc = "",
    prefab = "TeamApplyListPopUp",
    class = "TeamApplyListPopUp",
    hideCollider = false
  },
  TeamInvitePopUp = {
    id = 354,
    tab = nil,
    name = "\233\130\128\232\175\183\233\152\159\229\145\152",
    desc = "",
    prefab = "TeamInvitePopUp",
    class = "TeamInvitePopUp",
    hideCollider = false
  },
  TeamOptionPopUp = {
    id = 355,
    tab = nil,
    name = "\233\152\159\228\188\141\232\174\190\231\189\174",
    desc = "",
    prefab = "TeamOptionPopUp",
    class = "TeamOptionPopUp",
    hideCollider = false
  },
  PostView = {
    id = 370,
    tab = nil,
    name = "\233\130\174\228\187\182",
    desc = "",
    prefab = "PostView",
    class = "PostView",
    hideCollider = false
  },
  XOView = {
    id = 380,
    tab = nil,
    name = "\233\151\174\231\173\148\231\179\187\231\187\159",
    desc = "",
    prefab = "XOView",
    class = "XOView",
    hideCollider = false
  },
  AdventurePanel = {
    id = 400,
    tab = nil,
    name = "\229\134\146\233\153\169\230\151\165\229\191\151",
    desc = "",
    prefab = "AdventurePanel",
    class = "AdventurePanel"
  },
  AdventureRewardPanel = {
    id = 401,
    tab = nil,
    name = "\229\134\146\233\153\169\229\165\150\229\138\177",
    desc = "",
    prefab = "AdventureRewardPanel",
    class = "AdventureRewardPanel"
  },
  ScenerytDetailPanel = {
    id = 402,
    tab = nil,
    name = "\230\153\175\231\130\185\232\175\166\230\131\133",
    desc = "",
    prefab = "ScenerytDetailPanel",
    class = "ScenerytDetailPanel"
  },
  MonthCardDetailPanel = {
    id = 403,
    tab = nil,
    name = "\230\156\136\229\141\161\232\175\166\230\131\133",
    desc = "",
    prefab = "MonthCardDetailPanel",
    class = "MonthCardDetailPanel"
  },
  EpCardDetailPanel = {
    id = 404,
    tab = nil,
    name = "Ep\232\175\166\230\131\133",
    desc = "",
    prefab = "EpCardDetailPanel",
    class = "EpCardDetailPanel"
  },
  AdventureZoneRewardPopUp = {
    id = 405,
    tab = nil,
    name = "\229\134\146\233\153\169\230\137\139\229\134\140\229\140\186\229\159\159\229\165\150\229\138\177",
    desc = "",
    prefab = "AdventureZoneRewardPopUp",
    class = "AdventureZoneRewardPopUp",
    hideCollider = true
  },
  ShopSale = {
    id = 410,
    tab = nil,
    name = "\229\149\134\229\186\151\229\135\186\229\148\174",
    desc = "",
    prefab = "ShopSale",
    class = "ShopSale"
  },
  ChangeJobView = {
    id = 420,
    tab = nil,
    name = "\232\189\172\232\129\140\233\149\191\229\187\138\231\149\140\233\157\162",
    desc = "",
    prefab = "ChangeJobView",
    class = "ChangeJobView"
  },
  GuidePanel = {
    id = 430,
    tab = nil,
    name = "\229\188\149\229\175\188\230\143\144\231\164\186\231\161\174\232\174\164",
    desc = "",
    prefab = "GuidePanel",
    class = "GuidePanel"
  },
  GuideMaskView = {
    id = 440,
    tab = nil,
    name = "\229\188\149\229\175\188",
    desc = "",
    prefab = "GuideMaskView",
    class = "GuideMaskView"
  },
  UIMapAreaList = {
    id = 450,
    tab = nil,
    name = "\229\140\186\229\159\159\231\149\140\233\157\162",
    desc = "",
    prefab = "UIMapAreaList",
    class = "UIMapAreaList"
  },
  UIMapMapList = {
    id = 460,
    tab = nil,
    name = "\229\156\176\229\155\190\231\149\140\233\157\162",
    desc = "",
    prefab = "UIMapAreaList",
    class = "UIMapMapList"
  },
  LoadingViewDefault = {
    id = 470,
    tab = 1,
    name = "\233\187\152\232\174\164\229\138\160\232\189\189\231\149\140\233\157\162",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewIllustration = {
    id = 471,
    tab = 2,
    name = "\230\143\146\231\148\187\229\138\160\232\189\189\231\149\140\233\157\162",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewNewExplore = {
    id = 472,
    tab = 3,
    name = "\230\150\176\229\140\186\229\159\159\232\167\163\233\148\129",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  LoadingViewQuickWithoutProgress = {
    id = 473,
    tab = 4,
    name = "\228\187\128\228\185\136\233\131\189\230\178\161\231\154\132\233\187\145\231\149\140\233\157\162",
    desc = "",
    prefab = "Loading/LoadingSceneView",
    class = "LoadingSceneView"
  },
  FriendMainView = {
    id = 480,
    tab = nil,
    name = "\229\165\189\229\143\139\228\184\187\231\149\140\233\157\162",
    desc = "",
    prefab = "FriendMainView",
    class = "FriendMainView"
  },
  AddFriendView = {
    id = 481,
    tab = nil,
    name = "\230\183\187\229\138\160\229\165\189\229\143\139",
    desc = "",
    prefab = "AddFriendView",
    class = "AddFriendView"
  },
  FriendApplyInfoView = {
    id = 482,
    tab = nil,
    name = "\229\165\189\229\143\139\231\148\179\232\175\183\229\136\151\232\161\168",
    desc = "",
    prefab = "FriendApplyInfoView",
    class = "FriendApplyInfoView"
  },
  BlacklistView = {
    id = 483,
    tab = nil,
    name = "\233\187\145\229\144\141\229\141\149",
    desc = "",
    prefab = "BlacklistView",
    class = "BlacklistView"
  },
  FriendView = {
    id = 484,
    tab = 1,
    name = "\229\165\189\229\143\139\231\149\140\233\157\162",
    desc = "",
    prefab = "FriendMainView",
    class = "FriendView"
  },
  TutorView = {
    id = 485,
    tab = 2,
    name = "\229\175\188\229\184\136\231\149\140\233\157\162",
    desc = "",
    prefab = "FriendMainView",
    class = "TutorMainView"
  },
  TutorApplyView = {
    id = 486,
    tab = nil,
    name = "\229\175\188\229\184\136\231\148\179\232\175\183\231\149\140\233\157\162",
    desc = "",
    prefab = "TutorApplyView",
    class = "TutorApplyView"
  },
  TutorTaskView = {
    id = 487,
    tab = nil,
    name = "\229\175\188\229\184\136\228\187\187\229\138\161\231\149\140\233\157\162",
    desc = "",
    prefab = "TutorTaskView",
    class = "TutorTaskView"
  },
  TutorGraduationView = {
    id = 488,
    tab = nil,
    name = "\229\175\188\229\184\136\230\175\149\228\184\154\231\149\140\233\157\162",
    desc = "",
    prefab = "TutorGraduationView",
    class = "TutorGraduationView"
  },
  PicMakeView = {
    id = 490,
    tab = nil,
    name = "\229\155\190\231\186\184\229\136\182\228\189\156\231\149\140\233\157\162",
    desc = "",
    prefab = "PicMakeView",
    class = "PicMakeView"
  },
  PicTipPopUp = {
    id = 495,
    tab = nil,
    name = "\229\155\190\231\186\184\229\136\182\228\189\156\229\188\185\230\161\134",
    desc = "",
    prefab = "PicTipPopUp",
    class = "PicTipPopUp"
  },
  ShopMallMainView = {
    id = 500,
    tab = nil,
    name = "\229\149\134\229\159\142\228\184\187\231\149\140\233\157\162",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ShopMallExchangeBuyInfoView = {
    id = 501,
    tab = nil,
    name = "\229\149\134\229\159\142\228\186\164\230\152\147\230\137\128\232\180\173\228\185\176\232\175\166\230\131\133\231\149\140\233\157\162",
    desc = "",
    prefab = "ShopMallExchangeInfoView",
    class = "ShopMallExchangeBuyInfoView"
  },
  ShopMallExchangeSellInfoView = {
    id = 502,
    tab = nil,
    name = "\229\149\134\229\159\142\228\186\164\230\152\147\230\137\128\229\135\186\229\148\174\232\175\166\230\131\133\231\149\140\233\157\162",
    desc = "",
    prefab = "ShopMallExchangeInfoView",
    class = "ShopMallExchangeSellInfoView"
  },
  ShopMallExchangeSearchView = {
    id = 503,
    tab = nil,
    name = "\229\149\134\229\159\142\228\186\164\230\152\147\230\137\128\230\144\156\231\180\162\231\149\140\233\157\162",
    desc = "",
    prefab = "ShopMallExchangeSearchView",
    class = "ShopMallExchangeSearchView"
  },
  ShopMallExchangeView = {
    id = 504,
    tab = nil,
    name = "\229\149\134\229\159\142\228\186\164\230\152\147\230\137\128",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ShopMallShopView = {
    id = 505,
    tab = nil,
    name = "\229\149\134\229\159\142\229\149\134\229\159\142",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ShopMallRechargeView = {
    id = 506,
    tab = nil,
    name = "\229\149\134\229\159\142\229\133\133\229\128\188",
    desc = "",
    prefab = "ShopMallMainView",
    class = "ShopMallMainView"
  },
  ExchangeExpressView = {
    id = 507,
    tab = nil,
    name = "\228\186\164\230\152\147\230\137\128\232\181\160\233\128\129",
    desc = "",
    prefab = "ExchangeExpressView",
    class = "ExchangeExpressView"
  },
  ExchangeRecordDetailView = {
    id = 508,
    tab = nil,
    name = "\228\186\164\230\152\147\230\137\128\228\186\164\230\152\147\232\174\176\229\189\149\232\175\166\230\131\133",
    desc = "",
    prefab = "ExchangeRecordDetailView",
    class = "ExchangeRecordDetailView"
  },
  ExchangeFriendView = {
    id = 509,
    tab = nil,
    name = "\228\186\164\230\152\147\230\137\128\232\181\160\233\128\129\229\165\189\229\143\139\233\128\137\230\139\169",
    desc = "",
    prefab = "ExchangeFriendView",
    class = "ExchangeFriendView"
  },
  ExchangeSignExpressView = {
    id = 510,
    tab = nil,
    name = "\228\186\164\230\152\147\230\137\128\231\173\190\230\148\182\229\191\171\233\128\146",
    desc = "",
    prefab = "ExchangeSignExpressView",
    class = "ExchangeSignExpressView"
  },
  GuildInfoView = {
    id = 520,
    tab = 1,
    name = "\229\133\172\228\188\154\228\184\187\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildInfoPage = {
    id = 521,
    tab = 1,
    name = "\229\133\172\228\188\154\228\191\161\230\129\175\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildMemberListPage = {
    id = 522,
    tab = 2,
    name = "\229\133\172\228\188\154\233\152\159\229\145\152\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildFaithPage = {
    id = 523,
    tab = 3,
    name = "\229\133\172\228\188\154\228\191\161\228\187\176\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildFindPage = {
    id = 524,
    tab = 4,
    name = "\229\133\172\228\188\154\230\159\165\230\137\190\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GuildAssetPage = {
    id = 525,
    tab = 5,
    name = "\229\133\172\228\188\154\232\181\132\228\186\167\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildInfoView",
    class = "GuildInfoView"
  },
  GLandStatusListView = {
    id = 528,
    tab = 5,
    name = "\229\133\172\228\188\154\230\141\174\231\130\185\231\138\182\230\128\129\231\149\140\233\157\162",
    desc = "",
    prefab = "GLandStatusListView",
    class = "GLandStatusListView"
  },
  CreateGuildPopUp = {
    id = 530,
    tab = nil,
    name = "\229\133\172\228\188\154\229\136\155\229\187\186",
    desc = "",
    prefab = "CreateGuildPopUp",
    class = "CreateGuildPopUp"
  },
  GuildJobEditPopUp = {
    id = 531,
    tab = nil,
    name = "\229\133\172\228\188\154\232\129\140\228\189\141\231\188\150\232\190\145",
    desc = "",
    prefab = "GuildJobEditPopUp",
    class = "GuildJobEditPopUp"
  },
  GuildJobChangePopUp = {
    id = 532,
    tab = nil,
    name = "\229\133\172\228\188\154\232\129\140\228\189\141\229\143\152\230\155\180",
    desc = "",
    prefab = "GuildJobChangePopUp",
    class = "GuildJobChangePopUp"
  },
  GuildApplyListPopUp = {
    id = 533,
    tab = nil,
    name = "\229\133\172\228\188\154\231\148\179\232\175\183\229\136\151\232\161\168",
    desc = "",
    prefab = "GuildApplyListPopUp",
    class = "GuildApplyListPopUp"
  },
  GuildHeadChoosePopUp = {
    id = 534,
    tab = nil,
    name = "\229\133\172\228\188\154\229\164\180\229\131\143\230\155\180\230\141\162\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildHeadChoosePopUp",
    class = "GuildHeadChoosePopUp"
  },
  GuildEventPopUp = {
    id = 535,
    tab = nil,
    name = "\229\133\172\228\188\154\228\186\139\228\187\182\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildEventPopUp",
    class = "GuildEventPopUp"
  },
  GuildTreasurePopUp = {
    id = 536,
    tab = nil,
    name = "\229\133\172\228\188\154\229\174\157\231\174\177\232\180\161\231\140\174\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildTreasurePopUp",
    class = "GuildTreasurePopUp"
  },
  GuildPrayDialog = {
    id = 538,
    tab = nil,
    name = "\229\133\172\228\188\154\231\165\136\231\165\183\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildPrayDialog",
    class = "GuildPrayDialog"
  },
  GuildFindPopUp = {
    id = 540,
    tab = nil,
    name = "\229\138\160\229\133\165\229\133\172\228\188\154",
    desc = "",
    prefab = "GuildFindPopUp",
    class = "GuildFindPopUp"
  },
  GuildDonateView = {
    id = 545,
    tab = nil,
    name = "\229\133\172\228\188\154\232\180\161\231\140\174\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildDonateView",
    class = "GuildDonateView"
  },
  GuildOpenRaidDialog = {
    id = 546,
    tab = nil,
    name = "\229\133\172\228\188\154\230\140\145\230\136\152\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildOpenRaidDialog",
    class = "GuildOpenRaidDialog"
  },
  AstrolabeView = {
    id = 547,
    tab = nil,
    name = "\229\133\172\228\188\154\230\152\159\231\155\152\231\149\140\233\157\162",
    desc = "",
    prefab = "AstrolabeView",
    class = "AstrolabeView"
  },
  GuildChangeNamePopUp = {
    id = 548,
    tab = nil,
    name = "\229\133\172\228\188\154\230\155\180\229\144\141",
    desc = "",
    prefab = "GuildChangeNamePopUp",
    class = "GuildChangeNamePopUp"
  },
  GuildChallengeTaskPopUp = {
    id = 549,
    tab = nil,
    name = "\229\133\172\228\188\154\230\140\145\230\136\152\228\187\187\229\138\161",
    desc = "",
    prefab = "GuildChallengeTaskPopUp",
    class = "GuildChallengeTaskPopUp"
  },
  AdventureAppendRewardPanel = {
    id = 550,
    tab = nil,
    name = "\229\134\146\233\153\169\230\137\139\229\134\140\232\191\189\229\138\160",
    desc = "",
    prefab = "AdventureAppendRewardPanel",
    class = "AdventureAppendRewardPanel"
  },
  SpeechRecognizerView = {
    id = 560,
    tab = nil,
    name = "\232\175\173\233\159\179\229\188\185\229\135\186\229\176\143\232\175\157\231\173\146",
    desc = "",
    prefab = "SpeechRecognizerView",
    class = "SpeechRecognizerView"
  },
  DojoGroupView = {
    id = 570,
    tab = nil,
    name = "\233\128\137\230\139\169\233\129\147\229\156\186",
    desc = "",
    prefab = "DojoGroupView",
    class = "DojoGroupView"
  },
  DojoMainView = {
    id = 571,
    tab = nil,
    name = "\230\140\145\230\136\152\233\129\147\229\156\186",
    desc = "",
    prefab = "DojoMainView",
    class = "DojoMainView"
  },
  DojoWaitView = {
    id = 572,
    tab = nil,
    name = "\233\129\147\229\156\186\231\173\137\229\190\133\233\152\159\229\143\139",
    desc = "",
    prefab = "DojoWaitView",
    class = "DojoWaitView"
  },
  DungeonCountDownView = {
    id = 573,
    tab = nil,
    name = "\232\191\155\229\133\165\229\137\175\230\156\172\229\128\146\232\174\161\230\151\182",
    desc = "",
    prefab = "DungeonCountDownView",
    class = "DungeonCountDownView"
  },
  DojoResultPopUp = {
    id = 574,
    tab = nil,
    name = "\233\129\147\229\156\186\232\131\156\229\136\169\229\165\150\229\138\177",
    desc = "",
    prefab = "DojoResultPopUp",
    class = "DojoResultPopUp"
  },
  CountDownView = {
    id = 580,
    tab = nil,
    name = "\229\137\175\230\156\172\229\128\146\232\174\161\230\151\182",
    desc = "",
    prefab = "CountDownView",
    class = "CountDownView"
  },
  SealTaskPopUp = {
    id = 590,
    tab = nil,
    name = "\229\176\129\229\141\176\230\142\165\229\143\150\233\157\162\230\157\191",
    desc = "",
    prefab = "SealTaskPopUp",
    class = "SealTaskPopUp"
  },
  RepairSealConfirmPopUp = {
    id = 595,
    tab = nil,
    name = "\229\176\129\229\141\176\229\188\128\229\167\139\233\157\162\230\157\191",
    desc = "",
    prefab = "RepairSealConfirmPopUp",
    class = "RepairSealConfirmPopUp",
    hideCollider = true
  },
  MediaPanel = {
    id = 600,
    tab = nil,
    name = "\230\146\173\230\148\190\232\167\134\233\162\145",
    desc = "",
    prefab = "MediaPanel",
    class = "MediaPanel"
  },
  InstituteResultPopUp = {
    id = 610,
    tab = nil,
    name = "\231\160\148\231\169\182\230\137\128\231\187\147\231\174\151\233\157\162\230\157\191",
    desc = "",
    prefab = "InstituteResultPopUp",
    class = "InstituteResultPopUp"
  },
  AdventureSkill = {
    id = 620,
    name = "\229\134\146\233\153\169\230\138\128\232\131\189",
    prefab = "UIViewAdventureSkill",
    class = "UIViewControllerAdventureSkill"
  },
  SetView = {
    id = 630,
    name = "\232\174\190\231\189\174",
    prefab = "SetView",
    class = "SetView",
    hideCollider = true
  },
  SystemSettingPage = {
    id = 631,
    tab = 1,
    name = "\231\179\187\231\187\159\232\174\190\231\189\174",
    desc = "",
    prefab = "",
    class = ""
  },
  EffectSettingPage = {
    id = 632,
    tab = 2,
    name = "\231\137\185\230\149\136\232\174\190\231\189\174",
    desc = "",
    prefab = "",
    class = ""
  },
  MsgPushSettingPage = {
    id = 633,
    tab = 3,
    name = "\230\142\168\233\128\129\232\174\190\231\189\174",
    desc = "",
    prefab = "",
    class = ""
  },
  SecuritySettingPage = {
    id = 634,
    tab = 4,
    name = "\229\174\137\229\133\168\232\174\190\231\189\174",
    desc = "",
    prefab = "",
    class = ""
  },
  NoticeMsgView = {
    id = 640,
    name = "\229\133\172\229\145\138",
    prefab = "NoticeMsgView",
    class = "NoticeMsgView"
  },
  PlayerDetailView = {
    id = 650,
    tab = nil,
    name = "\231\142\169\229\174\182\232\175\166\231\187\134\228\191\161\230\129\175\231\149\140\233\157\162",
    desc = "",
    prefab = "PlayerDetailView",
    class = "PlayerDetailView",
    hideCollider = true
  },
  EDView = {
    id = 660,
    tab = nil,
    name = "EDUI\231\149\140\233\157\162",
    desc = "",
    prefab = "EDView",
    class = "EDView",
    hideCollider = true
  },
  EDView2 = {
    id = 661,
    tab = nil,
    name = "EDUI2\231\149\140\233\157\162",
    desc = "",
    prefab = "EDView2",
    class = "EDView2",
    hideCollider = true
  },
  SkyWheelAcceptView = {
    id = 670,
    tab = nil,
    name = "\230\145\169\229\164\169\232\189\174\230\142\165\229\143\151",
    desc = "",
    prefab = "SkyWheelAcceptView",
    class = "SkyWheelAcceptView"
  },
  SkyWheelSearchView = {
    id = 671,
    tab = nil,
    name = "\230\145\169\229\164\169\232\189\174\230\144\156\231\180\162",
    desc = "",
    prefab = "SkyWheelSearchView",
    class = "SkyWheelSearchView"
  },
  SkyWheelFriendView = {
    id = 672,
    tab = nil,
    name = "\230\145\169\229\164\169\232\189\174\229\165\189\229\143\139",
    desc = "",
    prefab = "SkyWheelFriendView",
    class = "SkyWheelFriendView"
  },
  EquipMakeView = {
    id = 680,
    tab = nil,
    name = "\232\163\133\229\164\135\229\136\182\228\189\156",
    desc = "",
    prefab = "EquipMakeView",
    class = "EquipMakeView"
  },
  EquipRecoverView = {
    id = 681,
    tab = nil,
    name = "\232\163\133\229\164\135\231\134\148\231\130\137",
    desc = "",
    prefab = "EquipRecoverView",
    class = "EquipRecoverView"
  },
  EquipAlchemyView = {
    id = 685,
    tab = nil,
    name = "\232\163\133\229\164\135\231\130\188\233\135\145",
    desc = "",
    prefab = "EquipAlchemyView",
    class = "EquipAlchemyView"
  },
  ChangeZoneView = {
    id = 690,
    tab = nil,
    name = "\229\136\135\230\141\162\229\188\130\230\172\161\229\133\131",
    desc = "",
    prefab = "ChangeZoneView",
    class = "ChangeZoneView"
  },
  GiftActivePanel = {
    id = 700,
    tab = nil,
    name = "\231\164\188\229\140\133\231\160\129\229\133\145\230\141\162",
    desc = "",
    prefab = "GiftActivePanel",
    class = "GiftActivePanel"
  },
  ChangeHeadView = {
    id = 710,
    tab = nil,
    name = "\230\155\180\230\141\162\229\164\180\229\131\143",
    desc = "",
    prefab = "ChangeHeadView",
    class = "ChangeHeadView"
  },
  ZenyShop = {
    id = 720,
    tab = 1,
    name = "Zeny\229\149\134\229\159\142",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  ZenyShopMonthlyVIP = {
    id = 721,
    tab = 2,
    name = "\230\156\136\229\141\161\232\180\173\228\185\176",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  ZenyShopGachaCoin = {
    id = 722,
    tab = 3,
    name = "\230\137\173\232\155\139\229\184\129\232\180\173\228\185\176",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  ZenyShopItem = {
    id = 723,
    tab = 4,
    name = "\233\129\147\229\133\183\232\180\173\228\185\176",
    desc = "",
    prefab = "UIViewZenyShop",
    class = "UIViewControllerZenyShop"
  },
  AppStorePurchase = {
    id = 724,
    tab = nil,
    name = "",
    desc = "",
    prefab = "UIViewAppStorePurchase",
    class = "UVC_AppStorePurchase"
  },
  ChangeNameView = {
    id = 730,
    tab = nil,
    name = "\230\155\180\230\141\162\232\167\146\232\137\178\229\144\141\231\167\176",
    desc = "",
    prefab = "ChangeNameView",
    class = "ChangeNameView"
  },
  RoleChangeNamePopUp = {
    id = 731,
    tab = nil,
    name = "\230\155\180\230\141\162\232\167\146\232\137\178\229\144\141\231\167\176",
    desc = "",
    prefab = "RoleChangeNamePopUp",
    class = "RoleChangeNamePopUp"
  },
  ShortCutOptionPopUp = {
    id = 740,
    tab = nil,
    name = "\232\191\189\232\184\170\233\128\137\230\139\169\231\149\140\233\157\162",
    desc = "",
    prefab = "ShortCutOptionPopUp",
    class = "ShortCutOptionPopUp"
  },
  AuguryView = {
    id = 750,
    tab = nil,
    name = "\229\141\160\229\141\156",
    desc = "",
    prefab = "AuguryView",
    class = "AuguryView"
  },
  ValentineView = {
    id = 760,
    tab = nil,
    name = "\231\153\189\232\137\178\230\131\133\228\186\186\232\138\130\230\131\133\228\185\166",
    desc = "",
    prefab = "ValentineView",
    class = "ValentineView"
  },
  StarView = {
    id = 761,
    tab = nil,
    name = "\230\152\159\229\186\167\231\181\174\232\175\173\230\131\133\228\185\166",
    desc = "",
    prefab = "StarView",
    class = "StarView"
  },
  ChristmasInviteView = {
    id = 762,
    tab = nil,
    name = "\229\156\163\232\175\158\230\131\133\228\185\166\233\130\128\232\175\183",
    desc = "",
    prefab = "ChristmasInviteView",
    class = "ChristmasInviteView"
  },
  ChristmasView = {
    id = 763,
    tab = nil,
    name = "\229\156\163\232\175\158\230\131\133\228\185\166",
    desc = "",
    prefab = "ChristmasView",
    class = "ChristmasView"
  },
  SpringActivityInviteView = {
    id = 764,
    tab = nil,
    name = "\230\152\165\232\138\130\232\180\186\229\141\161\233\130\128\232\175\183",
    desc = "",
    prefab = "SpringActivityInviteView",
    class = "SpringActivityInviteView"
  },
  SpringActivityView = {
    id = 765,
    tab = nil,
    name = "\230\152\165\232\138\130\232\180\186\229\141\161",
    desc = "",
    prefab = "SpringActivityView",
    class = "SpringActivityView"
  },
  LotteryGiftView = {
    id = 766,
    tab = nil,
    name = "\230\137\173\232\155\139\231\165\157\231\166\143",
    desc = "",
    prefab = "LotteryGiftView",
    class = "LotteryGiftView"
  },
  WeddingDressSendView = {
    id = 767,
    tab = nil,
    name = "\229\169\154\231\186\177\232\181\160\233\128\129\232\181\160\233\128\129",
    desc = "",
    prefab = "WeddingDressSendView",
    class = "WeddingDressSendView"
  },
  WeddingDressView = {
    id = 768,
    tab = nil,
    name = "\229\169\154\231\186\177\232\181\160\233\128\129\228\185\166\228\191\161",
    desc = "",
    prefab = "WeddingDressView",
    class = "WeddingDressView"
  },
  VideoPanel = {
    id = 770,
    tab = nil,
    name = "\229\134\146\233\153\169\230\137\139\229\134\140\231\143\141\232\151\143\229\147\129\232\167\134\233\162\145",
    desc = "",
    prefab = "VideoPanel",
    class = "VideoPanel",
    hideCollider = false
  },
  UIVictoryView = {
    id = 780,
    tab = nil,
    name = "\230\137\147\230\150\151\229\156\186\231\187\147\231\174\151\231\149\140\233\157\162",
    desc = "",
    prefab = "UIVictoryView",
    class = "UIVictoryView"
  },
  HairDressingView = {
    id = 790,
    tab = nil,
    name = "\231\144\134\229\143\145\229\186\151\229\149\134\229\159\142",
    desc = "",
    prefab = "HairDressingView",
    class = "HairDressingView"
  },
  HairCutPage = {
    id = 791,
    tab = 1,
    name = "\231\144\134\229\143\145\231\149\140\233\157\162",
    desc = "",
    prefab = "HairCutPage",
    class = "HairCutPage"
  },
  HairDyePage = {
    id = 792,
    tab = 2,
    name = "\230\159\147\229\143\145\231\149\140\233\157\162",
    desc = "",
    prefab = "HairDyePage",
    class = "HairDyePage"
  },
  PlotStoryView = {
    id = 800,
    tab = nil,
    name = "\229\137\167\230\131\133\230\149\133\228\186\139\231\149\140\233\157\162",
    desc = "",
    prefab = "PlotStoryView",
    class = "PlotStoryView"
  },
  HireCatInfoView = {
    id = 810,
    tab = nil,
    name = "\233\155\135\228\189\163\231\140\171\232\175\166\230\131\133",
    desc = "",
    prefab = "HireCatInfoView",
    class = "HireCatInfoView"
  },
  SecretReportPvpPopUp = {
    id = 820,
    tab = nil,
    name = "\229\175\134\231\160\129\230\138\165\229\144\141",
    desc = "",
    prefab = "SecretReportPvpPopUp",
    class = "SecretReportPvpPopUp"
  },
  WeakDialogView = {
    id = 830,
    tab = nil,
    name = "\230\187\145\229\138\168\229\175\185\232\175\157",
    desc = "",
    prefab = "WeakDialogView",
    class = "WeakDialogView",
    hideCollider = true
  },
  HandUpView = {
    id = 900,
    tab = nil,
    name = "\230\140\130\230\156\186\231\149\140\233\157\162",
    desc = "",
    prefab = "HandUpView",
    class = "HandUpView"
  },
  PopUpItemView = {
    id = 910,
    tab = nil,
    name = "\233\129\147\229\133\183\232\142\183\229\190\151\229\188\185\230\161\134",
    desc = "",
    prefab = "PopUpItemView",
    class = "PopUpItemView",
    hideCollider = false
  },
  PvpMainView = {
    id = 920,
    tab = nil,
    name = "\230\137\147\230\150\151\229\156\186",
    desc = "",
    prefab = "PvpMainView",
    class = "PvpMainView"
  },
  YoyoViewPage = {
    id = 921,
    tab = 1,
    name = "\230\186\156\230\186\156\231\140\180\230\137\147\230\150\151\229\156\186",
    desc = "",
    prefab = "YoyoViewPage",
    class = "YoyoViewPage"
  },
  DesertWolfView = {
    id = 922,
    tab = 2,
    name = "\230\178\153\230\188\160\228\185\139\231\139\188\230\150\151\230\138\128\229\156\186",
    desc = "",
    prefab = "DesertWolfView",
    class = "DesertWolfView"
  },
  GorgeousMetalView = {
    id = 923,
    tab = 3,
    name = "\229\141\142\228\184\189\233\135\145\229\177\158\230\138\162\229\164\186\230\136\152",
    desc = "",
    prefab = "GorgeousMetalView",
    class = "GorgeousMetalView"
  },
  DesertWolfJoinView = {
    id = 924,
    tab = nil,
    name = "\230\178\153\230\188\160\228\185\139\231\139\188\230\138\165\229\144\141",
    desc = "",
    prefab = "DesertWolfJoinView",
    class = "DesertWolfJoinView"
  },
  TeamPwsView = {
    id = 925,
    tab = 11,
    name = "\230\142\146\228\189\141\231\171\158\230\138\128\232\181\155",
    desc = "",
    prefab = "TeamPwsView",
    class = "TeamPwsView"
  },
  FreeBattleView = {
    id = 926,
    tab = 12,
    name = "\228\188\145\233\151\178\231\171\158\230\138\128\232\181\155",
    desc = "",
    prefab = "FreeBattleView",
    class = "FreeBattleView"
  },
  ClassicBattleView = {
    id = 927,
    tab = 13,
    name = "\231\187\143\229\133\184\230\168\161\229\188\143\230\136\152\229\156\186",
    desc = "",
    prefab = "ClassicBattleView",
    class = "ClassicBattleView"
  },
  BusinessmanMakeView = {
    id = 930,
    tab = nil,
    name = "\229\149\134\228\186\186\229\136\182\228\189\156",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "BusinessmanMakeView"
  },
  AlchemistMakeView = {
    id = 931,
    tab = nil,
    name = "\231\130\188\233\135\145\229\136\182\228\189\156",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "AlchemistMakeView"
  },
  KnightMakeView = {
    id = 932,
    tab = nil,
    name = "\231\130\188\233\135\145\229\136\182\228\189\156",
    desc = "",
    prefab = "BusinessmanMakeView",
    class = "KnightMakeView"
  },
  MagicStoneRecoverView = {
    id = 940,
    tab = nil,
    name = "\229\141\184\229\141\161\233\173\148\231\159\179",
    desc = "",
    prefab = "MagicStoneRecoverView",
    class = "MagicStoneRecoverView"
  },
  CardRandomMakeView = {
    id = 950,
    tab = nil,
    name = "\229\141\161\231\137\135\229\134\141\231\148\159\230\156\186\230\138\189\229\141\161",
    desc = "",
    prefab = "CardRandomMakeView",
    class = "CardRandomMakeView"
  },
  CardMakeView = {
    id = 960,
    tab = nil,
    name = "\229\141\161\231\137\135\229\134\141\231\148\159\230\156\186\229\144\136\230\136\144",
    desc = "",
    prefab = "CardMakeView",
    class = "CardMakeView"
  },
  GeneralShareView = {
    id = 970,
    tab = nil,
    name = "\229\136\134\228\186\171\233\128\154\231\148\168\231\149\140\233\157\162",
    desc = "",
    prefab = "GeneralShareView",
    class = "GeneralShareView"
  },
  FoodMakeView = {
    id = 980,
    tab = nil,
    name = "\230\150\153\231\144\134\229\136\182\228\189\156\231\149\140\233\157\162",
    desc = "",
    prefab = "FoodMakeView",
    class = "FoodMakeView"
  },
  FoodGetPopUp = {
    id = 985,
    tab = nil,
    name = "\230\150\153\231\144\134\232\142\183\229\190\151\231\149\140\233\157\162",
    desc = "",
    prefab = "FoodGetPopUp",
    class = "FoodGetPopUp",
    hideCollider = true
  },
  EatFoodPopUp = {
    id = 986,
    tab = nil,
    name = "\229\144\131\230\150\153\231\144\134\231\149\140\233\157\162",
    desc = "",
    prefab = "EatFoodPopUp",
    class = "EatFoodPopUp",
    hideCollider = true
  },
  LotteryHeadwearView = {
    id = 990,
    tab = nil,
    name = "\230\137\173\232\155\139\229\164\180\233\165\176",
    desc = "",
    prefab = "LotteryHeadwearView",
    class = "LotteryHeadwearView"
  },
  LotteryEquipView = {
    id = 991,
    tab = nil,
    name = "\230\137\173\232\155\139\232\163\133\229\164\135",
    desc = "",
    prefab = "LotteryEquipView",
    class = "LotteryEquipView"
  },
  LotteryCardView = {
    id = 992,
    tab = nil,
    name = "\230\137\173\232\155\139\229\141\161\231\137\135",
    desc = "",
    prefab = "LotteryCardView",
    class = "LotteryCardView"
  },
  LotteryCatLitterBoxView = {
    id = 993,
    tab = nil,
    name = "\231\166\143\229\136\169\231\140\171\231\160\130\231\155\134",
    desc = "",
    prefab = "LotteryCatLitterBoxView",
    class = "LotteryCatLitterBoxView"
  },
  LotteryMagicView = {
    id = 994,
    tab = nil,
    name = "\230\137\173\232\155\139\233\173\148\229\138\155",
    desc = "",
    prefab = "LotteryMagicView",
    class = "LotteryMagicView"
  },
  LotteryExpressView = {
    id = 995,
    tab = nil,
    name = "\230\137\173\232\155\139\232\181\160\233\128\129",
    desc = "",
    prefab = "LotteryExpressView",
    class = "LotteryExpressView",
    hideCollider = false
  },
  LotteryMagicSecView = {
    id = 996,
    tab = nil,
    name = "\230\137\173\232\155\139\233\173\148\229\138\1552",
    desc = "",
    prefab = "LotteryMagicView",
    class = "LotteryMagicSecView"
  },
  LotteryResultView = {
    id = 997,
    tab = nil,
    name = "\230\137\173\232\155\139\229\141\129\232\191\158\230\138\189\231\187\147\231\174\151",
    desc = "",
    prefab = "LotteryResultView",
    class = "LotteryResultView"
  },
  PocketLotteryView = {
    id = 999,
    tab = nil,
    name = "\233\154\143\232\186\171\230\137\173\232\155\139",
    desc = "",
    prefab = "PocketLotteryView",
    class = "PocketLotteryView"
  },
  AuctionView = {
    id = 1000,
    tab = nil,
    name = "\230\139\141\229\141\150",
    desc = "",
    prefab = "AuctionView",
    class = "AuctionView"
  },
  AuctionSignUpView = {
    id = 1001,
    tab = nil,
    name = "\230\139\141\229\141\150\230\138\165\229\144\141",
    desc = "",
    prefab = "AuctionSignUpView",
    class = "AuctionSignUpView"
  },
  AuctionSignUpDetailView = {
    id = 1002,
    tab = nil,
    name = "\230\139\141\229\141\150\230\138\165\229\144\141\232\175\166\230\131\133",
    desc = "",
    prefab = "AuctionSignUpDetailView",
    class = "AuctionSignUpDetailView"
  },
  AuctionRecordView = {
    id = 1003,
    tab = nil,
    name = "\230\139\141\229\141\150\230\151\165\229\191\151",
    desc = "",
    prefab = "AuctionRecordView",
    class = "AuctionRecordView"
  },
  AuctionSignUpSelectView = {
    id = 1004,
    tab = nil,
    name = "\230\139\141\229\141\150\230\138\165\229\144\141\233\128\137\230\139\169",
    desc = "",
    prefab = "AuctionSignUpSelectView",
    class = "AuctionSignUpSelectView"
  },
  SlotMachineView = {
    id = 1010,
    tab = nil,
    name = "\230\139\137\233\156\184\230\156\186",
    desc = "",
    prefab = "SlotMachineView",
    class = "SlotMachineView"
  },
  PetCatchSuccessView = {
    id = 1011,
    tab = nil,
    name = "\229\174\160\231\137\169\230\141\149\232\142\183\230\136\144\229\138\159\231\149\140\233\157\162",
    desc = "",
    prefab = "PetCatchSuccessView",
    class = "PetCatchSuccessView"
  },
  PetMakeNamePopUp = {
    id = 1012,
    tab = nil,
    name = "\229\174\160\231\137\169\229\143\150\229\144\141\231\149\140\233\157\162",
    desc = "",
    prefab = "PetMakeNamePopUp",
    class = "PetMakeNamePopUp"
  },
  PetInfoView = {
    id = 1020,
    tab = nil,
    name = "\229\174\160\231\137\169\232\175\166\230\131\133\231\149\140\233\157\162",
    desc = "",
    prefab = "PetInfoView",
    class = "PetInfoView"
  },
  PetAdventureView = {
    id = 1030,
    tab = nil,
    name = "\229\174\160\231\137\169\229\134\146\233\153\169\231\149\140\233\157\162",
    desc = "",
    prefab = "PetAdventureView",
    class = "PetAdventureView"
  },
  EyeLensesView = {
    id = 1040,
    tab = nil,
    name = "\231\190\142\231\158\179\229\149\134\229\186\151",
    desc = "",
    prefab = "EyeLensesView",
    class = "EyeLensesView"
  },
  ClothDressingView = {
    id = 1041,
    tab = nil,
    name = "\230\156\141\232\163\133\229\186\151",
    desc = "",
    prefab = "ClothDressingView",
    class = "ClothDressingView"
  },
  GvgLandInfoPopUp = {
    id = 1050,
    tab = nil,
    name = "\229\133\172\228\188\154\230\136\152\228\186\137",
    desc = "",
    prefab = "GvgLandInfoPopUp",
    class = "GvgLandInfoPopUp"
  },
  UniqueConfirmView_GvgLandGiveUp = {
    id = 1055,
    tab = nil,
    name = "\229\133\172\228\188\154\230\141\174\231\130\185\230\148\190\229\188\131\231\161\174\232\174\164\230\161\134",
    desc = "",
    prefab = "UniqueConfirmView",
    class = "UniqueConfirmView_GvgLandGiveUp"
  },
  QuotaCardView = {
    id = 1060,
    tab = nil,
    name = "\231\140\171\233\135\145\230\137\147\232\181\143\231\167\175\229\136\134\229\141\161",
    desc = "",
    prefab = "QuotaCardView",
    class = "QuotaCardView"
  },
  QuickBuyView = {
    id = 1070,
    tab = nil,
    name = "\229\191\171\233\128\159\232\180\173\228\185\176",
    desc = "",
    prefab = "QuickBuyView",
    class = "QuickBuyView"
  },
  BeingInfoView = {
    id = 1080,
    tab = nil,
    name = "\229\191\171\233\128\159\232\180\173\228\185\176",
    desc = "",
    prefab = "BeingInfoView",
    class = "BeingInfoView"
  },
  GvGPvPPrayDialog = {
    id = 1090,
    tab = nil,
    name = "\229\183\165\228\188\154\231\165\136\231\165\1832.0",
    desc = "",
    prefab = "GvGPvPPrayDialog",
    class = "GvGPvPPrayDialog"
  },
  PoringFightResultView = {
    id = 1100,
    tab = nil,
    name = "\230\179\162\229\136\169\229\164\167\228\185\177\230\150\151\231\187\147\231\174\151\231\149\140\233\157\162",
    desc = "",
    prefab = "PoringFightResultView",
    class = "PoringFightResultView"
  },
  FaceBookFavPanel = {
    id = 100001,
    tab = nil,
    name = "\231\130\185\232\181\158\231\164\188\231\155\146",
    desc = "",
    prefab = "FaceBookFavPanel",
    class = "FaceBookFavPanel"
  },
  LinePanel = {
    id = 100002,
    tab = nil,
    name = "Line",
    desc = ""
  },
  TXWYPlatPanel = {
    id = 100003,
    tab = nil,
    name = "TXWYPlat",
    desc = "",
    prefab = "TXWYPlatPanel",
    class = "TXWYPlatPanel",
    hideCollider = true
  },
  ServiceSettingPage = {
    id = 100004,
    tab = 5,
    name = "\229\174\162\230\156\141\232\174\190\231\189\174",
    desc = "",
    prefab = "",
    class = ""
  },
  ShopConfirmPanel = {
    id = 100006,
    tab = nil,
    name = "ShopConfirmPanel",
    desc = "",
    prefab = "ShopConfirmPanel",
    class = "ShopConfirmPanel"
  },
  ZenyConvertPanel = {
    id = 100005,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6300",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  ZenyConvertPanel1 = {
    id = 100007,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6301",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  ZenyConvertPanel2 = {
    id = 100008,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6302",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  ZenyConvertPanel3 = {
    id = 100009,
    tab = nil,
    name = "ZenyConvertPanel",
    desc = "6303",
    prefab = "ZenyConvertPanel",
    class = "ZenyConvertPanel"
  },
  StorePayPanel = {
    id = 100999,
    tab = nil,
    name = "StorePayPanel",
    desc = "",
    prefab = "StorePayPanel",
    class = "StorePayPanel"
  },
  CreateTipPanel = {
    id = 100010,
    tab = nil,
    name = "CreateTipPanel",
    desc = "",
    prefab = "CreateTipPanel",
    class = "CreateTipPanel",
    hideCollider = true
  },
  ChargeLimitPanel = {
    id = 100011,
    tab = nil,
    name = "ChargeLimitPanel",
    desc = "",
    prefab = "ChargeLimitPanel",
    class = "ChargeLimitPanel"
  },
  ChargeComfirmPanel = {
    id = 100012,
    tab = nil,
    name = "ChargeComfirmPanel",
    desc = "",
    prefab = "ChargeComfirmPanel",
    class = "ChargeComfirmPanel"
  },
  LotteryCoinInfo = {
    id = 100013,
    tab = nil,
    name = "LotteryCoinInfo",
    desc = "",
    prefab = "LotteryCoinInfo",
    class = "LotteryCoinInfo",
    hideCollider = true
  },
  QualitySelect = {
    id = 100014,
    tab = nil,
    name = "QualitySelect",
    desc = "",
    prefab = "QualitySelect",
    class = "QualitySelect"
  },
  RecallShareView = {
    id = 1110,
    tab = nil,
    name = "\229\165\189\229\143\139\229\143\172\229\155\158\229\136\134\228\186\171",
    desc = "",
    prefab = "RecallShareView",
    class = "RecallShareView"
  },
  RecallContractSelectView = {
    id = 1111,
    tab = nil,
    name = "\229\143\172\229\155\158\229\165\145\231\186\166\233\128\137\230\139\169\231\149\140\233\157\162",
    desc = "",
    prefab = "RecallContractSelectView",
    class = "RecallContractSelectView"
  },
  RecallView = {
    id = 1112,
    tab = nil,
    name = "\229\143\172\229\155\158\229\165\189\229\143\139",
    desc = "",
    prefab = "RecallView",
    class = "RecallView"
  },
  RecallContractView = {
    id = 1113,
    tab = nil,
    name = "\229\143\172\229\155\158\229\165\145\231\186\166",
    desc = "",
    prefab = "RecallContractView",
    class = "RecallContractView"
  },
  EquipUpgradePopUp = {
    id = 1120,
    tab = nil,
    name = "\232\163\133\229\164\135\229\141\135\231\186\167",
    desc = "",
    prefab = "EquipUpgradePopUp",
    class = "EquipUpgradePopUp"
  },
  PoringFightTipView = {
    id = 1130,
    tab = nil,
    name = "\230\179\162\229\136\169\228\185\177\230\150\151Tip",
    desc = "",
    prefab = "PoringFightTipView",
    class = "PoringFightTipView",
    hideCollider = true
  },
  GuildBuildingView = {
    id = 1480,
    tab = nil,
    name = "\229\133\172\228\188\154\232\174\190\230\150\189",
    desc = "",
    prefab = "GuildBuildingView",
    class = "GuildBuildingView"
  },
  GuildBuildingMatSubmitView = {
    id = 1490,
    tab = nil,
    name = "\229\133\172\228\188\154\232\174\190\230\150\189\230\143\144\228\186\164\230\157\144\230\150\153",
    desc = "",
    prefab = "GuildBuildingMatSubmitView",
    class = "GuildBuildingMatSubmitView"
  },
  GuildBuildingRankPopUp = {
    id = 1491,
    tab = nil,
    name = "\229\133\172\228\188\154\232\174\190\230\150\189\232\180\161\231\140\174\230\142\146\232\161\140\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildBuildingRankPopUp",
    class = "GuildBuildingRankPopUp",
    hideCollider = true
  },
  RedeemCodeView = {
    id = 1500,
    tab = nil,
    name = "\231\186\191\228\184\139\229\133\145\230\141\162",
    desc = "",
    prefab = "RedeemCodeView",
    class = "RedeemCodeView"
  },
  ArtifactMakeView = {
    id = 1510,
    tab = nil,
    name = "\229\136\182\228\189\156\231\165\158\229\153\168",
    desc = "",
    prefab = "ArtifactMakeView",
    class = "ArtifactMakeView"
  },
  ReturnArtifactView = {
    id = 1520,
    tab = nil,
    name = "\232\191\148\232\191\152\231\165\158\229\153\168",
    desc = "",
    prefab = "ReturnArtifactView",
    class = "ReturnArtifactView"
  },
  ArtifactDistributePopUp = {
    id = 1525,
    tab = nil,
    name = "\233\128\137\230\139\169\229\136\134\233\133\141\231\165\158\229\153\168",
    desc = "",
    prefab = "ArtifactDistributePopUp",
    class = "ArtifactDistributePopUp",
    hideCollider = true
  },
  RealNameCentifyView = {
    id = 1530,
    tab = nil,
    name = "\229\174\158\229\144\141\232\174\164\232\175\129",
    desc = "",
    prefab = "RealNameCentifyView",
    class = "RealNameCentifyView",
    hideCollider = true
  },
  EngageMainView = {
    id = 1540,
    tab = nil,
    name = "\232\174\162\229\169\154",
    desc = "",
    prefab = "EngageMainView",
    class = "EngageMainView"
  },
  WeddingManualMainView = {
    id = 1541,
    tab = nil,
    name = "\231\187\147\229\169\154\230\137\139\229\134\140",
    desc = "",
    prefab = "WeddingManualMainView",
    class = "WeddingManualMainView"
  },
  WeddingProcessView = {
    id = 1542,
    tab = nil,
    name = "\229\169\154\231\164\188\228\187\170\229\188\143\232\175\166\230\131\133",
    desc = "",
    prefab = "WeddingProcessView",
    class = "WeddingProcessView"
  },
  WeddingPackageView = {
    id = 1543,
    tab = nil,
    name = "\229\169\154\231\164\188\228\187\170\229\188\143\229\165\151\233\164\144",
    desc = "",
    prefab = "WeddingPackageView",
    class = "WeddingPackageView"
  },
  WeddingRingView = {
    id = 1544,
    tab = nil,
    name = "\229\169\154\231\164\188\230\136\146\230\140\135\229\165\151\233\164\144",
    desc = "",
    prefab = "HappyShop",
    class = "WeddingRingView"
  },
  WeddingInviteView = {
    id = 1545,
    tab = nil,
    name = "\229\169\154\231\164\188\233\130\128\232\175\183",
    desc = "",
    prefab = "WeddingInviteView",
    class = "WeddingInviteView"
  },
  WeddingQuestionView = {
    id = 1546,
    tab = nil,
    name = "\229\169\154\231\164\188\228\187\170\229\188\143\233\151\174\231\173\148",
    desc = "",
    prefab = "WeddingQuestionView",
    class = "WeddingQuestionView"
  },
  SelectFriendView = {
    id = 1547,
    tab = nil,
    name = "\233\128\137\230\139\169\229\165\189\229\143\139",
    desc = "",
    prefab = "SelectFriendView",
    class = "SelectFriendView"
  },
  GuildTreasureView = {
    id = 1550,
    tab = nil,
    name = "\229\133\172\228\188\154\229\174\157\231\174\177",
    desc = "",
    prefab = "GuildTreasureView",
    class = "GuildTreasureView"
  },
  PetWorkSpaceView = {
    id = 1560,
    tab = nil,
    name = "\229\174\160\231\137\169\230\137\147\229\183\165",
    desc = "",
    prefab = "PetWorkSpaceView",
    class = "PetWorkSpaceView"
  },
  OricalCardInfoView = {
    id = 1570,
    tab = nil,
    name = "\231\165\158\232\176\149\231\137\140\229\141\161\231\137\140\233\162\132\232\167\136\231\149\140\233\157\162",
    desc = "",
    prefab = "OricalCardInfoView",
    class = "OricalCardInfoView"
  },
  CardDecomposeView = {
    id = 1580,
    tab = nil,
    name = "\229\141\161\231\137\135\229\136\134\232\167\163",
    desc = "",
    prefab = "CardDecomposeView",
    class = "CardDecomposeView"
  },
  EnchantTransferView = {
    id = 1590,
    tab = nil,
    name = "\233\153\132\233\173\148\232\189\172\231\167\187",
    desc = "",
    prefab = "EnchantTransferView",
    class = "EnchantTransferView",
    hideCollider = false
  },
  RaidEnterWaitView = {
    id = 1600,
    tab = nil,
    name = "\229\137\175\230\156\172\232\191\155\229\133\165\231\173\137\229\190\133\231\149\140\233\157\162",
    desc = "",
    prefab = "EndlessTowerWaitView",
    class = "RaidEnterWaitView"
  },
  GuildTreasureRewardPopUp = {
    id = 1610,
    tab = nil,
    name = "\229\133\172\228\188\154\229\174\157\231\174\177\231\186\162\229\140\133\231\149\140\233\157\162",
    desc = "",
    prefab = "GuildTreasureRewardPopUp",
    class = "GuildTreasureRewardPopUp"
  },
  ServantNewMainView = {
    id = 1620,
    tab = nil,
    name = "\229\165\179\228\187\134",
    desc = "",
    prefab = "ServantNewMainView",
    class = "ServantNewMainView"
  },
  ServantRecommendView = {
    id = 1621,
    tab = 1,
    name = "\228\187\138\230\151\165\230\142\168\232\141\144",
    desc = "",
    prefab = "ServantRecommendView",
    class = "ServantRecommendView"
  },
  FinanceView = {
    id = 1622,
    tab = 2,
    name = "\228\187\138\230\151\165\232\180\162\231\187\143",
    desc = "",
    prefab = "FinanceView",
    class = "FinanceView"
  },
  ServantImproveViewNew = {
    id = 1624,
    tab = 3,
    name = "\230\143\144\229\141\135\232\174\161\229\136\146",
    desc = "",
    prefab = "ServantImproveViewNew",
    class = "ServantImproveViewNew"
  },
  ServantCalendarView = {
    id = 1625,
    tab = 1,
    name = "\230\180\187\229\138\168\230\151\165\229\142\134",
    desc = "",
    prefab = "ServantCalendarView",
    class = "ServantCalendarView"
  },
  ServantActivityInfoView = {
    id = 1626,
    tab = nil,
    name = "\230\151\165\229\142\134\230\180\187\229\138\168\232\175\166\230\131\133",
    desc = "",
    prefab = "ServantActivityInfoView",
    class = "ServantActivityInfoView",
    hideCollider = false
  },
  GVGPortalView = {
    id = 1630,
    tab = nil,
    name = "GVG\229\134\179\230\136\152\228\188\160\233\128\129\233\151\168",
    desc = "",
    prefab = "GVGPortalView",
    class = "GVGPortalView"
  },
  GVGResultView = {
    id = 1631,
    tab = nil,
    name = "GVG\229\134\179\230\136\152\231\187\147\230\158\156",
    desc = "",
    prefab = "GVGResultView",
    class = "GVGResultView"
  },
  GVGDetailView = {
    id = 1632,
    tab = nil,
    name = "GVG\229\134\179\230\136\152\232\175\166\231\187\134\228\191\161\230\129\175",
    desc = "",
    prefab = "GVGDetailView",
    class = "GVGDetailView"
  },
  MVPResultView = {
    id = 1640,
    tab = nil,
    name = "MVP\231\187\147\231\174\151",
    desc = "",
    prefab = "MVPResultView",
    class = "MVPResultView"
  },
  MvpMatchView = {
    id = 1641,
    tab = nil,
    name = "MVP\229\140\185\233\133\141",
    desc = "",
    prefab = "MvpMatchView",
    class = "MvpMatchView"
  },
  QuestManualView = {
    id = 1642,
    tab = nil,
    name = "\228\187\187\229\138\161\230\137\139\229\134\140",
    desc = "",
    prefab = "QuestManualView",
    class = "QuestManualView"
  },
  WebviewPanel = {
    id = 1650,
    tab = nil,
    name = "\229\134\133\231\189\174\230\181\143\232\167\136\229\153\168",
    desc = "",
    prefab = "WebviewPanel",
    class = "WebviewPanel"
  },
  StageView = {
    id = 1651,
    tab = 1,
    name = "\230\141\162\232\163\133\232\136\158\229\143\176",
    desc = "",
    prefab = "StageView",
    class = "StageView",
    hideCollider = true
  },
  StageOutfit = {
    id = 1652,
    tab = 2,
    name = "\233\128\160\229\158\139",
    desc = "",
    prefab = "StageView",
    class = "StageView",
    hideCollider = true
  },
  StageStyleView = {
    id = 1653,
    tab = nil,
    name = "\232\136\158\229\143\176",
    desc = "",
    prefab = "StageStyleView",
    class = "StageStyleView",
    hideCollider = false
  },
  JoinStagePopUp = {
    id = 1654,
    tab = nil,
    name = "\232\191\155\229\133\165\232\136\158\229\143\176",
    desc = "",
    prefab = "JoinStagePopUp",
    class = "JoinStagePopUp",
    hideCollider = true
  },
  ExchangeShopView = {
    id = 1660,
    tab = nil,
    name = "\232\191\189\232\184\170\229\149\134\229\186\151",
    desc = "",
    prefab = "ExchangeShopView",
    class = "ExchangeShopView"
  },
  TutorMatchView = {
    id = 1670,
    tab = nil,
    name = "\229\175\188\229\184\136\229\140\185\233\133\141",
    desc = "",
    prefab = "TutorMatchView",
    class = "TutorMatchView",
    hideCollider = true
  },
  TutorMatchResultView = {
    id = 1671,
    tab = nil,
    name = "\229\175\188\229\184\136\229\140\185\233\133\141\231\187\147\230\158\156",
    desc = "",
    prefab = "TutorMatchResultView",
    class = "TutorMatchResultView",
    hideCollider = true
  },
  BoothMainView = {
    id = 1680,
    tab = nil,
    name = "\230\145\134\230\145\138\228\184\187",
    desc = "",
    prefab = "BoothMainView",
    class = "BoothMainView"
  },
  BoothExchangeView = {
    id = 1681,
    tab = 1,
    name = "\230\145\134\230\145\138\228\186\164\230\152\147",
    desc = "",
    prefab = "BoothMainView",
    class = "BoothExchangeView"
  },
  BoothRecordView = {
    id = 1682,
    tab = 2,
    name = "\230\145\134\230\145\138\230\151\165\229\191\151",
    desc = "",
    prefab = "BoothMainView",
    class = "BoothRecordView"
  },
  BoothNameView = {
    id = 1683,
    tab = nil,
    name = "\230\145\134\230\145\138\229\144\141\231\167\176",
    desc = "",
    prefab = "BoothNameView",
    class = "BoothNameView"
  },
  BoothSellInfoView = {
    id = 1684,
    tab = nil,
    name = "\230\145\134\230\145\138\229\141\150\232\175\166\230\131\133",
    desc = "",
    prefab = "BoothExchangeInfoView",
    class = "BoothSellInfoView"
  },
  BoothBuyInfoView = {
    id = 1685,
    tab = nil,
    name = "\230\145\134\230\145\138\228\185\176\232\175\166\230\131\133",
    desc = "",
    prefab = "BoothExchangeInfoView",
    class = "BoothBuyInfoView"
  },
  TeamPwsReportPopUp = {
    id = 1690,
    tab = nil,
    name = "\231\187\132\233\152\159\231\171\158\230\138\128\232\181\155\230\136\152\230\138\165",
    desc = "",
    prefab = "TeamPwsReportPopUp",
    class = "TeamPwsReportPopUp",
    hideCollider = true
  },
  TeamPwsFightResultPopUp = {
    id = 1691,
    tab = nil,
    name = "\231\187\132\233\152\159\231\171\158\230\138\128\232\181\155\231\187\147\231\174\151",
    desc = "",
    prefab = "TeamPwsFightResultPopUp",
    class = "TeamPwsFightResultPopUp"
  },
  TeamPwsRankPopUp = {
    id = 1692,
    tab = nil,
    name = "\231\187\132\233\152\159\231\171\158\230\138\128\232\181\155\230\142\146\229\144\141",
    desc = "",
    prefab = "TeamPwsRankPopUp",
    class = "TeamPwsRankPopUp",
    hideCollider = true
  },
  MatchPreparePopUp = {
    id = 1693,
    tab = nil,
    name = "\231\187\132\233\152\159\231\171\158\230\138\128\232\181\155\229\135\134\229\164\135",
    desc = "",
    prefab = "MatchPreparePopUp",
    class = "MatchPreparePopUp",
    hideCollider = true
  },
  TeamPwsMatchPopUp = {
    id = 1694,
    tab = nil,
    name = "\231\187\132\233\152\159\231\171\158\230\138\128\232\181\155\229\140\185\233\133\141\231\138\182\230\128\129",
    desc = "",
    prefab = "TeamPwsMatchPopUp",
    class = "TeamPwsMatchPopUp",
    hideCollider = true
  },
  TeamPwsRewardPopUp = {
    id = 1695,
    tab = nil,
    name = "\231\187\132\233\152\159\231\171\158\230\138\128\232\181\155\229\165\150\229\138\177",
    desc = "",
    prefab = "TeamPwsRewardPopUp",
    class = "TeamPwsRewardPopUp",
    hideCollider = true
  },
  PetComposeView = {
    id = 1700,
    tab = nil,
    name = "\229\174\160\231\137\169\232\158\141\229\144\136",
    desc = "",
    prefab = "PetComposeView",
    class = "PetComposeView"
  },
  PetComposePreviewPopUp = {
    id = 1701,
    tab = nil,
    name = "\229\174\160\231\137\169\232\158\141\229\144\136\233\162\132\232\167\136",
    desc = "",
    prefab = "PetComposePreviewPopUp",
    class = "PetComposePreviewPopUp"
  },
  PetComposePopUp = {
    id = 1702,
    tab = nil,
    name = "\229\174\160\231\137\169\232\158\141\229\144\136",
    desc = "",
    prefab = "PetComposePopUp",
    class = "PetComposePopUp"
  },
  EquipComposeView = {
    id = 1710,
    tab = nil,
    name = "\232\163\133\229\164\135\229\144\136\230\136\144",
    desc = "",
    prefab = "EquipComposeView",
    class = "EquipComposeView"
  },
  ExchangeShopView = {
    id = 1650,
    tab = nil,
    name = "\232\191\189\232\184\170\229\149\134\229\186\151",
    desc = "",
    prefab = "ExchangeShopView",
    class = "ExchangeShopView"
  },
  HitBoliView = {
    id = 1750,
    tab = nil,
    name = "\229\164\169\229\164\169\230\137\147\230\179\162\229\136\169",
    desc = "",
    prefab = "HitBoli",
    class = "HitBoliView"
  },
  HotKeyInfoSetView = {
    id = 1720,
    tab = nil,
    name = "\233\128\137\233\161\185",
    prefab = "HotKeyInfoSetView",
    class = "HotKeyInfoSetView",
    hideCollider = true
  },
  HotKeyInfoView = {
    id = 1721,
    tab = nil,
    name = "\229\191\171\230\141\183\233\148\174\231\149\140\233\157\162",
    prefab = "HotKeyInfoView",
    class = "HotKeyInfoView"
  },
  ColliderView = {
    id = 1730,
    tab = nil,
    name = "\233\128\154\231\148\168\230\140\161\230\157\191",
    prefab = "ColliderView",
    class = "ColliderView",
    hideCollider = true
  },
  MoroccTimePopUp = {
    id = 1735,
    tab = nil,
    name = "\230\162\166\231\189\151\229\133\139\232\163\130\233\154\153\230\143\144\231\164\186\231\149\140\233\157\162",
    prefab = "MoroccTimePopUp",
    class = "MoroccTimePopUp",
    hideCollider = true
  },
  HitBoliView = {
    id = 1750,
    tab = nil,
    name = "\229\164\169\229\164\169\230\137\147\230\179\162\229\136\169",
    desc = "",
    prefab = "HitBoli",
    class = "HitBoliView"
  },
  ExpRaidMapView = {
    id = 1761,
    tab = nil,
    name = "\231\187\143\233\170\140\229\137\175\230\156\172\229\156\176\229\155\190",
    prefab = "ExpRaidMapView",
    class = "ExpRaidMapView"
  },
  ExpRaidDetailView = {
    id = 1762,
    tab = nil,
    name = "\231\187\143\233\170\140\229\137\175\230\156\172\232\175\166\230\131\133",
    prefab = "ExpRaidDetailView",
    class = "ExpRaidDetailView"
  },
  ExpRaidResultView = {
    id = 1763,
    tab = nil,
    name = "\231\187\143\233\170\140\229\137\175\230\156\172\231\187\147\231\174\151",
    prefab = "DojoResultPopUp",
    class = "ExpRaidResultView"
  },
  ExpRaidShopView = {
    id = 1764,
    tab = nil,
    name = "\231\187\143\233\170\140\229\137\175\230\156\172\229\149\134\229\186\151",
    prefab = "HappyShop",
    class = "ExpRaidShopView"
  },
  NewServerSignInMapView = {
    id = 1770,
    tab = nil,
    name = "\230\150\176\230\156\141\231\173\190\229\136\176\231\149\140\233\157\162",
    desc = "",
    prefab = "NewServerSignInMapView",
    class = "NewServerSignInMapView"
  },
  SignInRewardPreview = {
    id = 1771,
    tab = nil,
    name = "\230\150\176\230\156\141\231\173\190\229\136\176\229\165\150\229\138\177\233\162\132\232\167\136",
    desc = "",
    prefab = "SignInRewardPreview",
    class = "SignInRewardPreview",
    hideCollider = true
  },
  SignInTipsView = {
    id = 1772,
    tab = nil,
    name = "\230\150\176\230\156\141\231\173\190\229\136\176\229\176\143\230\143\144\231\164\186",
    desc = "",
    prefab = "SignInTipsView",
    class = "SignInTipsView"
  },
  SignInQAView = {
    id = 1773,
    tab = nil,
    name = "\230\150\176\230\156\141\231\173\190\229\136\176\229\165\150\229\138\177\233\151\174\231\173\148",
    desc = "",
    prefab = "SignInQAView",
    class = "SignInQAView"
  },
  SignInCatEncounterView = {
    id = 1774,
    tab = nil,
    name = "\230\150\176\230\156\141\231\173\190\229\136\176B\230\160\188\231\140\171\229\138\168\231\148\187",
    desc = "",
    prefab = "SignInCatEncounterView",
    class = "SignInCatEncounterView"
  },
  SignInRewardGetView = {
    id = 1775,
    tab = nil,
    name = "\230\150\176\230\156\141\231\173\190\229\136\176\230\136\144\229\138\159\230\143\144\231\164\186",
    desc = "",
    prefab = "SignInRewardGetView",
    class = "SignInRewardGetView"
  },
  CourageRankPopUp = {
    id = 1780,
    tab = nil,
    name = "\229\139\135\230\176\148\230\142\146\232\161\140\231\149\140\233\157\162",
    prefab = "CourageRankPopUp",
    class = "CourageRankPopUp"
  },
  MapTransmitterView = {
    id = 1790,
    tab = nil,
    name = "\228\188\160\233\128\129\229\153\168\229\156\176\229\155\190\233\128\137\230\139\169\231\149\140\233\157\162",
    desc = "",
    prefab = "MapTransmitterView",
    class = "MapTransmitterView"
  },
  MapTransmitterAreaView = {
    id = 1791,
    tab = nil,
    name = "\228\188\160\233\128\129\229\153\168\229\156\176\231\130\185\233\128\137\230\139\169\231\149\140\233\157\162",
    desc = "",
    prefab = "MapTransmitterAreaView",
    class = "MapTransmitterAreaView"
  },
  ChangeCatPopUp = {
    id = 1800,
    tab = nil,
    name = "\230\155\180\230\141\162\228\189\163\229\133\181\231\140\171",
    desc = "",
    prefab = "ChangeCatPopUp",
    class = "ChangeCatPopUp"
  },
  ActivityDungeonView = {
    id = 1810,
    tab = nil,
    name = "\230\180\187\229\138\168\229\137\175\230\156\172",
    desc = "",
    prefab = "ActivityDungeonView",
    class = "ActivityDungeonView"
  },
  ActivityDungeonInfo = {
    id = 1811,
    tab = 1,
    name = "\230\180\187\229\138\168\229\137\175\230\156\172\228\187\139\231\187\141",
    desc = "",
    prefab = "ActivityDungeonInfo",
    class = "ActivityDungeonInfo"
  },
  ActivityDungeonRate = {
    id = 1812,
    tab = 2,
    name = "\230\180\187\229\138\168\229\137\175\230\156\172\232\175\132\231\186\167",
    desc = "",
    prefab = "ActivityDungeonRate",
    class = "ActivityDungeonRate"
  },
  ActivityDungeonShop = {
    id = 1812,
    tab = 3,
    name = "\230\180\187\229\138\168\229\137\175\230\156\172\229\149\134\229\186\151",
    desc = "",
    prefab = "ActivityDungeonShop",
    class = "ActivityDungeonShop"
  },
  RatingRewardPreview = {
    id = 1813,
    tab = nil,
    name = "\232\175\132\231\186\167\229\165\150\229\138\177\233\162\132\232\167\136",
    desc = "",
    prefab = "RatingRewardPreview",
    class = "RatingRewardPreview"
  },
  BossCardComposeView = {
    id = 1800,
    tab = nil,
    name = "Boss\229\141\161\229\144\136\230\136\144",
    desc = "",
    prefab = "BossCardComposeView",
    class = "BossCardComposeView"
  },
  WorldMapMenuPopUp = {
    id = 1830,
    tab = nil,
    name = "\228\184\150\231\149\140\229\156\176\229\155\190\232\175\166\230\131\133\231\149\140\233\157\162",
    desc = "",
    prefab = "WorldMapMenuPopUp",
    class = "WorldMapMenuPopUp",
    hideCollider = true
  },
  ActivePanel = {
    id = 10004,
    tab = nil,
    name = "\230\191\128\230\180\187\231\149\140\233\157\162",
    desc = "",
    prefab = "ActivePanel",
    class = "ActivePanel"
  },
  TempActivityView = {
    id = 10005,
    tab = nil,
    name = "\232\191\144\232\144\165\230\180\187\229\138\168",
    desc = "",
    prefab = "TempActivityView",
    class = "TempActivityView",
    hideCollider = true
  },
  ActiveErrorBord = {
    id = 10006,
    tab = nil,
    name = "\230\191\128\230\180\187\233\148\153\232\175\175\229\188\185\230\161\134",
    desc = "",
    prefab = "ActiveErrorBord",
    class = "ActiveErrorBord"
  },
  RolesSelect = {
    id = 10009,
    tab = nil,
    name = "\232\167\146\232\137\178\233\128\137\230\139\169",
    desc = "",
    prefab = "UIViewRolesList",
    class = "UIViewControllerRolesList"
  },
  SecurityPanel = {
    id = 10010,
    tab = nil,
    name = "\229\174\137\229\133\168\233\170\140\232\175\129",
    desc = "",
    prefab = "SecurityPanel",
    class = "SecurityPanel"
  },
  AgreementPanel = {
    id = 10020,
    tab = nil,
    name = "\232\174\184\229\143\175\229\141\143\232\174\174",
    desc = "",
    prefab = "AgreementPanel",
    class = "AgreementPanel"
  },
  ActivityDetailPanel = {
    id = 10030,
    tab = nil,
    name = "\230\180\187\229\138\168\232\175\166\230\131\133",
    desc = "",
    prefab = "ActivityDetailPanel",
    class = "ActivityDetailPanel"
  },
  MiyinStrengthen = {
    id = 10040,
    tab = nil,
    name = "\231\167\152\233\147\182\229\188\186\229\140\150",
    desc = "",
    prefab = "UIViewMiyinStrengthen",
    class = "UIViewControllerMiyinStrengthen"
  },
  MarriageCertificate = {
    id = 10050,
    tab = nil,
    name = "\231\187\147\229\169\154\232\175\129\228\185\166",
    desc = "",
    prefab = "MarriageCertificate",
    class = "MarriageCertificate"
  },
  MarriageManualPicDiy = {
    id = 10051,
    tab = nil,
    name = "\231\187\147\229\169\154\230\137\139\229\134\140diy\232\175\129\228\185\166",
    desc = "",
    prefab = "MarriageManualPicDiy",
    class = "MarriageManualPicDiy"
  },
  KFCActivityShowView = {
    id = 10061,
    tab = nil,
    name = "kfc\230\180\187\229\138\168\229\136\134\228\186\171",
    desc = "",
    prefab = "KFCActivityShowView",
    class = "KFCActivityShowView"
  },
  KFCARCameraPanel = {
    id = 10062,
    tab = nil,
    name = "kfcarcamera",
    desc = "",
    prefab = "KFCARCameraPanel",
    class = "KFCARCameraPanel"
  },
  SharePanel = {
    id = 10063,
    tab = nil,
    name = "SharePanel",
    desc = "",
    prefab = "SharePanel",
    class = "SharePanel"
  }
}
