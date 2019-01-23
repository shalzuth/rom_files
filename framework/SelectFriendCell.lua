autoImport("FriendBaseCell")

local baseCell = autoImport("BaseCell")
SelectFriendCell = class("SelectFriendCell", SocialBaseCell)

function SelectFriendCell:Init()
	self:FindObjs()
	self:InitShow()
end

function SelectFriendCell:FindObjs()
	SelectFriendCell.super.FindObjs(self)

	self.mask = self:FindGO("Mask")
	self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
	self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
	self.emptyGuild = self:FindGO("EmptyGuild")
end

function SelectFriendCell:InitShow()
	SelectFriendCell.super.InitShow(self)

	local selectBtn = self:FindGO("SelectBtn")
	self:SetEvent(selectBtn, function ()
		self:PassEvent(SelectFriendEvent.Select, self)
	end)	
end

function SelectFriendCell:SetData(data)
	SelectFriendCell.super.SetData(self, data)

	if data then
		self.mask:SetActive(data.offlinetime ~= 0)

		if data.guildname ~= "" then
			self:SetGuild(true)
			self.guildName.text = data.guildname

			local guildportrait = tonumber(data.guildportrait) or 1
			guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
			IconManager:SetGuildIcon(guildportrait , self.guildIcon)
		else
			self:SetGuild(false)
		end
	end
end

function SelectFriendCell:SetGuild(isActive)
	self.emptyGuild:SetActive(not isActive)
	self.guildName.gameObject:SetActive(isActive)
	self.guildIcon.gameObject:SetActive(isActive)
end