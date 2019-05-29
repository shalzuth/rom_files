AstrolabeCellPool = class("AstrolabeCellPool")
autoImport("Astrolabe_PointCell")
autoImport("Astrolabe_LineCell")
local PointCell_PoolSzie = 500
local LineCell_PoolSzie = 300
AstrolabeCellPool.Instance = nil
function AstrolabeCellPool:ctor()
  self.pointCellPool = {}
  self.lineCellPool = {}
  self:InitContainer()
  AstrolabeCellPool.Instance = self
end
function AstrolabeCellPool:InitContainer()
  if self.container == nil then
    self.container = GameObject("AstrolabeCellPool")
    self.container.layer = RO.Config.Layer.UI.Value
    self.container:SetActive(false)
    GameObject.DontDestroyOnLoad(self.container)
    self.container = self.container.transform
    self.container:SetParent(UIManagerProxy.Instance.UIRoot.transform)
  end
end
function AstrolabeCellPool:GetPointCellFromPool(parent)
  local pointCell = table.remove(self.pointCellPool)
  if pointCell == nil then
    pointCell = Astrolabe_PointCell.new()
  end
  pointCell:OnAdd(parent)
  return pointCell
end
function AstrolabeCellPool:AddPointCellToPool(pointCell)
  if pointCell == nil then
    return
  end
  local count = #self.pointCellPool
  if count <= PointCell_PoolSzie then
    pointCell:OnRemove()
    table.insert(self.pointCellPool, pointCell)
  else
    pointCell:OnDestroy()
  end
end
function AstrolabeCellPool:ClearPointCellPool()
  for i = #self.pointCellPool, 1, -1 do
    self.pointCellPool[i]:OnDestroy()
    self.pointCellPool[i] = nil
  end
end
function AstrolabeCellPool:PrintPointPoolSize()
  helplog("pointCellPool Size:", #self.pointCellPool)
end
function AstrolabeCellPool:GetLineCellFromPool(parent)
  local lineCell = table.remove(self.lineCellPool)
  if lineCell == nil then
    lineCell = Astrolabe_LineCell.new()
  end
  lineCell:OnAdd(parent)
  return lineCell
end
function AstrolabeCellPool:AddLineCellToPool(lineCell)
  if lineCell == nil then
    return
  end
  local count = #self.lineCellPool
  if count <= LineCell_PoolSzie then
    lineCell:OnRemove()
    table.insert(self.lineCellPool, lineCell)
  else
    lineCell:OnDestroy()
  end
end
function AstrolabeCellPool:ClearLineCellPool()
  for i = #self.lineCellPool, 1, -1 do
    self.lineCellPool[i]:OnDestroy()
    self.lineCellPool[i] = nil
  end
end
function AstrolabeCellPool:AddToTempPool(obj)
  obj.transform:SetParent(self.container, false)
end
