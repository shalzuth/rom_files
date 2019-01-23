autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
SkyWheelFriendCell = class("SkyWheelFriendCell", baseCell)

function SkyWheelFriendCell:Init()
	self:FindObjs()
	self:InitShow()
end

function SkyWheelFriendCell:FindObjs()

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
	self.FriendName = self:FindGO("FriendName"):GetComponent(UILabel)
	self.GenderIcon = self:FindGO("GenderIcon"):GetComponent(UISprite)
	self.GuildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
	self.GuildName = self:FindGO("GuildName"):GetComponent(UILabel)
	self.EmptyGuild = self:FindGO("EmptyGuild"):GetComponent(UILabel)
	self.selectBtn = self:FindGO("SelectBtn"):GetComponent(UISprite)
	self.selectLabel = self:FindGO("Label" , self.selectBtn.gameObject):GetComponent(UILabel)
end

function SkyWheelFriendCell:InitShow()

	self:SetEvent(self.selectBtn.gameObject, function ()
		if self.data.offlinetime ~= 0 then
			MsgManager.ShowMsgByID(864)
			return
		end

		if self.data.zoneid ~= MyselfProxy.Instance:GetZoneId() then
			MsgManager.ShowMsgByID(3607)
			return
		end

		self:PassEvent(SkyWheel.Select, self)
	end)

	self.EmptyGuild.text = ZhString.Friend_EmptyGuild
end

function SkyWheelFriendCell:SetData(data)
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

		self.FriendName.text = data.name

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

		if data.offlinetime == 0 and data.zoneid == MyselfProxy.Instance:GetZoneId() then
			self.selectBtn.color = ColorUtil.NGUIWhite
			self.selectLabel.effectColor = ColorUtil.ButtonLabelBlue
		else
			self.selectBtn.color = ColorUtil.NGUIShaderGray
			self.selectLabel.effectColor = ColorUtil.NGUIGray
		end
	end
end

function SkyWheelFriendCell:SetGuild(isActive)
	self.EmptyGuild.gameObject:SetActive(not isActive)
	self.GuildIcon.gameObject:SetActive(isActive)
	self.GuildName.gameObject:SetActive(isActive)
end