GvgFinalSectionCell = class("GvgFinalSectionCell",BaseCell)

local tempVector3 = LuaVector3.zero
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull

function GvgFinalSectionCell:Init()
	self:initView()
	self:initData()
end

function GvgFinalSectionCell:initView()
	self.desLabel = self:FindComponent("desLabel",UILabel)
	self.ownerName = self:FindComponent("ownerName",UILabel)
	self.guildGreen = self:FindComponent("guildGreen",UISprite)
	self.guildPurple = self:FindComponent("guildPurple",UISprite)
	self.guildRed = self:FindComponent("guildRed",UISprite)
	self.guildBlue = self:FindComponent("guildBlue",UISprite)
end

function GvgFinalSectionCell:initData()
	self.lastWidth = 0
end


function GvgFinalSectionCell:SetData(data)
	self.guildGreen.gameObject:SetActive(false)
	self.guildPurple.gameObject:SetActive(false)
	self.guildRed.gameObject:SetActive(false)
	self.guildBlue.gameObject:SetActive(false)
	self.lastWidth = 0
	self.data = data
	local twCf = GvgFinalFightTip.EGvgTowerType[data.etype]
	if(twCf)then
		self.desLabel.text = twCf.name
		local guildInfo = SuperGvgProxy.Instance:GetGuildInfoByGuildId(data.owner_guild)
		if(guildInfo) then
			self.ownerName.text = "归属方: " .. guildInfo.guildname
		else
			self.ownerName.text = ZhString.GvgTowerStateNeutral
		end
		self.lastWidth = 0
		local infos = data.infos
		for i=1,#infos do
			self:SetPerGuildProgress(infos[i],twCf.totalValue)
		end
	end
end

function GvgFinalSectionCell:SetPerGuildProgress(data,totalValue)
	--根据当前工会占领值和总值关系设置每个sp位置和长度
	if(not data)then
		return
	end
	local curValue = data.value
	local guildid = data.guildid
	local index =  SuperGvgProxy.Instance:GetIndexByGuildId(guildid)
	local config = GvgFinalFightTip.GuildIndex[index]
	if(config)then
		local name = string.format("guild%s",config.colorName)
		local spName = self[name]
		if(spName)then
			spName.gameObject:SetActive(true)
			spName.width = GvgFinalFightTip.totalCaptureLen*(curValue/totalValue)
			spName.transform.localPosition = LuaVector3(self.lastWidth,0,0)
			self.lastWidth = spName.width + self.lastWidth
		end
	end
end