autoImport("PropsContainer")

EquipProps = class("EquipProps",PropsContainer)

function EquipProps:ctor()
	EquipProps.super.ctor(self)
	self.cacheEffect = nil
	self.wholeEffectCount = 0
	self.configs = UserProxy.Instance.creatureProps
end

function EquipProps:CreateByConfig(effects,factor)
	self:ResetCount()
	factor = factor or 1
	self.cacheEffect = effects
	for k,v in pairs(self.cacheEffect) do
		self:SetValueByName(k,v * factor)
	end
end

function EquipProps:Multiply(factor)
	local p
	for k,v in pairs(self.cacheEffect) do
		p = self:GetPropByName( k )
		if(p~=nil) then
			p.value = p.value * factor
		end
	end
end

function EquipProps:Add(equipProps,justSame)
	local selfP,otherP
	if(justSame) then self:ResetCount() end
	for k,v in pairs(equipProps.cacheEffect) do
		otherP = equipProps:GetPropByName( k )
		selfP = self:GetPropByName( k )
		if(otherP) then
			if(selfP) then
				self:CountProp(k)
				-- print(v.name,selfP.value , otherP.value,tostring(justSame))
				selfP.value = selfP.value + otherP.value
			elseif(not justSame) then
				self:SetValueByName(k,otherP.value)
			end
		end
	end
end

function EquipProps:ResetCount()
	self.cacheWholeEffectName = {}
	self.wholeEffectCount = 0
end

function EquipProps:CountProp(name)
	if(not self.cacheWholeEffectName[name]) then
		self.cacheWholeEffectName[name] = name
		self.wholeEffectCount = self.wholeEffectCount + 1
	end
end

function EquipProps:SetValueByName( name,value )
	self:CountProp(name)
	-- print("set:",name,value)
	EquipProps.super.SetValueByName(self,name,value)
end

function EquipProps:ToString(sperator,newLine)
	sperator = sperator or ":"
	newLine = newLine or "\n"
	local res = ""
	local count = self.wholeEffectCount
	local i=0
	local prop
	for k,v in pairs(self.cacheWholeEffectName) do
		i = i + 1
		prop = self[v]
		res = res..prop.propVO.displayName..sperator..prop:ValueToString()..(i~=count and newLine or "")
		-- res = res..GameConfig.EquipEffect[v]..sperator..self[v]:ValueToString()..(i~=count and newLine or "")
	end
	return res
end