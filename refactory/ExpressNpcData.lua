ExpressNpcData = reusableClass("ExpressNpcData",CreatureDataWithPropUserdata)
ExpressNpcData.PoolSize = 10

-- override begin
function ExpressNpcData:DoConstruct(asArray, serverData)
	ExpressNpcData.super.DoConstruct(self,asArray,serverData)
	self:SetData(serverData)
end

function ExpressNpcData:DoDeconstruct(asArray)
	ExpressNpcData.super.DoDeconstruct(self,asArray)
	self.staticData = nil
end
-- override end

function ExpressNpcData:GetDressParts()
	return NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.staticData)
end

function ExpressNpcData:SetData(serverData)
	if self.staticData==nil then
		self.staticData = Table_Npc[serverData.npcid]
	end
	self.dressEnable = true
	self.id = serverData.guid
	self.giveid = serverData.giveid
	self.expiretime = serverData.expiretime
	self.type=serverData.type
end

function ExpressNpcData:GetName()
	return self.staticData.NameZh
end

function ExpressNpcData:IsNpc()
	return true
end

function ExpressNpcData:IsMonster()
	return false
end

function ExpressNpcData:GetFollowEP()
	return RoleDefines_EP.Bottom
end