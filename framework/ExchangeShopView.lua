autoImport("ExchangeShopItemCell")
ExchangeShopView = class("ExchangeShopView", ContainerView)
ExchangeShopView.ViewType = UIViewType.NormalLayer
local Texture_Bg = {
  Buttom = "chaes_bg_bottom",
  Pattern = "chaes_bg_pattern",
  Corolla = "chase_bg_Corolla"
}
function ExchangeShopView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddEvt()
  self:InitShow()
end
function ExchangeShopView:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.modelTex = self:FindComponent("ModelTex", UITexture)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.bgTex1 = self:FindComponent("BgTex1", UITexture)
  self.patternTex = self:FindComponent("PatternTex", UITexture)
  self.patternTex1 = self:FindComponent("PatternTex1", UITexture)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.helpBtn = self:FindGO("HelpBtn")
  self.titleDesc = self:FindComponent("TitleDesc", UILabel)
end
function ExchangeShopView:AddEvt()
  self:AddClickEvent(self.helpBtn, function()
    local data = Table_Help[1800]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
end
function ExchangeShopView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopUpdateExchangeShopData, self.ResetData)
  self:AddListenEvt(ServiceEvent.SessionShopExchangeShopItemCmd, self.HideGoodsTip)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.ResetData)
end
function ExchangeShopView:HideGoodsTip()
  TipManager.Instance:HideExchangeGoodsTip()
end
function ExchangeShopView:InitShow()
  self.title.text = ZhString.ExchangeShop_Title
  self.titleDesc.text = ZhString.ExchangeShop_TitleDesc
  self.desc.text = ZhString.ExchangeShop_Desc
  PictureManager.Instance:SetExchangeShop(Texture_Bg.Corolla, self.modelTex)
  PictureManager.Instance:SetExchangeShop(Texture_Bg.Pattern, self.patternTex)
  PictureManager.Instance:SetExchangeShop(Texture_Bg.Pattern, self.patternTex1)
  PictureManager.Instance:SetExchangeShop(Texture_Bg.Buttom, self.bgTex)
  PictureManager.Instance:SetExchangeShop(Texture_Bg.Buttom, self.bgTex1)
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 4,
    cellName = "ExchangeShopItemCell",
    control = ExchangeShopItemCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self:ResetData()
end
function ExchangeShopView:ResetData()
  local data = ExchangeShopProxy.Instance:GetExchangeShopData()
  if not data then
    return
  end
  self.itemWrapHelper:UpdateInfo(data)
  self.itemWrapHelper:ResetPosition()
end
function ExchangeShopView:OnClickCell(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  if ExchangeShopProxy.GoodsTYPE.EMPTY == data.status then
    return
  end
  local type = data.staticData.ExchangeType
  if type == ExchangeShopProxy.EnchangeType.COINS then
    local sysId = data.staticData.Type <= 2 and 2712 or 2711
    if MyselfProxy.Instance:GetLottery() < data.staticData.Cost[2] then
      MsgManager.ShowMsgByID(3634)
      return
    end
    MsgManager.ConfirmMsgByID(sysId, function()
      ExchangeShopProxy.Instance:CallExchange(data.goodsId)
    end, nil)
  elseif type == ExchangeShopProxy.EnchangeType.FRESS then
    ExchangeShopProxy.Instance:CallExchange(data.goodsId)
  else
    ExchangeShopProxy.Instance:ResetChoose()
    TipManager.Instance:ShowExchangeGoodsTip(data, self.tipStick, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end
function ExchangeShopView:OnExit()
  PictureManager.Instance:UnloadExchangeShop()
  GameFacade.Instance:sendNotification(ExchangeShopEvent.ExchangeShopShow)
end
