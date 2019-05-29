InfomationPage = class("InfomationPage", SubView)
autoImport("BaseAttributeMoneyCell")
autoImport("ProfessionInfoCell")
InfomationPage.addPointAction = "AddPointPage_addPointAction"
InfomationPage.CheckHasSelected = "InfomationPage_CheckHasSelected"
InfomationPage.HasSelectedChange = "InfomationPage_HasSelectedChange"
function InfomationPage:Init()
  self:initView()
  self:initData()
  self:UpdateUserInfo()
  self:addViewEventListener()
  self:AddListenerEvts()
end
function InfomationPage:initData()
  self:AddOrRemoveGuideId("skillBtn", 9)
end
function InfomationPage:removeInfomations(name)
  for i = 1, #self.infomations do
    if name == self.infomations[i] then
      table.remove(self.infomations, i)
      break
    end
  end
end
function InfomationPage:initView()
  self.infomations = {
    unpack(GameConfig.InfoPageConfigs)
  }
  self.leftPointLabel = self:FindChild("leftPointLabel"):GetComponent(UILabel)
  self.attriGrid = self:FindGO("attriGrid"):GetComponent(UIGrid)
  self.attrList = UIGridListCtrl.new(self.attriGrid, BaseAttributeCell, "BaseAttributeCell")
  self.attrList:AddEventListener(InfomationPage.CheckHasSelected, self.CheckHasSelected, self)
  self.attrList:AddEventListener(InfomationPage.HasSelectedChange, self.HasSelectedChange, self)
  if not FunctionUnLockFunc.Me():CheckCanOpen(75) then
  end
  self.attrList:SetEmptyDatas(#self.infomations + 2)
  self.line = self:FindGO("attriGridLine")
  self.line2 = self:FindGO("line2")
  self:Hide(self.line2)
  local infoGridCp = self:FindGO("infoGrid"):GetComponent(UIGrid)
  self.infoGridCt = self:FindGO("infoGridCt")
  self.infoGrid = UIGridListCtrl.new(infoGridCp, BaseAttributeMoneyCell, "BaseAttributeMoneyCell")
  local grid = self:FindGO("professionGrid"):GetComponent(UIGrid)
  self.professionInfoGrid = UIGridListCtrl.new(grid, ProfessionInfoCell, "ProfessionInfoCell")
  self.skillBtn = self:FindGO("skillBtn")
  self:RegistRedTip()
end
local tempVector3 = LuaVector3.zero
function InfomationPage:CheckHasSelected(cellCtr)
  if cellCtr and cellCtr.data then
    local data = cellCtr.data
    local userData = Game.Myself.data.userdata
    if userData then
      local opt = userData:Get(UDEnum.OPTION) or 0
      local optType, desCell
      if data.prop.propVO.name == "SaveHp" then
        optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP
        desCell = self:getCellByCellName("SaveHpDes")
      elseif data.prop.propVO.name == "SaveSp" then
        optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP
        desCell = self:getCellByCellName("SaveSpDes")
      end
      if opt and 0 < BitUtil.band(opt, optType) then
        cellCtr:setIsSelected(true)
      else
        cellCtr:setIsSelected(false)
      end
    end
  end
end
function InfomationPage:CheckDesColor()
  local cells = self.attrList:GetCells()
  local userData = Game.Myself.data.userdata
  local opt = userData:Get(UDEnum.OPTION) or 0
  for i = 1, #cells do
    local cellCtr = cells[i]
    if cellCtr.data then
      local data = cellCtr.data
      local optType
      if data.name == "SaveHpDes" then
        optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP
        local ret = BitUtil.band(opt, optType)
        if ret > 0 then
          cellCtr:whiteValueText()
        else
          cellCtr:greyValueText()
        end
      elseif data.name == "SaveSpDes" then
        optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP
        local ret = BitUtil.band(opt, optType)
        if ret > 0 then
          cellCtr:whiteValueText()
        else
          cellCtr:greyValueText()
        end
      end
    end
  end
end
function InfomationPage:getCellByCellName(name)
  local cells = self.attrList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single.data and single.data.name and single.data.name == name then
      return single
    end
  end
end
function InfomationPage:HasSelectedChange(cellCtr)
  if cellCtr and cellCtr.data then
    local ret = cellCtr:IsSelected()
    local data = cellCtr.data
    local optType
    if data.prop.propVO.name == "SaveHp" then
      optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP
    elseif data.prop.propVO.name == "SaveSp" then
      optType = SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP
    end
    if ret then
      ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(optType, 0)
    else
      ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(optType, 1)
    end
  end
end
function InfomationPage:AddListenerEvts()
  self:AddListenEvt(MyselfEvent.MyPropChange, self.UpdateUserInfo)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateUserInfo)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateMyProfession)
  self:AddListenEvt(ServiceEvent.ItemQueryDebtItemCmd, self.UpdateProps)
