-- errorLog
local baseCell = autoImport("BaseCell")
ChatNameCell = class("ChatNameCell",baseCell)

function ChatNameCell:Init()
	self:FindObjs()
	self:InitShow()
	self:AddCellClickEvent()
end

function ChatNameCell:FindObjs()
	-- self.bg = self:FindGO("Bg"):GetComponent(UISprite)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.unreadCount = self:FindGO("UnreadCount"):GetComponent(UILabel)
	self.chooseBg = self:FindGO("ChooseBg")
	self.chooseBgFirst = self:FindGO("ChooseBgFirst")
	self.chatZoneOwner = self:FindGO("ChatZoneOwner")
end

function ChatNameCell:InitShow()
	local color = { Default = "FFFFFF" , Toggle = "6a9af6" , Offline = "6c6c6c" }
 	local hasC = nil
	hasC , self.defaultResultC = ColorUtil.TryParseHexString(color.Default)
	hasC , self.toggleResultC = ColorUtil.TryParseHexString(color.Toggle)
	hasC , self.offlineResultC = ColorUtil.TryParseHexString(color.Offline)
end

function ChatNameCell:SetData(data)

	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data ~= nil then

		-- if data.offlinetime == 0 then
		-- 	-- self.bg.color = Color(1,1,1,1)
		-- 	self.name.color = self.defaultResultC
		-- else
		-- 	-- self:SetTextureGrey( self.bg.gameObject )
		-- 	self.name.color = self.offlineResultC
		-- end

		self.name.text = data.name
		UIUtil.WrapLabel(self.name)

		if data.unreadCount ~= nil and data.unreadCount > 0 then
			self.unreadCount.gameObject:SetActive(true)
			if data.unreadCount <= 9 then
				self.unreadCount.text = data.unreadCount
			else
				self.unreadCount.text = "N"
			end
		else
			self.unreadCount.gameObject:SetActive(false)
		end

		if data.isChoose then
			if data.offlinetime == 0 then
				self.name.color = self.toggleResultC
			else
				self.name.color = self.offlineResultC
			end
			if data.isFirst then
				self:SetFirstChoose(true)
			else
				self:SetFirstChoose(false)
			end
		else
			if data.offlinetime == 0 then
				self.name.color = self.defaultResultC
			else
				self.name.color = self.offlineResultC
			end
			self:SetChooseBg(false)
		end

		if data.owner then
			self.chatZoneOwner:SetActive(true)
		else
			self.chatZoneOwner:SetActive(false)
		end
	end
end

function ChatNameCell:SetChooseBg(isActive)
	self.chooseBg:SetActive(isActive)
	self.chooseBgFirst:SetActive(isActive)
end

function ChatNameCell:SetFirstChoose(isFirst)
	self.chooseBgFirst:SetActive(isFirst)
	self.chooseBg:SetActive(not isFirst)
end