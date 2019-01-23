local BaseCell = autoImport("BaseCell");
PetSkillsCell = class("PetSkillsCell", BaseCell);

autoImport("PetSkillCell");

function PetSkillsCell:Init()
	self.skillGrid = self:FindComponent("SkillGrid", UIGrid);
	self.skillsCtl = UIGridListCtrl.new(self.skillGrid , PetSkillCell, "PetSkillCell");
	self.skillsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSkill, self)
	self.endLine = self:FindGO("Line2");
end

function PetSkillsCell:ClickSkill( cell )
	self:PassEvent(MouseEvent.MouseClick, cell);
end

local tempV3 = LuaVector3();
function PetSkillsCell:SetData(datas)
	if(datas and #datas>0)then
		self.skillsCtl:ResetDatas(datas);

		local count = #datas;
		local cellHeight = self.skillGrid.cellHeight;
		local maxPerLine = self.skillGrid.maxPerLine;

		local line2_posY = -135 - (math.ceil(count/maxPerLine) - 1)*cellHeight
		tempV3:Set(0, line2_posY);
		self.endLine.transform.localPosition = tempV3;
	end
end

function PetSkillsCell:HideLine(flag)
	if(not flag)then
		self:Show(self.endLine)
	else
		self:Hide(self.endLine)
	end
end

function PetSkillsCell:SetScale(size)
	local cells = self:GetCells()
	if(not cells)then return end
	for i=1,#cells do
		cells[i]:SetScale(size)
	end
end

function PetSkillsCell:GetCells()
	if(self.skillsCtl)then
		return self.skillsCtl:GetCells();
	end
end