local baseCell = autoImport("BaseCell")
HireCatSkillCell = class("HireCatSkillCell", baseCell)
function HireCatSkillCell:Init()
  self:initView()
end
function HireCatSkillCell:initView()
  self.skillIcon = self:FindComponent("SkillIcon", UISprite)
  self.skillName = self:FindComponent("SkillName", UILabel)
end
function HireCatSkillCell:SetData(id)
  local data = Table_Skill[id]
  if data then
    self.gameObject:SetActive(true)
    IconManager:SetSkillIcon(data.Icon, self.skillIcon)
    self.skillName.text = data.NameZh
  else
    redlog("\228\189\163\229\133\181\231\140\171\230\138\128\232\131\189ID\230\156\170\229\156\168Skill\232\161\168\228\184\173\230\137\190\229\136\176\239\188\140\233\148\153\232\175\175ID\239\188\154 ", id)
    self.gameObject:SetActive(false)
  end
end
