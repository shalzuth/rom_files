function math.KeepDecimalPlaces(fValue, n)
  if type(fValue) == "number" and type(n) == "number" then
    local tenPower = math.pow(10, n)
    local value = fValue * tenPower
    value = math.floor(value)
    return value / tenPower
  end
  return fValue
end
math.Epsilon = 1.0E-5
function math.Approximately(a, b)
  return a >= b - math.Epsilon and a <= b + math.Epsilon
end
function math.CalculateRemainder(divident, divisor)
  local result = -1
  if divident > 0 and divisor > 0 then
    if divident < divisor then
      result = divident
    elseif divident == divisor then
      result = 0
    else
      local isBreak = false
      while not isBreak do
        divident = divident - divisor
        if divisor > divident then
          result = divident
          isBreak = true
        end
      end
    end
  end
  return result
end
function math.CalculateQuotient(divident, divisor)
  local result = -1
  if divident > 0 and divisor > 0 then
    if divident < divisor then
      result = 0
    elseif divident == divisor then
      result = 1
    else
      local temp = 0
      local isBreak = false
      while not isBreak do
        divident = divident - divisor
        temp = temp + 1
        if divisor > divident then
          isBreak = true
        end
      end
      result = temp
    end
  end
  return result
end
function math.IsInteger(number)
  return math.floor(number) == number
end
function table.ContainsKey(tab, key)
  return tab[key] ~= nil
end
function table.ContainsValue(tab, value)
  if value == nil then
    return false
  end
  if tab then
    for _, v in pairs(tab) do
      if v == value then
        return true
      end
    end
  end
  return false
end
function table.IsEmpty(tab)
  if tab == nil then
    return true
  end
  for _, v in pairs(tab) do
    if v then
      return false
    end
  end
  return true
end
function table.IsNest(tab)
  if tab == nil then
    return false
  end
  for _, v in pairs(tab) do
    if v and type(v) == "table" then
      return true
    end
  end
  return false
end
function table.IsArray(tab)
  if tab == nil then
    return false
  end
  local indicator = 1
  for k, v in pairs(tab) do
    if type(k) ~= "number" or k ~= indicator then
      return false
    end
    indicator = indicator + 1
  end
  return true
end
function table.KeyIsLast(tab, kValue)
  if kValue and tab then
    local tabKey = {}
    for k, _ in pairs(tab) do
      table.insert(tabKey, k)
    end
    if not table.IsEmpty(tabKey) then
      local lastKey = tabKey[#tabKey]
      if type(kValue) == type(lastKey) and kValue == lastKey then
        return true
      end
    end
  end
  return false
end
function table.EqualTo(tab1, tab2)
  if tab1 == tab2 then
    return true
  end
  if tab1 == nil or tab2 == nil then
    return false
  end
  for k, v in pairs(tab1) do
    if v ~= tab2[k] then
      return false
    end
  end
  return true
end
local tabSymbolCount = 0
function Tab()
  local retValue = ""
  if tabSymbolCount > 0 then
    for i = 1, tabSymbolCount do
      retValue = retValue .. "\t"
    end
  end
  return retValue
end
local table_insert = table.insert
function Serialize(obj, depth)
  depth = depth or 1
  local t = type(obj)
  if t == "number" then
    return obj
  end
  if t == "string" then
    obj = string.gsub(obj, "\\", "\\\\")
    obj = string.gsub(obj, "\n", "\\n")
    return "'" .. tostring(obj) .. "'"
  end
  if t == "table" then
    local str_array = {}
    table_insert(str_array, "{")
    local keys = {}
    for k, v in pairs(obj) do
      table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
      return b < a
    end)
    for i = 1, #keys do
      local k, v = keys[i], obj[keys[i]]
      local strK
      local kType = type(k)
      if kType == "string" then
        strK = tostring(k)
      elseif kType == "number" then
        strK = "[" .. k .. "]"
      end
      if depth == 1 then
        strK = [[

	]] .. strK
      end
      table_insert(str_array, " ")
      table_insert(str_array, strK)
      table_insert(str_array, " = ")
      table_insert(str_array, Serialize(v, depth + 1))
      table_insert(str_array, ",")
    end
    if #keys == 0 then
      return "_EmptyTable"
    end
    if depth == 1 then
      table_insert(str_array, "\n")
    end
    table_insert(str_array, "}")
    return table.concat(str_array)
  end
  if t == "boolean" then
    return tostring(obj)
  end
  if depth == 1 then
    return "{}"
  end
  return "nil"
end
