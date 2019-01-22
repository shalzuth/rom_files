local baseCell = autoImport("BaseCell")

AttributePointModifyCell = class("AttributePointModifyCell",baseCell)


function AttributePointModifyCell:Init(  )
	-- body
	self:initView()
	self:addViewEventListener()
	self.needNum = 0
	self.originRealPoint = 0
	self.autoRealPoint = 0
	self.originTimeOfAdd = 0
	self.timeOfAdd = 0
	self.leftPoint = nil
end

function AttributePointModifyCell:initView(  )
	-- body
	self.cellName = self:FindGO("cellName"):GetComponent(UILabel)
	self.point = self:FindGO("point"):GetComponent(UILabel)
	self.extra = self:FindGO("extra"):GetComponent(UILabel)
	self.currentAdd = self:FindGO("currentAdd"):GetComponent(UILabel)
	self.needNumLabel = self:FindGO("needNum"):GetComponent(UILabel)

	self.addBtnCollider = self:FindGO("plusBg"):GetComponent(BoxCollider)
	self.reduceBtnCollider = self:FindGO("reduceBg"):GetComponent(BoxCollider)
	self.neddNumIndicator = self:FindGO("neddNumIndicator")
	self.reduceBg = self:FindGO("reduceBg"):GetComponent(UISprite)
	self.plusBg = self:FindGO("plusBg"):GetComponent(UISprite)
end

function AttributePointModifyCell:addViewEventListener(  )
	-- body
	local btn = self:FindGO("reduceBg")
	self:SetEvent(btn,function (  )
		-- body	
		self:reducePointAction()
	end)

	self.reduceLongPress = btn:GetComponent(UILongPress)	
	local longPressFun = function (obj,state)
		if(state)then
			TimeTickManager.Me():CreateTick(0,50,self.reducePointAction,self)
		else
			TimeTickManager.Me():ClearTick(self)
		end
 	end
    self.reduceLongPress.pressEvent = longPressFun

	btn = self:FindChild("plusBg")
	self:SetEvent(btn,function (  )
		-- body		
		self:addPointAction()
	end)

	self.addLongPress = btn:GetComponent(UILongPress)	
	longPressFun = function (obj,state)
		if(state)then
			TimeTickManager.Me():CreateTick(0,50,self.addPointAction,self)
		else
			TimeTickManager.Me():ClearTick(self)
		end
 	end
    self.addLongPress.pressEvent = longPressFun
end

function AttributePointModifyCell:reducePointAction(  )
	-- body
	local attrTabel = Table_AttributePoint[self.originTimeOfAdd + self.timeOfAdd]
	self.timeOfAdd = self.timeOfAdd - 1
	self.leftPoint.currentLeftPoint = self.leftPoint.currentLeftPoint + attrTabel.NeedPoint
	self:PassEvent(MouseEvent.MouseClick)
end

function AttributePointModifyCell:addPointAction(  )
	-- body	
	self.timeOfAdd = self.timeOfAdd + 1
	self.leftPoint.currentLeftPoint = self.leftPoint.currentLeftPoint - self.needNum
	self:PassEvent(MouseEvent.MouseClick)	
end

function AttributePointModifyCell:updateLeftPoint(  )
	-- body
	local canAddPoint

	local attrTabel = Table_AttributePoint[self.originTimeOfAdd + self.timeOfAdd+1]
	if(attrTabel ~=nil)then
		canAddPoint = true	
		self.needNum = attrTabel.NeedPoint
		self.needNumLabel.text = tostring(self.needNum)
	else
		canAddPoint = false
		-- MsgManager.FloatMsg(nil,"????????????????????????????????????Table_AttributePoint???~")
	end
	canAddPoint = canAddPoint and self.leftPoint.currentLeftPoint >= self.needNum
	-- if(self.timeOfAdd + self.data.extraP:GetValue() >=GameConfig.System.maxattrpoint) then
	-- 	canAddPoint = false
	-- end
	if(canAddPoint)then
		self.plusBg.color = Color(1,1,1,1)
		self.addBtnCollider.enabled = true
		self.addLongPress.enabled = true		
		self:Show(self.neddNumIndicator)
	else
		self.plusBg.color = Color(1,1,1,0.5)		
		self.addBtnCollider.enabled = false
		self.addLongPress.enabled = false
		self:Hide(self.neddNumIndicator)		
	end

	if(self.timeOfAdd>0)then
		self.reduceBg.color = Color(1,1,1,1)
		self.reduceBtnCollider.enabled = true
		self.reduceLongPress.enabled = true
	else
		self.reduceBg.color = Color(1,1,1,0.5)		
		self.reduceBtnCollider.enabled = false
		self.reduceLongPress.enabled = false
	end	
	-- printRed("data.prop.propVO.displayName:"..self.data.prop.propVO.displayName)
	-- print(canAddPoint)
	-- print(self.timeOfAdd)
	-- printRed("end")
	self.currentAdd.text = self.timeOfAdd == 0 and "" or "+"..self.timeOfAdd
