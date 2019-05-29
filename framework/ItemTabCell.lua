ItemTabCell = class("ItemTabCell", BaseCell)
local ItemTabType_MainBag_Icon = {
  [0] = {
    [0] = "bag_icon_all"
  },
  [ItemNormalList.TabType.ItemPage] = {
    [-1] = "bag_icon_like",
    [0] = "bag_icon_all",
    [1] = "bag_icon_1",
    [2] = "bag_icon_2",
    [3] = "bag_icon_3",
    [4] = "bag_icon_5"
  },
  [ItemNormalList.TabType.FashionPage] = {
    [0] = "bag_icon_all",
    [1] = "bag_equip_2",
    [2] = "bag_equip_7",
    [3] = "bag_equip_8",
    [4] = "bag_equip_9",
    [5] = "bag_equip_10",
    [6] = "bag_equip_11",
    [7] = "bag_equip_12",
    [8] = "bag_equip_13"
  },
  [ItemNormalList.TabType.FoodPage] = {
    [0] = "bag_icon_all",
    [1] = "bag_icon_6",
    [2] = "bag_icon_4"
  }
}
local ItemTabType_Fashion_Site = {
  [1] = 2,
  [2] = 7,
  [3] = 8,
  [4] = 9,
  [5] = 10,
  [6] = 11,
  [7] = 12,
  [8] = 13
}
function ItemTabCell:Init()
  ItemTabCell.super.Init(self)
  self.sp1 = self:FindComponent("sprite1", UISprite)
  self.sp2 = self:FindComponent("sprite2", UISprite)
  self.tog = self.gameObject:GetComponent(UIToggle)
  self:SetEvent(self.gameObject, function()
    self:SetTog(true)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function ItemTabCell:SetTog(v)
  self.tog:Set(v)
end
function ItemTabCell:SetGroup(g)
  g = g or 0
  self.tog.group = g
end
function ItemTabCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.data = data
  local spName
  local tabType = data.tabType
  if tabType == ItemNormalList.TabType.FashionPage then
    local fashionEquip = BagProxy.Instance.fashionEquipBag.siteMap[ItemTabType_Fashion_Site[data.index]]
    if fashionEquip then
      spName = fashionEquip.staticData.Icon
      IconManager:SetItemIcon(spName, self.sp1)
      IconManager:SetItemIcon(spName, self.sp2)
      self.sp1:MakePixelPerfect()
      self.sp1.width = self.sp1.width * 0.6
      self.sp1.height = self.sp1.height * 0.6
      self.sp2:MakePixelPerfect()
      self.sp2.width = self.sp2.width * 0.6
      self.sp2.height = self.sp2.height * 0.6
      return
    end
  end
  local iconMap = tabType and ItemTabType_MainBag_Icon[tabType]
  iconMap = iconMap or ItemTabType_MainBag_Icon[0]
  spName = iconMap and iconMap[data.index]
  if spName then
    local ui1 = RO.AtlasMap.GetAtlas("NewUI1")
    local getSData = ui1:GetSprite(spName)
    if getSData then
      self.sp1.atlas = ui1
      self.sp1.spriteName = spName
      self.sp2.atlas = ui1
      self.sp2.spriteName = spName
      self.sp1:MakePixelPerfect()
      self.sp2:MakePixelPerfect()
    else
      IconManager:SetUIIcon(spName, self.sp1)
      IconManager:SetUIIcon(spName, self.sp2)
      self.sp1:MakePixelPerfect()
      self.sp1.width = self.sp1.width * 0.6
      self.sp1.height = self.sp1.height * 0.6
      self.sp2:MakePixelPerfect()
      self.sp2.width = self.sp2.width * 0.6
      self.sp2.height = self.sp2.height * 0.6
    end
  end
end
