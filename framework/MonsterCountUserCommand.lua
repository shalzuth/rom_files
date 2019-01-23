MonsterCountUserCommand = class("MonsterCountUserCommand", pm.SimpleCommand)

function MonsterCountUserCommand:execute(note)
	local num = note.body.num;
	if(note.name == ServiceEvent.FuBenCmdMonsterCountUserCmd)then
		if(num>0)then
			MsgManager.NoticeRaidMsgById(1900,num)
		else
			EventManager.Me():DispatchEvent(SystemMsgEvent.RaidRemove)
		end
	end
end