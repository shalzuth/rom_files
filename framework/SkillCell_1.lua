local baseCell = autoImport("BaseCell")
autoImport("DragDropCell")
SkillCell = class("SkillCell", baseCell)
SkillCell.Click_PreviewPeak = "SkillCell_Click_PreviewPeak"
SkillCell.SimulationUpgrade = "SkillCell_SimulationUpgrade"
SkillCell.SimulationDowngrade = "SkillCell_SimulationDowngrade"
SkillCell.EnableLineColor = Color(0.49411764705882355, 0.8, 0.10588235294117647, 1)
SkillCell.DisableLineColor = Color(0.45098039215686275, 0.45098039215686275, 0.45098039215686275, 1)
function SkillCell:Init()
  self.nameEnableAlpha = 1
  SkillCell.super.Init(self)
  self:FindObjs()
end
function SkillCell:FindObjs()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
  self.skillLevel = self:FindGO("SkillLevel"):GetComponent(UILabel)
  self.skillCount = self:FindGO("Count"):GetComponent(UILabel)
  self.upgradeBtn = self:FindGO("LevelUpBtn")
  self.upgradeBtnSp = self:FindGO("LevelUpBtn"):GetComponent(UIMultiSprite)
  self.upgradeBtnSp.isChangeSnap = false
  self.previewBtn = self:FindGO("PreviewBtn")
  self.levelDelBtn = self:FindGO("LevelDelete"):GetComponent(UIButton)
  self.nameBg = self:FindGO("NameBg"):GetComponent(UIMultiSprite)
  self.skillIcon = self:FindGO("SkillIcon"):GetComponent(UISprite)
  self.share = self:FindGO("Share")
  self.func = self:FindGO("Func")
  self.clickCell = self:FindGO("SkillBg")
  self.dragDrop = DragDropCell.new(self.clickCell:GetComponent(UIDragItem))
  self.dragDrop.dragDropComponent.data = self
  self:SetEvent(self.clickCell, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:SetEvent(self.upgradeBtn.gameObject, function()
    self:PassEvent(SkillCell.SimulationUpgrade, self)
  end)
  self:SetEvent(self.levelDelBtn.gameObject, function()
    self:PassEvent(SkillCell.SimulationDowngrade, self)
  end)
  function self.dragDrop.dragDropComponent.OnStart(data)
    if self.data.staticData.SkillType == GameConfig.SkillType.Passive.type then
      self.dragDrop.dragDropComponent:StopDrag()
      MsgManager.ShowMsgByIDTable(601)
    end
  end
  self:SetEvent(self.previewBtn, function()
    self:PassEvent(SkillCell.Click_PreviewPeak, self)
  end)
  self:Hide(self.levelDelBtn.gameObject)
  self:Hide(self.previewBtn)
end
function SkillCell:IsClickMe(click)
  return click == self.clickCell
end
function SkillCell:SetData(data)
  self.data = data
  if self.data and self.data.shadow then
    self:Hide()
    return
  else
    self:Show()
  end
  local skillData = data.staticData
  self:UpdateName(skillData)
  self:UpdateLevel(skillData)
  self:UpdateIcon(skillData)
  self:UpdateSkillNameBg(skillData, self.data:HasRuneSpecials() and 2 or 0)
  self:UpdateUpgradeBtn(skillData)
  self:UpdateShare()
  self:UpdateFunc()
  self:UpdateDragable()
  self:ShowDowngrade(false)
end
function SkillCell:UpdateName(skillData)
  skillData = skillData or self.data.staticData
  if self.skillName ~= skillData.NameZh then
    local name = OverSea.LangManager.Instance():GetLangByKey(skillData.NameZh)
    local len = StringUtil.getTextLen(name)
    if len > 5 then
      name = StringUtil.SubString(name, 1, 4) .. "..."
    end
    self.skillName.text = name
    UIUtil.WrapLabel(self.skillName)
  end
end
function SkillCell:UpdateLevel(skillData)
  self.skillCount.gameObject:SetActive(self.data.maxTimes > 0)
  self.skillLevel.gameObject:SetActive(self.data.maxTimes <= 0)
  if self.data.maxTimes > 0 then
    self.skillCount.text = self.data.leftTimes .. "/" .. self.data.maxTimes
  else
    local breakEnable = SkillProxy.Instance:GetSkillCanBreak() or SimulateSkillProxy.Instance:GetSkillCanBreak()
    if self.data.learned then
      self:SetLevel(self.data.level, nil, breakEnable)
    else
      self:SetLevel(0, nil, breakEnable)
    end
    self:Show(self.skillLevel.gameObject)
  end
end
local sb = LuaStringBuilder.new()
function SkillCell:SetLevel(level, color, breakEnable)
  sb:Clear()
  local extraLevel = self.data:GetExtraLevel()
  local max = self.data.maxLevel
  if breakEnable and self.data.breakMaxLevel > 0 and MyselfProxy.Instance:HasJobBreak() then
    max = self.data.breakMaxLevel
  elseif 0 < self.data.breakNewMaxLevel and MyselfProxy.Instance:HasJobNewBreak() then
    max = self.data.breakNewMaxLevel
  end
  if level == 0 then
    if extraLevel ~= 0 then
      sb:Append(level)
      sb:Append("+")
      sb:Append(extraLevel)
      level = sb:ToString()
    end
    self.skillLevel.text = string.format(ZhString.SkillCell_Level, ColorUtil.GrayColor_16, level, max)
  else
    if extraLevel ~= 0 then
      sb:Append(level)
      sb:Append("[c][000000]")
      sb:Append("+")
      sb:Append(extraLevel)
      sb:Append("[-][/c]")
      level = sb:ToString()
    end
    if color then
      self.skillLevel.text = string.format(ZhString.SkillCell_Level, color, level, max)
    else
      self.skillLevel.text = level .. "/" .. max
    end
  end
end
function SkillCell:UpdateIcon(skillData)
  if skillData ~= nil then
    IconManager:SetSkillIconByProfess(skillData.Icon, self.skillIcon, MyselfProxy.Instance:GetMyProfessionType(), true)
    self:EnableGray(not self.data.learned)
  else
    self.icon.spriteName = nil
  end
end
function SkillCell:UpdateSkillNameBg(skillData, startIndex)
  if startIndex == nil then
    startIndex = 0
  end
  if skillData.SkillType ~= GameConfig.SkillType.Passive.type then
    self.nameBg.CurrentState = startIndex
    self.nameBg.transform.localPosition = Vector3(75, 0, 0)
    self.nameBg.width = 178
  else
    self.nameBg.CurrentState = startIndex + 1
    self.nameBg.transform.localPosition = Vector3(67, 0, 0)
    self.nameBg.width = 186
  end
end
function SkillCell:EnableGray(value)
  if value then
    self.nameBg.alpha = 0.5
    self.skillName.alpha = 0.5
    ColorUtil.ShaderGrayUIWidget(self.skillIcon)
    self.skillIcon.alpha = 0.5
  else
    self.nameBg.alpha = 1
    self:SetNameAlpha(self.nameEnableAlpha)
    ColorUtil.WhiteUIWidget(self.skillIcon)
    self.skillIcon.alpha = 1
  end
end
function SkillCell:UpdateUpgradeBtn(skillData)
  if self.data:GetNextID(SkillProxy.Instance:GetSkillCanBreak()) ~= nil and self.data.active and skillData.Cost > 0 then
    self:ShowUpgrade(true)
  else
    self:ShowUpgrade(false)
  end
end
function SkillCell:UpdateDragable()
  if self.data == nil then
    self:SetDragEnable(false)
  else
    self:SetDragEnable(self.data.learned)
  end
end
function SkillCell:SetDragEnable(val)
  if self.data ~= nil and val then
    local typeConfig = GameConfig.SkillType[self.data.staticData.SkillType]
    local configEnableDrag = true
    if typeConfig and typeConfig.nodrag and typeConfig.nodrag == 1 then
      configEnableDrag = false
    end
    self.dragDrop:SetDragEnable(val and configEnableDrag)
  else
    self.dragDrop:SetDragEnable(false)
  end
end
function SkillCell:SetUpgradeEnable(val, breakEnable)
  if val then
    if breakEnable and MyselfProxy.Instance:HasJobBreak() and self.data ~= nil and self.data.breakMaxLevel > 0 then
      self.upgradeBtnSp.CurrentState = 2
    else
      self.upgradeBtnSp.CurrentState = 0
    end
  else
    self.upgradeBtnSp.CurrentState = 1
  end
end
function SkillCell:SetNameBgEnable(val)
  if val then
    self.nameEnableAlpha = 1
  else
    self.nameEnableAlpha = 0.6
  end
  self:SetNameAlpha(self.nameEnableAlpha)
end
function SkillCell:SetNameAlpha(alpha)
  self.skillName.alpha = alpha
end
function SkillCell:ShowPreview(value)
  if value then
    self:Show(self.previewBtn)
    self:Hide(self.upgradeBtn.gameObject)
  else
    self:Hide(self.previewBtn)
  end
end
function SkillCell:ShowUpgrade(value)
  if value then
    self:Show(self.upgradeBtn.gameObject)
    self:Hide(self.previewBtn)
  else
    self:Hide(self.upgradeBtn.gameObject)
  end
end
function SkillCell:ShowDowngrade(value)
  if value then
    self:Show(self.levelDelBtn.gameObject)
  else
    self:Hide(self.levelDelBtn.gameObject)
  end
end
function SkillCell:GetGridXY()
  local id = self.data.sortID * 1000 + 1
  local config = Table_SkillMould[id]
  if config and config.Pos then
    return config.Pos[1], config.Pos[2]
  end
  return 0, 0
end
function SkillCell:RemoveLink()
  if self.linkLine ~= nil and not GameObjectUtil.Instance:ObjectIsNULL(self.linkLine) then
    GameObject.Destroy(self.linkLine.gameObject)
  end
  self.linkLine = nil
end
function SkillCell:ResetLink()
  self.requiredCell = nil
  self.linkState = nil
end
function SkillCell:DrawLink(cell, hasBetween, up)
  cell.requiredCell = self
  if self.linkLine then
    GameObject.Destroy(self.linkLine.gameObject)
  end
  local targetX, targetY = cell:GetGridXY()
  local myX, myY = self:GetGridXY()
  local cellDistance = cell.gameObject.transform.localPosition - self.gameObject.transform.localPosition
  self.linkLine = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(hasBetween and "SkillBetweenLine" or "SkillLine"), self.gameObject):GetComponent(UISprite)
  self.linkLine.transform.localPosition = Vector3(self.nameBg.transform.localPosition.x + self.nameBg.width, 0, 0)
  if myY == targetY then
    if not hasBetween then
      local fix = 0
      if self.data.staticData.SkillType == GameConfig.SkillType.Passive.type then
        fix = 10
      end
      self.linkLine.width = cellDistance.x - self.nameBg.width - 66 + fix
    else
      self:DrawBetween(up, cellDistance.x - self.nameBg.width - 55 - 62)
    end
  else
    self.linkLine.width = cellDistance.x - self.nameBg.width - 20
    local line2 = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("SkillLine"), self.linkLine.gameObject):GetComponent(UIMultiSprite)
    line2.transform.localPosition = Vector3(self.linkLine.width, 0, 0)
    line2.transform.localEulerAngles = Vector3(0, 0, targetY > myY and -90 or 90)
    line2.width = math.abs(cellDistance.y)
  end
  self:LinkUnlock(true)
