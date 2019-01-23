
FunctionDungen = class("FunctionDungen")

FunctionDungen.LaunchEvt = "FunctionDungen_LaunchEvt"
FunctionDungen.ShutdownEvt = "FunctionDungen_ShutdownEvt"

FunctionDungen.EndlessTowerType = 4
FunctionDungen.LaboratoryType = 5
FunctionDungen.ChangeJobType = 6
FunctionDungen.DojoType = 9
FunctionDungen.EDAnimType = 11
FunctionDungen.YoyoType = 21
FunctionDungen.DesertWolfType = 22
FunctionDungen.GorgeousMetalType = 23

function FunctionDungen.Me()
	if nil == FunctionDungen.me then
		FunctionDungen.me = FunctionDungen.new()
	end
	return FunctionDungen.me
end

function FunctionDungen:ctor()
	self.typeHandler = {}
	self.typeHandler[FunctionDungen.ChangeJobType] = self.HandlerChangeJob
	self.typeHandler[FunctionDungen.EDAnimType] = self.HandleEDAnim
	self:Reset()
end

function FunctionDungen:Reset()
	self.bossID = nil
	self.raidData = nil
	self.running = false
end

function FunctionDungen:Launch(raidID)
	if self.running then
		return
	end

	self.running = true
	self.raidData = Table_MapRaid[raidID]
	self.bossID = self.raidData.Boss
	
	local eventManager = EventManager.Me()
	eventManager:AddEventListener(SceneCreatureEvent.DeathBegin, self.OnCreatureDeathBegin, self)
	GameFacade.Instance:sendNotification(FunctionDungen.LaunchEvt)
end

function FunctionDungen:Shutdown()
	if not self.running then
		return
	end

	self:Reset()

	local eventManager = EventManager.Me()
	eventManager:RemoveEventListener(SceneCreatureEvent.DeathBegin, self.OnCreatureDeathBegin, self)
	GameFacade.Instance:sendNotification(FunctionDungen.ShutdownEvt)
end

function FunctionDungen:OnCreatureDeathBegin(event)
	local role = event.data
	local creature = SceneCreatureProxy.FindCreature(role.data.ID)
	if nil ~= creature and self.bossID == creature.staticId then
		if(self.bossID)then
			GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "BattleResultView"}); 
		else
			printRed("This Map Not Config The Boss!!");
		end
	end
end

function FunctionDungen:HandleSceneLoaded()
	if self.running and self.raidData then
		local call = self.typeHandler[self.raidData.Type]
		if(call~=nil) then
			call(self)
		end
	end
end

function FunctionDungen:HandlerChangeJob()
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ChangeJobView,force = true}); 
end

function FunctionDungen:HandleEDAnim()
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.EDView}); 
end

function FunctionDungen:DungenBattleSuccess( data )
	local fubenType = data.type;
	local vdata = {
		viewname = "BattleResultView",
	};
	if(fubenType == FuBenCmd_pb.ERAIDTYPE_LABORATORY)then
		local curve, maxScore, currentScore, p_multiple = data.param1, data.param2, data.param3, data.param4;
		local resultData = {
			getScore = math.max(0, currentScore-maxScore);
			multiple = p_multiple,
			curve = curve,
			todayScore = maxScore,
			currentScore = currentScore,
		};

		local baselv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL);
		local gardenConfig, robConfig = GameConfig.Laboratory.garden, GameConfig.Laboratory.rob;
		resultData.garden = math.ceil(resultData.getScore / (gardenConfig[1] + baselv * gardenConfig[2]));
		resultData.rob = math.ceil(resultData.getScore / (robConfig[1] + baselv * robConfig[2]));

		vdata.callback = function ()
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, 
				{view = PanelConfig.InstituteResultPopUp, viewdata = {resultData = resultData}}) 
		end
		GameFacade.Instance:sendNotification(UIEvent.ShowUI, vdata); 
	elseif(fubenType == FuBenCmd_pb.ERAIDTYPE_RAIDTEMP3)then
		GameFacade.Instance:sendNotification(UIEvent.ShowUI, vdata); 
	end
end


