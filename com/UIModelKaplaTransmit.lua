UIModelKaplaTransmit = class('UIModelKaplaTransmit')

local gReusableTable = {}
local gReusableArray = {}

local teammatesDetail = {}

UIModelKaplaTransmit.ins = nil
function UIModelKaplaTransmit:Ins()
	if UIModelKaplaTransmit.ins == nil then
		UIModelKaplaTransmit.ins = UIModelKaplaTransmit.new()
	end
	return UIModelKaplaTransmit.ins
end

function UIModelKaplaTransmit:GetTeammates()
	local myselfTeamData = TeamProxy.Instance.myTeam
	if TeamProxy.Instance:IHaveTeam() and myselfTeamData ~= nil then
		local teammates = myselfTeamData:GetPlayerMemberList(false, true)
		if teammates ~= nil then
			local teammatesID = {}
			for _, v in pairs(teammates) do
				local teamMemberData = v
				local isOnline = not teamMemberData:IsOffline()
				if isOnline then
					local teammateID = teamMemberData.id
					table.insert(teammatesID, teammateID)
					local teammateDetail = {}
					teammateDetail.isFollowing = false
					teammateDetail.name = teamMemberData.name
					teammatesDetail[teammateID] = teammateDetail
				end
			end
			local followers = Game.Myself:Client_GetAllFollowers()
			if followers ~= nil then
				for k, _ in pairs(followers) do
					local followerID = k
					if table.ContainsKey(teammatesDetail, followerID) then
						teammatesDetail[followerID].isFollowing = true
					end
				end
			end
			return teammatesID
		end
	end
	return nil
end

function UIModelKaplaTransmit:GetFollowingTeammates()
	local teammatesID = self:GetTeammates()
	if teammatesID ~= nil then
		local followingTeammatesID = {}
		for _, v in pairs(teammatesID) do
			local teammateID = v
			local teammateDetail = UIModelKaplaTransmit.Ins():GetTeammateDetail(teammateID)
			if teammateDetail.isFollowing then
				table.insert(followingTeammatesID, teammateID)
			end
		end
		return followingTeammatesID
	end
	return nil
end

function UIModelKaplaTransmit:GetTeammateDetail(teammate_id)
	self:GetTeammates()
	if teammatesDetail ~= nil then
		return teammatesDetail[teammate_id]
	end
	return nil
end

function UIModelKaplaTransmit:AmITeamLeader()
	local leaderTeamMemberData = TeamProxy.Instance.myTeam:GetNowLeader()
	if leaderTeamMemberData ~= nil then
		local myselfID = Game.Myself.data.id
		return leaderTeamMemberData.id == myselfID
	end
	return false
end

function UIModelKaplaTransmit:GetHandInHandPlayerID()
	local followId = Game.Myself:Client_GetFollowLeaderID();
	local isHandFollow = Game.Myself:Client_IsFollowHandInHand();
	local handFollowerId = Game.Myself:Client_GetHandInHandFollower();
	local handTargetId = isHandFollow and followId or handFollowerId
	return handTargetId
end

function UIModelKaplaTransmit:GetHandInHandPlayerID_Teammate_NotCat()
	local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID()
	if handInHandPlayerID ~= nil and handInHandPlayerID > 0  then
		local isTeammate = UIModelKaplaTransmit.Ins():IsTeammate(handInHandPlayerID)
		if isTeammate then
			local isCat = UIModelKaplaTransmit.Ins():PlayerIsCat(handInHandPlayerID)
			if not isCat then
				return handInHandPlayerID
			end
		end
	end
	return nil
end

function UIModelKaplaTransmit:PlayerIsCat(player_id)
	return TeamProxy.Instance:CheckIsCatByPlayerId(player_id)
end

-- others defect
function UIModelKaplaTransmit:IsTeammate(player_id)
	return TeamProxy.Instance:IsInMyTeam(player_id)
end