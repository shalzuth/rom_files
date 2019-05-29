autoImport("ItemTipBaseCell")
ItemTipComCell = class("ItemTipComCell", ItemTipBaseCell)
autoImport("ItemTipFuncCell")
autoImport("ItemSecendFuncBord")
local tempV3 = LuaVector3()
function ItemTipComCell:ctor(obj, index)
  ItemTipComCell.super.ctor(self, obj)
  self.index = index
end
function ItemTipComCell:Init()
  ItemTipComCell.super.Init(self)
  self.bg = self:FindComponent("Bg", UISprite)
  self.tips = self:FindComponent("Tips", UILabel)
  self.refreshTip_GO = self:FindGO("RefreshTip")
  if self.refreshTip_GO then
    self.refreshTip = self:FindComponent("Label", UILabel, self.refreshTip_GO)
  end
  self.beforePanel = self:FindGO("BeforePanel")
  self.func = {}
  self.bottomBtns = self:FindGO("BottomButtons")
  local style1, style2, style3 = {}, {}, {}
  style1.obj = self:FindGO("Style1", self.bottomBtns)
  style2.obj = self:FindGO("Style2", self.bottomBtns)
  style3.obj = self:FindGO("Style3", self.bottomBtns)
  style3.morebg = self:FindComponent("MoreBg", UISprite, style3.obj)
  self:AddButtonEvent("FuncBtnMore")
  self:InitFuncBtnStyle(1, style1)
  self:InitFuncBtnStyle(2, style2)
  self:InitFuncBtnStyle(5, style3)
  self.func.style = {
    style1,
    style2,
    style3
  }
  self.LockRoot = self:FindGO("LockRoot")
  self.LockDes = self:FindComponent("LockMenuDes", UILabel)
  self.showfpButton = self:FindGO("ShowFPreviewButton")
  if self.showfpButton then
    self:AddClickEvent(self.showfpButton, function(go)
      self:PassEvent(ItemTipEvent.ShowFashionPreview, self)
    end)
  end
  self.showupButton = self:FindGO("ShowUpgradeButton")
  if self.showupButton then
    self.showupButton_Symbol = self:FindComponent("Symbol", UISprite, self.showupButton)
    self:AddClickEvent(self.showupButton, function()
      self:PassEvent(ItemTipEvent.ShowEquipUpgrade, self)
    end)
  end
  self.favoriteButton = self:FindGO("Favorite")
  if self.favoriteButton then
    self.favoriteButton:SetActive(false)
    self:AddClickEvent(self.favoriteButton, function()
      self:OnFavoriteClick()
    end)
  end
  self.Style1 = self:FindGO("Style1", self.bottomBtns)
  self.FuncBtn1 = self:FindGO("FuncBtn1", self.Style1)
  self:AddOrRemoveGuideId(self.FuncBtn1, 202)
  local Style2 = self:FindGO("Style2", self.bottomBtns)
  local FuncBtn2 = self:FindGO("FuncBtn2", self.Style2)
  local fbtn2 = self:FindGO("Label", FuncBtn2):GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(fbtn2, 3, 140)
end
function ItemTipComCell:InitFuncBtnStyle(num, container)
  container.button = {}
  for i = 1, num do
    local obj = self:FindGO("FuncBtn" .. i, container.obj)
    container.button[i] = ItemTipFuncCell.new(obj)
    container.button[i]:AddEventListener(MouseEvent.MouseClick, self.ClickTipFunc, self)
  end
end
function ItemTipComCell:ClickTipFunc(cellCtl)
  local data = cellCtl.data
  if data then
    local childFunction = data.childFunction
    if childFunction then
      self:ShowSecendFunc(childFunction, data.childFunction_Tip, self.beforePanel, cellCtl.bg)
    else
      if data.type == "GotoUse" then
        self:PassEvent(ItemTipEvent.ShowGotoUse, self)
        return
      end
      local count = self.chooseCount or 1
      local callback = data.callback
      if callback then
        self:UpdateCountChooseBordButton()
        callback(data.callbackParam, count)
      else
        MsgManager.FloatMsgTableParam(nil, data.type .. " Not Implement")
      end
      if data.type == "Apply" and count < self.data.num and (not self.data.staticData.UseMode or self.data.staticData.UseMode == 0) then
        return
      end
      if data.noClose then
        return
      end
      self:PassEvent(ItemTipEvent.ClickTipFuncEvent)
    end
  end
