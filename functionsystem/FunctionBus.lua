
FunctionBus = class("FunctionBus")

FunctionBus.SCREEN_EFFECT_DURATION = 1

function FunctionBus.Me()
	if nil == FunctionBus.me then
		FunctionBus.me = FunctionBus.new()
	end
	return FunctionBus.me
end

function FunctionBus:ctor()
	self:Reset()
end

function FunctionBus:Reset()
	self.bus = nil
	self.seat = nil
	self.role = nil
	self.running = false
	self.needAnim = true
end

function FunctionBus:ShowPhotographUI()
	if nil ~= self.bus then 
		self.bus:CaptureCameraBegin(CameraController.Instance)
	end
	-- Launch Photograph
	GameFacade.Instance:sendNotification(
		UIEvent.JumpPanel,
		{view = PanelConfig.PhotographPanel, viewdata = {cameraId=Table_Bus[self.busID].Camera},force=true})
	GameFacade.Instance:sendNotification(CarrierEvent.ShowUI)
end

function FunctionBus:ClosePhotographUI()
	GameFacade.Instance:sendNotification(UIEvent.CloseUI,PhotographPanel.ViewType)
	if nil ~= self.bus then 
		self.bus:CaptureCameraEnd()
	end
end

function FunctionBus:SetBusNil()
	if nil ~= self.bus then 
		self.bus:CaptureCameraEnd()
	end
	self.bus = nil
end

function FunctionBus:GetOn()
	if not self.running then
		return false
	end
	if nil == self.bus or Slua.IsNull(self.bus) then
		self:Reset()
		return false
	end
	if nil == self.role then
		self:Reset()
		return false
	end
	local seat = self.bus:GetSeat(self.seat)
	if seat == nil or Slua.IsNull(seat) then
		self:Reset()
		return false
	end
	

	print("坐载具上了")
	-- 0 setparent
	self.role:SetParent(seat.transform)
	-- 1 坐下
	self.role.assetRole:PlayAction_Sitdown()
	-- 2 去掉阴影
	self.role.assetRole:SetShadowEnable(false)
	-- 3 角度设0
	self.role:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY,0,true)

	if(not Game.MapManager:Previewing()) then
		self:ShowPhotographUI()
	else
		EventManager.Me():AddEventListener(PlayerEvent.CapturedCamera,self.ShowPhotographUI,self)
	end
end

function FunctionBus:GetOff(position)
	if not self.running then
		return
	end
	EventManager.Me():PassEvent(MyselfEvent.LeaveCarrier,self.bus)
	local busEnded = false
	if nil ~= self.role then
		FunctionSystem.WeakInterruptMyself()
		-- 1 阴影整回来
		self.role.assetRole:SetShadowEnable(true)
		-- 2 
		self.role:SetParent(nil)
		-- 3
		position = position or self.role:GetPosition()
		self.role:Client_PlaceXYZTo(position[1],position[2],position[3])
		if nil ~= self.bus and not Slua.IsNull(self.bus) then
			self.bus:End()
			busEnded = true
		end
	end
	if not busEnded and nil ~= self.bus and not Slua.IsNull(self.bus) then
		self.bus:End()
	end

	-- 1. Shutdown Photograph
	EventManager.Me():RemoveEventListener(PlayerEvent.CapturedCamera,self.ShowPhotographUI,self)
	self:ClosePhotographUI()

	-- 2.
	Game.AreaTriggerManager:SetIgnore(false)
	print("摧毁我自己乘坐的载具")
	if self.bus and not Slua.IsNull(self.bus.gameObject) then
		GameObject.Destroy(self.bus.gameObject)
	end
	self.bus = nil
	self:VisibleBus(self.busID,true)

	-- 3.
	if(self.callBackAfterGetOff) then
		self.callBackAfterGetOff()
		self.callBackAfterGetOff = nil
	end
end

function FunctionBus:VisibleBus(busID,value)
	local bus = BusManager.Instance:GetBus(busID)
	if(bus) then
		bus.gameObject:SetActive(value)
	end
end

function FunctionBus:Launch(bus,busID, seat,needAnim)
	if self.running then
		return
	end
	self.needAnim = needAnim
	local myself = Game.Myself
	if nil == myself then
		return
	end

	local busManager = BusManager.Instance
	if nil == busManager then
		return
	end

	self:VisibleBus(busID,false)
	if nil == bus then
		return
	end
	self.busID = busID
	self.bus = bus
	self.seat = seat
	self.role = myself
	self.running = true

	Game.AreaTriggerManager:SetIgnore(true)
	-- FunctionSystem.WeakInterruptMyself()
	FunctionSystem.InterruptMyself()

	FunctionCameraEffect.Me():Shutdown()
	if(self.needAnim) then
		print("walk to bus")

		myself:Client_MoveXYZTo(LuaGameObject.GetPosition(self.bus.transform))
		UIUtil.ShowScreenMask(
			FunctionBus.SCREEN_EFFECT_DURATION,
			FunctionBus.SCREEN_EFFECT_DURATION,
			function()
				self:GetOn()
			end
			-- test begin
			-- ,function()
			-- 	self.originPosition = self.bus.busPosition
			-- 	self:GO(2, nil, function()
			-- 		self:Shutdown(self.originPosition)
			-- 	end)
			-- end
			-- test end
			)
	else
		self:GetOn()
	end
end

function FunctionBus:Shutdown(position,callBack,immdiately)
	-- print("FunctionBus ==> Shutdown")
	if not self.running then
		return
	end
	self.callBackAfterGetOff = callBack
	-- EventManager.Me():PassEvent(MyselfEvent.LeaveCarrier,self.bus)
	if(self.callBackAfterGetOff == nil and position == nil) then
		EventManager.Me():PassEvent(MyselfEvent.LeaveCarrier,self.bus)
		self:Reset()
	else
		--下载具统统黑屏
		if(immdiately) then
			self:GetOff(position)
			self:Reset()
		else
			UIUtil.ShowScreenMask(
				FunctionBus.SCREEN_EFFECT_DURATION,
				FunctionBus.SCREEN_EFFECT_DURATION,
				function()
					self:GetOff(position)
					self:Reset()
				end)
		end
	end
end

function FunctionBus:GO(line, progressCallback, arrivedCallback)
	if not self.running then
		return
	end
	if Slua.IsNull(self.bus) then
		return
	end
	self.bus.progressListener = progressCallback
	self.bus.arrivedListener = arrivedCallback
	self.bus:GO(line, 0)
end


