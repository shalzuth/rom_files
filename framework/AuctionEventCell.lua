local baseCell = autoImport("BaseCell")
AuctionEventCell = class("AuctionEventCell", baseCell)

local pos = LuaVector3.zero

function AuctionEventCell:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitShow()
end

function AuctionEventCell:FindObjs()
	self.time = self:FindGO("Time"):GetComponent(UILabel)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.clickUrl = self.content.gameObject:GetComponent(UILabelClickUrl)
	self.root = self:FindGO("Root")
end

function AuctionEventCell:AddEvts()
	self.clickUrl.callback = function (url)
		if url ~= nil and self.data ~= nil then
			ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.data.playerid)
		end
	end
end

function AuctionEventCell:InitShow()
	self.contentOriginalHight = 34
	self.contentOffset = 17

	pos:Set(LuaGameObject.GetLocalPosition(self.root.transform))
end

function AuctionEventCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data then
		self.time.text = data:GetTimeString()
		self.content.text = data:GetContent()

		local sizeY = self.content.localSize.y
		local rate = sizeY / self.contentOriginalHight
		pos:Set(pos.x, self.contentOffset * (rate - 1), pos.z)
		self.root.transform.localPosition = pos
	end
end