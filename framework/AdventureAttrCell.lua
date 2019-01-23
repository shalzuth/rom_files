local baseCell = autoImport("BaseCell")
AdventureAttrCell = class("AdventureAttrCell",baseCell)

function AdventureAttrCell:Init(  )
	-- body
	self:initView()
end

function AdventureAttrCell:initView()
	self.name = self:FindChild("name"):GetComponent(UILabel)
	self.value = self:FindChild("value"):GetComponent(UILabel)
end

function AdventureAttrCell:SetData( data )
	-- body
	local value = data.value
	local propStaticData = data.prop
	local name = propStaticData.PropName
	if(propStaticData.IsPercent == 1) then
		local tmp = string.format("%.1f",value*100)
		-- if(propStaticData.VarName == 'MAtkPer')then
		-- 	helplog("AdventureAttrCell:",value*1000,math.floor(value*1000),math.floor(100.0))
		-- end
		-- if(tmp == 0)then
		-- 	value = "0%"
		-- else
			value = tmp.."%"
		-- end
	else
		value = math.floor(value)
	end
	self.name.text = name
	self.value.text = "+"..value
end