end
function ItemTipComCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    ItemTipComCell.super.SetData(self, data)
    self.scrollview:ResetPosition()
    self.scrollview.gameObject:SetActive(false)
    self.scrollview.gameObject:SetActive(true)
    self:UpdateShowFpButton()
    self:UpdateFavorite()
  else
    self.gameObject:SetActive(false)
  end
end
function ItemTipComCell:UpdateShowFpButton()
  local data = self.data
  local myCreatureData = Game.Myself.data
  if self.showfpButton then
    if data:IsPic() then
      local composeId = data.staticData.ComposeID
      local productId = composeId and Table_Compose[composeId] and Table_Compose[composeId].Product.id
      local product = productId and ItemData.new("Product", productId)
      if product and product:CanEquip() then
        self.showfpButton:SetActive(true)
      else
        self.showfpButton:SetActive(false)
      end
    elseif data:EyeCanEquip() then
      self.showfpButton:SetActive(true)
    elseif data:HairCanEquip() then
      self.showfpButton:SetActive(true)
    elseif data:IsMountPet() then
      self.showfpButton:SetActive(true)
    elseif data:IsFashion() or data.equipInfo and (data.equipInfo:IsWeapon() or data.equipInfo:IsMount()) then
      if data:CanEquip(data.equipInfo:IsMount()) then
        if not myCreatureData:IsInMagicMachine() then
          self.showfpButton:SetActive(true)
        else
          self.showfpButton:SetActive(false)
        end
      else
        self.showfpButton:SetActive(false)
      end
    elseif data.equipInfo and data.equipInfo.equipData.Type == "Shield" then
      local class = myCreatureData.userdata:Get(UDEnum.PROFESSION)
      if class == 72 or class == 73 or class == 74 then
        self.showfpButton:SetActive(true)
      else
        self.showfpButton:SetActive(false)
      end
    else
      self.showfpButton:SetActive(false)
    end
  end
end
local SpriteBlue = Color(0.30980392156862746, 0.41568627450980394, 0.6941176470588235, 1)
local SpriteRed = Color(1.0, 0 / 255, 0 / 255, 1)
function ItemTipComCell:UpdateShowUpButton()
  local data = self.data
  if self.showupButton then
    if data and data.equipInfo and data.equipInfo.upgradeData then
      self.showupButton:SetActive(true)
      if not data.equipInfo:CanUpgrade() then
        self.showupButton:SetActive(false)
      elseif data.equipInfo:CheckCanUpgradeSuccess(true) then
        self.showupButton_Symbol.color = SpriteBlue
      else
        self.showupButton_Symbol.color = SpriteRed
      end
    else
      self.showupButton:SetActive(false)
    end
  end
end
function ItemTipComCell:SetDownTipText(tips)
  if tips and tips ~= "" then
    self.tips.gameObject:SetActive(true)
    self.tips.text = tips
  else
    self.tips.gameObject:SetActive(false)
  end
  self:UpdateTipFunc()
end
function ItemTipComCell:HideGetPath()
  self:ActiveGetPath(false)
end
function ItemTipComCell:ActiveGetPath(b)
  if self.getPathBtn then
    self.getPathBtn.gameObject:SetActive(b)
  end
end
function ItemTipComCell:HidePreviewButton()
  if self.showfpButton then
    self.showfpButton.gameObject:SetActive(false)
  end
