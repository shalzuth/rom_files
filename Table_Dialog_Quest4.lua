Table_Dialog_Quest4 = {}
local func_index = function(table, key)
	local data = StrTablesManager.GetData("Table_Dialog_Quest4", key);
	return data
end
local Mt_Table_Dialog_Quest4 = {__index = func_index}
setmetatable(Table_Dialog_Quest4,Mt_Table_Dialog_Quest4)
Table_Dialog_Quest4_s = {
	[83] = "{id = 83, Speaker = 1054, Text = '[c][ffff00][PlayerName][-][/c]????????????????????????????????????????????????????????????????????????????????????', Emoji = 0}",
	[84] = "{id = 84, Speaker = 1054, Text = '????????????????????????????????????????????????????????????????????????????????????????????????~', Option = '??????', Emoji = 20}",
	[85] = "{id = 85, Speaker = 1054, Text = '??????????????????????????????????????????????????????~?????????????????????????????????', Option = '??????', Emoji = 0}",
	[86] = "{id = 86, Speaker = 1054, Text = '????????????????????????????????????????????????????????????????????????????????????^-^', Emoji = 17}",
	[87] = "{id = 87, Speaker = 1054, Text = '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????', Option = '????????????', Emoji = 0}",
	[2364] = "{id = 2364, Speaker = 1024, Text = '[c][ffff00]??????[-][/c]????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????', Option = '??????'}",
	[2365] = "{id = 2365, Speaker = 1024, Text = '????????????????????????????????????????????????[c][ffff00]????????????[-][/c]???????????????????????????????????????????????????????????????????????????????????????', Option = '??????'}",
	[5106] = "{id = 5106, Speaker = 1024, Text = '????????????????????????????????????????????????????????????????????????????????????'}",
	[5107] = "{id = 5107, Speaker = 1024, Text = '???????????????????????????????????????????????????????????????~'}",
	[1312550] = "{id = 1312550, Speaker = 1187, Text = '??????????????????????????????????????????????????????????????????'}",
	[1312551] = "{id = 1312551, Speaker = 1187, Text = '??????????????????????????????????????????????????????????????????'}",
 
}
return Table_Dialog_Quest4
