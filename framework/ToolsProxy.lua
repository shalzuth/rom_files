ToolsProxy = class('ToolsProxy', pm.Proxy)
ToolsProxy.Instance = nil;
ToolsProxy.NAME = "ToolsProxy"

function ToolsProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ToolsProxy.NAME
	if(ToolsProxy.Instance == nil) then
		ToolsProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function ToolsProxy:Init()
	-- body
end

function ToolsProxy:InitGmFunction()
	self.gmFunction = {}

	local functionList = {}
	for k,v in pairs(Table_GM_CMD) do
		local key = ""
		if v.MenuDir == "" then
			key = v.Name
		else
			key = v.MenuDir
		end

		if functionList[key] == nil then
			functionList[key] = {}
		end

		table.insert( functionList[key] , v.id )
	end

	for k,v in pairs(functionList) do
		local data = {}
		data.name = k
		data.cmdId = v
		table.insert(self.gmFunction , data)
	end

	table.sort(self.gmFunction,function(l,r)
		return l.cmdId[1] < r.cmdId[1]
	end)
end

function ToolsProxy:GetGmFunction()
	if self.gmFunction == nil then
		self:InitGmFunction()
	end

	return self.gmFunction
end

function ToolsProxy:GetChildFunction(parentData)
	local datas = {}
	for i=1,#parentData.cmdId do
		local data = {}
		data.cmdId = {}
		data.name = Table_GM_CMD[ parentData.cmdId[i] ].Name
		table.insert(data.cmdId,parentData.cmdId[i])
		table.insert(datas,data)				
	end

	table.sort(datas,function(l,r)
		return l.cmdId[1] < r.cmdId[1]
	end)

	return datas
end

function ToolsProxy:GetGmInput(cmdId)
	local result = {}
	local data = Table_GM_CMD[cmdId]

	if data then
		local params = data.Param
		local symbol = "({(.-)})"
		for str,param in string.gmatch(params, symbol) do
			local datas = {}
			datas.param = param
			datas.cmdId = cmdId
			table.insert(result,datas)
		end
	end

	return result
end