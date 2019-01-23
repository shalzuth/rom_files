local baseCell = autoImport("BaseCell")
autoImport("AchievementCategoryChildCell")
AchievementCategoryCell = class("AchievementCategoryCell",baseCell)

function AchievementCategoryCell:Init()
	self:initView()
	self:initData()
	self:AddCellClickEvent();
end

function AchievementCategoryCell:initData(  )
	self.isShowChild = false
	self:Hide(self.childGrid.gameObject)
end

function AchievementCategoryCell:initView(  )
	-- body
	-- self.icon = self:FindGO("icon"):GetComponent(UISprite)
	self.Name = self:FindGO("Name"):GetComponent(UILabel)
	self.selectedBg = self:FindGO("selectedBg")
	self.Value = self:FindComponent("Value",UILabel)
	self.bg = self:FindComponent("bg",UISprite)
	self.childGrid = self:FindComponent("child",UIGrid)
	self.categoryGrid = UIGridListCtrl.new(self.childGrid,AchievementCategoryChildCell,"AchievementCategoryChildCell")
	self.categoryGrid:AddEventListener(MouseEvent.MouseClick,self.childCellClick,self)

	self.slider = self:FindComponent("foreSp",UISlider)
	self.foreSp = self:FindComponent("foreSp",UISprite)
	self.progress = self:FindGO("progress")
end

function AchievementCategoryCell:childCellClick(cellCtl)
	if(cellCtl and cellCtl.isSelected)then
		return
	end
	--TODO 父类选中去除
	-- self:Hide(self.selectedBg.gameObject)
	-- self.isSelected = false
	--TODO 父类选中去除
	self:PassEvent(AdventureAchievementPage.childGroupCellClick, cellCtl)
	local cells = self.categoryGrid:GetCells()
	if(cells and #cells>0)then
		for i=1,#cells do
			local cell = cells[i]
			if(cell == cellCtl)then
				cell:setSelected(true)
			else
				cell:setSelected(false)
			end
		end
	end
end

function AchievementCategoryCell:getSubChildCells()
	return self.categoryGrid:GetCells()
end

function AchievementCategoryCell:SetData(data)
	self.data = data
	-- self.level.text = data:GetLevelText()
	-- IconManager:SetUIIcon(data.staticData.Icon,self.icon)
	self.Name.text = data.staticData.Name
	if(data.staticData.id == AdventureAchieveProxy.HomeCategoryId)then
		self:Hide(self.Value.gameObject)
		self:Hide(self.progress)
	else
		self:Show(self.progress)
		self:Show(self.Value.gameObject)
		local unlock,total = AdventureAchieveProxy.Instance:getAchieveAndTotalNum(data.staticData.id)
		self.foreSp.spriteName = self.data.staticData.BackImage
		self.Value.text = unlock.."/"..total
		self.slider.value = unlock/total
		local list = {}
		for k,v in pairs(data.childs) do
			table.insert(list,v)
		end
		table.sort(list,function ( l,r )
			-- body
			return l.staticData.id < r.staticData.id
		end)
		self.categoryGrid:ResetDatas(list)
	end
	-- self:setSelected(false)
end

function AchievementCategoryCell:clickEvent()
	if(self.isSelected)then
		self.isShowChild = not self.isShowChild
		self.childGrid.gameObject:SetActive(self.isShowChild)
	end
end

function AchievementCategoryCell:setSelected(isSelected)
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		self.selectedBg.gameObject:SetActive(isSelected)
		if(isSelected)then
			self.isShowChild = true
			self:Show(self.childGrid.gameObject)
			-- self:childCellClick()  --TODO 父类选中去除 
		else
			self.isShowChild = false
			self:Hide(self.childGrid.gameObject)
			self:childCellClick()
		end
	end	
end