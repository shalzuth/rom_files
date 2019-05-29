local BaseCell = autoImport("BaseCell")
TipLabelCell = class("TipLabelCell", BaseCell)
local Line_default_width = {340, 170}
function TipLabelCell:Init()
  self.labelMap = {}
  self.tiplabel = self:FindComponent("A_TipLabel", UILabel)
  self.labelPfb = self:FindGO("Label")
  self.line = self:FindGO("Z_Line")
  self.table = self.gameObject:GetComponent(UITable)
end
local tempVector3 = LuaVector3.zero
function TipLabelCell:SetData(data)
  self.data = data
  if data then
    if Slua.IsNull(self.gameObject) then
      return
    end
    local tiplabel = data.tiplabel
    local labels = {}
    if type(data.label) == "string" then
      labels = {
        data.label
      }
    elseif type(data.label) == "table" then
      labels = data.label
    end
    local hideline = data.hideline or false
    if not self:ObjIsNil(self.tiplabel) then
      if data.tiplabel and data.tiplabel ~= "" then
        self.tiplabel.gameObject:SetActive(true)
        self.tiplabel.text = data.tiplabel
        if data.isGray then
          ColorUtil.GrayUIWidget(self.tiplabel)
        end
      else
        self.tiplabel.gameObject:SetActive(false)
      end
    end
    self:SetLabels(labels, data.labelConfig)
    if self.line then
      self.line:SetActive(not hideline)
      if not hideline then
        local lineImg = self.line:GetComponent("UISprite")
        if data.lineTab then
          lineImg.width = data.lineTab[1]
          tempVector3:Set(data.lineTab[2], self.line.transform.localPosition.y, 0)
        else
          lineImg.width = Line_default_width[1]
          tempVector3:Set(Line_default_width[2], self.line.transform.localPosition.y, 0)
        end
        self.line.transform.localPosition = tempVector3
      end
    end
    if data.needInfo then
      local Label01 = self:FindGO("Label01")
      if Label01 ~= nil and self.helpButton == nil then
        self.helpButton = self:LoadPreferb("cell/HelpButton", Label01)
        self.helpButton.transform.localPosition = Vector3(316, -10, 0)
        self.helpButton.transform.localScale = Vector3(0.8, 0.8, 1)
        self:AddClickEvent(self.helpButton, function(go)
          OverseaHostHelper:ShowGiftProbability(data.itemId)
        end)
        helplog(self.helpButton)
      end
    elseif self.helpButton then
      GameObject.Destroy(self.helpButton)
      self.helpButton = nil
    end
  else
    self:SetLabels({})
  end
  self:RePosition()
end
function TipLabelCell:SetLabels(labels, labelConfig)
  local num = labels and #labels or 0
  local width, iconwidth, iconheight
  if labelConfig then
    width, iconwidth, iconheight = labelConfig.width, labelConfig.iconwidth, labelConfig.iconheight
  end
  for i = 1, num do
    local lab = self.labelMap[i]
    if not lab then
      local labObj = self:CopyGameObject(self.labelPfb)
      labObj:SetActive(true)
      labObj.name = string.format("Label%02d", i)
      labObj = labObj:GetComponent(UILabel)
      if labelConfig and labelConfig.labWidth then
        labObj.width = labelConfig.labWidth
      end
      lab = SpriteLabel.new(labObj, width, iconwidth, iconheight, true)
      self.labelMap[i] = lab
    else
      lab:Reset()
    end
    lab:SetText(labels[i])
    if self.data.isGray then
      ColorUtil.GrayUIWidget(lab.richLabel)
    elseif self.data.isWhite then
      ColorUtil.WhiteUIWidget(lab.richLabel)
    end
  end
  for i = #self.labelMap, num + 1, -1 do
    local richLabel = self.labelMap[i].richLabel
    self.labelMap[i]:Destroy()
    if not Slua.IsNull(richLabel) then
      GameObject.DestroyImmediate(richLabel.gameObject)
    end
    table.remove(self.labelMap, i)
  end
end
function TipLabelCell:RePosition()
  if self.gameObject.activeInHierarchy then
    self.table:Reposition()
  else
    self.table.repositionNow = true
  end
end
