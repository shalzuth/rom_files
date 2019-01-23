--[[
    --说明:
        界面显示/隐藏的方式枚举
    --配置说明:
        CreateAndDestroy 创建/销毁
        ActiveAndDeactive 设置激活/非激活
        MoveOutAndMoveIn 移除到远处/移动回来
]]
LayerShowHideMode = {
    ActiveAndDeactive = 1,
    MoveOutAndMoveIn = 2
}

--[[
    --说明：
        层级的配置
        此配置由策划维护
    --配置格式:
        xxLayer         每个layer的配置
        name            层级的名字
        depth           层级深度，数值越大，显示越前面，并且每个layer下可最多同时出现15个UIPanel
        reEntnerNotDestory          再该层级已打开的情况下，不会销毁原来的层级
        hideOtherLayer  该层级显示时，需隐藏的其他层级
        closeOtherLayer 该层级显示时，需关闭的其他层级
        coliderColor    层级挡板的颜色（不配置该项的话，便认作为此层级无底部挡板)
        showHideMode    显示隐藏模式
]]
UIViewType = {
    SceneNameLayer = {
        name = "角色场景UI" ,
        depth = 0
    },
    BlindLayer = {
        name = "场景致盲遮罩" ,
        depth = 1
    },
    MainLayer = {
        name = "主界面" ,
        depth = 2,
        reEntnerNotDestory = true,
        showHideMode = LayerShowHideMode.ActiveAndDeactive,
    },
    ReviveLayer = {
        name = "复活层级" ,
        depth = 3,
        closeOtherLayer = {CheckLayer={},NormalLayer={},PopUpLayer={},TipLayer={},FocusLayer={},DialogLayer={},ChatroomLayer={},ChitchatLayer={},ChatLayer={},ShieldingLayer={}},
        hideOtherLayer = {GuideLayer={},Popup10Layer={},SystemOpenLayer={},GOGuideLayer={}},
    },
    ChatroomLayer = {
        name = "好友" ,
        depth = 4,
        closeOtherLayer = {FocusLayer={},DialogLayer={},TipLayer={},TeamLayer={},ChatLayer={}},
    },
    BoothLayer = {
        name = "摆摊" ,
        depth = 5,
		hideOtherLayer = {MainLayer={}},
        closeOtherLayer = {FocusLayer={},DialogLayer={},TipLayer={},TeamLayer={},ChatLayer={}},
    },
	InterstitialLayer = {
        name = "全屏界面" ,
        depth = 6,
        coliderColor = Color(0,0,0,1/255),
        hideOtherLayer = {ChatroomLayer={},DialogLayer={},BoothLayer={}},
        closeOtherLayer = {ChatLayer={},FocusLayer={},TeamLayer={},NormalLayer={}},
    },
    ChitchatLayer = {
        name = "聊天栏(左)" ,
        depth = 7,
        closeOtherLayer = {FocusLayer={},DialogLayer={},TipLayer={},TeamLayer={},ChatLayer={},NormalLayer={}},
        reEntnerNotDestory = true,
    },
    TeamLayer = {
        name = "组队界面（不屏蔽主界面）" ,
        depth = 8,
        coliderColor = Color(0,0,0,1/255),
        hideOtherLayer = {ChatroomLayer={},NormalLayer={},ChitchatLayer={},BoothLayer={}},
        closeOtherLayer = {ChatLayer={},TipLayer={}},
    },
    UIScreenEffectLayer = {
        name = "全屏UI特效层",
        depth = 9,
    },
    FocusLayer = {
        name = "聚焦层级" ,
        depth = 10,
        hideOtherLayer = {MainLayer={},CheckLayer={},NormalLayer={},TipLayer={},ChatroomLayer={},BoothLayer={},ChitchatLayer={},TeamLayer={}},
        closeOtherLayer = {ChatLayer={}},
    },
    DialogLayer = {
        name = "对话层级" ,
        depth = 11,
        hideOtherLayer = {CheckLayer={},MainLayer={},NormalLayer={},ChatroomLayer={},BoothLayer={},ChitchatLayer={},TeamLayer={},MovieLayer={}},
        closeOtherLayer = {FocusLayer={},PopUpLayer={},TipLayer={},ChatLayer={}},
    },
    ChatLayer = {
        name = "表情聊天层级" ,
        depth = 12,
    },
    NormalLayer = {
        name = "二级界面层级" ,
        depth = 13,
        coliderColor = Color(0,0,0,1/255),
        hideOtherLayer = {MainLayer={},ChatroomLayer={},ChitchatLayer={}},
        closeOtherLayer = {ChatLayer={},FocusLayer={}},
    },
    PopUpLayer = {
        name = "三级弹出界面层级" ,
        depth = 14,
        coliderColor = Color(0,0,0,200/255),
    },
    CheckLayer = {
        name = "查看详情层级" ,
        depth = 15,
        hideOtherLayer = {MainLayer={},ChatroomLayer={},ChitchatLayer={},PopUpLayer={},NormalLayer={},TeamLayer={},},
        closeOtherLayer = {ChatLayer={}},
    },
    DragLayer = {
        name = "拖动层级" ,
        depth = 16,
    },
    TipLayer = {
        name = "提示界面层级" ,
        depth = 17,
    },
    Lv4PopUpLayer = {
        name = "四级弹出层级" ,
        depth = 18,
        coliderColor = Color(0,0,0,200/255),
    },
    IConfirmLayer = {
        name = "邀请确认层级" ,
        depth = 19,
        hideOtherLayer = {},
        closeOtherLayer = {FocusLayer={}},
    },
    ConfirmLayer = {
        name = "确认框层级" ,
        depth = 20,
        coliderColor = Color(0,0,0,1/255),
    },
    GuideLayer = {
        name = "引导层级" ,
        depth = 21,
    },
    SystemOpenLayer = {
        name = "系统开启层级" ,
        depth = 22,
        hideOtherLayer = {FocusLayer={},CheckLayer={},NormalLayer={},PopUpLayer={},TipLayer={},GuideLayer={},ConfirmLayer={},Popup10Layer={},ChatroomLayer={},ChitchatLayer={},TeamLayer={}},
        closeOtherLayer = {ChatLayer={}},
        coliderColor = Color(0,0,0,1/255),
        reEntnerNotDestory = true,
        showHideMode = LayerShowHideMode.ActiveAndDeactive,
    },
    MovieLayer = {
        name = "观看电影层级" ,
        depth = 23,
        hideOtherLayer = {FocusLayer={},MainLayer={},CheckLayer={},NormalLayer={},PopUpLayer={},TipLayer={},BoardLayer={},GuideLayer={},DragLayer={},ConfirmLayer={},Popup10Layer={},ChatroomLayer={},ChitchatLayer={}},
        closeOtherLayer = {ChatLayer={}},
        coliderColor = Color(0,0,0,1/255),
    },
    GOGuideLayer = {
        name = "引导开始确认层" ,
        depth = 24,
        closeOtherLayer = {FocusLayer={},CheckLayer={},NormalLayer={},PopUpLayer={},TipLayer={},GuideLayer={},ConfirmLayer={},Popup10Layer={},ChatLayer={},ChatroomLayer={},ChitchatLayer={},TeamLayer={},Show3D2DLayer={},ProcessLayer={}},
        coliderColor = Color(0,0,0,1/255),
        reEntnerNotDestory = true,
    },
    Show3D2DLayer = {
        name = "3D/2D展示层级" ,
        depth = 25,
        hideOtherLayer = {FocusLayer={},TipLayer={},Popup10Layer={},DialogLayer={},SystemOpenLayer={},MainLayer={},NormalLayer={},PopUpLayer={},CheckLayer={},TeamLayer={},ChitchatLayer={},ChatroomLayer={}},
        coliderColor = Color(0,0,0,200/255),
    },
    ShareLayer = {
        name = "分享层级" ,
        depth = 26,
        hideOtherLayer = {FocusLayer={},TipLayer={},Popup10Layer={},DialogLayer={},SystemOpenLayer={},MainLayer={},NormalLayer={},PopUpLayer={},CheckLayer={},TeamLayer={},ChitchatLayer={},ChatroomLayer={},Show3D2DLayer={}},
    },
    FloatLayer = {
        name = "浮动框层级" ,
        depth = 27,
    },
    Popup10Layer = {
        name = "弹框10层级" ,
        depth = 28,
        coliderColor = Color(0,0,0,1/255),
        reEntnerNotDestory = true,
        closeOtherLayer = {TipLayer={},TeamLayer={},ChatLayer={}},
        showHideMode = LayerShowHideMode.ActiveAndDeactive,
    },
    LoadingLayer = {
        name = "加载界面层级" ,
        depth = 29,
        hideOtherLayer = {MainLayer={},ChatLayer={}},
        closeOtherLayer = {FocusLayer={}},
        coliderColor = Color(0,0,0,1/255),
    },
    TouchLayer = {
        name = "UI触摸反馈层级" ,
        depth = 30,

    },
    ToolsLayer = {
        name = "工具层级" ,
        depth = 31,
    },
    WarnLayer = {
        name = "警告框层级" ,
        depth = 32,
        reEntnerNotDestory = true,
    },
    ShieldingLayer = {
        name = "屏保层级" ,
        depth = 33,
        coliderColor = Color(0,0,0,1/255),
    },
    VideoLayer = {
        name = "视频（珍藏品）播放层级" ,
        depth = 34,
        hideOtherLayer = {IConfirmLayer={},BoardLayer={},ConfirmLayer={},Popup10Layer={},ChatroomLayer={},ChitchatLayer={},ReviveLayer={}},
        coliderColor = Color(0,0,0,1/255),
    },
    ProcessLayer = {
        name = "弹幕层级" ,
        depth = 35,
        reEntnerNotDestory = true,
    },
    BoardLayer = {
        name = "公告层级" ,
        depth = 36,
        reEntnerNotDestory = true,
    },
}

    ----------界面返回属性的配置----------------------
    UIRollBackID = {
    353,352,3,720,495,1070,547,1620
}


