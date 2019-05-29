Aaacplh = class("Aaacplh")
function Aaacplh:ctor()
  self.clickPosList = {}
end
function Aaacplh:Send(clickPosList)
  if not clickPosList or not next(clickPosList) then
    return
  end
  local item
  for i = 1, #clickPosList do
    local element = clickPosList[i]
    if element.count and element.count > 0 then
      item = ReusableTable.CreateTable()
      item.button = element.button or element.enum
      item.pos = element.pos or 0
      item.count = element.count
      TableUtility.ArrayPushBack(self.clickPosList, item)
    end
  end
  ServiceNUserProxy.Instance:CallClickPosList(self.clickPosList)
  self:Clear()
end
function Aaacplh:Clear()
  for i = 1, #self.clickPosList do
    ReusableTable.DestroyAndClearTable(self.clickPosList[i])
  end
  TableUtility.ArrayClear(self.clickPosList)
end
