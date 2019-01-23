PhotoCallback = class('PhotoCallback')

function PhotoCallback:ctor()
	self.allCallbacks = {}
end

function PhotoCallback:RegisterCallback(id, progress_callback, success_callback, error_callback, o_or_t)
	local key = self:GetKey(id, o_or_t)
	local callbacks = self.allCallbacks[key]
	if callbacks == nil then
		callbacks = {}
	end
	table.insert(callbacks, {progressCallback = progress_callback, successCallback = success_callback, errorCallback = error_callback})
	self.allCallbacks[key] = callbacks
end

function PhotoCallback:ClearCallback(id, o_or_t)
	local key = self:GetKey(id, o_or_t)
	self.allCallbacks[key] = nil
end

function PhotoCallback:FireProgress(id, progress_value, o_or_t)
	local key = self:GetKey(id, o_or_t)
	local callbacks = self.allCallbacks[key]
	if callbacks ~= nil then
		for i = 1, #callbacks do
			local callback = callbacks[i]
			if callback.progressCallback ~= nil then
				callback.progressCallback(progress_value)
			end
		end
	end
end

function PhotoCallback:FireSuccess(id, bytes, timestamp, o_or_t)
	local key = self:GetKey(id, o_or_t)
	local callbacks = self.allCallbacks[key]
	if callbacks ~= nil then
		for i = 1, #callbacks do
			local callback = callbacks[i]
			if callback.successCallback ~= nil then
				callback.successCallback(bytes, timestamp)
			end
		end
		self:ClearCallback(id, o_or_t)
	end
end

function PhotoCallback:FireError(id, error_message, o_or_t)
	local key = self:GetKey(id, o_or_t)
	local callbacks = self.allCallbacks[key]
	if callbacks ~= nil then
		for i = 1, #callbacks do
			local callback = callbacks[i]
			if callback.errorCallback ~= nil then
				callback.errorCallback(error_message)
			end
		end
		self:ClearCallback(id, o_or_t)
	end
end

function PhotoCallback:GetKey(id, o_or_t)
	return id .. '_' .. (o_or_t and 'o' or 't')
end