LotteryCoinInfo = class("LotteryCoinInfo", ContainerView)
LotteryCoinInfo.ViewType = UIViewType.PopUpLayer
function LotteryCoinInfo:Init()
  local TotalPrice = self:FindGO("TotalPrice", self:FindGO("TotalPriceBg")):GetComponent(UILabel)
  TotalPrice.text = MyselfProxy.Instance:GetLottery() - MyselfProxy.Instance:GetFreeLottery()
  local TotalPrice1 = self:FindGO("TotalPrice", self:FindGO("TotalPriceBg1")):GetComponent(UILabel)
  TotalPrice1.text = MyselfProxy.Instance:GetFreeLottery()
end
function LotteryCoinInfo:OnEnter()
  self.super.OnEnter(self)
end
function LotteryCoinInfo:OnExit()
end
