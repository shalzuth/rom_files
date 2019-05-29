autoImport("ShopItemCell")
autoImport("HappyShopBuyItemCell")
autoImport("ServantHeadCell")
HappyShop = class("HappyShop", ContainerView)
HappyShop.ViewType = UIViewType.NormalLayer
ShopInfoType = {
  MyProfession = "MyProfession",
  All = "All"
}
local originWidth = 94
local extendWidth = 476
local originposY = -75
local extendpos = {3, -454}
function HappyShop:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end
function HappyShop:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function HappyShop:FindObjs()
  self.moneySprite = {}
  self.moneySprite[1] = self:FindGO("goldIcon"):GetComponent(UISprite)
  self.moneySprite[2] = self:FindGO("silversIcon"):GetComponent(UISprite)
  self.moneyLabel = {}
  self.moneyLabel[1] = self:FindGO("gold"):GetComponent(UILabel)
  self.moneyLabel[2] = self:FindGO("silvers"):GetComponent(UILabel)
  self.LeftStick = self:FindGO("LeftStick"):GetComponent(UISprite)
  self.ItemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.ItemScrollViewSpecial = self:FindGO("ItemScrollViewSpecial"):GetComponent(UIScrollView)
  self.myProfessionBtn = self:FindGO("MyProfessionBtn"):GetComponent(UIToggle)
  self.myProfessionLabel = self:FindGO("MyProfessionLabel"):GetComponent(UILabel)
  self.allBtn = self:FindGO("AllBtn")
  self.allLabel = self:FindGO("AllLabel"):GetComponent(UILabel)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.skipBtn.gameObject:SetActive(HappyShopProxy.Instance:IsShowSkip())
  self.toggleRoot = self:FindGO("ToggleRoot")
  self.descLab = self:FindGO("desc"):GetComponent(UILabel)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.specialRoot = self:FindGO("SpecialRoot")
  self.limitLab = self:FindComponent("LimitLab", UILabel)
  self.money1tg = self:FindGO("money1"):GetComponent(UIToggle)
  self.money1Label = self:FindGO("money1Label"):GetComponent(UILabel)
  self.money1sprite = self:FindGO("money1Sprite"):GetComponent(UISprite)
  self.money2tg = self:FindGO("money2"):GetComponent(UIToggle)
  self.money2Label = self:FindGO("money2Label"):GetComponent(UILabel)
  self.money2sprite = self:FindGO("money2Sprite"):GetComponent(UISprite)
  self.showtoggle = self:FindGO("ShowToggle")
  self:InitBuyItemCell()
  self.servantExp = self:FindGO("ServantExt")
  self.servantbg = self:FindGO("servantbg", self.servantExp):GetComponent(UISprite)
  self.servantBtn = self:FindGO("expandBtn", self.servantExp)
  self.servantSp = self.servantBtn:GetComponent(UISprite)
  self.servantSC = self:FindGO("ServantScrollview", self.servantExp):GetComponent(UIScrollView)
  self.servantGrid = self:FindGO("ServantGrid", self.servantExp):GetComponent(UIGrid)
  self.servantCtl = UIGridListCtrl.new(self.servantGrid, ServantHeadCell, "ServantHeadCell")
  self.servantCtl:AddEventListener(MouseEvent.MouseClick, self.ClickServantHead, self)
  self.expandToggle = true
  self:AddClickEvent(self.servantBtn, function(go)
    self.expandToggle = not self.expandToggle
    if not self.expandToggle then
      local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or 0
      if myServantid == 0 then
        MsgManager.ConfirmMsgByID(25405, function()
          FuncShortCutFunc.Me():CallByID(1005)
        end)
        self:CloseSelf()
        return
      end
    end
    self:InitServantList()
  end)
end
function HappyShop:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.CloseWhenClickOtherPlace = self.buyCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
end
function HappyShop:SetScrollView()
  local isSpecial = HappyShopProxy.Instance:isGuildMaterialType()
  self.ItemScrollView.gameObject:SetActive(not isSpecial)
  self.specialRoot:SetActive(isSpecial)
  local sv = isSpecial and self.ItemScrollViewSpecial or self.ItemScrollView
  function sv.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
