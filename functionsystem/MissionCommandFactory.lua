MissionCommandFactory = class("MissionCommandFactory")
local tempArgs = {}
function MissionCommandFactory.CreateCommand(args, cmdClass)
  LogUtility.InfoFormat([[
<color=green>MissionCommandFactory.CreateCommand</color> {0}
 {1}
 {2}]], LogUtility.StringFormat([[
cmdClass={0}, args:
 targetMapID={1}
 targetBPID={2}]], cmdClass.__cname, LogUtility.ToString(args.targetMapID), LogUtility.ToString(args.targetBPID)), LogUtility.StringFormat([[
targetPos={0}
 distance={1}
 npcID={2}]], args.targetPos, LogUtility.ToString(args.distance), LogUtility.ToString(args.npcID)), LogUtility.StringFormat([[
npcUID={0}
 groupID={1}
 skillID={2}]], LogUtility.ToString(args.npcUID), LogUtility.ToString(args.groupID), LogUtility.ToString(args.skillID)))
  local currentMapID = Game.MapManager:GetMapID()
  if nil == currentMapID then
    return nil
  end
  if nil == args.targetMapID then
    args.targetMapID = currentMapID
  end
  if currentMapID ~= args.targetMapID then
    if not Table_Map[currentMapID] then
      return nil
    end
    local disableOutterTeleport = Table_Map[currentMapID].LeapsMapNavigation
    if nil ~= disableOutterTeleport and 0 ~= disableOutterTeleport then
      MsgManager.ShowMsgByIDTable(52)
      return nil
    end
    disableOutterTeleport = Table_Map[args.targetMapID].LeapsMapNavigation
    if nil ~= disableOutterTeleport and 0 ~= disableOutterTeleport then
      MsgManager.ShowMsgByIDTable(51)
      return nil
    end
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
  elseif nil == args.targetPos and nil == args.npcUID then
    return nil
  end
  local cmd = ReusableObject.Create(cmdClass, true, args)
  TableUtility.TableClear(tempArgs)
  return cmd
end
