Table_Menu_JP = {
  [9007] = {
    id = 9007,
    type = 3,
    text = "\229\188\185\229\135\186APP\232\175\132\228\187\183\229\188\149\229\175\188\230\161\134",
    Condition = {
      quest = {398600002}
    },
    event = _EmptyTable,
    sysMsg = _EmptyTable,
    Tip = "",
    Acc = 1,
    Icon = {uiicon = "Part"}
  },
  [3051] = {
    id = 3051,
    type = 3,
    text = "\228\187\187\229\138\161\230\137\139\229\134\140\229\188\128\230\148\190",
    Condition = {level = 1},
    event = _EmptyTable,
    sysMsg = _EmptyTable,
    Tip = "\228\187\187\229\138\161\230\137\139\229\134\140 \229\183\178\229\188\128\230\148\190",
    Acc = 1,
    Icon = {itemicon = "item_5549"}
  },
  [1000] = {
    id = 1000,
    type = 2,
    text = "\229\174\140\230\136\144\229\144\142\229\143\175\229\136\155\229\187\186\229\133\172\228\188\154",
    Condition = {level = 20},
    event = _EmptyTable,
    sysMsg = {id = 802},
    Tip = "\229\136\155\229\187\186\229\133\172\228\188\154\229\188\128\229\144\175",
    Show = 1,
    Icon = {uiicon = "Guild"}
  }
}
Table_Menu_JP_fields = {
  "id",
  "type",
  "PanelID",
  "text",
  "Condition",
  "event",
  "sysMsg",
  "Tip",
  "Show",
  "Acc",
  "Icon",
  "GuideID",
  "Enterhide"
}
return Table_Menu_JP
