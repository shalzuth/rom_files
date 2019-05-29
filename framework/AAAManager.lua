autoImport("Atcmi")
autoImport("Atpc")
autoImport("Atlpc")
autoImport("Atcfocar")
autoImport("Aaacplh")
AAAManager = class("AAAManager")
AAAManager.Cmri = 120000
AAAManager.Cri = 1800000
AAAManager.Cfri = 1800000
AAAManager.EnumMap = {
  AutoBattleButton = SceneUser2_pb.EMONITORBUTTON_AUTO_BATTLE_BUTTON,
  QuickItemCell1 = SceneUser2_pb.EMONITORBUTTON_QUICK_ITEM_CELL1,
  QuickItemCell2 = SceneUser2_pb.EMONITORBUTTON_QUICK_ITEM_CELL2,
  NearlyButton = SceneUser2_pb.EMONITORBUTTON_NEARLY_BUTTON,
  NPCTog = SceneUser2_pb.EMONITORBUTTON_NPC_TOG,
  NearlyCreatureCell2 = SceneUser2_pb.EMONITORBUTTON_NEARLY_CREATURE_CELL2
}
local isMPlus = false
local atMap
function AAAManager.Me()
  if AAAManager.me == nil then
    AAAManager.me = AAAManager.new()
  end
  return AAAManager.me
end
function AAAManager:ctor()
  atMap = {}
  atMap.cmi = Atcmi.new(self.Cmri)
  atMap.pc = Atpc.new(self.Cri)
  atMap.lpc = Atlpc.new()
  atMap.cf = Atcfocar.new(self.Cfri)
end
function AAAManager:RecvCheatTagStat(data)
  local recvThreshold = data.clickmvpthreshold
  if recvThreshold and recvThreshold > 0 and recvThreshold ~= atMap.cmi.threshold then
    atMap.cmi.threshold = recvThreshold
  end
  if data.buttonthreshold then
    atMap.pc:SetTMap(data.buttonthreshold)
  end
  if data.cheated then
    self:MPlus()
  else
    self:MMinus()
  end
end
function AAAManager:MPlus()
  if isMPlus then
    return
  end
  isMPlus = true
  LogUtility.Info("M+")
  atMap.pc:StartRecording()
  atMap.cf:StartRecording()
  if not self.cplh then
    self.cplh = Aaacplh.new()
  end
end
function AAAManager:MMinus()
  if not isMPlus then
    return
  end
  isMPlus = false
  LogUtility.Info("M-")
  atMap.pc:StopRecording()
  atMap.cf:StopRecording()
  if self.cplh then
    self.cplh:Clear()
  end
end
function AAAManager:ClickEvent(name, positionX, positionY)
  if not name then
    return
  end
  if isMPlus then
    atMap.pc:Record(self.EnumMap[name], positionX, positionY)
    atMap.cf:Rcnc(name)
  end
  atMap.lpc:Record(name, positionX, positionY)
end
function AAAManager:IsCmiOn()
  return atMap.cmi and atMap.cmi:IsOn()
end
function AAAManager:StartCmi()
  atMap.cmi:Start()
end
function AAAManager:ClearCmi()
  atMap.cmi:Clear()
end
function AAAManager:Rcmc()
  atMap.cmi:R()
  atMap.cf:Rcmc()
end
function AAAManager:GetLpc(name)
  return atMap.lpc:Get(name)
end
function AAAManager:ClearLpc(name)
  return atMap.lpc:Clear(name)
end
function AAAManager:Rcr(data)
  return atMap.cf:Rcr(data)
end
function AAAManager.MakeInteger(a, b)
  return math.ceil(a) * 10000 + math.ceil(b)
end
