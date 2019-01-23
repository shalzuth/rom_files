local baseCell = autoImport("BaseCell")
DojoGroupCell = class("DojoGroupCell", baseCell)

function DojoGroupCell:Init()
	self:FindObjs()

	self:AddCellClickEvent()
end

function DojoGroupCell:FindObjs()
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.des = self:FindGO("Des"):GetComponent(UILabel)
	self.lock = self:FindGO("Lock")
	self.lockTip = self:FindGO("LockTip"):GetComponent(UILabel)
	self.icon = self:FindComponent("Icon", UITexture)
	self.bottom1 = self:FindGO("bottom1"):GetComponent(UISprite)
	self.bottom2 = self:FindGO("bottom2"):GetComponent(UISprite)
	self.bottom3 = self:FindGO("bottom3"):GetComponent(UISprite)

	OverseaHostHelper:FixLabelOverV1(self.des,3,220)
end

function DojoGroupCell:SetData(data)
	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data then
		self.name.text = data.DojoName
		self.des.text = data.Text
		
		-- self.canOpen = FunctionUnLockFunc.Me():CheckCanOpen(tonumber(data.MenuId))
		self.canOpen = DojoProxy.Instance:CheckCanOpenGroup(data.DojoGroupId)
		if self.canOpen then
			self.lock:SetActive(false)
		else
			self.lock:SetActive(true)

			local guildInfo = DojoProxy.Instance:GetGuildDataByGroupId(data.DojoGroupId)
			if guildInfo then
				for i=1,#guildInfo do
					local guild = Table_Guild[guildInfo[i]]
					if guild then
						self.lockTip.text = guild.DojoTxt
					end
				end
			end
		end

		-- local menu = Table_Menu[tonumber(data.MenuId)]
		-- if menu then
		-- 	self.lockTip.text = menu.text
		-- else
		-- 	errorLog(string.format("DojoGroupCell SetData : Table_Menu[%s] == nil",data.MenuId))
		-- end

		local colorData = GameConfig.GuildDojo.BackImage[data.BackImage]
		self:SetSpriteColor(colorData.outerglow , self.bottom1)
		self:SetSpriteColor(colorData.backcolour , self.bottom2)
		self:SetSpriteColor(colorData.lightcolour , self.bottom3)

		PictureManager.Instance:SetUI(colorData.inmage, self.icon)
	end
end

function DojoGroupCell:SetSpriteColor(color,sprite)
	local hasC, resultC = ColorUtil.TryParseHexString(color)
	if(hasC)then
		sprite.color = resultC
	end	
end