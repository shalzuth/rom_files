local baseCell = autoImport("BaseCell")

ProfessionSkillCell = class("ProfessionSkillCell",baseCell)

function ProfessionSkillCell:Init()
	-- self.bg = self.gameObject:GetComponent(UISprite) 
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self:AddCellClickEvent()
end

function ProfessionSkillCell:SetData(obj)	
	if(obj)then
		local profession = obj[1]
		local skill = obj[2]
		self.data = skill
		local professionData = Table_Class[profession] 
		local professionType = professionData and professionData.Type or MyselfProxy.Instance:GetMyProfessionType()
		local skillData = Table_Skill[skill]
		if(skillData)then
			if(profession)then
				IconManager:SetSkillIconByProfess(skillData.Icon, self.icon,professionType,true)
			else
				IconManager:SetSkillIcon(skillData.Icon, self.icon)
			end
			self:Show(self.icon.gameObject)	
		else
			self.icon.spriteName = nil
			-- self:Hide(self.icon.gameObject)
			errorLog("can't find skillData in table Skill,Skill id:",obj)
		end
	end
end