local BaseCell = autoImport("BaseCell");

GvGPvpAttrCell = class("GvGPvpAttrCell", BaseCell);

function GvGPvpAttrCell:Init()
	self.name = self:FindComponent("nameLab", UILabel);
	self.attr = self:FindComponent("attrLab", UILabel);
	self.bg = self:FindComponent("bg",UISprite);
	self.bgline = self:FindComponent("bgline",UISprite);
end

function GvGPvpAttrCell:SetData(data)
	if(data)then
		self.name.text = data[1]
		self.attr.text = string.format("+%s",data[2]);
		local t = data[3]
		if(t and t>0)then
			local colorID = GameConfig.GvGPvP_PrayType[t].colorID
			local colorCfg = Table_GFaithUIColorConfig[colorID]
			if(colorCfg)then
				local hasc, rc = ColorUtil.TryParseHexString(colorCfg.bg_Color)
				self.bg.color = rc
				local hasc, rc = ColorUtil.TryParseHexString(colorCfg.bgline_Color)
				self.bgline.color = rc
			end
		end
	end
end