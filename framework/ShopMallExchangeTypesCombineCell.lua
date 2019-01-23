local baseCell = autoImport("BaseCell")
ShopMallExchangeTypesCombineCell = class("ShopMallExchangeTypesCombineCell",baseCell)

autoImport("ShopMallExchangeTypesCell")

function ShopMallExchangeTypesCombineCell:Init()
	self:FindObjs()
	self:InitShow()
end

function ShopMallExchangeTypesCombineCell:FindObjs()
	self.fahterObj = self:FindGO("FatherTypes")
	self.fatherSprite = self.fahterObj:GetComponent(UIMultiSprite)
	self.fatherLabel = self:FindComponent("Label", UILabel, self.fatherSprite.gameObject)
	self.tweenPlay = self.fahterObj:GetComponent(UIPlayTween)
	self.fatherSymbol = self:FindGO("Symbol", self.fahterObj)	
	self.childBg = self:FindComponent("ChildBg", UISprite)
end

function ShopMallExchangeTypesCombineCell:InitShow()
	self.fatherCell = ShopMallExchangeTypesCell.new(self.fahterObj)
	self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self)

	local grid = self:FindComponent("ChildTypes", UIGrid)
	self.childCtl = UIGridListCtrl.new(grid, ShopMallExchangeTypesCell, "ShopMallExchangeTypesCell")
	self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)

	self.childSpace = grid.cellHeight
	self.animDir = false
end

function ShopMallExchangeTypesCombineCell:ClickFather(cellCtl,isOpen)

	if isOpen and self.animDir then
		
	else
		self:PlayAnim(not self.animDir)
	end
	self:SetChoose(true)

	self:PassEvent(ShopMallEvent.ExchangeClickFatherTypes, {combine = self , cellCtl = cellCtl})

	if cellCtl.data then
		local childData = ShopMallProxy.Instance:GetExchangeBuyChildTypes(cellCtl.data.id)
		if childData == nil then
			self:PassEvent(MouseEvent.MouseClick, cellCtl)
		end
	end
end

function ShopMallExchangeTypesCombineCell:ClickChild(cellCtl)
	if cellCtl ~= self.nowChild then
		if self.nowChild then
			self.nowChild:SetChoose(false)
		end
		cellCtl:SetChoose(true)
		self.nowChild = cellCtl	
	end
	self:PassEvent(MouseEvent.MouseClick, cellCtl)
	-- self:PassEvent(MouseEvent.MouseClick, {type = "Child" , cellCtl = cellCtl})
end

function ShopMallExchangeTypesCombineCell:SetData(data)
	self.data = data
	if data then
		self.fatherCell:SetData(data)

		local childData = ShopMallProxy.Instance:GetExchangeBuyChildTypes(data.id)
		self.childCtl:ResetDatas(childData)

		if childData and #childData > 0 then
			self:Show(self.childBg)
			self:Show(self.fatherSymbol)
			
			self.childBg.height = 88 + self.childSpace * #childData
		else
			self:Hide(self.childBg)
			self:Hide(self.fatherSymbol)
		end
	end
end

function ShopMallExchangeTypesCombineCell:CancelChildChoose()
	if self.nowChild then
		self.nowChild:SetChoose(false)
		self.nowChild = nil
	end
end

function ShopMallExchangeTypesCombineCell:SetChoose(choose)
	self.fatherSprite.CurrentState = choose and 1 or 0;
	self.fatherLabel.effectColor = choose and Color(159/255, 79/255, 9/255) or Color(29/255, 45/255, 118/255)
	if(self.nowChild)then
		self.nowChild:SetChoose(false);
		self.nowChild = nil;
	end
end

function ShopMallExchangeTypesCombineCell:PlayAnim(forward)
	self.animDir = forward
	self.tweenPlay:Play(forward)
end