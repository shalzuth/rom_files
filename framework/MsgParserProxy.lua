MsgParserProxy = class("MsgParserProxy", pm.Proxy)
MsgParserProxy.Instance = nil
MsgParserProxy.NAME = "MsgParserProxy"
function MsgParserProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MsgParserProxy.NAME
  if MsgParserProxy.Instance == nil then
    MsgParserProxy.Instance = self
  end
  self:InitPatterns()
end
function MsgParserProxy:InitPatterns()
  self.myName = "%[PlayerName%]"
  self.upAdvLvCost = "%[UpAdvLvCost%]"
  self.itemPattern = "({item=(%d+)(,-)(%d-)})"
  self.npcPattern = "({npc=(%d+)(,-)(%d-)})"
  self.mapPattern = "({map=(%d+)})"
  self.questPattern = "({quest=(%d+)})"
  self.countDownPattern = "({countDown=(%d+)(,-)(%d-)})"
  self.iconPattern = "({(%w+)icon=(%w+)(_-)(%w-)})"
  self.singleIconPattern = "(%w+)=(%w+_*%w*)"
end
function MsgParserProxy:GetIconInfo(text)
  return string.match(text, self.singleIconPattern)
end
function MsgParserProxy:ReplaceIconInfo(text, replace)
  replace = replace or ""
  return string.gsub(text, self.iconPattern, replace)
end
function MsgParserProxy:TryParse(text, ...)
  text = OverSea.LangManager.Instance():GetLangByKey(text)
  local isError
  text, isError = self:ReplaceDynamicParams(text, ...)
  return self:DoParse(text), isError
end
local function GetMatchPatternTimes(text, pattern, index)
  local s, e = string.find(text, pattern, index)
  if e then
    return GetMatchPatternTimes(text, pattern, e) + 1
  end
  return 0
end
function MsgParserProxy:ReplaceDynamicParams(text, ...)
  local textNum = GetMatchPatternTimes(text, "%%s+", 1)
  if (...) ~= nil and textNum ~= 0 then
    local argLength = select("#", ...)
    if argLength == textNum then
      return string.format(text, ...)
    else
      printRed(string.format("MsgParserProxy ReplaceDynamicParams : text = %s , textNum = %s , #arg = %s", tostring(text), tostring(textNum), tostring(argLength)))
      local argStr = {}
      local isError
      for k, v in ipairs({
        ...
      }) do
        table.insert(argStr, v)
      end
      if textNum < argLength then
        for i = argLength, textNum + 1, -1 do
          table.remove(argStr, i)
        end
      elseif textNum > argLength then
        for i = 1, textNum - argLength do
          table.insert(argStr, argLength + i, "(\231\188\186\229\176\145\229\143\130\230\149\176)")
        end
        isError = true
      end
      return string.format(text, unpack(argStr)), isError
    end
  else
    return text
  end
end
local str, id, split, num, replaceStr
function MsgParserProxy:_ReplaceItemPattern(text)
  str, id, split, num = string.match(text, self.itemPattern)
  if str then
    replaceStr = self:GetItemNameWithQuality(id, num)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceItemPattern(text)
    end
  end
  return text
end
function MsgParserProxy:_ReplaceNpcPattern(text)
  str, id, split, num = string.match(text, self.npcPattern)
  if str then
    replaceStr = self:GetNpcNameWithQuality(id, num)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceNpcPattern(text)
    end
  end
  return text
end
function MsgParserProxy:_ReplaceMapPattern(text)
  str, id = string.match(text, self.mapPattern)
  if str then
    replaceStr = self:GetMapName(id)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceMapPattern(text)
    end
  end
  return text
end
function MsgParserProxy:_ReplaceQuestPattern(text)
  str, id, split, num = string.match(text, self.questPattern)
  if str then
    replaceStr = self:GetQuestName(id)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceQuestPattern(text)
    end
  end
  return text
end
local _ReplaceItemPattern = MsgParserProxy._ReplaceItemPattern
local _ReplaceNpcPattern = MsgParserProxy._ReplaceNpcPattern
local _ReplaceMapPattern = MsgParserProxy._ReplaceMapPattern
local _ReplaceQuestPattern = MsgParserProxy._ReplaceQuestPattern
function MsgParserProxy:DoParse(text)
  text = _ReplaceItemPattern(self, text)
  text = _ReplaceNpcPattern(self, text)
  text = _ReplaceMapPattern(self, text)
  text = _ReplaceQuestPattern(self, text)
  text = StringUtil.Replace(text, self.myName, self:GetMyName())
  text = StringUtil.Replace(text, self.upAdvLvCost, self:GetUpAdvLvCostStr())
  return text
end
function MsgParserProxy:TryParseCountDown(text, isHideTime)
  local data
  for str, time, split, num in string.gmatch(text, self.countDownPattern) do
    if isHideTime then
      text = string.gsub(text, str, "")
    else
      text = string.gsub(text, str, "%%s")
    end
    data = {
      time = tonumber(time),
      decimal = num ~= nil and tonumber(num) or 0,
      isHideTime = isHideTime
    }
  end
  return text, data
end
function MsgParserProxy:GetQuestName(id)
  local data = QuestProxy.Instance:getStaticDataById(id)
  if data ~= nil then
    return data.Name
  end
  return nil
end
function MsgParserProxy:GetMapName(id)
  local data = Table_Map[tonumber(id)]
  if data ~= nil then
    return data.NameZh
  end
  return nil
end
function MsgParserProxy:GetCachedItemNameWithQuality(id)
  local data = Table_Item[tonumber(id)]
  if data ~= nil then
    if data.customColorName == nil then
      data.customColorName = ItemQualityColor[data.Quality] .. data.NameZh .. "[-]"
    end
    return data.customColorName
  end
  return nil
end
function MsgParserProxy:GetItemNameWithQuality(id, num)
  local data = Table_Item[tonumber(id)]
  if data ~= nil then
    local numStr = ""
    if num ~= nil and num ~= "" then
      numStr = "\195\151" .. num
    end
    if data.Quality == 1 then
      return ItemQualityColor[data.Quality] .. data.NameZh .. numStr .. "[-]"
    end
    return "[c]" .. ItemQualityColor[data.Quality] .. data.NameZh .. numStr .. "[-][/c]"
  end
  return nil
end
function MsgParserProxy:GetNpcNameWithQuality(id, num)
  local data = Table_Npc[tonumber(id)]
  if data ~= nil then
    local numStr = ""
    if num ~= nil and num ~= "" then
      numStr = "\195\151" .. num
    end
    return data.NameZh .. numStr
  end
  return nil
end
function MsgParserProxy:GetMyName()
  if self.myself == nil then
    self.myself = Game.Myself
  end
  if self.myself and self.myself.data then
    return self.myself.data:GetName()
  end
  return "\230\136\145"
end
function MsgParserProxy:GetUpAdvLvCostStr()
  local result = ""
  if self.myself == nil then
    self.myself = Game.Myself
  end
  if self.myself then
    local nowAdvlv = AdventureDataProxy.Instance:getManualLevel()
    local cost = nowAdvlv and Table_AdventureLevel[nowAdvlv] and Table_AdventureLevel[nowAdvlv].Item
    if cost then
      local id = cost.id
      local num = cost.num
      if Table_Item[id] and num then
        result = num .. Table_Item[id].NameZh
      end
    end
  end
  return result
end
