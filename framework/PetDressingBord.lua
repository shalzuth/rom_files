autoImport("PetDressingCombineItemCell")
autoImport("Table_PetAvatar")
PetDressingBord = class("PetDressingBord", CoreView)
local Prefab_Path = ResourcePathHelper.UIView("PetDressingBord")
PetDressingBord.TabConfig = {
  8,
  9,
  10,
  11,
  12
}
local TabCssonfig = {
  "Head",
  "Face",
  "Mouth",
  "Wing",
  "Tail"
}
PetDressingBord.EPosConfig = {
  [8] = SceneItem_pb.EEQUIPPOS_HEAD,
  [9] = SceneItem_pb.EEQUIPPOS_FACE,
  [10] = SceneItem_pb.EEQUIPTYPE_MOUTH,
  [11] = SceneItem_pb.EEQUIPPOS_BACK,
  [12] = SceneItem_pb.EEQUIPPOS_TAIL
}
local EPosConfig = {
  Head = 8,
  Face = 9,
  Mouth = 10,
  Wing = 11,
  Tail = 12
}
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
local _sortData = function(a, b)
  if a == nil then
    return false
  elseif b == nil then
    return true
  end
  if a.unlocked and b.unlocked then
    return a.id < b.id
  end
  if a.unlocked or b.unlocked then
    return a.unlocked
  end
  if false == a.unlocked and false == b.unlocked then
    return a.id < b.id
  end
end
function PetDressingBord:ctor(go, petData)
  self.dressData = {}
  PetDressingBord.super.ctor(self, go)
  self.petinfoData = petData
  self.bodyid = self.petinfoData:GetBodyId()
  self:InitAvatarData(self.bodyid)
  self:Init()
end
function PetDressingBord:InitAvatarData(id)
  local avatarData = Table_PetAvatar[id]
  if avatarData then
    for part, value in pairs(avatarData) do
      for _, v in pairs(value) do
        local epos = EPosConfig[part]
        if v.forbidFlag ~= true then
          if nil == self.dressData[epos] then
            self.dressData[epos] = {}
            local unloadData = {id = 0, unlocked = true}
            table.insert(self.dressData[epos], unloadData)
          end
          local isUnlock = PetComposeProxy.Instance:IsItemUnlock(self.bodyid, epos, v.id)
          local data = {
            id = v.id,
            unlocked = isUnlock
          }
          table.insert(self.dressData[epos], data)
        end
      end
      if self.dressData[EPosConfig[part]] then
        table.sort(self.dressData[EPosConfig[part]], function(a, b)
          return _sortData(a, b)
        end)
      end
    end
  end
end
function PetDressingBord:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:InitView()
end
function PetDressingBord:FindObjs()
  self.itemRoot = self:FindGO("DressWrap")
  self.closeDressingBtn = self:FindGO("CloseDressingBtn")
  self.scrollView = self:FindComponent("PetDressingScrollView", ScrollView)
  self.empty = self:FindGO("Empty")
end
function PetDressingBord:AddUIEvts()
  self:AddClickEvent(self.closeDressingBtn, function(go)
    self:Hide(self.gameObject)
  end)
  self:AddViewEvts()
end
function PetDressingBord:AddViewEvts()
end
function PetDressingBord:InitView()
  self.myPet = PetProxy.Instance:GetMySceneNpet()
  self.nowTab = 1
  self.tabMap = {}
  self.tabSprite = {}
  self.cacheData = FunctionPet.Me():GetMyPetUserdata(self.bodyid)
  for i = 1, #PetDressingBord.TabConfig do
    local obj = self:FindGO("petDressingTab" .. i)
    if obj then
      local index = i
      self:AddClickEvent(obj, function(go)
        self.nowTab = index
        self:UpdateList()
      end)
      self.tabMap[i] = obj:GetComponent(UIToggle)
      self.tabSprite[i] = obj:GetComponent(UISprite)
    else
    end
  end
  self:InitTab()
  self:UpdateTabSprite()
end
function PetDressingBord:UpdateChoose(id)
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local single = cells[i]:GetCells()
    for j = 1, #single do
      single[j]:SetChoose(id)
    end
  end
end
function PetDressingBord:ChooseTab(tab)
  self.tabMap[tab].value = true
  self.nowTab = tab
  self:UpdateList()
end
function PetDressingBord:InitTab()
  self.nowTab = 1
  for i = 2, 5 do
    local tab = self.tabMap[i]
    if tab then
      self.tabMap[i]:Set(false)
    end
  end
  self:ChooseTab(1)
end
function PetDressingBord:RecvPetChangeDress(data)
  self.cacheData = FunctionPet.Me():GetMyPetUserdata(self.bodyid)
  self:UpdateTabSprite()
