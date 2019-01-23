local baseCell = autoImport("BaseCell")
AdventureResearchCategoryCell = class("AdventureResearchCategoryCell",baseCell)

function AdventureResearchCategoryCell:Init()
	self:initView()	
end

function AdventureResearchCategoryCell:initView(  )
	-- body
	self.CategoryName = self:FindComponent("CategoryName",UILabel)
	self.CategoryInfoText = self:FindComponent("CategoryInfoText",UILabel)
	self.icon = self:FindComponent("icon",UISprite)
	self.selected = self:FindGO("selected")
	self:AddClickEvent(self.gameObject,function (  )
		-- body
		if(not self.isSelect)then
			self:PassEvent(MouseEvent.MouseClick, self)
		end
	end)
	self:setSelected(false)
end

function AdventureResearchCategoryCell:SetData(data)
	if(data)then
		self.data = data
		self.CategoryName.text = data.staticData.Name
		local currentUnlock ,total = 0,0
		if(data.staticData.id == AdventureResearchPage.DataFromMenuId)then
			currentUnlock ,total =  AdventureDataProxy.Instance:getMenuLockInfo()
		else
			currentUnlock ,total = AdventureDataProxy.Instance:getLockNumInfoByClassify(data.staticData.id)
		end
		self.CategoryInfoText.text = currentUnlock.."/"..total
		self.icon.spriteName = data.staticData.icon
		self.icon:MakePixelPerfect();
	end
end

function AdventureResearchCategoryCell:setSelected(isSelect)
	if(self.isSelect == isSelect)then
		return
	end
	self.isSelect = isSelect
	if(isSelect)then
		self:Show(self.selected)
	else
		self:Hide(self.selected)
	end
end
