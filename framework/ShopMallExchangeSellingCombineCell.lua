autoImport("ShopMallExchangeDetailCell")
local baseCell = autoImport("BaseCell")
ShopMallExchangeSellingCombineCell = class("ShopMallExchangeSellingCombineCell", baseCell)
function ShopMallExchangeSellingCombineCell:Init()
  self.childNum = self.gameObject.transform.childCount
  self:FindObjs()
end
function ShopMallExchangeSellingCombineCell:FindObjs()
  self.childrenObjs = {}
  local go
  for i = 1, self.childNum do
    go = self:FindChild("child" .. i)
    self.childrenObjs[i] = ShopMallExchangeDetailCell.new(go)
  end
end
function ShopMallExchangeSellingCombineCell:AddEventListener(eventType, handler, handlerOwner)
  for i = 1, #self.childrenObjs do
    self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner)
  end
end
function ShopMallExchangeSellingCombineCell:SetData(data)
  self.data = data
  self:UpdateInfo()
end
function ShopMallExchangeSellingCombineCell:GetDataByChildIndex(index)
  if self.data == nil then
    return nil
  else
    return self.data[index]
  end
end
function ShopMallExchangeSellingCombineCell:UpdateInfo()
  for i = 1, #self.childrenObjs do
    local cData = self:GetDataByChildIndex(i)
    local cell = self.childrenObjs[i]
    cell:SetData(cData)
    cell.gameObject:SetActive(cData ~= nil)
  end
end
function ShopMallExchangeSellingCombineCell:OnDestroy()
  for i = 1, #self.childrenObjs do
    local cell = self.childrenObjs[i]
    cell:OnDestroy()
  end
end
