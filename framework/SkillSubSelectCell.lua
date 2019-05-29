local baseCell = autoImport("BaseCell")
SkillSubSelectCell = class("SkillSubSelectCell", baseCell)
function SkillSubSelectCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function SkillSubSelectCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
end
function SkillSubSelectCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data ~= nil then
    local staticData = Table_Skill[data]
    if staticData ~= nil then
      IconManager:SetSkillIconByProfess(staticData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
      self.name.text = staticData.NameZh
    end
  end
end
