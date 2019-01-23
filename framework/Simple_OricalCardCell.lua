local BaseCell = autoImport("BaseCell");
Simple_OricalCardCell = class("Simple_OricalCardCell", BaseCell);

autoImport("ItemCardCell")

local Frame_ColorMap = {
	Environment = "660c0c",
	Item = "ff86c3",
	Monster = "3e55a6",
	Boss = "ff863d",
}

function Simple_OricalCardCell:Init()
	self.content = self:FindGO("Content");

	self.bg = self:FindComponent("Bg", UISprite);
	self.fg = self:FindComponent("Fg", UISprite);
	self.icon = self:FindComponent("Icon", UISprite);

	self:AddCellClickEvent();
end

function Simple_OricalCardCell:SetData(data)
	self.data = data;

	if(type(data) ~= "table")then
		self.content:SetActive(false);
		return;
	end

	self.content:SetActive(true);

	local t = data.Type;
	if(t and Frame_ColorMap[t] ~= nil)then
		local hasc, rc = ColorUtil.TryParseHexString(Frame_ColorMap[t])
		if(hasc)then
			self.fg.color = rc;
		end
	end

	local headIcon = data.HeadIcon;
	if(headIcon == nil or headIcon == "")then
		local monsterId = data.MonsterID;
		local monsterData = Table_Monster[ monsterId ];
		headIcon = monsterData and monsterData.Icon;
	end
	if(headIcon)then
		IconManager:SetFaceIcon(headIcon, self.icon);
	end
end

function Simple_OricalCardCell:HideContent()
	self.content:SetActive(false);
end

