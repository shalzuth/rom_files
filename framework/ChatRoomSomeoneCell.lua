autoImport("ChatRoomCell")
ChatRoomSomeoneCell = reusableClass("ChatRoomSomeoneCell", ChatRoomCell)

ChatRoomSomeoneCell.rid = ResourcePathHelper.UICell("ChatRoomSomeoneCell")

function ChatRoomSomeoneCell:CreateSelf(parent)
	if parent then
		self.gameObject = self:CreateObj(ChatRoomSomeoneCell.rid,parent)
	end
end