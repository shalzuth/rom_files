local BaseCell = autoImport("BaseCell")
TeamOptionGComCell = class("TeamOptionGComCell", BaseCell)
autoImport("TeamOptionGSonCell")
function TeamOptionGComCell:Init()
  self:InitCell()
end
function TeamOptionGComCell:InitCell()
  self.childGrid = self:FindComponent("ChildGrid", UIGrid)
  self.childCtl = UIGridListCtrl.new(self.childGrid, TeamOptionGSonCell, "TeamOptionGSonCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.clickChild, self)
  self:SetEvent(self.gameObject, function(go)
    self:clickFather()
  end)
  self.playTween = self.gameObject:GetComponent(UIPlayTween)
  self.label = self:FindComponent("Label", UILabel)
  self.tog = self:FindComponent("Toggle", UIToggle)
  self.goalTween = self:FindGO("GoalTween")
  self.childBg = self:FindComponent("ChildBg", UISprite)
end
function TeamOptionGComCell:clickFather(ignortTween)
  self.tog.value = true
  self:PlayTween(not self.tweenDir)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "father",
    ctl = self,
    data = self.data.fatherGoal
  })
end
function TeamOptionGComCell:clickChild(cellCtl)
  if self.chooseChild ~= cellCtl then
    if not self.tweenDir then
      self.tweenDir = true
      self.childGrid.transform.localScale = Vector3(1, 1, 1)
    end
    if self.chooseChild then
      self.chooseChild:SetChoose(false)
    end
    self.chooseChild = cellCtl
    cellCtl:SetChoose(true)
    self:PassEvent(MouseEvent.MouseClick, {
      type = "child",
      ctl = cellCtl,
      data = cellCtl.data
    })
    self.tog.value = false
  end
end
function TeamOptionGComCell:SetData(data)
  self.label.text = data.NameZh
  self.data = data
  if data.fatherGoal and data.fatherGoal.SetShow == 1 then
    self.gameObject:SetActive(true)
    self.label.text = data.fatherGoal.NameZh
    local childGoals = {}
    for i = 1, #data.childGoals do
      local goal = data.childGoals[i]
      if goal.SetShow == 1 then
        table.insert(childGoals, goal)
      end
    end
    self.childCtl:ResetDatas(childGoals)
    if #childGoals > 0 then
      self.goalTween:SetActive(true)
      self.childBg.height = 59 + 51 * #childGoals
    else
      self.goalTween:SetActive(false)
    end
  else
    self.gameObject:SetActive(false)
  end
end
function TeamOptionGComCell:PlayTween(b)
  self.playTween:Play(b)
  self.tweenDir = b
  if not b and self.chooseChild then
    self.chooseChild:SetChoose(false)
    self.chooseChild = nil
  end
end
function TeamOptionGComCell:SetChoose(b)
  self.tog.value = b
end
function TeamOptionGComCell:InitChoose(goalid)
  if self.data then
    if self.data.fatherGoal and self.data.fatherGoal.id == goalid then
      self:clickFather(true)
      return true
    end
    if self.childCtl then
      local childCells = self.childCtl:GetCells()
      for i = 1, #childCells do
        local childCell = childCells[i]
        if childCell.data and childCell.data.id == goalid then
          self:clickFather(true)
          self:clickChild(childCell)
          return true
        end
      end
    end
  end
  return false
end
