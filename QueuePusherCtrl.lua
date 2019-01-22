QueuePusherCtrl = class("QueuePusherCtrl")

QueuePusherCtrl.Dir = {
	Horizontal = 1,
	Vertical = 2,
}

function QueuePusherCtrl:ctor(container,classRef)
	self.container = container
	self.classRef = classRef
	self.checkTimerID = -1
	self.hideDelay = 0.5
	self.hideDelayGrow = 0.1
	self.startPos = {0,0}
	self.endPos = {0,0}
	self.speed = 10
	self.gap = 0
	self.maxNum = -1
	self.isPushing = false
	self.datas = {}
	self:SetDir(QueuePusherCtrl.Dir.Horizontal)
	self:Reset()
end

function QueuePusherCtrl:SetDir(dir)
	self.dir = dir
	if(self.dir == QueuePusherCtrl.Dir.Vertical) then
		self.CheckCanShow = self.CheckVCanShow
		self.ResetPushTargetPos = self.VResetPushTargetPos
		self.FixStick = self.VFixStick
	else
	end
end

function QueuePusherCtrl:SetCellPos(cell,x,y)
	if(cell.gameObject ~=nil) then
		local pos = cell.gameObject.transform.localPosition
		pos.x = x
		pos.y = y
		cell.gameObject.transform.localPosition = pos
	end
end

function QueuePusherCtrl:SetStartPos(x,y)
	self.startPos[1] = x
	self.startPos[2] = y
	for i=1,#self.waiting do
		self:SetCellPos(self.waiting[i],x,y)
	end
end

function QueuePusherCtrl:SetEndPos(x,y)
	self.endPos[1] = x
	self.endPos[2] = y
end

function QueuePusherCtrl:Reset()
	self.waiting = {}
	self.pushing = {}
end

