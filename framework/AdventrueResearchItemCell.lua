autoImport("ItemCell");
AdventrueResearchItemCell = class("AdventrueResearchItemCell", ItemCell)

function AdventrueResearchItemCell:Init()
	self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject);
	self.itemObj.transform.localPosition = Vector3.zero
	AdventrueResearchItemCell.super.Init(self);	
	self:AddCellClickEvent();
	self.unlockCt = self:FindGO("unlockCt")
	self.BagChooseSymbol = self:FindGO("BagChooseSymbol")
end

function AdventrueResearchItemCell:setIsSelected( isSelected )
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

function AdventrueResearchItemCell:SetEvent(evtObj,event,hideSound)
	local hideType = {hideClickSound = true,hideClickEffect = true}
	self:AddClickEvent(evtObj,event,hideType)
end

function AdventrueResearchItemCell:SetData(data)
	self.data = data
	AdventrueResearchItemCell.super.SetData(self,data)
	self:Hide(self.unlockCt)
	self:Hide(self.invalid)
	self:setIsSelected(false)
	if(not data)then
		return 
	end
	self:setIsSelected(data.isSelected)
	self.status = true	
	if(data.type == SceneManual_pb.EMANUALTYPE_EQUIP)then
		self.status = AdventureDataProxy.Instance:checkEquipIsUnlock(self.data.staticId)
	elseif(data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or data.type == SceneManual_pb.EMANUALTYPE_ITEM)then
		self.status = AdventureDataProxy.Instance:checkShopItemIsUnlock(self.data.staticId)
	elseif(data.type == SceneManual_pb.EMANUALTYPE_MATE)then
		if(data.staticData.Icon and data.staticData.Icon ~= "")then
			self:Show(self.icon.gameObject)		
			local sus = IconManager:SetFaceIcon(data.staticData.Icon,self.icon)
			if(not sus)then
				IconManager:SetFaceIcon("boli",self.icon)
			end

			self.icon:MakePixelPerfect();
			-- self.icon.transform.localScale = Vector3(0.7,0.7,1)
		else
			self:Hide(self.icon.gameObject)
		end
		self.status = AdventureDataProxy.Instance:checkMercenaryCatIsUnlock(self.data:getCatId())
	end
	self:setItemIsLock()
end

function AdventrueResearchItemCell:setItemIsLock(  )
	-- body
	if(self.status)then
		self:Hide(self.unlockCt)
	else
		self:Show(self.unlockCt)
	end
end