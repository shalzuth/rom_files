Table_PlotQuest_13 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "startfilter",
    Params = {
      fliter = {22}
    }
  },
  [3] = {
    id = 3,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [4] = {
    id = 4,
    Type = "play_sound",
    Params = {
      path = "Common/JumpFly"
    }
  },
  [5] = {
    id = 5,
    Type = "play_camera_anim",
    Params = {name = "Camera1", time = 16}
  },
  [6] = {
    id = 6,
    Type = "wait_time",
    Params = {time = 15000}
  },
  [7] = {
    id = 7,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  },
  [8] = {
    id = 8,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_13_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_13
