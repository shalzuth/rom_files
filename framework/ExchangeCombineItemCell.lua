autoImport("BaseCombineCell")
ExchangeCombineItemCell = class("ExchangeCombineItemCell", BaseCombineCell)
autoImport("ExchangeItemCell")
function ExchangeCombineItemCell:Init()
  self:InitCells(4, "ExchangeItemCell", ExchangeItemCell)
end
