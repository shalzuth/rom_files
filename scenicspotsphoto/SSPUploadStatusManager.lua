autoImport('NetIngScenicSpotPhotoNew')
autoImport('PhotoFileInfo')

SSPUploadStatusManager = class('SSPUploadStatusManager')

SSPUploadStatusManager.ins = nil
function SSPUploadStatusManager.Ins()
	if SSPUploadStatusManager.ins == nil then
		SSPUploadStatusManager.ins = SSPUploadStatusManager.new()
	end
	return SSPUploadStatusManager.ins
end

local arraySSID = {}
local indicator = 1
local ticketsCount = 1

function SSPUploadStatusManager:SyncUploadStatusToGameServer(s_scenic_spot_id)
	if s_scenic_spot_id ~= nil and #s_scenic_spot_id > 0 then
		for i = 1, #s_scenic_spot_id do
			local ssID = s_scenic_spot_id[i]
			if ssID > 0 then
				table.insert(arraySSID, ssID)
			end
		end
		self:DoSyncUploadStatusToGameServer()
	end
end

function SSPUploadStatusManager:DoSyncUploadStatusToGameServer()
	if #arraySSID > 0 then
		if indicator <= #arraySSID then
			local endIndicator = math.min(indicator + ticketsCount - 1, #arraySSID)
			for i = indicator, endIndicator do
				local ssID = arraySSID[i]
				NetIngScenicSpotPhotoNew.Ins():CheckExist(
					Game.Myself.data.id,
					ssID,
					function ()
						self:RequestUploadOkSceneryUserCmd(ssID, 1)
						ticketsCount = ticketsCount + 1
						self:DoSyncUploadStatusToGameServer()
					end,
					function ()
						self:RequestUploadOkSceneryUserCmd(ssID, 2)
						ticketsCount = ticketsCount + 1
						self:DoSyncUploadStatusToGameServer()
					end,
					PhotoFileInfo.OldExtension
				)
				ticketsCount = ticketsCount - 1
				indicator = indicator + 1
			end
		else
			TableUtility.ArrayClear(arraySSID)
		end
	end
end

function SSPUploadStatusManager:RequestUploadOkSceneryUserCmd(ss_id, status)
	ServiceNUserProxy.Instance:CallUploadOkSceneryUserCmd(ss_id, status)
end