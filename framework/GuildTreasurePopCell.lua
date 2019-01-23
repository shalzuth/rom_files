local BaseCell = autoImport("BaseCell");
GuildTreasurePopCell = class("GuildTreasurePopCell", BaseCell);

local MAXARTIFACT = 6
local MALE_ICON = "friend_icon_man"
local FEMALE_ICON = "friend_icon_woman"

function GuildTreasurePopCell:Init()
	self.name = self:FindComponent("Name", UILabel);
	self.job = self:FindComponent("Job", UILabel);
	self.weekbcoin = self:FindComponent("Weekbcoin", UILabel);
	self.totalbcoin = self:FindComponent("Totalbcoin", UILabel);
	self.artifactPos = self:FindGO("ArtifactPos")
	self.sex = self:FindComponent("Sex", UISprite);
	self:AddCellClickEvent();
end

function GuildTreasurePopCell:SetData(data)
	self.data = data
	if(data)then
		self.gameObject:SetActive(true);
		self.artiData = ArtifactProxy.Instance:GetMemberArti(data.id)
		self.sex.spriteName = data:IsBoy() and MALE_ICON or FEMALE_ICON
		if(self.artiData)then
			self:Show(self.artifactPos)
			self:SetMemberArtifact(self.artiData)
		else
			self:Hide(self.artifactPos)
		end
		self.name.text = data.name;
		self.job.text = data:GetJobName();
		self.weekbcoin.text = data.weekbcoin or 0
		self.totalbcoin.text = data.totalcoin or 0;
	else
		self.gameObject:SetActive(false);
	end
end

function GuildTreasurePopCell:SetMemberArtifact(artiData)
	if(not self.artifacts)then
		self.artifacts = {};
		for i=1,MAXARTIFACT do
			self.artifacts[i] = self:FindComponent("arti"..i,UISprite);
		end
	end

	for i=1,MAXARTIFACT do
		if(self.artifacts[i] and #artiData>=i)then
			self:Show(self.artifacts[i].gameObject)
			if(artiData[i] and artiData[i].itemID)then
				local icon = artiData[i].itemStaticData and artiData[i].itemStaticData.Icon or ""
				IconManager:SetItemIcon(icon, self.artifacts[i]);
			end
		else
			self:Hide(self.artifacts[i].gameObject)
		end
	end
end
