autoImport("BaseTip")
TutorFindTip = class("TutorFindTip", BaseTip)

local ImportCell = "SocialBaseCell"
local StudentTipColor = Color(255/255, 239/255, 162/255, 1)
local TutorTipColor = Color(208/255, 232/255, 253/255, 1)
local StudentTipLabelColor = Color(179/255, 107/255, 36/255, 1)
local TutorTipLabelColor = Color(31/255, 116/255, 191/255, 1)

function TutorFindTip:OnEnter()
	TutorFindTip.super.OnEnter(self)

	self.gameObject:SetActive(true)
end

function TutorFindTip:Init()
	if _G[ImportCell] == nil then
		autoImport(ImportCell)
	end

	self:FindObjs()
	self:AddEvts()
	self:InitShow()
end

function TutorFindTip:FindObjs()
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
	self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
	self.emptyGuild = self:FindGO("EmptyGuild"):GetComponent(UILabel)
	self.tip = self:FindGO("Tip"):GetComponent(UISprite)
	self.tipLabel = self:FindGO("Label", self.tip.gameObject):GetComponent(UILabel)
	self.confirmBtn = self:FindGO("ConfirmBtn")
	self.confirmLabel = self:FindGO("Label", self.confirmBtn):GetComponent(UILabel)
end

function TutorFindTip:AddEvts()
	self.closecomp.callBack = function (go)
		self:CloseSelf()
	end

	self:AddClickEvent(self.confirmBtn, function ()
		self:Confirm()
	end)
end

function TutorFindTip:InitShow()
	local cell = self:FindGO("Cell")
	self.socialCell = SocialBaseCell.new(cell)

	self.socialData = SocialData.CreateAsTable()
end

function TutorFindTip:SetData(data)
	TutorFindTip.super.SetData(self, data)

	if data then
		local chatData = data.data
		self.charguid = chatData:GetId()
		self.tutorType = tonumber(data.url)
	
		self.socialData:SetDataByChatMessageData(self.charguid, chatData)
		self.socialCell:SetData(self.socialData)

		--设置公会
		if self.socialData.guildname ~= "" then
			self:SetGuild(true)
			self.guildName.text = self.socialData.guildname

			local guildportrait = tonumber(self.socialData.guildportrait) or 1
			guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
			IconManager:SetGuildIcon(guildportrait , self.guildIcon)
		else
			self:SetGuild(false)
		end

		if self.tutorType == TutorType.Tutor then
			self.title.text = ZhString.Tutor_Chat_FindTutor
			self.tip.color = TutorTipColor
			self.tipLabel.color = TutorTipLabelColor
			self.tipLabel.text = ZhString.Tutor_FindingTutor
			self.confirmLabel.text = ZhString.FunctionPlayerTip_Tutor_Student

		elseif self.tutorType == TutorType.Student then
			self.title.text = ZhString.Tutor_Chat_FindStudent
			self.tip.color = StudentTipColor
			self.tipLabel.color = StudentTipLabelColor
			self.tipLabel.text = ZhString.Tutor_FindingStudent
			self.confirmLabel.text = ZhString.FunctionPlayerTip_Tutor_Tutor

		end
	end
end

function TutorFindTip:SetGuild(isActive)
	self.emptyGuild.gameObject:SetActive(not isActive)
	self.guildIcon.gameObject:SetActive(isActive)
	self.guildName.gameObject:SetActive(isActive)
end

function TutorFindTip:Confirm()
	if self.tutorType ~= nil then
		if self.charguid == Game.Myself.data.id then
			MsgManager.ShowMsgByID(3233)
			return
		end

		if self.tutorType == TutorType.Tutor then
			TutorProxy.Instance:CallAddTutor(self.charguid)
		elseif self.tutorType == TutorType.Student then
			TutorProxy.Instance:CallAddStudent(self.charguid)
		end

		self:CloseSelf()
	end
end

function TutorFindTip:DestroySelf()
	GameObject.Destroy(self.gameObject)	
end

function TutorFindTip:CloseSelf()
	TipsView.Me():HideCurrent()
end