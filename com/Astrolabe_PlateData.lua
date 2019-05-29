Astrolabe_PlateData = class("Astrolabe_PlateData")
autoImport("Astrolabe_PointData")
local ASTROLABE_BORDER = 150
function Astrolabe_PlateData:ctor(bordData)
  self.bordData = bordData
  self.pointMap = {}
end
function Astrolabe_PlateData:ReInitData(sData)
  TableUtility.TableClear(self.pointMap)
  if sData == nil then
    return
  end
  self.staticData = sData
  self.id = sData.id
  self.pos = {
    sData.pos[1],
    sData.pos[2],
    sData.pos[3]
  }
  self.unlock = sData.unlock
  local maxPointid = 0
  self.point_count = 0
  for pointid, connectData in pairs(sData.stars) do
    local pointData = Astrolabe_PointData.new(self.id, pointid, self.bordData)
    pointData:ReInitPosData(connectData, sData.pos)
    self.pointMap[pointid] = pointData
    maxPointid = math.max(maxPointid, pointid)
    self.point_count = self.point_count + 1
  end
  self.plateWidth = math.floor((maxPointid - 1) / 6) + 1
  self.min_x = self.pos[1] - self.plateWidth * AstrolabeProxy_Plate_Length - ASTROLABE_BORDER
  self.min_y = self.pos[2] - self.plateWidth * AstrolabeProxy_Plate_Length - ASTROLABE_BORDER
  self.max_x = self.pos[1] + self.plateWidth * AstrolabeProxy_Plate_Length + ASTROLABE_BORDER
  self.max_y = self.pos[2] + self.plateWidth * AstrolabeProxy_Plate_Length + ASTROLABE_BORDER
end
function Astrolabe_PlateData:SetProfession(profession)
  self.profession = profession
end
function Astrolabe_PlateData:SetEvo(evo)
  self.evo = evo
end
function Astrolabe_PlateData:GetEvo()
  if self.evo then
    return self.evo
  end
  return ProfessionProxy.Instance:GetDepthByClassId(self:GetProfession())
end
function Astrolabe_PlateData:GetProfession()
  if self.profession then
    return self.profession
  end
  local userdata = Game.Myself and Game.Myself.data.userdata
  if userdata then
    return userdata:Get(UDEnum.PROFESSION)
  end
  return 0
end
function Astrolabe_PlateData:SetRoleLevel(rolelv)
  self.rolelv = rolelv
end
function Astrolabe_PlateData:GetRoleLevel()
  if self.rolelv then
    return self.rolelv
  end
  local userdata = Game.Myself and Game.Myself.data.userdata
  if userdata then
    return userdata:Get(UDEnum.ROLELEVEL)
  end
  return 0
end
function Astrolabe_PlateData:GetPos_XYZ()
  if self.pos then
    return self.pos[1], self.pos[2], self.pos[3]
  end
end
function Astrolabe_PlateData:GetBound_Min_XY()
  return self.min_x, self.min_y
end
function Astrolabe_PlateData:GetBound_Max_XY()
  return self.max_x, self.max_y
end
function Astrolabe_PlateData:GetPointMap()
  return self.pointMap
end
function Astrolabe_PlateData:GetPointDataByPos(posid)
  if posid then
    return self.pointMap[posid]
  end
end
function Astrolabe_PlateData:IsActive()
  return true
end
function Astrolabe_PlateData:GetUnlock()
  if self.staticData then
    return self.staticData.unlock
  end
end
function Astrolabe_PlateData:IsUnlock()
  if self.staticData then
    local unlock = self.staticData.unlock
    if unlock.lv then
      local lv = self:GetRoleLevel()
      if lv < unlock.lv then
        return false
      end
    end
    if unlock.evo then
      if unlock.evo == 4 and not FunctionUnLockFunc.Me():CheckCanOpen(5002) then
        return
      end
      if unlock.evo == 3 and not FunctionUnLockFunc.Me():CheckCanOpen(5001) then
        return
      end
      if self:GetEvo() < unlock.evo then
        return false
      end
    end
    if not GameConfig.SystemForbid.RuneUpgrade and unlock.menuid and not FunctionUnLockFunc.Me():CheckCanOpen(unlock.menuid) then
      return false
    end
    return true
  end
  return false
end
