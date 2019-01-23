local baseCell = autoImport("BaseCell")
BaseAttributeCell = class("BaseAttributeCell",baseCell)


function BaseAttributeCell:Init(  )
	-- body
	self:initView()
	self:addViewEventListener()
end


function BaseAttributeCell:addViewEventListener(  )
	-- body
	 self:AddCellClickEvent()
end

function BaseAttributeCell:SetData( data )
	-- body
	-- self.icon.spriteName = data.icon
	self.data = data
	-- [87FF00FF]
	-- printRed("BaseAttributeCell:SetData")	
	local total
	-- local append = ""
	local addPointAttr = ""
	local maxAddValue = ""
	local lastTotal = 0
	local value 
	local name

	if data~=nil and data.name~=nil and data.value~=nil then
		value = data.value
		name = data.name
	end	

	if(self.data.type == BaseAttributeView.cellType.normal)then
		-- printRed(data.prop.propVO.name)
		local props = Game.Myself.data.props
		local per =props[data.prop.propVO.name.."Per"]
		per = per and per:GetValue() or nil
		local maxPer = props["Max"..data.prop.propVO.name.."Per"]
		maxPer = maxPer and maxPer:GetValue() or nil
		
		local maxPropValue = props["Max"..data.prop.propVO.name]
		maxPropValue = maxPropValue and maxPropValue:GetValue() or 0
		if(not per)then
			per = 0
		end

		if(not maxPer)then
			maxPer = 0
		end

		local tmp = (data.prop:GetValue() - data.extraP:GetValue())*(1+per)
		if(data.prop.propVO.name == "Sp" or data.prop.propVO.name == "Hp")then
			addPointAttr = data.maxAddData or nil
		else
			addPointAttr = data.addData or nil
		end
		if(CommonFun.checkIsNoNeedPercent(data.prop.propVO.name))then
			total = data.prop:GetValue()
			maxPropValue = 	maxPropValue	
		else
			total = data.prop:GetValue() * (1+per)
		end	 
		lastTotal = total
		if(data.prop.propVO.name == "Sp" or data.prop.propVO.name == "Hp")then
			lastTotal = maxPropValue
		end
		-- if(tmp ~= 0 )then
		-- 	if(data.extraP.propVO.IsClientPercent)then
		-- 		append = "  [c][FF8A29]+"..math.floor(tmp*100).."%".."[-][/c]"
		-- 	else
		-- 		append = "  [c][FF8A29]+"..math.floor(tmp).."[-][/c]"
		-- 	end
		-- end
		-- printRed("data.prop.propVO.displayName",data.prop.propVO.displayName,addPointAttr)
		-- printRed("total:"..data.prop:GetValue()*(1+per))
		-- printRed("append:"..tmp)	
		-- printRed("base:"..base)
		-- printRed("per:"..per)
		-- if(addPointAttr)then
		-- 	printRed("add:"..addPointAttr)
		-- else
		-- 	printRed(nil)
		-- end
		-- if(addPointAttr and addPointAttr - lastTotal ~= 0)then
		if(addPointAttr and addPointAttr ~= 0)then
			-- addPointAttr = addPointAttr - lastTotal	
			if(data.prop.propVO.IsClientPercent) then
				if(math.floor(addPointAttr*1000) ~= 0)then
					if(addPointAttr>0)then
						addPointAttr = "  [c][FF8A29FF]+"..(math.floor(addPointAttr*1000)/10).."%".."[-][/c]"
					else
						addPointAttr = "  [c][FF8A29FF]"..(math.floor(addPointAttr*1000)/10).."%".."[-][/c]"
					end
				else
					addPointAttr = ""
				end
			else
				if(math.floor(addPointAttr) ~= 0)then
					if(addPointAttr>0)then
						addPointAttr = "  [c][FF8A29ff]+"..math.floor(addPointAttr).."[-][/c]"
					else
						addPointAttr = "  [c][FF8A29ff]"..math.floor(addPointAttr).."[-][/c]"
					end
				else
					addPointAttr = ""
				end
				
			end
		else
			addPointAttr = ""
		end

		if(data.prop.propVO.IsClientPercent) then
			local tmp = (math.floor(total*1000)/10)
			if(tmp == 0)then
				total = "0%"
			else
				total = tmp.."%"
			end
		else
			total = math.floor(total)
		end	
		if(data.prop.propVO.name == "Sp" or data.prop.propVO.name == "Hp")then
			maxPropValue = math.floor(maxPropValue)
			value = maxPropValue..addPointAttr -- total.."/"..
			name = data.prop.propVO.name
		else
			value = total..addPointAttr
			name = data.prop.propVO.displayName
		end
		if(self.checkBoxCt)then
			if(data.prop.propVO.name == "SaveHp" or data.prop.propVO.name == "SaveSp")then
				self:Show(self.checkBoxCt)				
				self:PassEvent(InfomationPage.CheckHasSelected,self)
			else
				self:Hide(self.checkBoxCt)
			end
		end

		if(data.prop.propVO.name == "SlimHeight")then
			local _,scaleY = Game.Myself:GetScaleWithFixHW()
			value = (math.floor(scaleY*100)).."%"

			if(scaleY > 1)then
				value = ZhString.Charactor_SlimHeightDes_L..value
			elseif(scaleY == 1)then
				value = ZhString.Charactor_SlimDes_Nomal..value
			else
				value = ZhString.Charactor_SlimHeightDes_S..value
			end
		end

		if(data.prop.propVO.name == "SlimWeight")then
			local scaleX = Game.Myself:GetScaleWithFixHW()
			value = (math.floor(scaleX*100)).."%"
		
			if(scaleX > 1)then
				value = ZhString.Charactor_SlimWeightDes_L..value
			elseif(scaleX == 1)then
				value = ZhString.Charactor_SlimDes_Nomal..value
			else
				value = ZhString.Charactor_SlimWeightDes_S..value
			end
		end

	elseif(self.data.type == BaseAttributeView.cellType.jobBase)then
		value = self.data.value
		name = self.data.name
		if(self.checkBoxCt)then
			self:Hide(self.checkBoxCt)
		end
	elseif(self.data.type == BaseAttributeView.cellType.saveHpSp)then
		value = self.data.value
		name = ""
		if(self.checkBoxCt)then
			self:Hide(self.checkBoxCt)
		end
	elseif(self.data.type == BaseAttributeView.cellType.fixed)then
		total = data.prop:GetValue()
		if(data.prop.propVO.IsClientPercent) then	
			local tmp = (math.floor(total*1000)/10)
			if(tmp == 0)then
				total = "0%"
			else
				total = tmp.."%"
			end
		else
			total = math.floor(total)
		end	
		total = "+"..total

		if(data.prop.propVO.name == "Sp" or data.prop.propVO.name == "Hp")then
			maxPropValue = math.floor(maxPropValue)
			value = total.."/"..maxPropValue..addPointAttr
			name = data.prop.propVO.name
		else
			value = total..addPointAttr
			name = data.prop.propVO.displayName
		end
		if(self.checkBoxCt)then
			self:Hide(self.checkBoxCt)
		end
	end
	self.value.text = value
	self.name.text = name
	--todo xde fix ui 
	self.value.fontSize = 22
	self.name.fontSize = 22
	if string.len(self.name.text) > 0 then
		self.value.transform.localPosition = Vector3(225,0,0)
	end
	if(self.checkboxAnchor)then
		self.checkboxAnchor:UpdateAnchors()
	end
	-- todo xde Ref Dmg Reduc 等情况时调整字体和对齐
	local specialNames = {

	}
	if (self.data.type == BaseAttributeView.cellType.normal or self.data.type == BaseAttributeView.cellType.fixed) and self.name.transform.parent.name == 'BaseAttrCell_' then
		self.name.alignment = 1
		self.name.transform.localPosition = Vector3(44,0,0)
		if data.prop.propVO.displayName == GameConfig.EquipEffect.RefineDamReduc or
			data.prop.propVO.displayName == GameConfig.EquipEffect.RefineMDamReduc or
			data.prop.propVO.displayName == OverSea.LangManager.Instance():GetLangByKey("受到治疗加成") or
			data.prop.propVO.displayName == GameConfig.EquipEffect.MRefine or
			data.prop.propVO.displayName == OverSea.LangManager.Instance():GetLangByKey("魔法伤害减免")
		 then 
			self.name.overflowMethod = 1 -- Shrink Content
			self.name.width = 210
			self.name.transform.localPosition = Vector3(80,0,0)
		else
			-- printData('data.prop.propVO.displayName', data.prop.propVO.displayName)
		end
	end
