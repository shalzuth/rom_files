autoImport("LState")
autoImport("LStack")
autoImport("EventDispatcher")
LStateMachine = class('LStateMachine',EventDispatcher)

function LStateMachine:ctor()
	self:Reset()
end

function LStateMachine:Reset()
	self:SetCurrentState(nil)
	self.previousState = nil
	self.onStateChange = nil
end

function LStateMachine:SetOnStateChange(func,owner)
	self.onStateChange = {call = func,owner=owner}
end

--private 别直接调用啊-_-||
function LStateMachine:SetCurrentState(state)
	if(state~=self.currentState or (self.currentState and state.class ~= self.currentState.class)) then
		self.previousState = self.currentState
		if(self.currentState) then
			self.currentState:Exit()
		end
		self.currentState = state
		if(self.onStateChange) then
			self.onStateChange.func(self.onStateChange.owner,self.previousState,self.currentState)
		end
		if(self.currentState) then
			self.currentState:Enter()
		end
	elseif(self.currentState)then
		self.currentState:Reset()
	end
end

function LStateMachine:SwitchState(state)
	self:SetCurrentState(state)
end

function LStateMachine:Exit()
	self:Reset()
end