CodeData = class("CodeData")

function CodeData:ctor(id,staticData)
	self.guid=id
	self.staticData = staticData;
	self:InitData();
end

function CodeData:InitData()
end

function CodeData:Server_SetData(serverdata)
	self.code = serverdata.code;
	self.used = serverdata.used;
end

function CodeData:IsCodeCanSell()
	return self.used
end
