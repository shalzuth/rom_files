DesertWolfJoinView = class("DesertWolfJoinView",ContainerView)
DesertWolfJoinView.ViewType = UIViewType.PopUpLayer

function DesertWolfJoinView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function DesertWolfJoinView:FindObjs()
	self.nameInput = self:FindGO("NameInput"):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(self.nameInput, 12)
end

function DesertWolfJoinView:AddEvts()
	local joinButton = self:FindGO("JoinButton", self.desertWolfView)
	self:AddClickEvent(joinButton,function ()
		self:ClickJoin()
	end)
end

function DesertWolfJoinView:AddViewEvts()
	-- body
end

function DesertWolfJoinView:InitShow()
	self.defaultName = string.format(ZhString.Pvp_DesertWolfJoinName, Game.Myself.data.name)
	self.nameInput.value = self.defaultName
end

function DesertWolfJoinView:ClickJoin()
	local resultStr = string.gsub(self.nameInput.value, " ", "")
	if StringUtil.ChLength(resultStr) >= 2 then
		if not FunctionMaskWord.Me():CheckMaskWord(resultStr, FunctionMaskWord.MaskWordType.SpecialSymbol | FunctionMaskWord.MaskWordType.Chat) then
			ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.DesertWolf, 0, resultStr)
			self:CloseSelf()
		else
			MsgManager.ShowMsgByIDTable(958)
		end
	else
		MsgManager.ShowMsgByIDTable(883)
	end
end