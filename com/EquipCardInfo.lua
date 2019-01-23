EquipCardInfo = class("EquipCardInfo")

function EquipCardInfo:ctor(serverData)
	self.guid = serverData.guid
	self.id = serverData.id
	self.staticData = Table_Card[self.id]
end