end
local StoreFuncKey = {
  WthdrawnRepository = 1,
  PersonalWthdrawnRepository = 1,
  PutBackBarrow = 1,
  DepositRepository = 1,
  PersonalDepositRepository = 1,
  PutInBarrow = 1
}
function ItemTipComCell:UpdateTipFunc(config)
  config = config or {}
  if #config > 0 then
    self.tips.gameObject:SetActive(false)
  end
  local funcDatas = ReusableTable.CreateArray()
  self.hasUseFunc = false
  self.hasStroeFunc = false
  local locked = false
  local UnlockPetWork = PetWorkSpaceProxy.Instance:IsFuncUnlock()
  for i = 1, #config do
    local cfgid = config[i]
    local cfgdata = GameConfig.ItemFunction[cfgid]
    if cfgdata then
      if self.data.staticData.id == 5542 and not UnlockPetWork then
        locked = true
      end
      local state = FunctionItemFunc.Me():CheckFuncState(cfgdata.type, self.data)
      if state == ItemFuncState.Active or state == ItemFuncState.Grey then
        if cfgdata.type == "Apply" or cfgdata.type == "PutFood" then
          local sid = self.data and self.data.staticData.id
          local useItemData = sid and Table_UseItem[sid]
          if useItemData == nil or useItemData.UseInterval == nil then
            self.hasUseFunc = true
          end
        elseif StoreFuncKey[cfgdata.type] then
          self.hasStroeFunc = true
        end
        local data = {
          itemData = self.data,
          name = cfgdata.name,
          type = cfgdata.type,
          callback = FunctionItemFunc.Me():GetFuncById(cfgid),
          callbackParam = self.data,
          childFunction = cfgdata.childFunction,
          childFunction_Tip = cfgdata.childFunction_Tip
        }
        table.insert(funcDatas, data)
      end
    end
  end
  self:UpdateTipButtons(funcDatas)
  ReusableTable.DestroyAndClearArray(funcDatas)
  local d = self.data
  if self.hasStroeFunc then
    self:UpdateCountChooseBord(d.staticData.MaxNum)
    self:SetChooseCount(d.num)
  else
    self:UpdateCountChooseBord()
    self:SetChooseCount(1)
  end
  self.LockRoot:SetActive(locked)
  self.LockDes.gameObject:SetActive(locked)
  if locked then
    self.LockDes.text = Table_Menu[1907].text
  end
end
function ItemTipComCell:UpdateTipButtons(funcDatas)
  self.funcDatas = funcDatas
  local n = #funcDatas
  self.hasFunc = n > 0
  if self.hasFunc then
    local style
    if n == 1 then
      style = self.func.style[1]
    elseif n == 2 then
      style = self.func.style[2]
    elseif n > 2 then
      style = self.func.style[3]
      style.morebg.height = 60 * (n - 1) + 10
    end
    for i = 1, 3 do
      self.func.style[i].obj:SetActive(style == self.func.style[i])
    end
    for i = 1, #style.button do
      style.button[i]:SetData(funcDatas[i])
    end
  else
    for i = 1, 3 do
      self.func.style[i].obj:SetActive(false)
    end
  end
  self:UpdateBgHeight()
end
function ItemTipComCell:UpdateBgHeight()
  if self.hasFunc and self.bottomBtns.activeSelf or self.tips.gameObject.activeInHierarchy then
    self.bg.height = 606
  elseif self.refreshTip_GO and self.refreshTip_GO.gameObject.activeInHierarchy then
    self.bg.height = 536
  else
    self.bg.height = 506
  end
end
function ItemTipComCell:SetDelTimeTip(isShow)
  if Slua.IsNull(self.bottomBtns) then
    return
  end
  self.bottomBtns:SetActive(true)
  if Slua.IsNull(self.refreshTip_GO) then
    self.refreshTip_GO.gameObject:SetActive(false)
    TimeTickManager.Me():ClearTick(self, 1)
  end
  local data = self.data
  local cttime
  if data then
    local useItemData = Table_UseItem[data.staticData.id]
    if useItemData and useItemData.UseInterval then
      local usedtime = data.usedtime or 0
      cttime = usedtime + useItemData.UseInterval
    else
      cttime = data.deltime
    end
  end
  if isShow and cttime and cttime * 1000 > ServerTime.CurServerTime() then
    tempV3:Set(0, -255, 0)
    self.bottomBtns.transform.localPosition = tempV3
    self.refreshTip_GO.gameObject:SetActive(true)
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDelTimeTip, self, 1)
  else
    tempV3:Set(0, -240, 0)
    self.bottomBtns.transform.localPosition = tempV3
    self.refreshTip_GO.gameObject:SetActive(false)
    TimeTickManager.Me():ClearTick(self, 1)
    local existTimeType = self.data and self.data.staticData and self.data.staticData.ExistTimeType
    if existTimeType == 3 and data.deltime ~= nil and data.deltime ~= 0 then
      self.refreshTip_GO.gameObject:SetActive(true)
      self.bottomBtns:SetActive(false)
      self.refreshTip.text = ZhString.ItemTip_InvalidTip
    end
  end
  self:UpdateBgHeight()
