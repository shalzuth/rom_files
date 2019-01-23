local BaseCell = autoImport("BaseCell");
PetWorkSpaceEmoji = class("PetWorkSpaceEmoji", BaseCell);
local strFormat = "x%s"
local petRestIcon = "pet_icon_zz"
local IconSize = 
{
	reward = {96,93},
	rest = {58,56},
}
function PetWorkSpaceEmoji:ctor(go)
	PetWorkSpaceEmoji.super.ctor(self, go);
end

function PetWorkSpaceEmoji:Init()
	self:FindObj();
end

function PetWorkSpaceEmoji:FindObj()
	self.bg = self:FindGO("pic_biaoqingbg")
	self.icon = self:FindComponent("pic_biaoqinggif", UISprite);
	self.num = self:FindComponent("num",UILabel)
	self.rest = self:FindGO("rest")
	self:AddCellClickEvent()
end

local tempVector3 = LuaVector3.zero
function PetWorkSpaceEmoji:SetData(data)
	if(not self.gameObject)then
		return;
	end
	self.data = data
	if(data)then
		self.gameObject:SetActive(true);
		if(type(data)=='table')then
			local icon = Table_Item[data.id].Icon
			IconManager:SetItemIcon(icon, self.icon);
			self.num.text = string.format(strFormat,data.num)
			tempVector3:Set(8,0,0)
			self:Show(self.icon)
			self:Hide(self.rest)
		elseif (data=='rest')then
			tempVector3:Set(0,0,0)
			self:Hide(self.icon)
			self:Show(self.rest)
		end
		self.bg.transform.localPosition = tempVector3
		self.bg:SetActive(false)
		self.bg:SetActive(true)
	else
		self.gameObject:SetActive(false);
	end
end

