ServerZoneData = class("ServerZoneData")
function ServerZoneData:ctor(data)
  self.map = {}
  self:SetData(data)
end
function ServerZoneData:SetData(data)
  self.serverid = data.serverid
  self.groupid = data.groupid
  local info, num
  local index = 0
  for i = 1, #data.zoneinfos do
    info = data.zoneinfos[i]
    for j = info.minzoneid, info.maxzoneid do
      num = math.fmod(j, 10000)
      if self.serverid ~= 1 then
        index = index + 1
        self.map[num] = index
      else
        self.map[num] = num
      end
    end
  end
end
function ServerZoneData:GetDisplayZoneId(id)
  return self.map[id]
end
function ServerZoneData:GetZoneId(id)
  for k, v in pairs(self.map) do
    if v == id then
      return k
    end
  end
  return nil
end
