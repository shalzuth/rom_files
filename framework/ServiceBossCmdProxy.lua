autoImport('ServiceBossCmdAutoProxy')
ServiceBossCmdProxy = class('ServiceBossCmdProxy', ServiceBossCmdAutoProxy)
ServiceBossCmdProxy.Instance = nil
ServiceBossCmdProxy.NAME = 'ServiceBossCmdProxy'

function ServiceBossCmdProxy:ctor(proxyName)
	if ServiceBossCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceBossCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceBossCmdProxy.Instance = self
	end
end

function ServiceBossCmdProxy:RecvBossListUserCmd(data)
	local mvplist = {};
	if(data.bosslist~=nil)then
		for i = 1,#data.bosslist do
			local v = data.bosslist[i];
			if(Table_Boss[v.id])then
				local new = {};
				new.id = v.id;
				new.staticData = Table_Boss[v.id];
				new.time = v.refreshTime;
				-- new.refreshstate = v.refreshstate;
				new.killer = v.lastKiller;
				new.mapid = v.mapid;
				table.insert(mvplist, new);
			else
				errorLog(string.format("Not Find BossID(%s) In Table_Boss", v.id));
			end
		end
	end
	local minilist = {};
	if(data.minilist~=nil)then
		for i = 1,#data.minilist do
			local v = data.minilist[i];
			if(Table_Boss[v.id])then
				local new = {};
				new.id = v.id;
				new.staticData = Table_Boss[v.id];
				new.time = v.refreshTime;
				-- new.refreshstate = v.refreshstate;
				new.killer = v.lastKiller;
				new.mapid = v.mapid;
				table.insert(minilist, new);
			else
				errorLog(string.format("Not Find BossID(%s) In Table_Boss", v.id));
			end
		end
	end
	self:Notify(ServiceEvent.BossCmdBossListUserCmd, {mvplist, minilist});
end

function ServiceBossCmdProxy:RecvBossPosUserCmd(data) 
	self:Notify(ServiceEvent.BossCmdBossPosUserCmd, data)
end

function ServiceBossCmdProxy:RecvKillBossUserCmd(data) 
	self:Notify(ServiceEvent.BossCmdKillBossUserCmd, data)
end
