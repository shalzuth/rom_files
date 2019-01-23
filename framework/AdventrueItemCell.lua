autoImport("ItemCell");
AdventrueItemCell = class("AdventrueItemCell", ItemCell)

function AdventrueItemCell:Init()
	self.itemObj = self:LoadPreferb("cell/AdventureSimpleItemCell", self.gameObject);
	self.itemObj.transform.localPosition = Vector3.zero
	AdventrueItemCell.super.Init(self);	
	self:AddCellClickEvent();
	self.mvpMonster = self:FindGO("mvpMonster"):GetComponent(UISprite)
	self.unlockClient = self:FindGO("unlockClient"):GetComponent(UISprite)
	self.BagChooseSymbol = self:FindGO("BagChooseSymbol")
	self.starIcon =self:FindGO("starIcon"):GetComponent(UISprite)
	self.effectContainer = self:FindGO("EffectContainer");
	self.packageStoreState = self:FindComponent("packageStoreState",UISprite)
	self.canMakeDress = self:FindGO("canMakeDress")
end

function AdventrueItemCell:setIsSelected( isSelected )
	-- body
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		if(isSelected)then
			self:Show(self.BagChooseSymbol)
		else
			self:Hide(self.BagChooseSymbol)
		end
	end
end

function AdventrueItemCell:SetEvent(evtObj,event,hideSound)
	local hideType = {hideClickSound = true,hideClickEffect = true}
	self:AddClickEvent(evtObj,event,hideType)
end

