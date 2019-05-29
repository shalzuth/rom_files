autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("DyeHairCombineItemCell")
HairDyePage = class("HairDyePage", DressingPage)
function HairDyePage:FindObjs()
  self.super.FindObjs(self)
  self.root = self:FindGO("dyeWrap")
end
function HairDyePage:InitPageView()
  local staticData = ShopDressingProxy.Instance.staticData
  if not staticData then
    return
  end
  local data = staticData[ShopDressingProxy.DressingType.HAIRCOLOR]
  if not data then
    return
  end
  local newData = ShopDressingProxy.Instance:ReUniteCellData(data, 5)
  if self.itemWrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.root,
      pfbNum = 5,
      cellName = "DyeHairCombineItemCell",
      control = DyeHairCombineItemCell
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  end
  self.itemWrapHelper:UpdateInfo(newData)
end
local args = {}
function HairDyePage:OnClickItem(cellctl)
  if cellctl and cellctl.data and cellctl ~= self.chooseCtl then
    self.chooseCtl = cellctl
    local data = self.chooseCtl.data
    ShopDressingProxy.Instance.chooseData = data
    self:SetChoose(data.id)
    if data then
      args[1] = ShopDressingProxy.DressingType.HAIRCOLOR
      args[2] = data.id
      args[3] = data.ItemCount
      ShopDressingProxy.Instance:SetQueryData(args)
      self.container:RefreshModel()
      local costID = data.ItemID
      local needCount = data.ItemCount
      local pagetype = self.container.pageType
      local precost = data.PreCost
      self.container:RefreshSelectedROB(pagetype, precost, costID, needCount)
    else
      self.container:DisableState()
    end
  end
end
