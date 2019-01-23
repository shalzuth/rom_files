
DelegateUtil = class("DelegateUtil")

function DelegateUtil:ctor()
	self.delegateOwner = nil
	self.delegateInterruptedCallback = nil
end

function DelegateUtil:SetDelegate(owner, delegateSetter, interruptedCallback)
	if not delegateSetter() then
		return
	end

	if self.delegateOwner ~= owner then
		if nil ~= self.delegateInterruptedCallback then
			self.delegateInterruptedCallback(owner)
		end
	end	

	self.delegateOwner = owner
	self.delegateInterruptedCallback = interruptedCallback
end

function DelegateUtil:ClearDelegate(owner, delegateClearer)
	if self.delegateOwner == owner then
		delegateClearer()

		self.delegateOwner = nil
		self.delegateInterruptedCallback = nil
		return true
	end
	return false
end