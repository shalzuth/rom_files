local BaseCell = autoImport("BaseCell")
jihuacombinecell = class("jihuacombinecell", BaseCell)
autoImport("jihuacell")
autoImport("jihuacellfather")
function jihuacombinecell:Init()
  self.gameObject:SetActive(true)
  local fahterObj = self:FindGO("FatherGoal")
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.ChildContainer = self:FindGO("ChildContainer")
  self.arrow = self:FindGO("Arrow")
  self.fatherTog = fahterObj:GetComponent(UIToggle)
  self.FatherGoal = self:FindGO("FatherGoal")
  self.FatherGoal_Label = self:FindGO("Label", self.FatherGoal)
  self.FatherGoal_Label_UILabel = self.FatherGoal_Label:GetComponent(UILabel)
  self.fatherSymbol = self:FindGO("Symbol", fahterObj)
  self.fatherCell = jihuacellfather.new(fahterObj)
  self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self)
  local grid = self:FindComponent("ChildGoals", UITable)
  self.ChildGoals_UITable = self:FindComponent("ChildGoals", UITable)
  self.childCtl = UIGridListCtrl.new(grid, jihuacell, "jihuacell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childCtl:AddEventListener(ServantImproveEvent.JiHuaIconClick, self.JiHuaIconClick, self)
  self.Father = self:FindGO("Father")
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
end
function jihuacombinecell:ChangeFatherLabelText(str)
  self.FatherGoal_Label_UILabel.text = str
end
function jihuacombinecell:OnTweenScaleOnFinished()
  if self.folderState then
    self.ChildGoals_UITable:Reposition()
    self.ChildGoals_UITable.repositionNow = true
  else
  end
end
function jihuacombinecell:ClickFather(cellCtl)
  cellCtl = cellCtl or self.fatherCell
  self:SetChoose(true)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Father",
    combine = self,
    father = cellCtl
  })
end
function jihuacombinecell:ClickChild(cellCtl)
  if cellCtl ~= self.nowChild then
    if self.nowChild then
      self.nowChild:SetChoose(false)
    end
    cellCtl:SetChoose(true)
    self.nowChild = cellCtl
    helplog("ClickChild2")
  else
    self.nowChild:SetChoose(false)
    self.nowChild = nil
    helplog("ClickChild3")
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end
function jihuacombinecell:JiHuaIconClick(cell)
  self:PassEvent(ServantImproveEvent.JiHuaIconClick, cell)
end
function jihuacombinecell:ChildrenLayout()
  self.childCtl:Layout()
end
function jihuacombinecell:GetChildCtl()
  return self.childCtl
end
local tempV3 = LuaVector3()
local tempRot = LuaQuaternion.Euler(0, 0, 0, 0)
function jihuacombinecell:SetData(data)
  self.data = data
  if data.fatherGoal then
    self.fatherCell:SetData(data.fatherGoal)
    self.childCtl:ResetDatas(data.childGoals)
    if #data.childGoals > 0 then
      self:Show(self.fatherSymbol)
      self.Father.gameObject:SetActive(true)
    else
      self:Hide(self.fatherSymbol)
      self.Father.gameObject:SetActive(false)
    end
  else
    helplog("if(data.fatherGoal)then == nil")
  end
  self.folderState = false
  self:SetFolderState(true)
end
function jihuacombinecell:SetChoose(choose)
  if self.nowChild then
    self.nowChild:SetChoose(false)
    self.nowChild = nil
  end
  self.choose = true
end
function jihuacombinecell:GetChoose()
  return self.choose
end
function jihuacombinecell:GetFolderState()
  return self.folderState == true
end
function jihuacombinecell:PlayReverseAnimation()
  self:SetFolderState(not self.folderState)
end
function jihuacombinecell:SetFolderState(isOpen)
  if self.folderState ~= isOpen then
    self.folderState = isOpen
    if isOpen then
      tempV3:Set(0, 0, 0)
      self.tweenScale:PlayForward()
    else
      tempV3:Set(180, 0, 0)
      self.tweenScale:PlayReverse()
    end
    tempRot.eulerAngles = tempV3
    self.arrow.transform.rotation = tempRot
  end
end