end
function ItemTipComCell:UpdateDelTimeTip()
  local data = self.data
  local tip, cttime
  if data then
    local useItemData = Table_UseItem[data.staticData.id]
    if useItemData and useItemData.UseInterval then
      cttime = data.usedtime + useItemData.UseInterval
      tip = ZhString.ItemTip_IntervalUseTip
    else
      cttime = data.deltime
    end
  end
  local existTimeType = self.data and self.data.staticData and self.data.staticData.ExistTimeType
  if existTimeType == 3 then
    tip = ZhString.ItemTip_InvalidRefreshTip
  end
  if tip == nil then
    tip = ZhString.ItemTip_DelRefreshTip
  end
  local deltaTime = cttime - ServerTime.CurServerTime() / 1000
  if deltaTime < 0 then
    self:SetDelTimeTip(false)
  elseif data.bagtype == BagProxy.BagType.Temp then
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec(deltaTime)
    local leftTimeStr = string.format("%02d:%02d:%02d", leftDay * 24 + leftHour, leftMin, leftSec)
    self.refreshTip.text = string.format(tip, leftTimeStr)
  else
    local leftTimeTip = ""
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec(deltaTime)
    if deltaTime > 86400 then
      leftTimeTip = string.format("%s%s%s%s", leftDay, ZhString.ItemTip_DelRefreshTip_Day, leftHour, ZhString.ItemTip_DelRefreshTip_Hour)
    elseif deltaTime > 3600 and deltaTime <= 86400 then
      leftTimeTip = string.format("%s%s%s%s", leftHour, ZhString.ItemTip_DelRefreshTip_Hour, leftMin, ZhString.ItemTip_DelRefreshTip_Min)
    elseif deltaTime > 60 and deltaTime <= 3600 then
      leftTimeTip = string.format("%s%s%s%s", leftMin, ZhString.ItemTip_DelRefreshTip_Min, leftSec, ZhString.ItemTip_DelRefreshTip_Sec)
    elseif deltaTime <= 60 then
      leftTimeTip = string.format("%s%s", leftSec, ZhString.ItemTip_DelRefreshTip_Sec)
    end
    self.refreshTip.text = string.format(tip, leftTimeTip)
  end
end
function ItemTipComCell:UpdateCountChooseBord(useMaxNumber)
  if self.countChooseBord == nil then
    return
  end
  if self.data == nil then
    return
  end
  if self.hasStroeFunc == true then
    self:ActiveCountChooseBord(true, useMaxNumber)
    return
  end
  if self.hasUseFunc == false then
    self:ActiveCountChooseBord(false)
    return
  end
  if useMaxNumber == nil then
    local typeData = Table_ItemType[self.data.staticData.Type]
    useMaxNumber = typeData and typeData.UseNumber
    if useMaxNumber == nil then
      local useItemData = Table_UseItem[self.data.staticData.id]
      useMaxNumber = useItemData and useItemData.UseMultiple
    end
  end
  if useMaxNumber and useMaxNumber > 0 then
    self:ActiveCountChooseBord(true, useMaxNumber)
    self:UpdateCountChooseBordButton()
  else
    self:ActiveCountChooseBord(false)
  end
end
function ItemTipComCell:UpdateNoneItemTipCountChooseBord(useMaxNumber)
  if useMaxNumber and useMaxNumber > 0 then
    self:ActiveCountChooseBord(true, useMaxNumber)
    self:UpdateCountChooseBordButton()
  else
    self:ActiveCountChooseBord(false)
  end
end
function ItemTipComCell:AddTipFunc(funcname, callback, callbackParam, noClose, inactive)
  local data = {
    name = funcname,
    itemData = self.data,
    noClose = noClose,
    callback = callback,
    callbackParam = callbackParam,
    inactive = inactive
  }
  if self.funcDatas == nil then
    self.funcDatas = {}
  end
  table.insert(self.funcDatas, data)
  self:UpdateTipButtons(self.funcDatas)
