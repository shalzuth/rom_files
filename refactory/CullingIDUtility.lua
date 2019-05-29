CullingIDUtility = class("CullingIDUtility")
local maxID = 1500
local startID = 1
local usedFlags = {}
for i = 1, maxID do
  usedFlags[i] = false
end
function CullingIDUtility.GetID()
  local i = startID
  for j = 1, maxID do
    if i >= maxID then
      i = 1
    end
    if usedFlags[i] == false then
      usedFlags[i] = true
      startID = i + 1
      break
    end
    if j >= maxID then
      errorLog("CullingIDUtility - \230\156\137\230\149\136\231\154\132cullingID\229\183\178\232\162\171\231\148\168\229\174\140\239\188\140\232\175\183\230\137\169\229\164\167id\230\177\160\229\173\144")
      i = 0
    else
      i = i + 1
    end
  end
  return i
end
function CullingIDUtility.ClearID(i)
  if i ~= nil and usedFlags[i] then
    usedFlags[i] = false
    startID = i
    if i >= maxID then
      startID = 1
    end
  end
end