end
function PetDressingBord:UpdateList()
  local index = PetDressingBord.TabConfig[self.nowTab] or 1
  if nil == self.dressData then
    self:Hide(self.itemRoot)
    return
  end
  local data = self.dressData[index]
  if nil == data then
    self:Hide(self.itemRoot)
    self:Show(self.empty)
    return
  end
  self:Hide(self.empty)
  self:Show(self.itemRoot)
  self:ShowSingle(data)
  local previewData = FunctionPet.Me():GetPreviewData()
  if not previewData or not previewData[RoleDefines_EquipBodyIndex[TabCssonfig[self.nowTab]]] then
  end
  self.curItemid = self.cacheData[PetDressingBord.TabConfig[self.nowTab]]
  self:UpdateChoose(self.curItemid)
end
function PetDressingBord:ShowBord()
  self.dressData = {}
  self.bodyid = self.petinfoData:GetBodyId()
  self:InitAvatarData(self.bodyid)
  self:Show(self.gameObject)
  self:UpdateList()
end
function PetDressingBord:ShowSingle(data)
  local newData = ReUniteCellData(data, 4)
  if nil == self.itemWrapHelper then
    local wrapConfig = {
      wrapObj = self.itemRoot,
      pfbNum = 5,
      cellName = "PetDressingCombineItemCell",
      control = PetDressingCombineItemCell
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  end
  self.itemWrapHelper:UpdateInfo(newData)
  self.itemWrapHelper:ResetPosition()
end
function PetDressingBord:HandleClickItem(cellctl)
  if cellctl and cellctl.data then
    local cellctlId = cellctl.data.id
    local udEnum = RoleDefines_EquipBodyIndex[TabCssonfig[self.nowTab]]
    if cellctl.data.unlocked then
      FunctionPet.Me():SetPreviewData(udEnum, nil)
      local chooseItem = {}
      local oper = {}
      local item = ScenePet_pb.PetWearInfo()
      if cellctlId == 0 then
        local curEquip = self:GetCurEquipByTab()
        if curEquip == 0 then
          MsgManager.ShowMsgByID(26116)
        else
          TableUtility.ArrayClear(chooseItem)
          local id = 26115
          local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
          item.epos = PetDressingBord.TabConfig[self.nowTab]
          item.itemid = curEquip
          item.oper = ScenePet_pb.EPETEQUIPOPER_DELETE
          TableUtility.ArrayPushBack(chooseItem, item)
          if dont == nil then
            MsgManager.DontAgainConfirmMsgByID(id, function()
              ServiceScenePetProxy.Instance:CallChangeWearPetCmd(self.petinfoData.petid, chooseItem)
            end)
          else
            ServiceScenePetProxy.Instance:CallChangeWearPetCmd(self.petinfoData.petid, chooseItem)
          end
          self.curItemid = nil
          self:UpdateChoose()
          self.myPet:ReDress()
        end
        return
      end
      if self.curItemid ~= cellctlId then
        self.curItemid = cellctlId
        oper = ScenePet_pb.EPETEQUIPOPER_ON
        self:UpdateChoose(self.curItemid)
      else
        oper = ScenePet_pb.EPETEQUIPOPER_OFF
        self.curItemid = nil
        self:UpdateChoose()
      end
      TableUtility.ArrayClear(chooseItem)
      item.epos = PetDressingBord.TabConfig[self.nowTab]
      item.itemid = cellctlId
      item.oper = oper
      TableUtility.ArrayPushBack(chooseItem, item)
      ServiceScenePetProxy.Instance:CallChangeWearPetCmd(self.petinfoData.petid, chooseItem)
      break
    else
      local cacheId = self.cacheData[PetDressingBord.TabConfig[self.nowTab]]
      self.curItemid = self.curItemid ~= cellctlId and cellctlId or nil
      self:UpdateChoose(self.curItemid or cacheId)
      FunctionPet.Me():SetPreviewData(udEnum, self.curItemid)
    end
    self.myPet:ReDress()
  end
end
local UD_Enum = {
  UDEnum.HEAD,
  UDEnum.FACE,
  UDEnum.MOUTH,
  UDEnum.BACK,
  UDEnum.TAIL
}
function PetDressingBord:GetCurEquipByTab()
  local scenePet = PetProxy.Instance:GetMySceneNpet()
  local userdata = scenePet.data and scenePet.data.userdata
  if not userdata then
    return
  end
  return userdata:Get(UD_Enum[self.nowTab])
end
function PetDressingBord:GetFakeId(id, cfg)
  for k, v in pairs(cfg) do
    if id == v.id then
      return v.FakeID or v.id
    end
  end
end
function PetDressingBord:UpdateTabSprite()
  for i = 1, #PetDressingBord.TabConfig do
    local preIndex = RoleDefines_EquipBodyIndex[TabCssonfig[i]]
    local spname
    local key = PetDressingBord.TabConfig[i]
    local itemId = self.cacheData[key]
    if itemId then
      spname = Table_Item[itemId] and Table_Item[itemId].Icon or ""
      IconManager:SetItemIcon(spname, self.tabSprite[i])
    else
      spname = i ~= 5 and string.format("bag_equip_%s", i) or "bag_equip_12"
      IconManager:SetUIIcon(spname, self.tabSprite[i])
    end
  end
end
