local BaseCell = autoImport("BaseCell")
jihuacell = class("jihuacell", BaseCell)
jihuacell.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
jihuacell.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
jihuacell.ChooseImgColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
jihuacell.NormalImgColor = Color(0, 0, 0, 1)
autoImport("ServantImproveCell")
function jihuacell:Init()
  self.choose = false
  self.Back1 = self:FindGO("Back1")
  self.Back1_UISprite = self.Back1:GetComponent(UISprite)
  self.Back2 = self:FindGO("Back2")
  self.Back2_UISprite = self.Back2:GetComponent(UISprite)
  self.expand = self:FindGO("Expand")
  self.redPoint = self:FindGO("RedPoint")
  self.lock = self:FindGO("Lock")
  self.finishMark = self:FindGO("FinishMark")
  self.description = self:FindComponent("Description", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.cellName = self:FindComponent("Name", UILabel)
  self.cellTitle = self:FindComponent("Title", UILabel)
  self.cellTitle2 = self:FindComponent("Title2Desc", UILabel)
  self.cellBtnSprite = self:FindComponent("Btn", UISprite)
  self.btnText = self:FindComponent("BtnText", UILabel)
  self.awardItemIcon = self:FindComponent("AwardItemIcon", UISprite)
  self.awardItemCount = self:FindComponent("AwardItemCount", UILabel)
  self.content = self:FindGO("Content")
  self.title2 = self:FindGO("Title2")
  self.growthCount = self:FindComponent("Award", UILabel)
  self.Content = self:FindGO("Content")
  self.Content_Btn = self:FindGO("Btn", self.Content)
  self:AddCellClickEvent()
  self:AddButtonEvent("Btn", function(obj)
    if ServantRecommendProxy.CheckDateValid(self.data.staticData) then
      self:PassEvent(ServantImproveEvent.TraceBtnClick, self)
    else
      MsgManager.ShowMsgByID(5209)
    end
  end)
  self.State1 = self:FindGO("State1")
  self.State2 = self:FindGO("State2")
  self.State1_Btn = self:FindGO("Btn", self.State1)
  self.State1_Btn.gameObject:SetActive(false)
  self.State1_NameForProgress = self:FindGO("NameForProgress", self.state1)
  self.State1_NameForProgress_UILabel = self.State1_NameForProgress:GetComponent(UILabel)
  self.hp = self:FindGO("hp")
  self.hp_UISlider = self.hp:GetComponent(UISlider)
  self.NodeForShop = self:FindGO("NodeForShop")
  self.NodeForShop_Price = self:FindGO("Price", self.NodeForShop)
  self.NodeForShop_Icon = self:FindGO("Icon", self.NodeForShop_Price)
  self.NodeForShop_BG = self:FindGO("BG", self.NodeForShop_Price)
  self.NodeForShop_Lab = self:FindGO("Lab", self.NodeForShop_Price)
  self.NodeForShop_Icon_UISprite = self.NodeForShop_Icon:GetComponent(UISprite)
  self.NodeForShop_Lab_UILabel = self.NodeForShop_Lab:GetComponent(UILabel)
  self.Title2AwardIcon = self:FindGO("AwardIcon", self.Title2)
  self.Title2Award = self:FindGO("Award", self.Title2)
  self.Title2AwardItemIcon = self:FindGO("AwardItemIcon", self.Title2)
  self.Title2AwardItemCount = self:FindGO("AwardItemCount", self.Title2)
  self.Back1 = self:FindGO("Back1")
  self:AddClickEvent(self.Back1, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.Back2, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.icon.gameObject, function(obj)
    self:PassEvent(ServantImproveEvent.JiHuaIconClick, self)
  end)
  self.NodeForShop_SoldOut = self:FindGO("SoldOut", self.NodeForShop)
  OverseaHostHelper:FixLabelOverV1(self.cellName, 3, 400)
  OverseaHostHelper:FixLabelOverV1(self.cellTitle2, 3, 300)
end
function jihuacell:setSelected(isSelected)
  self.isSelected = isSelected
  if Slua.IsNull(self.expand) == false then
    self.expand:SetActive(isSelected)
    local bd = NGUIMath.CalculateRelativeWidgetBounds(self.content.transform, false)
    local height = math.max(bd.size.y, 110)
    self.Back1.gameObject:SetActive(not self.isSelected)
    self.Back2.gameObject:SetActive(self.isSelected)
    local off = 10
    if self.hasfirst == nil then
      off = 30
      self.hasfirst = true
    end
    self.Back2_UISprite.height = self.Back1_UISprite.height + self.description.height + off
    if self.isSelected then
    else
      if self.title2.activeSelf then
      else
      end
    end
    NGUITools.UpdateWidgetCollider(self.gameObject)
  end
end
function jihuacell:GetGoodData(data)
  return self.goodData
end
function jihuacell:SetGoodData(data)
  self.goodData = data
end
function jihuacell:NeedShowSoldOut()
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.goodData)
  if canBuyCount and self.goodData.LimitNum and canBuyCount == 0 then
    return true
  end
  return false
