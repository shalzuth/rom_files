ShortCutOptionPopUp = class("ShortCutOptionPopUp", BaseView);

autoImport("ShortCutItemCell")

ShortCutOptionPopUp.ViewType = UIViewType.PopUpLayer

function ShortCutOptionPopUp:Init()
	local grid = self:FindComponent("Grid", UIGrid);
   	self.ctl = UIGridListCtrl.new(grid , ShortCutItemCell, "ShortCutItemCell");
	self.ctl:AddEventListener(MouseEvent.MouseClick, self.ClickItemTrace, self);
end

function ShortCutOptionPopUp:ClickItemTrace(shortCutItem)
	if(shortCutItem.traceId)then
		FuncShortCutFunc.Me():CallByID(shortCutItem.traceId);
	end
	self:CloseSelf();
end

local datas = {};
function ShortCutOptionPopUp:OnEnter()
	ShortCutOptionPopUp.super.OnEnter(self);

	local viewdata = self.viewdata.viewdata;
	if(viewdata)then
		local data = self.viewdata.viewdata.data;

		TableUtility.ArrayClear(datas);
		for i=1, #data do
			local shortCutData = Table_ShortcutPower[data[i]];
			table.insert(datas, shortCutData);
		end
		self.ctl:ResetDatas(datas);
	end
end