function QueuePusherCtrl:AddData(data)
	--[[
		todo xde RecvSysMsg ???????????? oiusn_?????????
		??????????????????
	]]
	if (data ~= nil and data.params ~=nil and type(data.params) == "table" and data.params[1] ~= nil) then
		if string.match(tostring(data.params[1]), '_?????????') then
			local suffix = "_?????????"
			local partyName = data.params[1]:gsub(suffix, "")
			data.params[1] = partyName .. OverSea.LangManager.Instance():GetLangByKey(suffix)
		end
	end

	self.datas[#self.datas+1] = data
	self:FillWaitingByData()
end

function QueuePusherCtrl:FillWaitingByData()
	if(#self.datas>0 and #self.waiting==0) then
		local data = table.remove(self.datas,1)
		local cell = self.classRef.new(self.container)
		cell:SetData(data)
		self:AddCell(cell)
	end
end

--????????????????????????
function QueuePusherCtrl:AddCell(cell)
	local last = self:GetLast()
	if(last~=nil) then
		cell.previous = last
		last.next = cell
		-- print(#self.pushing)
		-- print(msg.gameObject.name.." last:"..last.gameObject.name)
	end
	-- print("?????????"..QueuePusherCtrl.index.."?????????")
	-- QueuePusherCtrl.index = QueuePusherCtrl.index +1
	self.waiting[#self.waiting+1] = cell
	self:SetCellPos(cell,self.startPos[1],self.startPos[2])
	-- msg.gameObject.name = "Waiting_"..#self.waiting
	self:CheckWaitingShow(#self.waiting)
end

function QueuePusherCtrl:GetLast()
	local last = self.waiting[#self.waiting]
	if(last==nil) then
		last = self.pushing[#self.pushing]
	end
	return last
end

function QueuePusherCtrl:PushForward()
	-- print("PushForward")
	-- if(self.waiting[1]~= nil) then
		self.ResetPushTargetPos(self,self.waiting[1])
	-- end
end

function QueuePusherCtrl:CheckVCanShow(cell)
	local previous = cell.previous
	if(previous==nil) then return true end
	-- if(previous~=nil) then
	-- 	print(cell.gameObject.name.." previous:"..previous.gameObject.name.." gap:"..(previous:GetY()-cell:GetY()).." height gap:"..((previous:GetH()+cell:GetH())/2))
	-- end
	if(self.startPos[2] < self.endPos[2]) then
		return (previous:GetY()-cell:GetY() >= ((previous:GetH()+cell:GetH())/2 + self.gap))==true
	else
		return (cell:GetY()-previous:GetY() >= ((previous:GetH()+cell:GetH())/2 + self.gap))==true
	end
end

function QueuePusherCtrl:CheckWaitingShow(checkIndex)
	checkIndex = checkIndex or 1
	local cell = self.waiting[checkIndex]
	if(cell~=nil) then
		if(cell:Parsed()==false and checkIndex==1) then
			-- print("parse")
			cell:NextToPush()
		end
		if(self.CheckCanShow(self,cell)) then
			self:StartPush()
		elseif(not cell.isPushed) then
			cell:Hide()
			self:PushForward()
			self:StartTimerCheck()
			-- self:CheckPush()
		end
	end
end

function QueuePusherCtrl:VFixStick(cell)
	local factor = -1
	if(self.startPos[2] > self.endPos[2]) then
		factor = 1
	end
	self:SetCellPos(cell,self.startPos[1],cell.previous:GetY() + (self.gap + (cell:GetH()+cell.previous:GetH())/2)*factor)
end

function QueuePusherCtrl:StartPush()
	local cell = table.remove( self.waiting, 1 )
	-- print("push!!")
	if(cell ~= nil) then
		self.pushing[#self.pushing+1] = cell
		if(cell.previous~=nil) then
			self.FixStick(self,cell)
		end
		cell:Show()
		if(self.maxNum >0 and #self.pushing>self.maxNum) then
			self:DestroyCell(self.pushing[1])
		end
		self:PushForward()
		-- self.ResetPushTargetPos(self)
		-- self:StartLuaTimer()
	end
	if(#self.waiting==0) then 
		self:FillWaitingByData()
		self:StopTimerCheck()
	end
end

function QueuePusherCtrl:VResetPushTargetPos(firstWaitCell)
	local pushCell = nil
	local endY= self.endPos[2]
	local time = 0
	local ltd = nil
	local factor = 1
	if(self.startPos[2] > self.endPos[2]) then
		factor = -1
	end
	if(firstWaitCell~=nil) then
		firstWaitCell.isPushed = true
		if(self.pushing[#self.pushing]~=nil) then
			endY = endY+(self.gap + (firstWaitCell:GetH()+self.pushing[#self.pushing]:GetH())/2)*factor
		else
			endY = endY+(self.gap + firstWaitCell:GetH())*factor
		end
	end
	for i=#self.pushing,1,-1 do
		local cell = self.pushing[i]
		if(pushCell ~= nil ) then
			endY = endY+(cell:GetH()/2)*factor
		end
		-- print("no."..i.." h:"..cell:GetH())
		-- print("TargetY.."..endY)
		time = math.abs(endY - cell:GetY())/self.speed
		LeanTween.cancel(cell.gameObject)
		ltd = LeanTween.moveLocalY(cell.gameObject,endY,time)
		if(self.hideDelay>0) then
			local delay = LeanTween.delayedCall(cell.gameObject,time + self.hideDelay + i*self.hideDelayGrow,function()
				self:DestroyCell(cell)
			end)
		end
		endY = endY+(self.gap + cell:GetH()/2)*factor
		-- print("1Endy.."..endY)
		pushCell = cell
	end

	-- if(self.maxNum >0 and #self.pushing>self.maxNum) then
	-- 	ltd:setOnComplete(function ()
	-- 		self:DestroyCell(pushCell)
	-- 	end)
	-- end
end

function QueuePusherCtrl:DestroyCell(cell)
	if(cell~=nil) then
		-- print("DestroyCell.."..cell:GetY())
		LeanTween.cancel(cell.gameObject)
		if(cell.Destroy~=nil) then cell:Destroy() end
		if(cell.next~=nil) then
			cell.next.previous = nil
		end
		TableUtil.Remove(self.pushing,cell)
		-- print(#self.pushing)
		cell = nil
	end
end

function QueuePusherCtrl:CheckPush()
	local cell = self.waiting[1]
	if(cell~=nil) then
		-- local lastPush = self.pushing[#self.pushing]
		-- if(not cell.isPushed) then
		-- 	self.ResetPushTargetPos(self,cell)
		-- end
		self:CheckWaitingShow()
	end
end

function QueuePusherCtrl:StartTimerCheck()
	-- print("StartTimerCheck")
	if(self.checkTimerID ==-1) then
		LuaTimer.Add(0,16,function (id)
			self.checkTimerID = id
			self:CheckPush()
			end)
	end
end

function QueuePusherCtrl:StopTimerCheck()
	-- print(#self.waiting)
	-- print("StopTimerCheck")
	if(self.checkTimerID ~=-1) then
		self.checkTimerID= -1
		LuaTimer.Delete(self.checkTimerID)
	end
end