local BaseCell = autoImport("BaseCell");
PetInfoLabelCell = class("PetInfoLabelCell", BaseCell);

PetInfoLabelCell.Path_PetSkillsCell = ResourcePathHelper.UICell("PetSkillsCell")

PetInfoLabelCell.Type = {
	Attri = 1,
	Skill = 2,
}

autoImport("PetSkillsCell");

function PetInfoLabelCell:Init()
	self.type_Attri = self:FindGO("Type_Attri");
	self.type_Skill = self:FindGO("Type_Skill");

	self.tip = self:FindComponent("Tip", UILabel, self.type_Attri);
	self.value = self:FindComponent("Value", UILabel, self.type_Attri);
end

function PetInfoLabelCell:SetData(data)
	if(data == nil)then
		return
	end

	if(data[1] == PetInfoLabelCell.Type.Skill)then
		if(self.skillGO == nil)then
			self.skillGO = Game.AssetManager_UI:CreateAsset(self.Path_PetSkillsCell, self.type_Skill);
			self.skillsCell = PetSkillsCell.new(self.skillGO);
			self.skillsCell:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self);
		end

		if(data[2])then
			self.skillsCell:SetData(data[2]);
		elseif(data[3])then
			self.skillsCell:SetData(data[3]);
		end
		self.skillsCell:HideLine(data[4])
		self.type_Attri:SetActive(false);
		self.type_Skill:SetActive(true);

	elseif(data[1] == PetInfoLabelCell.Type.Attri)then
		if(self.skillGO~=nil)then
			GameObject.Destroy(self.skillGO);
			self.skillsCell = nil;
		end

		self.tip.text = data[2];

		self.type_Attri:SetActive(true);
		self.type_Skill:SetActive(false);

		self.value.text = data[3] or "";
	end
end

function PetInfoLabelCell:ClickSkill(skillCell)
	self:PassEvent(MouseEvent.MouseClick, skillCell);
end

function PetInfoLabelCell:PlayResetEffect()
	if(self.skillsCell)then
		local cells = self.skillsCell:GetCells();
		if(cells)then
			for i=1,#cells do
				cells[i]:PlayResetEffect();
			end
		end
	end
end