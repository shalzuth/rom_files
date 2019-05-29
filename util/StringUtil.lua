StringUtil = {}
function StringUtil.utf8_tail(n, k)
  local u, r = "", nil
  for i = 1, k do
    n, r = math.floor(n / 64), n % 64
    u = string.char(r + 128) .. u
  end
  return u, n
end
function StringUtil.to_utf8(a)
  local n, r, u = tonumber(a)
  if n < 128 then
    return string.char(n)
  elseif n < 2048 then
    u, n = StringUtil.utf8_tail(n, 1)
    return string.char(n + 192) .. u
  elseif n < 65536 then
    u, n = StringUtil.utf8_tail(n, 2)
    return string.char(n + 224) .. u
  elseif n < 2097152 then
    u, n = StringUtil.utf8_tail(n, 3)
    return string.char(n + 240) .. u
  elseif n < 67108864 then
    u, n = StringUtil.utf8_tail(n, 4)
    return string.char(n + 248) .. u
  else
    u, n = StringUtil.utf8_tail(n, 5)
    return string.char(n + 252) .. u
  end
end
function StringUtil.sto_utf8(s)
  return string.gsub(s, "&#(%d+);", StringUtil.to_utf8)
end
local tab = {}
function StringUtil.getTextByIndex(str, startIndex, endIndex)
  if endIndex and endIndex < startIndex then
    printRed("error!startIndex can't bigger endIndex")
    return ""
  end
  TableUtility.ArrayClear(tab)
  for uchar in string.gmatch(str, "[%z\001-\127\194-\244][\128-\191]*") do
    tab[#tab + 1] = uchar
  end
  if endIndex and endIndex > #tab or not endIndex then
    endIndex = #tab
  end
  return table.concat(tab, "", startIndex, endIndex)
end
function StringUtil.getTextLen(str)
  local lenInByte = #str
  local len = 0
  local i = 1
  local curByte
  local byteCount = 1
  while lenInByte >= i do
    curByte = string.byte(str, i)
    if curByte > 0 and curByte <= 127 then
      byteCount = 1
    elseif curByte >= 192 and curByte < 223 then
      byteCount = 2
    elseif curByte >= 224 and curByte < 239 then
      byteCount = 3
    elseif curByte >= 240 and curByte <= 247 then
      byteCount = 4
    end
    i = i + byteCount
    len = len + 1
  end
  return len
end
function StringUtil.StringToCharArray(str)
  local result = 0
  local _, count = string.gsub(str, "[^\128-\193]", "")
  local tab = {}
  for uchar in string.gmatch(str, "[%z\001-\127\194-\244][\128-\191]*") do
    tab[#tab + 1] = uchar
  end
  return tab
end
function StringUtil.SubString(str, startIndex, length)
  local maxIndex = math.max(StringUtil.ChLength(str), startIndex + length - 1)
  return StringUtil.Sub(str, startIndex, maxIndex)
end
function StringUtil.Sub(str, startIndex, endIndex)
  local dropping = string.byte(str, endIndex + 1)
  if not dropping then
    return str
  end
  if dropping >= 128 and dropping < 192 then
    return StringUtil.Sub(str, startIndex, endIndex - 1)
  end
  return string.sub(str, startIndex, endIndex)
end
function StringUtil.ChLength(str)
  return #string.gsub(str, "[\128-\255][\128-\255]", " ")
end
function StringUtil.AnalyzeDialogOptionConfig(str)
  local optionformat = "(%{([^%{%}]+)%,(%d+)%})"
  local result = {}
  for _, text, id in string.gmatch(str, optionformat) do
    local optionConfig = {}
    optionConfig.id = tonumber(id)
    optionConfig.text = text
    table.insert(result, optionConfig)
  end
  if #result == 0 then
    local optionConfig = {}
    optionConfig.text = str
    optionConfig.id = 0
    table.insert(result, optionConfig)
  end
  return result
end
function StringUtil.Split(str, delimiter)
  if str == nil or str == "" or delimiter == nil then
    return nil
  end
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end
function StringUtil.Json2Lua(str)
  local luaString = LuaUtils.JsonToLua(str)
  if nil ~= luaString then
    luaString = "return " .. luaString
    local luaFunc = loadstring(luaString)
    if nil ~= luaFunc and type(luaFunc) == "function" then
      local luaObject = luaFunc()
      return luaObject
    end
  else
  end
end
function StringUtil.Lua2Json(tTable, nTabCnt)
  nTabCnt = nTabCnt or 0
  local szJsonStr = "\n"
  assert(type(tTable) == "table", "tTable is not a table.")
  local szTab = ""
  for i = 1, nTabCnt do
    szTab = szTab .. "\t"
  end
  local szKeyType
  for key, value in pairs(tTable) do
    if szKeyType == nil then
      szKeyType = type(key)
      if szKeyType ~= "string" and szKeyType ~= "number" then
        return nil
      end
    end
    if type(key) ~= szKeyType then
      return nil
    end
    szJsonStr = szJsonStr .. "\t" .. szTab
    if szKeyType == "string" then
      szJsonStr = szJsonStr .. string.format("\"%s\" = ", EscDecode(key))
    end
    if type(value) == "table" then
      szJsonStr = szJsonStr .. StringUtil.Lua2Json(value, nTabCnt + 1) .. ",\n"
    else
      if type(value) == "string" then
        value = "\"" .. EscDecode(value) .. "\""
      end
      szJsonStr = szJsonStr .. string.format("%s,\n", value)
    end
  end
  if szJsonStr == "\n" then
    szTab = ""
    szJsonStr = ""
  end
  if szKeyType == "string" then
    return "{" .. szJsonStr .. szTab .. "}"
  else
    return "[" .. szJsonStr .. szTab .. "]"
  end
end
tJson2Lua = {
  ["true"] = {value = true},
  ["null"] = {value = nil},
  ["false"] = {value = false}
}
tStr2Esc = {
  ["\\\""] = "\"",
  ["\\f"] = "\f",
  ["\\b"] = "\b",
  ["\\/"] = "/",
  ["\\\\"] = "\\",
  ["\\n"] = "\n",
  ["\\r"] = "\r",
  ["\\t"] = "\t"
}
tEsc2Str = {
  ["\""] = "\\\"",
  ["\f"] = "\\f",
  ["\b"] = "\\b",
  ["/"] = "\\/",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t"
}
function EscEncode(szString)
  for str, esc in pairs(tStr2Esc) do
    szString = string.gsub(szString, str, esc)
  end
  return szString
end
function EscDecode(szString)
  szString = string.gsub(szString, "\\", "\\\\")
  for esc, str in pairs(tEsc2Str) do
    szString = string.gsub(szString, esc, str)
  end
  return szString
end
function StringUtil.Chsize(char)
  if not char then
    return 0
  elseif char > 240 then
    return 4
  elseif char > 225 then
    return 3
  elseif char > 192 then
    return 2
  else
    return 1
  end
end
function StringUtil.Utf8len(str)
  local len = 0
  local currentIndex = 1
  while currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + StringUtil.Chsize(char)
    len = len + 1
  end
  return len
end
function StringUtil.Replace(str, searchStr, replaceStr)
  local replaceStr = string.gsub(replaceStr, "%%", "%%%%")
  return string.gsub(str, searchStr, replaceStr)
end
function StringUtil.NumThousandFormat(num, deperator)
  if deperator == nil then
    deperator = ","
  end
  deperator = deperator or ","
  local result = ""
  num = math.floor(num)
  local str = tostring(math.abs(num))
  local slength = string.len(str)
  for i = 1, slength do
    result = string.char(string.byte(str, slength + 1 - i)) .. result
    if i % 3 == 0 and i < slength then
      result = deperator .. result
    end
  end
  return num < 0 and "-" .. result or result
end
local RomansMap = {
  {1000, "M"},
  {900, "CM"},
  {500, "D"},
  {400, "CD"},
  {100, "C"},
  {90, "XC"},
  {50, "L"},
  {40, "XL"},
  {10, "X"},
  {9, "IX"},
  {5, "V"},
  {4, "IV"},
  {1, "I"}
}
function StringUtil.IntToRoman(num)
  local k = num
  local roman, val, let = "", nil, nil
  for _, v in ipairs(RomansMap) do
    val, let = v[1], v[2]
    while k >= val do
      k = k - val
      roman = roman .. let
    end
  end
  return roman
end
function StringUtil.FormatTime2TimeStamp(formatTime)
  local t = {}
  local ifs = string.split(formatTime, " ")
  local d1 = string.split(ifs[1], "-")
  t.year, t.month, t.day = tonumber(d1[1]), tonumber(d1[2]), tonumber(d1[3])
  local d2 = string.split(ifs[2], ":")
  t.hour, t.min, t.sec = tonumber(d2[1]), tonumber(d2[2]), tonumber(d2[3])
  return os.time(t)
end
function StringUtil.IsEmpty(content)
  if not content or content == "" then
    return true
  end
end
function StringUtil.LastIndexOf(content, findStr)
  local found = content:reverse():find(findStr:reverse(), nil, true)
  if found then
    return content:len() - findStr:len() - found + 2
  else
    return found
  end
end
function StringUtil.GetDateData(date)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  return date:match(p)
end
function StringUtil.ConvertFileSize(fileSize)
  if fileSize == nil then
    return 0
  end
  local size = fileSize / 1024
  local mb_size = 1024
  local gb_size = 1048576
  local tb_size = 1073741824
  if size < mb_size then
    return {
      string.format("%.2f", size),
      1
    }
  elseif size >= mb_size and size < gb_size then
    return {
      string.format("%.2f", size / mb_size),
      2
    }
  elseif size >= gb_size and size < tb_size then
    return {
      string.format("%.2f", size / gb_size),
      3
    }
  else
    return {
      string.format("%.2f", size / tb_size),
      4
    }
  end
end
function StringUtil.ConvertFileSizeString(fileSize)
  local suffix = {
    "Kb",
    "Mb",
    "Gb",
    "Tb"
  }
  local result = StringUtil.ConvertFileSize(fileSize)
  return result[1] .. " " .. suffix[tonumber(result[2])]
end
