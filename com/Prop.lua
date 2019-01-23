autoImport("PropVO")

Prop = class("Prop")

Prop.PercentFactor = 100
Prop.FixPercent = 1000

function Prop:ctor(propVO)
	self.value = propVO~=nil and propVO.defaultValue or 0
	self:SetConfig(propVO)
end

function Prop:GetValue()
	if(self.propVO==nil) then
		return 0
	end
	-- print(self.propVO.valueType)
	if(self.propVO.valueType == PropValueType.Bool) then
		return (self.value == 1)
	else 	
		local v = self.value
		if(self.propVO.isPercent or self.propVO.isSyncFloat) then
			v= self.value / Prop.FixPercent
		end
		if(self.propVO.valueType == PropValueType.Float) then
			return v
		elseif(self.propVO.valueType == PropValueType.Int) then
			return math.floor(v)
		end
	end
end

function Prop:SetValue(v)
	local old = self.value
	if(self.propVO.valueType == PropValueType.Float) then
		self.value = v
	elseif(self.propVO.valueType == PropValueType.Int) then
		self.value = math.floor(v)
	elseif(self.propVO.valueType == PropValueType.Bool) then
		self.value = v
	end
	return old
end

function Prop:ValueToString(percent)
	percent = percent or "%"
	local value = self.value
	if(self.propVO.isPercent) then
		local p = Prop.FixPercent/Prop.PercentFactor
		value = math.floor(value/p)..percent
		-- print("prop:"..self.propVO.displayName.." value:"..value)
		-- value = math.floor(value*Prop.PercentFactor).."%"
	else
		return math.floor(value)
	end
	return value
end

function Prop:SetConfig(propVO)
	self.propVO = propVO
end

function Prop:ResetValue()
	self.value = self.propVO~=nil and self.propVO.defaultValue or 0
end

-- return Prop