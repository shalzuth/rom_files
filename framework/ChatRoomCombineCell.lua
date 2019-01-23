autoImport("ChatRoomMySelfCell")
autoImport("ChatRoomSomeoneCell")
autoImport("ChatRoomSystemCell")

local baseCell = autoImport("BaseCell")
ChatRoomCombineCell = class("ChatRoomCombineCell", baseCell)

function ChatRoomCombineCell:Init()
	self:InitShow()
end

function ChatRoomCombineCell:InitShow()
	self.controlMap = {}
	self.controlMap[ChatTypeEnum.MySelfMessage] = ChatRoomMySelfCell
	self.controlMap[ChatTypeEnum.SomeoneMessage] = ChatRoomSomeoneCell
	self.controlMap[ChatTypeEnum.SystemMessage] = ChatRoomSystemCell

	self.cellMap = {}
end

function ChatRoomCombineCell:SetData(data)

	self.data = data

	if data then
		local type = data:GetCellType()
		local control = self.controlMap[type]
		if control then			
			if self.cellMap[type] == nil then
				self.cellMap[type] = control.CreateAsTable(self.gameObject)
				self.cellMap[type]:AddEventListener(self.eventType, self.handler, self.handlerOwner)
			end

			local cell = self.cellMap[type]
			cell:SetData(data)

			if self.lastCell and self.lastCell ~= cell then
				self.lastCell.gameObject:SetActive(false)
			end
			self.lastCell = cell
		end
	else
		for k,v in pairs(self.cellMap) do
			v.gameObject:SetActive(false)
		end

		self.lastCell = nil
	end
end

function ChatRoomCombineCell:CheckMoveToFirst()
	if self.lastCell then
		return self.lastCell.top.isVisible or false
	end
end

function ChatRoomCombineCell:AddEventListener(eventType, handler, handlerOwner)
	self.eventType = eventType
	self.handler = handler
	self.handlerOwner = handlerOwner
end

function ChatRoomCombineCell:GetCurrentCell()
	return self.lastCell
end