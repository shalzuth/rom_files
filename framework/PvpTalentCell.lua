autoImport("TalentSkillCell")
PvpTalentCell = class("PvpTalentCell", BaseCell)
function PvpTalentCell:Init()
  PvpTalentCell.super.Init(self)
  local useless, config = next(GameConfig.PvpTeamRaid)
  self.layerNeedPoint = config.LayerNeedPoint
  self:FindObjs()
  self:InitTalentList()
end
function PvpTalentCell:FindObjs()
  self.labLayer = self:FindComponent("labLayer", UILabel)
  self.objBG = self:FindGO("Bg")
end
function PvpTalentCell:InitTalentList()
  local gridTalents = self:FindComponent("gridTalents", UIGrid)
  self.listTalents = UIGridListCtrl.new(gridTalents, TalentSkillCell, "SkillCell")
  self.listTalents:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.listTalents:AddEventListener(SkillCell.Click_PreviewPeak, self.ShowPeakTipHandler, self)
  self.listTalents:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.listTalents:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
end
function PvpTalentCell:SetData(data)
  local layerStr
  self.layer = data.layer
  if data.layer > 10 then
    local first, second = math.modf(data.layer / 10)
    if second > 0 then
      layerStr = string.format("%s%s", ZhString.ChinaNumber[10], ZhString.ChinaNumber[second * 10])
    else
      layerStr = ZhString.ChinaNumber[10]
    end
    if first > 1 then
      layerStr = string.format("%s%s", ZhString.ChinaNumber[math.clamp(first, 1, 9)], layerStr)
    end
  else
    layerStr = ZhString.ChinaNumber[data.layer]
  end
  self.labLayer.text = string.format(ZhString.SkillView_Talent_Layer, layerStr)
  self.objBG:SetActive(data.layer % 2 ~= 0)
  self.listTalents:ResetDatas(data.skills)
end
function PvpTalentCell:GetLayerSimulateLevel()
  local cells = self.listTalents:GetCells()
  local level = 0
  if cells then
    for i = 1, #cells do
      level = level + cells[i]:GetSimulateLevel()
    end
  end
  return level
end
function PvpTalentCell:SetLayerEnable(isEnabled)
  local cells = self.listTalents:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetCellEnable(isEnabled)
    end
  end
end
function PvpTalentCell:SetLayerUpdateEnable(isEnabled)
  isEnabled = isEnabled and self:GetLayerSimulateLevel() < self.layerNeedPoint
  local cells = self.listTalents:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetUpgradeEnable(isEnabled, false)
    end
  end
end
function PvpTalentCell:SetLayerDisableOperate()
  local cells = self.listTalents:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:SetDisableOperate()
    end
  end
end
function PvpTalentCell:ResetLayer()
  local cells = self.listTalents:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:ResetLevel()
    end
  end
end
function PvpTalentCell:ShowTipHandler(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end
function PvpTalentCell:ShowPeakTipHandler(cell)
  self:PassEvent(SkillCell.Click_PreviewPeak, cell)
end
function PvpTalentCell:SimulationUpgradeHandler(cell)
  self:PassEvent(SkillCell.SimulationUpgrade, cell)
end
function PvpTalentCell:SimulationDowngradeHandler(cell)
  self:PassEvent(SkillCell.SimulationDowngrade, cell)
end
