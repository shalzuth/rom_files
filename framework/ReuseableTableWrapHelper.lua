ReuseableTableWrapHelper = class("ReuseableTableWrapHelper")
local tempV3 = LuaVector3()
local tempV2 = LuaVector2()
local SetParent = SetParent
local GetLocalPosition = LuaGameObject.GetLocalPosition
local InverseTransformPointByVector3 = LuaGameObject.InverseTransformPointByVector3
local panelCorners = {}
local ScrollViewOnMove = function(params, updateItemCallback)
  local dataCount = params.datas and #params.datas or 0
  if dataCount == 0 then
    return
  end
  local itemSize = params.cellSize
  local pfbNum = params.pfbNum
  local panel = params.panel
  local tableTrans = params.tableTrans
  local bound = NGUIMath.CalculateRelativeWidgetBounds(tableTrans)
  local extents = bound.size.y * 0.5
  local corners = panel.worldCorners
  local cellCtrls = params.ctls
  for i = 1, 4 do
    local v = panelCorners[i] or LuaVector3.zero
    v:Set(InverseTransformPointByVector3(tableTrans, corners[i]))
    panelCorners[i] = v
  end
  local center = LuaVector3.Lerp(panelCorners[1], panelCorners[3], 0.5)
  local allWithinRange = true
  local ext2 = extents * 2 + extents / 2
  for i = 1, #cellCtrls do
    local cellCtrl = cellCtrls[i]
    local t = cellCtrl.trans
    local distance = t.localPosition.y - center.y
    if distance < -extents then
      local cell, maxPosition = GetNextTopPositionCell(cellCtrls)
      if cell then
        local nextDataIndex = cell.__dataIndex - 1
        updateItemCallback(i, nextDataIndex)
        local bound = NGUIMath.CalculateRelativeWidgetBounds(t)
        local posY = maxPosition + bound.size.y
        tempV3:Set(GetLocalPosition(t))
        tempV3[2] = posY
        t.localPosition = tempV3
      end
    elseif extents < distance then
      local cell, minPosition = GetNextBottomPositionCell(cellCtrls, dataCount)
      if cell then
        local nextDataIndex = cell.__dataIndex + 1
        updateItemCallback(i, nextDataIndex)
        local bound = NGUIMath.CalculateRelativeWidgetBounds(cell.trans)
        local posY = minPosition - bound.size.y
        tempV3:Set(GetLocalPosition(t))
        tempV3[2] = posY
        t.localPosition = tempV3
      end
    end
  end
end
function GetNextTopPositionCell(cellCtrls)
  if not cellCtrls or #cellCtrls == 0 then
    return nil
  end
  local maxCellCtrl = cellCtrls[1]
  local _, maxPosition, _ = GetLocalPosition(maxCellCtrl.trans)
  local transform
  for i = 2, #cellCtrls do
    local cellCtrl = cellCtrls[i]
    local t = cellCtrl.trans
    local _, y, _ = GetLocalPosition(t)
    if maxPosition < y and cellCtrl.gameObject.activeInHierarchy then
      maxPosition = y
      maxCellCtrl = cellCtrl
    end
  end
  if maxCellCtrl.__dataIndex == 1 then
    return nil
  end
  return maxCellCtrl, maxPosition
end
function GetNextBottomPositionCell(cellCtrls, maxIndex)
  if maxIndex == 0 then
    return nil
  end
  local minCellCtrl = cellCtrls[1]
  local _, minPosition, _ = GetLocalPosition(minCellCtrl.trans)
  local transform
  for i = 2, #cellCtrls do
    local cellCtrl = cellCtrls[i]
    local t = cellCtrl.trans
    local _, y, _ = GetLocalPosition(t)
    if minPosition > y and cellCtrl.gameObject.activeInHierarchy then
      minPosition = y
      minCellCtrl = cellCtrl
    end
  end
  if minCellCtrl.__dataIndex == maxIndex then
    return nil
  end
  return minCellCtrl, minPosition
