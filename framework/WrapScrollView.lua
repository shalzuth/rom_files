WrapScrollView = class("WrapScrollView")
local x, y, z, Ax, Ay, Az, Bx, By, Bz
local tempVec = LuaVector3.zero
local CalculateRelativeWidgetBounds = NGUIMath.CalculateRelativeWidgetBounds
local GetLocalPosition = LuaGameObject.GetLocalPosition
function WrapScrollView:ctor(scrollView, table)
  self.scrollView = scrollView
  self.scrollViewTrans = scrollView.transform
  self.isVertically = scrollView.canMoveVertically
  local panel = scrollView:GetComponent(UIPanel)
  if self.isVertically then
    self.panelFinalClipRegion = math.abs(panel.finalClipRegion.y)
  else
    self.panelFinalClipRegion = math.abs(panel.finalClipRegion.x)
  end
  self.tableTrans = table.transform
  if self.isVertically then
    self.tablePadding = table.padding.y
  else
    self.tablePadding = table.padding.x
  end
  table.onCustomSort = WrapScrollView._SortByPos
  self.currentList = {}
  self.tempList = {}
  local childCount = self.tableTrans.childCount
  if childCount > 0 then
    for i = 0, childCount - 1 do
      TableUtility.ArrayPushBack(self.currentList, self.tableTrans:GetChild(i))
    end
  end
  self.lastAxis = self:_GetLocalAxis(self.scrollViewTrans)
  function self.scrollView.onMomentumMove()
    local currentAxis = self:_GetLocalAxis(self.scrollViewTrans)
    local relative = currentAxis - self.lastAxis
    if relative ~= 0 then
      self:CheckScrollView(relative)
    end
    self.lastAxis = currentAxis
  end
end
function WrapScrollView:Init(maxShowNum, totalCount, topOffSetValue, bottomOffSetValue)
  self.index = maxShowNum
  self.maxShowNum = maxShowNum
  self.totalCount = totalCount
  self.topOffSetValue = topOffSetValue
  self.bottomOffSetValue = bottomOffSetValue
end
function WrapScrollView:SetIndex(index)
  self.index = index
end
function WrapScrollView:SelfMinusIndex()
  self.index = self.index - 1
end
function WrapScrollView:SetTotalCount(totalCount)
  self.totalCount = totalCount
end
function WrapScrollView:RefreshPosByIndex(index)
  local currentTrans, lastTrans, currentHeight, lastHeight
  local scrollViewTrans = self.scrollViewTrans
  for i = 1, #self.currentList do
    currentTrans = self.currentList[i]
    if i == 1 then
      lastHeight = CalculateRelativeWidgetBounds(scrollViewTrans, currentTrans, false, true).size.y / 2
    end
    if self.onInitializeItem then
      self.onInitializeItem(currentTrans.gameObject.name, index - i + 1)
    end
    if i == 1 then
      currentHeight = CalculateRelativeWidgetBounds(scrollViewTrans, currentTrans, false, true).size.y / 2
      local offset = currentHeight - lastHeight
      tempVec:Set(0, self:_GetLocalAxis(currentTrans) - offset, 0)
      currentTrans.localPosition = tempVec
    else
      lastTrans = self.currentList[i - 1]
      currentHeight = CalculateRelativeWidgetBounds(scrollViewTrans, currentTrans, false, true).size.y / 2
      lastHeight = CalculateRelativeWidgetBounds(scrollViewTrans, lastTrans, false, true).size.y / 2
      tempVec:Set(0, self:_GetLocalAxis(lastTrans) - lastHeight - currentHeight - self.tablePadding, 0)
      currentTrans.localPosition = tempVec
    end
  end
end
function WrapScrollView:RefreshByIndex(index)
  for i = 1, #self.currentList do
    tempVec:Set(0, -i, 0)
    self.currentList[i].localPosition = tempVec
    if self.onInitializeItem then
      self.onInitializeItem(self.currentList[i].gameObject.name, index - i + 1)
    end
  end
