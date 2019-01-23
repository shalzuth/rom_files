autoImport("WrapCellHelper")
autoImport("TextEmojiCombineCell")

ChatTextEmojiPage = class("ChatTextEmojiPage",SubView)

function ChatTextEmojiPage:Init()
	self:FindObjs()
	self:InitShow()
end

function ChatTextEmojiPage:FindObjs()
	self.PopUpWindow=self.container.PopUpWindow
	self.itemContainer=self:FindGO("TextEmoji_Container",self.PopUpWindow)
	self.WrapContent=self.itemContainer:GetComponent(UIWrapContent)
	self.ContentScrollView=self:FindGO("TextEmojiScrollView",self.PopUpWindow):GetComponent(UIScrollView)
end

function ChatTextEmojiPage:InitShow()

	self.localTable = {}

	self.localTable.wrapObj = self.itemContainer
	self.localTable.pfbNum = 5
	self.localTable.cellName = "TextEmojiCombineCell"
	self.localTable.control = TextEmojiCombineCell
	self.localTable.dir = 1

	self.itemWrapHelper = WrapCellHelper.new(self.localTable)	
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)

	self.ContentScrollView.gameObject:SetActive(true)

	self:UpdateTextEmojiInfo()
	self.ContentScrollView:ResetPosition()
end

function ChatTextEmojiPage:ReUniteCellData(datas, Nums)
	TableUtility.TableClear(self.localTable)

	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/Nums)+1;
			local i2 = math.floor((i-1)%Nums)+1;
			self.localTable[i1] = self.localTable[i1] or {};
			if(datas[i] == nil)then
				self.localTable[i1][i2] = nil;
			else
				self.localTable[i1][i2] = datas[i];
			end
		end
	end
end

function ChatTextEmojiPage:UpdateTextEmojiInfo()
	self:ReUniteCellData( ChatRoomProxy.Instance.textEmojiData , 7)
	self.itemWrapHelper:UpdateInfo(self.localTable)
end

function ChatTextEmojiPage:HandleClickItem(cellctl)
	if self.container.contentInput.gameObject.activeInHierarchy then
		self.container:SetContentInputValue(cellctl.data.Emoji)
	end
end