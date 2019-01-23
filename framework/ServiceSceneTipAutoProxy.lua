ServiceSceneTipAutoProxy = class('ServiceSceneTipAutoProxy', ServiceProxy)

ServiceSceneTipAutoProxy.Instance = nil

ServiceSceneTipAutoProxy.NAME = 'ServiceSceneTipAutoProxy'

function ServiceSceneTipAutoProxy:ctor(proxyName)
	if ServiceSceneTipAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneTipAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneTipAutoProxy.Instance = self
	end
end

function ServiceSceneTipAutoProxy:Init()
end

function ServiceSceneTipAutoProxy:onRegister()
	self:Listen(18, 1, function (data)
		self:RecvGameTipCmd(data) 
	end)
	self:Listen(18, 2, function (data)
		self:RecvBrowseRedTipCmd(data) 
	end)
	self:Listen(18, 3, function (data)
		self:RecvAddRedTip(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneTipAutoProxy:CallGameTipCmd(opt, redtip) 
	local msg = SceneTip_pb.GameTipCmd()
	if(opt ~= nil )then
		msg.opt = opt
	end
	if( redtip ~= nil )then
		for i=1,#redtip do 
			table.insert(msg.redtip, redtip[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneTipAutoProxy:CallBrowseRedTipCmd(red, tipid) 
	local msg = SceneTip_pb.BrowseRedTipCmd()
	if(red ~= nil )then
		msg.red = red
	end
	if(tipid ~= nil )then
		msg.tipid = tipid
	end
	self:SendProto(msg)
end

function ServiceSceneTipAutoProxy:CallAddRedTip(red, tipid) 
	local msg = SceneTip_pb.AddRedTip()
	if(red ~= nil )then
		msg.red = red
	end
	if(tipid ~= nil )then
		msg.tipid = tipid
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneTipAutoProxy:RecvGameTipCmd(data) 
	self:Notify(ServiceEvent.SceneTipGameTipCmd, data)
end

function ServiceSceneTipAutoProxy:RecvBrowseRedTipCmd(data) 
	self:Notify(ServiceEvent.SceneTipBrowseRedTipCmd, data)
end

function ServiceSceneTipAutoProxy:RecvAddRedTip(data) 
	self:Notify(ServiceEvent.SceneTipAddRedTip, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneTipGameTipCmd = "ServiceEvent_SceneTipGameTipCmd"
ServiceEvent.SceneTipBrowseRedTipCmd = "ServiceEvent_SceneTipBrowseRedTipCmd"
ServiceEvent.SceneTipAddRedTip = "ServiceEvent_SceneTipAddRedTip"
