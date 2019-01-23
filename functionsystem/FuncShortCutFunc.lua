--errorLog
FuncShortCutFunc = class("FuncShortCutFunc")

FuncShortCutFunc.FuncType = {
	MoveToNpc = 1,
	MoveToPos = 2,
	JumpPanel = 3,
	OpenUrl = 4,
	NpcFunc = 5,
}

function FuncShortCutFunc.Me()
	if nil == FuncShortCutFunc.me then
		FuncShortCutFunc.me = FuncShortCutFunc.new()
	end
	return FuncShortCutFunc.me
end

function FuncShortCutFunc:ctor()
	self.FuncMap = {}
	self.FuncMap[FuncShortCutFunc.FuncType.MoveToNpc] = self.MoveToNpc
	self.FuncMap[FuncShortCutFunc.FuncType.MoveToPos] = self.MoveToPos
	self.FuncMap[FuncShortCutFunc.FuncType.JumpPanel] = self.JumpPanel
	self.FuncMap[FuncShortCutFunc.FuncType.OpenUrl] = self.OpenUrl
	self.FuncMap[FuncShortCutFunc.FuncType.NpcFunc] = self.NpcFunc
end

function FuncShortCutFunc:CallByID(id, param)
	if(type(id) == "number") then
		local config = Table_ShortcutPower[id]
		if(config) then
			local func = self.FuncMap[config.Type]
			if(func) then
				func(self,config, param)
			else
				errorLog(string.format("FuncShortCutFunc 未支持Table_ShortcutPower Type为%s的处理",config.Type))
			end
		else
			errorLog(string.format("Table_ShortcutPower 未找到id为%s的配置",id))
		end
	elseif(type(id) == "table" and #id == 1)then
		self:CallByID(id[1], param);
	else
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ShortCutOptionPopUp, viewdata = {data = id}});
	end
end

--data 必须是 {Event={}} 格式
function FuncShortCutFunc:CallByTable(t,data)
	if(t==nil or data==nil) then
		return
	end
	local func = self.FuncMap[t]
	if(func) then
		func(self,data)
	end
end

function FuncShortCutFunc:MoveToNpc(data, param)
	local cmdArgs = {
		targetMapID = data.Event.mapid, -- GameConfig.Produce.TraceNpc.map,
		npcID = data.Event.npcid,
		npcUID = data.Event.uniqueid,
	}
	local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)	
	if(cmd)then
		Game.Myself:Client_SetMissionCommand( cmd );
	end
	GameFacade.Instance:sendNotification(UIEvent.CloseUI,UIViewType.NormalLayer)
	TipsView.Me():HideCurrent()
end

local pos = LuaVector3(0,0,0)
function FuncShortCutFunc:MoveToPos(data, param)
	local cmdArgs = {
		targetMapID = data.Event.mapid,
		targetPos = data.Event.pos,
	}
	if(cmdArgs.targetPos~=nil) then
		pos:Set(cmdArgs.targetPos[1],cmdArgs.targetPos[2],cmdArgs.targetPos[3])
		cmdArgs.targetPos = pos
	end
	local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)	
	Game.Myself:Client_SetMissionCommand(cmd)
	GameFacade.Instance:sendNotification(ShortCut.MoveToPos,cmdArgs.targetMapID)
end

local RealNameCheckPanel_Map = {
	[500] = 1,	[501] = 1,	[502] = 1,	[503] = 1,	[504] = 1,	[505] = 1,	
	[506] = 1,	[507] = 1,	[508] = 1,	[509] = 1,	[510] = 1,
}
function FuncShortCutFunc:JumpPanel(data, param)
	local panelid = data.Event.panelid;
	if(panelid)then
		if(RealNameCheckPanel_Map[panelid])then
			FunctionSecurity.Me():TryDoRealNameCentify( function (go)
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = panelid,viewdata = param});
			end,callbackParam );
		else
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = panelid,viewdata = param});
		end
	end
	
	TipsView.Me():HideCurrent();
end

function FuncShortCutFunc:OpenUrl(data, param)
	helplog("FuncShortCutFunc:OpenUrl")
	helplog(data.Event.url)
	Application.OpenURL(data.Event.url)
end

function FuncShortCutFunc:NpcFunc(data, param)
	local npcFunctionData = Table_NpcFunction[data.Event.npcfuncid]
	if npcFunctionData ~= nil then
		FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, Game.Myself, data.Event.param)
	end
end


