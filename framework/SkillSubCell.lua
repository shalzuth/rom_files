local baseCell = autoImport("BaseCell")
SkillSubCell = class("SkillSubCell", baseCell)
function SkillSubCell:Init()
  self:FindObjs()
  self:InitShow()
end
function SkillSubCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.add = self:FindGO("Add")
  self.remove = self:FindGO("Remove")
end
function SkillSubCell:InitShow()
  self:SetEvent(self.add, function()
    self:PassEvent(SkillEvent.AddSubSkill, self)
  end)
  self:SetEvent(self.remove, function()
    self:PassEvent(SkillEvent.RemoveSubSkill, self)
  end)
end
function SkillSubCell:SetData(data)
  self.data = data
  if data ~= nil then
    if data == -1 then
      self.add:SetActive(true)
      self.remove:SetActive(false)
      self.icon.spriteName = ""
    else
      self.add:SetActive(false)
      self.remove:SetActive(true)
      local staticData = Table_Skill[data]
      if staticData ~= nil then
        IconManager:SetSkillIconByProfess(staticData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
      end
    end
  end
end
