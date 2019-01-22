autoImport("EventDispatcher")
autoImport("MsgData")
autoImport("CountDownMsg")
MsgManager = class("MsgManager")

MsgManager.MsgType = {
	--?????????
	Float=0,
	--?????????
	Confirm=1,
	--?????????????????????
	ChatNearChannel=2,
	--?????????????????????
	ChatWorldChannel=3,
	--?????????????????????
	ChatTeamChannel=4,
	--?????????????????????
	ChatGuildChannel=5,
	--?????????????????????
	ChatYellChannel=6,
	--?????????????????????
	ChatSystemChannel=7,
	--?????????
	CountDown=8,
	--????????????
	ModelTop=9,
	--???????????????????????????????????????
	FuncPopUp=10,
	--????????????
	Float2=11,
	--????????????
	MenuMsg=12,
	--????????????????????????
	WarnPopup=13,
	--?????????????????????
	ChatPrivateChannel=14,
	--????????????
	AbilityGrow=15,
	--????????????
	DontShowAgain=16,
	--???????????????
	NoticeMsg=17,
	--???????????????
	ShowyFloat=18,
	--???????????????
	MaintenanceMsg = 19,
	--???????????????
	ActivityMsg = 20,
	AchievementPopupTip = 21,
	--????????????????????????
	RaidMsg=22,
	--???????????????
	OverSeaMsg=23,
}

MsgManager.BitIndexs = {}

