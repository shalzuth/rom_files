EffectShowDataWraper = class("EffectShowDataWraper")
autoImport("CardNCell")
autoImport("ItemCell")
EffectShowDataWraper.IconType = {
	item = 1,
	skill =2,
	ui = 3,
	career = 4,
}

EffectShowDataWraper.DefaultWidth = 380
EffectShowDataWraper.DefaultHeight = 380
EffectShowDataWraper.Default = 1

EffectShowDataWraper.CardNCellResPath = ResourcePathHelper.UICell("CardNCell")

EffectShowDataWraper.ItemCellResPath = ResourcePathHelper.UICell("AwardItemCell")
function EffectShowDataWraper:ctor(itemData,effectPath,showType,from,callback)
	self.itemData = itemData
	self.callback = callback
	self.effectPath = effectPath
	self.showType = showType
	self.effectFromType = from
	self.obj = nil
	self.resPath = nil
	if(itemData.staticData)then
		self.dataName = itemData:GetName()
		self.canBeShare = itemData.staticData.Share == 1
	else
		self.tb = TableUtil.unserialize(itemData.data)
		self.dataName = self.tb.text
	end
end

function EffectShowDataWraper:canBeShared(  )
	return self.canBeShare
end

local tempVector3 = LuaVector3.zero
function EffectShowDataWraper:adjustDepth( obj )
	-- body
	local max = -999
	if(obj)then
		local objs = GameObjectUtil.Instance:GetAllChildren(obj)
		for i=1,#objs do
			local child = objs[i]
			local widget = child:GetComponent(UIWidget)
			if(widget)then
				widget.depth = widget.depth+50
				if(widget.depth > max)then
					max = widget.depth
				end
			end
		end
		-- NGUITools.NormalizeWidgetDepths()
	end
	return max
end

function EffectShowDataWraper:getModelObj( parent )
	-- body
	local obj
	if(self.showType == FloatAwardView.ShowType.ModelType)then
		obj = ItemUtil.getAssetPartByItemData(self.itemData.staticData.id,parent)
	elseif(self.showType == FloatAwardView.ShowType.ItemType)then
		self.resPath = EffectShowDataWraper.ItemCellResPath
		obj = Game.AssetManager_UI:CreateAsset(self.resPath,parent)
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		tempVector3:Set(1,1,1)
		obj.transform.localScale = tempVector3
		obj.name = "ItemCell";		
		self.cell = ItemCell.new(obj)
		self.cell:SetData(self.itemData)
		local max = self:adjustDepth(parent)
		local tx = GameObjectUtil.Instance:DeepFind(parent.transform.parent.gameObject, "Texture")
		if(tx)then
			tx = tx:GetComponent(UITexture)
			tx.depth = max+1
		end
	elseif(self.showType == FloatAwardView.ShowType.CardType)then		

		self.resPath = EffectShowDataWraper.CardNCellResPath
		obj = Game.AssetManager_UI:CreateAsset(self.resPath,parent)
		tempVector3:Set(0,35,0)
		obj.transform.localPosition = tempVector3
		tempVector3:Set(1,1,1)
		obj.transform.localScale = tempVector3
		obj.name = "CardNCell";		
		self.cell = CardNCell.new(obj)
		self.cell:SetData(nil)
		self.cell:SetData(self.itemData)
		self.cell:Hide(self.cell.useButton.gameObject)
		local max = self:adjustDepth(parent)
		local tx = GameObjectUtil.Instance:DeepFind(parent.transform.parent.gameObject, "Texture")
		if(tx)then
			tx = tx:GetComponent(UITexture)
			tx.depth = max+1
		end
	elseif(self.showType == FloatAwardView.ShowType.IconType)then
		obj = GameObject("tmp")
		obj.transform:SetParent(parent.transform)
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		local cpn = obj:AddComponent(UISprite)
		cpn.depth = 3
		if(self.itemData.type == EffectShowDataWraper.IconType.skill)then
			IconManager:SetSkillIcon(self.tb.icon,cpn)
		elseif(self.itemData.type == EffectShowDataWraper.IconType.career)then
			IconManager:SetProfessionIcon(self.tb.icon,cpn)
		elseif(self.itemData.type == EffectShowDataWraper.IconType.ui)then
			IconManager:SetUIIcon(self.tb.icon, cpn);
		elseif(self.itemData.type == EffectShowDataWraper.IconType.item)then
			IconManager:SetItemIcon(self.tb.icon, cpn);
		end

		cpn:MakePixelPerfect();
		local scale = self.tb.scale or EffectShowDataWraper.Default
		local cpnWidth = cpn.width*scale
		local cpnHeight = cpn.height*scale
		if(cpnWidth > EffectShowDataWraper.DefaultWidth or cpnHeight > EffectShowDataWraper.DefaultHeight)then
			local orginRatio = EffectShowDataWraper.DefaultWidth / EffectShowDataWraper.DefaultHeight 
			local textureRatio =  cpnWidth / cpnHeight
			local wRatio = math.min(orginRatio,textureRatio) == orginRatio		
			local height = EffectShowDataWraper.DefaultHeight 
			local width = EffectShowDataWraper.DefaultWidth
			if(wRatio)then
				height = EffectShowDataWraper.DefaultWidth/textureRatio
			else
				width = EffectShowDataWraper.DefaultHeight*textureRatio
			end
			cpn.width = width
			cpn.height = height
			tempVector3:Set(1,1,1)
			obj.transform.localScale = tempVector3
		else
			tempVector3:Set(1,1,1)
			tempVector3:Mul(scale)
			obj.transform.localScale = tempVector3
		end		
	end
	self.obj = obj
	return obj
end

function EffectShowDataWraper:Exit(  )
	-- body
	if(self.cell)then
		self.cell:SetData(nil)
	end
	if(self.obj and self.showType == FloatAwardView.ShowType.ModelType)then
		self.obj:Destroy()
	elseif(self.obj and self.resPath)then
		Game.GOLuaPoolManager:AddToUIPool(self.resPath, self.obj)
	elseif(self.obj)then
		GameObject.DestroyImmediate(self.obj)
	end
	
	self.cell = nil
	self.obj = nil
end

function EffectShowDataWraper:clone(  )
	-- body
	local showData = EffectShowDataWraper.new(self.itemData,self.effectPath,self.showType,self.effectFromType)
	return showData
end