local BaseCell = autoImport("BaseCell");
RecommendPetTipCell = class("RecommendPetTipCell", BaseCell)

function RecommendPetTipCell:Init()
	self.icon = self:FindComponent("Icon", UISprite);
	self.descLab = self:FindComponent("Desc", UILabel);
	self.table = self.gameObject:GetComponent(UITable);
end

function RecommendPetTipCell:SetData(data)
	self.conditionID = data
	if(self.conditionID)then
		local staticData=Table_Pet_AdventureCond[self.conditionID]
		if(staticData)then
			local typeId = staticData.TypeID
			if('Race' == typeId)then
				self.descLab.text=staticData.Desc
				IconManager:SetUIIcon(staticData.Icon,self.icon)
			elseif('Nature' == typeId)then
				self.descLab.text=staticData.Desc
				IconManager:SetUIIcon(staticData.Icon,self.icon)
			elseif('Friendly' == typeId)then
				local friendly = staticData.Param[1]
				self.descLab.text=string.format(staticData.Desc,friendly)
				IconManager:SetUIIcon(staticData.Icon,self.icon)
			elseif('Skill' == typeId)then
				local skillID = staticData.Param[1]
				skillID=skillID * 1000+1
				local limit = staticData.Param[2]
				local skillName = Table_Skill[skillID].NameZh
				self.descLab.text = string.format(staticData.Desc,limit,skillName)
				IconManager:SetSkillIcon(staticData.Icon,self.icon);
			elseif('PetID' == typeId)then
				local petName = Table_Monster[staticData.Param[1]].NameZh
				self.descLab.text=string.format(staticData.Desc,petName)
				IconManager:SetFaceIcon(staticData.Icon,self.icon)
			end
		end
		self.table:Reposition();
		self.table.repositionNow = true;
	end
end
