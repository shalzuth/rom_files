--[[
    --说明:
        界面显示/隐藏的方式枚举
    --配置说明:
        CreateAndDestroy 创建/销毁
        ActiveAndDeactive 设置激活/非激活
        MoveOutAndMoveIn 移除到远处/移动回来
]]
PanelShowHideMode = {
    CreateAndDestroy = 1,
    ActiveAndDeactive = 2,
    MoveOutAndMoveIn = 3
}

--[[
	--说明：
		界面的配置
		此配置由程序维护，策划会来查看相应界面ID并配置系统开启等。
		ID一旦定下，不可以修改。
		如有界面中有tab标签页的，也需要当成一个界面来配置
	--配置格式:
		id 		        唯一标识ID，不可改变（约定每个整体界面的间隔为10，中间预留为以后可能插入的标签页ID）
		tab 	        标签页ID，如果不特定，则为nil
		name	        名字
		desc	        描述
		prefab	        视图的prefab名字，相对于GUI/v1/view下的路径名
        class           lua脚本名
        hideCollider    强制隐藏遮挡底板
        unOpenJump      面板未开启，自动跳转的界面ID
]]
PanelConfig = {
    Charactor = {id=1,tab=nil,name="人物",desc="",prefab = "Charactor",class = "Charactor",hideCollider = true},
    CharactorAdventureSkill = {id=3,tab=1,name="冒险技能",desc="",prefab = "SkillView",class = "SkillView"},
    CharactorProfessSkill = {id=4,tab=2,name="职业技能",desc="",prefab = "SkillView",class = "SkillView",unOpenJump = 3},
    CharactorTitle = {id=5,tab=4,name="人物称号",desc="",prefab = "Charactor1",class = "Charactor1"},
    CharactorBeingSkill = {id=6,tab=5,name="生命体技能",desc="",prefab = "SkillView",class = "SkillView"},

    Bag = {id=11,tab=1,name="背包",desc="",prefab = "PackageView",class = "PackageView",hideCollider = true},
    EquipStrengthen = {id=91,tab=2,name="强化",desc="",prefab = "PackageView",class = "PackageView"},
    PackageRefine = {id=12,tab=3,name="强化",desc="",prefab = "PackageRefine",class = "PackageRefine"},
    PackageHighRefine = {id=13,tab=4,name="强化",desc="",prefab = "PackageHighRefine",class = "PackageHighRefine"},

    UseCardPopUp = {id=15,tab=nil,name="使用卡片",desc="",prefab = "UseCardPopUp",class = "UseCardPopUp"},
    SetCardPopUp = {id=16,tab=nil,name="镶嵌卡片",desc="",prefab = "SetCardPopUp",class = "SetCardPopUp"},
    CollectSaleConfirmPopUp = {id=17,tab=nil,name="一键出售",desc="",prefab = "CollectSaleConfirmPopUp",class = "CollectSaleConfirmPopUp"},

    TempPackageView = {id=21,tab=nil,name="临时背包",desc="",prefab="TempPackageView",class="TempPackageView",hideCollider=true},

    NpcRefinePanel = {id=31,tab=nil,name="精炼界面",desc="",prefab = "NpcRefinePanel",class = "NpcRefinePanel"},
    HighRefinePanel = {id=41,tab=nil,name="极限精炼",desc="",prefab = "HighRefinePanel",class = "HighRefinePanel"},

    PhotographPanel = {id=71,tab=nil,name="照相模式",desc="",prefab = "PhotographPanel",class = "PhotographPanel",hideCollider = true},
    PhotographResultPanel = {id=81,tab=nil,name="照相结果",desc="",prefab = "PhotographResultPanel",class = "PhotographResultPanel",hideCollider = true},
    PictureDetailPanel = {id=82,tab=nil,name="照片墙详情",desc="",prefab = "PictureDetailPanel",class = "PictureDetailPanel",hideCollider = true},
    PersonalPicturePanel = {id=83,tab=nil,name="个人相册",desc="",prefab = "PersonalPicturePanel",class = "PersonalPicturePanel"},
    PersonalPictureDetailPanel = {id=84,tab=nil,name="个人相册详情",desc="",prefab = "PersonalPictureDetailPanel",class = "PersonalPictureDetailPanel"},
    PicutureWallSyncPanel = {id=85,tab=nil,name="公会墙同步",desc="",prefab = "PicutureWallSyncPanel",class = "PicutureWallSyncPanel"},
    TempPersonalPicturePanel = {id=86,tab=nil,name="临时相册",desc="",prefab = "TempPersonalPicturePanel",class = "TempPersonalPicturePanel"},
    TempPersonalPictureDetailPanel = {id=87,tab=nil,name="临时相册详情",desc="",prefab = "TempPersonalPictureDetailPanel",class = "TempPersonalPictureDetailPanel"},
    WeddingWallPictureDetail = {id=88,tab=nil,name="婚礼相框详情",desc="",prefab = "WeddingWallPictureDetail",class = "WeddingWallPictureDetail"},
    WeddingWallPictureSyncPanel = {id=89,tab=nil,name="婚礼相框上传",desc="",prefab = "PicutureWallSyncPanel",class = "WeddingWallPictureSyncPanel"},

    EnchantView = {id=90,tab=nil,name="装备附魔",desc="",prefab = "EnchantView",class = "EnchantView"},
    DeComposeView = {id=92,tab=nil,name="分解",desc="",prefab = "DeComposeView",class = "DeComposeView"},
    ReplaceView = {id=94,tab=nil,name="装备置换",desc="",prefab = "ReplaceView",class = "ReplaceView"},

    BossView = {id = 101, tab=nil, name = "Boss", desc="", prefab = "BossView", class="BossView"},
    AddPointPage = {id= 111,tab=2,name="加点",desc="",prefab = "AddPointPage",class = "AddPointPage"},
    ProfessionPage = {id=121,tab=3,name="职业",desc="",prefab = "ProfessionPage",class = "ProfessionPage"},
    InfomationPage = {id=122,tab=1,name="角色信息",desc="",prefab="InfomationPage",class = "InfomationPage" },


    ProfessionSaveLoadView = {id=123,tab=nil,name="职业存储",desc="",prefab = "ProfessionInfoViewMP",class = "ProfessionContainerView"},
    PlayerDetailViewMP = {id = 124,tab=nil,name="玩家详细信息界面",desc="",prefab="PlayerDetailViewMP",class="PlayerDetailViewMP",hideCollider = true},
    ChangeSaveNamePopUp = {id=125,tab=nil,name="存档改名",desc="",prefab = "ChangeSaveNamePopUp",class = "ChangeSaveNamePopUp"},
    PurchaseSaveSlotPopUp = {id=126,tab=nil,name="存档改名",desc="",prefab = "PurchaseSaveSlotPopUp",class = "PurchaseSaveSlotPopUp"},
    CheckAllProfessionPanel = {id=127,tab=nil,name="查看职业面板",desc="",prefab="CheckAllProfessionPanel",class="CheckAllProfessionPanel"},

    RepositoryView = {id=141,tab=nil,name="仓库",desc="",prefab = "RepositoryView",class = "RepositoryView"},
    
    HappyShop = {id=151,tab=nil,name="乐园团商店",desc="",prefab = "HappyShop",class = "HappyShop"},
    WorldMapView = {id=161,tab=nil,name="世界地图",desc="",prefab = "WorldMapView",class = "WorldMapView"},    
    LowBloodBlinkView = {id=134,tab=nil,name="低血泛红",desc="",prefab = "ClickEffectView",class = "LowBloodBlinkView"},

    FloatAwardView = {id=135,tab=nil,name="奖励",desc="",prefab = "FloatAwardView",class = "FloatAwardView"},
    ShareAwardView = {id=136,tab=nil,name="分享",desc="",prefab = "ShareAwardView",class = "ShareAwardView"},

    QuestPanel = {id=137,tab=nil,name="任务面板",desc="",prefab = "QuestPanel",class = "QuestPanel"},
    RaidInfoPopUp = {id=140,tab=nil,name="副本信息",desc="",prefab = "RaidInfoPopUp",class = "RaidInfoPopUp",hideCollider = true},
    ChatRoomPage = {id=181,tab=nil,name="聊天室",desc="",prefab = "ChatRoom",class = "ChatRoomPage",hideCollider = false},
    ChatBarrageView = {id=182,tab=nil,name="聊天弹幕",desc="",prefab = "ChatBarrageView",class = "ChatBarrageView"},
    ChatEmojiView = {id=191,tab=nil,name="表情",desc="",prefab = "UIEmojiView",class = "UIEmojiView",hideCollider = false},
    AnnounceQuestPanel = {id=201,tab=nil,name="公告任务版",desc="",prefab = "AnnounceQuestPanel",class = "AnnounceQuestPanel",hideCollider = false},
    AnnounceQuestActivityPanel = {id=202,tab=nil,name="公告任务活动版",desc="",prefab = "AnnounceQuestActivityPanel",class = "AnnounceQuestPanel",hideCollider = false},
    SoundBoxView = {id=211,tab=nil,name="音乐盒播放列表",desc="",prefab = "SoundBoxView",class = "SoundBoxView",hideCollider = false},
    SoundItemChoosePopUp = {id=212,tab=nil,name="音乐盒道具列表",desc="",prefab = "SoundItemChoosePopUp",class = "SoundItemChoosePopUp",hideCollider = false},
    ClickEffectView = {id=310,tab=nil,name="全屏点击",desc="",prefab = "ClickEffectView",class = "ClickEffectView",hideCollider = true},
    CreateChatRoom = {id=320,tab=nil,name="聊天室",desc="",prefab = "CreateChatRoom",class = "CreateChatRoom",hideCollider = false},
    EndlessTower = {id=330,tab=nil,name="无尽之塔",desc="",prefab = "EndlessTower",class = "EndlessTower",hideCollider = false},
    EndlessTowerWaitView = {id=331,tab=nil,name="无尽之塔等待队友",desc="",prefab="EndlessTowerWaitView",class="EndlessTowerWaitView"},
    
    TeamMemberListPopUp = {id=351,tab=nil,name="队伍信息",desc="",prefab = "TeamMemberListPopUp",class = "TeamMemberListPopUp",hideCollider = false},
    TeamFindPopUp = {id=352,tab=nil,name="查找队伍",desc="",prefab = "TeamFindPopUp",class = "TeamFindPopUp",hideCollider = false},
    TeamApplyListPopUp = {id=353,tab=nil,name="申请列表",desc="",prefab = "TeamApplyListPopUp",class = "TeamApplyListPopUp",hideCollider = false},
    TeamInvitePopUp = {id=354,tab=nil,name="邀请队员",desc="",prefab = "TeamInvitePopUp",class = "TeamInvitePopUp",hideCollider = false},
    TeamOptionPopUp = {id=355,tab=nil,name="队伍设置",desc="",prefab = "TeamOptionPopUp",class = "TeamOptionPopUp",hideCollider = false},

    PostView = {id=370,tab=nil,name="邮件",desc="",prefab = "PostView",class = "PostView",hideCollider = false},    
    XOView = {id=380,tab=nil,name="问答系统",desc="",prefab = "XOView",class = "XOView",hideCollider = false},
    AdventurePanel = {id=400,tab=nil,name="冒险日志",desc="",prefab = "AdventurePanel",class = "AdventurePanel"},
    AdventureRewardPanel = {id=401,tab=nil,name="冒险奖励",desc="",prefab = "AdventureRewardPanel",class = "AdventureRewardPanel"},
    ScenerytDetailPanel = {id=402,tab=nil,name="景点详情",desc="",prefab = "ScenerytDetailPanel",class = "ScenerytDetailPanel"},
    MonthCardDetailPanel = {id=403,tab=nil,name="月卡详情",desc="",prefab = "MonthCardDetailPanel",class = "MonthCardDetailPanel"},
    EpCardDetailPanel = {id=404,tab=nil,name="Ep详情",desc="",prefab = "EpCardDetailPanel",class = "EpCardDetailPanel"},
    ShopSale = {id=410,tab=nil,name="商店出售",desc="",prefab = "ShopSale",class = "ShopSale"},
    ChangeJobView = {id=420,tab=nil,name="转职长廊界面",desc="",prefab = "ChangeJobView",class = "ChangeJobView"},
    GuidePanel = {id=430,tab=nil,name="引导提示确认",desc="",prefab = "GuidePanel",class = "GuidePanel"},
    GuideMaskView = {id=440,tab=nil,name="引导",desc="",prefab = "GuideMaskView",class = "GuideMaskView"},
    UIMapAreaList = {id=450,tab=nil,name="区域界面",desc="",prefab="UIMapAreaList",class="UIMapAreaList"},
    UIMapMapList = {id=460,tab=nil,name="地图界面",desc="",prefab="UIMapAreaList",class="UIMapMapList"},

    LoadingViewDefault = {id=470,tab=1,name="默认加载界面",desc="",prefab="Loading/LoadingSceneView",class="LoadingSceneView"},
    LoadingViewIllustration = {id=471,tab=2,name="插画加载界面",desc="",prefab="Loading/LoadingSceneView",class="LoadingSceneView"},
    LoadingViewNewExplore = {id=472,tab=3,name="新区域解锁",desc="",prefab="Loading/LoadingSceneView",class="LoadingSceneView"},
    LoadingViewQuickWithoutProgress = {id=473,tab=4,name="什么都没的黑界面",desc="",prefab="Loading/LoadingSceneView",class="LoadingSceneView"},

    FriendMainView = {id=480,tab=nil,name="好友主界面",desc="",prefab="FriendMainView",class="FriendMainView"},
    AddFriendView = {id=481,tab=nil,name="添加好友",desc="",prefab="AddFriendView",class="AddFriendView"},
    FriendApplyInfoView = {id=482,tab=nil,name="好友申请列表",desc="",prefab="FriendApplyInfoView",class="FriendApplyInfoView"},
    BlacklistView = {id=483,tab=nil,name="黑名单",desc="",prefab="BlacklistView",class="BlacklistView"},
    FriendView = {id=484,tab=1,name="好友界面",desc="",prefab="FriendMainView",class="FriendView"},
    TutorView = {id=485,tab=2,name="导师界面",desc="",prefab="FriendMainView",class="TutorMainView"},
    TutorApplyView = {id=486,tab=nil,name="导师申请界面",desc="",prefab="TutorApplyView",class="TutorApplyView"},
    TutorTaskView = {id=487,tab=nil,name="导师任务界面",desc="",prefab="TutorTaskView",class="TutorTaskView"},
    TutorGraduationView = {id=488,tab=nil,name="导师毕业界面",desc="",prefab="TutorGraduationView",class="TutorGraduationView"},

    PicMakeView = {id=490,tab=nil,name="图纸制作界面",desc="",prefab="PicMakeView",class="PicMakeView"},
    PicTipPopUp = {id=495,tab=nil,name="图纸制作弹框",desc="",prefab="PicTipPopUp",class="PicTipPopUp"},

    ShopMallMainView = {id=500,tab=nil,name="商城主界面",desc="",prefab="ShopMallMainView",class="ShopMallMainView"},
    ShopMallExchangeBuyInfoView = {id=501,tab=nil,name="商城交易所购买详情界面",desc="",prefab="ShopMallExchangeInfoView",class="ShopMallExchangeBuyInfoView"},
    ShopMallExchangeSellInfoView = {id=502,tab=nil,name="商城交易所出售详情界面",desc="",prefab="ShopMallExchangeInfoView",class="ShopMallExchangeSellInfoView"},
    ShopMallExchangeSearchView = {id=503,tab=nil,name="商城交易所搜索界面",desc="",prefab="ShopMallExchangeSearchView",class="ShopMallExchangeSearchView"},
    ShopMallExchangeView = {id=504,tab=nil,name="商城交易所",desc="",prefab="ShopMallMainView",class="ShopMallMainView"},
    ShopMallShopView = {id=505,tab=nil,name="商城商城",desc="",prefab="ShopMallMainView",class="ShopMallMainView"},
    ShopMallRechargeView = {id=506,tab=nil,name="商城充值",desc="",prefab="ShopMallMainView",class="ShopMallMainView"},
    ExchangeExpressView = {id=507,tab=nil,name="交易所赠送",desc="",prefab="ExchangeExpressView",class="ExchangeExpressView"},
    ExchangeRecordDetailView = {id=508,tab=nil,name="交易所交易记录详情",desc="",prefab="ExchangeRecordDetailView",class="ExchangeRecordDetailView"},
    ExchangeFriendView = {id=509,tab=nil,name="交易所赠送好友选择",desc="",prefab="ExchangeFriendView",class="ExchangeFriendView"},
    ExchangeSignExpressView = {id=510,tab=nil,name="交易所签收快递",desc="",prefab="ExchangeSignExpressView",class="ExchangeSignExpressView"},

    GuildInfoView = {id=520,tab=1,name="公会主界面",desc="",prefab="GuildInfoView",class="GuildInfoView"},
    GuildInfoPage = {id=521,tab=1,name="公会信息界面",desc="",prefab="GuildInfoView",class="GuildInfoView"},
    GuildMemberListPage = {id=522,tab=2,name="公会队员界面",desc="",prefab="GuildInfoView",class="GuildInfoView"},
    GuildFaithPage = {id=523,tab=3,name="公会信仰界面",desc="",prefab="GuildInfoView",class="GuildInfoView"},
    GuildFindPage = {id=524,tab=4,name="公会查找界面",desc="",prefab="GuildInfoView",class="GuildInfoView"},
    GuildAssetPage ={id=525,tab=5,name="公会资产界面",desc="",prefab="GuildInfoView",class="GuildInfoView"},
    GLandStatusListView ={id=528,tab=5,name="公会据点状态界面",desc="",prefab="GLandStatusListView",class="GLandStatusListView"},

    CreateGuildPopUp = {id=530,tab=nil,name="公会创建",desc="",prefab="CreateGuildPopUp",class="CreateGuildPopUp"},
    GuildJobEditPopUp = {id=531,tab=nil,name="公会职位编辑",desc="",prefab="GuildJobEditPopUp",class="GuildJobEditPopUp"},
    GuildJobChangePopUp = {id=532,tab=nil,name="公会职位变更",desc="",prefab="GuildJobChangePopUp",class="GuildJobChangePopUp"},
    GuildApplyListPopUp = {id=533,tab=nil,name="公会申请列表",desc="",prefab="GuildApplyListPopUp",class="GuildApplyListPopUp"},
    GuildHeadChoosePopUp = {id=534,tab=nil,name="公会头像更换界面",desc="",prefab="GuildHeadChoosePopUp",class="GuildHeadChoosePopUp"},
    GuildEventPopUp = {id=535,tab=nil,name="公会事件界面",desc="",prefab="GuildEventPopUp",class="GuildEventPopUp"},
    GuildTreasurePopUp = {id=536,tab=nil,name="公会宝箱贡献界面",desc="",prefab="GuildTreasurePopUp",class="GuildTreasurePopUp"},
    GuildPrayDialog = {id=538,tab=nil,name="公会祈祷界面",desc="",prefab="GuildPrayDialog",class="GuildPrayDialog"},
    GuildFindPopUp = {id=540,tab=nil,name="加入公会",desc="",prefab="GuildFindPopUp",class="GuildFindPopUp"},
    GuildDonateView = {id=545,tab=nil,name="公会贡献界面",desc="",prefab="GuildDonateView",class="GuildDonateView"},
    GuildOpenRaidDialog = {id=546,tab=nil,name="公会挑战界面",desc="",prefab="GuildOpenRaidDialog",class="GuildOpenRaidDialog"},
    AstrolabeView = {id=547,tab=nil,name="公会星盘界面",desc="",prefab="AstrolabeView",class="AstrolabeView"},

    GuildChangeNamePopUp = {id=548,tab=nil,name="公会更名",desc="",prefab="GuildChangeNamePopUp",class="GuildChangeNamePopUp"},
    GuildChallengeTaskPopUp = {id=549,tab=nil,name="公会挑战任务",desc="",prefab="GuildChallengeTaskPopUp",class="GuildChallengeTaskPopUp"},

    AdventureAppendRewardPanel = {id=550,tab=nil,name="冒险手册追加",desc="",prefab="AdventureAppendRewardPanel",class="AdventureAppendRewardPanel"},

    SpeechRecognizerView = {id=560,tab=nil,name="语音弹出小话筒",desc="",prefab="SpeechRecognizerView",class="SpeechRecognizerView"},

    DojoGroupView = {id=570,tab=nil,name="选择道场",desc="",prefab="DojoGroupView",class="DojoGroupView"},
    DojoMainView = {id=571,tab=nil,name="挑战道场",desc="",prefab="DojoMainView",class="DojoMainView"},
    DojoWaitView = {id=572,tab=nil,name="道场等待队友",desc="",prefab="DojoWaitView",class="DojoWaitView"},
    DungeonCountDownView = {id=573,tab=nil,name="进入副本倒计时",desc="",prefab="DungeonCountDownView",class="DungeonCountDownView"},
    DojoResultPopUp = {id=574,tab=nil,name="道场胜利奖励",desc="",prefab="DojoResultPopUp",class="DojoResultPopUp"},

    CountDownView = {id=580,tab=nil,name="副本倒计时",desc="",prefab="CountDownView",class="CountDownView"},

    SealTaskPopUp = {id=590,tab=nil,name="封印接取面板",desc="",prefab="SealTaskPopUp",class="SealTaskPopUp"},
    RepairSealConfirmPopUp = {id=595,tab=nil,name="封印开始面板",desc="",prefab="RepairSealConfirmPopUp",class="RepairSealConfirmPopUp",hideCollider=true},

    MediaPanel = {id=600,tab=nil,name="播放视频",desc="",prefab="MediaPanel",class="MediaPanel"},

    InstituteResultPopUp = {id=610,tab=nil,name="研究所结算面板",desc="",prefab="InstituteResultPopUp",class="InstituteResultPopUp"},

    AdventureSkill = {id=620,name='冒险技能',prefab='UIViewAdventureSkill',class='UIViewControllerAdventureSkill'},

    SetView = {id=630,name='设置',prefab='SetView',class='SetView', hideCollider = true},
    SystemSettingPage = {id=631,tab=1,name="系统设置",desc="",prefab="",class = "" },
    EffectSettingPage = {id=632,tab=2,name="特效设置",desc="",prefab="",class = "" },
    MsgPushSettingPage = {id=633,tab=3,name="推送设置",desc="",prefab="",class = "" },
    SecuritySettingPage = {id=634,tab=4,name="安全设置",desc="",prefab="",class = "" },

    NoticeMsgView = {id=640,name='公告',prefab='NoticeMsgView',class='NoticeMsgView'},

    PlayerDetailView = {id = 650,tab=nil,name="玩家详细信息界面",desc="",prefab="PlayerDetailView",class="PlayerDetailView",hideCollider = true},

    EDView = {id = 660,tab=nil,name="EDUI界面",desc="",prefab="EDView",class="EDView",hideCollider = true},
    EDView2 = {id = 661,tab=nil,name="EDUI2界面",desc="",prefab="EDView2",class="EDView2",hideCollider = true},

    SkyWheelAcceptView = {id=670,tab=nil,name="摩天轮接受",desc="",prefab="SkyWheelAcceptView",class="SkyWheelAcceptView"},
    SkyWheelSearchView = {id=671,tab=nil,name="摩天轮搜索",desc="",prefab="SkyWheelSearchView",class="SkyWheelSearchView"},
    SkyWheelFriendView = {id=672,tab=nil,name="摩天轮好友",desc="",prefab="SkyWheelFriendView",class="SkyWheelFriendView"},

    EquipMakeView = {id=680,tab=nil,name="装备制作",desc="",prefab="EquipMakeView",class="EquipMakeView"},
    EquipRecoverView = {id=681,tab=nil,name="装备熔炉",desc="",prefab="EquipRecoverView",class="EquipRecoverView"},
    EquipAlchemyView = {id=685,tab=nil,name="装备炼金",desc="",prefab="EquipAlchemyView",class="EquipAlchemyView"},

    ChangeZoneView = {id=690,tab=nil,name="切换异次元",desc="",prefab="ChangeZoneView",class="ChangeZoneView"},

    GiftActivePanel = {id=700,tab=nil,name="礼包码兑换",desc="",prefab="GiftActivePanel",class="GiftActivePanel"},

    ChangeHeadView = {id=710,tab=nil,name="更换头像",desc="",prefab="ChangeHeadView",class="ChangeHeadView"},

    ZenyShop = {id=720,tab=1,name="Zeny商城",desc="",prefab="UIViewZenyShop",class="UIViewControllerZenyShop"},
    ZenyShopMonthlyVIP = {id=721,tab=2,name="月卡购买",desc="",prefab="UIViewZenyShop",class="UIViewControllerZenyShop"},
    ZenyShopGachaCoin = {id=722,tab=3,name="扭蛋币购买",desc="",prefab="UIViewZenyShop",class="UIViewControllerZenyShop"},
    ZenyShopItem = {id=723,tab=4,name="道具购买",desc="",prefab="UIViewZenyShop",class="UIViewControllerZenyShop"},
    AppStorePurchase = {id=724,tab=nil,name="",desc="",prefab="UIViewAppStorePurchase",class="UVC_AppStorePurchase"},

    ChangeNameView = {id=730,tab=nil,name="更换角色名称",desc="",prefab="ChangeNameView",class="ChangeNameView"},
    RoleChangeNamePopUp = {id=731,tab=nil,name="更换角色名称",desc="",prefab="RoleChangeNamePopUp",class="RoleChangeNamePopUp"},

    ShortCutOptionPopUp = {id=740,tab=nil,name="追踪选择界面",desc="",prefab="ShortCutOptionPopUp",class="ShortCutOptionPopUp"},

    AuguryView = {id=750,tab=nil,name="占卜",desc="",prefab="AuguryView",class="AuguryView"},

    ValentineView = {id=760,tab=nil,name="白色情人节情书",desc="",prefab="ValentineView",class="ValentineView"},
    StarView = {id=761,tab=nil,name="星座絮语情书",desc="",prefab="StarView",class="StarView"},
    ChristmasInviteView = {id=762,tab=nil,name="圣诞情书邀请",desc="",prefab="ChristmasInviteView",class="ChristmasInviteView"},
    ChristmasView = {id=763,tab=nil,name="圣诞情书",desc="",prefab="ChristmasView",class="ChristmasView"},
    SpringActivityInviteView = {id=764,tab=nil,name="春节贺卡邀请",desc="",prefab="SpringActivityInviteView",class="SpringActivityInviteView"},
    SpringActivityView = {id=765,tab=nil,name="春节贺卡",desc="",prefab="SpringActivityView",class="SpringActivityView"},
    LotteryGiftView = {id=766,tab=nil,name="扭蛋祝福",desc="",prefab="LotteryGiftView",class="LotteryGiftView"},
    WeddingDressSendView = {id=767,tab=nil,name="婚纱赠送赠送",desc="",prefab="WeddingDressSendView",class="WeddingDressSendView"},
    WeddingDressView = {id=768,tab=nil,name="婚纱赠送书信",desc="",prefab="WeddingDressView",class="WeddingDressView"},

    VideoPanel={id=770,tab=nil,name="冒险手册珍藏品视频",desc="",prefab="VideoPanel",class="VideoPanel",hideCollider=false},

    UIVictoryView = {id=780,tab=nil,name="打斗场结算界面",desc="",prefab="UIVictoryView",class="UIVictoryView"},

    HairDressingView = {id=790,tab=nil,name="理发店商城",desc="",prefab="HairDressingView",class="HairDressingView"},
    HairCutPage = {id=791,tab=1,name="理发界面",desc="",prefab="HairCutPage",class="HairCutPage"},
    HairDyePage = {id=792,tab=2,name="染发界面",desc="",prefab="HairDyePage",class="HairDyePage"},

    PlotStoryView = {id=800,tab=nil,name="剧情故事界面",desc="",prefab="PlotStoryView",class="PlotStoryView"},

    HireCatInfoView = {id=810,tab=nil,name="雇佣猫详情",desc="",prefab="HireCatInfoView",class="HireCatInfoView"},

    SecretReportPvpPopUp = {id=820,tab=nil,name="密码报名",desc="",prefab="SecretReportPvpPopUp",class="SecretReportPvpPopUp"},

    HandUpView = {id=900,tab=nil,name="挂机界面",desc="",prefab="HandUpView",class="HandUpView"},
    PopUpItemView = {id=910,tab=nil,name="道具获得弹框",desc="",prefab="PopUpItemView",class="PopUpItemView",hideCollider=false},

    PvpMainView = {id=920,tab=nil,name="打斗场",desc="",prefab="PvpMainView",class="PvpMainView"},
    YoyoViewPage = {id=921,tab=1,name="溜溜猴打斗场",desc="",prefab="YoyoViewPage",class="YoyoViewPage"},
    DesertWolfView = {id=922,tab=2,name="沙漠之狼斗技场",desc="",prefab="DesertWolfView",class="DesertWolfView"},
    GorgeousMetalView = {id=923,tab=3,name="华丽金属抢夺战",desc="",prefab="GorgeousMetalView",class="GorgeousMetalView"},
    DesertWolfJoinView = {id=924,tab=nil,name="沙漠之狼报名",desc="",prefab="DesertWolfJoinView",class="DesertWolfJoinView"},

    BusinessmanMakeView = {id=930,tab=nil,name="商人制作",desc="",prefab="BusinessmanMakeView",class="BusinessmanMakeView"},
    AlchemistMakeView = {id=931,tab=nil,name="炼金制作",desc="",prefab="BusinessmanMakeView",class="AlchemistMakeView"},
    KnightMakeView = {id=932,tab=nil,name="炼金制作",desc="",prefab="BusinessmanMakeView",class="KnightMakeView"},

    MagicStoneRecoverView = {id=940,tab=nil,name="卸卡魔石",desc="",prefab="MagicStoneRecoverView",class="MagicStoneRecoverView"},

    CardRandomMakeView = {id=950,tab=nil,name="卡片再生机抽卡",desc="",prefab="CardRandomMakeView",class="CardRandomMakeView"},
    CardMakeView = {id=960,tab=nil,name="卡片再生机合成",desc="",prefab="CardMakeView",class="CardMakeView"},

    GeneralShareView = {id=970,tab=nil,name="分享通用界面",desc="",prefab="GeneralShareView",class="GeneralShareView"},

    FoodMakeView = {id=980,tab=nil,name="料理制作界面",desc="",prefab="FoodMakeView",class="FoodMakeView"},
    FoodGetPopUp = {id=985,tab=nil,name="料理获得界面",desc="",prefab="FoodGetPopUp",class="FoodGetPopUp", hideCollider = true},
    EatFoodPopUp = {id=986,tab=nil,name="吃料理界面",desc="",prefab="EatFoodPopUp",class="EatFoodPopUp", hideCollider = true},

    LotteryHeadwearView = {id=990,tab=nil,name="扭蛋头饰",desc="",prefab="LotteryHeadwearView",class="LotteryHeadwearView"},
    LotteryEquipView = {id=991,tab=nil,name="扭蛋装备",desc="",prefab="LotteryEquipView",class="LotteryEquipView"},
    LotteryCardView = {id=992,tab=nil,name="扭蛋卡片",desc="",prefab="LotteryCardView",class="LotteryCardView"},
    LotteryCatLitterBoxView = {id=993,tab=nil,name="福利猫砂盆",desc="",prefab="LotteryCatLitterBoxView",class="LotteryCatLitterBoxView"},
    LotteryMagicView = {id=994,tab=nil,name="扭蛋魔力",desc="",prefab="LotteryMagicView",class="LotteryMagicView"},
    LotteryExpressView = {id=995,tab=nil,name="扭蛋赠送",desc="",prefab="LotteryExpressView",class="LotteryExpressView",hideCollider=false},

    AuctionView = {id=1000,tab=nil,name="拍卖",desc="",prefab="AuctionView",class="AuctionView"},
    AuctionSignUpView = {id=1001,tab=nil,name="拍卖报名",desc="",prefab="AuctionSignUpView",class="AuctionSignUpView"},
    AuctionSignUpDetailView = {id=1002,tab=nil,name="拍卖报名详情",desc="",prefab="AuctionSignUpDetailView",class="AuctionSignUpDetailView"},
    AuctionRecordView = {id=1003,tab=nil,name="拍卖日志",desc="",prefab="AuctionRecordView",class="AuctionRecordView"},
    AuctionSignUpSelectView = {id=1004,tab=nil,name="拍卖报名选择",desc="",prefab="AuctionSignUpSelectView",class="AuctionSignUpSelectView"},

    SlotMachineView = {id = 1010, tab = nil, name = "拉霸机", desc = "", prefab = "SlotMachineView", class = "SlotMachineView"},
    PetCatchSuccessView = {id = 1011, tab = nil, name = "宠物捕获成功界面", desc = "", prefab = "PetCatchSuccessView", class = "PetCatchSuccessView"},
    PetMakeNamePopUp = {id = 1012, tab = nil, name = "宠物取名界面", desc = "", prefab = "PetMakeNamePopUp", class = "PetMakeNamePopUp"},
    PetInfoView = {id = 1020, tab = nil, name = "宠物详情界面", desc = "", prefab = "PetInfoView", class = "PetInfoView"},

    PetAdventureView = {id=1030,tab=nil,name="宠物冒险界面",desc="",prefab="PetAdventureView",class="PetAdventureView"},

    EyeLensesView = {id=1040,tab=nil,name="美瞳商店",desc="",prefab="EyeLensesView",class="EyeLensesView"},
    ClothDressingView = {id=1041,tab=nil,name="服装店",desc="",prefab="ClothDressingView",class="ClothDressingView"},


    GvgLandInfoPopUp = {id=1050,tab=nil,name="公会战争",desc="",prefab="GvgLandInfoPopUp",class="GvgLandInfoPopUp"},
    UniqueConfirmView_GvgLandGiveUp = {id=1055,tab=nil,name="公会据点放弃确认框",desc="",prefab="UniqueConfirmView",class="UniqueConfirmView_GvgLandGiveUp"},

    QuotaCardView = {id = 1060, tab = nil, name = "猫金打赏积分卡", desc = "", prefab = "QuotaCardView", class = "QuotaCardView"},

    QuickBuyView = {id=1070,tab=nil,name="快速购买",desc="",prefab="QuickBuyView",class="QuickBuyView"},

    BeingInfoView = {id=1080,tab=nil,name="快速购买",desc="",prefab="BeingInfoView",class="BeingInfoView"},

    GvGPvPPrayDialog = {id=1090,tab=nil,name="工会祈祷2.0",desc="",prefab="GvGPvPPrayDialog",class="GvGPvPPrayDialog"},

    PoringFightResultView = {id=1100,tab=nil,name="波利大乱斗结算界面",desc="",prefab="PoringFightResultView",class="PoringFightResultView"},

    -- overseas ui
    FaceBookFavPanel = {id = 100001 ,tab = nil, name = "点赞礼盒", desc = "", prefab = "FaceBookFavPanel", class = "FaceBookFavPanel"},
    LinePanel = {id = 100002 ,tab = nil, name = "Line", desc = ""},
    TXWYPlatPanel = {id = 100003 ,tab = nil, name = "TXWYPlat", desc = "", prefab = "TXWYPlatPanel", class = "TXWYPlatPanel",hideCollider = true},
    ServiceSettingPage = {id=100004,tab=5,name="客服设置",desc="",prefab="",class = "" },
    ShopConfirmPanel = {id = 100006 ,tab = nil, name = "ShopConfirmPanel", desc = "", prefab = "ShopConfirmPanel", class = "ShopConfirmPanel"},
    ReplenishmentPanel = {id = 100011 ,tab = nil, name = "海外补款", desc = "", prefab = "ReplenishmentPanel", class = "ReplenishmentPanel"},

    ZenyConvertPanel = {id = 100005 ,tab = nil, name = "ZenyConvertPanel", desc = "6300", prefab = "ZenyConvertPanel", class = "ZenyConvertPanel"},
    ZenyConvertPanel1 = {id = 100007 ,tab = nil, name = "ZenyConvertPanel", desc = "6301", prefab = "ZenyConvertPanel", class = "ZenyConvertPanel"},
    ZenyConvertPanel2 = {id = 100008 ,tab = nil, name = "ZenyConvertPanel", desc = "6302", prefab = "ZenyConvertPanel", class = "ZenyConvertPanel"},
    ZenyConvertPanel3 = {id = 100009 ,tab = nil, name = "ZenyConvertPanel", desc = "6303", prefab = "ZenyConvertPanel", class = "ZenyConvertPanel"},
    LangSwitchPanel = {id = 100010 ,tab = nil, name = "LangSwitchPanel", desc = "", prefab = "LangSwitchPanel", class = "LangSwitchPanel",hideCollider = true},
    StorePayPanel = {id = 100999 ,tab = nil, name = "StorePayPanel", desc = "", prefab = "StorePayPanel", class = "StorePayPanel"},

    RecallShareView = {id=1110,tab=nil,name="好友召回分享",desc="",prefab="RecallShareView",class="RecallShareView"},
    RecallContractSelectView = {id=1111,tab=nil,name="召回契约选择界面",desc="",prefab="RecallContractSelectView",class="RecallContractSelectView"},

    EquipUpgradePopUp = {id=1120,tab=nil,name="装备升级",desc="",prefab="EquipUpgradePopUp",class="EquipUpgradePopUp"},

    PoringFightTipView = {id=1130,tab=nil,name="波利乱斗Tip",desc="",prefab="PoringFightTipView",class="PoringFightTipView",hideCollider=true},

    GuildBuildingView ={id=1480,tab=nil,name="公会设施",desc="",prefab="GuildBuildingView",class="GuildBuildingView"},
    GuildBuildingMatSubmitView = {id=1490,tab=nil,name="公会设施提交材料",desc="",prefab="GuildBuildingMatSubmitView",class="GuildBuildingMatSubmitView"},
    GuildBuildingRankPopUp = {id=1491,tab=nil,name="公会设施贡献排行界面",desc="",prefab="GuildBuildingRankPopUp",class="GuildBuildingRankPopUp",hideCollider=true},

    RedeemCodeView = {id=1500,tab=nil,name="线下兑换",desc="",prefab="RedeemCodeView",class="RedeemCodeView"},

    ArtifactMakeView = {id=1510,tab=nil,name="制作神器",desc="",prefab="ArtifactMakeView",class="ArtifactMakeView"},
    ReturnArtifactView = {id=1520,tab=nil,name="返还神器",desc="",prefab="ReturnArtifactView",class="ReturnArtifactView"},
    ArtifactDistributePopUp = {id=1525,tab=nil,name="选择分配神器",desc="",prefab="ArtifactDistributePopUp",class="ArtifactDistributePopUp",hideCollider = true},

    RealNameCentifyView = {id=1530,tab=nil,name="实名认证",desc="",prefab="RealNameCentifyView",class="RealNameCentifyView",hideCollider=true},

    EngageMainView = {id=1540,tab=nil,name="订婚",desc="",prefab="EngageMainView",class="EngageMainView"},
    WeddingManualMainView = {id=1541,tab=nil,name="结婚手册",desc="",prefab="WeddingManualMainView",class="WeddingManualMainView"},
    WeddingProcessView = {id=1542,tab=nil,name="婚礼仪式详情",desc="",prefab="WeddingProcessView",class="WeddingProcessView"},
    WeddingPackageView = {id=1543,tab=nil,name="婚礼仪式套餐",desc="",prefab="WeddingPackageView",class="WeddingPackageView"},
    WeddingRingView = {id=1544,tab=nil,name="婚礼戒指套餐",desc="",prefab="HappyShop",class="WeddingRingView"},
    WeddingInviteView = {id=1545,tab=nil,name="婚礼邀请",desc="",prefab="WeddingInviteView",class="WeddingInviteView"},
    WeddingQuestionView = {id=1546,tab=nil,name="婚礼仪式问答",desc="",prefab="WeddingQuestionView",class="WeddingQuestionView"},
    SelectFriendView = {id=1547,tab=nil,name="选择好友",desc="",prefab="SelectFriendView",class="SelectFriendView"},

    GuildTreasureView = {id=1550,tab=nil,name="公会宝箱",desc="",prefab="GuildTreasureView",class="GuildTreasureView"},

    PetWorkSpaceView = {id=1560,tab=nil,name="宠物打工",desc="",prefab="PetWorkSpaceView",class="PetWorkSpaceView"},

    OricalCardInfoView = {id = 1570, tab = nil, name = "神谕牌卡牌预览界面", desc = "", prefab = "OricalCardInfoView", class = "OricalCardInfoView"},

    CardDecomposeView = {id=1580,tab=nil,name="卡片分解",desc="",prefab="CardDecomposeView",class="CardDecomposeView"},

    EnchantTransferView = {id=1590,tab=nil,name="附魔转移",desc="",prefab="EnchantTransferView",class="EnchantTransferView",hideCollider=false},
    RaidEnterWaitView = {id = 1600, tab = nil, name = "副本进入等待界面", desc = "", prefab = "EndlessTowerWaitView", class = "RaidEnterWaitView"},

    GuildTreasureRewardPopUp = {id=1610,tab=nil,name="公会宝箱红包界面",desc="",prefab="GuildTreasureRewardPopUp",class="GuildTreasureRewardPopUp"},

    ServantMainView = {id=1620,tab=nil,name="女仆",desc="",prefab="ServantMainView",class="ServantMainView"},
    ServantRecommendView = {id=1621,tab=1,name="今日推荐",desc="",prefab="ServantRecommendView",class="ServantRecommendView"},
    FinanceView = {id=1622,tab=2,name="今日财经",desc="",prefab="FinanceView",class="FinanceView"},
    ServantStrengthenView = {id=1623,tab=3,name="提升一览",desc="",prefab="ServantStrengthenView",class="ServantStrengthenView"},

    GVGPortalView = {id=1630,tab=nil,name="GVG决战传送门",desc="",prefab="GVGPortalView",class="GVGPortalView"},
    GVGResultView = {id=1631,tab=nil,name="GVG决战结果",desc="",prefab="GVGResultView",class="GVGResultView"},
    GVGDetailView = {id=1632,tab=nil,name="GVG决战详细信息",desc="",prefab="GVGDetailView",class="GVGDetailView"},

    MVPResultView = {id=1640,tab=nil,name="MVP结算",desc="",prefab="MVPResultView",class="MVPResultView"},
    MvpMatchView = {id=1641,tab=nil,name="MVP匹配",desc="",prefab="MvpMatchView",class="MvpMatchView"},

    WebviewPanel = {id = 1650, tab = nil, name = "内置浏览器", desc = "", prefab = "WebviewPanel", class = "WebviewPanel"},

    TutorMatchView = {id=1670,tab=nil,name="导师匹配",desc="",prefab="TutorMatchView",class="TutorMatchView",hideCollider=true},
    TutorMatchResultView = {id=1671,tab=nil,name="导师匹配结果",desc="",prefab="TutorMatchResultView",class="TutorMatchResultView",hideCollider=true},

    BoothMainView = {id=1680,tab=nil,name="摆摊主",desc="",prefab="BoothMainView",class="BoothMainView"},
    BoothExchangeView = {id=1681,tab=1,name="摆摊交易",desc="",prefab="BoothMainView",class="BoothExchangeView"},
    BoothRecordView = {id=1682,tab=2,name="摆摊日志",desc="",prefab="BoothMainView",class="BoothRecordView"},
    BoothNameView = {id=1683,tab=nil,name="摆摊名称",desc="",prefab="BoothNameView",class="BoothNameView"},
    BoothSellInfoView = {id=1684,tab=nil,name="摆摊卖详情",desc="",prefab="BoothExchangeInfoView",class="BoothSellInfoView"},
    BoothBuyInfoView = {id=1685,tab=nil,name="摆摊买详情",desc="",prefab="BoothExchangeInfoView",class="BoothBuyInfoView"},

    --测试专用界面,正常使用界面请放上面
    ActivePanel = {id = 10004,tab=nil,name="激活界面",desc="",prefab="ActivePanel",class="ActivePanel"},
    TempActivityView = {id = 10005,tab=nil,name="运营活动",desc="",prefab="TempActivityView",class="TempActivityView", hideCollider = true},
    ActiveErrorBord = {id = 10006,tab=nil,name="激活错误弹框",desc="",prefab="ActiveErrorBord",class="ActiveErrorBord"},
    RolesSelect = {id = 10009, tab = nil, name = "角色选择", desc = "", prefab = "UIViewRolesList", class = "UIViewControllerRolesList"},


    SecurityPanel = {id = 10010, tab = nil, name = "安全验证", desc = "", prefab = "SecurityPanel", class = "SecurityPanel"},
    AgreementPanel = {id = 10020, tab = nil, name = "许可协议", desc = "", prefab = "AgreementPanel", class = "AgreementPanel"},

    ActivityDetailPanel = {id = 10030, tab = nil, name = "活动详情", desc = "", prefab = "ActivityDetailPanel", class = "ActivityDetailPanel"},
    MiyinStrengthen = {id = 10040, tab = nil, name = "秘银强化", desc = "", prefab = "UIViewMiyinStrengthen", class = "UIViewControllerMiyinStrengthen"},
    MarriageCertificate = {id = 10050, tab = nil, name = "结婚证书", desc = "", prefab = "MarriageCertificate", class = "MarriageCertificate"},
    MarriageManualPicDiy = {id = 10051, tab = nil, name = "结婚手册diy证书", desc = "", prefab = "MarriageManualPicDiy", class = "MarriageManualPicDiy"},
    KFCActivityShowView = {id = 10061, tab = nil, name = "kfc活动分享", desc = "", prefab = "KFCActivityShowView", class = "KFCActivityShowView"},
    HouseKeeperView = {id = 10071, tab = nil, name = "女仆", desc = "", prefab = "HouseKeeperView", class = "HouseKeeperView"},
    LotteryMagicView = {id=994,tab=nil,name="扭蛋魔力",desc="",prefab="LotteryMagicView",class="LotteryMagicView"},

}
