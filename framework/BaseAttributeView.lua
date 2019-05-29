BaseAttributeView = class("BaseAttributeView", SubMediatorView)
autoImport("BaseAttributeCell")
autoImport("AttributeTabCell")
BaseAttributeView.cellType = {
  normal = 1,
  fixed = 2,
  jobBase = 3,
  saveHpSp = 4
}
local tempVector3 = LuaVector3.zero
function BaseAttributeView:Init()
  self:initView()
  self:resetData()
  self:AddListenEvts()
  self.attr = nil
end
function BaseAttributeView:resetData()
  self:calculAttrData()
  self:updateGeneralData()
  self:updateFixedData()
  self:reBuildPolygon()
end
function BaseAttributeView:calculAttrData()
  if self.addCoundMap then
    local calView = {}
    self.addData = {}
    local pType = Game.Myself.data:GetCurOcc().professionData.Type
    local jobLv = MyselfProxy.Instance:JobLevel()
    for k, v in pairs(self.addCoundMap) do
      local id = k
      local prop = Game.Myself.data.props[id]
      local extra = MyselfProxy.Instance.extraProps[id]
      local name = prop.propVO.name
      local value = CommonFun.calAttrPoint(v.totalCount, jobLv, pType, name)
      self.addData[prop.propVO.id] = value + prop:GetValue() - extra:GetValue()
      calView[prop.propVO.id] = v.addCount
    end
    local roleLv = MyselfProxy.Instance:RoleLevel()
    local profession = Game.Myself.data:GetCurOcc().profession
    local weaponType = Game.Myself.data:GetEquipedWeaponType()
    self.attr = CommonFun.calcUserShowAttr(calView, profession, roleLv, weaponType)
  end
end
function BaseAttributeView:updateGeneralData()
  local datas = self:GetPropByIndex(1, 2)
  self.baseGridList:ResetDatas(datas)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.baseGrid.gameObject.transform)
  local _, y = LuaGameObject.GetLocalPosition(self.baseSp.transform)
  local x, _, z = LuaGameObject.GetLocalPosition(self.fixedSp.transform)
  tempVector3:Set(x, y - bound.size.y - 4, z)
  self.fixedSp.transform.localPosition = tempVector3
  datas = self:GetPropByIndex(3, #MyselfProxy.Instance.propTabConfigs)
  if #datas > 0 then
    self.fixedGridList:ResetDatas(datas)
    self:Show(self.fixedSp)
  else
    self:Hide(self.fixedSp)
  end
end
function BaseAttributeView:GetPropByIndex(start, endIndex)
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
      local prop = Game.Myself.data.props[k]
      local extraP = MyselfProxy.Instance.extraProps[k]
      if 0 ~= prop:GetValue() or 0 ~= extraP:GetValue() then
        singleData = singleData or {
          desc = single.desc,
          name = single.name,
          props = {},
          id = single.id
        }
        local data = {}
        data.prop = prop
        data.sign = true
        data.extraP = extraP
        if self.attr then
          data.addData = self.attr[id] or 0
        end
        data.type = BaseAttributeView.cellType.normal
        table.insert(singleData.props, data)
      end
    end
    if singleData then
      datas[#datas + 1] = singleData
    end
  end
  return datas
end
function BaseAttributeView:updateFixedData()
end
function BaseAttributeView:initView()
  self.gameObject = self:FindGO("attrViewHolder")
  local obj = self:LoadPreferb("view/BaseAttributeView", self.gameObject, true)
  tempVector3:Set(0, 0, 0)
  obj.transform.localPosition = tempVector3
  self.baseSp = self:FindGO("Base")
  self.baseGrid = self:FindComponent("Grid", UITable, self.baseSp)
  self.baseGridList = UIGridListCtrl.new(self.baseGrid, AttributeTabCell, "AttributeTabCell")
  self.baseGridList:AddEventListener(MouseEvent.MouseClick, self.ClickPropTab, self)
  local lbx = self:FindGO("AbilityPolygon", self.baseSp)
  self.abilitypoint = self:FindGO("point", lbx)
  self.abilityline = self:FindGO("line", lbx)
  self.abilityPolygon = self:FindGO("PowerPolygo", lbx):GetComponent(PolygonSprite)
  local tips = self:FindGO("tips", self.baseSp)
  self.initAttiLab = {}
  for i = 1, 6 do
    self.initAttiLab[i] = self:FindGO("Label" .. i, tips):GetComponent(UILabel)
  end
  self.fixedSp = self:FindGO("Fixed")
  self.fixedGrid = self:FindComponent("Grid", UITable, self.fixedSp)
  self.fixedGridList = UIGridListCtrl.new(self.fixedGrid, AttributeTabCell, "AttributeTabCell")
  self.fixedGridList:AddEventListener(MouseEvent.MouseClick, self.ClickPropTab, self)
  self.helpBtn = self:FindGO("HelpButton")
end
function BaseAttributeView:HideHelpBtn()
  self:Hide(self.helpBtn)
end
function BaseAttributeView:ClickPropTab(cellctrl)
  cellctrl:toggleGridUIVisible()
  self:updateGeneralData()
  FunctionPlayerPrefs.Me():Save()
end
function BaseAttributeView:reBuildPolygon(playerData)
  playerData = playerData or Game.Myself.data or playerData
  local initAttris = {}
  for i = 1, #GameConfig.ClassInitialAttr do
    local single = GameConfig.ClassInitialAttr[i]
    local prop = playerData.props[single]
    table.insert(initAttris, prop)
  end
  if self.lps ~= nil then
    for k, v in pairs(self.lps) do
      GameObject.DestroyImmediate(v)
    end
  end
  if initAttris ~= nil and #initAttris > 0 then
    local v = {}
    for i = 1, #initAttris do
      self.initAttiLab[i].text = initAttris[i].propVO.name
      if self.addData then
        v[i] = self:getWeightByValue(self.addData[initAttris[i].propVO.id])
      else
        v[i] = self:getWeightByValue(initAttris[i]:GetValue())
      end
      self.abilityPolygon:SetLength(i - 1, v[i] * 115)
    end
  end
end
function BaseAttributeView:getWeightByValue(value)
  local A = 0
  if value >= 200 then
    A = 100
  elseif value >= 100 then
    A = 75 + (value - 100) / 100 * 25
  elseif value >= 40 then
    A = 50 + (value - 40) / 60 * 25
  elseif value >= 10 then
    A = 25 + (value - 10) / 30 * 25
  else
    A = 10 + (value - 1) * 15 / 9
  end
  return A / 100
end
function BaseAttributeView:clickShowBtn()
  local activeSelf = not self.gameObject.activeSelf
  self.gameObject:SetActive(activeSelf)
  if activeSelf then
    self.abilityPolygon:ReBuildPolygon()
    self:resetData()
  end
end
function BaseAttributeView:showMySelf(notifyData)
  if not notifyData or not notifyData.from then
    local from
  end
  if not notifyData or not notifyData.addCoundMap then
    local addCoundMap
  end
  if not from then
    self:Show()
  end
  if addCoundMap then
    self.addCoundMap = addCoundMap
  else
    self.attr = nil
    self.addCoundMap = nil
    self.addData = nil
  end
  self.abilityPolygon:ReBuildPolygon()
  self:resetData()
end
function BaseAttributeView:AddListenEvts()
  self:AddListenEvt(MyselfEvent.MyPropChange, self.resetData)
  self:AddListenEvt(ServiceEvent.NUserBuffForeverCmd, self.updateFixedData)
end
