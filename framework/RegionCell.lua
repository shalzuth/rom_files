local baseCell = autoImport("BaseCell")
RegionCell = class("RegionCell",baseCell)

function RegionCell:Init()
	self:initView()
	self:initData()
	-- self:addViewEventListener()	
	-- self:addListEventListener()
end

function RegionCell:initView(  )
	-- body
	self.name = self:FindGO("name"):GetComponent(UILabel)
	-- self.newTag = self:FindGO("newTag")
	self.bg = self:FindGO("bg"):GetComponent(UIMultiSprite)

	self:SetEvent(self.gameObject,function ( obj )
		-- body
		if not self.isSelected then
			self:PassEvent(MouseEvent.MouseClick,self)
		end
	end)
end

function RegionCell:initData(  )
	-- body
	-- local questTypeList = QuestProxy.Instance:getOngoingQuestList()
	-- self.questList:ResetDatas(questTypeList)
	self.isSelected = true
	self:setIsSelected(false)
end

function RegionCell:setIsSelected( isSelected )
	-- body
	if self.isSelected ~= isSelected then
		self.isSelected = isSelected
		if(isSelected)then
			self.bg.CurrentState = 0
			self.name.effectColor = Color(4/255,126/255,176/255,1)
			self.name.effectStyle = UILabel.Effect.Outline8
			self.bg.gameObject.transform.localScale = Vector3(1.04,1.04,1.04)
		else			
			self.bg.CurrentState = 1
			self.name.effectStyle = UILabel.Effect.None
			self.bg.gameObject.transform.localScale = Vector3.one
		end
	end
end

function RegionCell:SetData(data)
	self.data = data
	self.name.text = data.name
	-- self:initData()
end
