local LoginInitCommand = class("LoginInitCommand", pm.SimpleCommand)

function LoginInitCommand:execute(note)
	local data = note.body
	self:Init()
end

function LoginInitCommand:Init()
	-- init package data	
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_EQUIP)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FASHIONEQUIP)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_MAIN)
	-- ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FASHION)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_STORE)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_PERSONAL_STORE)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_BARROW)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_QUEST or 10)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_FOOD or 11)
	-- ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_CARD)
	ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_TEMP_MAIN)
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
	FunctionGuide.Me():stopGuide(  )
	-- ServiceNUserProxy.Instance:CallNewDressing()
	ServiceNUserProxy.Instance:CallQueryShortcut() 
end

return LoginInitCommand