end
function InfomationPage:addViewEventListener()
  self:AddButtonEvent("skillBtn", function(obj)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorProfessSkill
    })
  end)
end
function InfomationPage:RegistRedTip()
  local portraitObj = self:FindGO("PlayerHeadCell")
  if portraitObj then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ROLE_IMG, portraitObj, nil, {-15, -15})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_MONSTER_IMG, portraitObj, nil, {-15, -15})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PHOTOFRAME, portraitObj, nil, {-15, -15})
  end
end
function InfomationPage:UpdateMyProfession()
end
function InfomationPage:UpdateUserInfo()
  self:UpdateProps()
  self:UpdateMyProfession()
end
function InfomationPage:UpdateProps()
  local cells = self.attrList:GetCells()
  local userData = Game.Myself.data.userdata
  for i = 1, #self.infomations do
    local single = self.infomations[i]
    local data = {}
    if single == "SaveHpDes" then
      data.type = BaseAttributeView.cellType.saveHpSp
      data.value = ZhString.Charactor_HPEnergyDes
      data.name = single
      local cell = cells[i]
      cell:SetData(data)
      cell:Hide(cell.line)
    elseif single == "SaveSpDes" then
      data.type = BaseAttributeView.cellType.saveHpSp
      data.value = ZhString.Charactor_SPEnergyDes
      data.name = single
      local cell = cells[i]
      cell:SetData(data)
      cell:Hide(cell.line)
    elseif single == "Satiety" then
      local foods = FoodProxy.Instance:GetEatFoods()
      local cur = foods and #foods or 0
      local curLv = userData:Get(UDEnum.TASTER_LV) or 0
      local tbData = Table_TasterLevel[curLv]
      local progress = 1
      if tbData then
        progress = tbData.AddBuffs
      else
        progress = GameConfig.Food.MaxSatiety_Default or 80
      end
      data.type = BaseAttributeView.cellType.jobBase
      data.value = cur .. "/" .. progress
      data.name = ZhString.Charactor_SatieTyDes
      local cell = cells[i]
      cell:SetData(data)
      cell:Hide(cell.line)
    else
      local prop = Game.Myself.data.props[single]
      local extra = MyselfProxy.Instance.extraProps[single]
      data.prop = prop
      data.extraP = extra
      data.type = BaseAttributeView.cellType.normal
      local cell = cells[i]
      cell:SetData(data)
      cell:Hide(cell.line)
    end
  end
  local baseCell = cells[#self.infomations + 1]
  local data = {}
  local userData = Game.Myself.data.userdata
  local roleExp = userData:Get(UDEnum.ROLEEXP) or 0
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL) or 0
  local referenceValue = Table_BaseLevel[nowRoleLevel + 1]
  if referenceValue == nil then
    referenceValue = roleExp
  else
    referenceValue = referenceValue.NeedExp
  end
  data.type = BaseAttributeView.cellType.jobBase
  data.value = roleExp .. "/" .. referenceValue
  data.name = "Base"
  baseCell:SetData(data)
  baseCell:Hide(baseCell.line)
  baseCell = cells[#self.infomations + 2]
  local nowJob = Game.Myself.data:GetCurOcc()
  if nowJob == nil then
    return
  end
  referenceValue = Table_JobLevel[nowJob.level + 1]
  if referenceValue == nil then
    referenceValue = nowJob.exp
  else
    referenceValue = referenceValue.JobExp
  end
  data.type = BaseAttributeView.cellType.jobBase
  data.value = nowJob.exp .. "/" .. referenceValue
  data.name = "Job"
  baseCell:SetData(data)
  baseCell:Hide(baseCell.line)
  self.attrList:Layout()
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.attriGrid.transform, true)
  tempVector3:Set(LuaGameObject.GetLocalPosition(self.attriGrid.transform))
  local y = tempVector3.y - bound.size.y
  tempVector3:Set(LuaGameObject.GetLocalPosition(self.infoGridCt.transform))
  tempVector3:Set(tempVector3.x, y - 5, tempVector3.z)
  self.infoGridCt.transform.localPosition = tempVector3
  local debts = MyselfProxy.Instance:GetDebts()
  local moneyArray = {
    unpack(GameConfig.Charactor_InfoShow)
  }
  TableUtil.InsertArray(moneyArray, debts)
  self.infoGrid:ResetDatas(moneyArray)
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.Charactor.id, self.skillBtn)
  self:CheckDesColor()
end
