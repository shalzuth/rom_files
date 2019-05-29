autoImport("ItemData")
ExchangeItemData = class("ExchangeItemData", ItemData)
function ExchangeItemData:ctor(config)
  ExchangeItemData.super.ctor(self, "exchange", config.ItemID)
  self.config = config
end
