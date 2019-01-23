local BaseCell = autoImport("BaseCell")
PlayerAttriButeCell = class("PlayerAttriButeCell", BaseCell)

function PlayerAttriButeCell:Init(  )
	self.name = self:FindChild("name"):GetComponent(UILabel)
	self.value = self:FindChild("value"):GetComponent(UILabel)
	self.line = self:FindGO("line")

	self:AddCellClickEvent();
end

function PlayerAttriButeCell:SetData( data )
	self.data = data;

	if(data)then
		local playerData = data.playerData;
		local propVO = data.prop.propVO;

		local name, value, total;
		
		if(CommonFun.checkIsNoNeedPercent(data.prop.propVO.name))then
			total = data.prop:GetValue()
		else
			local perProKey = string.format("%sPer", propVO.name);
			local perPropVO,perPropValue = playerData.props[perProKey], 0;
			if(perPropVO)then
				perPropValue = perPropVO:GetValue() or 0;
			end
			total = data.prop:GetValue() * (1 + perPropValue);
		end	 

		if(propVO.IsClientPercent) then	
			local tmp = (math.floor(total*1000)/10)
			total = tmp.."%"
		else
			total = math.floor(total)
		end

		if(propVO.name == "Sp" or propVO.name == "Hp")then
			local maxProKey = string.format("Max%s", propVO.name);
			local maxPropVO,maxPropValue = playerData.props[maxProKey], 0;
			if(maxPropVO)then
				maxPropValue = maxPropVO:GetValue() or 0;
			end
			maxPropValue = math.floor(maxPropValue)
			value = string.format("%s/%s", total, maxPropValue);
			name = propVO.name
		else
			value = total
			name = propVO.displayName
		end 

		self.value.text = value
		self.name.text = name
	end
	
	--todo xde
	self.name.fontSize = 22
	self.value.fontSize = 22
	self.name.pivot = UIWidget.Pivot.Left
	OverseaHostHelper:FixLabelOverV1(self.name,3,210)
end