for k,v in pairs(MsgManager.MsgType) do
	MsgManager.BitIndexs[#MsgManager.BitIndexs + 1] = v
end
table.sort(MsgManager.BitIndexs)

local SystemMsgRemove = {
	[2613] = 3*60	--???
}

function MsgManager.ShowMsgByID(id,...)
	local data = Table_Sysmsg[id]
	if(data~=nil) then
		MsgManager.ShowMsg(data.Title,data.Text,data.Type,...)
	end
end

function MsgManager.ShowMsgByIDTable(id,param,roleid)
	local data = Table_Sysmsg[id]
	if(data~=nil) then
		local removeTime = SystemMsgRemove[id]
		MsgManager.ShowMsgTable(data.Title,data.Text,data.Type,param,roleid,data,removeTime)
	end
end

--??????8???????????????????????????????????????????????? pos???transform.position????????????,offset???table??????????????????
--ex. MsgManager.ShowEightTypeMsgByIDTable(211,{1,1},xxx.transform.position,{10,10})
function MsgManager.ShowEightTypeMsgByIDTable(id,param,pos,offset)
	local data = Table_Sysmsg[id]
	if(data~=nil) then
		local data = MsgData.new(nil,data.Text,param)
		UIUtil.ShowEightTypeMsgByData(data,pos,offset)
	end
end

function MsgManager.ShowEightTypeMsgByString(content,pos,offset)
	if(content~=nil) then
		local data = MsgData.new(nil,content,{})
		UIUtil.ShowEightTypeMsgByData(data,pos,offset)
	end
end

function MsgManager.ShowMsg(title,text,type,...)
	local handler = nil
	local index = nil
	for i=1,#MsgManager.BitIndexs do
		index = MsgManager.BitIndexs[i]
		if(BitUtil.valid(type,index)) then
			if(BitUtil.band(type,index)>0) then
				handler = MsgManager.TypeHandler[index]
				if(handler~=nil) then
					handler(title,text,...)
				end
			end
		else
			break
		end
	end
end

function MsgManager.ShowMsgTable(title,text,type,param,roleid,data,removeTime)
	local handler = nil
	local index = nil
	for i=1,#MsgManager.BitIndexs do
		index = MsgManager.BitIndexs[i]
		if(BitUtil.valid(type,index)) then
			if(BitUtil.band(type,index)>0) then
				handler = MsgManager.TypeTableHandler[index]
				if(handler~=nil) then
					handler(title,text,param,roleid,data,removeTime)
				end
			end
		else
			break
		end
	end
end

function MsgManager.FloatMsg(title, text,... )
	-- text = MsgParserProxy.Instance:TryParse(text,...)
	local data = MsgData.new(nil,text,...)
	UIUtil.FloatMsgByData(data)
	-- UIUtil.FloatMsgByText(text)
end

function MsgManager.FloatMsgTableParam(title, text,param )
	local data = MsgData.new(nil,text,param)
	UIUtil.FloatMsgByData(data)
end

function MsgManager.FloatMiddleBottomTable(title, text,param)
	local text = MsgParserProxy.Instance:TryParse(text,unpack(param))
	UIUtil.FloatMiddleBottom(tonumber(title),text)
end

function MsgManager.FloatRoleTopMsgTableParam(title, text,param,roleid)
	SceneUIManager.Instance:FloatRoleTopMsg(roleid, text, param)
end

function MsgManager.CountDownMsgTableParam(title,text,param,id,staticdata)
	local parser = MsgParserProxy.Instance
	local isHideTime = staticdata.buttonF == "HideTime"
	local parsedText = text
	if param ~= nil and #param > 0 then
		parsedText = parser:TryParse(text,unpack(param))
	end

	local text,data = parser:TryParseCountDown(parsedText, isHideTime)
	if not data then
		redlog("id",id)
	end
	data.id = id
	UIUtil.StartSceenCountDown(text,data)
end

function MsgManager.AdaptConfirm(confirmID,confirmHandler)
	if(confirmID == nil or Table_ShortcutPower[confirmID]==nil) then
		return confirmHandler
	end
	return function (...)
		if(confirmHandler~=nil) then
			confirmHandler(...)
		end
		FuncShortCutFunc.Me():CallByID(confirmID)
	end
end

function MsgManager.DontAgainConfirmMsgByID( id,confirmHandler,cancelHandler,source,... )
	local data = Table_Sysmsg[id]
	if(data~=nil) then
		if(BitUtil.valid(data.Type,MsgManager.MsgType.DontShowAgain)) then
			if(BitUtil.band(data.Type,MsgManager.MsgType.DontShowAgain)>0) then
				local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
				if(dont==nil) then
					local text = MsgParserProxy.Instance:TryParse(data.Text,...)
					confirmHandler = MsgManager.AdaptConfirm(data.Confirm,confirmHandler)
					UIUtil.PopUpDontAgainConfirmView(text,confirmHandler,cancelHandler,source,data)
				end
			else
				MsgManager.ConfirmMsgByID( id,confirmHandler,cancelHandler,source,... )
			end
		end
	end
end

function MsgManager.ConfirmMsgByID( id,confirmHandler,cancelHandler,source,... )
	local data = Table_Sysmsg[id]
	if(data~=nil) then
		local text = MsgParserProxy.Instance:TryParse(data.Text,...)
		confirmHandler = MsgManager.AdaptConfirm(data.Confirm,confirmHandler)
		UIUtil.PopUpConfirmYesNoView(data.Title,text,confirmHandler,cancelHandler,source,data.button,data.buttonF,id)
	end
end

function MsgManager.CloseConfirmMsgByID( id )
	local uniqueConfirm = UIManagerProxy.UniqueConfirmView
	if(uniqueConfirm~=nil) then
		local unique = uniqueConfirm:GetUnique()
		if(unique~=nil and unique== id) then
			uniqueConfirm:CloseSelf()
		end
	end
end

function MsgManager.ConfirmMsg( title,text,... )
	text = MsgParserProxy.Instance:TryParse(text,...)
	-- UIUtil.PopUpConfirmYesNoView(title,text,confirmHandler,cancelHandler,source)
	UIUtil.PopUpConfirmYesNoView(title,text)
end

function MsgManager.ConfirmMsgTableParam(title,text,param,roleid,data)
	local confirmHandler,cancelHandler
	if param ~= nil then
		confirmHandler = param.confirmHandler
		cancelHandler = param.cancelHandler
	end
	confirmHandler = MsgManager.AdaptConfirm(data.Confirm,confirmHandler)
	if param~=nil then
		text = MsgParserProxy.Instance:TryParse(text,unpack(param))
	else
		text = MsgParserProxy.Instance:TryParse(text)
	end
	UIUtil.PopUpConfirmYesNoView(title,text,confirmHandler,cancelHandler,nil,data.button,data.buttonF)
end

function MsgManager.FuncPopUpTableParam(title,text,param ,roleid,data)
	local text = MsgParserProxy.Instance:TryParse(data.Text)
	UIUtil.PopUpFuncView(title,text,param.confirmHandler,param.cancelHandler,nil,data.button,data.buttonF)
end

function MsgManager.MenuMsgTableParam(title,text,param ,roleid,data)
	if(param~=nil) then
		text = MsgParserProxy.Instance:TryParse(text,unpack(param))
	else
		text = MsgParserProxy.Instance:TryParse(text)
	end
	local msg = {text = text,title = title}
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "PopUp10View"});
	GameFacade.Instance:sendNotification(SystemMsgEvent.MenuMsg,msg);
end

function MsgManager.WarnPopupParam(title,text,param ,roleid,data)
	local text
	if(param~=nil) then
		text = MsgParserProxy.Instance:TryParse(data.Text,unpack(param))
		UIUtil.WarnPopup(title,text,param.confirmHandler,param.cancelHandler,nil,data.button,data.buttonF)
	else
		text = MsgParserProxy.Instance:TryParse(data.Text)
		UIUtil.WarnPopup(title,text,nil,nil,nil,data.button,data.buttonF)
	end
end

function MsgManager.ChatMsgTableParam(text,param,channelID,removeTime)
	ChatRoomProxy.Instance:AddSystemMessage(channelID,text,param,removeTime)
end

function MsgManager.ChatNearChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.Current,removeTime)
end

function MsgManager.ChatWorldChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.World,removeTime)
end

