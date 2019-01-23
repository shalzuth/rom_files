local baseCell = autoImport("BaseCell")
WeddingInviteCell = class("WeddingInviteCell", baseCell)

function WeddingInviteCell:Init()
	self:FindObjs()
	self:InitShow()
end

function WeddingInviteCell:FindObjs()
	local headContainer = self:FindGO("HeadContainer")
	self.headIcon = HeadIconCell.new()
	self.headIcon:CreateSelf(headContainer)
	self.headIcon.gameObject:AddComponent(UIDragScrollView)
	self.headIcon:SetScale(0.68)
	self.headIcon:SetMinDepth(1)

	self.profession = self:FindGO("Profession"):GetComponent(UISprite)
	self.professionColor = self:FindGO("Color", self.profession.gameObject):GetComponent(UISprite)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.level = self:FindGO("Level"):GetComponent(UILabel)
	self.professionName = self:FindGO("ProfessionName"):GetComponent(UILabel)
	self.invited = self:FindGO("Invited")
	self.inviteBtn = self:FindGO("InviteBtn"):GetComponent(UIMultiSprite)
	self.inviteBtnLabel = self:FindGO("Label", self.inviteBtn.gameObject):GetComponent(UILabel)
end

function WeddingInviteCell:InitShow()
	self:AddClickEvent(self.inviteBtn.gameObject, function ()
		if self.data ~= nil and not self.data.isInvited then
			local temp = ReusableTable.CreateArray()
			temp[1] = self.data.guid
			WeddingProxy.Instance:CallWeddingInviteCCmd(temp)
			ReusableTable.DestroyArray(temp)
		end
	end)

	self:SetEvent(self.headIcon.clickObj.gameObject, function ()
		self:PassEvent(WeddingEvent.Select, self)
	end)
end

function WeddingInviteCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		local sb = LuaStringBuilder.CreateAsTable()
		local config = Table_Class[data.profession]
		if config then
			IconManager:SetProfessionIcon(config.icon, self.profession)

			sb:Append("CareerIconBg")
			sb:Append(config.Type)
			local iconColor = ColorUtil[sb:ToString()]
			if iconColor == nil then
				iconColor = ColorUtil.CareerIconBg0
			end
			self.professionColor.color = iconColor

			self.professionName.text = config.NameZh
		end

		local headData = Table_HeadImage[data.portrait]
		if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
			self.headIcon:SetSimpleIcon(headData.Picture)
		else
			self.headIcon:SetData(data)
		end

		self.name.text = data.name

		sb:Clear()
		sb:Append("Lv. ")
		sb:Append(data.level)
		self.level.text = sb:ToString()
		sb:Destroy()

		self.invited:SetActive(data.isInvited == true)
		if data.isInvited then
			self.inviteBtn.CurrentState = 1
			self.inviteBtnLabel.effectStyle = UILabel.Effect.None
		else
			self.inviteBtn.CurrentState = 0
			self.inviteBtnLabel.effectStyle = UILabel.Effect.Outline
		end
	end
end