end
function jihuacell:SetData(data)
  self.NodeForShop.gameObject:SetActive(false)
  if data.isGoodData then
    self:SetGoodData(data)
  else
    self:SetGoodData(nil)
  end
  local clickid = ServantRecommendProxy.Instance:GetCurrentJinDuId()
  local groupData = ServantRecommendProxy.Instance:GetImproveGroup(clickid)
  if groupData and groupData.itemList and #groupData.itemList > 0 then
    for m, n in pairs(groupData.itemList) do
      if n.dwid == data.id and data.isGoodData ~= true then
        self.data = n
      end
    end
  end
  self.btnType = 0
  if self.data and self.data.dwid and data.isGoodData ~= true then
    local itemData = Table_Growth[self.data.dwid]
    if itemData.AllTaskNumber then
      self.hp_UISlider.value = self.data.finishtimes / itemData.AllTaskNumber
      self.State1_NameForProgress_UILabel.text = self.data.finishtimes .. "/" .. itemData.AllTaskNumber
      self.State1.gameObject:SetActive(true)
      self.Content_Btn.gameObject.transform.localPosition = Vector3(275.9, -39.7, 0)
    else
      self.State1.gameObject:SetActive(false)
      self.Content_Btn.gameObject.transform.localPosition = Vector3(275.9, -13, 0)
    end
    self.gotoMode = itemData.gotomode
    self.cellName.text = itemData.maintitle
    self.cellTitle2.text = string.format(itemData.subtitle, self.data.finishtimes)
    self.description.text = ZhString.ItemTip_CHSpace .. itemData.desc
    self.growthCount.text = "x" .. itemData.Growth
    local ret = IconManager:SetUIIcon(itemData.icon, self.icon)
    if not ret then
      IconManager:SetItemIcon(itemData.icon, self.icon)
    end
    if itemData.Reward then
      local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(itemData.Reward)
      if rewardTeamids and #rewardTeamids > 0 then
        local item = rewardTeamids[1]
        local itemData = Table_Item[item.id]
        IconManager:SetItemIcon(itemData.Icon, self.awardItemIcon)
        self.awardItemCount.text = "x" .. item.num
      end
    end
    if self.data.status == SceneUser2_pb.EGROWTH_STATUS_MIN then
      self.cellTitle2.text = itemData.unlock_desc
      self.btnType = 6
    elseif self.data.status == SceneUser2_pb.EGROWTH_STATUS_GO then
      self.btnType = 2
    elseif self.data.status == SceneUser2_pb.EGROWTH_STATUS_RECEIVE then
      self.btnType = 3
      if itemData.AllTaskNumber then
        self.hp_UISlider.value = itemData.AllTaskNumber / itemData.AllTaskNumber
        self.State1_NameForProgress_UILabel.text = itemData.AllTaskNumber .. "/" .. itemData.AllTaskNumber
      else
        self.hp_UISlider.value = 1.0
        self.State1_NameForProgress_UILabel.text = "1/1"
      end
    elseif self.data.status == SceneUser2_pb.EGROWTH_STATUS_FINISH then
      self.State1.gameObject:SetActive(false)
      self.Content_Btn.gameObject.transform.localPosition = Vector3(275.9, -13, 0)
    end
    self.cellTitle.gameObject:SetActive(false)
    self.title2:SetActive(true)
    self.NodeForShop.gameObject:SetActive(false)
  else
    self.State1.gameObject:SetActive(false)
    self.Content_Btn.gameObject.transform.localPosition = Vector3(275.9, -13, 0)
    if data and data.id and data.icon then
      local itemData = Table_Growth[data.id]
      self.gotoMode = itemData.gotomode
      self.cellName.text = itemData.maintitle
      self.description.text = ZhString.ItemTip_CHSpace .. itemData.desc
      self.growthCount.text = "x" .. itemData.Growth
      self.cellTitle2.text = itemData.subtitle
      local ret = IconManager:SetUIIcon(itemData.icon, self.icon)
      if not ret then
        IconManager:SetItemIcon(itemData.icon, self.icon)
      end
      if itemData.Reward then
        local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(itemData.Reward)
        if rewardTeamids and #rewardTeamids > 0 then
          local item = rewardTeamids[1]
          local itemData = Table_Item[item.id]
          IconManager:SetItemIcon(itemData.Icon, self.awardItemIcon)
          self.awardItemCount.text = "x" .. item.num
        end
      end
    elseif data and data.isGoodData then
      self.NodeForShop.gameObject:SetActive(true)
      self.State1.gameObject:SetActive(false)
      self.State2.gameObject:SetActive(false)
      self.Title2AwardIcon.gameObject:SetActive(false)
      self.Title2Award.gameObject:SetActive(false)
      self.Title2AwardItemIcon.gameObject:SetActive(false)
      self.Title2AwardItemCount.gameObject:SetActive(false)
      local itemData = Table_Item[data.goodsID]
      if itemData == nil then
        helplog("Table_Item\230\178\161\230\156\137")
        return
      end
      self.cellName.text = itemData.NameZh
      local ret = IconManager:SetUIIcon(itemData.Icon, self.icon)
      if not ret then
        IconManager:SetItemIcon(itemData.Icon, self.icon)
      end
      if data.LimitNum ~= 0 then
        self.cellTitle2.text = "\233\153\144\232\180\173" .. data.LimitNum .. "\228\187\182"
      else
        self.cellTitle2.gameObject:SetActive(false)
      end
      IconManager:SetItemIcon("item_151", self.NodeForShop_Icon_UISprite)
      self.price = self:GetDiscountPrice(data)
      self.NodeForShop_Lab_UILabel.text = FuncZenyShop.FormatMilComma(self.price)
      if self:NeedShowSoldOut() then
        self.NodeForShop_SoldOut.gameObject:SetActive(true)
      else
        self.NodeForShop_SoldOut.gameObject:SetActive(false)
      end
    end
  end
  self.icon:MakePixelPerfect()
  self.icon.width = math.floor(self.icon.width * 0.9)
  self.icon.height = math.floor(self.icon.height * 0.9)
  if self.btnType == 0 then
    self.cellBtnSprite.gameObject:SetActive(false)
    ColorUtil.WhiteUIWidget(self.icon)
  elseif self.btnType == 6 then
    ColorUtil.ShaderGrayUIWidget(self.icon)
    self.lock:SetActive(true)
    self.cellBtnSprite.gameObject:SetActive(false)
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self.cellBtnSprite.gameObject:SetActive(true)
    self.cellBtnSprite.spriteName = ServantImproveCell.CellState[self.btnType].btnSprite
    self.btnText.text = ServantImproveCell.CellState[self.btnType].buttonString
    self.btnText.effectColor = ServantImproveCell.CellState[self.btnType].effectColor
  end
  self.expand:SetActive(false)
  self.Back1.gameObject:SetActive(true)
  self.Back2.gameObject:SetActive(false)
end
function jihuacell:GetDiscountPrice(shopItemData)
  local retValue
  if shopItemData.actDiscount == 0 then
    retValue = shopItemData.ItemCount
  else
    retValue = shopItemData.ItemCount * shopItemData.actDiscount / 100
  end
  return math.floor(retValue)
end
function jihuacell:IsChoose()
  return self.choose
end
function jihuacell:SetChoose(choose)
  self.choose = choose
end
function jihuacell:GetData()
  return self.data
end
