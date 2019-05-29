Table_EquipEnchant = {
  [1] = {
    id = 1,
    UniqID = 1001,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Vit",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 4}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [2] = {
    id = 2,
    UniqID = 1002,
    AttrType = "Str"
  },
  [3] = {
    id = 3,
    UniqID = 1003,
    AttrType = "Int"
  },
  [5] = {
    id = 5,
    UniqID = 1005,
    AttrType = "Dex"
  },
  [6] = {
    id = 6,
    UniqID = 1006,
    AttrType = "Agi"
  },
  [4] = {
    id = 4,
    UniqID = 1004,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Luk",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 2}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      ShieldRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [7] = {
    id = 7,
    UniqID = 1007,
    AttrType = "MaxHp",
    AttrBound = {
      {1, 160}
    }
  },
  [8] = {
    id = 8,
    UniqID = 1008,
    AttrType = "MaxSp",
    AttrBound = {
      {1, 16}
    }
  },
  [9] = {
    id = 9,
    UniqID = 1009,
    AttrType = "Atk",
    AttrBound = {
      {1, 8}
    }
  },
  [10] = {
    id = 10,
    UniqID = 1010,
    AttrType = "MAtk",
    AttrBound = {
      {1, 8}
    }
  },
  [11] = {
    id = 11,
    UniqID = 1011,
    AttrType = "Def",
    AttrBound = {
      {1, 4}
    }
  },
  [12] = {
    id = 12,
    UniqID = 1012,
    AttrType = "MDef",
    AttrBound = {
      {1, 8}
    }
  },
  [13] = {
    id = 13,
    UniqID = 2001,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Vit",
    AttrType2 = {"MDef"},
    Condition = {refinelv = 6, type = 1},
    Name = "\231\165\158\228\189\145",
    Dsc = "\233\173\148\230\179\149\228\188\164\229\174\179\229\135\143\229\133\141",
    ComBineAttr = "\228\189\147\232\180\168+\233\173\148\230\179\149\233\152\178\229\190\161",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      ShieldRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [14] = {
    id = 14,
    UniqID = 2002,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Str",
    AttrType2 = {"Atk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\230\150\151\229\191\151",
    Dsc = "\229\191\189\232\167\134\231\137\169\231\144\134\233\152\178\229\190\161",
    ComBineAttr = "\229\138\155\233\135\143+\231\137\169\231\144\134\230\148\187\229\135\187",
    AttrSectionDsc = "5%~20%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [15] = {
    id = 15,
    UniqID = 2003,
    AttrType = "Int",
    AttrType2 = {"MAtk"},
    Name = "\233\173\148\229\138\155",
    Dsc = "\229\144\159\229\148\177\233\128\159\229\186\166\231\188\169\231\159\173",
    ComBineAttr = "\230\153\186\229\138\155+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2.5%~10%",
    NoExchangeEnchant = {
      AxeRate = 1,
      BowRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      SpearRate = 1,
      SwordRate = 1
    }
  },
  [17] = {
    id = 17,
    UniqID = 2005,
    AttrType = "Dex",
    AttrType2 = {"Hit"},
    Name = "\229\144\141\229\188\147",
    Dsc = "\232\191\156\231\168\139\231\137\169\231\144\134\230\148\187\229\135\187\229\162\158\229\138\160",
    ComBineAttr = "\231\129\181\229\183\167+\229\145\189\228\184\173",
    AttrSectionDsc = "2.5%~10%",
    NoExchangeEnchant = {
      AxeRate = 1,
      MaceRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [18] = {
    id = 18,
    UniqID = 2006,
    AttrType = "Agi",
    AttrType2 = {"Luk"},
    Name = "\229\176\150\233\148\144",
    Dsc = "\230\154\180\229\135\187\228\188\164\229\174\179\230\143\144\229\141\135",
    ComBineAttr = "\230\149\143\230\141\183+\229\185\184\232\191\144",
    NoExchangeEnchant = {StaffRate = 1}
  },
  [16] = {
    id = 16,
    UniqID = 2004,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Luk",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 6}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      ShieldRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [19] = {
    id = 19,
    UniqID = 2007,
    AttrType = "MaxHp",
    AttrBound = {
      {20, 240}
    }
  },
  [21] = {
    id = 21,
    UniqID = 2009,
    AttrType = "MaxSp",
    AttrBound = {
      {8, 24}
    }
  },
  [23] = {
    id = 23,
    UniqID = 2011,
    AttrType = "Atk",
    AttrBound = {
      {4, 12}
    }
  },
  [24] = {
    id = 24,
    UniqID = 2013,
    AttrType = "MAtk",
    AttrBound = {
      {4, 12}
    }
  },
  [25] = {
    id = 25,
    UniqID = 2015,
    AttrType = "Def"
  },
  [26] = {
    id = 26,
    UniqID = 2017,
    AttrType = "MDef",
    AttrBound = {
      {4, 12}
    }
  },
  [27] = {
    id = 27,
    UniqID = 2019,
    AttrType = "Hit",
    AttrBound = {
      {1, 5}
    }
  },
  [28] = {
    id = 28,
    UniqID = 2020,
    AttrType = "Flee",
    AttrBound = {
      {1, 5}
    }
  },
  [20] = {
    id = 20,
    UniqID = 2008,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "MaxHpPer",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {0.01, 0.05}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      ShieldRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [22] = {
    id = 22,
    UniqID = 2010,
    AttrType = "MaxSpPer",
    AttrType2 = {"MAtk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\165\165\230\179\149",
    Dsc = "\233\173\148\228\188\164\229\138\160\230\136\144",
    ComBineAttr = "\233\173\148\230\179\149\228\184\138\233\153\144%+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2%~8%",
    NoShowEquip = {ArmorRate = 1}
  },
  [29] = {
    id = 29,
    UniqID = 3001,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Vit",
    AttrType2 = {"MDef"},
    Condition = {refinelv = 6, type = 1},
    Name = "\231\165\158\228\189\145",
    Dsc = "\233\173\148\230\179\149\228\188\164\229\174\179\229\135\143\229\133\141",
    ComBineAttr = "\228\189\147\232\180\168+\233\173\148\230\179\149\233\152\178\229\190\161",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      ShieldRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [30] = {
    id = 30,
    UniqID = 3002,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Str",
    AttrType2 = {"Atk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\230\150\151\229\191\151",
    Dsc = "\229\191\189\232\167\134\231\137\169\231\144\134\233\152\178\229\190\161",
    ComBineAttr = "\229\138\155\233\135\143+\231\137\169\231\144\134\230\148\187\229\135\187",
    AttrSectionDsc = "5%~20%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [31] = {
    id = 31,
    UniqID = 3003,
    AttrType = "Int",
    AttrType2 = {"MAtk"},
    Name = "\233\173\148\229\138\155",
    Dsc = "\229\144\159\229\148\177\233\128\159\229\186\166\231\188\169\231\159\173",
    ComBineAttr = "\230\153\186\229\138\155+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2.5%~10%",
    NoExchangeEnchant = {
      AxeRate = 1,
      BowRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      SpearRate = 1,
      SwordRate = 1
    }
  },
  [33] = {
    id = 33,
    UniqID = 3005,
    AttrType = "Dex",
    AttrType2 = {"Hit"},
    Name = "\229\144\141\229\188\147",
    Dsc = "\232\191\156\231\168\139\231\137\169\231\144\134\230\148\187\229\135\187\229\162\158\229\138\160",
    ComBineAttr = "\231\129\181\229\183\167+\229\145\189\228\184\173",
    AttrSectionDsc = "2.5%~10%",
    NoExchangeEnchant = {
      AxeRate = 1,
      MaceRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [34] = {
    id = 34,
    UniqID = 3006,
    AttrType = "Agi",
    AttrType2 = {"Luk"},
    Name = "\229\176\150\233\148\144",
    Dsc = "\230\154\180\229\135\187\228\188\164\229\174\179\230\143\144\229\141\135",
    ComBineAttr = "\230\149\143\230\141\183+\229\185\184\232\191\144",
    NoExchangeEnchant = {StaffRate = 1}
  },
  [32] = {
    id = 32,
    UniqID = 3004,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Luk",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 8}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      ShieldRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [35] = {
    id = 35,
    UniqID = 3007,
    AttrType = "MaxHp",
    AttrBound = {
      {40, 400}
    }
  },
  [37] = {
    id = 37,
    UniqID = 3009,
    AttrType = "MaxSp",
    AttrBound = {
      {10, 80}
    }
  },
  [39] = {
    id = 39,
    UniqID = 3011,
    AttrType = "Atk",
    AttrBound = {
      {8, 40}
    }
  },
  [40] = {
    id = 40,
    UniqID = 3013,
    AttrType = "MAtk",
    AttrBound = {
      {8, 40}
    }
  },
  [41] = {
    id = 41,
    UniqID = 3015,
    AttrType = "Def",
    AttrBound = {
      {4, 20}
    }
  },
  [42] = {
    id = 42,
    UniqID = 3017,
    AttrType = "MDef",
    AttrBound = {
      {6, 20}
    }
  },
  [43] = {
    id = 43,
    UniqID = 3019,
    AttrType = "Hit",
    AttrBound = {
      {3, 20}
    }
  },
  [44] = {
    id = 44,
    UniqID = 3020,
    AttrType = "Flee",
    AttrBound = {
      {3, 20}
    }
  },
  [45] = {
    id = 45,
    UniqID = 3021,
    AttrType = "EquipASPD",
    AttrType2 = {
      "DamIncrease"
    },
    Condition = {refinelv = 6, type = 1},
    Name = "\229\136\169\229\136\131",
    Dsc = "\232\191\145\230\136\152\231\137\169\231\144\134\230\148\187\229\135\187\229\162\158\229\138\160",
    ComBineAttr = "\232\163\133\229\164\135\230\148\187\233\128\159+\231\137\169\228\188\164\229\138\160\230\136\144",
    AttrSectionDsc = "2.5%~10%",
    AttrBound = {
      {0.01, 0.04}
    },
    NoShowEquip = {
      ArmorRate = 1,
      RobeRate = 1,
      ShoeRate = 1
    },
    NoExchangeEnchant = {StaffRate = 1}
  },
  [47] = {
    id = 47,
    UniqID = 3023,
    AttrType = "CriRes",
    AttrBound = {
      {1, 10}
    }
  },
  [48] = {
    id = 48,
    UniqID = 3024,
    AttrType = "CriDamPer",
    AttrBound = {
      {0.01, 0.1}
    }
  },
  [49] = {
    id = 49,
    UniqID = 3025,
    AttrType = "CriDefPer",
    AttrBound = {
      {0.01, 0.1}
    }
  },
  [52] = {
    id = 52,
    UniqID = 3028,
    AttrType = "DamIncrease",
    AttrBound = {
      {0.01, 0.04}
    }
  },
  [53] = {
    id = 53,
    UniqID = 3029,
    AttrType = "DamReduc",
    AttrBound = {
      {0.01, 0.04}
    }
  },
  [36] = {
    id = 36,
    UniqID = 3008,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "MaxHpPer",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.02, 0.1}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      ShieldRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [38] = {
    id = 38,
    UniqID = 3010,
    AttrType = "MaxSpPer",
    AttrType2 = {"MAtk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\165\165\230\179\149",
    Dsc = "\233\173\148\228\188\164\229\138\160\230\136\144",
    ComBineAttr = "\233\173\148\230\179\149\228\184\138\233\153\144%+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2%~8%",
    ZenyCost = 5000,
    AttrBound = {
      {0.01, 0.05}
    },
    NoShowEquip = {ArmorRate = 1}
  },
  [51] = {
    id = 51,
    UniqID = 3027,
    AttrType = "BeHealEncPer",
    AttrBound = {
      {0.01, 0.05}
    }
  },
  [46] = {
    id = 46,
    UniqID = 3022,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Cri",
    AttrType2 = {"Def"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\157\154\233\159\167",
    Dsc = "\231\137\169\231\144\134\228\188\164\229\174\179\229\135\143\229\133\141",
    ComBineAttr = "\230\154\180\229\135\187+\231\137\169\231\144\134\233\152\178\229\190\161",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {1, 10}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      ArmorRate = 1,
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [50] = {
    id = 50,
    UniqID = 3026,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "HealEncPer",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.01, 0.05}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      ShieldRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [54] = {
    id = 54,
    UniqID = 3033,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "SilenceDef",
    AttrType2 = _EmptyTable,
    Condition = {refinelv = 6, type = 1},
    Name = "\232\128\144\229\191\131",
    Dsc = "\229\188\130\229\184\184\231\138\182\230\128\129\230\151\182\233\151\180\229\135\143\229\176\145",
    ComBineAttr = "\228\187\187\230\132\143\230\138\151\230\128\167+\228\187\187\230\132\143\230\138\151\230\128\167",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.01, 0.25}
    },
    NoShowEquip = {
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    },
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      FaceRate = 1,
      HeadRate = 1,
      MouthRate = 1,
      ShieldRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [55] = {
    id = 55,
    UniqID = 3034,
    AttrType = "FreezeDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [56] = {
    id = 56,
    UniqID = 3035,
    AttrType = "StoneDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [57] = {
    id = 57,
    UniqID = 3036,
    AttrType = "StunDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [58] = {
    id = 58,
    UniqID = 3037,
    AttrType = "BlindDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [59] = {
    id = 59,
    UniqID = 3038,
    AttrType = "PoisonDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [60] = {
    id = 60,
    UniqID = 3039,
    AttrType = "SlowDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [61] = {
    id = 61,
    UniqID = 3040,
    AttrType = "ChaosDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [62] = {
    id = 62,
    UniqID = 3041,
    AttrType = "CurseDef",
    Name = "",
    Dsc = "",
    ComBineAttr = ""
  },
  [63] = {
    id = 63,
    UniqID = 4001,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Vit",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 4}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [64] = {
    id = 64,
    UniqID = 4002,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Str",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 4}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [65] = {
    id = 65,
    UniqID = 4003,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Int",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 4}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [66] = {
    id = 66,
    UniqID = 4004,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Luk",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 2}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [69] = {
    id = 69,
    UniqID = 4007,
    AttrType = "MaxHp",
    AttrBound = {
      {1, 240}
    }
  },
  [70] = {
    id = 70,
    UniqID = 4008,
    AttrType = "MaxSp",
    AttrBound = {
      {1, 24}
    }
  },
  [71] = {
    id = 71,
    UniqID = 4009,
    AttrType = "Atk",
    AttrBound = {
      {1, 12}
    }
  },
  [72] = {
    id = 72,
    UniqID = 4010,
    AttrType = "MAtk",
    AttrBound = {
      {1, 12}
    }
  },
  [73] = {
    id = 73,
    UniqID = 4011,
    AttrType = "Def",
    AttrBound = {
      {1, 12}
    }
  },
  [74] = {
    id = 74,
    UniqID = 4012,
    AttrType = "MDef",
    AttrBound = {
      {1, 12}
    }
  },
  [67] = {
    id = 67,
    UniqID = 4005,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Dex",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 4}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      WingRate = 1
    }
  },
  [68] = {
    id = 68,
    UniqID = 4006,
    EnchantType = 1,
    MaxNum = 2,
    AttrType = "Agi",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = _EmptyTable,
    ZenyCost = 5000,
    AttrBound = {
      {1, 4}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [75] = {
    id = 75,
    UniqID = 5001,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Vit",
    AttrType2 = {"Int"},
    Condition = {refinelv = 6, type = 1},
    Name = "\228\186\181\230\184\142",
    Dsc = "\230\138\128\232\131\189\228\188\164\229\174\179\229\135\143\229\133\141",
    ComBineAttr = "\228\189\147\232\180\168+\230\153\186\229\138\155",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [76] = {
    id = 76,
    UniqID = 5002,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Str",
    AttrType2 = {"Atk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\230\150\151\229\191\151",
    Dsc = "\229\191\189\232\167\134\231\137\169\231\144\134\233\152\178\229\190\161",
    ComBineAttr = "\229\138\155\233\135\143+\231\137\169\231\144\134\230\148\187\229\135\187",
    AttrSectionDsc = "5%~20%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = {HeadRate = 1},
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [77] = {
    id = 77,
    UniqID = 5003,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Int",
    AttrType2 = {"MAtk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\233\173\148\229\138\155",
    Dsc = "\229\144\159\229\148\177\233\128\159\229\186\166\231\188\169\231\159\173",
    ComBineAttr = "\230\153\186\229\138\155+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = {
      FaceRate = 1,
      TailRate = 1,
      WingRate = 1
    },
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [84] = {
    id = 84,
    UniqID = 5010,
    AttrType = "MaxSpPer",
    AttrType2 = {"Int"},
    Name = "\230\180\158\229\175\159",
    Dsc = "\229\191\189\232\167\134\233\173\148\230\179\149\233\152\178\229\190\161",
    ComBineAttr = "\233\173\148\230\179\149\228\184\138\233\153\144%+\230\153\186\229\138\155",
    AttrSectionDsc = "5%~20%",
    AttrBound = {
      {0.01, 0.05}
    },
    NoShowEquip = {TailRate = 1}
  },
  [78] = {
    id = 78,
    UniqID = 5004,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Luk",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 6}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [81] = {
    id = 81,
    UniqID = 5007,
    AttrType = "MaxHp",
    AttrBound = {
      {30, 360}
    }
  },
  [83] = {
    id = 83,
    UniqID = 5009,
    AttrType = "MaxSp",
    AttrBound = {
      {8, 36}
    }
  },
  [85] = {
    id = 85,
    UniqID = 5011,
    AttrType = "Atk",
    AttrBound = {
      {6, 18}
    }
  },
  [86] = {
    id = 86,
    UniqID = 5013,
    AttrType = "MAtk",
    AttrType2 = {"MaxSpPer"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\165\165\230\179\149",
    Dsc = "\233\173\148\228\188\164\229\138\160\230\136\144",
    ComBineAttr = "\233\173\148\230\179\149\228\184\138\233\153\144%+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2%~8%",
    AttrBound = {
      {6, 18}
    },
    NoShowEquip = {FaceRate = 1, WingRate = 1}
  },
  [87] = {
    id = 87,
    UniqID = 5015,
    AttrType = "Def",
    AttrBound = {
      {6, 18}
    }
  },
  [88] = {
    id = 88,
    UniqID = 5017,
    AttrType = "MDef",
    AttrBound = {
      {6, 18}
    }
  },
  [89] = {
    id = 89,
    UniqID = 5019,
    AttrType = "Hit",
    AttrBound = {
      {2, 8}
    }
  },
  [90] = {
    id = 90,
    UniqID = 5020,
    AttrType = "Flee",
    AttrBound = {
      {2, 8}
    }
  },
  [79] = {
    id = 79,
    UniqID = 5005,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Dex",
    AttrType2 = {"Hit"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\144\141\229\188\147",
    Dsc = "\232\191\156\231\168\139\231\137\169\231\144\134\230\148\187\229\135\187\229\162\158\229\138\160",
    ComBineAttr = "\231\129\181\229\183\167+\229\145\189\228\184\173",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = {HeadRate = 1, MouthRate = 1},
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      WingRate = 1
    }
  },
  [80] = {
    id = 80,
    UniqID = 5006,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "Agi",
    AttrType2 = {"Luk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\176\150\233\148\144",
    Dsc = "\230\154\180\229\135\187\228\188\164\229\174\179\230\143\144\229\141\135",
    ComBineAttr = "\230\149\143\230\141\183+\229\185\184\232\191\144",
    AttrSectionDsc = "5%~20%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {2, 8}
    },
    NoShowEquip = {FaceRate = 1, MouthRate = 1},
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [82] = {
    id = 82,
    UniqID = 5008,
    EnchantType = 2,
    MaxNum = 3,
    AttrType = "MaxHpPer",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 2},
    ZenyCost = 5000,
    AttrBound = {
      {0.01, 0.05}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [91] = {
    id = 91,
    UniqID = 6001,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Vit",
    AttrType2 = {"Int"},
    Condition = {refinelv = 6, type = 1},
    Name = "\228\186\181\230\184\142",
    Dsc = "\230\138\128\232\131\189\228\188\164\229\174\179\229\135\143\229\133\141",
    ComBineAttr = "\228\189\147\232\180\168+\230\153\186\229\138\155",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [92] = {
    id = 92,
    UniqID = 6002,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Str",
    AttrType2 = {"Atk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\230\150\151\229\191\151",
    Dsc = "\229\191\189\232\167\134\231\137\169\231\144\134\233\152\178\229\190\161",
    ComBineAttr = "\229\138\155\233\135\143+\231\137\169\231\144\134\230\148\187\229\135\187",
    AttrSectionDsc = "5%~20%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = {HeadRate = 1},
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [93] = {
    id = 93,
    UniqID = 6003,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Int",
    AttrType2 = {"MAtk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\233\173\148\229\138\155",
    Dsc = "\229\144\159\229\148\177\233\128\159\229\186\166\231\188\169\231\159\173",
    ComBineAttr = "\230\153\186\229\138\155+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = {
      FaceRate = 1,
      TailRate = 1,
      WingRate = 1
    },
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [100] = {
    id = 100,
    UniqID = 6010,
    AttrType = "MaxSpPer",
    AttrType2 = {"Int"},
    Name = "\230\180\158\229\175\159",
    Dsc = "\229\191\189\232\167\134\233\173\148\230\179\149\233\152\178\229\190\161",
    ComBineAttr = "\233\173\148\230\179\149\228\184\138\233\153\144%+\230\153\186\229\138\155",
    AttrSectionDsc = "5%~20%",
    AttrBound = {
      {0.01, 0.05}
    },
    NoShowEquip = {TailRate = 1}
  },
  [94] = {
    id = 94,
    UniqID = 6004,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Luk",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 8}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [97] = {
    id = 97,
    UniqID = 6007,
    AttrType = "MaxHp",
    AttrBound = {
      {60, 600}
    }
  },
  [99] = {
    id = 99,
    UniqID = 6009,
    AttrType = "MaxSp",
    AttrBound = {
      {12, 120}
    }
  },
  [101] = {
    id = 101,
    UniqID = 6011,
    AttrType = "Atk",
    AttrBound = {
      {12, 60}
    }
  },
  [102] = {
    id = 102,
    UniqID = 6013,
    AttrType = "MAtk",
    AttrType2 = {"MaxSpPer"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\165\165\230\179\149",
    Dsc = "\233\173\148\228\188\164\229\138\160\230\136\144",
    ComBineAttr = "\233\173\148\230\179\149\228\184\138\233\153\144%+\233\173\148\230\179\149\230\148\187\229\135\187",
    AttrSectionDsc = "2%~8%",
    AttrBound = {
      {12, 60}
    },
    NoShowEquip = {FaceRate = 1, WingRate = 1}
  },
  [103] = {
    id = 103,
    UniqID = 6015,
    AttrType = "Def",
    AttrBound = {
      {6, 30}
    }
  },
  [104] = {
    id = 104,
    UniqID = 6017,
    AttrType = "MDef",
    AttrBound = {
      {6, 30}
    }
  },
  [105] = {
    id = 105,
    UniqID = 6019,
    AttrType = "Hit",
    AttrBound = {
      {5, 30}
    }
  },
  [106] = {
    id = 106,
    UniqID = 6020,
    AttrType = "Flee",
    AttrBound = {
      {5, 30}
    }
  },
  [109] = {
    id = 109,
    UniqID = 6023,
    AttrType = "CriRes",
    AttrBound = {
      {1, 10}
    }
  },
  [111] = {
    id = 111,
    UniqID = 6025,
    AttrType = "CriDefPer",
    AttrType2 = {"Vit"},
    Condition = {refinelv = 6, type = 1},
    Name = "\233\147\129\231\148\178",
    Dsc = "\230\154\180\229\135\187\233\152\178\230\138\164\229\162\158\229\138\160",
    ComBineAttr = "\228\189\147\232\180\168+\230\154\180\228\188\164\229\135\143\229\133\141%",
    AttrSectionDsc = "5~20",
    AttrBound = {
      {0.01, 0.1}
    },
    NoShowEquip = {TailRate = 1, WingRate = 1}
  },
  [112] = {
    id = 112,
    UniqID = 6026,
    AttrType = "HealEncPer",
    AttrBound = {
      {0.01, 0.05}
    }
  },
  [113] = {
    id = 113,
    UniqID = 6027,
    AttrType = "BeHealEncPer",
    AttrBound = {
      {0.01, 0.05}
    }
  },
  [95] = {
    id = 95,
    UniqID = 6005,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Dex",
    AttrType2 = {"Hit"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\144\141\229\188\147",
    Dsc = "\232\191\156\231\168\139\231\137\169\231\144\134\230\148\187\229\135\187\229\162\158\229\138\160",
    ComBineAttr = "\231\129\181\229\183\167+\229\145\189\228\184\173",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = {HeadRate = 1, MouthRate = 1},
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      WingRate = 1
    }
  },
  [107] = {
    id = 107,
    UniqID = 6021,
    AttrType = "EquipASPD",
    AttrType2 = {"CriDamPer"},
    Name = "\231\139\130\231\131\173",
    Dsc = "\230\153\174\230\148\187\228\188\164\229\174\179\229\162\158\229\138\160",
    ComBineAttr = "\232\163\133\229\164\135\230\148\187\233\128\159+\230\154\180\228\188\164%",
    AttrBound = {
      {0.01, 0.04}
    },
    NoShowEquip = _EmptyTable
  },
  [96] = {
    id = 96,
    UniqID = 6006,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Agi",
    AttrType2 = {"Luk"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\176\150\233\148\144",
    Dsc = "\230\154\180\229\135\187\228\188\164\229\174\179\230\143\144\229\141\135",
    ComBineAttr = "\230\149\143\230\141\183+\229\185\184\232\191\144",
    AttrSectionDsc = "5%~20%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {4, 10}
    },
    NoShowEquip = {FaceRate = 1, MouthRate = 1},
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [98] = {
    id = 98,
    UniqID = 6008,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "MaxHpPer",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.02, 0.1}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1
    }
  },
  [108] = {
    id = 108,
    UniqID = 6022,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "Cri",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {1, 10}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1
    }
  },
  [110] = {
    id = 110,
    UniqID = 6024,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "CriDamPer",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.01, 0.1}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  },
  [114] = {
    id = 114,
    UniqID = 6028,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "DamIncrease",
    AttrType2 = {"EquipASPD"},
    Condition = {refinelv = 6, type = 1},
    Name = "\229\136\169\229\136\131",
    Dsc = "\232\191\145\230\136\152\231\137\169\231\144\134\230\148\187\229\135\187\229\162\158\229\138\160",
    ComBineAttr = "\232\163\133\229\164\135\230\148\187\233\128\159+\231\137\169\228\188\164\229\138\160\230\136\144",
    AttrSectionDsc = "2.5%~10%",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.01, 0.04}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      GloveRate = 1,
      HeadRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      MouthRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      WingRate = 1
    }
  },
  [115] = {
    id = 115,
    UniqID = 6029,
    EnchantType = 3,
    MaxNum = 3,
    AttrType = "DamReduc",
    AttrType2 = _EmptyTable,
    Condition = _EmptyTable,
    Name = "",
    Dsc = "",
    ComBineAttr = "",
    AttrSectionDsc = "",
    ExpressionOfMaxUp = 0.8,
    ExpressionOfMaxDown = 0.2,
    ItemCost = {itemid = 135, num = 4},
    ZenyCost = 20000,
    AttrBound = {
      {0.01, 0.04}
    },
    NoShowEquip = _EmptyTable,
    NoExchangeEnchant = _EmptyTable,
    CantEnchant = {
      AccessoryRate = 1,
      ArmorRate = 1,
      AxeRate = 1,
      BookRate = 1,
      BowRate = 1,
      FaceRate = 1,
      GloveRate = 1,
      InstrumentRate = 1,
      KatarRate = 1,
      KnifeRate = 1,
      LashRate = 1,
      MaceRate = 1,
      PotionRate = 1,
      RobeRate = 1,
      ShieldRate = 1,
      ShoeRate = 1,
      SpearRate = 1,
      StaffRate = 1,
      SwordRate = 1,
      TailRate = 1,
      WingRate = 1
    }
  }
}
setmetatable(Table_EquipEnchant[2], {
  __index = Table_EquipEnchant[1]
})
setmetatable(Table_EquipEnchant[3], {
  __index = Table_EquipEnchant[1]
})
setmetatable(Table_EquipEnchant[5], {
  __index = Table_EquipEnchant[1]
})
setmetatable(Table_EquipEnchant[6], {
  __index = Table_EquipEnchant[1]
})
setmetatable(Table_EquipEnchant[7], {
  __index = Table_EquipEnchant[4]
})
setmetatable(Table_EquipEnchant[8], {
  __index = Table_EquipEnchant[4]
})
setmetatable(Table_EquipEnchant[9], {
  __index = Table_EquipEnchant[4]
})
setmetatable(Table_EquipEnchant[10], {
  __index = Table_EquipEnchant[4]
})
setmetatable(Table_EquipEnchant[11], {
  __index = Table_EquipEnchant[4]
})
setmetatable(Table_EquipEnchant[12], {
  __index = Table_EquipEnchant[4]
})
setmetatable(Table_EquipEnchant[15], {
  __index = Table_EquipEnchant[14]
})
setmetatable(Table_EquipEnchant[17], {
  __index = Table_EquipEnchant[14]
})
setmetatable(Table_EquipEnchant[18], {
  __index = Table_EquipEnchant[14]
})
setmetatable(Table_EquipEnchant[19], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[21], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[23], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[24], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[25], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[26], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[27], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[28], {
  __index = Table_EquipEnchant[16]
})
setmetatable(Table_EquipEnchant[22], {
  __index = Table_EquipEnchant[20]
})
setmetatable(Table_EquipEnchant[31], {
  __index = Table_EquipEnchant[30]
})
setmetatable(Table_EquipEnchant[33], {
  __index = Table_EquipEnchant[30]
})
setmetatable(Table_EquipEnchant[34], {
  __index = Table_EquipEnchant[30]
})
setmetatable(Table_EquipEnchant[35], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[37], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[39], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[40], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[41], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[42], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[43], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[44], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[45], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[47], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[48], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[49], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[52], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[53], {
  __index = Table_EquipEnchant[32]
})
setmetatable(Table_EquipEnchant[38], {
  __index = Table_EquipEnchant[36]
})
setmetatable(Table_EquipEnchant[51], {
  __index = Table_EquipEnchant[36]
})
setmetatable(Table_EquipEnchant[55], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[56], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[57], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[58], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[59], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[60], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[61], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[62], {
  __index = Table_EquipEnchant[54]
})
setmetatable(Table_EquipEnchant[69], {
  __index = Table_EquipEnchant[66]
})
setmetatable(Table_EquipEnchant[70], {
  __index = Table_EquipEnchant[66]
})
setmetatable(Table_EquipEnchant[71], {
  __index = Table_EquipEnchant[66]
})
setmetatable(Table_EquipEnchant[72], {
  __index = Table_EquipEnchant[66]
})
setmetatable(Table_EquipEnchant[73], {
  __index = Table_EquipEnchant[66]
})
setmetatable(Table_EquipEnchant[74], {
  __index = Table_EquipEnchant[66]
})
setmetatable(Table_EquipEnchant[84], {
  __index = Table_EquipEnchant[77]
})
setmetatable(Table_EquipEnchant[81], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[83], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[85], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[86], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[87], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[88], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[89], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[90], {
  __index = Table_EquipEnchant[78]
})
setmetatable(Table_EquipEnchant[100], {
  __index = Table_EquipEnchant[93]
})
setmetatable(Table_EquipEnchant[97], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[99], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[101], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[102], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[103], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[104], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[105], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[106], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[109], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[111], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[112], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[113], {
  __index = Table_EquipEnchant[94]
})
setmetatable(Table_EquipEnchant[107], {
  __index = Table_EquipEnchant[95]
})
return Table_EquipEnchant