end
function WrapScrollView:CheckScrollView(relative)
  if self.currentList == nil or #self.currentList == 0 then
    return
  end
  self:_SortListByPos()
  TableUtility.ArrayClear(self.tempList)
  local isVertically = self.isVertically
  if isVertically and relative > 0 or not isVertically and relative < 0 then
    local borderValue
    local scrollViewAxis = self:_GetLocalAxis(self.scrollViewTrans)
    local tableAxis = self:_GetLocalAxis(self.tableTrans)
    for i = 1, #self.currentList do
      if isVertically then
        borderValue = self:_GetLocalAxis(self.currentList[i]) + scrollViewAxis + tableAxis + self.panelFinalClipRegion
      end
      if not (borderValue < self.topOffSetValue) then
        TableUtility.ArrayPushBack(self.tempList, self.currentList[i])
      end
    end
    local currentTrans, currentHeight, previousHeight
    local lastTrans = self.currentList[#self.currentList]
    local lastHeight = CalculateRelativeWidgetBounds(self.scrollViewTrans, lastTrans, false, true).size.y / 2
    for i = 1, #self.tempList do
      if not (self.index <= self.maxShowNum) then
        self.index = self.index - 1
        currentTrans = self.tempList[i]
        if self.onInitializeItem then
          self.onInitializeItem(currentTrans.gameObject.name, self.index - self.maxShowNum + 1)
        end
        if self.isVertically then
          currentHeight = CalculateRelativeWidgetBounds(self.scrollViewTrans, currentTrans, false, true).size.y / 2
          if i == 1 then
            tempVec:Set(0, self:_GetLocalAxis(lastTrans) - currentHeight - lastHeight - self.tablePadding, 0)
          else
            tempVec:Set(0, self:_GetLocalAxis(self.tempList[i - 1]) - currentHeight - previousHeight - self.tablePadding, 0)
          end
          currentTrans.localPosition = tempVec
          previousHeight = currentHeight
        end
      end
    end
  elseif isVertically and relative < 0 or not isVertically and relative > 0 then
    local borderValue
    local scrollViewAxis = self:_GetLocalAxis(self.scrollViewTrans)
    local tableAxis = self:_GetLocalAxis(self.tableTrans)
    for i = #self.currentList, 1, -1 do
      if isVertically then
        borderValue = self:_GetLocalAxis(self.currentList[i]) + scrollViewAxis + tableAxis + self.panelFinalClipRegion
      end
      if not (borderValue > -self.bottomOffSetValue) then
        TableUtility.ArrayPushBack(self.tempList, self.currentList[i])
      end
    end
    local currentTrans, currentHeight, previousHeight
    local firstTrans = self.currentList[1]
    local firstHeight = CalculateRelativeWidgetBounds(self.scrollViewTrans, firstTrans, false, true).size.y / 2
    for i = 1, #self.tempList do
      if not (self.index >= self.totalCount) then
        self.index = self.index + 1
        currentTrans = self.tempList[i]
        if self.onInitializeItem then
          self.onInitializeItem(currentTrans.gameObject.name, self.index)
        end
        if isVertically then
          currentHeight = CalculateRelativeWidgetBounds(self.scrollViewTrans, currentTrans, false, true).size.y / 2
          if i == 1 then
            tempVec:Set(0, currentHeight + firstHeight + self:_GetLocalAxis(firstTrans) + self.tablePadding, 0)
          else
            tempVec:Set(0, currentHeight + previousHeight + self:_GetLocalAxis(self.tempList[i - 1]) + self.tablePadding, 0)
          end
          currentTrans.localPosition = tempVec
          previousHeight = currentHeight
        end
      end
    end
  end
  if self.onMoveCallBack then
    self.onMoveCallBack()
  end
end
function WrapScrollView:_GetLocalAxis(trans)
  x, y, z = GetLocalPosition(trans)
  if self.isVertically then
    return y
  else
    return x
  end
end
function WrapScrollView:_SortListByPos()
  table.sort(self.currentList, function(transA, transB)
    Ax, Ay, Az = GetLocalPosition(transA)
    Bx, By, Bz = GetLocalPosition(transB)
    if self.isVertically then
      return Ay > By
    else
      return Ax > Bx
    end
  end)
end
function WrapScrollView._SortByPos(transA, transB)
  Ax, Ay, Az = GetLocalPosition(transA)
  Bx, By, Bz = GetLocalPosition(transB)
  return WrapScrollView._CompareTo(By, Ay)
end
function WrapScrollView._CompareTo(valueA, valueB)
  if valueB < valueA then
    return 1
  end
  if valueA < valueB then
    return -1
  end
  return 0
end
