MissionCommandFactory = class("MissionCommandFactory")

-- Args = {
-- 	targetMapID,
-- 	targetBPID,
-- 	targetPos,

-- 	distance,
-- 	npcID,
-- 	npcUID,
-- 	groupID,
-- 	skillID,

-- 	custom,

-- 	cmdClass,
-- }

local tempArgs = {}

function MissionCommandFactory.CreateCommand(args, cmdClass)
	LogUtility.InfoFormat("<color=green>MissionCommandFactory.CreateCommand</color> {0}\n {1}\n {2}", 
		LogUtility.StringFormat("cmdClass={0}, args:\n targetMapID={1}\n targetBPID={2}", 
			cmdClass.__cname,
			LogUtility.ToString(args.targetMapID),
			LogUtility.ToString(args.targetBPID)),
		LogUtility.StringFormat("targetPos={0}\n distance={1}\n npcID={2}", 
			args.targetPos,
			LogUtility.ToString(args.distance),
			LogUtility.ToString(args.npcID)),
		LogUtility.StringFormat("npcUID={0}\n groupID={1}\n skillID={2}", 
			LogUtility.ToString(args.npcUID),
			LogUtility.ToString(args.groupID),
			LogUtility.ToString(args.skillID)))
	-- if nil ~= args.targetPos and type(args.targetPos) == "table" then
	-- 	errorLog(string.format("MissionCommandFactory.CreateCommand args.targetPos is table, not Vector3"))
	-- 	if nil == args.targetPos.x or nil == args.targetPos.y or args.targetPos.z then
	-- 		TableUtil.Array2Vector3(args.targetPos)
	-- 	end
	-- end

	local currentMapID = Game.MapManager:GetMapID()
	if nil == currentMapID then
		return nil
	end
	if nil == args.targetMapID then
		args.targetMapID = currentMapID
	end

	if currentMapID ~= args.targetMapID then
		-- outter
		if(not Table_Map[currentMapID])then
			return nil
		end

		local disableOutterTeleport = Table_Map[currentMapID].LeapsMapNavigation
		if nil ~= disableOutterTeleport and 0 ~= disableOutterTeleport then
			-- show message 52
			MsgManager.ShowMsgByIDTable(52)
			return nil
		end

		disableOutterTeleport = Table_Map[args.targetMapID].LeapsMapNavigation
		if nil ~= disableOutterTeleport and 0 ~= disableOutterTeleport then
			-- show message 51
			MsgManager.ShowMsgByIDTable(51)
			return nil
		end

		-- if not WorldTeleport.CanArriveMap(currentMapID, args.targetMapID) then
			-- this block is going to delete
			-- local entranceNPCUID = Table_Map[args.targetMapID].EntranceNpc
			-- if nil ~= entranceNPCUID then
			-- 	local entranceMapID = Table_Map[args.targetMapID].NpcMapID
			-- 	local newArgs = {}
			-- 	newArgs.callback = args.callback
			-- 	newArgs.custom = args.custom
			-- 	newArgs.targetMapID = entranceMapID
			-- 	newArgs.npcUID = entranceNPCUID
			-- 	args = newArgs
			-- 	cmdClass = MissionCommandVisitNpc
			-- else
			-- 	local exitNPCUID = Table_Map[currentMapID].ExitNpc
			-- 	if nil ~= exitNPCUID then
			-- 		newArgs = {}
			-- 		newArgs.callback = args.callback
			-- 		newArgs.custom = args.custom
			-- 		newArgs.customDeleter = args.customDeleter
			-- 		newArgs.targetMapID = currentMapID
			-- 		newArgs.npcUID = exitNPCUID
			-- 		args = newArgs
			-- 		cmdClass = MissionCommandVisitNpc
			-- 	end
			-- end
		-- else
			local npcUID, npcMapID, npcToMapID = WorldTeleport.GetTransitNPCInfo(currentMapID, args.targetMapID)
			if nil ~= npcUID and nil ~= npcMapID then
				local newArgs = tempArgs
				newArgs.callback = args.callback
				newArgs.custom = args.custom
				newArgs.customDeleter = args.customDeleter
				newArgs.customType = args.customType
				newArgs.targetMapID = npcMapID
				newArgs.teleportMapID = npcToMapID
				newArgs.realTargetMapID = args.targetMapID
				newArgs.npcUID = npcUID
				args = newArgs
				cmdClass = MissionCommandVisitNpc
			end
		-- end
	else
		-- inner
		if nil == args.targetPos and nil == args.npcUID then
			return nil
		end

		-- allow inner navigation 2016.11.4.
		-- local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
		-- if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
		-- 	-- show message 50
		-- 	MsgManager.ShowMsgByIDTable(50)
		-- 	return nil
		-- end
	end
	local cmd = ReusableObject.Create( cmdClass, true, args )
	TableUtility.TableClear(tempArgs)
	return cmd
end