local BaseCell = autoImport("BaseCell")
MainViewAuctionCell = class("MainViewAuctionCell", BaseCell)

function MainViewAuctionCell:Init()
	self:InitUI()
end

function MainViewAuctionCell:InitUI()
	self.sprite = self:FindComponent("Sprite", UISprite)
	self.label = self:FindComponent("Label", UILabel)

	self:AddCellClickEvent()
end

function MainViewAuctionCell:SetData(data)
	self.data = data;

	local sData = self.data.staticData;

	if not self.isRegisterAuctionRed then
		RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_AUCTION_RECORD, self.sprite, 10, {-7,-7})
		self.isRegisterAuctionRed = true
	end

	self.label.text = data.Name
end

function MainViewAuctionCell:UpdateAuction(totalSec, min, sec)
	if self.data then 
		if totalSec ~= nil and min ~= nil then
			self.label.text = string.format(self.data.Name, min, sec)
		end
	end
end