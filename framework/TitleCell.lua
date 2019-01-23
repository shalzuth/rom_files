local BaseCell = autoImport("BaseCell");
TitleCell = class("TitleCell", BaseCell);
local choosen = "com_bg_money3"
local unChoosen = "com_bg_property"

local grayLabel= Color(128.0/255.0,128.0/255.0,128.0/255.0,1)	-- 未解锁的
local blackLabel = Color(45.0/255.0,45.0/255.0,45.0/255.0,1)	-- 解锁的
local usingLabel = Color(31.0/255.0,116.0/255.0,191.0/255.0,1) -- 正在使用的

local choosenLabelColor = "[1F74BF]"
local lockBtnSpriteName="com_bg_13"
local unlockBtnSpriteName = "com_bg_2"

function TitleCell:Init()
	TitleCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function TitleCell:FindObjs()
	self.bgImg = self:FindComponent("bg",UISprite);
	self.titleName = self:FindComponent("title",UILabel);
	self.choosenBg=self:FindGO("chooseBg")
end

function TitleCell:ShowChooseImg(flag)
	self.bgImg.spriteName = flag and choosen or unChoosen
end

function TitleCell:SetData(data)
	if(data.__cname=="TitleLevelGroupData")then
		self.data=data.activeTitleData
	else
		self.data=data
	end
	-- self.data=data
	self.id=self.data.id
	self.unlocked=self.data.unlocked
	self.type=self.data.titleType

	local name = self.data.config.Name
	self.titleName.text=name
	self:SetUnlockState()
	self:UpdateChoose()
end


function TitleCell:SetChoose(chooseId)
	self.chooseId=chooseId
	self:UpdateChoose()
end

function TitleCell:UpdateChoose()
	if(self.id and self.id==self.chooseId)then
		self.choosenBg:SetActive(true)
	else
		self.choosenBg:SetActive(false)
	end
end

function TitleCell:SetUnlockState()
	local curID = Game.Myself.data:GetAchievementtitle()
	if(curID==self.id and self.unlocked)then
		self.titleName.color=usingLabel
	elseif(self.unlocked)then
		self.titleName.color=blackLabel
	else
		self.titleName.color=grayLabel
	end
end



