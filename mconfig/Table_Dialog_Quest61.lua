Table_Dialog_Quest61 = {}
local func_index = function(table, key)
	local data = StrTablesManager.GetData("Table_Dialog_Quest61", key);
	return data
end
local Mt_Table_Dialog_Quest61 = {__index = func_index}
setmetatable(Table_Dialog_Quest61,Mt_Table_Dialog_Quest61)
Table_Dialog_Quest61_s = {
	[82053] = "{id = 82053, Speaker = 2157, Text = '你带来足够的莫拉币了吗？'}",
 
}
return Table_Dialog_Quest61
