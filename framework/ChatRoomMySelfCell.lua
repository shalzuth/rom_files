autoImport("ChatRoomCell")
ChatRoomMySelfCell = reusableClass("ChatRoomMySelfCell", ChatRoomCell)

ChatRoomMySelfCell.rid = ResourcePathHelper.UICell("ChatRoomMySelfCell")

function ChatRoomMySelfCell:CreateSelf(parent)
	if parent then
		self.gameObject = self:CreateObj(ChatRoomMySelfCell.rid,parent)
	end	
end