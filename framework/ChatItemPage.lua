autoImport("ChatItemCombineCell")

ChatItemPage = class("ChatItemPage",SubView)

function ChatItemPage:OnEnter()
	self.super.OnEnter(self)

	self:UpdateItem()

	ChatRoomProxy.Instance:ResetItemDataList()	
end

function ChatItemPage:Init()
	self:FindObjs()
	self:AddViewEvts()
	self:InitShow()
end

function ChatItemPage:FindObjs()
	self.PopUpWindow = self.container.PopUpWindow
	self.itemContainer = self:FindGO("Item_Container",self.PopUpWindow)
	self.ContentScrollView = self:FindGO("ItemScrollView",self.PopUpWindow):GetComponent(UIScrollView)
end

function ChatItemPage:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate,self.UpdateItem)
	self:AddListenEvt(ItemEvent.EquipUpdate,self.UpdateItem)
end

function ChatItemPage:InitShow()
	
	self.localData = {}

	self.localData.wrapObj = self.itemContainer
	self.localData.pfbNum = 4
	self.localData.cellName = "ChatItemCombineCell"
	self.localData.control = ChatItemCombineCell
	self.localData.dir = 1

	self.itemWrapHelper = WrapCellHelper.new(self.localData)	
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function ChatItemPage:UpdateItem()
	local data = ChatRoomProxy.Instance:GetChatItemInfo()
	self:ReUniteCellData(data, 10)
	self.itemWrapHelper:UpdateInfo(self.localData)
end

function ChatItemPage:HandleClickItem(cellctl)
	if cellctl.data then
		local content = ChatRoomProxy.Instance:TryParseItemDataToNormal(cellctl.data)
		self.container:SetContentInputValue(content)
		ChatRoomProxy.Instance:AddItemData(cellctl.data)
	end
end

function ChatItemPage:ReUniteCellData(datas, perRowNum)
	TableUtility.TableClear(self.localData)

	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			self.localData[i1] = self.localData[i1] or {};
			if(datas[i] == nil)then
				self.localData[i1][i2] = nil;
			else
				self.localData[i1][i2] = datas[i];
			end
		end
	end
end