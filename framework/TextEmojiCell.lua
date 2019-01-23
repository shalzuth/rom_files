local baseCell = autoImport("BaseCell")
TextEmojiCell = class("TextEmojiCell", baseCell)

function TextEmojiCell:Init()
	TextEmojiCell.super.Init(self)

	self:FindObjs()
	self:AddCellClickEvent()
end

function TextEmojiCell:FindObjs()
	self.EmojiLabel=self:FindGO("EmojiLabel"):GetComponent(UILabel)
end

function TextEmojiCell:SetData(id)
	self.data = Table_ChatEmoji[id]
	
	if self.data and self.data.Emoji then
	 	self.EmojiLabel.text = self.data.Emoji
	end
end