end
function HappyShop:AddEvts()
  self:AddOrRemoveGuideId(self.buyCell.countPlusBg.gameObject, 16)
  self:AddOrRemoveGuideId(self.buyCell.confirmButton.gameObject, 17)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:OnClickSkip()
  end)
  function self.CloseWhenClickOtherPlace.callBack()
    if self.selectGo then
      local size = NGUIMath.CalculateAbsoluteWidgetBounds(self.selectGo.transform)
      if self.uiCamera == nil then
        self.uiCamera = NGUITools.FindCameraForLayer(self.selectGo.layer)
      end
      local pos = self.uiCamera:ScreenToWorldPoint(Input.mousePosition)
      if not size:Contains(Vector3(pos.x, pos.y, pos.z)) then
        self.selectGo = nil
      elseif not self.buyCell.gameObject.activeSelf then
        self.buyCell.gameObject:SetActive(true)
      end
    end
  end
  if self.myProfessionBtn then
    self:AddClickEvent(self.myProfessionBtn.gameObject, function(g)
      self:ClickMyProfession(g)
    end)
  end
  if self.allBtn then
    self:AddClickEvent(self.allBtn, function(g)
      self:ClickAll(g)
    end)
  end
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  if config.Parama.ItemID then
    if self.money1tg then
      self:AddClickEvent(self.money1tg.gameObject, function(g)
        self.tabid = 1
        self:ClickMoneyType()
      end)
    end
    if self.money2tg then
      self:AddClickEvent(self.money2tg.gameObject, function(g)
        self.tabid = 2
        self:ClickMoneyType()
      end)
    end
  end
end
function HappyShop:OnClickSkip()
  local skipType = HappyShopProxy.Instance.aniConfig[2]
  if skipType then
    TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Top, {120, 50})
  end
end
function HappyShop:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopInfo)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopSoldCountCmd, self.HandleShopSoldCountCmd)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvUpdateShopConfig)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.SessionShopExchangeShopItemCmd, self.HideGoodsTip)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.SetLimitLab)
  self:AddListenEvt(ServiceEvent.GuildCmdBuildingNtfGuildCmd, self.SetLimitLab)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end
function HappyShop:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
end
function HappyShop:InitUI()
  self:InitShopInfo()
  EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.RecvItemGetCount, self)
  self:InitScreen()
  self:InitShowtoggle()
  self:InitLeftUpIcon()
  self:UpdateShopInfo(true)
  self:UpdateMoney()
  self.descLab.text = HappyShopProxy.Instance.desc
  self:SetScrollView()
  self:SetLimitLab()
  self.buyCell.gameObject:SetActive(false)
  self.default = HappyShopProxy.Instance:GetShopType()
  self.lastSelect = nil
  self:InitServantList()
end
function HappyShop:InitShopInfo()
  local isGuildMaterialType = HappyShopProxy.Instance:isGuildMaterialType()
  local itemContainer = isGuildMaterialType and self:FindGO("shop_itemContainerSpecial") or self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 6,
    cellName = "ShopItemCell",
    control = ShopItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  if isGuildMaterialType then
    if self.specialItemWrapHelper then
      return
    end
    self.specialItemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.specialItemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.specialItemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
    self.specialItemWrapHelper:AddEventListener(HappyShopEvent.ExchangeBtnClick, self.HandleClickItemExchange, self)
  else
    if self.itemWrapHelper then
      return
    end
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
    self.itemWrapHelper:AddEventListener(HappyShopEvent.ExchangeBtnClick, self.HandleClickItemExchange, self)
  end
end
function HappyShop:InitScreen()
  if HappyShopProxy.Instance:GetScreen() then
    self.infoType = ShopInfoType.MyProfession
    self.toggleRoot:SetActive(true)
    self.myProfessionBtn.value = true
    self.myProfessionLabel.color = ColorUtil.TitleBlue
    self.allLabel.color = ColorUtil.TitleGray
  else
    self.infoType = ShopInfoType.All
    self.toggleRoot:SetActive(false)
  end
end
function HappyShop:InitShowtoggle()
  self.tabid = 1
  if HappyShopProxy.Instance:GetTab() then
    local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
    local itemid = config.Parama.ItemID
    self.showtoggle:SetActive(true)
    self.money1tg.value = true
    self.money1Label.color = ColorUtil.TitleBlue
    self.money1Label.text = Table_Item[itemid[1]].NameZh
    self.money1sprite.spriteName = "shop_icon_" .. itemid[1]
    self.money1sprite.color = ColorUtil.TitleBlue
    self.money2Label.color = ColorUtil.TitleGray
    self.money2Label.text = Table_Item[itemid[2]].NameZh
    self.money2sprite.spriteName = "shop_icon_" .. itemid[2]
    self.money2sprite.color = ColorUtil.TitleGray
  else
    self.showtoggle:SetActive(false)
  end
