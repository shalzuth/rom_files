EmbedViewSlotCell = class("EmbedViewSlotCell", BaseCell)
function EmbedViewSlotCell:Init()
  self:initView()
end
function EmbedViewSlotCell:initView()
  self.icon = self.gameObject:GetComponent(UISprite)
end
function EmbedViewSlotCell:SetData(data)
  self.data = data
  if data.staticData == nil then
    self.icon.spriteName = "card_icon_0"
  else
    local iconStr = "card_icon_" .. data.staticData.Quality
    self.icon.spriteName = iconStr
  end
end
