DressingPage = class("DressingPage", SubView)
function DressingPage:Init()
  self:FindObjs()
  self:AddEvent()
  self:InitPageView()
end
function DressingPage:AddEvent()
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.UpdateShop)
end
function DressingPage:UpdateShop()
  ShopDressingProxy.Instance:ResetData()
  self:InitPageView()
end
function DressingPage:FindObjs()
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.menuDes = self:FindGO("menuDes"):GetComponent(UILabel)
  self.itemRoot = self:FindGO("Wrap")
end
function DressingPage:InitPageView()
  self.itemWrapHelper = nil
end
function DressingPage:SetDes(data)
  if data.des and data.des ~= "" then
    self:Show(self.desc)
    self.desc.text = data.des
  else
    self:Hide(self.desc)
  end
end
function DressingPage:SetMenuDes(data, type)
  local bUnlock = true
  if type == ShopDressingProxy.DressingType.ClothColor then
    bUnlock = ShopDressingProxy.Instance:CheckCanOpen(data.MenuID)
  else
    local id = type == ShopDressingProxy.DressingType.EYE and data.goodsID or ShopDressingProxy.Instance:GetHairStyleIDByItemID(data.goodsID)
    bUnlock = ShopDressingProxy.Instance:bActived(id, type)
  end
  if bUnlock == false then
    self:Show(self.menuDes)
    self.menuDes.text = data:GetMenuDes()
  else
    self:Hide(self.menuDes)
  end
end
function DressingPage:OnEnter()
  DressingPage.super.OnEnter(self)
  self:UpdateShop()
end
function DressingPage:OnExit()
  DressingPage.super.OnExit(self)
end
function DressingPage:SetChoose(id)
  if not self.itemWrapHelper then
    return
  end
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local cell = cells[i]
    for j = 1, #cell.childrenObjs do
      local child = cell.childrenObjs[j]
      child:SetChoose(id)
    end
  end
end