local tempColor = LuaColor.white
function AdventrueItemCell:SetData(data)
	-- self:PassEvent(AdventureNormalList.UpdateCellRedTip, self);	
	self:PassEvent(AdventureNormalList.UpdateCellRedTip,{ctrl = self,ret = false})
	self.data = data
	self:Hide(self.mvpMonster.gameObject)
	self:Hide(self.canMakeDress)
	if(data and data.type == SceneManual_pb.EMANUALTYPE_NPC)then
		self:Hide(self.itemObj)
		self:initHeadImage()
	else
		self:removeHeadImage()
		self:Show(self.itemObj)
		AdventrueItemCell.super.SetData(self, data)
	end
	self:SetActive(self.invalid, false)
	self:setIsSelected(false)
	self:Hide(self.unlockClient.gameObject)
	self:Hide(self.starIcon.gameObject)
	self:Hide(self.packageStoreState.gameObject)
	if(not data)then
		return 
	end
	self:setIsSelected(data.isSelected)
	self:setItemIsLock(data)
	self:setPackageStoreState()
	self:setFashionMakeState()
	if(data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT )then
		self:Show(self.unlockClient.gameObject)
		self.unlockClient.spriteName = "com_icon_add2"
		self.unlockClient:MakePixelPerfect();
	-- elseif(data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP)then
	-- 	local canBeClick = data:canBeClick()		
	-- 	if(canBeClick)then
	-- 		self:Show(self.unlockClient.gameObject)
	-- 		self.unlockClient.spriteName = "com_icon_add3"
	-- 		self.unlockClient:MakePixelPerfect();
	-- 	end
	-- end
	 elseif(data:canBeClick())then
		self:Show(self.unlockClient.gameObject)
		self.unlockClient.spriteName = "com_icon_add3"
		self.unlockClient:MakePixelPerfect();
	end
		
	if(data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT )then
		if(data.type == SceneManual_pb.EMANUALTYPE_NPC)then
			if(self.targetCell)then
				self.targetCell.frameSp.spriteName = "com_bg_head"
			end
		else
			self.bg.spriteName = "com_icon_bottom3"
		end
	else
		if(data.type == SceneManual_pb.EMANUALTYPE_NPC)then
			if(self.targetCell)then
				self.targetCell.frameSp.spriteName = "com_icon_bottom6"		
			end
		else
			self.bg.spriteName = "com_icon_bottom6"
		end
		-- self:Hide(self.bg.gameObject)
		-- self:Show(self.empty)
	end
	
	if(data.type == SceneManual_pb.EMANUALTYPE_MONSTER or data.type == SceneManual_pb.EMANUALTYPE_PET)then
		if(data.staticData.Icon and data.staticData.Icon ~= "")then
			self:Show(self.icon.gameObject)		
			local sus = IconManager:SetFaceIcon(data.staticData.Icon,self.icon)
			if(not sus)then
				IconManager:SetFaceIcon("boli",self.icon)
			end
			if(data.staticData.Type == "MVP")then
				self:Show(self.mvpMonster.gameObject)
				IconManager:SetUIIcon("ui_HP_1",self.mvpMonster)
				-- self.mvpMonster.spriteName = "ui_HP_1"
			elseif(data.staticData.Type == "MINI")then
				self:Show(self.mvpMonster.gameObject)
				IconManager:SetUIIcon("ui_HP_2",self.mvpMonster)
				-- self.mvpMonster.spriteName = "ui_HP_2"
			end

			if(data.staticData.IsStar and data.staticData.IsStar == 1)then
				self:Show(self.starIcon.gameObject)
				IconManager:SetUIIcon("icon_40",self.starIcon)
				-- self.starIcon.spriteName = "icon_40"
				self.starIcon:MakePixelPerfect()
			else
				self:Hide(self.starIcon.gameObject)
			end

			self.icon:MakePixelPerfect();
			-- self.icon.transform.localScale = Vector3(0.7,0.7,1)
		else
			self:Hide(self.icon.gameObject)
		end
	else
		self:Hide(self.starIcon.gameObject)
		local type = data.staticData.Type			
		if(type and AdventureDataProxy.Instance:isCard(type))then
			if(data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
				-- self:SetTextureColor(self.bg,Color(1/255,2/255,3/255,160/255),true)
				-- self:SetTextureColor(self.cardItem, Color(1,1,1,1), true)
				-- self.cardItem:SetCardWhite()
			else
				self.cardItem:SetCardGrey();
				-- self:SetTextureColor(self.cardItem,Color(1/255,2/255,3/255,160/255),true)
				-- self:SetTextureColor(self.bg, Color(1,1,1,1), true)
			end
		elseif(type and type == 1210)then
			self:Hide(self.bg.gameObject)
			if(data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
				self:SetTextureColor(self.frameItem, Color(1,1,1,1), true)
			else
				self:SetTextureColor(self.frameItem,Color(1/255,2/255,3/255,160/255),true)
			end
		elseif(data.type == SceneManual_pb.EMANUALTYPE_COLLECTION)then
			local atlas = RO.AtlasMap.GetAtlas("NewCom")
			if(atlas and data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY)then
				self.icon.atlas = atlas
				self.icon.spriteName = "Adventure_icon_03"
				self.icon:MakePixelPerfect();
			end
		end
	end

	local RedTipCell = self:FindGO("RedTipCell")

	if(self.data:isCollectionGroup())then		
		if(self.data:isTotalComplete())then
			self.bg.spriteName = "com_icon_bottom3"
		elseif(self.data:isTotalUnComplete())then
			local atlas = RO.AtlasMap.GetAtlas("NewCom")
			self.icon.atlas = atlas
			self.icon.spriteName = "Adventure_icon_03"
			self.icon:MakePixelPerfect();
			self.bg.spriteName = "com_icon_bottom6"
		else
			local atlas = RO.AtlasMap.GetAtlas("NewCom")
			-- self.icon.atlas = atlas
			-- self.icon.spriteName = "Adventure_icon_03"
			-- self.icon:MakePixelPerfect();
			-- self.bg.spriteName = "com_icon_bottom6"
			tempColor:Set(1.0/255.0,2.0/255.0,3.0/255.0,160/255)
			self.icon.color = tempColor
			self:Show(self.unlockClient.gameObject)
			self.unlockClient.spriteName = "Adventure_icon_03"
			self.unlockClient:MakePixelPerfect();
			self:PassEvent(AdventureNormalList.UpdateCellRedTip,{ctrl = self,ret = true})
			if(RedTipCell)then
				self:Show(RedTipCell)
			end
		end
	else
		if(RedTipCell)then
			self:Hide(RedTipCell)
		end
	end
end

function AdventrueItemCell:setItemIsLock( data )
	-- body
	-- printRed("data.status:")
		-- print(data.status)
	if(data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
		-- self.bg.color = Color(1/255,2/255,3/255,4/255)
		-- self.quality.color = Color(1/255,2/255,3/255,4/255)

		tempColor:Set(1,1,1,1)		
		self.mvpMonster.color = tempColor
		self.icon.color = tempColor
		self.starIcon.color = tempColor
		if(self.targetCell)then
			self.targetCell:SetActive(true)
		end
	else
		tempColor:Set(1.0/255.0,2.0/255.0,3.0/255.0,160/255)
		if(self.targetCell)then
			self.targetCell:SetActive(false)
		end
		self.mvpMonster.color = tempColor
		self.icon.color = tempColor
		self.starIcon.color = tempColor
		-- self.bg.color = Color(1,1,1,1)
		-- local qInt = data.staticData.Quality;
		-- if(qInt and qInt~=0)then
		-- 	self.quality.color = CustomColor.ItemFrameColor[qInt];
		-- end			
	end
end

-- function AdventrueItemCell:(  )
-- 	-- body
-- end

function AdventrueItemCell:removeHeadImage(  )
	if(self.targetCell)then
		GameObject.Destroy(self.targetCell.gameObject)
		-- Game.GOLuaPoolManager:AddToUIPool(AdventrueItemCell.headResId , self.targetCell.gameObject)
		self.targetCell = nil
	end
end

function AdventrueItemCell:setFashionMakeState(  )
	if(self.data.type ~= SceneManual_pb.EMANUALTYPE_FASHION)then
		return
	end
	local islock = not self.data.store and self.data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY
	if(AdventureDataProxy.Instance:CheckFashionCanMake(self.data.staticId) and islock)then
		self:Show(self.canMakeDress)
	else
		self:Hide(self.canMakeDress)
	end
end

function AdventrueItemCell:setPackageStoreState(  )
	if(self.data.type ~= SceneManual_pb.EMANUALTYPE_CARD and self.data.type ~= SceneManual_pb.EMANUALTYPE_FASHION)then
		return
	end
	if(self.data and self.data.store)then
		self:Show(self.packageStoreState.gameObject)
		self.packageStoreState.spriteName = "Adventure_icon_02"
	elseif(self.data and AdventureDataProxy.Instance:checkFashionCanStore(self.data))then
		self:Show(self.packageStoreState.gameObject)
		self.packageStoreState.spriteName = "Adventure_icon_01"
	else
		self:Hide(self.packageStoreState.gameObject)
	end
end

function AdventrueItemCell:initHeadImage(  )
	-- body
	if(not self.targetCell)then
		-- local headCellObj = self:FindGO("PortraitCell")
		-- local headCellObj = Game.AssetManager_UI:CreateAsset(AdventrueItemCell.headResId , self.gameObject)

		self.targetCell = HeadIconCell.new()
		self.targetCell:CreateSelf(self.gameObject)
		self.targetCell:SetScale(0.65)
		self.targetCell:SetMinDepth(3)

		-- headCellObj.transform.localPosition = Vector3.zero
		-- headCellObj.transform.localScale = Vector3(0.675,0.675,0.675)
		-- self.targetCell = PlayerFaceCell.new()
		-- self.targetCell:Hide(self.targetCell.hp.gameObject)
		-- self.targetCell:Hide(self.targetCell.mp.gameObject)
		-- self.targetCell:HideLevel()
		-- self.targetCell:HideHpMp()
	end
	
	-- local headData = HeadImageData.new();
	-- headData:TransByNpcData(self.data.staticData);
	-- -- 临时处理
	-- headData.frame = nil;
	local npcdata = self.data.staticData
	local data = ReusableTable.CreateTable()
	if(npcdata.Icon == "")then
		data.bodyID = npcdata.Body or 0
		data.hairID = npcdata.Hair or 0
		data.haircolor = npcdata.HeadDefaultColor or 0
		data.gender = npcdata.Gender or -1
		data.eyeID = npcdata.Eye or 0
		self.targetCell:SetData(data)
	else
		self.targetCell:SetSimpleIcon(npcdata.Icon)
	end

	ReusableTable.DestroyTable(data)
end

function AdventrueItemCell:PlayUnlockEffect()
	self:PlayUIEffect(EffectMap.UI.Activation,self.effectContainer,true)
end

