HandNpcData = reusableClass("HandNpcData",CreatureDataWithPropUserdata)
HandNpcData.PoolSize = 10

-- override begin
function HandNpcData:DoConstruct(asArray, serverData)
	HandNpcData.super.DoConstruct(self,asArray,serverData)
	self:SetData(serverData)
end

function HandNpcData:DoDeconstruct(asArray)
	HandNpcData.super.DoDeconstruct(self,asArray)
end
-- override end

function HandNpcData:GetDressParts()
	local parts = Asset_Role.CreatePartArray()
	parts[Asset_Role.PartIndex.Body] = self.body or 0
	parts[Asset_Role.PartIndex.Hair] = self.hair or 0
	parts[Asset_Role.PartIndex.LeftWeapon] = 0
	parts[Asset_Role.PartIndex.RightWeapon] = 0
	parts[Asset_Role.PartIndex.Head] = self.head or 0
	parts[Asset_Role.PartIndex.Wing] = 0
	parts[Asset_Role.PartIndex.Face] = 0
	parts[Asset_Role.PartIndex.Tail] = 0
	parts[Asset_Role.PartIndex.Eye] = self.eye or 0
	parts[Asset_Role.PartIndex.Mouth] = 0
	parts[Asset_Role.PartIndex.Mount] = 0
	parts[Asset_Role.PartIndexEx.Gender] = 0
	parts[Asset_Role.PartIndexEx.HairColorIndex] = self.haircolor or 0
	parts[Asset_Role.PartIndexEx.EyeColorIndex] = 0

	return parts
end
local ID = 1
function HandNpcData:SetData(serverData)
	if(serverData.guid==0) then
		self.id = ID
		ID = ID +1
	else
		self.id = serverData.guid
	end
	self.name = serverData.name or ""
	self.body = serverData.body
	self.head = serverData.head
	self.hair = serverData.hair
	self.haircolor = serverData.haircolor
	self.eye = serverData.eye
	self.speffect = serverData.speffect
end

function HandNpcData:GetName()
	return self.name
end