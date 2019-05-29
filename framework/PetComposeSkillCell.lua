local BaseCell = autoImport("BaseCell")
PetComposeSkillCell = class("PetComposeSkillCell", BaseCell)
local allMonster = "pet_icon_all"
function PetComposeSkillCell:Init()
  self:FindObjs()
  self:AddEvt()
end
function PetComposeSkillCell:FindObjs()
  self.nameLab = self:FindGO("Name"):GetComponent(UILabel)
  self.descLab = self:FindComponent("Desc", UILabel)
  self.skillIcon = self:FindComponent("Icon", UISprite)
  self.content = self:FindGO("Content")
end
function PetComposeSkillCell:AddEvt()
end
function PetComposeSkillCell:SetData(data)
  self.data = data
  if data then
    self.content:SetActive(true)
    if Table_Skill[data] then
      local config = Table_Skill[data]
      IconManager:SetSkillIcon(config.Icon, self.skillIcon)
      self.nameLab.text = config.NameZh
      local desc = ""
      local descCsv = Table_Skill[data].Desc
      if descCsv then
        for i = 1, #descCsv do
          local config = descCsv[i]
          if Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc then
            if config.params then
              desc = desc .. string.format(Table_SkillDesc[config.id].Desc, unpack(config.params)) .. (i ~= #Table_Skill[data].Desc and "\n" or "")
            else
              desc = desc .. Table_SkillDesc[config.id].Desc .. (i ~= #Table_Skill[data].Desc and "\n" or "")
            end
          end
        end
      end
      self.descLab.text = desc
    end
  else
    self.content:SetActive(false)
  end
end
