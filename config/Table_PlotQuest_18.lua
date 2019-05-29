Table_PlotQuest_18 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 4000}
  },
  [3] = {
    id = 3,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = true}
  },
  [4] = {
    id = 4,
    Type = "play_sound",
    Params = {
      path = "Common/1thFireworks5"
    }
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [6] = {
    id = 6,
    Type = "onoff_camerapoint",
    Params = {groupid = 0, on = false}
  }
}
Table_PlotQuest_18_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_18