end

function BaseAttributeCell:initView(  )
	-- body
	self.name = self:FindChild("name"):GetComponent(UILabel)
	self.value = self:FindChild("value"):GetComponent(UILabel)
	self.line = self:FindGO("line")
	self.checkBox = self:FindComponent("selectedBg",UIToggle)
	self.checkBoxCt = self:FindGO("checkBox")
	self:AddButtonEvent("checkBox",function (  )
		-- body
		self:PassEvent(InfomationPage.HasSelectedChange, self)
	end)
	self.checkboxAnchor = self:FindComponent("checkBox",UIWidget)
end

function BaseAttributeCell:setIsSelected( bRet )
	if(bRet)then
		self.checkBox.value = true
	else
		self.checkBox.value = false
	end
end

function BaseAttributeCell:greyValueText(  )
	self.value.text = "[c][454545FF]"..self.data.value.."[-][/c]"
end

function BaseAttributeCell:whiteValueText(  )
	self.value.text = self.data.value
end

function BaseAttributeCell:IsSelected(  )
	return self.checkBox.value
end

function BaseAttributeCell:ChangeValueDepth(depth )
	self.value.depth = depth
end	

function BaseAttributeCell:ChangeNameDepth(depth )
	self.name.depth = depth
end	

function BaseAttributeCell:ChangeValueFontSize(size )
	self.value.fontSize = size
end	

function BaseAttributeCell:ChangeNameFontSize(size )
	self.name.fontSize = size
end	

function BaseAttributeCell:ChangeValueColor(color )
	self.value.color = color
end	

function BaseAttributeCell:ChangeNameColor(color )
	self.name.color = color
end	

function BaseAttributeCell:ChangeValueLocalPos(pos )
	self.value.gameObject.transform.localPosition = pos
end	

function BaseAttributeCell:ChangeNameLocalPos(pos )
	self.value.gameObject.transform.localPosition = pos
end	



function BaseAttributeCell:HideLine()
	self.line.gameObject:SetActive(false)
end	