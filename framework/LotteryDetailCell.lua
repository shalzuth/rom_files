LotteryDetailCell = class("LotteryDetailCell", ItemCell)
function LotteryDetailCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = Vector3.zero
  LotteryDetailCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end
function LotteryDetailCell:FindObjs()
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
    self.rate.spacingX = -1
  end
  self.up = self:FindGO("Up")
  self.fashionUnlock = self:FindGO("FashionUnlock")
  if self.fashionUnlock then
    self.fashionUnlock = self.fashionUnlock:GetComponent(UIMultiSprite)
  end
end
function LotteryDetailCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function LotteryDetailCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    LotteryDetailCell.super.SetData(self, data:GetItemData())
    self:UpdateMyselfInfo(data:GetItemData())
    if self.rate then
      self.rate.text = string.format(ZhString.Lottery_DetailRate, data:GetRate())
    end
    if self.up then
      self.up:SetActive(data.isCurBatch == true)
    end
    if self.fashionUnlock then
      local id = data.itemid
      local equip = Table_Equip[id]
      if equip and equip.GroupID then
        id = equip.GroupID
      end
      local _AdventureDataProxy = AdventureDataProxy.Instance
      if _AdventureDataProxy:IsFashionStored(id) then
        self.fashionUnlock.gameObject:SetActive(true)
        self.fashionUnlock.CurrentState = 1
      elseif _AdventureDataProxy:IsFashionUnlock(id) then
        self.fashionUnlock.gameObject:SetActive(true)
        self.fashionUnlock.CurrentState = 0
      else
        self.fashionUnlock.gameObject:SetActive(false)
      end
    end
  end
  self.data = data
end
