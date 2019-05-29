RandomUtil = {}
function RandomUtil.Clamp(value, min, max)
  if value < min then
    return min
  end
  if max < value then
    return max
  end
  return value
end
function RandomUtil.Range(min, max)
  local p = math.random()
  p = min + p * (max - min)
  return p
end
function RandomUtil.RoundTableSelect(arg)
  local p = math.random()
  local lastIndex = 0
  local mark = 0
  for i, v in ipairs(arg) do
    mark = mark + v
    lastIndex = i
    if not (p <= mark) then
    end
  end
  return lastIndex, p
end
function RandomUtil.RoundInt(p)
  local p1 = math.floor(p)
  if p >= p1 + 0.5 then
    p = math.ceil(p)
  else
    p = p1
  end
  return p
end
function RandomUtil.RandomInTable(t)
  if t and #t > 0 then
    return t[math.random(1, #t)]
  end
  return nil
end
function RandomUtil.RandomInCircle()
  return RandomUtil.Range(-1, 1), RandomUtil.Range(-1, 1)
end
function RandomUtil.PingPong(v, min, max)
  local dirChanged = false
  if v < min then
    local dist = max - min
    repeat
      v = v + dist
    until min < v
    v = max - v
    dirChanged = true
  elseif max < v then
    local dist = max - min
    repeat
      v = v - dist
    until max > v
    v = max - v
    dirChanged = true
  end
  return v, dirChanged
end
