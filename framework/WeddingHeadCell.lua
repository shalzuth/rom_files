autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
WeddingHeadCell = class("WeddingHeadCell", baseCell)

function WeddingHeadCell:Init()
	self:FindObjs()
	self:InitShow()
end

function WeddingHeadCell:FindObjs()
	self.headIcon = HeadIconCell.new()
	self.headIcon:CreateSelf(self.gameObject)
	self.headIcon:SetScale(0.68)
	self.headIcon:SetMinDepth(1)

	local profession = self:FindGO("Profession")
	self.professionColor = self:FindGO("Color", profession):GetComponent(UISprite)
	self.professionIcon = self:FindGO("Icon", profession):GetComponent(UISprite)

	self.name = self:FindGO("Name"):GetComponent(UILabel)
end

function WeddingHeadCell:InitShow()
	self:SetEvent(self.headIcon.clickObj.gameObject, function ()
		self:PassEvent(MouseEvent.MouseClick, self)
	end)
end

function WeddingHeadCell:SetData(data)
	self.data = data

	if data then
		local config = Table_Class[data.profession]
		if config then
			IconManager:SetProfessionIcon(config.icon, self.professionIcon)

			local iconColor = ColorUtil["CareerIconBg"..config.Type]
			if iconColor == nil then
				iconColor = ColorUtil.CareerIconBg0
			end
			self.professionColor.color = iconColor
		end

		local headData = Table_HeadImage[data.portrait]
		if data.portrait and data.portrait ~= 0 and headData and headData.Picture then
			self.headIcon:SetSimpleIcon(headData.Picture)
		else
			self.headIcon:SetData(data)
		end

		self.name.text = data.name
	end
end