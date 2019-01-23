
autoImport ("SceneSeat")

-- actionIDs
local SitAction = 60

local DisplaySkillID = 50031001
local DisplayDuration = 10

SceneSeatManager = class("SceneSeatManager")

function SceneSeatManager:ctor()
	self.staticData = nil
	self.seats = {}
	self.sittingCreatures = {}
	self.displaying = false
	self.displayEndTime = 0
end

function SceneSeatManager:Display(duration)
	self.displayEndTime = Time.time + duration
	self:SetDisplay(true)
end

function SceneSeatManager:SetDisplay(on)
	if on == self.displaying then
		return
	end

	self.displaying = on
	local seats = self.seats
	if on then
		for k,v in pairs(seats) do
			v:DeterminShow()
		end
	else
		for k,v in pairs(seats) do
			v:Hide()
		end
		self.displayEndTime = 0
	end
end

function SceneSeatManager:SeatIsCustom(seatID)
	local seat = self.seats[seatID]
	if(seat) then
		return seat.isCustomSeat
	end
	return false
end

function SceneSeatManager:SetSeatsDisplay(seats,on)
	if(seats) then
		local seat
		for i=1,#seats do
			seat = self.seats[seats[i]]
			if(seat) then
				if(on) then
					seat:Server_Show()
				else
					seat:Hide()
				end
			end
		end
	end
end

function SceneSeatManager:IsDisplaying()
	return self.displaying
end

function SceneSeatManager:GetCreatureSeat(creature)
	return self.sittingCreatures[creature]
end

function SceneSeatManager:GetOnSeat(creature, seatID)
	local seat = self.seats[seatID]
	if nil == seat then
		return false
	end
	local oldSeat = self:GetCreatureSeat(creature)
	if nil ~= oldSeat then
		if oldSeat:GetID() == seatID then
			return true
		end
		self.sittingCreatures[creature] = nil
		oldSeat:GetOff(creature)
	end
	if not seat:GetOn(creature) then
		return false
	end
	self.sittingCreatures[creature] = seat
	creature:RegisterWeakObserver(self)
	return true
end

function SceneSeatManager:MyselfManualGetOffSeat()
	local creature = Game.Myself
	local seat = self:GetCreatureSeat(creature)
	if nil == seat then
		return false
	end
	self.sittingCreatures[creature] = nil
	seat:GetOff(creature)
	ServiceNUserProxy.Instance:CallCheckSeatUserCmd(
		seat:GetID(), 
		false)
	return true
end

function SceneSeatManager:GetOffSeat(creature)
	local seat = self:GetCreatureSeat(creature)
	if nil == seat then
		return false
	end
	self.sittingCreatures[creature] = nil
	seat:GetOff(creature)
	return true
end

function SceneSeatManager:TryGetOffSeat(creature, seatID)
	local seat = self:GetCreatureSeat(creature)
	if nil == seat then
		return true
	end
	if seat:GetID() ~= seatID then
		return false
	end
	self.sittingCreatures[creature] = nil
	seat:GetOff(creature)
	return true
end

function SceneSeatManager:ClickSeat(obj)
	local creature = Game.Myself
	local seat = self:GetCreatureSeat(creature)
	if nil ~= seat then
		return
	end

	local seatID = obj.ID
	seat = self.seats[seatID]
	if nil == seat then
		return
	end

	local accessPos = seat:GetAccessPosition()
	if VectorUtility.AlmostEqual_3_XZ(accessPos, creature:GetPosition()) then
		self:_OnSeatAccessed(seatID)
		return
	end
	creature:Client_MoveXYZTo(
		accessPos[1],accessPos[2],accessPos[3],
		nil,
		nil,
		SceneSeatManager._OnSeatAccessed,
		self,
		seatID)
end

function SceneSeatManager:_OnSeatAccessed(seatID)
	local creature = Game.Myself
	local seat = self:GetCreatureSeat(creature)
	if nil ~= seat then
		return
	end

	seat = self.seats[seatID]
	if nil == seat then
		return
	end

	if 0 < seat:GetPassengerCount() then
		return
	end

	helplog("OnSeatAccessed", seatID)

	-- 1.
	FunctionSystem.InterruptMyselfAll()
	-- 2.
	self:GetOnSeat(creature, seatID)
	-- 3.
	ServiceNUserProxy.Instance:CallCheckSeatUserCmd(
		seatID, 
		true) 
	-- 4.
	creature:Client_PlayMotionAction(SitAction)
	creature:Client_SetDirCmd(
		AI_CMD_SetAngleY.Mode.SetAngleY,
		seat:GetDir(),
		true)

	self:SetDisplay(false)
end

function SceneSeatManager:_CreateSeats()
	local seats = self.seats
	for k,v in pairs(self.staticData) do
		local seat
		if(v.PrefabID == nil) then
			seat = SceneSeat.Create(v)
		else
			seat = CustomSceneSeat.Create(v)
		end
		if self.displaying then
			seat:DeterminShow()
		end
		seats[k] = seat
	end
end

function SceneSeatManager:_DestroySeats()
	local seats = self.seats
	for k,v in pairs(seats) do
		seats[k] = nil
		v:Destroy()
	end
end

function SceneSeatManager:_ClearSittingCreatures()
	for k,v in pairs(self.sittingCreatures) do
		v:GetOff(k)
		k:UnregisterWeakObserver(self)
		self.sittingCreatures[k] = nil
	end
end

function SceneSeatManager:_OnSkillUsed(skillID)
	if DisplaySkillID == skillID then
		self:Display(DisplayDuration)
	end
end

function SceneSeatManager:ObserverDestroyed(creature)
	self:GetOffSeat(creature)
end

function SceneSeatManager:Launch()
	if self.running then
		return
	end

	local mapID = Game.MapManager:GetMapID()
	local mapInfo = Table_Map[mapID]
	if nil == mapInfo then
		return
	end

	local seatFile = "Table_Seat_"..mapInfo.NameEn
	if not ResourceID.CheckFileIsRecorded(seatFile) then
		return
	end
	if _G[seatFile] == nil then
		autoImport(seatFile)
	end
	self.staticData = _G[seatFile]
	if nil == self.staticData then
		return
	end

	self.running = true

	EventManager.Me():AddEventListener(
		MyselfEvent.UsedSkill,
		SceneSeatManager._OnSkillUsed,
		self)

	self:_CreateSeats()
end

function SceneSeatManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false

	EventManager.Me():RemoveEventListener(
		MyselfEvent.UsedSkill,
		SceneSeatManager._OnSkillUsed,
		self)

	-- 1.
	self:_ClearSittingCreatures()
	-- 2.
	self:_DestroySeats()
	-- 3.
	self.staticData = nil
	self.displaying = false
	self.displayEndTime = 0
end

function SceneSeatManager:Update(time, deltaTime)
	if not self.running then
		return
	end
	if self.displaying 
		and 0 < self.displayEndTime 
		and time > self.displayEndTime then
		self:SetDisplay(false)
	end
end