PlayerTeamInfoCommand = class("PlayerTeamInfoCommand", pm.SimpleCommand)

function PlayerTeamInfoCommand:execute(note)
	if(note.body)then
		local playerid = note.body.charid;
		local teamid = note.body.teamid;
		if(playerid and teamid)then
			FunctionPlayerTip.Me():UpdateInviteMemberFuncState(playerid, teamid)
		end
	end
end