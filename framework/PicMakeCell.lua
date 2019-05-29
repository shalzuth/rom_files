local BaseCell = autoImport("BaseCell")
PicMakeCell = class("PicMakeCell", BaseCell)
autoImport("MaterialNCell")
PicMakeCell.ClickToItem = "PicMakeCell_ClickToItem"
PicMakeCell.ClickMaterial = "PicMakeCell_ClickMaterial"
PicMakeCell.GoToMake = "PicMakeCell_GoToMake"
PicMakeCell.TraceMaterial = "PicMakeCell_TraceMaterial"
PicMakeCell.GuidePicIds = {14176, 14175}
function PicMakeCell:Init()
  PicMakeCell.super.Init()
  self.combine_lacMats = {}
  self.cache_sortingOrder = {}
  self:InitCell()
end
function PicMakeCell:InitCell()
  self.roblab = self:FindComponent("ROGold", UILabel)
  self.costGold = self:FindComponent("CostGold", UILabel)
  self.destItemObj = self:FindGO("ItemCell")
  self.fashionName = self:FindComponent("FashionName", UILabel)
  self.modelContainer = self:FindComponent("ModelContainer", ChangeRqByTex)
  self.makeTip = self:FindComponent("MakeTip", UILabel)
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, MaterialNCell, "MaterialNCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMaterial, self)
  self.modelTexture = self:FindComponent("ModelTexture", UITexture)
  local toItemGO = self:FindGO("ToItem")
  self:AddClickEvent(toItemGO, function(go)
    self:PassEvent(PicMakeCell.ClickToItem, {
      gameObject = go,
      data = self.toItem
    })
  end)
  self:AddButtonEvent("TrackButton", function()
    local materialDatas = self.materialsData or {}
    local traceDatas = {}
    for i = 1, #materialDatas do
      local mdata = materialDatas[i]
      if mdata and mdata.neednum > mdata.num then
        local temp = {
          itemid = mdata.staticData.id
        }
        table.insert(traceDatas, temp)
      end
    end
    if #traceDatas > 0 then
      GameFacade.Instance:sendNotification(MainViewEvent.AddItemTrace, traceDatas)
    else
      MsgManager.ShowMsgByIDTable(542)
    end
    self:PassEvent(PicMakeCell.TraceMaterial, self)
  end)
  self.quickBuyButton = self:FindGO("QuickBuyButton")
  self:AddClickEvent(self.quickBuyButton, function(go)
    if #self.combine_lacMats > 0 and QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
      return
    end
  end)
  self.goMakeButton = self:FindGO("GoMakeButton")
  self:AddClickEvent(self.goMakeButton, function(go)
    self:PassEvent(PicMakeCell.GoToMake, self)
  end)
  self.makeBtn = self:FindGO("MakeButton")
  self:AddClickEvent(self.makeBtn, function(go)
    if #self.combine_lacMats > 0 and QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
      return
    end
    if self.canCompose then
      self:PassEvent(MouseEvent.MouseClick, self)
    else
      MsgManager.ShowMsgByIDTable(8)
    end
  end)
end
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, PRODUCE_MATERIAL_SEARCH_BAGTYPES
local pacakgeCheck = GameConfig.PackageMaterialCheck
DEFAULT_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.default or {1, 9}
PRODUCE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.produce or DEFAULT_MATERIAL_SEARCH_BAGTYPES
function PicMakeCell:GetItemNum(itemid)
  local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, PRODUCE_MATERIAL_SEARCH_BAGTYPES)
  local searchNum = 0
  for i = 1, #items do
    searchNum = searchNum + items[i].num
  end
  return searchNum
end
function PicMakeCell:ClickMaterial(cellctl)
  self:PassEvent(PicMakeCell.ClickMaterial, cellctl)
end
function PicMakeCell:ActiveGoMakeButton(b)
  self.gotoMake_active = b
  self:UpdateButtons()
end
function PicMakeCell:Refresh()
  self:SetData(self.data)
