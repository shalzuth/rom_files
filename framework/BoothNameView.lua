BoothNameView = class("BoothNameView", ContainerView)

BoothNameView.ViewType = UIViewType.PopUpLayer

function BoothNameView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function BoothNameView:FindObjs()
	self.sign = self:FindGO("Sign"):GetComponent(UIMultiSprite)
	self.signTitle = self:FindGO("SignTitle"):GetComponent(UILabel)
	self.input = self:FindGO("Input"):GetComponent(UIInput)

	UIUtil.LimitInputCharacter(self.input, GameConfig.Booth.name_length_max)
end

function BoothNameView:AddEvts()
	local confirmBtn = self:FindGO("ConfirmBtn")
	self:AddClickEvent(confirmBtn, function ()
		self:ClickConfirm()
	end)
end

function BoothNameView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.HandleBoothReq)
	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function BoothNameView:InitShow()
	local viewdata = self.viewdata.viewdata
	if viewdata ~= nil then
		self.playerID = viewdata.playerID
	end

	if self.playerID == nil then
		local map = NSceneUserProxy.Instance:GetAll()
		if map ~= nil then
			local range = GameConfig.Booth.booth_range
			local myPos = Game.Myself:GetPosition()
			local myId = Game.Myself.data.id
			local _DistanceXZ = VectorUtility.DistanceXZ
			for k,v in pairs(map) do
				if k ~= myId then
					local dist = _DistanceXZ(v:GetPosition(), myPos)
					if dist <= range and v:IsInBooth() then
						MsgManager.ShowMsgByID(25707)
						break
					end
				end
			end
		end
	end

	self:UpdateSign()
	self:UpdateName()
end

function BoothNameView:UpdateSign()
	local level = BoothProxy.Instance:GetScoreLevel(MyselfProxy.Instance:GetBoothScore())
	self.sign.CurrentState = level

	local name = ""
	local scoreConfig = GameConfig.Booth.score[level]
	if scoreConfig ~= nil then
		name = scoreConfig.name
	end
	self.signTitle.text = string.format(ZhString.Booth_SignName, name)
end

function BoothNameView:UpdateName()
	if self.playerID ~= nil then
		local player = NSceneUserProxy.Instance:Find(self.playerID)
		if player ~= nil and player.data ~= nil then
			local boothData = player.data.boothData
			if boothData ~= nil then
				self.input.value = boothData:GetName()
				return
			end
		end
	end

	self.input.value = string.format(ZhString.Booth_Name, Game.Myself.data.name)
end

function BoothNameView:ClickConfirm()
	if #self.input.value < 1 then
		MsgManager.ShowMsgByID(25700)
		return
	end

	if FunctionMaskWord.Me():CheckMaskWord(self.input.value , FunctionMaskWord.MaskWordType.SpecialSymbol|FunctionMaskWord.MaskWordType.Chat) then
		MsgManager.ShowMsgByID(2604)
		return
	end

	if self.playerID ~= nil then
		ServiceNUserProxy.Instance:CallBoothReqUserCmd(self.input.value, BoothProxy.OperEnum.Update)
	else
		ServiceNUserProxy.Instance:CallBoothReqUserCmd(self.input.value, BoothProxy.OperEnum.Open)
	end
end

function BoothNameView:HandleBoothReq(note)
	local data = note.body
	if data and data.success == true and data.oper == BoothProxy.OperEnum.Open then
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BoothMainView})
	end

	self:CloseSelf()
end