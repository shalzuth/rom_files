FollowCommand = class("FollowCommand", pm.SimpleCommand)

function FollowCommand:execute(note)
	if(note.name == FollowEvent.Follow)then
		local followid = note.body;
		if(followid)then
			ServiceNUserProxy.Instance:CallFollowerUser(followid)
		else
			printRed("not transfer follow id..");
		end
	elseif(note.name == ServiceEvent.NUserFollowerUser)then
		local followid = note.body.userid;
		local followType = note.body.eType;
		Game.Myself:Client_SetFollowLeader(followid, followType, true);
	elseif(note.name == FollowEvent.CancelFollow)then
		Game.Myself:Client_SetFollowLeader(0);
	elseif(note.name == ServiceEvent.NUserGoMapFollowUserCmd)then
		-- LogUtility.InfoFormat(" ServiceEvent.NUserGoMapFollowUserCmd map :{0} ", note.body.mapid)
		Game.Myself:Client_SetFollowLeaderMoveToMap(note.body.mapid);
	end
end