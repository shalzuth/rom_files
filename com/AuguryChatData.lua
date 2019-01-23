AuguryChatData = class("AuguryChatData")

function AuguryChatData:ctor(data)
	self:SetData(data)
end

function AuguryChatData:SetData(data)
	if data then
		self.name = data.sender
		self.text = data.content
	end
end