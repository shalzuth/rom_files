autoImport("GvgFinalRankCell")
GvgFinalMapRankCell = class("GvgFinalMapRankCell",GvgFinalRankCell)
function GvgFinalMapRankCell:initView()
	GvgFinalMapRankCell.super.initView(self)

	-- self.invalidCt = self:FindGO("invalidCt")
	self.guildGreen = self:FindComponent("guildGreen",UISprite)
	self.guildPurple = self:FindComponent("guildPurple",UISprite)
	self.guildRed = self:FindComponent("guildRed",UISprite)
	self.guildBlue = self:FindComponent("guildBlue",UISprite)
	
	self.pieceIcon = self:FindComponent("pieceSp", UISprite)
	self.pieceNum = self:FindComponent("pieceNum",UILabel)
	-- self.default = self:FindGO("default")
	-- self.progress = self:FindComponent("progress",UISlider)
end

function GvgFinalMapRankCell:initData()

end


function GvgFinalMapRankCell:SetData(data)
	self.data = data
	GvgFinalMapRankCell.super.SetData(self,data)
	self.pieceNum.text = tostring(data.crystalData.chipnum or 0) .. "/4"
	IconManager:SetItemIcon("item_700104", self.pieceIcon)
end