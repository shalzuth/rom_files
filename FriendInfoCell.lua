autoImport("FriendBaseCell")

local baseCell = autoImport("BaseCell")
FriendInfoCell = class("FriendInfoCell", FriendBaseCell)

function FriendInfoCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
	self:InitShow()
end

function FriendInfoCell:FindObjs()
	FriendInfoCell.super.FindObjs(self)

	self.GuildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
	self.GuildName = self:FindGO("GuildName"):GetComponent(UILabel)
	self.EmptyGuild = self:FindGO("EmptyGuild"):GetComponent(UILabel)
	self.recallBtn = self:FindGO("RecallBtn"):GetComponent(UISprite)
end

function FriendInfoCell:AddButtonEvt()
	self:AddClickEvent(self.recallBtn.gameObject,function ()
		self:Recall()
	end)	
end

function FriendInfoCell:InitShow()
	FriendInfoCell.super.InitShow(self)

	self.EmptyGuild.text = ZhString.Friend_EmptyGuild
end

function FriendInfoCell:SetData(data)
	FriendInfoCell.super.SetData(self, data)

	if data then
		if data.guildname ~= "" then
			self:SetGuild(true)
			self.GuildName.text = data.guildname
			----[[ todo xde ?????????????????????
			self.GuildName.text = AppendSpace2Str(data.guildname)
			--]]

			local guildportrait = tonumber(data.guildportrait) or 1
			guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
			IconManager:SetGuildIcon(guildportrait , self.GuildIcon)
		else
			self:SetGuild(false)
		end

		local canRecall = data:CheckCanRecall()
		self.recallBtn.gameObject:SetActive(canRecall)
		if canRecall then
			self:SetRecall(data.recall)
		end
	end
end

function FriendInfoCell:SetGuild(isActive)
	self.EmptyGuild.gameObject:SetActive(not isActive)
	self.GuildIcon.gameObject:SetActive(isActive)
	self.GuildName.gameObject:SetActive(isActive)
end

function FriendInfoCell:SetRecall(bRecall)
	if bRecall then
		ColorUtil.DeepGrayUIWidget(self.recallBtn)
	else
		ColorUtil.WhiteUIWidget(self.recallBtn)
	end
end

function FriendInfoCell:Recall()
	if self.data ~= nil then
		if self.data.recall then
			MsgManager.ShowMsgByID(3620)
			return
		end

		if #FriendProxy.Instance:GetContractData() > GameConfig.Recall.max_recall_count then
			MsgManager.ConfirmMsgByID(3621, function ()
				self:JumpShareView()
			end)
		else
			self:JumpShareView()
		end
	end
end

function FriendInfoCell:JumpShareView()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.RecallShareView, viewdata = self.data})
end