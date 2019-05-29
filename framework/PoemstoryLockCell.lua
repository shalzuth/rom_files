autoImport("BaseCell")
PoemstoryLockCell = class("PoemstoryLockCell", BaseCell)
function PoemstoryLockCell:Init()
  self.storyname = self:FindGO("storyname"):GetComponent(UILabel)
  self.lockname = self:FindGO("lockname"):GetComponent(UILabel)
  self.lockname.pivot = UIWidget.Pivot.Left
  self.lockname.transform.localPosition = Vector3(-66, -22)
  OverseaHostHelper:FixLabelOverV1(self.lockname, 3, 260)
  OverseaHostHelper:FixLabelOverV1(self.storyname, 3, 260)
end
function PoemstoryLockCell:SetData(data)
  self.storyname.text = data.name
  self.lockname.text = data.QuestName
end
