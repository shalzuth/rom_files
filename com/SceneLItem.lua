SceneLItem = class('SceneLItem',ReusableObject)

function SceneLItem:ctor()
	SceneLItem.super.ctor(self)
end

function SceneLItem:ResetData( guid,staticData,equipStaticData,pos)
	self.id = guid
	self.staticData = staticData
	self.equipStaticData = equipStaticData
	self.pos = PosUtil.DevideVector3(pos.x,pos.y,pos.z)
end

-- return Creature