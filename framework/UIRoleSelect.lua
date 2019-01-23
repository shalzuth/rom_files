autoImport('UIModelRolesList')

UIRoleSelect = class('UIRoleSelect')

UIRoleSelect.ins = nil
function UIRoleSelect.Ins()
	if UIRoleSelect.ins == nil then
		UIRoleSelect.ins = UIRoleSelect.new()
	end
	return UIRoleSelect.ins
end

local tempTable = {}
function UIRoleSelect:Open()
	tempTable.view = PanelConfig.RolesSelect
	tempTable.viewdata = {}
	local uiInfo = tempTable
	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, uiInfo)
	TableUtility.TableClear(tempTable)
end

function UIRoleSelect:Close()
	
end