BitUtil = {}
bit = require("bit")
BitUtil.data32 = {}
for i = 1, 32 do
  BitUtil.data32[i] = 2 ^ (32 - i)
end
local int32 = {}
for i = 0, 31 do
  int32[i] = 2 ^ i
end
function BitUtil.valid(num, index)
  return num >= int32[index]
end
function BitUtil.band(num, index)
  return bit.band(num, int32[index])
end
function BitUtil.bandOneZero(num, index)
  return bit.band(num, int32[index]) > 0 and 1 or 0
end
function BitUtil.bor(num, index)
  return bit.bor(num, int32[index])
end
function BitUtil.setbit(num, index)
  return BitUtil.band(num, index) > 0 and num or num + int32[index]
end
function BitUtil.unsetbit(num, index)
  return BitUtil.band(num, index) <= 0 and num or num - int32[index]
end
function BitUtil.d2b(arg)
  arg = arg or 0
  local bits = {}
  for i = 1, 32 do
    if arg >= BitUtil.data32[i] then
      bits[i] = 1
      arg = arg - BitUtil.data32[i]
    else
      bits[i] = 0
    end
  end
  return bits
end
function BitUtil.b2d(arg)
  local nr = 0
  for i = 1, 32 do
    if arg[i] == 1 then
      nr = nr + 2 ^ (32 - i)
    end
  end
  return nr
end
function BitUtil.lshift(a, n)
  local op1 = BitUtil.d2b(a)
  local r = BitUtil.d2b(0)
  if n < 32 and n > 0 then
    for i = 1, n do
      for i = 1, 31 do
        op1[i] = op1[i + 1]
      end
      op1[32] = 0
    end
    r = op1
  end
  return BitUtil.b2d(r)
end
