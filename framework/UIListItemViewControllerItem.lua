autoImport('IconManager')

UIListItemViewControllerItem = class('UIListItemViewControllerItem', BaseCell)

function UIListItemViewControllerItem:Init()
	self:GetGameObjects()

	self:AddClickEvent(self.gameObject, function ()
		self:OnClickForSelf()
	end)
end

function UIListItemViewControllerItem:SetData(data)
	self.itemID = data.id
	self.num = data.num
	self.itemConf = Table_Item[data.id]

	self:LoadView()
end

function UIListItemViewControllerItem:GetGameObjects()
	self.spIcon = self:FindGO('Icon', self.gameObject):GetComponent(UISprite)
	self.labName = self:FindGO('Name', self.gameObject):GetComponent(UILabel)
	self.count = self:FindComponent('countLabel',UILabel)
end

function UIListItemViewControllerItem:LoadView()
	IconManager:SetItemIcon(self.itemConf.Icon, self.spIcon)
	if(self.num>1)then
		self:Show(self.count.gameObject)
		self.count.text = string.format("x%s",self.num)
	else
		self:Hide(self.count.gameObject)
	end
	self.labName.text = self.itemConf.NameZh
end

function UIListItemViewControllerItem:OnClickForSelf()
	local itemData = ItemData.new(nil, self.itemID)
	local tab = ReusableTable.CreateTable()
	tab.itemdata = itemData
	self:ShowItemTip(tab, UISubViewControllerMonthlyVIP.instance.goBoardE:GetComponent(UIWidget), NGUIUtil.AnchorSide.Left, {-168, -28})
	ReusableTable.DestroyAndClearTable(tab)
end