local BaseCell = autoImport("BaseCell");
GuildDonateMemberCell = class("GuildDonateMemberCell", BaseCell);

function GuildDonateMemberCell:Init()
	self.rank = self:FindComponent("Rank", UILabel);
	self.name = self:FindComponent("Name", UILabel);
	self.donate = self:FindComponent("Donate", UILabel);
end

function GuildDonateMemberCell:SetData(data)
	if(data)then
		self.rank.text = data.index;
		self.name.text = data.memberData.name;
		self.donate.text = data.memberData.weekasset;
	end
end