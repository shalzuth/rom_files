local BaseCell = autoImport("BaseCell");
GuildApplyCell = class("GuildApplyCell", BaseCell);

GuildApplyCell.DoProgress = "GuildApplyCell_DoProgress";

autoImport("PlayerFaceCell")

function GuildApplyCell:Init()
	self.headCell = self:FindGO("PlayerHeadCell");
	self.headCell = PlayerFaceCell.new(self.headCell);
	self.name = self:FindComponent("Name", UILabel);
	self.lv = self:FindComponent("Lv", UILabel);
	self.sex = self:FindComponent("Sex", UISprite);

	local agreeButton = self:FindGO("AgreeButton");
	self:AddClickEvent(agreeButton, function (go)
		self:PassEvent(GuildApplyCell.DoProgress, {self, true});
	end);
	local refuseButton = self:FindGO("RefuseButton");
	self:AddClickEvent(refuseButton, function (go)
		self:PassEvent(GuildApplyCell.DoProgress, {self, false});
	end);
	
	--todo xde
	local tip = self:FindGO("Tip"):GetComponent(UILabel)
	OverseaHostHelper:FixLabelOverV1(tip,3,260)
end

function GuildApplyCell:SetData(data)
	self.data = data;
	if(data)then
		local headData = HeadImageData.new();
		headData:TransByGuildMemberData(data);
		self.headCell:SetData(headData);
		self.name.text = data.name;
		self.lv.text = string.format("Lv.%s", data.baselevel);	
	end
end