PresetMsgData = class("PresetMsgData")

function PresetMsgData:ctor(data)
	self:SetData(data)	
end

function PresetMsgData:SetData(msg)
	self.msg = msg
end

function PresetMsgData:SetMsg(msg)
	self.msg = msg
end