local baseCell = autoImport("BaseCell")
AdventureCategoryCell = class("AdventureCategoryCell",baseCell)

function AdventureCategoryCell:Init()
	self:initView()
	self:initData()
	-- self:addViewEventListener()	
	-- self:addListEventListener()
end

function AdventureCategoryCell:initView(  )
	-- body
	-- self.name = self:FindGO("name"):GetComponent(UILabel)
	-- self.newTag = self:FindGO("newTag")
	self.icon = self:FindGO("icon"):GetComponent(UISprite)

	-- self:SetEvent(self.icon.gameObject,function ( obj )
	-- 	-- body
	-- 	if not self.isSelected then
	-- 		self:PassEvent(MouseEvent.MouseClick,self)
	-- 		self:unRegistRedTip()
	-- 	end
	-- end)
end

function AdventureCategoryCell:unRegistRedTip(  )
	-- body
	-- if(self.categoryCount<2)then
		-- printRed("unRegistRedTip")
		-- print(self.redTipIds[1])
		-- if(self.redTipIds[1])then
		-- 	RedTipProxy.Instance:SeenNew(self.redTipIds[1]);
		-- end
		if(self.data.staticData.id ~= SceneManual_pb.EMANUALTYPE_SCENERY)then
			for i=1,#self.redTipIds do
				local single = self.redTipIds[i]
				RedTipProxy.Instance:RemoveWholeTip(single);
			end
		end
	-- end
end

function AdventureCategoryCell:initData(  )
	-- body
	-- local questTypeList = QuestProxy.Instance:getOngoingQuestList()
	-- self.questList:ResetDatas(questTypeList)
	self.redTipIds = {}
end

local tempColor =LuaColor.white
function AdventureCategoryCell:setIsSelected( isSelected )
	-- body
	if self.isSelected ~= isSelected then
		self.isSelected = isSelected
		if(isSelected)then
			tempColor:Set(65/255,89/255,170/255,1)		
			self.icon.color = tempColor
			-- self:unRegistRedTip()
		else			
			tempColor:Set(1,1,1,1)
			self.icon.color = tempColor
		end
	end
end

function AdventureCategoryCell:addViewEventListener(  )
	-- body
end

-- function AdventureCategoryCell:RegisterRedTip(  )
-- 	-- body
-- 	-- self.categoryCount = 0
-- 	self.redTipIds = AdventureDataProxy.Instance:getRidTipsByCategoryId(self.data.id)
-- 	for i=1,#self.redTipIds do
-- 		local single = self.redTipIds[i]
-- 		local data = {}
-- 		data.id = single
-- 		data.obj = self.icon
-- 		data.offset = {-5,-5}
-- 		printRed("AdventureCategoryCell:RegisterRedTip(  )")
-- 		EventManager.Me():PassEvent(AdventurePanel.RegistRedTip,data)
-- 		-- self.categoryCount = self.categoryCount+1
-- 	end
-- end

function AdventureCategoryCell:registGuide(  )
	-- body
	if(self.data and self.data.staticData.GuideID)then
		self:AddOrRemoveGuideId(self.gameObject, self.data.staticData.GuideID)
	end
end

local tempVector3 = LuaVector3.zero
function AdventureCategoryCell:SetData(data)
	self.data = data
	IconManager:SetUIIcon(data.staticData.icon,self.icon)
	self.icon:MakePixelPerfect()
	tempVector3:Set(0.7,0.7,0.7)
	self.icon.transform.localScale = tempVector3
	if(data.icon == "")then
		IconManager:SetItemIcon("21",self.icon)
	end
	-- self:RegisterRedTip()
	self:registGuide()
	-- self.name.text = data.Name
	-- self:initData()
end
