local ReconnInitCommand = class("ReconnInitCommand", pm.SimpleCommand)

function ReconnInitCommand:execute(note)
	local data = note.body
	self:Init()
end

function ReconnInitCommand:Init()
	-- FunctionCameraAdditiveEffect.Me():Shutdown()
	-- FunctionCameraEffect.Me():Shutdown()
	-- Game.Myself:Client_SetMissionCommand(nil)
	if(Game.Myself)then
		-- 重置牵手
		Game.Myself:Client_ClearFollower();
		Game.Myself:Server_SetHandInHand(
			Game.Myself:Client_GetFollowLeaderID(), 
			false);
	end

	-- init package data	
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_EQUIP)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FASHIONEQUIP)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_MAIN)
	-- ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FASHION)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_STORE)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_PERSONAL_STORE)
	-- ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_CARD)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_TEMP_MAIN)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_QUEST or 10)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FOOD or 11)

	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_FASHION)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_CARD)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_EQUIP)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_ITEM)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_MOUNT)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_MONSTER)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_PET)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_NPC)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_MAP)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_SCENERY)
	ServiceSceneManualProxy.Instance:CallQueryManualData(SceneManual_pb.EMANUALTYPE_COLLECTION)
		
	ServiceNUserProxy.Instance:CallQueryShopGotItem()
	ServiceNUserProxy.Instance:CallNewDressing()
	FunctionGuide.Me():stopGuide(  )
	FunctionCheck.Me():Reset()
	FloatingPanel.Instance:CloseMaintenanceMsg()
	ComboCtl.Instance:Clear()
	QuestProxy.Instance:CleanAllQuest(  )
end

return ReconnInitCommand