end
function HappyShop:InitLeftUpIcon()
  local _HappyShopProxy = HappyShopProxy
  local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
  if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild then
    for i = 1, #self.moneySprite do
      self.moneySprite[i].gameObject:SetActive(false)
    end
    return
  end
  local moneyTypes = _HappyShopProxy.Instance:GetMoneyType()
  if moneyTypes then
    for i = 1, #self.moneySprite do
      local moneyId = moneyTypes[i]
      if moneyId then
        local item = Table_Item[moneyId]
        if item then
          IconManager:SetItemIcon(item.Icon, self.moneySprite[i])
          self.moneySprite[i].gameObject:SetActive(true)
        end
      else
        self.moneySprite[i].gameObject:SetActive(false)
      end
    end
  else
    for i = 1, #self.moneySprite do
      self.moneySprite[i].gameObject:SetActive(false)
    end
  end
end
function HappyShop:HandleClickItem(cellctl)
  if self.currentItem ~= cellctl then
    if self.currentItem then
      self.currentItem:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.currentItem = cellctl
  end
  local id = cellctl.data
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
  local go = cellctl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local _HappyShopProxy = HappyShopProxy
    local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
    if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild and not GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Shop) then
      MsgManager.ShowMsgByID(3808)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    if HappyShopProxy.Instance:isGuildMaterialType() then
      local npcdata = HappyShopProxy.Instance:GetNPC()
      if npcdata then
        self:CameraReset()
        self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, CameraConfig.GuildMaterial_Choose_ViewPort, CameraConfig.GuildMaterial_Choose_Rotation)
      end
    end
    HappyShopProxy.Instance:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end
function HappyShop:HandleClickItemExchange(cellctl)
  local exchangeData = ExchangeShopProxy.Instance:GetShopDataByExchangeId(cellctl.data)
  if exchangeData then
    TipManager.Instance:ShowExchangeGoodsTip(exchangeData, self.tipStick, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end
function HappyShop:HandleClickIconSprite(cellctl)
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(cellctl.data)
  self:ShowHappyItemTip(data)
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end
function HappyShop:ShowHappyItemTip(data)
  if data.goodsID then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, self.LeftStick)
  else
    errorLog("HappyShop ShowItemTip data.goodsID == nil")
  end
end
function HappyShop:OnEnter()
  HappyShop.super.OnEnter(self)
  self:handleCameraQuestStart()
  self:InitUI()
  self:HandleSpecial(true)
end
function HappyShop:OnExit()
  self:CameraReset()
  self.expandToggle = true
  HappyShopProxy.Instance:SetSelectId(nil)
  HappyShopProxy.Instance:RemoveLeanTween()
  self.buyCell:Exit()
  TipsView.Me():HideCurrent()
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.RecvItemGetCount, self)
  if self.needUpdateSold then
    self.needUpdateSold = false
    ServiceMatchCCmdProxy.Instance:CallOpenGlobalShopPanelCCmd(false)
  end
  self:HandleSpecial(false)
  HappyShop.super.OnExit(self)
end
local shopCameraConfig = {
  BAR = 923,
  VENDING_MACHINE = 924,
  GUILD_MATERIAL_MACHINE = 988
}
function HappyShop:handleCameraQuestStart()
  local npcdata = HappyShopProxy.Instance:GetNPC()
  if npcdata then
    local isSpecial = true
    local shopType, viewPort, rotation
    shopType = HappyShopProxy.Instance.shopType
    if shopType == shopCameraConfig.VENDING_MACHINE then
      viewPort = CameraConfig.Vending_Machine_ViewPort
      rotation = CameraConfig.Vending_Machine_Rotation
    elseif shopType == shopCameraConfig.BAR then
      viewPort = CameraConfig.Bar_ViewPort
      rotation = CameraConfig.Bar_Rotation
    elseif shopType == shopCameraConfig.GUILD_MATERIAL_MACHINE then
      viewPort = CameraConfig.GuildMaterial_ViewPort
      rotation = CameraConfig.GuildMaterial_Rotation
    else
      isSpecial = false
      viewPort = CameraConfig.HappyShop_ViewPort
      rotation = CameraConfig.HappyShop_Rotation
    end
    if isSpecial then
      self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, viewPort, rotation)
    else
      self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
    end
  end
