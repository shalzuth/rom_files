autoImport("BaseAttributeView")
autoImport("PlayerAttributeTabCell")
autoImport("PlayerAttriButeCell")
PlayerAttriButeView = class("PlayerAttriButeView", BaseAttributeView)
function PlayerAttriButeView:Init()
  self:initView()
end
local tempVector3 = LuaVector3.zero
function PlayerAttriButeView:initView()
  self.gameObject = self:FindGO("PlayerAttriViewHolder")
  self.baseSp = self:FindGO("Base")
  self.baseGrid = self:FindGO("Grid", self.baseSp):GetComponent(UITable)
  self.baseGridList = UIGridListCtrl.new(self.baseGrid, PlayerAttributeTabCell, "AttributeTabCell")
  self.baseGridList:AddEventListener(MouseEvent.MouseClick, self.ClickPropTab, self)
  self.fixedSp = self:FindGO("Fixed")
  self.fixedGrid = self:FindComponent("Grid", UITable, self.fixedSp)
  self.fixedGridList = UIGridListCtrl.new(self.fixedGrid, PlayerAttributeTabCell, "AttributeTabCell")
  self.fixedGridList:AddEventListener(MouseEvent.MouseClick, self.ClickPropTab, self)
  local lbx = self:FindGO("AbilityPolygon", self.baseSp)
  self.abilitypoint = self:FindGO("point", lbx)
  self.abilityline = self:FindGO("line", lbx)
  self.abilityPolygon = self:FindGO("PowerPolygo", lbx):GetComponent(PolygonSprite)
  local tips = self:FindGO("tips", self.baseSp)
  self.initAttiLab = {}
  for i = 1, 6 do
    self.initAttiLab[i] = self:FindGO("Label" .. i, tips):GetComponent(UILabel)
  end
  self.playerName = self:FindComponent("Name", UILabel)
  self.playerGender = self:FindComponent("RoleSex", UISprite)
end
function PlayerAttriButeView:ClickPropTab(cellctrl)
  cellctrl:toggleGridUIVisible()
  self:updateGeneralData(self.data)
  FunctionPlayerPrefs.Me():Save()
end
function PlayerAttriButeView:SetPlayer(palerData)
  self.data = palerData
  if not self.gameObject.activeInHierarchy then
    self:Show()
    self.abilityPolygon:ReBuildPolygon()
    self:Hide()
  else
    self.abilityPolygon:ReBuildPolygon()
  end
  self:resetData(palerData)
end
function PlayerAttriButeView:resetData(playerData)
  if not playerData then
    return
  end
  self:updateGeneralData(playerData)
  self:reBuildPolygon(playerData)
  self.playerName.text = playerData.name
  local gender = playerData.userdata:Get(UDEnum.SEX)
  self.playerGender.spriteName = gender == 2 and "friend_icon_woman" or "friend_icon_man"
end
function PlayerAttriButeView:updateGeneralData(playerData)
  local datas = self:GetPropByIndex(1, 2, playerData)
  self.baseGridList:ResetDatas(datas)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.baseGrid.gameObject.transform)
  local _, y = LuaGameObject.GetLocalPosition(self.baseSp.transform)
  local x, _, z = LuaGameObject.GetLocalPosition(self.fixedSp.transform)
  tempVector3:Set(x, y - bound.size.y - 4, z)
  self.fixedSp.transform.localPosition = tempVector3
  datas = self:GetPropByIndex(3, #MyselfProxy.Instance.propTabConfigs, playerData)
  if #datas > 0 then
    self.fixedGridList:ResetDatas(datas)
    self:Show(self.fixedSp)
  else
    self:Hide(self.fixedSp)
  end
end
function PlayerAttriButeView:GetPropByIndex(start, endIndex, playerData)
  local datas = {}
  local propsTable = MyselfProxy.Instance.propTabConfigs
  if #propsTable == 0 then
    return datas
  end
  for i = start, endIndex do
    local single = propsTable[i]
    local props = single.props
    local singleData
    for j = 1, #props do
      local id = props[j].id
      local k = Table_RoleData[id].VarName
      local prop = playerData.props[k]
      if 0 ~= prop:GetValue() then
        singleData = singleData or {
          desc = single.desc,
          name = single.name,
          props = {},
          id = single.id
        }
        local data = {}
        data.prop = prop
        data.sign = true
        data.type = BaseAttributeView.cellType.normal
        data.playerData = playerData
        table.insert(singleData.props, data)
      end
    end
    if singleData then
      datas[#datas + 1] = singleData
    end
  end
  return datas
end