end

-- function function_name( ... )
-- 	-- body
-- end

function AttributePointModifyCell:addPoint( num )
	-- body
	local complete = true
	for i=1,num do
		local attrTabel = Table_AttributePoint[self.originTimeOfAdd + self.timeOfAdd+1]
		if(attrTabel ~= nil)then	
			local needNum = attrTabel.NeedPoint
			if(self.leftPoint.currentLeftPoint >= needNum)then
				self.timeOfAdd = self.timeOfAdd + 1
				self.autoRealPoint = self.autoRealPoint +1
				self.leftPoint.currentLeftPoint = self.leftPoint.currentLeftPoint - needNum
			else
				return 1
			end
		else
			-- MsgManager.FloatMsg(nil,"????????????????????????????????????Table_AttributePoint???~")
			return 1
		end			
	end
	return 0
end

function AttributePointModifyCell:resetSolution(  )
	-- body
	for i=1,self.autoRealPoint do		
		local attrTabel = Table_AttributePoint[self.originTimeOfAdd + self.timeOfAdd]
		if(attrTabel ~=nil)then	
			local needNum = attrTabel.NeedPoint
			self.timeOfAdd = self.timeOfAdd - 1
			self.autoRealPoint = self.autoRealPoint - 1
			self.leftPoint.currentLeftPoint = self.leftPoint.currentLeftPoint + needNum
		else
			-- MsgManager.FloatMsg(nil,"????????????????????????????????????Table_AttributePoint???~")
			return	
		end
	end	
	self.autoRealPoint = 0
	self:PassEvent(MouseEvent.MouseClick)
end

function AttributePointModifyCell:resetTimeOfAdd(  )
	-- body
	for i=1,self.timeOfAdd do		
		local attrTabel = Table_AttributePoint[self.originTimeOfAdd + self.timeOfAdd]
		if(attrTabel ~=nil)then	
			local needNum = attrTabel.NeedPoint
			self.timeOfAdd = self.timeOfAdd - 1
			self.leftPoint.currentLeftPoint = self.leftPoint.currentLeftPoint + needNum
		else
			-- MsgManager.FloatMsg(nil,"????????????????????????????????????Table_AttributePoint???~")
			return	
		end
	end
	self.autoRealPoint = 0
	self:updateLeftPoint()
end

function AttributePointModifyCell:clearTimeOfAdd(  )
	-- body
	self.timeOfAdd = 0
	self.autoRealPoint = 0
end

function AttributePointModifyCell:GetAttrName(  )
	-- body
	if(self.data and self.data.prop and self.data.prop.propVO)then
		return self.data.prop.propVO.name
	end
end

function AttributePointModifyCell:SetData( data )
	-- body
	-- self.data = data
	-- self.leftPoint = data.leftPoint
	-- self.cellName.text = data.prop.propVO.displayName..data.prop.propVO.name		
	-- self.originRealPoint = self.data.prop:GetValue() - self.data.extraP:GetValue()
	-- self.extra.text = self.originRealPoint == 0 and "" or "+"..self.originRealPoint 
	-- self.point.text = data.extraP:GetValue()
	-- self.originTimeOfAdd = data.timeOfAdd
	-- self:updateLeftPoint()
	-- if(self.data.prop.propVO.id == 100)then
	-- 	self:AddOrRemoveGuideId(self.plusBg.gameObject,6)
	-- else
	-- 	self:AddOrRemoveGuideId(self.plusBg.gameObject)
	-- end
	self.data = data
	self.leftPoint = data.leftPoint
    -- todo xde start ??????????????????(Vit, Int???)
    -- self.cellName.text = data.prop.propVO.displayName..data.prop.propVO.name
    self.cellName.text = data.prop.propVO.name
    -- todo xde end
	self.originTimeOfAdd = data.timeOfAdd
	self.originRealPoint = self.data.prop:GetValue() - self.data.extraP:GetValue()
	local extra = self.data.prop:GetValue() - self.originTimeOfAdd
	if(extra==0)then
		self.extra.text = ""
	elseif(extra >0)then
		self.extra.text = "+"..extra
	else
		self.extra.text = extra
	end
	self.point.text = self.originTimeOfAdd
	self:updateLeftPoint()
	if(self.data.prop.propVO.id == 100)then
		self:AddOrRemoveGuideId(self.plusBg.gameObject,6)
	else
		self:AddOrRemoveGuideId(self.plusBg.gameObject)
	end
end