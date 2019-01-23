WWWRequest = reusableClass("WWWRequest")
WWWRequest.PoolSize = 15

local MaxOverTime = 15

local WWWRequestState = {
	NONE = 0,
	REQUESTING = 1,
	SUCCESS = 2,
	ERROR = 3,
	OVERTIME = 4
}

function WWWRequest:ctor()
	self:Reset()
end

function WWWRequest:Reset()
	self.overtime = 0
	self.overtimeStamp = 0
	self.url = nil
	self.wwwForm = nil
	self.requestHead = nil
	self.responseHead = nil

	self.www = nil

	--state
	self.state = WWWRequestState.NONE

	--callback
	self.onSuccessResponseCall = nil
	self.onFailedResponseCall = nil
	self.onOvertimeCall = nil
end

function WWWRequest:_DisposeWWW()
	if(self.www) then
		self.www:Dispose()
		self.www = nil
	end
end

function WWWRequest:SetUrl( url )
	if(self.state == WWWRequestState.NONE) then
		self.url = url
	else
		helplog("request is already begin/end, cannot change url")
	end
end

function WWWRequest:SetOverTime( overtime )
	if(self.state == WWWRequestState.NONE) then
		overtime = overtime or MaxOverTime
		overtime = math.min(overtime,MaxOverTime)
		self.overtime = overtime
	else
		helplog("request is already begin/end, cannot change overtime")
	end
end

function WWWRequest:SetCallBacks( successCall,failedCall,overtimeCall )
	if(self.state <= WWWRequestState.REQUESTING) then
		self.onSuccessResponseCall = successCall
		self.onFailedResponseCall = failedCall
		self.onOvertimeCall = overtimeCall
	else
		helplog("request is already end, cannot change callbacks")
	end
end

function WWWRequest:Request(url,overtime)
	if(self.state ~= WWWRequestState.NONE) then
		return
	end
	if (url) then
		self:SetUrl(url)
	end
	if (overtime) then
		self:SetOverTime(overtime)
	end
	self.state = WWWRequestState.REQUESTING
	local c = coroutine.create(function ()
		self.www = WWW(self.url)

		self.overtimeStamp = Time.unscaledTime + self.overtime
		Yield(self.www)

		if(self.state == WWWRequestState.REQUESTING) then
			if(self.www.isDone) then
				if(self.www.error == nil or self.www.error == "") then
					self.state = WWWRequestState.SUCCESS
					if(self.onSuccessResponseCall) then
						self.onSuccessResponseCall(self.www)
					end
				else
					self.state = WWWRequestState.ERROR
					if(self.onFailedResponseCall) then
						self.onFailedResponseCall(self.www,self.www.error)
					end
				end
			else
				helplog("www is not done ??")
			end
		end
	end)
	coroutine.resume(c)
end

function WWWRequest:CanRemove()
	return self.state >= WWWRequestState.SUCCESS
end

function WWWRequest:IsRequesting()
	return self.state == WWWRequestState.REQUESTING
end

function WWWRequest:DoConstruct(asArray, data)
	if(data) then
		self.url = data.url
		self.overtime = data.overtime
	end
end

function WWWRequest:DoDeconstruct(asArray)
	self:Reset()
end

function WWWRequest:Update(time, deltaTime)
	if(Time.unscaledTime>=self.overtimeStamp) then
		--超时
		self.state = WWWRequestState.OVERTIME
		if(self.onOvertimeCall) then
			self.onOvertimeCall(self.www)
		end
		return false
	end
	return true
end