end
function HappyShop:UpdateShopInfo(isReset)
  local datas
  if self.infoType == ShopInfoType.MyProfession then
    datas = HappyShopProxy.Instance:GetMyProfessionItems()
  elseif self.infoType == ShopInfoType.All then
    datas = HappyShopProxy.Instance:GetShopItems()
  end
  if HappyShopProxy.Instance:GetTab() then
    if datas then
      TableUtility.ArrayClear(datas)
    end
    datas = HappyShopProxy.Instance:GetTabItem(self.tabid)
  end
  local wrap = self:GetWrapHelper()
  if datas then
    self:NeedUpdateSold(datas)
    wrap:UpdateInfo(datas)
    HappyShopProxy.Instance:SetSelectId(nil)
  else
    printRed("HappyShop:UpdateShopInfo : datas is nil ~")
  end
  if isReset == true then
    wrap:ResetPosition()
  end
end
function HappyShop:GetWrapHelper()
  local isGuildMaterialType = HappyShopProxy.Instance:isGuildMaterialType()
  if isGuildMaterialType then
    return self.specialItemWrapHelper
  else
    return self.itemWrapHelper
  end
end
function HappyShop:NeedUpdateSold(datas)
  if self.needUpdateSold == true then
    return
  end
  local _HappyShopProxy = HappyShopProxy.Instance
  for i = 1, #datas do
    local id = datas[i]
    local shopdata = _HappyShopProxy:GetShopItemDataByTypeId(id)
    if shopdata and shopdata.produceNum and shopdata.produceNum > 0 then
      ServiceMatchCCmdProxy.Instance:CallOpenGlobalShopPanelCCmd(true)
      self.needUpdateSold = true
      return
    end
  end
end
function HappyShop:UpdateMoney()
  local moneyTypes = HappyShopProxy.Instance:GetMoneyType()
  if moneyTypes then
    for i = 1, #self.moneyLabel do
      local moneyType = moneyTypes[i]
      if moneyType then
        local money = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(moneyTypes[i]))
        self.moneyLabel[i].text = money
      else
        self.moneyLabel[i].text = ""
      end
    end
  end
end
function HappyShop:UpdateBuyItemInfo(data)
  if data then
    local itemType = data.itemtype
    if itemType and itemType ~= 2 then
      self.buyCell:SetData(data)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end
function HappyShop:ClickMyProfession()
  self.myProfessionLabel.color = ColorUtil.TitleBlue
  self.allLabel.color = ColorUtil.TitleGray
  self.infoType = ShopInfoType.MyProfession
  self:UpdateShopInfo(true)
end
function HappyShop:ClickAll()
  self.myProfessionLabel.color = ColorUtil.TitleGray
  self.allLabel.color = ColorUtil.TitleBlue
  self.infoType = ShopInfoType.All
  self:UpdateShopInfo(true)
end
function HappyShop:RecvBuyShopItem(note)
  local success = note.body.success
  if HappyShopProxy.Instance.aniConfig[2] and success then
    if HappyShopProxy.Instance.aniConfig[2] == "functional_action" then
      HappyShopProxy.Instance:PlayFunctionalAction()
    else
      HappyShopProxy.Instance:PlayAnimationEff()
    end
  end
  self:UpdateShopInfo()
end
function HappyShop:RecvQueryShopConfig(note)
  self:InitScreen()
  self:InitShowtoggle()
  self:UpdateShopInfo(true)
  self:InitLeftUpIcon()
  self.buyCell.gameObject:SetActive(false)
end
function HappyShop:RecvShopDataUpdate(note)
  local data = note.body
  if data then
    local _HappyShopProxy = HappyShopProxy.Instance
    if data.type == _HappyShopProxy:GetShopType() and data.shopid == _HappyShopProxy:GetShopId() then
      _HappyShopProxy:CallQueryShopConfig()
    end
  end
end
function HappyShop:RecvItemGetCount(note)
  local data = note.data
  if data then
    self.buyCell:SetItemGetCount(data)
  end
end
function HappyShop:SetLimitLab()
  if not HappyShopProxy.Instance:isGuildMaterialType() then
    return
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  local gmLimitCount = GuildBuildingProxy.Instance:GetGuildMaterialLimitCount()
  if myGuildData and gmLimitCount ~= 0 then
    self.limitLab.text = string.format(ZhString.HappyShop_GuildMaterialCanBuy, gmLimitCount - myGuildData.material_machine_count)
    self.limitLab.gameObject:SetActive(true)
  else
    self.limitLab.gameObject:SetActive(false)
  end
end
function HappyShop:RecvUpdateShopConfig(note)
  self:UpdateShopInfo(true)
  self.buyCell.gameObject:SetActive(false)
