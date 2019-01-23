CampHandler = class("CampHandler")

if(CampHandler.CampPriority==nil) then
	--阵营获取的优先级，按位做，从低到高
	CampHandler.CampPriority = 
	{
		SelfTransformedAtk = {priority = 0,camp = RoleDefines_Camp.ENEMY},
		OtherTransformedAtk = {priority = 1,camp = RoleDefines_Camp.ENEMY},
		SameTeam = {priority = 2,camp = RoleDefines_Camp.FRIEND},
		PVPScene = {priority = 3,camp = RoleDefines_Camp.ENEMY},
		SameGuild = {priority = 4,camp = RoleDefines_Camp.FRIEND},
		GVGScene = {priority = 5,camp = RoleDefines_Camp.ENEMY},
		Normal = {priority = 6,camp = RoleDefines_Camp.FRIEND},
	}

	CampHandler.BitIndexs = {}
	CampHandler.BitMapCamp = {}

	for k,v in pairs(CampHandler.CampPriority) do
		CampHandler.BitIndexs[#CampHandler.BitIndexs + 1] = v.priority
		CampHandler.BitMapCamp[v.priority] = v.camp
	end
	table.sort(CampHandler.BitIndexs)
end

function CampHandler:ctor(defaultCamp)
	self.defaultCamp = defaultCamp
	self:Reset()
end

function CampHandler:SetBitValue(bit,val)
	local newValue = self.value
	if(val) then
		newValue = BitUtil.setbit(self.value,bit)
	else
		newValue = BitUtil.unsetbit(self.value,bit)
	end
	if(newValue~=self.value) then
		self.value = newValue
		self.dirty = true
	end
end

function CampHandler:Reset()
	self.dirty = false
	self.camp = self.defaultCamp ~=nil and self.defaultCamp or RoleDefines_Camp.FRIEND
	self.value = 0
	if(self.defaultCamp == nil) then
		self:SetBitValue(CampHandler.CampPriority.Normal.priority,true)
	end
end

function CampHandler:GetCamp()
	if(self.dirty) then
		self.dirty = false
		local index
		for i=1,#CampHandler.BitIndexs do
			index = CampHandler.BitIndexs[i]
			if(BitUtil.valid(self.value,index)) then
				if(BitUtil.band(self.value,index)>0) then
					self.camp = CampHandler.BitMapCamp[index]
					break
				end
			end
		end
	end
	return self.camp
end

function CampHandler:SetIsInPvpScene(val)
	self:SetBitValue(CampHandler.CampPriority.PVPScene.priority,val)
end

function CampHandler:SetIsSelfTransformedAtk(val)
	self:SetBitValue(CampHandler.CampPriority.SelfTransformedAtk.priority,val)
end

function CampHandler:SetIsOtherTransformedAtk(val)
	self:SetBitValue(CampHandler.CampPriority.OtherTransformedAtk.priority,val)
end

function CampHandler:SetIsSameTeam(val)
	self:SetBitValue(CampHandler.CampPriority.SameTeam.priority,val)
end

function CampHandler:SetIsSameGuild(val)
	self:SetBitValue(CampHandler.CampPriority.SameGuild.priority,val)
end

function CampHandler:SetIsInGVGScene(val)
	self:SetBitValue(CampHandler.CampPriority.GVGScene.priority,val)
end