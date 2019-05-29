local COMPOSE_MAX_PET = 3
DendrogramPart = class("DendrogramPart")
function DendrogramPart:ctor(csv, index, needRecursive)
  self.rootCsv = csv
  self.root = csv.id
  self.index = index
  self.needRecursive = needRecursive
end
function DendrogramPart:SetIndex(var)
  self.index = var
end
PetComposeDendrogram = class("PetComposeDendrogram")
function PetComposeDendrogram:ctor(rootId, recursiveFlag)
  self.rootId = rootId
  self.csv = Table_PetCompose[rootId]
  self.interval = nil
  self.uiData = {}
  self.needRecursive = recursiveFlag
  if self.csv then
    self.node = {}
    self:RecursiveNode(rootId)
  else
    self.node = nil
  end
end
function PetComposeDendrogram:RecursiveNode(rootid)
  for i = 1, COMPOSE_MAX_PET do
    local materialPet = self.csv["MaterialPet" .. i]
    local childId = materialPet and materialPet.id
    if childId then
      local index = #self.uiData + 1
      if self.needRecursive and Table_PetCompose[childId] then
        self.node[childId] = self:Clone(childId)
        self.uiData[index] = self:Clone(childId)
      else
        self.node[childId] = DendrogramPart.new(materialPet, i, self.needRecursive)
        self.uiData[index] = DendrogramPart.new(materialPet, i, self.needRecursive)
      end
    end
  end
end
function PetComposeDendrogram:GetUIData()
  return self.uiData
end
function PetComposeDendrogram:GetNode(id)
  if nil == self.node then
    return nil
  end
  return self.node[id]
end
function PetComposeDendrogram:SetIndex(var)
  self.index = var
end
function PetComposeDendrogram:GetNodeCount()
  if not self.node then
    return 0
  end
  local c = 0
  for childID, value in pairs(self.node) do
    c = c + 1
  end
  return c
end
function PetComposeDendrogram:GetChildNodeCount(id)
  local nodeData = self:GetNode(id)
  if nodeData then
    if nodeData.__cname == "PetComposeDendrogram" then
      return nodeData:GetNodeCount()
    else
      return 0
    end
  end
  return 0
end
function PetComposeDendrogram:GetNodeLevel()
  if not self.node then
    return 0
  end
  local level = 1
  for id, value in pairs(self.node) do
    if value.__cname == "PetComposeDendrogram" then
      level = level + 1
    end
  end
  return level
end
function PetComposeDendrogram:Clone(rootid)
  return PetComposeDendrogram.new(rootid, self.needRecursive)
end
function PetComposeDendrogram:SetInterval()
end
