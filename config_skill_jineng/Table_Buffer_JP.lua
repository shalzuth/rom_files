Table_Buffer_JP = {
  [36850] = {
    id = 36850,
    BuffName = "45941\231\153\189\231\139\144\231\139\184\229\164\180\233\165\176",
    BuffRate = {Odds = 100},
    Condition = _EmptyTable,
    BuffType = _EmptyTable,
    BuffEffect = {
      type = "AttrChange",
      MaxHp = 500,
      MaxHpPer = 0.02
    },
    BuffIcon = "",
    BuffDesc = "",
    Dsc = "\231\148\159\229\145\189\228\184\138\233\153\144\239\188\139500\n\231\148\159\229\145\189\228\184\138\233\153\144\239\188\1392%",
    DelBuffID = _EmptyTable
  },
  [36860] = {
    id = 36860,
    BuffName = "49101\233\135\145\231\139\144\231\139\184\229\164\180\233\165\176",
    BuffRate = {Odds = 100},
    Condition = _EmptyTable,
    BuffType = _EmptyTable,
    BuffEffect = {
      type = "AttrChange",
      Str = 1,
      Vit = 1,
      Dex = 1,
      Agi = 1,
      Int = 1,
      Luk = 1,
      DamIncrease = 0.04,
      MDamIncrease = 0.04
    },
    BuffIcon = "",
    BuffDesc = "",
    Dsc = "\229\133\168\232\131\189\229\138\155\239\188\1391\n\231\137\169\231\144\134\228\188\164\229\174\179\239\188\1394%\n\233\173\148\230\179\149\228\188\164\229\174\179\239\188\1394%",
    DelBuffID = _EmptyTable
  },
  [36870] = {
    id = 36870,
    BuffName = "47177\231\186\162\230\129\182\233\173\148\231\191\133\232\134\128",
    BuffRate = {Odds = 100},
    Condition = _EmptyTable,
    BuffType = _EmptyTable,
    BuffEffect = {
      type = "AttrChange",
      Str = 1,
      Vit = 1,
      Dex = 1,
      Agi = 1,
      Int = 1,
      Luk = 1,
      DamIncrease = 0.04,
      MDamIncrease = 0.04
    },
    BuffIcon = "",
    BuffDesc = "",
    Dsc = "\229\133\168\232\131\189\229\138\155\239\188\1391\n\231\137\169\231\144\134\228\188\164\229\174\179\239\188\1394%\n\233\173\148\230\179\149\228\188\164\229\174\179\239\188\1394%",
    DelBuffID = _EmptyTable
  },
  [36880] = {
    id = 36880,
    BuffName = "47178\233\135\145\230\129\182\233\173\148\231\191\133\232\134\128",
    BuffRate = {Odds = 100},
    Condition = _EmptyTable,
    BuffType = _EmptyTable,
    BuffEffect = {
      type = "AttrChange",
      Str = 1,
      Agi = 1,
      Vit = 1,
      Int = 1,
      Dex = 1,
      Luk = 1,
      MDamSpike = 0.05,
      DamSpike = 0.05
    },
    BuffIcon = "",
    BuffDesc = "",
    Dsc = "\229\133\168\232\131\189\229\138\155\239\188\1391\n\231\137\169\231\144\134\231\169\191\229\136\186\239\188\1395%\n\233\173\148\230\179\149\231\169\191\229\136\186\239\188\1395%",
    DelBuffID = _EmptyTable
  },
  [21532] = {
    id = 21532,
    BuffName = "\232\191\170\230\150\175\229\135\175\231\137\185\231\154\132\230\138\171\233\163\142",
    BuffRate = {Odds = 100},
    Condition = {
      type = "Profession",
      value = {
        11,
        12,
        13,
        14,
        72,
        73,
        74,
        31,
        32,
        33,
        34,
        61,
        62,
        63,
        64,
        92,
        93,
        94,
        132,
        133,
        134
      }
    },
    BuffType = _EmptyTable,
    BuffEffect = {type = "AttrChange", DamRebound = 0.05},
    BuffIcon = "",
    BuffDesc = "",
    Dsc = "\229\137\145\229\163\171\231\179\187\239\188\140\229\149\134\228\186\186\231\179\187\239\188\140\231\155\151\232\180\188\231\179\187\232\163\133\229\164\135\230\151\182\231\137\169\231\144\134\229\143\141\228\188\164\231\142\135\239\188\1395%\n\231\178\190\231\130\188\239\188\13910\230\151\182\239\188\140\229\143\141\228\188\164\231\142\135\239\188\13915%",
    DelBuffID = _EmptyTable
  }
}
Table_Buffer_JP_fields = {
  "id",
  "BuffName",
  "BuffRate",
  "Condition",
  "BuffType",
  "BuffStateID",
  "BuffEffect",
  "BuffIcon",
  "IconType",
  "BuffDesc",
  "Dsc",
  "DelBuffID"
}
return Table_Buffer_JP
