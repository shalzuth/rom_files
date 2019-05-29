StageItemNormalList = class("StageItemNormalList", CoreView)
autoImport("StageCombineItemCell")
autoImport("WrapListCtrl")
autoImport("StageItemCell")
autoImport("EyeLensesCell")
autoImport("HairDyeCell")
StageItemNormalList.SiteMap = {
  [1] = {name = "\230\173\166\229\153\168", site = 7},
  [2] = {name = "\229\164\180\233\131\168", site = 8},
  [3] = {name = "\232\132\184\233\131\168", site = 9},
  [4] = {name = "\232\131\140\233\131\168", site = 11},
  [5] = {name = "\229\176\190\233\131\168", site = 12},
  [6] = {name = "\230\151\182\232\163\133", site = 2},
  [7] = {name = "\229\137\175\230\137\139", site = 7},
  [8] = {name = "\229\152\180\233\131\168", site = 10},
  [9] = {
    name = "\229\164\180\229\143\145",
    userdatatype = ProtoCommon_pb.EUSERDATATYPE_HAIR
  },
  [10] = {
    name = "\229\143\145\232\137\178",
    userdatatype = ProtoCommon_pb.EUSERDATATYPE_HAIRCOLOR
  },
  [11] = {
    name = "\231\190\142\231\158\179",
    userdatatype = ProtoCommon_pb.EUSERDATATYPE_EYE
  }
}
local resizeScale = LuaVector3.zero
function StageItemNormalList:ctor(go, control, isAddMouseClickEvent)
  if go then
    StageItemNormalList.super.ctor(self, go)
    self.control = control or StageCombineItemCell
    if isAddMouseClickEvent == true or isAddMouseClickEvent == nil then
      self.isAddMouseClickEvent = true
    else
      self.isAddMouseClickEvent = false
    end
    self:Init()
  else
    error("can not find itemListObj")
  end
end
function StageItemNormalList:Init()
  self.nowTab = 6
  self.tabMap = {}
  self.tabIcons = {}
  for i = 1, #StageProxy.TabConfig do
    local obj = self:FindGO("ItemTab" .. i)
    local icon = self:FindGO("sprite1", obj):GetComponent(UISprite)
    if obj then
      local comps = UIUtil.GetAllComponentsInChildren(obj, UISprite)
      local index = i
      self:AddClickEvent(obj, function(go)
        self.nowTab = index
        self:UpdateList(index)
        self.chooseId = 0
        putOn = false
      end)
      self.tabMap[i] = obj:GetComponent(UIToggle)
      self.tabIcons[i] = icon
      if icon and i ~= 10 then
        icon:MakePixelPerfect()
        resizeScale:Set(0.8, 0.8, 1)
      elseif icon and i == 10 then
        icon:MakePixelPerfect()
        resizeScale:Set(0.7, 0.7, 1)
      end
      icon.transform.localScale = resizeScale
    else
    end
  end
  local itemContainer = self:FindGO("bag_itemContainer")
  self.wraplist = WrapListCtrl.new(itemContainer, StageItemCell, "StageItemCell", WrapListCtrl_Dir.Vertical, 4, 98)
  if self.isAddMouseClickEvent then
    self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  end
  self.scrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.itemTabs = self:FindComponent("ItemTabs", UIGrid)
  self.itemCells = self.wraplist:GetCells()
  self:ChooseTab(6)
end
function StageItemNormalList:InitTabList()
  self:UpdateTabList(StageProxy.TabType.EquipTab)
end
function StageItemNormalList:SetTabType(tabType)
  self:UpdateTabList(tabType)
end
function StageItemNormalList:UpdateTabList(tabType)
  self.nowTab = 6
  self.nowTabType = tabType
  if tabType == StageProxy.TabType.EquipTab then
    local class = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    if class == 72 or class == 73 or class == 74 then
      self.showShield = true
    else
      self.showShield = false
    end
    for i = 1, 11 do
      local tab = self.tabMap[i]
      if tab then
        if i == 7 then
          self.tabMap[7].gameObject:SetActive(self.showShield)
        else
          self.tabMap[i].gameObject:SetActive(i < 9)
        end
      end
    end
    self:ChooseTab(6)
    self.tabMap[6]:Set(true)
  else
    for i = 1, 11 do
      local tab = self.tabMap[i]
      if tab then
        self.tabMap[i].gameObject:SetActive(i > 8)
      end
    end
    self:ChooseTab(9)
    self.tabMap[9]:Set(true)
  end
  self.itemTabs:Reposition()