end
function ItemTipComCell:ShowSecendFunc(funcConfig, title, parent, widget, side, pixelOffset)
  if self.itemSecendFuncBord == nil then
    self.itemSecendFuncBord = ItemSecendFuncBord.new()
    side = side or NGUIUtil.AnchorSide.TopRight
    pixelOffset = pixelOffset or {-11, 239}
    self.itemSecendFuncBord:OnCreate(parent, widget, side, pixelOffset)
    self.itemSecendFuncBord:AddEventListener(MouseEvent.MouseClick, self.ClickSecendFunc, self)
    self.itemSecendFuncBord:AddEventListener(ItemSecendFuncEvent.Close, self.CloseSecendBord, self)
  end
  self.itemSecendFuncBord:SetData(funcConfig, self.data)
  if title then
    self.itemSecendFuncBord:SetTitle(title)
  end
end
function ItemTipComCell:ClickSecendFunc(data)
  local tipfunc = FunctionItemFunc.Me():GetFunc(data.type)
  if tipfunc then
    if tipfunc then
      tipfunc(self.data, self.chooseCount)
    end
    if data.type == "Combine" then
      local maxNum, hasLeft = FunctionItemFunc._GetCombineMaxNum(self.data.staticData.id)
      if maxNum > 1 or hasLeft then
        self:CloseSecendBord()
        return
      end
    elseif data.type == "CombineMultiple" then
      local maxNum, hasLeft = FunctionItemFunc._GetCombineMaxNum(self.data.staticData.id)
      if hasLeft then
        self:CloseSecendBord()
        return
      end
    end
    self:PassEvent(ItemTipEvent.ClickTipFuncEvent)
  end
end
function ItemTipComCell:CloseSecendBord()
  if self.itemSecendFuncBord then
    self.itemSecendFuncBord:OnDestroy()
    self.itemSecendFuncBord = nil
  end
end
function ItemTipComCell:Exit()
  ItemTipComCell.super.Exit(self)
  self:SetDelTimeTip(false)
  self:CloseSecendBord()
end
function ItemTipComCell:OnFavoriteClick()
  if not self.data then
    LogUtility.Error("Cannot find item data while marking item as favorite.")
    return
  end
  local msgId = BagProxy.Instance:CheckIsFavorite(self.data) and 32001 or 32000
  if not LocalSaveProxy.Instance:GetDontShowAgain(msgId) then
    self:PassEvent(ItemTipEvent.ConfirmMsgShowing, true)
    MsgManager.DontAgainConfirmMsgByID(msgId, function()
      self:NegateFavorite()
      self:PassEvent(ItemTipEvent.ConfirmMsgShowing, false)
    end, function()
      self:PassEvent(ItemTipEvent.ConfirmMsgShowing, false)
    end)
  else
    self:NegateFavorite()
  end
end
function ItemTipComCell:UpdateFavorite()
  if not self:CheckIfCanActiveFavoriteButton() then
    return
  end
  local favoriteSp = self.favoriteButton:GetComponent(UISprite)
  if not favoriteSp then
    return
  end
  favoriteSp.color = BagProxy.Instance:CheckIsFavorite(self.data) and ColorUtil.NGUIWhite or ColorUtil.NGUIGray
end
function ItemTipComCell:TrySetFavoriteButtonActive(isActive)
  if self:CheckIfCanActiveFavoriteButton() then
    self.favoriteButton:SetActive(isActive)
  end
end
function ItemTipComCell:CheckIfCanActiveFavoriteButton()
  if not self.favoriteButton then
    return false
  end
  if self.equipTip.activeInHierarchy or not self.data or self.data.staticData.Type == 65 then
    self.favoriteButton:SetActive(false)
    return false
  end
  return true
end
function ItemTipComCell:NegateFavorite()
  if not self.data then
    LogUtility.Error("Cannot negate favorite of item while item data == nil!")
    return
  end
  BagProxy.Instance:TryNegateFavoriteOfItem(self.data)
end
