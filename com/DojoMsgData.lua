DojoMsgData = class("DojoMsgData")

function DojoMsgData:ctor(data)
	self:SetData(data)
end

function DojoMsgData:SetData(data)
	self.charid = data.charid
	self.name = data.name
	self.content = data.conent
	self.iscompleted = data.iscompleted
	self.cellType = DojoCellType
end

function DojoMsgData:GetCellType()
	return self.cellType
end