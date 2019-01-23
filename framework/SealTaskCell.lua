local BaseCell = autoImport("BaseCell");
SealTaskCell = class("SealTaskCell", BaseCell)

autoImport("ItemCell");

function SealTaskCell:Init()
	self:InitCell();
end

function SealTaskCell:InitCell()
	self.posLabel = self:FindComponent("PosName", UILabel);
	self.level = self:FindComponent("Level", UILabel);

	local dropGrid = self:FindComponent("DropGrid", UIGrid);
	self.dropCtl = UIGridListCtrl.new(dropGrid ,ItemCell ,"DropItemCell");

	local getBtn = self:FindGO("GetButton");
	self.getBtnLab = self:FindComponent("Label", UILabel, getBtn);
	self:AddClickEvent(getBtn, function (go)
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
end

function SealTaskCell:SetData(data)
	self.data = data;

	local data = data.staticData;
	if(data.Map)then
		self.posLabel.text = data.Map;
	end
	local reward = {}, {};
	if(data.DisplayProps)then
		for _,id in pairs(data.DisplayProps)do
			local tempItem = ItemData.new("Reward", id);
			tempItem.num = 0;
			table.insert(reward, tempItem);
		end
	end
	self.level.text = data.SealLevel.."";
	self.getBtnLab.text = self.data.accept and ZhString.SealTaskCell_GiveUp or ZhString.SealTaskCell_Accept;
	self.dropCtl:ResetDatas(reward);
end