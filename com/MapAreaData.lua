MapAreaData = class("MapAreaData")
function MapAreaData:ctor(mapid, x, y)
  self.mapid = mapid
  self.x = x
  self.y = y
  self.index = x * 10000 + y
  self:InitData()
end
function MapAreaData:InitData()
  if self.mapid then
    self.staticData = Table_Map[self.mapid]
    if self.staticData == nil then
      helplog("MapAreaData Init Failure!!!")
    end
    if self.staticData then
      self.pos = {}
      self.pos.x = self.staticData.Position and self.staticData.Position[1]
      self.pos.y = self.staticData.Position and self.staticData.Position[2]
    end
    self.childMaps = {}
    for k, data in pairs(Table_Map) do
      if data and data.MapArea and data.ShowInList == 1 and data.MapArea == self.mapid then
        table.insert(self.childMaps, data)
      end
    end
  end
end
function MapAreaData:GetPos()
  return self.pos
end
function MapAreaData:SetActive(b)
  self.isactive = b
end
function MapAreaData:SetIsNew(isNew)
  self.isNew = isNew
end