end
function SkillCell:DrawBetween(up, width)
  if up then
    self.linkLine.transform.localEulerAngles = Vector3(180, 0, 0)
  end
  local straightLine = self:FindGO("StraightLine", self.linkLine.gameObject):GetComponent(UISprite)
  straightLine.width = width
end
function SkillCell:LinkUnlock(val)
  if self.linkLine and not Slua.IsNull(self.linkLine) and val ~= self.linkState then
    self.linkState = val
    local sps = self.linkLine.gameObject:GetComponentsInChildren(UISprite)
    if sps then
      for i = 1, #sps do
        if val then
          sps[i].color = SkillCell.EnableLineColor
        else
          sps[i].color = SkillCell.DisableLineColor
        end
      end
    end
  end
end
function SkillCell:UpdateShare()
  self.share:SetActive(self.data:GetIsShare())
end
function SkillCell:UpdateFunc()
  local isFunc = false
  for k, v in pairs(SkillItemData.FuncType) do
    if self.data:CheckFuncOpen(v) then
      isFunc = true
      break
    end
  end
  self.func:SetActive(isFunc)
end
AdventureSkillCell = class("AdventureSkillCell", SkillCell)
function AdventureSkillCell:UpdateLevel(skillData)
  self.super.UpdateLevel(self, skillData)
  if self.data.maxTimes <= 0 and skillData.NextID == nil and skillData.Level <= 1 then
    self:Hide(self.skillLevel.gameObject)
  end
end
function AdventureSkillCell:SetLevel(level, color)
  if level == 0 then
    self.skillLevel.text = string.format("[c][%s]0/%s[-][/c]", ColorUtil.GrayColor_16, self.data.maxLevel)
  else
    self.skillLevel.text = "Lv." .. level
  end
end
