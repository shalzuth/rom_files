StrTablesManager = class("StrTablesManager")

function StrTablesManager.GetData(tableName, key)
	--local time1 = os.clock()
	local strTable = _G[tableName .. "_s"]
	if (nil == strTable) then
		redlog("Trying to access " .. tableName .. "_s but it's not exist")
		return nil
	end

	local strData = strTable[key]
	if (nil == strData or '' == strData) then
		return nil
	end
	strData = string.gsub(strData, "\\", "\\\\")
	strData = string.gsub(strData, "\n", "\\n")
	local funcData = loadstring("return " .. strData)
	if (nil == funcData) then
		redlog("Data Cannot Parse: " .. strData)
		return nil
	end

	local data = funcData()

	-- todo xde ??????????????????????????????
	for k,v in pairs(transConfig) do
		if k == tableName then
			track2(data, v)
		end
	end

	_G[tableName][key] = data
	strTable[key] = nil
	--local time2 = os.clock()
	--helplog("Parse Data Cost Time: " .. time2 .. " - " .. time1 .. " = " .. time2 - time1)
	return data
end

function StrTablesManager.ProcessMonsterOrNPC(data)
	if (nil ~= data) then
		if (nil ~= data.SpawnSE and '' ~= data.SpawnSE) then
			data.SE = string.split(data.SpawnSE, '-')
		end
		data.Race_Parsed = CommonFun.ParseRace(data.Race)
		data.Nature_Parsed = CommonFun.ParseNature(data.Nature)
	end
	return data
end
