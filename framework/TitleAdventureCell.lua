autoImport("TitleCell");
TitleAdventureCell = class("TitleAdventureCell", TitleCell);

local grayLabel= Color(128.0/255.0,128.0/255.0,128.0/255.0,1)	-- 未解锁的
local blackLabel = Color(45.0/255.0,45.0/255.0,45.0/255.0,1)	-- 解锁的
local usingLabel = Color(31.0/255.0,116.0/255.0,191.0/255.0,1) -- 正在使用的

function TitleAdventureCell:FindObjs()
	TitleAdventureCell.super.FindObjs(self)
	self.attr=self:FindComponent("attr",UILabel)
end

function TitleAdventureCell:SetData(data)
	TitleAdventureCell.super.SetData(self,data)
	local staticData = Table_Appellation[self.id]
	if(not staticData) then return end 
	local prop = staticData.BaseProp
	local propDesc
	for k,v in pairs(prop) do
		if(propDesc)then
			propDesc = propDesc .. " , ".. tostring(k).."+"..tostring(v)
		else
			propDesc = tostring(k).."+"..tostring(v)
		end
	end
	local curID = Game.Myself.data:GetAchievementtitle()
	if(curID==self.id and self.unlocked)then
		self.attr.color=usingLabel
	elseif(self.unlocked)then
		self.attr.color=blackLabel
	else
		self.attr.color=grayLabel
	end
	self.attr.text=propDesc
end

-- function TitleAdventureCell:SetUnlockState()
-- 	local curID = Game.Myself.data:GetAchievementtitle()
-- 	if(curID==self.id and self.unlocked)then
-- 		self.titleName.color=usingLabel
-- 	elseif(self.unlocked)then
-- 		self.titleName.color=blackLabel
-- 	else
-- 		self.titleName.color=grayLabel
-- 	end
-- end



