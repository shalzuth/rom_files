LayerShowHideMode = {ActiveAndDeactive = 1, MoveOutAndMoveIn = 2}
UIViewType = {
  SceneNameLayer = {
    name = "\232\167\146\232\137\178\229\156\186\230\153\175UI",
    depth = 0
  },
  BlindLayer = {
    name = "\229\156\186\230\153\175\232\135\180\231\155\178\233\129\174\231\189\169",
    depth = 1
  },
  MainLayer = {
    name = "\228\184\187\231\149\140\233\157\162",
    depth = 2,
    reEntnerNotDestory = true,
    showHideMode = LayerShowHideMode.ActiveAndDeactive
  },
  ReviveLayer = {
    name = "\229\164\141\230\180\187\229\177\130\231\186\167",
    depth = 3,
    closeOtherLayer = {
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      FocusLayer = {},
      DialogLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      ChatLayer = {},
      ShieldingLayer = {}
    },
    hideOtherLayer = {
      GuideLayer = {},
      Popup10Layer = {},
      SystemOpenLayer = {},
      GOGuideLayer = {}
    }
  },
  ChatroomLayer = {
    name = "\229\165\189\229\143\139",
    depth = 4,
    closeOtherLayer = {
      FocusLayer = {},
      DialogLayer = {},
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {}
    }
  },
  BoothLayer = {
    name = "\230\145\134\230\145\138",
    depth = 5,
    hideOtherLayer = {
      MainLayer = {}
    },
    closeOtherLayer = {
      FocusLayer = {},
      DialogLayer = {},
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {}
    }
  },
  InterstitialLayer = {
    name = "\229\133\168\229\177\143\231\149\140\233\157\162",
    depth = 6,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      ChatroomLayer = {},
      DialogLayer = {},
      BoothLayer = {},
      MainLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      FocusLayer = {},
      TeamLayer = {},
      NormalLayer = {}
    }
  },
  ChitchatLayer = {
    name = "\232\129\138\229\164\169\230\160\143(\229\183\166)",
    depth = 7,
    closeOtherLayer = {
      FocusLayer = {},
      DialogLayer = {},
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {},
      NormalLayer = {}
    },
    reEntnerNotDestory = true
  },
  TeamLayer = {
    name = "\231\187\132\233\152\159\231\149\140\233\157\162\239\188\136\228\184\141\229\177\143\232\148\189\228\184\187\231\149\140\233\157\162\239\188\137",
    depth = 8,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      ChatroomLayer = {},
      NormalLayer = {},
      ChitchatLayer = {},
      BoothLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      TipLayer = {}
    }
  },
  UIScreenEffectLayer = {
    name = "\229\133\168\229\177\143UI\231\137\185\230\149\136\229\177\130",
    depth = 9
  },
  FocusLayer = {
    name = "\232\129\154\231\132\166\229\177\130\231\186\167",
    depth = 10,
    hideOtherLayer = {
      MainLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      TipLayer = {},
      ChatroomLayer = {},
      BoothLayer = {},
      ChitchatLayer = {},
      TeamLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {}
    }
  },
  DialogLayer = {
    name = "\229\175\185\232\175\157\229\177\130\231\186\167",
    depth = 11,
    hideOtherLayer = {
      CheckLayer = {},
      MainLayer = {},
      NormalLayer = {},
      ChatroomLayer = {},
      BoothLayer = {},
      ChitchatLayer = {},
      TeamLayer = {},
      MovieLayer = {}
    },
    closeOtherLayer = {
      FocusLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      ChatLayer = {}
    }
  },
  ChatLayer = {
    name = "\232\161\168\230\131\133\232\129\138\229\164\169\229\177\130\231\186\167",
    depth = 12
  },
  NormalLayer = {
    name = "\228\186\140\231\186\167\231\149\140\233\157\162\229\177\130\231\186\167",
    depth = 13,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    hideOtherLayer = {
      MainLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {},
      FocusLayer = {}
    }
  },
  PopUpLayer = {
    name = "\228\184\137\231\186\167\229\188\185\229\135\186\231\149\140\233\157\162\229\177\130\231\186\167",
    depth = 14,
    coliderColor = Color(0, 0, 0, 0.7843137254901961)
  },
  CheckLayer = {
    name = "\230\159\165\231\156\139\232\175\166\230\131\133\229\177\130\231\186\167",
    depth = 15,
    hideOtherLayer = {
      MainLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      PopUpLayer = {},
      NormalLayer = {},
      TeamLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {}
    }
  },
  DragLayer = {
    name = "\230\139\150\229\138\168\229\177\130\231\186\167",
    depth = 16
  },
  TipLayer = {
    name = "\230\143\144\231\164\186\231\149\140\233\157\162\229\177\130\231\186\167",
    depth = 17
  },
  Lv4PopUpLayer = {
    name = "\229\155\155\231\186\167\229\188\185\229\135\186\229\177\130\231\186\167",
    depth = 18,
    coliderColor = Color(0, 0, 0, 0.7843137254901961)
  },
  IConfirmLayer = {
    name = "\233\130\128\232\175\183\231\161\174\232\174\164\229\177\130\231\186\167",
    depth = 19,
    hideOtherLayer = {},
    closeOtherLayer = {
      FocusLayer = {}
    }
  },
  ConfirmLayer = {
    name = "\231\161\174\232\174\164\230\161\134\229\177\130\231\186\167",
    depth = 20,
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  GuideLayer = {
    name = "\229\188\149\229\175\188\229\177\130\231\186\167",
    depth = 21
  },
  SystemOpenLayer = {
    name = "\231\179\187\231\187\159\229\188\128\229\144\175\229\177\130\231\186\167",
    depth = 22,
    hideOtherLayer = {
      FocusLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      GuideLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      TeamLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    reEntnerNotDestory = true,
    showHideMode = LayerShowHideMode.ActiveAndDeactive
  },
  MovieLayer = {
    name = "\232\167\130\231\156\139\231\148\181\229\189\177\229\177\130\231\186\167",
    depth = 23,
    hideOtherLayer = {
      FocusLayer = {},
      MainLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      BoardLayer = {},
      GuideLayer = {},
      DragLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatroomLayer = {},
      ChitchatLayer = {}
    },
    closeOtherLayer = {
      ChatLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  GOGuideLayer = {
    name = "\229\188\149\229\175\188\229\188\128\229\167\139\231\161\174\232\174\164\229\177\130",
    depth = 24,
    closeOtherLayer = {
      FocusLayer = {},
      CheckLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      TipLayer = {},
      GuideLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatLayer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      TeamLayer = {},
      Show3D2DLayer = {},
      ProcessLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    reEntnerNotDestory = true
  },
  Show3D2DLayer = {
    name = "3D/2D\229\177\149\231\164\186\229\177\130\231\186\167",
    depth = 25,
    hideOtherLayer = {
      FocusLayer = {},
      TipLayer = {},
      Popup10Layer = {},
      DialogLayer = {},
      SystemOpenLayer = {},
      MainLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      CheckLayer = {},
      TeamLayer = {},
      ChitchatLayer = {},
      ChatroomLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.7843137254901961)
  },
  ShareLayer = {
    name = "\229\136\134\228\186\171\229\177\130\231\186\167",
    depth = 26,
    hideOtherLayer = {
      FocusLayer = {},
      TipLayer = {},
      Popup10Layer = {},
      DialogLayer = {},
      SystemOpenLayer = {},
      MainLayer = {},
      NormalLayer = {},
      PopUpLayer = {},
      CheckLayer = {},
      TeamLayer = {},
      ChitchatLayer = {},
      ChatroomLayer = {},
      Show3D2DLayer = {}
    }
  },
  FloatLayer = {
    name = "\230\181\174\229\138\168\230\161\134\229\177\130\231\186\167",
    depth = 27
  },
  Popup10Layer = {
    name = "\229\188\185\230\161\13410\229\177\130\231\186\167",
    depth = 28,
    coliderColor = Color(0, 0, 0, 0.00392156862745098),
    reEntnerNotDestory = true,
    closeOtherLayer = {
      TipLayer = {},
      TeamLayer = {},
      ChatLayer = {}
    },
    showHideMode = LayerShowHideMode.ActiveAndDeactive
  },
  LoadingLayer = {
    name = "\229\138\160\232\189\189\231\149\140\233\157\162\229\177\130\231\186\167",
    depth = 29,
    hideOtherLayer = {
      MainLayer = {},
      ChatLayer = {}
    },
    closeOtherLayer = {
      FocusLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  TouchLayer = {
    name = "UI\232\167\166\230\145\184\229\143\141\233\166\136\229\177\130\231\186\167",
    depth = 30
  },
  ToolsLayer = {
    name = "\229\183\165\229\133\183\229\177\130\231\186\167",
    depth = 31
  },
  WarnLayer = {
    name = "\232\173\166\229\145\138\230\161\134\229\177\130\231\186\167",
    depth = 32,
    reEntnerNotDestory = true
  },
  ShieldingLayer = {
    name = "\229\177\143\228\191\157\229\177\130\231\186\167",
    depth = 33,
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  VideoLayer = {
    name = "\232\167\134\233\162\145\239\188\136\231\143\141\232\151\143\229\147\129\239\188\137\230\146\173\230\148\190\229\177\130\231\186\167",
    depth = 34,
    hideOtherLayer = {
      IConfirmLayer = {},
      BoardLayer = {},
      ConfirmLayer = {},
      Popup10Layer = {},
      ChatroomLayer = {},
      ChitchatLayer = {},
      ReviveLayer = {}
    },
    coliderColor = Color(0, 0, 0, 0.00392156862745098)
  },
  ProcessLayer = {
    name = "\229\188\185\229\185\149\229\177\130\231\186\167",
    depth = 35,
    reEntnerNotDestory = true
  },
  BoardLayer = {
    name = "\229\133\172\229\145\138\229\177\130\231\186\167",
    depth = 36,
    reEntnerNotDestory = true
  }
}
UIRollBackID = {
  353,
  352,
  3,
  720,
  495,
  1070,
  547,
  1620
}
