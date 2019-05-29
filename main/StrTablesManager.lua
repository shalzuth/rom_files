StrTablesManager = class("StrTablesManager")
transConfig = {
  Table_Item = {"Desc", "NameZh"},
  Table_Map = {"NameZh", "CallZh"},
  Table_Sysmsg = {"Text"},
  Table_ItemType = {"Name"},
  Table_NpcFunction = {"NameZh"},
  Table_Buffer = {
    "Dsc",
    "BuffDesc",
    "BuffName"
  },
  Table_Class = {"NameZh"},
  Table_WantedQuest = {"Target"},
  Table_Monster = {"NameZh"},
  Table_AdventureAppend = {"Desc"},
  Table_MCharacteristic = {"NameZh", "Desc"},
  Table_Npc = {"NameZh"},
  Table_Appellation = {"Name"},
  Table_RoleData = {"PropName", "RuneName"},
  Table_Viewspot = {"SpotName"},
  Table_Skill = {"NameZh"},
  Table_EquipSuit = {"EffectDesc"},
  Table_ChatEmoji = {"Emoji"},
  Table_RuneSpecial = {"RuneName"},
  Table_Guild_Faith = {"Name"},
  Table_Recipe = {"Name"},
  Table_ItemTypeAdventureLog = {"Name"},
  Table_ActivityStepShow = {"Trace_Text"},
  Table_GuildBuilding = {
    "FuncDesc",
    "LevelUpPreview"
  },
  Table_ItemAdvManual = {"LockDesc"},
  Table_Menu = {"text", "Tip"},
  Table_Guild_Treasure = {"Desc"}
}
function track2(t, keys)
  for __, key in pairs(keys) do
    t[key] = OverSea.LangManager.Instance():GetLangByKey(t[key])
  end
end
function track(t, keys)
  for _, v in pairs(t) do
    for __, key in pairs(keys) do
      v[key] = OverSea.LangManager.Instance():GetLangByKey(v[key])
    end
  end
end
function transTable(tbl)
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      tbl[k] = OverSea.LangManager.Instance():GetLangByKey(v)
    elseif type(v) == "table" then
      transTable(v)
    end
  end
end
function transArray(arr)
  for i = 1, #arr do
    arr[i] = OverSea.LangManager.Instance():GetLangByKey(arr[i])
  end
end
function simpleReplace(origin)
  local ret = origin
  candidates = {
    "\231\154\132\228\184\147\229\177\158\230\137\167\228\186\139",
    "\231\154\132\228\184\147\229\177\158\229\165\179\228\187\134",
    "\230\137\190\228\184\141\229\136\176\231\155\174\230\160\135\229\156\176\229\155\190",
    "_\231\154\132\233\152\159\228\188\141"
  }
  for _, candidate in ipairs(candidates) do
    local translated = OverSea.LangManager.Instance():GetLangByKey(candidate)
    ret = string.gsub(ret, candidate, translated)
  end
  return ret
end
function StrTablesManager.GetData(tableName, key)
  local strTable = _G[tableName .. "_s"]
  if nil == strTable then
    redlog("Trying to access " .. tableName .. "_s but it's not exist")
    return nil
  end
  local strData = strTable[key]
  if nil == strData or "" == strData then
    return nil
  end
  strData = string.gsub(strData, "\\", "\\\\")
  strData = string.gsub(strData, "\n", "\\n")
  local funcData = loadstring("return " .. strData)
  if nil == funcData then
    redlog("Data Cannot Parse: " .. strData)
    return nil
  end
  local data = funcData()
  for k, v in pairs(transConfig) do
    if k == tableName then
      track2(data, v)
    end
  end
  _G[tableName][key] = data
  strTable[key] = nil
  return data
end
function StrTablesManager.ProcessMonsterOrNPC(data)
  if nil ~= data then
    if nil ~= data.SpawnSE and "" ~= data.SpawnSE then
      data.SE = string.split(data.SpawnSE, "-")
    end
    data.Race_Parsed = CommonFun.ParseRace(data.Race)
    data.Nature_Parsed = CommonFun.ParseNature(data.Nature)
  end
  return data
end
