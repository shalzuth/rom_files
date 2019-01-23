local BaseCell = autoImport("BaseCell");
TeamGoalCell = class("TeamGoalCell", BaseCell);

TeamGoalCell.ChooseColor = Color(27/255,94/255,177/255)
TeamGoalCell.NormalColor = Color(34/255,34/255,34/255)

function TeamGoalCell:Init()
	self.label = self:FindComponent("Label", UILabel);
	self:AddCellClickEvent();

	self.choose = false;

	--todo xde
--	self.label.transform.localPosition = Vector3(-60,0,0)
	self.label.fontSize = 22
	OverseaHostHelper:FixLabelOverV1(self.label,3,250)
end

function TeamGoalCell:SetData(data)
	self.data = data;
	self.label.text = data.NameZh;
end

function TeamGoalCell:IsChoose()
	return self.choose;
end

function TeamGoalCell:SetChoose(choose)
	self.choose = choose;
	self.label.color = self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor;
end