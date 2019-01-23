local baseCell = autoImport("BaseCell")
autoImport("ProfessionSkillTip")
LockItemCell = class("LockItemCell",baseCell)


function LockItemCell:Init(  )
	-- body
	self:initView()
	self:addViewEventListener()
	self.itemId = 0
	self.isSelected = true
	self:setIsSelected(false)
	self.time = 0
end

function LockItemCell:initView(  )
	-- body
	self.selected = self:FindChild("Select"):GetComponent(UISprite);	
	self.icon = self:FindChild("Icon"):GetComponent(UISprite);
	self.frameObj = self:FindGO("Frame");
	self.bg = self:FindGO("Bg");

	self.cardItem = self:FindGO("CardItem");
	if(self.cardItem)then
		self.cardquality = self:FindComponent("CardQuality", UISprite, self.cardItem);
		self.cardpos = self:FindComponent("CardPosition", UISprite, self.cardItem);
		self.cardicon = self:FindComponent("CardIcon", UISprite, self.cardItem);
		self.cardlv = self:FindComponent("CardLv", UILabel, self.cardItem);
	end
end

function LockItemCell:addViewEventListener(  )
	-- body	
	local pressFun = function ( obj )
		-- body
		if(Time.unscaledTime - self.time < 0.3)then
			return
		end
		self:setIsSelected(not self.isSelected)	
		self:PassEvent(MouseEvent.MouseClick, self);				
	end
	self:SetEvent(self.gameObject,pressFun)
end

function LockItemCell:setIsSelected( isSelected )
	-- body
	if(not isSelected)then
		self.time = Time.unscaledTime
	end
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		if not GameObjectUtil.Instance:ObjectIsNULL(self.selected) then
			self:SetActive(self.selected.gameObject,isSelected)
		end
	end
end

function LockItemCell:SetData( data )
	-- body
	self.data = data
	self.cardItem:SetActive(false);
	self.itemId = data.lockItemId
	if(self.itemId ~= nil)then
		if(data.face ~= nil)then
			self:Hide(self.frameObj)
			self:Hide(self.cardItem)
			self:Show(self.icon.gameObject)
			self:Show(self.bg)
			IconManager:SetFaceIcon(Table_Item[self.itemId].Icon,self.icon)		
			self.icon:MakePixelPerfect();		
			self.icon.width = math.floor(self.icon.width*0.7);
			self.icon.height = math.floor(self.icon.height*0.7);
		else			
			local itemData = Table_Item[self.itemId]
			if(itemData.Type == 80)then
				itemData = ItemData.new(nil,self.itemId)
				self:UpdateCardItem(itemData);
			elseif(itemData.Type == 1210)then
				itemData = ItemData.new(nil,self.itemId)				
				self:UpdateFrameCell(itemData)
			else
				self:Show(self.icon.gameObject)
				self:Hide(self.frameObj)
				self:Hide(self.cardItem)
				IconManager:SetItemIcon(itemData.Icon,self.icon)
			end	
			self.icon:MakePixelPerfect();		
		end
	else
		self:Hide(self.frameObj)
		self:Hide(self.cardItem)
		self:Show(self.icon.gameObject)
		self.itemId = -1
		self:Show(self.bg)

		IconManager:SetUIIcon("icon_30", self.icon)
		self.icon:MakePixelPerfect();
	end	
end


function LockItemCell:UpdateCardItem(data)
	if(self.cardItem)then
		self:Hide(self.icon.gameObject)
		self:Hide(self.frameObj)
		self:Show(self.cardItem)
		local mids = data.cardInfo.monsterID;
		if(mids)then
			local _,monsterID = next(mids);
			if(monsterID and Table_Monster[monsterID])then
				IconManager:SetFaceIcon(Table_Monster[monsterID].Icon, self.cardicon);
			end
		end
		self.cardlv.text = "Lv."..data.cardInfo.CardLv;
		self.cardquality.spriteName = "com_bg_card0"..data.cardInfo.Quality;
		self.cardpos.spriteName = CardPosIconConfig[data.cardInfo.Position];
	end
end

function LockItemCell:UpdateFrameCell(data)
	if(self.frameObj)then
		self:Hide(self.icon.gameObject)
		self:Show(self.frameObj)
		self:Hide(self.cardItem)
		self:Hide(self.bg)
		if(not self.frameCell)then
			self.frameCell = PortraitFrameCell.new(self.frameObj);
		end
		local framedata = Table_HeadImage[data.staticData.id];
		self.frameCell:SetData(framedata);
	end
end