autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("EyeLensesCombineItemCell")
EyeLensesPage = class("EyeLensesPage", DressingPage)
function EyeLensesPage:InitPageView()
  local staticData = ShopDressingProxy.Instance.staticData
  if not staticData then
    return
  end
  local tableData = staticData[ShopDressingProxy.DressingType.EYE]
  if not tableData then
    return
  end
  local newData = ShopDressingProxy.Instance:ReUniteCellData(tableData, 3)
  if self.itemWrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.itemRoot,
      pfbNum = 3,
      cellName = "EyeLensesCombineItemCell",
      control = EyeLensesCombineItemCell,
      dir = 1
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  end
  self.itemWrapHelper:UpdateInfo(newData)
end
local args = {}
local defaultCount = 1
function EyeLensesPage:OnClickItem(cellctl)
  if cellctl and cellctl.data and cellctl ~= self.chooseCtl then
    self.chooseCtl = cellctl
    ShopDressingProxy.Instance.chooseData = self.chooseCtl.data
    local data = self.chooseCtl.data
    self:SetChoose(data.id)
    if nil ~= data then
      args[1] = ShopDressingProxy.DressingType.EYE
      args[2] = data.id
      args[3] = defaultCount
      ShopDressingProxy.Instance:SetQueryData(args)
      self:RefreshChooseUI(data)
      self.container:RefreshModel()
    else
      self.container:DisableState()
    end
  end
end
function EyeLensesPage:RefreshChooseUI(chooseData)
  self:SetDes(chooseData)
  self:SetMenuDes(chooseData, ShopDressingProxy.DressingType.EYE)
  local id = chooseData.id
  local eyeID = chooseData.goodsID
  local moneyID = chooseData.ItemID
  local itemCount = chooseData.ItemCount
  self.container:RefreshLensesROB(moneyID, itemCount, eyeID)
end
