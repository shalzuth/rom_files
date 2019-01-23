UILongPressManager = class("UILongPressManager")

function UILongPressManager:ctor()

end

function UILongPressManager:Update(time, deltaTime)
	if not self.isCheck then
		return
	end

	if self.posX and self.posY then
		local x,y = self:_GetTouchPos()
		if x and y then
			if math.abs(self.posX - x) > self.checkWidth or math.abs(self.posY - y) > self.checkHeight then
				self.isInRange = false
				if self.funcNotIn then
					self.funcNotIn()
				end
			else
				self.isInRange = true
				if self.funcIn then
					self.funcIn()
				end
			end
		end
	end
end

function UILongPressManager:StartCheck(width,height,funcIn,funcNotIn)
	-- self.isCheck = true
	self.checkWidth = width
	self.checkHeight = height
	self.funcIn = funcIn
	self.funcNotIn = funcNotIn
	self.posX,self.posY = self:_GetTouchPos()
end

function UILongPressManager:StopCheck()
	self.isCheck = false
end

function UILongPressManager:GetState()
	return true
	-- return self.isInRange
end

function UILongPressManager:_GetTouchPos()
	local x,y

	if ApplicationInfo.IsRunOnEditor() then
		x,y = LuaGameObject.GetMousePosition()
	else
		if Input.touchCount > 0 then
			x,y = LuaGameObject.GetTouchPosition(0,false)
		end
	end

	return x,y
end