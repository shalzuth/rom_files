Table_PlotQuest_9 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 1800}
  },
  [3] = {
    id = 3,
    Type = "startfilter",
    Params = {
      fliter = {22}
    }
  },
  [4] = {
    id = 4,
    Type = "scene_action",
    Params = {uniqueid = 4748, id = 508}
  },
  [5] = {
    id = 5,
    Type = "play_sound",
    Params = {
      path = "Common/CrystalTower_5_1"
    }
  },
  [6] = {
    id = 6,
    Type = "play_camera_anim",
    Params = {name = "Camera5", time = 19}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 18000}
  },
  [8] = {
    id = 8,
    Type = "reset_camera",
    Params = _EmptyTable
  },
  [9] = {
    id = 9,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_9_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_9