end
function PicMakeCell:SetData(data)
  self.data = data
  local composeID = data.staticData.ComposeID
  if not composeID then
    return
  end
  if not Table_Compose[composeID] then
    return
  end
  local cdata = Table_Compose[composeID]
  self.toItem = ItemData.new(0, cdata.Product.id)
  local toSdata = self.toItem.staticData
  self.fashionName.text = toSdata.NameZh
  self:UpdateFashionModel(self.toItem)
  self.materialsData = {}
  self.canCompose = true
  TableUtility.ArrayClear(self.combine_lacMats)
  local failIndexMap = {}
  if cdata.FailStayItem then
    for i = 1, #cdata.FailStayItem do
      local index = cdata.FailStayItem[i]
      if index then
        failIndexMap[index] = 1
      end
    end
  end
  for i = 1, #cdata.BeCostItem do
    local v = cdata.BeCostItem[i]
    if v and not failIndexMap[i] then
      local tempData = ItemData.new("Material", v.id)
      tempData.num = self:GetItemNum(v.id)
      tempData.neednum = v.num
      if tempData.num < tempData.neednum then
        local lackItem = {
          id = v.id,
          count = v.num - tempData.num
        }
        table.insert(self.combine_lacMats, lackItem)
        self.canCompose = false
      end
      if tempData.staticData.Type ~= 50 then
        table.insert(self.materialsData, tempData)
      end
    end
  end
  self.materialCtl:ResetDatas(self.materialsData)
  self:DrawLine(#self.materialsData)
  local rob = cdata.ROB
  if rob > 0 then
    self.roblab.gameObject:SetActive(true)
    if cdata.ROB > MyselfProxy.Instance:GetROB() then
      self.roblab.text = CustomStrColor.BanRed .. tostring(rob) .. "[-]"
    else
      self.roblab.text = tostring(rob)
    end
  else
    self.roblab.gameObject:SetActive(false)
  end
  if TableUtil.HasValue(PicMakeCell.GuidePicIds, data.staticData.id) then
    self:AddOrRemoveGuideId(self.makeBtn.gameObject)
    self:AddOrRemoveGuideId(self.makeBtn.gameObject, 20)
  end
  self:UpdateButtons()
  self:UpdateBagType()
end
local BagType_SymbolMap = {
  [BagProxy.BagType.PersonalStorage] = "com_icon_Corner_warehouse",
  [BagProxy.BagType.Barrow] = "com_icon_Corner_wheelbarrow",
  [BagProxy.BagType.Temp] = "com_icon_Corner_temporarybag"
}
function PicMakeCell:UpdateBagType()
  if not self.init_bagtype then
    self.init_bagtype = true
    self.bagTypes = self:FindGO("BagTypes")
    self.bagTypes_Sp = self.bagTypes and self.bagTypes:GetComponent(UISprite)
  end
  if self.bagTypes == nil then
    return
  end
  local data = self.data
  if data and data.bagtype then
    if BagType_SymbolMap[data.bagtype] then
      self.bagTypes:SetActive(true)
      self.bagTypes_Sp.spriteName = BagType_SymbolMap[data.bagtype]
    else
      self.bagTypes:SetActive(false)
    end
  else
    self.bagTypes:SetActive(false)
  end
end
function PicMakeCell:UpdateButtons()
  local canMake = #self.combine_lacMats <= 0
  self.makeBtn:SetActive(canMake)
  self.goMakeButton:SetActive(not canMake)
  self.quickBuyButton:SetActive(not canMake)
  self.makeTip.gameObject:SetActive(not canMake)
  if canMake then
    self.quickBuyButton:SetActive(false)
    self.makeBtn:SetActive(self.gotoMake_active ~= true)
    self.goMakeButton:SetActive(self.gotoMake_active == true)
  else
    self.quickBuyButton:SetActive(true)
    self.makeBtn:SetActive(false)
    self.goMakeButton:SetActive(false)
  end
end
function PicMakeCell:DrawLine(num)
  if not self.line then
    local lineObj = self:FindGO("MaterialLines")
    self.line = {}
    self.line.quan = {}
    self.line.dline = {}
    self.line.quanGrid = self:FindComponent("QuanGrid", UIGrid, lineObj)
    self.line.dlineGrid = self:FindComponent("LineGrid", UIGrid, lineObj)
    for i = 1, 4 do
      self.line.quan[i] = self:FindGO("quan" .. i, lineObj)
    end
    for i = 1, 3 do
      self.line.dline[i] = self:FindGO("dline" .. i, lineObj)
    end
    self.line.mid = self:FindComponent("MidLine", UISprite, lineObj)
  end
  self.line.mid.width = num % 2 == 1 and 15 or 22
  for i = 1, 4 do
    if self.line.quan[i] then
      self.line.quan[i]:SetActive(num >= i)
    end
    if self.line.dline[i] then
      self.line.dline[i]:SetActive(i <= num - 1)
    end
  end
  self.line.quanGrid:Reposition()
  self.line.dlineGrid:Reposition()
end
local tempQA = LuaQuaternion()
function PicMakeCell:UpdateFashionModel(fashionData)
  local isPetPic = fashionData.staticData.Type == 52
  local staticID = fashionData.staticData.id
  local sid = isPetPic and Table_UseItem[staticID] and Table_UseItem[staticID].UseEffect.itemid or staticID
  if self.modelId or self.modelId == sid then
    return
  end
  self:RemoveModel()
  self.modelId = sid
  local partIndex = ItemUtil.getItemRolePartIndex(sid)
  self.model = Asset_RolePart.Create(partIndex, sid, self.OnModelCreate, self)
  if self.model then
    self.model:RegisterWeakObserver(self)
    self.model:ResetParent(self.modelContainer.transform)
    self.model:SetLayer(self.modelContainer.gameObject.layer)
    self.modelContainer.excute = false
    local itemModelName = isPetPic and Table_Equip[sid].Model or fashionData.equipInfo.equipData.Model
    if itemModelName and ModelShowConfig[itemModelName] then
      local position = ModelShowConfig[itemModelName].localPosition
      self.model:ResetLocalPositionXYZ(position[1], position[2], position[3])
      local rotation = ModelShowConfig[itemModelName].localRotation
      tempQA:Set(rotation[1], rotation[2], rotation[3], rotation[4])
      self.model:ResetLocalEulerAngles(tempQA.eulerAngles)
      local scale = ModelShowConfig[itemModelName].localScale
      self.model:ResetLocalScaleXYZ(scale[1], scale[2], scale[3])
    end
  end
end
function PicMakeCell.OnModelCreate(obj, self)
  self:ChangeSortingOrder(obj.gameObject)
end
function PicMakeCell:ChangeSortingOrder(go)
  if go == nil then
    return
  end
  local prs = UIUtil.FindAllComponents(go, ParticleSystemRenderer, true)
  if prs == nil then
    return
  end
  for i = 1, #prs do
    local pr = prs[i]
    local instanceID = pr.gameObject:GetInstanceID()
    self.cache_sortingOrder[instanceID] = pr.sortingOrder
    pr.sortingOrder = 0
  end
end
function PicMakeCell:ObserverDestroyed(obj)
  if Slua.IsNull(obj) then
    return
  end
  if obj ~= self.model then
    return
  end
  local prs = UIUtil.FindAllComponents(go, ParticleSystemRenderer, true)
  if prs == nil then
    return
  end
  for i = 1, #prs do
    local pr = prs[i]
    local instanceID = pr.gameObject:GetInstanceID()
    local orilayer = self.cache_sortingOrder[instanceID]
    if orilayer ~= nil then
      pr.sortingOrder = orilayer
    end
  end
  self.model:UnregisterWeakObserver(self)
end
function PicMakeCell:RemoveModel()
  if self.model then
    self.model:Destroy()
    self.modelId = nil
    self.model = nil
  end
end
function PicMakeCell:OnRemove()
  self:RemoveModel()
end
