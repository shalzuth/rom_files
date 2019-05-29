local baseCell = autoImport("BaseCell")
AttributePointSolutionCell = class("AttributePointSolutionCell", baseCell)
function AttributePointSolutionCell:Init()
  self:initView()
  self:addViewEventListener()
end
function AttributePointSolutionCell:initView()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.nameIcon = self:FindGO("nameIcon"):GetComponent(UILabel)
  self.des = self:FindGO("des"):GetComponent(UILabel)
  self.recomand = self:FindGO("recomand"):GetComponent(UILabel)
  self.tips = self:FindGO("tips"):GetComponent(UILabel)
  self.cellBg = self:FindGO("cellBg"):GetComponent(UISprite)
  self.desBg = self:FindGO("desBg"):GetComponent(UISprite)
  self.cellBgLine = self:FindComponent("cellBgLine", UISprite)
end
function AttributePointSolutionCell:addViewEventListener()
  self:SetEvent(self.cellBg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function AttributePointSolutionCell:SetData(data)
  local solutionData = Table_AddPointSolution[data]
  if solutionData then
    self.data = solutionData
    self.nameIcon.text = solutionData.Title
    self.des.text = solutionData.Dsc
    self.recomand.text = solutionData.RecomandSkill
    local bWarp0 = UIUtil.WrapLabel(self.recomand)
    if not bWarp0 then
      UIUtil.GetTextBeforeLastSpace(self.recomand, true)
    end
    self.tips.text = solutionData.tips
    local bWarp1 = UIUtil.WrapLabel(self.tips)
    if not bWarp1 then
      UIUtil.GetTextBeforeLastSpace(self.tips, true)
    end
    if Table_GFaithUIColorConfig then
      local config = Table_GFaithUIColorConfig[solutionData.Icon]
      local succ, color = ColorUtil.TryParseHexString(config.name_Color)
      if succ then
        self.des.color = color
      end
      succ, color = ColorUtil.TryParseHexString(config.levelEffect_Color)
      if succ then
        self.nameIcon.effectColor = color
      end
      succ, color = ColorUtil.TryParseHexString(config.iconBg_Color)
      if succ then
        self.icon.color = color
      end
      succ, color = ColorUtil.TryParseHexString(config.bg_Color)
      if succ then
        self.cellBg.color = color
      end
      succ, color = ColorUtil.TryParseHexString(config.bg1_Color)
      if succ then
        self.desBg.color = color
      end
      succ, color = ColorUtil.TryParseHexString(config.bgline_Color)
      if succ then
        self.cellBgLine.color = color
      end
    end
  else
    errorLog("Cannot Find solutionData in Table_AddPointSolution. solution  Id is " .. tostring(data))
  end
end
