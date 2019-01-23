local BaseCell = autoImport("BaseCell");
HRefinePosTogCell = class("HRefinePosTogCell", BaseCell)

HRefinePosTog_SpriteMap = 
{
	[5] = "79",
	[7] = "63",
}

function HRefinePosTogCell:Init()
	self.icon = self:FindComponent("Icon", UISprite);
	self.tog = self:FindComponent("tog", UIToggle);

	self:AddCellClickEvent();
end

function HRefinePosTogCell:SetData(data)
	self.data = data;

	self.icon.spriteName = HRefinePosTog_SpriteMap[data];
end

function HRefinePosTogCell:SetTog(chooseData)
	self.tog.value = self.data == chooseData;
end