end
function ReuseableTableWrapHelper:ctor(params)
  self.tableTrans = params.wrapObj.transform
  self.control = params.control
  self.cellName = params.cellName
  self.tableHolder = params.tableHolder
  self.tableHolderTrans = self.tableHolder.transform
  self.tableHolderCmp = self.tableHolder:GetComponent(UITable)
  self.tableHolderOriginParent = self.tableHolderTrans.parent
  self.eventWhenUpdate = params.eventWhenUpdate
  self.scrollView = GameObjectUtil.Instance:FindCompInParents(params.wrapObj, UIScrollView)
  self.dir = self.scrollView.movement
  self.pfbNum = params.pfbNum
  self.cellSize = params.cellSize
  self.panel = self.scrollView:GetComponent(UIPanel)
  local size = self.panel:GetViewSize()
  if self.dir == 1 then
    self.viewLength = size.y
  else
    self.viewLength = size.x
  end
  if not self.pfbNum then
    local numInt, numPoint = math.modf(self.viewLength / self.cellSize)
    if numPoint < 0.5 then
      self.pfbNum = numInt + 1
    else
      self.pfbNum = numInt + 2
    end
  end
  self.ctls = {}
  self.datas = {}
  self:LoadAllPfb()
  local updatefunc = function(wrapI, dataIndex)
    if self.ctls[wrapI] then
      self.ctls[wrapI]:SetData(self.datas[dataIndex])
      self.ctls[wrapI].__dataIndex = dataIndex
    end
  end
  function self.panel.onClipMove()
    ScrollViewOnMove(self, updatefunc)
  end
  self:Layout()
  self.scrollView:ResetPosition()
end
function ReuseableTableWrapHelper:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(self.cellName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cellName)
  end
  cellpfb.transform:SetParent(self.tableTrans, false)
  cellpfb.name = cName
  return cellpfb
end
function ReuseableTableWrapHelper:LoadAllPfb(pfbNum)
  local pnum = pfbNum or self.pfbNum
  for index = 1, pnum do
    local cellGo = self:LoadCellPfb(self.cellName .. index)
    local cell = self.control.new(cellGo)
    self.ctls[index] = cell
  end
end
function ReuseableTableWrapHelper:ResetPosition()
  self:Layout()
end
function ReuseableTableWrapHelper:Layout()
  if #self.datas == 0 then
    return
  end
  local _, y = GetNextTopPositionCell(self.ctls)
  tempV3:Set(0, y, 0)
  self.tableHolderTrans.localPosition = tempV3
  for index = 1, #self.ctls do
    local cell = self.ctls[index]
    cell.trans:SetParent(self.tableHolderTrans)
  end
  self.tableHolderCmp:Reposition()
  for index = 1, #self.ctls do
    local cell = self.ctls[index]
    cell.trans:SetParent(self.tableTrans, true)
  end
end
function ReuseableTableWrapHelper:SetStartPositionByIndex(index)
  self.scrollView:DisableSpring()
  local realPos = (index - 1) * 118
  tempV3:Set(GetLocalPosition(self.panel.transform))
  tempV3[2] = realPos
  self.panel.transform.localPosition = tempV3
  tempV3[2] = -realPos
  self.panel.clipOffset = tempV3
  tempV3:Set(GetLocalPosition(self.tableHolderTrans.transform))
  tempV3[2] = -realPos
  local dataIndex = index
  self.tableHolderTrans.localPosition = tempV3
  for index = 1, #self.ctls do
    local cell = self.ctls[index]
    cell.trans:SetParent(self.tableHolderTrans)
    cell:SetData(self.datas[dataIndex])
    cell.__dataIndex = dataIndex
    dataIndex = dataIndex + 1
  end
  self.tableHolderCmp:Reposition()
  for index = 1, #self.ctls do
    local cell = self.ctls[index]
    cell.trans:SetParent(self.tableTrans, true)
  end
end
function ReuseableTableWrapHelper:ResetDatas(datas)
  self:UpdateInfo(datas)
end
function ReuseableTableWrapHelper:UpdateInfo(datas)
  self.datas = datas
  for index = 1, #self.ctls do
    local cell = self.ctls[index]
    cell:SetData(datas[index])
    cell.__dataIndex = index
  end
  self:Layout()
end
function ReuseableTableWrapHelper:GetCellCtls()
  local result = {}
  for i = 1, #self.ctls do
    table.insert(result, self.ctls[i])
  end
  return result
end
function ReuseableTableWrapHelper:GetDatas()
  return self.datas
end
function ReuseableTableWrapHelper:Destroy()
  local cells = self:GetCellCtls()
  if cells then
    for _, cell in pairs(cells) do
      if cell.OnCellDestroy and type(cell.OnCellDestroy) == "function" then
        cell:OnCellDestroy()
      end
      TableUtility.TableClear(cell)
    end
  end
  TableUtility.TableClear(self)
end
function ReuseableTableWrapHelper:AddEventListener(eventType, handler, handlerOwner)
  for k, v in pairs(self.ctls) do
    if v ~= nil then
      v:AddEventListener(eventType, handler, handlerOwner)
    end
  end
end
