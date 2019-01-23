autoImport("TextEmojiCell")
local baseCell = autoImport("BaseCell")
TextEmojiCombineCell = class("TextEmojiCombineCell",baseCell)

function TextEmojiCombineCell:Init()
	self.childNum = self.gameObject.transform.childCount
	self:FindObjs();
end

function TextEmojiCombineCell:FindObjs()
	self.childrenObjs = {};
	local go = nil
	for i=1,self.childNum do
		go = self:FindChild("child"..i);
		self.childrenObjs[i] = TextEmojiCell.new(go)
	end
end

function TextEmojiCombineCell:AddEventListener(eventType, handler, handlerOwner)
	for i = 1, #self.childrenObjs do
		self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner);
	end
end

function TextEmojiCombineCell:SetData(data)
	self.data = data;
	self:UpdateInfo();
end

function TextEmojiCombineCell:GetDataByChildIndex(index)
	if(self.data == nil)then
		return nil;
	else
		return self.data[index];
	end
end

function TextEmojiCombineCell:UpdateInfo()
	for i = 1,#self.childrenObjs do
		local cData = self:GetDataByChildIndex(i);
		local cell = self.childrenObjs[i]
		cell:SetData(cData)
		cell.gameObject:SetActive(cData ~= nil)
	end
end