end
function HappyShop:HandleShopSoldCountCmd(note)
  local wrap = self:GetWrapHelper()
  local cells = wrap:GetCellCtls()
  for j = 1, #cells do
    cells[j]:RefreshBuyCondition()
  end
  if self.buyCell.gameObject.activeSelf then
    self.buyCell:UpdateSoldCountInfo()
  end
end
function HappyShop:AddCloseButtonEvent()
  HappyShop.super.AddCloseButtonEvent(self)
  self:AddOrRemoveGuideId("CloseButton", 15)
end
function HappyShop:HandleSpecial(on)
  local _HappyShopProxy = HappyShopProxy
  local config = Table_NpcFunction[_HappyShopProxy.Instance:GetShopType()]
  if config ~= nil and config.Parama.Source == _HappyShopProxy.SourceType.Guild then
    ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(on)
  end
end
function HappyShop:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end
function HappyShop:HideGoodsTip()
  TipManager.Instance:HideExchangeGoodsTip()
end
function HappyShop:ClickMoneyType()
  if self.tabid and self.tabid == 1 then
    self.money1Label.color = ColorUtil.TitleBlue
    self.money1sprite.color = ColorUtil.TitleBlue
    self.money2Label.color = ColorUtil.TitleGray
    self.money2sprite.color = ColorUtil.TitleGray
  elseif self.tabid and self.tabid == 2 then
    self.money1Label.color = ColorUtil.TitleGray
    self.money1sprite.color = ColorUtil.TitleGray
    self.money2Label.color = ColorUtil.TitleBlue
    self.money2sprite.color = ColorUtil.TitleBlue
  end
  self:UpdateShopInfo(true)
end
local tempVector3 = LuaVector3.zero
local onRotation, offRotation = Quaternion.Euler(0, 0, 90), Quaternion.Euler(0, 0, -90)
function HappyShop:InitServantList()
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or 0
  local isShowList = config.Parama.ShowType
  local npcstaticid = HappyShopProxy.Instance:GetNPCStaticid()
  if isShowList and isShowList == 1 then
    self.servantExp:SetActive(true)
    local servantShopMap = HappyShopProxy.Instance:GetServantShopMap()
    local servantShopList = {}
    local defaultdata
    local flag = false
    if servantShopMap then
      for k, v in pairs(servantShopMap) do
        local single = v
        if FunctionUnLockFunc.Me():CheckCanOpen(v.menuid) then
          table.insert(servantShopList, single)
        end
        if not flag then
          if not self.lastSelect then
            if myServantid == 0 and v.type == self.default then
              defaultdata = single
              flag = true
            elseif npcstaticid ~= 0 and npcstaticid == v.npcid then
              defaultdata = single
              flag = true
            elseif npcstaticid == 0 and myServantid == v.npcid then
              defaultdata = single
              flag = true
            end
          elseif v.npcid == self.lastSelect then
            defaultdata = single
            flag = true
          end
        end
      end
      table.sort(servantShopList, function(a, b)
        return a.npcid > b.npcid
      end)
    end
    local delta = 0
    if self.expandToggle then
      self.servantCtl:ResetDatas({defaultdata}, true)
      self.servantbg.width = originWidth
      tempVector3:Set(3, originposY, 0)
      self.servantBtn.gameObject.transform.localPosition = tempVector3
      self.servantSp.transform.localRotation = offRotation
      self.servantSC.panel.baseClipRegion = Vector4(0, 184, 64.8, 64)
    else
      delta = (#servantShopList < 7 and #servantShopList or 7) - 1
      self.servantCtl:ResetDatas(servantShopList, true)
      self.servantbg.width = originWidth + delta * 62
      tempVector3:Set(3, originposY - delta * 62, 0)
      self.servantBtn.gameObject.transform.localPosition = tempVector3
      self.servantSp.transform.localRotation = onRotation
      self.servantSC.panel.baseClipRegion = Vector4(0, 184 - delta * 31, 64.8, 64 + delta * 62)
    end
    self.servantSC:ResetPosition()
  else
    self.servantExp:SetActive(false)
  end
end
function HappyShop:ClickServantHead(cell)
  local data = cell.data
  if data then
    self.lastSelect = data.npcid
    HappyShopProxy.Instance:InitShop(nil, data.param, data.type)
    self:InitLeftUpIcon()
    self:UpdateShopInfo(true)
    self:UpdateMoney()
    local cells = self.servantCtl:GetCells()
    for _, v in pairs(cells) do
      v:SetChoose(data.npcid == v.data.npcid)
    end
  end
end
