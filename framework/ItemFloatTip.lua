autoImport("BaseTip")
ItemFloatTip = class("ItemFloatTip", BaseTip)
autoImport("FashionPreviewTip")
autoImport("ItemTipComCell")
autoImport("UseWayTip")
function ItemFloatTip:Init()
  self:InitCells()
  self.root = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIRoot)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end
function ItemFloatTip:InitCells()
  self.gpContainer = self:FindGO("GetPathContainer")
  self.grid = self:FindComponent("Grid", UIGrid)
  if not self.isInit then
    self.isInit = true
    self.cells = {}
    for i = 1, 3 do
      local key = "cell" .. i
      local obj = self:LoadPreferb("cell/ItemTipComCell", self.grid.gameObject)
      obj.name = string.format("%d_Cell%d", 4 - i, i)
      self.cells[i] = ItemTipComCell.new(obj, i)
      self.cells[i]:AddEventListener(ItemTipEvent.ClickTipFuncEvent, self.ClickTipFuncEvent, self)
      if i == 1 then
        obj:SetActive(true)
        self.cells[i]:AddEventListener(ItemTipEvent.ShowGetPath, self.ShowGetPath, self)
      else
        obj:SetActive(false)
      end
      self.cells[i]:AddEventListener(ItemTipEvent.ShowFashionPreview, self.ShowFashionPreview, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowGotoUse, self.ShowDoGotoUse, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ShowEquipUpgrade, self.ShowEquipUpgrade, self)
      self.cells[i]:AddEventListener(ItemTipEvent.ConfirmMsgShowing, self.HandleConfirmMsgShowing, self)
    end
  end
end
function ItemFloatTip:ClickTipFuncEvent()
  self:CloseSelf()
end
local tempV3 = LuaVector3()
function ItemFloatTip:ShowGetPath(cell)
  if cell and cell.gameObject then
    self:CloseGotouseBord()
    self:CloseFashionPreview()
    if not self.bdt then
      tempV3:Set(1, 1, 1)
      self.gpContainer.transform.localScale = tempV3
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(self.gpContainer.transform)
      if x > 0 then
        tempV3:Set(lx - 210, ly + 271, 0)
      else
        tempV3:Set(lx + 210, ly + 271, 0)
      end
      self.gpContainer.transform.localPosition = tempV3
      local data = cell.data
      if data and data.staticData then
        self.bdt = GainWayTip.new(self.gpContainer)
        self.bdt:SetAnchorPos(x <= 0)
        self.bdt:SetData(data.staticData.id)
        self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
          self:CloseSelf()
        end, self)
        self.bdt:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.bdt.gameObject)
        self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
      end
    else
      self.bdt:OnExit()
    end
  end
end
function ItemFloatTip:GetPathCloseCall()
  self.closecomp:ReCalculateBound()
  self.bdt = nil
end
function ItemFloatTip:CloseGetPath()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end
function ItemFloatTip:ShowFashionPreview(cell)
  if cell and cell.gameObject then
    for i = 1, #self.cells do
      if self.cells[i] ~= cell then
        self.cells[i]:SetData(nil)
      end
    end
    self:CloseGotouseBord()
    self:CloseGetPath()
    if not self.sfp then
      if cell.hasFunc then
        tempV3:Set(1.21, 1.21, 1.21)
      else
        tempV3:Set(1, 1, 1)
      end
      self.gpContainer.transform.localScale = tempV3
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(cell.gameObject.transform)
      if x > 0 then
        tempV3:Set(lx - 210, ly + 271, 0)
      else
        tempV3:Set(lx + 210, ly + 271, 0)
      end
      self.gpContainer.transform.localPosition = tempV3
      local data = cell.data
      if data and data.staticData then
        self.sfp = FashionPreviewTip.new(self.gpContainer)
        self.sfp:SetAnchorPos(x <= 0)
        if data:IsPic() then
          local cid = data.staticData.ComposeID
          local composeData = cid and Table_Compose[cid]
          if composeData then
            self.sfp:SetData(composeData.Product.id)
          end
        else
          self.sfp:SetData(data.staticData.id)
        end
        self.sfp:AddEventListener(ItemEvent.GoTraceItem, function()
          self:CloseSelf()
        end, self)
        self.sfp:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.sfp.gameObject)
        self.sfp:AddEventListener(FashionPreviewEvent.Close, self.FashionPreViewCloseCall, self)
      end
    else
      self:CloseFashionPreview()
    end
  end
end
function ItemFloatTip:FashionPreViewCloseCall()
  self.closecomp:ReCalculateBound()
  self.sfp = nil
  self:Refresh()
end
function ItemFloatTip:CloseFashionPreview()
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
end
function ItemFloatTip:CloseGotouseBord()
  if self.uwt then
    self.uwt:OnExit()
    self.uwt = nil
  end
