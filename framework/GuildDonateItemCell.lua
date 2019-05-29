local BaseCell = autoImport("BaseCell")
GuildDonateItemCell = class("GuildDonateItemCell", BaseCell)
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, DONATE_MATERIAL_SEARCH_BAGTYPES
function GuildDonateItemCell:Init()
  local pacakgeCheck = GameConfig.PackageMaterialCheck
  if not pacakgeCheck or not pacakgeCheck.default then
  end
  DEFAULT_MATERIAL_SEARCH_BAGTYPES = {1, 9}
  DONATE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.guilddonate or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  local simpleItemGO = self:FindGO("SimpleItemCell")
  self.itemcell = ItemCell.new(simpleItemGO)
  self.itemname = self:FindComponent("ItemName", UILabel)
  self.donateLabel = self:FindComponent("DonateReward", UILabel)
  self.goldMetalLabel = self:FindComponent("GoldMetal", UILabel)
  self.goldMetalSprite = self:FindComponent("Sprite", UISprite, self.goldMetalLabel.gameObject)
  self.leftTime = self:FindComponent("LeftTime", UILabel)
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("Label", UILabel, self.multiplySymbol.gameObject)
  self:SetEvent(self.gameObject, function()
    if self.active then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end
function GuildDonateItemCell.GetDonateItemNum(itemid)
  local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, DONATE_MATERIAL_SEARCH_BAGTYPES)
  local searchNum = 0
  for i = 1, #items do
    searchNum = searchNum + items[i].num
  end
  return searchNum
end
function GuildDonateItemCell:SetData(data)
  self.data = data
  if data then
    local itemData = ItemData.new("DonateItem", data.itemid)
    self.itemcell:SetData(itemData)
    itemData.num = data.itemcount
    local hasNum = GuildDonateItemCell.GetDonateItemNum(data.itemid)
    self.itemname.text = string.format(ZhString.GuildDonateItemCell_ItemName, itemData.staticData.NameZh, hasNum, itemData.num)
    self.donateLabel.text = data.contribute or 0
    local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.GuildDonate)
    local discount = rewardInfo and rewardInfo:GetMultiple() or 1
    if discount <= 1 then
      self.multiplySymbol:SetActive(false)
    else
      self.multiplySymbol:SetActive(true)
      self.multiplySymbol_label.text = "*" .. math.floor(discount)
    end
    self.leftTime.text = ClientTimeUtil.GetFormatOfflineTimeStr(data.time)
    if data.medal == nil or data.medal == 0 then
      self.goldMetalLabel.gameObject:SetActive(false)
    else
      self.goldMetalLabel.gameObject:SetActive(true)
      self.goldMetalLabel.text = data.medal
    end
    IconManager:SetItemIcon("item_5261", self.goldMetalSprite)
    local count = data.count or 0
    self:ActiveGrey(count > 0)
  end
end
function GuildDonateItemCell:ActiveGrey(b)
  if b then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
  end
  self.active = not b
end
