autoImport("WrapCellHelper")
autoImport("TextEmojiCombineCell")

HHChatTextEmojiPage = class("HHChatTextEmojiPage",SubView)

function HHChatTextEmojiPage:Init()
	self.pfbNum=7
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function HHChatTextEmojiPage:FindObjs()
	self.PopUpWindow=self.container.PopUpWindow
	self.itemContainer=self:FindGO("TextEmoji_Container",self.PopUpWindow)
	self.WrapContent=self.itemContainer:GetComponent(UIWrapContent)
	self.ContentScrollView=self:FindGO("TextEmojiScrollView",self.PopUpWindow):GetComponent(UIScrollView)
end

function HHChatTextEmojiPage:AddEvts()

end

function HHChatTextEmojiPage:AddViewEvts()
	
end

function HHChatTextEmojiPage:InitShow()
	self:UpdateTextEmojiInfo()
	self.ContentScrollView:ResetPosition()
end

function HHChatTextEmojiPage:TextEmojiData()
	return ChatRoomProxy.Instance.textEmojiData;
end

function HHChatTextEmojiPage:ReUniteCellData(datas, Nums)
	local newData = {};
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/Nums)+1;
			local i2 = math.floor((i-1)%Nums)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end

function HHChatTextEmojiPage:UpdateTextEmojiInfo(datas)
	if(datas == nil)then
		datas = self:TextEmojiData();
		print("UpdateTextEmojiInfo : "..#datas)
	end
	local newData = self:ReUniteCellData(datas, 4);
	if(self.itemWrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.itemContainer, 
			pfbNum = self.pfbNum, 
			cellName = "TextEmojiCombineCell", 
			control = TextEmojiCombineCell, 
			dir = 2,
		}
		self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
	end
	self.itemWrapHelper:UpdateInfo(newData)
end

function HHChatTextEmojiPage:HandleClickItem(cellctl)
	local data = cellctl.data;
	local go = cellctl.gameObject;
	self.selectData=data
	local ci = self.container.uiInput
	self.container:InsertInput(data.Emoji)
end
