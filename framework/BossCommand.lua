BossCommand = class("BossCommand", pm.SimpleCommand)

function BossCommand:execute(note)
	local data = note.body;
	if(data)then
		local role = NSceneUserProxy.Instance:Find(data.userid);
		if(role)then
			role:PlayKilledMVPEffect()
		end
	end
end