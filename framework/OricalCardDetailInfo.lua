local BaseCell = autoImport("BaseCell");
OricalCardDetailInfo = class("OricalCardDetailInfo", BaseCell);

local Frame2Bg_QualityMap = 
{
	Environment = "fb_bg_weather",
	Item = "fb_bg_prop",
	Monster = "fb_bg_monster",
	Boss = "fb_bg_boss",
}

local Frame_ColorMap = {
	Environment = "660c0c",
	Item = "ff86c3",
	Monster = "3e55a6",
	Boss = "ff863d",
}

function OricalCardDetailInfo:Init()
	self.bg = self:FindComponent("Bg", UISprite);
	self.frame = self:FindComponent("Frame", UISprite);
	self.frame2Bg = self:FindComponent("Frame2Bg", UISprite);
	self.desc = self:FindComponent("Desc", UILabel);

	self.icon = self:FindComponent("Icon", UITexture);

	self.collider = self:FindGO("Collider");
	self:AddClickEvent(self.collider, function (go)
		self:Hide();
	end);
end

function OricalCardDetailInfo:SetData(data)
	if(data == nil)then
		return;
	end

	local t = data.Type;
	if(t and Frame_ColorMap[t] ~= nil)then
		local hasc, rc = ColorUtil.TryParseHexString(Frame_ColorMap[t])
		if(hasc)then
			self.frame.color = rc;
		end
	end
	self.frame2Bg.spriteName = Frame2Bg_QualityMap[t];
	self.desc.text = data.Message;

	if(self.lastCard)then

	end
	self:Unload_OldIconPic();

	PictureManager.Instance:SetCard(data.Resource, self.icon);
	self.oldCardPic = data.Resource;
end

function OricalCardDetailInfo:Unload_OldIconPic()
	if(self.oldCardPic)then
		PictureManager.Instance:UnLoadCard(self.oldCardPic, self.icon)
	end
	self.oldCardPic = nil;
end
