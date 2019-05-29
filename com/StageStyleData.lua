StageStyleData = class("StageStyleData")
function StageStyleData:ctor(type, id)
  self.staticdata = Table_StageParts[id]
  self.stagePart = type
  self.partID = id
  if not self.staticdata then
    self.name = ""
    self.picPath = ""
  else
    self.name = self.staticdata.NameZh
    self.picPath = self.staticdata.picture
  end
end
function StageStyleData:GetName()
  return self.name
end
