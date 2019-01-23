autoImport("RoleChangeNamePopUp");
GuildChangeNamePopUp = class("GuildChangeNamePopUp", RoleChangeNamePopUp);

function GuildChangeNamePopUp:TryChangeName()
	local name = self.nameInput.value;

	if name == "" then
		MsgManager.ShowMsgByIDTable(1006);

		self:ShowChangeError();
		return
	end

	local itemId = GameConfig.Guild.rename_item or 1129;
	local itemNum = BagProxy.Instance:GetItemNumByStaticID(itemId);
	if(itemNum <= 0)then
		local itemName = Table_Item[itemId].NameZh;
		MsgManager.ShowMsgByIDTable(2703, {itemName});
		-- FuncShortCutFunc.Me():CallByID(86);
		self:CloseSelf();
		return;
	end

	local length = StringUtil.Utf8len(name)
	if length < GameConfig.System.namesize_min or length > GameConfig.System.namesize_max then
		MsgManager.ShowMsgByIDTable(883);
		self:ShowChangeError();
		return
	end

	if FunctionMaskWord.Me():CheckMaskWord(name, self.maskType) then
		MsgManager.ShowMsgByIDTable(2604);
		self:ShowChangeError();
		return
	end

	self:DoChangeName(name)
end

function GuildChangeNamePopUp:DoChangeName(name)
	if(self.waitRecv == true)then
		return;
	end
	self.waitRecv = true;

	ServiceGuildCmdProxy.Instance:CallRenameQueryGuildCmd(name) 
end

function GuildChangeNamePopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdRenameQueryGuildCmd, self.HandleError);
end

function GuildChangeNamePopUp:HandleError(note)
	self.waitRecv = false;

	local errorCode = note.body.code;
	if(errorCode == SceneUser2_pb.ERENAME_SUCCESS)then
		MsgManager.ShowMsgByIDTable(2702);
		self:CloseSelf();
		return;
	end

	if(errorCode == SceneUser2_pb.ERENAME_CONFLICT)then
		MsgManager.ShowMsgByIDTable(2630);
		self:ShowChangeError();
	elseif(errorCode == SceneUser2_pb.ERENAME_CD)then
		MsgManager.ShowMsgByIDTable(2701);
		self:ShowChangeError();
	end
end