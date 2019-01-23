function math.KeepDecimalPlaces(fValue, n)
	if type(fValue) == 'number' and type(n) == 'number' then
		local tenPower = math.pow(10, n)
		local value = fValue * tenPower
		value = math.floor(value)
		return value / tenPower
	end
	return fValue
end

math.Epsilon = 1e-5
function math.Approximately(a, b)
	return a >= b - math.Epsilon and a <= b + math.Epsilon
end

function math.CalculateRemainder(divident, divisor)
	local result = -1
	if divident > 0 and divisor > 0 then
		if divident < divisor then
			result = divident
		elseif divident == divisor then
			result = 0
		else
			local isBreak = false
			while not isBreak do
				divident = divident - divisor
				if divident < divisor then
					result = divident
					isBreak = true
				end
			end
		end
	end
	return result
end

function math.CalculateQuotient(divident, divisor)
	local result = -1
	if divident > 0 and divisor > 0 then
		if divident < divisor then
			result = 0
		elseif divident == divisor then
			result = 1
		else
			local temp = 0
			local isBreak = false
			while not isBreak do
				divident = divident - divisor
				temp = temp + 1
				if divident < divisor then
					isBreak = true
				end
			end
			result = temp
		end
	end
	return result
end

function math.IsInteger(number)
	return math.floor(number) == number
end

function table.ContainsKey(tab, key)
	return tab[key] ~= nil
end

function table.ContainsValue(tab, value)
	if value == nil then return false end

	if tab then
		for _, v in pairs(tab) do
			if v == value then
				return true
			end
		end
	end

	return false
end

function table.IsEmpty(tab)
	if tab == nil then return true end
	for _, v in pairs(tab) do
		if v then return false end
	end
	return true
end

function table.IsNest(tab)
	if tab == nil then return false end
	for _, v in pairs(tab) do
		if v and type(v) == 'table' then
			return true
		end
	end
	return false
end

function table.IsArray(tab)
	if tab == nil then return false end
	local indicator = 1
	for k, v in pairs(tab) do
		if type(k) ~= 'number' or k ~= indicator then
			return false
		end
		indicator = indicator + 1
	end
	return true
end

function table.KeyIsLast(tab, kValue)
	if kValue and tab then
		local tabKey = {}
		for k, _ in pairs(tab) do
			table.insert(tabKey, k)
		end
		if not table.IsEmpty(tabKey) then
			local lastKey = tabKey[#tabKey]
			if type(kValue) == type(lastKey) and kValue == lastKey then
				return true
			end
		end
	end
	return false
end

function table.EqualTo(tab1, tab2)
	if tab1 == tab2 then return true end
	if tab1 == nil or tab2 == nil then return false end
	for k, v in pairs(tab1) do
		if v ~= tab2[k] then
			return false
		end
	end
	return true
end

local tabSymbolCount = 0

function Tab()
	local retValue = ""
	if tabSymbolCount > 0 then
		for i = 1, tabSymbolCount do
			retValue = retValue .. "\t"
		end
	end
	return retValue
end

function Serialize(obj)
	local lua = ""
	local t = type(obj)
	if t == "number" then
		lua = obj
	elseif t == "boolean" then
		lua = tostring(obj)
	elseif t == "string" then
		lua = "\"" .. obj .. "\""
	elseif t == "table" then
		lua = "{\n"
		tabSymbolCount = tabSymbolCount + 1
		local strTabs = Tab()
		for k, v in pairs(obj) do
			local strK = ""
			local kType = type(k)
			if kType == "string" then
				strK = k
			elseif kType == "number" then
				strK = '[' .. k .. ']'
			end
			lua = lua .. strTabs .. strK .. '=' .. Serialize(v) .. ((table.KeyIsLast(obj, k) and '' or ",") .. '\n')
		end
		tabSymbolCount = tabSymbolCount - 1
		strTabs = Tab()
		lua = lua .. strTabs .. "}"
	elseif t == "nil" then
		return nil
	else
		error("Can not serialize a " .. t .. " type.")
	end
	return lua
end