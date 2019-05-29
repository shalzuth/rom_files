Table_PlotQuest_10 = {
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
    Params = {name = "CameraP1", time = 10}
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
      path = "Common/HailaAltal_2001"
    }
  },
  [6] = {
    id = 6,
    Type = "scene_action",
    Params = {uniqueid = 8808, id = 502}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 7000}
  },
  [8] = {
    id = 8,
    Type = "reset_camera",
    Params = _EmptyTable
  }
}
Table_PlotQuest_10_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_10
