autoImport("BaseTip")
autoImport("ExchangeCombineItemCell")
ExchangeGoodsTip = class("ExchangeGoodsTip", BaseTip)
local FORMAT = string.format
local MULTI_FLAG = "Contribution"
ExchangeGoodsTip.TYPE = {PROGRESS = 1, NO_PROGRESS = 2}
function ExchangeGoodsTip:Init()
  self:FindObj()
  self:AddEvts()
  self:InitView()
  ExchangeShopProxy.Instance:InitStaticData()
end
function ExchangeGoodsTip:InitView()
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 4,
    cellName = "ExchangeCombineItemCell",
    control = ExchangeCombineItemCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(ExchangeItemCellEvent.LongPress, self.OnClickCell, self)
  self.itemWrapHelper:AddEventListener(ExchangeItemCellEvent.LongPressSubtract, self.OnMinusItem, self)
  ExchangeShopProxy.Instance:ResetChoose()
end
function ExchangeGoodsTip:FindObj()
  self.exchangeRoot = self:FindGO("ExchangeRoot")
  self.progressRewardIcon = self:FindComponent("ProgressRewardIcon", UISprite)
  self.chooseNumLab = self:FindComponent("ChooseNumLab", UILabel)
  self.targetNumLab = self:FindComponent("TargetNumLab", UILabel)
  self.contributionNumLab = self:FindComponent("ContributionNumLab", UILabel)
  self.exchangeRewardIcon = self:FindComponent("ExchangeTarget", UISprite)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.scrollview = self:FindComponent("ScrollView", UIScrollView)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.EmptyBg = self:FindComponent("EmptyBg", UISprite)
  self.contributionPos = self:FindGO("Contribution")
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  ExchangeGoodsTip.super.Init(self)
end
function ExchangeGoodsTip:AddEvts()
  self:AddClickEvent(self.confirmBtn, function(go)
    self:OnClickConfirm()
  end)
  self:AddClickEvent(self.cancelBtn, function(go)
    self:CloseSelf()
  end)
end
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
function ExchangeGoodsTip:SetData(data)
  self.data = data
  if not self.data then
    return
  end
  self.id = data.goodsId
  self.nameLab.text = data.staticData.Name
  local rewardId = ExchangeShopProxy.Instance:GetRewardByGoods(self.id)
  self.contributionPos:SetActive(data.staticData.Source == 1)
  if rewardId then
    IconManager:SetItemIcon(Table_Item[rewardId].Icon, self.exchangeRewardIcon)
  end
  self:UpdateExchange(ExchangeShopProxy.Instance:GetChooseNum())
  local goods = ExchangeShopProxy.Instance.goodsMap[data.goodsId]
  if not goods then
    return
  end
  goods = ReUniteCellData(goods, 4)
  self.itemWrapHelper:ResetDatas(goods)
end
function ExchangeGoodsTip:UpdateExchange(goodsNum, rewardNum, extraNum)
  self.chooseNumLab.text = FORMAT(ZhString.ExchangeShop_ChooseNum, goodsNum)
  self.targetNumLab.text = FORMAT(ZhString.ExchangeShop_RewardNum, rewardNum)
  self.contributionNumLab.text = FORMAT(ZhString.ExchangeShop_RewardNum, extraNum)
end
function ExchangeGoodsTip:UpdateGoods(id)
  local chooseitems = ExchangeShopProxy.Instance:_getChooseItem()
  self:UpdateExchange(ExchangeShopProxy.Instance:GetChooseNum())
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local single = cells[i]:GetCells()
    for j = 1, #single do
      if single[j].data and single[j].data.staticData.id == id then
        single[j]:UpdateOwn()
      end
    end
  end
  if chooseitems and #chooseitems == 1 then
    IconManager:SetItemIcon(Table_Item[chooseitems[1].id].Icon, self.EmptyBg)
  else
    IconManager:SetUIIcon(MULTI_FLAG, self.EmptyBg)
  end
end
function ExchangeGoodsTip:OnClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  local ownCount = BagProxy.Instance:GetItemNumByStaticID(data.staticData.id)
  if not ownCount or 0 == ownCount then
    return
  end
  local worth_cfg = ExchangeShopProxy.Instance.goodsWorth[data.staticData.id]
  local worthNum = worth_cfg and worth_cfg[2] or 1
  local progressLimit = self.data.staticData.ExchangeLimit
  local previewCount, chooseNum = ExchangeShopProxy.Instance:GetChooseNum()
  if nil == progressLimit or #progressLimit <= 0 then
    redlog("Table_ExchangeShop ExchangeLimit \229\173\151\230\174\181\230\156\170\233\133\141\231\189\174")
  end
  local exchangeType = self.data.staticData.ExchangeType
  local needLimit = exchangeType == ExchangeShopProxy.EnchangeType.PROGRESS or exchangeType == ExchangeShopProxy.EnchangeType.Limited_PROGRESS or exchangeType == ExchangeShopProxy.EnchangeType.MEDAL_PROGRESS
  if needLimit then
    local isMedal = exchangeType == ExchangeShopProxy.EnchangeType.MEDAL_PROGRESS or self.data.isKapulaExchangeType == true
    local userMedalCount = Game.Myself.data.userdata:Get(UDEnum.TOTAL_MEDALCOUNT) or 0
    local c = isMedal and userMedalCount or self.data.exchangeCount
    local limit = progressLimit[self.data.progress] - c - chooseNum
    if worthNum > limit then
      MsgManager.ShowMsgByID(2710)
      return
    end
  end
  ExchangeShopProxy.Instance:AddChooseItems(data.staticData.id)
  self:UpdateGoods(data.staticData.id)
end
function ExchangeGoodsTip:OnMinusItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  ExchangeShopProxy.Instance:MinusChooseItem(data.staticData.id)
  self:UpdateGoods(data.staticData.id)
end
function ExchangeGoodsTip:OnClickConfirm()
  ExchangeShopProxy.Instance:CallExchange(self.id)
end
function ExchangeGoodsTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end
function ExchangeGoodsTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