function MsgManager.ChatTeamChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.Team,removeTime)
end

function MsgManager.ChatGuildChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.Guild,removeTime)
end

function MsgManager.ChatYellChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.Current,removeTime)
end

function MsgManager.ChatSystemChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.System,removeTime)
end

function MsgManager.ChatPrivateChannelMsgTableParam(title,text,param,roleid,data,removeTime)
	MsgManager.ChatMsgTableParam(text,param,ChatChannelEnum.Private,removeTime)
end

function MsgManager.NoticeMsgTableParam(title,text,param)
	local msg = {text = text,param = param}
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "NoticeMsgView"})
	GameFacade.Instance:sendNotification(SystemMsgEvent.NoticeMsg,msg)
end

-- ????????????????????????
function MsgManager.NoticeRaidMsgById(id,param)
	local data = Table_Sysmsg[id]
	if(data)then
		local msgText = MsgParserProxy.Instance:TryParse(data.Text , param);
		EventManager.Me():DispatchEvent(SystemMsgEvent.RaidAdd,msgText)
	end
end

function MsgManager.ShowyFloatMsgTableParam(title,text,param)
	if(param)then
		text = MsgParserProxy.Instance:TryParse(text, unpack(param));
	end
	UIUtil.FloatShowyMsg(text)
end

function MsgManager.MaintenanceMsgTableParam(title, text, param, roleid, data)
	local confirmHandler
	local cancelHandler
	if(param ~= nil)then
		cancelHandler = param.cancelHandler
		confirmHandler = param.confirmHandler
		text = MsgParserProxy.Instance:TryParse(text, unpack(param))
	else
		text = MsgParserProxy.Instance:TryParse(text)
	end
	FloatingPanel.Instance:ShowMaintenanceMsg(title, text, data.remark, data.button, data.Picture,confirmHandler,cancelHandler);
end

function MsgManager.ActivityMsgTableParam(title, text, param, roleid, data)
	local viewdata = {
		viewname = "ActivityPopUpView",
		title = title,
		text = text,
		param = param,
		msgData = data,
	};
	GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata);
end

function MsgManager.NoticeMsgById(id,param)
	local data = Table_Sysmsg[id]
	if(data~=nil) then
		MsgManager.NoticeMsgTableParam(data.Title,data.Text,param)
	end
end

function MsgManager.OverSeaMsgTableParam(title, text,param )
	OverSeaFunc.Msg(title, text,param)
end

function MsgManager.PopupTipAchievement(achievement_conf_id)
	UIUtil.PopupTipAchievement(achievement_conf_id)
end

MsgManager.TypeHandler = {}
MsgManager.TypeHandler[MsgManager.MsgType.Float] = MsgManager.FloatMsg
MsgManager.TypeHandler[MsgManager.MsgType.Confirm] = MsgManager.ConfirmMsg
MsgManager.TypeHandler[MsgManager.MsgType.OverSeaMsg] = MsgManager.OverSeaMsgTableParam

MsgManager.TypeTableHandler = {}
MsgManager.TypeTableHandler[MsgManager.MsgType.Float] = MsgManager.FloatMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.Confirm] = MsgManager.ConfirmMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ModelTop] = MsgManager.FloatRoleTopMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.CountDown] = MsgManager.CountDownMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.FuncPopUp] = MsgManager.FuncPopUpTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.MenuMsg] = MsgManager.MenuMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.WarnPopup] = MsgManager.WarnPopupParam
MsgManager.TypeTableHandler[MsgManager.MsgType.AbilityGrow] = MsgManager.FloatMiddleBottomTable
MsgManager.TypeTableHandler[MsgManager.MsgType.NoticeMsg] = MsgManager.NoticeMsgTableParam
--????????????
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatNearChannel] = MsgManager.ChatNearChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatWorldChannel] = MsgManager.ChatWorldChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatTeamChannel] = MsgManager.ChatTeamChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatGuildChannel] = MsgManager.ChatGuildChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatYellChannel] = MsgManager.ChatYellChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatSystemChannel] = MsgManager.ChatSystemChannelMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.ChatPrivateChannel] = MsgManager.ChatPrivateChannelMsgTableParam

MsgManager.TypeTableHandler[MsgManager.MsgType.ShowyFloat] = MsgManager.ShowyFloatMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.MaintenanceMsg] = MsgManager.MaintenanceMsgTableParam

MsgManager.TypeTableHandler[MsgManager.MsgType.ActivityMsg] = MsgManager.ActivityMsgTableParam
MsgManager.TypeTableHandler[MsgManager.MsgType.AchievementPopupTip] = MsgManager.PopupTipAchievement
MsgManager.TypeTableHandler[MsgManager.MsgType.RaidMsg] = MsgManager.NoticeRaidMsgById
MsgManager.TypeTableHandler[MsgManager.MsgType.OverSeaMsg] = MsgManager.OverSeaMsgTableParam

