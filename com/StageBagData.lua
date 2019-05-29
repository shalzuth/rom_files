autoImport("ItemData")
StageBagData = class("StageBagData")
function StageBagData:ctor(tab)
  self.items = {}
  self.tab = tab
  self.itemsMap = {}
  self.colors = {}
end
function StageBagData:initTabDatas()
end
function StageBagData:AddItem(itemid, itemdata)
  if itemdata ~= nil then
    self.itemsMap[itemid] = itemdata
    self.items[#self.items + 1] = itemdata
  end
end
function StageBagData:AddColor(id)
  if id then
    self.colors[#self.colors + 1] = id
  end
end
function StageBagData:GetItems(tabType)
  if tabType ~= nil then
    local tab = self.tabs[tabType]
    if tab ~= nil then
      return tab:GetItems()
    end
  end
end
function StageBagData.CheckValid(staticData)
  if not staticData then
    return true
  end
  if StringUtil.IsEmpty(staticData.ValidDate) and StringUtil.IsEmpty(staticData.TFValidDate) then
    return true
  end
  local validDate
  if EnvChannel.IsReleaseBranch() then
    validDate = staticData.ValidDate
  elseif EnvChannel.IsTFBranch() then
    validDate = staticData.TFValidDate
  end
  if not StringUtil.IsEmpty(validDate) and ServerTime.CurServerTime() then
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = validDate:match(p)
    local ddd = tonumber(os.date("%z", 0)) / 100
    local offset = (8 - ddd) * 3600
    local startDate = os.time({
      day = day,
      month = month,
      year = year,
      hour = hour,
      min = min,
      sec = sec
    })
    startDate = startDate - offset
    local server = ServerTime.CurServerTime() / 1000
    if startDate > server then
      return false
    end
  end
  return true
end