end
function ItemFloatTip:ShowDoGotoUse(cell)
  if cell and cell.gameObject then
    self:CloseFashionPreview()
    self:CloseGetPath()
    for i = 1, #self.cells do
      if self.cells[i] ~= cell then
        self.cells[i]:SetData(nil)
      end
    end
    if not self.uwt then
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(cell.gameObject.transform)
      if x > 0 then
        tempV3:Set(lx - 210, ly + 271, 0)
      else
        tempV3:Set(lx + 210, ly + 271, 0)
      end
      self.gpContainer.transform.localPosition = tempV3
      local data = cell.data
      if data and data.staticData then
        self.uwt = UseWayTip.new(self.gpContainer)
        self.uwt:SetAnchorPos(x <= 0)
        self.uwt:SetData(data)
        self.uwt:AddEventListener(ItemTipEvent.ClickGotoUse, self.ClickGotoUse, self)
        self.uwt:AddEventListener(ItemTipEvent.CloseShowGotoUse, self.CloseGotoModeCall, self)
        self.uwt:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.uwt.gameObject)
      end
    else
      self:CloseGotouseBord()
    end
  end
end
function ItemFloatTip:ShowEquipUpgrade(cell)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EquipUpgradePopUp,
    viewdata = {
      equipItem = cell.data
    }
  })
  self:CloseSelf()
end
function ItemFloatTip:ClickGotoUse(param)
  local cell, gotoCell = param[1], param[2]
  if cell and gotoCell then
    FuncShortCutFunc.Me():CallByID(gotoCell.data.GotoMode)
    self:CloseSelf()
  end
end
function ItemFloatTip:CloseGotoModeCall()
  self.closecomp:ReCalculateBound()
  self.uwt = nil
  self:Refresh()
end
function ItemFloatTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end
function ItemFloatTip:SetData(data)
  self.data = data
  self:Refresh()
end
function ItemFloatTip:Refresh()
  local data = self.data
  self.cells[1]:SetData(data.itemdata)
  self.cells[1]:UpdateTipFunc(data.funcConfig)
  self.cells[2]:SetData(data.compdata1)
  self.cells[2]:UpdateTipFunc()
  self.cells[2]:HideGetPath()
  self.cells[3]:SetData(data.compdata2)
  self.cells[3]:UpdateTipFunc()
  self.cells[3]:HideGetPath()
  if data.showUpTip then
    for i = 1, #self.cells do
      self.cells[i]:UpdateShowUpButton()
    end
  end
  self.cells[1]:SetDelTimeTip(data.showDelTime == nil or data.showDelTime == true)
  if data.tip then
    self.cells[1]:SetDownTipText(data.tip)
  end
  if data.compdata1 or data.hideGetPath then
    self.cells[1]:HideGetPath()
  end
  if data.noSelfClose then
    self.closecomp.enabled = false
  else
    self.closecomp.enabled = true
  end
  if data.hideItemIcon then
    self:HideItemIcon()
  end
  if data.needLocker then
    self:ShowMonsterlvLocker()
  end
  self.callback = data.callback
  self.callbackParam = data.callbackParam
  self.ignoreBounds = data.ignoreBounds
end
function ItemFloatTip:Reset()
  self:CloseGetPath()
  self:CloseFashionPreview()
  self.closecomp:ClearTarget()
  LeanTween.cancel(self.gameObject)
end
function ItemFloatTip:OnEnter()
  if type(self.ignoreBounds) == "table" then
    for i = 1, #self.ignoreBounds do
      if not self:ObjIsNil(self.ignoreBounds[i]) then
        self:AddIgnoreBounds(self.ignoreBounds[i])
      end
    end
  end
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, true)
  for i = 1, #colliders do
    colliders[i].enabled = false
  end
  LeanTween.delayedCall(self.gameObject, 0.3, function()
    for i = 1, #colliders do
      if not self:ObjIsNil(colliders[i]) then
        colliders[i].enabled = true
      end
    end
    for i = 1, #self.cells do
      self.cells[i]:Active_Collider_Call()
    end
  end):setDestroyOnComplete(true)
end
function ItemFloatTip:SetPos(pos)
  self:Reset()
  ItemFloatTip.super.SetPos(self, pos)
  self.grid:Reposition()
end
function ItemFloatTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
function ItemFloatTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
function ItemFloatTip:RemoveIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:RemoveTarget(obj.transform)
  end
end
function ItemFloatTip:HideItemIcon()
  for k, cell in pairs(self.cells) do
    cell:HideItemIcon()
  end
end
function ItemFloatTip:GetCell(index)
  return self.cells[index]
end
function ItemFloatTip:HideEquipedSymbol()
  for _, cell in pairs(self.cells) do
    cell:HideEquipedSymbol()
  end
end
function ItemFloatTip:ShowMonsterlvLocker()
  for _, cell in pairs(self.cells) do
    cell:ShowMonsterlvTip()
  end
end
function ItemFloatTip:OnExit()
  for _, cell in pairs(self.cells) do
    cell:Exit()
  end
  self.callback = nil
  self.callbackParam = nil
  return true
end
function ItemFloatTip:ActiveFavorite()
  for _, cell in pairs(self.cells) do
    cell:TrySetFavoriteButtonActive(true)
  end
end
function ItemFloatTip:UpdateFavorite()
  for _, cell in pairs(self.cells) do
    cell:UpdateFavorite()
  end
end
function ItemFloatTip:HandleConfirmMsgShowing(isShowing)
  if Slua.IsNull(self.closecomp) then
    return
  end
  self.closecomp.enabled = not isShowing
end
