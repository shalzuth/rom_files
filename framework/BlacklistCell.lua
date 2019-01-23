autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
BlacklistCell = class("BlacklistCell", baseCell)

function BlacklistCell:Init()
	self:FindObjs()
	self:InitShow()

	self:AddCellClickEvent()
	self:AddGameObjectComp()
end

function BlacklistCell:FindObjs()

	local headContainer = self:FindGO("HeadContainer")
	self.headIcon = HeadIconCell.new()
	self.headIcon:CreateSelf(headContainer)
	self.headIcon.gameObject:AddComponent(UIDragScrollView)
	self.headIcon:SetScale(0.6)
	self.headIcon:SetMinDepth(1)

	self.Profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
	self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
	self.Level = self:FindGO("Level"):GetComponent(UILabel)
	self.Mask = self:FindGO("Mask")
	self.Name = self:FindGO("Name"):GetComponent(UILabel)
	self.GenderIcon = self:FindGO("GenderIcon"):GetComponent(UISprite)
	self.GuildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
	self.GuildName = self:FindGO("GuildName"):GetComponent(UILabel)
	self.EmptyGuild = self:FindGO("EmptyGuild"):GetComponent(UILabel)
	self.Time = self:FindGO("Time"):GetComponent(UILabel)
end

function BlacklistCell:InitShow()

	self:SetEvent(self.headIcon.clickObj.gameObject, function ()
		self:PassEvent(BlacklistEvent.SelectHead, self)
	end)

	self.EmptyGuild.text = ZhString.Friend_EmptyGuild
end

function BlacklistCell:SetData(data)
	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data then
		local config = Table_Class[data.profession]
		if config then
			IconManager:SetProfessionIcon(config.icon, self.Profession)

			local iconColor = ColorUtil["CareerIconBg"..config.Type]
			if(iconColor==nil) then
				iconColor = ColorUtil.CareerIconBg0
			end
			self.professIconBG.color = iconColor
		end
		self.Level.text = "Lv."..data.level

		local headData = Table_HeadImage[data.portrait]
		if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
			self.headIcon:SetSimpleIcon(headData.Picture)
		else
			self.headIcon:SetData(data)
		end

		if data.gender == ProtoCommon_pb.EGENDER_MALE then
			self.GenderIcon.CurrentState = 0
		elseif data.gender == ProtoCommon_pb.EGENDER_FEMALE then
			self.GenderIcon.CurrentState = 1	
		end
		self.GenderIcon:MakePixelPerfect()

		self.Name.text = data.name
	----[[ todo xde 不翻译玩家名字
		self.Name.text = AppendSpace2Str(data.name)
		--]]

		if data.guildname ~= "" then
			self:SetGuild(true)
			self.GuildName.text = data.guildname

			local guildportrait = tonumber(data.guildportrait) or 1
			guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
			IconManager:SetGuildIcon(guildportrait , self.GuildIcon)
		else
			self:SetGuild(false)
		end

		if data.offlinetime == 0 then
			self.Mask:SetActive(false)
			self.headIcon:SetActive(true,true)
		else
			self.Mask:SetActive(true)
			self.headIcon:SetActive(false,true)
		end

		if data:IsForeverBlack() then
			self.Time.text = ZhString.Blacklist_Forever
		else
			local leftTime = ServerTime.CurServerTime()/1000 - data:GetCreatetime(SocialManager.SocialRelation.Black)
			local Day, Hour, Min, Sec
			if leftTime > 0 then
				Day, Hour, Min, Sec = ClientTimeUtil.FormatTimeBySec( leftTime )
			end

			if Day then
				local leftDay = GameConfig.Social.BlackListRemoveTime - Day
				if leftDay > 0 then
					self.Time.text = string.format(ZhString.Blacklist_Time , leftDay)
				else
					self.Time.text = ""
				end
			end
		end
	end
end

function BlacklistCell:SetGuild(isActive)
	self.EmptyGuild.gameObject:SetActive(not isActive)
	self.GuildIcon.gameObject:SetActive(isActive)
	self.GuildName.gameObject:SetActive(isActive)
end