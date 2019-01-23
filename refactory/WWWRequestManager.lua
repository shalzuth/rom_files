autoImport ("WWWRequest")
WWWRequestManager = class("WWWRequestManager")

local tableRemove = table.remove
local ArrayPopFront = TableUtility.ArrayPopFront
function WWWRequestManager:ctor()
	self.count = 10
	self.requests = {}
	self.waiting = {}
end

function WWWRequestManager:_InternalRequest( url,overtime,successCall,failedCall,overtimeCall )
	local request = WWWRequest.CreateAsTable()
	request:SetUrl(url)
	request:SetOverTime(overtime)
	request:SetCallBacks(successCall,failedCall,overtimeCall)
	if(#self.requests >= self.count) then
		self.waiting[#self.waiting + 1] = request
	else
		self:_AddToRequestAndStart(request)
	end
end

function WWWRequestManager:_AddToRequestAndStart(request)
	if(request) then
		self.requests[#self.requests + 1] = request
		request:Request()
	end
end

function WWWRequestManager:_RemoveRequestIndex(index)
	if(index>0 and index<=#self.requests) then
		local request = tableRemove(self.requests, index)
		request:Destroy()
	end
end

--overtime 秒
function WWWRequestManager:SimpleRequest(url,overtime,successCall,failedCall,overtimeCall)
	self:_InternalRequest(url,overtime,successCall,failedCall,overtimeCall)
end

function WWWRequestManager:Update(time, deltaTime)
	local request
	for i=#self.requests,1,-1 do
		request = self.requests[i]
		if(request:IsRequesting()) then
			if(request:Update(time, deltaTime)==false) then
				self:_RemoveRequestIndex(i)
			end
		elseif(request:CanRemove()) then
			self:_RemoveRequestIndex(i)
		end
	end
	local freeSeats = self.count - #self.requests
	if(freeSeats>0) then
		freeSeats = math.min(freeSeats,#self.waiting)
		for i=1,freeSeats do
			request = ArrayPopFront(self.waiting)
			if(request) then
				self:_AddToRequestAndStart(request)
			end
		end
	end
end