end
local currentSite = 0
local putOn = true
local bodyid = 0
function StageItemNormalList:HandleClickItem(cellCtl)
  putOn = self.chooseId ~= cellCtl.id or putOn
  self.chooseId = cellCtl.id
  if self.nowTab > 0 and self.nowTab < 9 then
    if StageItemNormalList.SiteMap[self.nowTab] then
      currentSite = StageItemNormalList.SiteMap[self.nowTab].site
    end
    if not putOn then
      ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_DRESSUP_OFF, currentSite, tostring(cellCtl.id), false)
      putOn = true
    else
      ServiceItemProxy.Instance:CallEquip(SceneItem_pb.EEQUIPOPER_DRESSUP_ON, currentSite, tostring(cellCtl.id), false)
      putOn = false
      if self.nowTab == 1 then
        bodyid = Game.Myself.data.userdata:Get(UDEnum.BODY)
        Game.Myself:Client_PlayMotionAction(8)
      end
    end
  elseif self.nowTab > 8 and self.nowTab < 12 then
    if StageItemNormalList.SiteMap[self.nowTab] then
      currentSite = StageItemNormalList.SiteMap[self.nowTab].userdatatype
    end
    ServiceNUserProxy.Instance:CallDressUpHeadUserCmd(currentSite, cellCtl.id, putOn)
    putOn = not putOn
  end
  for _, cell in pairs(self.itemCells) do
    cell:SetChooseId(self.chooseId)
  end
  self:SetTabIcon(currentSite, cellCtl)
end
function StageItemNormalList:ChooseTab(tab)
  self.tabMap[tab].value = true
  self.nowTab = tab
  self:UpdateList()
end
function StageItemNormalList:UpdateList(noResetPos)
  local index = self.nowTab or 6
  local datas = self:GetTabDatas()
  self.wraplist:ResetDatas(datas)
  self.wraplist:ResetPosition()
end
local tabDatas = {}
function StageItemNormalList:GetTabDatas()
  TableUtility.ArrayClear(tabDatas)
  local datas
  if self.nowTab == 10 then
    datas = StageProxy.Instance:GetColorsByTab(10)
  else
    datas = StageProxy.Instance:GetItemsByTab(self.nowTab)
  end
  for i = 1, #datas do
    table.insert(tabDatas, datas[i])
  end
  return tabDatas
end
function StageItemNormalList:AddCellEventListener(eventType, handler, handlerOwner)
  self.wraplist:AddEventListener(eventType, handler, handlerOwner)
end
function StageItemNormalList:SetTabIcon(currentSite, cellCtl)
  local data = cellCtl.data
  local icon = self.tabIcons[self.nowTab]
  if type(data) == "number" then
    self.id = data
    local hairColorData = Table_HairColor[data]
    if hairColorData then
      local topColor = hairColorData.ColorH
      local buttomColor = hairColorData.ColorD
      if topColor then
        local result, value = ColorUtil.TryParseHexString(topColor)
        if result then
          icon.color = value
        end
      end
      if buttomColor then
        local result, value = ColorUtil.TryParseHexString(buttomColor)
        if result then
          icon.color = value
        end
      end
      icon:MakePixelPerfect()
      resizeScale:Set(0.7, 0.7, 1)
      icon.transform.localScale = resizeScale
      self.dType = "eyeColor"
    end
    return
  else
    self.id = data.staticData.id
    self.dType = data.staticData.Type
  end
  if icon then
    icon.color = LuaColor.white
    local setSuc, scale = false, Vector3.one
    if self.dType == 821 or self.dType == 822 then
      local hairstyleID = ShopDressingProxy.Instance:GetHairStyleIDByItemID(self.id)
      local hairTableData = Table_HairStyle[hairstyleID]
      if hairTableData and hairTableData.Icon then
        setSuc = IconManager:SetHairStyleIcon(hairTableData.Icon, icon)
      end
      icon:MakePixelPerfect()
      resizeScale:Set(0.8, 0.8, 1)
    elseif self.dType == 823 or self.dType == 824 then
      local csvData = Table_Eye[self.id]
      if csvData and csvData.Icon then
        setSuc = IconManager:SetHairStyleIcon(csvData.Icon, icon)
        local csvColor = csvData.EyeColor
        if csvColor and #csvColor > 0 then
          local hasColor = false
          hasColor, eyeColor = ColorUtil.TryParseFromNumber(csvColor[1])
          icon.color = eyeColor
        end
        icon:MakePixelPerfect()
        resizeScale:Set(0.8, 0.8, 1)
      end
    else
      setSuc = IconManager:SetItemIcon(data.staticData.Icon, icon)
      if not setSuc then
        setSuc = IconManager:SetItemIcon("item_45001", icon)
        redlog("self.id", self.id)
      end
      icon:MakePixelPerfect()
      resizeScale:Set(0.7, 0.7, 1)
      icon.transform.localScale = resizeScale
    end
    if setSuc then
      icon.gameObject:SetActive(true)
      icon.transform.localScale = resizeScale
    else
      icon.gameObject:SetActive(false)
    end
  end
end
