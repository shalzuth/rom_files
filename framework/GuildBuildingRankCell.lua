local BaseCell = autoImport("BaseCell");
GuildBuildingRankCell = class("GuildBuildingRankCell", BaseCell);

function GuildBuildingRankCell:Init()
	self.nameLab = self:FindComponent("Name", UILabel);
	self.rankLab = self:FindComponent("Rank",UILabel);
	self.gender = self:FindComponent("Gender",UISprite);
	self.totalSubmitLab = self:FindComponent("TotalSubmit",UILabel);
end

function GuildBuildingRankCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true)
		self.rankLab.text = data.rank
		local rank_data = data.rankData
		if(rank_data)then
			-- helplog("gender: ",rank_data.gender)
			self.nameLab.text = rank_data.name
			self.totalSubmitLab.text = rank_data.submitCountTotal
		end
	else
		self.gameObject:SetActive(false)
	end
end
