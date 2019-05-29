autoImport("Bat")
Atcfocar = class("Atcfocar", Bat)
local cmrc, cmcc, cnrc, cncc
function Atcfocar:ctor(reportInterval)
  Atcfocar.super.ctor(self, reportInterval, self.Send, self)
  self.array = {}
  self:CreateArrayItem(SceneUser2_pb.EMONITORBUTTON_AUTO_CLICK_MVP_MINI)
  self:CreateArrayItem(SceneUser2_pb.EMONITORBUTTON_CLICK_MVP_MINI)
  self:CreateArrayItem(SceneUser2_pb.EMONITORBUTTON_CLICK_NPC)
  self:CreateArrayItem(SceneUser2_pb.EMONITORBUTTON_MAP_CLICK_NPC)
end
function Atcfocar:StartRecording(delay)
  Atcfocar.super.StartRecording(self, delay)
  self:Reset()
end
function Atcfocar:Reset()
  cmrc = 0
  cmcc = 0
  cnrc = 0
  cncc = 0
end
function Atcfocar:Rcmc()
  if not self:IsRecording() then
    return
  end
  cmcc = cmcc + 1
end
function Atcfocar:Rcnc(objName)
  if not self:IsRecording() then
    return
  end
  if string.find(objName, "NearlyCreatureCell") then
    cncc = cncc + 1
  end
end
function Atcfocar:Rcr(npcData)
  if not self:IsRecording() then
    return
  end
  if npcData:IsNpc() then
    cnrc = cnrc + 1
  elseif npcData:IsBoss() or npcData:IsMini() then
    cmrc = cmrc + 1
  end
end
function Atcfocar:Send()
  if cmrc + cmcc + cnrc + cncc == 0 then
    return
  end
  local item
  for i = 1, #self.array do
    item = self.array[i]
    if item.enum == SceneUser2_pb.EMONITORBUTTON_AUTO_CLICK_MVP_MINI then
      item.count = cmcc
    elseif item.enum == SceneUser2_pb.EMONITORBUTTON_CLICK_MVP_MINI then
      item.count = cmrc
    elseif item.enum == SceneUser2_pb.EMONITORBUTTON_CLICK_NPC then
      item.count = cnrc
    elseif item.enum == SceneUser2_pb.EMONITORBUTTON_MAP_CLICK_NPC then
      item.count = cncc
    end
  end
  local helper = AAAManager.Me().cplh
  if helper then
    helper:Send(self.array)
  else
    LogUtility.Warning("Cannot find Aaacplh")
  end
  self:Reset()
end
function Atcfocar:CreateArrayItem(enum)
  local item = {enum = enum, count = 0}
  TableUtility.ArrayPushBack(self.array, item)
end
