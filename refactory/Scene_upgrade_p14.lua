local Scene_upgrade_p14 = {
  PVE = {
    bps = {
      {
        ID = 1,
        position = {
          -10.3800001144409,
          -0.330000013113022,
          -26.6200008392334
        },
        range = 0
      }
    },
    eps = {
      {
        ID = 1,
        commonEffectID = 16,
        position = {
          -10.8800001144409,
          -0.300000011920929,
          27.3200016021729
        },
        nextSceneID = 63,
        nextSceneBornPointID = 7,
        type = 0,
        range = 1
      }
    }
  },
  Raids = {
    [50043] = {
      bps = {
        {
          ID = 1,
          position = {
            0.139996200799942,
            0.839999973773956,
            40.120002746582
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -39.0000038146973,
            1.4099999666214,
            0.00999832153320313
          },
          nextSceneID = 0,
          nextSceneBornPointID = 4,
          type = 0,
          range = 1
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 0,
          position = {
            -9.9640007019043,
            4.44000005722046,
            -0.219000816345215
          }
        }
      }
    },
    [601023] = {
      bps = {
        {
          ID = 1,
          position = {
            -10.3199996948242,
            -0.0540000051259995,
            -26.7199993133545
          },
          range = 0
        }
      },
      eps = {
        {
          ID = 1,
          commonEffectID = 16,
          position = {
            -10.460000038147,
            0.245999991893768,
            26.7000007629395
          },
          nextSceneID = 1,
          nextSceneBornPointID = 1,
          type = 0,
          range = 1
        }
      },
      nps = {
        {
          uniqueID = 1,
          ID = 56107,
          position = {
            -3.49054741859436,
            0.231298983097076,
            -16.9099731445313
          }
        },
        {
          uniqueID = 2,
          ID = 56108,
          position = {
            -4.61054754257202,
            0.231298983097076,
            -2.06997299194336
          }
        },
        {
          uniqueID = 3,
          ID = 56109,
          position = {
            -1.60054743289948,
            0.231298983097076,
            17.8700256347656
          }
        }
      }
    }
  },
  MapInfo = {
    MinPos = {x = -32.5, y = -32.5},
    Size = {x = 65, y = 65}
  }
}
return Scene_upgrade_p14
