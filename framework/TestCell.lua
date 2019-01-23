local baseCell = import(".BaseCell")
local TestCell = class("TestCell",baseCell)

function TestCell:Init()
end

function TestCell:SetData(obj)
	local c1 = GameObjectUtil.Instance:DeepFindChild(obj,"cell1");
	local testLab = c1.transform:Find("Label");
	local lab = testLab.gameObject:GetComponent(UILabel);
	lab.text = tostring(self.data);
end

return TestCell;