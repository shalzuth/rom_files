Table_PlotQuest_11 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [3] = {
    id = 3,
    Type = "play_camera_anim",
    Params = {name = "CameraP2", time = 8.5}
  },
  [4] = {
    id = 4,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [5] = {
    id = 5,
    Type = "play_sound",
    Params = {
      path = "Common/HailaAltal_3001"
    }
  },
  [6] = {
    id = 6,
    Type = "scene_action",
    Params = {uniqueid = 8809, id = 504}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 6000}
  },
  [8] = {
    id = 8,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_11_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_11
