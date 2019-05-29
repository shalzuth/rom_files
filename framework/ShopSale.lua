autoImport("ShopSaleBagPage")
autoImport("ShopSaleItemPage")
ShopSale = class("ShopSale", ContainerView)
ShopSale.ViewType = UIViewType.NormalLayer
function ShopSale:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end
function ShopSale:Init(viewObj)
  self:FindObjects()
  self:AddViewListeners()
  self.ShopSaleBagPage = self:AddSubView("ShopSaleBagPage", ShopSaleBagPage)
  self.ShopSaleItemPage = self:AddSubView("ShopSaleItemPage", ShopSaleItemPage)
end
function ShopSale:InitUI()
  ShopSaleProxy.Instance.waitSaleItems = {}
  ShopSaleProxy.Instance.waitSaleItemsDic = {}
  self:UpdateMoney()
end
function ShopSale:FindObjects()
  self.gold = self:FindGO("Gold"):GetComponent(UILabel)
  self.silver = self:FindGO("silver"):GetComponent(UILabel)
end
function ShopSale:AddViewListeners()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.TempBagUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.FoodUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.PetUpdate, self.HandleItemUpdate)
  self:AddListenEvt(TempItemEvent.TempWarnning, self.HandleItemUpdate)
  self:AddListenEvt(ItemEvent.ItemReArrage, self.HandleItemReArrage)
end
function ShopSale:UpdateMoney()
  self.gold.text = MyselfProxy.Instance:GetGold()
  self.silver.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end
function ShopSale:HandleItemUpdate(note)
  self.ShopSaleItemPage:HandleItemUpdate()
  self.ShopSaleBagPage:HandleItemUpdate()
end
function ShopSale:HandleItemReArrage(note)
  self.ShopSaleItemPage:HandleItemUpdate()
  self.ShopSaleBagPage:HandleItemReArrage()
end
function ShopSale:handleCameraQuestStart()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local npcData = viewdata.npcdata
    if npcData then
      self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
    end
  else
    self:CameraRotateToMe()
  end
end
function ShopSale:OnEnter()
  ShopSale.super.OnEnter(self)
  self:handleCameraQuestStart()
  self:InitUI()
end
function ShopSale:OnExit()
  self.super.OnExit(self)
  self:CameraReset()
  TipsView.Me():HideCurrent()
end
