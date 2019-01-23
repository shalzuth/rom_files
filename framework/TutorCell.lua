autoImport("FriendBaseCell")

local baseCell = autoImport("BaseCell")
TutorCell = class("TutorCell", FriendBaseCell)

function TutorCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
	self:InitShow()
end

function TutorCell:FindObjs()
	TutorCell.super.FindObjs(self)

	self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
	self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
	self.emptyGuild = self:FindGO("EmptyGuild")

	self.proficiency = self:FindGO("Proficiency")
	if self.proficiency then
		self.proficiency = self.proficiency:GetComponent(UILabel)
	end

	self.taskDetail = self:FindGO("TaskDetail")
end

function TutorCell:AddButtonEvt()
	if self.taskDetail ~= nil then
		self:AddClickEvent(self.taskDetail, function ()
			self:TaskDetail()
		end)
	end	
end

function TutorCell:SetData(data)
	TutorCell.super.SetData(self, data)

	if data then
		if data.guildname ~= "" then
			self:SetGuild(true)
			self.guildName.text = data.guildname

			local guildportrait = tonumber(data.guildportrait) or 1
			guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
			IconManager:SetGuildIcon(guildportrait , self.guildIcon)
		else
			self:SetGuild(false)
		end

		if self.proficiency ~= nil then
			local proficiency = data.profic or 0
			self.proficiency.text = string.format(ZhString.Tutor_TaskProficiency, TutorProxy.Instance:GetProficiency(proficiency))
		end

		if self.taskDetail ~= nil then
			local ERedSys = SceneTip_pb.EREDSYS_TUTOR_TASK
			local _RedTipProxy = RedTipProxy.Instance
			local isNew = _RedTipProxy:IsNew(ERedSys, data.guid)
			if isNew then
				_RedTipProxy:RegisterUI(ERedSys, self.taskDetail, 8, {0,0})
			else
				_RedTipProxy:UnRegisterUI(ERedSys, self.taskDetail)
			end
		end
	end
end

function TutorCell:SetGuild(isActive)
	self.emptyGuild:SetActive(not isActive)
	self.guildIcon.gameObject:SetActive(isActive)
	self.guildName.gameObject:SetActive(isActive)
end

function TutorCell:TaskDetail()
	if self.data then
		local proficiency = self.data.profic or 0
		proficiency = TutorProxy.Instance:GetProficiency(proficiency)

		if proficiency < 100 then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorTaskView, viewdata = self.data.guid})
		else
			MsgManager.ShowMsgByID(3246)
		end

		RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TUTOR_TASK, self.data.guid)
	end
end