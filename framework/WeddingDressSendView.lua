WeddingDressSendView = class("WeddingDressSendView",ContainerView)

WeddingDressSendView.ViewType = UIViewType.NormalLayer

local backgroundName = "marry_bg_process"
local _PictureManager = PictureManager.Instance

function WeddingDressSendView:OnExit()
	_PictureManager:UnLoadWedding(backgroundName, self.backgroundL)
	_PictureManager:UnLoadWedding(backgroundName, self.backgroundR)
	WeddingDressSendView.super.OnExit(self)
end

function WeddingDressSendView:Init()
	self:FindObj()
	self:AddButtonEvt()
	self:AddViewEvt()
	self:InitShow()
end

function WeddingDressSendView:FindObj()
	self.backgroundL = self:FindGO("BackgroundL"):GetComponent(UITexture)
	self.backgroundR = self:FindGO("BackgroundR"):GetComponent(UITexture)
	self.content = self:FindGO("Content"):GetComponent(UIInput)
	self.name = self:FindGO("Name"):GetComponent(UILabel)

	UIUtil.LimitInputCharacter(self.content, 50)
end

function WeddingDressSendView:AddButtonEvt()
	local sendBtn = self:FindGO("SendBtn")
	self:AddClickEvent(sendBtn, function ()
		self:ClickInvite()
	end)

	local friendButton = self:FindGO("FriendButton")
	self:AddClickEvent(friendButton,function ()
		self:ClickFriend()
	end)
end

function WeddingDressSendView:AddViewEvt()
	self:AddListenEvt(SelectFriendEvent.Select, self.HandleSelect)
end

function WeddingDressSendView:InitShow()
	_PictureManager:SetWedding(backgroundName, self.backgroundL)
	_PictureManager:SetWedding(backgroundName, self.backgroundR)

	self.itemGuid = self.viewdata.viewdata

	self.content.value = ZhString.Wedding_SendDress
end

function WeddingDressSendView:ClickInvite()
	if self.dataGuid == nil then
		MsgManager.ShowMsgByID(9646)
		return
	end

	if self.content.value == "" then
		MsgManager.ShowMsgByID(25308)
		return
	end

	ServiceItemProxy.Instance:CallGiveWeddingDressCmd(self.itemGuid, self.content.value, self.dataGuid)
	self:CloseSelf()
end

function WeddingDressSendView:ClickFriend()
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.SelectFriendView})
end

function WeddingDressSendView:HandleSelect(note)
	local data = note.body
	self:SetData(data)
end

function WeddingDressSendView:SetData(data)
	if data.name then
		self.name.text = data.name
	end

	self.dataGuid = data.guid
end