Table_PlotQuest_15 = {
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
    Params = {time = 1800}
  },
  [4] = {
    id = 4,
    Type = "onoff_camerapoint",
    Params = {groupid = 3, on = true}
  },
  [5] = {
    id = 5,
    Type = "summon",
    Params = {
      npcid = 8911,
      npcuid = 8911,
      groupid = 1,
      pos = {
        -17.77,
        -0.29,
        30.98
      },
      dir = 90
    }
  },
  [6] = {
    id = 6,
    Type = "summon",
    Params = {
      npcid = 8912,
      npcuid = 8912,
      groupid = 1,
      pos = {
        -17.75,
        -0.29,
        29.43
      },
      dir = 90
    }
  },
  [7] = {
    id = 7,
    Type = "summon",
    Params = {
      npcid = 8913,
      npcuid = 8913,
      groupid = 1,
      pos = {
        -17.77,
        -0.29,
        32.44
      },
      dir = 90
    }
  },
  [8] = {
    id = 8,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [9] = {
    id = 9,
    Type = "addbutton",
    Params = {
      id = 1,
      text = "\229\188\128\229\167\139",
      eventtype = "goon"
    }
  },
  [10] = {
    id = 10,
    Type = "wait_ui",
    Params = {button = 1}
  },
  [11] = {
    id = 11,
    Type = "move",
    Params = {
      npcuid = 8911,
      pos = {
        -17.75,
        -0.29,
        29.43
      },
      dir = 90,
      spd = 1.2
    }
  },
  [12] = {
    id = 12,
    Type = "move",
    Params = {
      npcuid = 8912,
      pos = {
        -17.77,
        -0.29,
        32.44
      },
      dir = 90,
      spd = 0.6
    }
  },
  [13] = {
    id = 13,
    Type = "move",
    Params = {
      npcuid = 8913,
      pos = {
        -17.77,
        -0.29,
        30.98
      },
      dir = 90,
      spd = 0.6
    }
  },
  [14] = {
    id = 14,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [15] = {
    id = 15,
    Type = "move",
    Params = {
      npcuid = 8911,
      pos = {
        -17.77,
        -0.29,
        32.44
      },
      dir = 90,
      spd = 1.2
    }
  },
  [16] = {
    id = 16,
    Type = "move",
    Params = {
      npcuid = 8912,
      pos = {
        -17.77,
        -0.29,
        30.98
      },
      dir = 90,
      spd = 0.6
    }
  },
  [17] = {
    id = 17,
    Type = "move",
    Params = {
      npcuid = 8913,
      pos = {
        -17.75,
        -0.29,
        29.43
      },
      dir = 90,
      spd = 0.6
    }
  },
  [18] = {
    id = 18,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [19] = {
    id = 19,
    Type = "move",
    Params = {
      npcuid = 8911,
      pos = {
        -17.77,
        -0.29,
        32.44
      },
      dir = 90,
      spd = 1.2
    }
  },
  [20] = {
    id = 20,
    Type = "move",
    Params = {
      npcuid = 8912,
      pos = {
        -17.75,
        -0.29,
        29.43
      },
      dir = 90,
      spd = 0.6
    }
  },
  [21] = {
    id = 21,
    Type = "move",
    Params = {
      npcuid = 8913,
      pos = {
        -17.77,
        -0.29,
        30.98
      },
      dir = 90,
      spd = 0.6
    }
  },
  [22] = {
    id = 22,
    Type = "wait_time",
    Params = {time = 2000}
  },
  [23] = {
    id = 23,
    Type = "addbutton",
    Params = {
      id = 2,
      text = "\231\156\139\230\184\133\228\186\134",
      eventtype = "goon"
    }
  },
  [24] = {
    id = 24,
    Type = "wait_ui",
    Params = {button = 2}
  },
  [25] = {
    id = 25,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  },
  [26] = {
    id = 26,
    Type = "wait_time",
    Params = {time = 2000}
  }
}
Table_PlotQuest_15_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_15
