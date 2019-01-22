DialogUtil = class("DialogUtil")

Mirror_Dialog = {};

local loadIds = {};
function DialogUtil.GetDialogData(dialogids)
	if(dialogids == nil)then
		return;
	end

	local tempid;

	for i=1,#dialogids do
		tempid = dialogids[i];
		if(Mirror_Dialog[tempid] == nil)then
			table.insert(loadIds, tempid);
		end
	end

	if(#loadIds == 0)then
		return Mirror_Dialog;
	end


	helplog("Table_Dialog LoadIn In!!!!!!!!!!!!!!!!!!!!");

	local table_dialog = _G["Table_Dialog"];

	if(table_dialog == nil)then
		-- package.loaded[fullPath] = nil
		autoImport("Table_Dialog", true);
		table_dialog = _G["Table_Dialog"];
	end

	for i=1,#loadIds do
		tempid = loadIds[i];

		local src = table_dialog[ tempid ];

		local copy = {};
		copy.id = src.id;
		copy.Speaker = src.Speaker;
		copy.Text = src.Text;
		copy.Option = src.Option;
		copy.Emoji = src.Emoji;
		copy.Voice = src.Voice;

		if(src.Action ~= _EmptyTable)then
			copy.Action = {};
			for k,v in pairs(src.Action)do
				copy.Action[k] = v;
			end
		else
			copy.Action = _EmptyTable;
		end

		Mirror_Dialog[tempid] = copy;
	end

	TableUtility.ArrayClear(loadIds);

	Table_Dialog = nil;

	return Mirror_Dialog;
end


local ERROR_DIALOG = 
{
	id = nil,
	Speaker = 0, 
	Text = '??????????????????????????????~???', 
	Voice = '', 
	Option = '',
}
function DialogUtil.GetDialogData(dialogid)
	local dialog_index = _G["Dialog_Index"];
	if(dialog_index == nil)then
		autoImport("Dialog_Index");
		dialog_index = _G["Dialog_Index"];
	end

	local table_name = dialog_index[dialogid];

	if(table_name == nil)then
		redlog("Not Find Dialog Id:" .. tostring(dialogid));
		ERROR_DIALOG.id = dialogid;
		return ERROR_DIALOG;
	end

	local table_dialog = _G[table_name];
	if(table_dialog == nil)then
		autoImport(table_name);
		table_dialog = _G[table_name];
	end

	-- todo xde Table_Dialog ?????????????????????????????????
	local temp = table_dialog[dialogid]
	-- printData("before", temp)
	if true then
		transTable(temp)
		-- printData("after", temp)
		return temp
	end

	return table_dialog[dialogid];
end

function DialogUtil.GetDialogDatas(dialogids)
	for i=1,#dialogids do
		return DialogUtil.GetDialogData(dialogids[i]);
	end
end
