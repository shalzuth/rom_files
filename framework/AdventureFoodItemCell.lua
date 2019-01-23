autoImport("BaseCell");
AdventureFoodItemCell = class("AdventureFoodItemCell", ItemCell)

function AdventureFoodItemCell:Init()
	self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject);
	self.itemObj.transform.localPosition = Vector3.zero
	AdventureFoodItemCell.super.Init(self);	
	self:AddCellClickEvent();
	self.unlockClient = self:FindGO("unlockClient"):GetComponent(UISprite)
	self.BagChooseSymbol = self:FindGO("BagChooseSymbol")
	self.effectContainer = self:FindGO("EffectContainer");
end

function AdventureFoodItemCell:setIsSelected( isSelected )
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

function AdventureFoodItemCell:SetData(data)
	self:Show(self.itemObj)
	local itemData 
	if(data)then
		itemData = data.itemData
	end
	AdventureFoodItemCell.super.SetData(self, itemData)
	self.data = data
	self:Hide(self.unlockClient.gameObject)
	if(not data)then
		return 
	end
	self:PassEvent(AdventureFoodPage.CheckHashSelected,self)
	self:setItemIsLock(data)
	if(data.status == SceneFood_pb.EFOODSTATUS_ADD)then
		self:Show(self.unlockClient.gameObject)
	-- elseif(data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP)then
	-- 	local canBeClick = data:canBeClick()		
	-- 	if(canBeClick)then
	-- 		self:Show(self.unlockClient.gameObject)
	-- 		self.unlockClient.spriteName = "com_icon_add3"
	-- 		self.unlockClient:MakePixelPerfect();
	-- 	end
	-- end
	self:Show(self.foodStars[0])
	elseif(data.status == SceneFood_pb.EFOODSTATUS_CLICKED)then
		self:Hide(self.unlockClient.gameObject)
		self:Show(self.foodStars[0])
	else
		self:Hide(self.foodStars[0])
		self:Hide(self.unlockClient.gameObject)
		local atlas = RO.AtlasMap.GetAtlas("NewCom")
		if(atlas )then
			self.icon.atlas = atlas
			self.icon.spriteName = "Adventure_icon_03"
			self.icon:MakePixelPerfect();
		end
		self.bg.spriteName = "com_icon_bottom6"
	end
		
	-- if(data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT )then
	-- 	if(data.type == SceneManual_pb.EMANUALTYPE_NPC)then
	-- 		if(self.targetCell)then
	-- 			self.targetCell.frameSp.spriteName = "com_bg_head"
	-- 		end
	-- 	else
	-- 		self.bg.spriteName = "com_icon_bottom3"
	-- 	end
	-- else
	-- 	if(data.type == SceneManual_pb.EMANUALTYPE_NPC)then
	-- 		if(self.targetCell)then
	-- 			self.targetCell.frameSp.spriteName = "com_icon_bottom6"		
	-- 		end
	-- 	else
	-- 		self.bg.spriteName = "com_icon_bottom6"
	-- 	end
	-- 	-- self:Hide(self.bg.gameObject)
	-- 	-- self:Show(self.empty)
	-- end
	
	
end

local tempColor = LuaColor.white
function AdventureFoodItemCell:setItemIsLock( data )
	-- body
	-- if(data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT)then
	-- 	tempColor:Set(1,1,1,1)		
	-- 	self.icon.color = tempColor
	-- 	if(self.targetCell)then
	-- 		self.targetCell:SetActive(true)
	-- 	end
	-- else
	-- 	tempColor:Set(1.0/255.0,2.0/255.0,3.0/255.0,160/255)
	-- 	if(self.targetCell)then
	-- 		self.targetCell:SetActive(false)
	-- 	end
	-- 	self.icon.color = tempColor
	-- end
end

function AdventureFoodItemCell:PlayUnlockEffect()
	self:PlayUIEffect(EffectMap.UI.Activation,self.effectContainer,true)
end

