autoImport("BusinessmanMakeMaterialCell")
autoImport("BusinessmanMakeItemCell")
autoImport("BusinessmanMakeModelCell")
autoImport("BusinessmanMakeTypeCell")

MakeBaseView = class("MakeBaseView", ContainerView)

MakeBaseView.ViewType = UIViewType.NormalLayer

local normalMaterialPosVec = LuaVector3.zero
local greatMaterialPosVec = LuaVector3.zero

function MakeBaseView:OnExit()
	if self.plusTick ~= nil then
		TimeTickManager.Me():ClearTick(self, 1)
		self.plusTick = nil
	end
	if self.subtractTick ~= nil then
		TimeTickManager.Me():ClearTick(self, 2)
		self.subtractTick = nil
	end
	MakeBaseView.super.OnExit(self)
end

function MakeBaseView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function MakeBaseView:FindObjs()
	self.makeRoot = self:FindGO("MakeRoot")
	self.makeBtn = self:FindGO("MakeBtn"):GetComponent(UISprite)
	self.makeCount = self:FindGO("MakeCount"):GetComponent(UIInput)
	self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
	self.countPlus = self:FindGO("CountPlus"):GetComponent(UISprite)
	self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
	self.countSubtract = self:FindGO("CountSubtract"):GetComponent(UISprite)
	self.lockTip = self:FindGO("LockTip"):GetComponent(UILabel)
	self.itemTable = self:FindGO("ItemTable"):GetComponent(UITable)
	self.normalProduct = self:FindGO("NormalProduct")
	self.greatProduct = self:FindGO("GreatProduct")
	self.normalRoot = self:FindGO("NormalRoot", self.normalProduct)
	self.modelRoot = self:FindGO("ModelRoot", self.normalProduct)
	self.makeMaterial = self:FindGO("MakeMaterialGrid")
end

function MakeBaseView:AddEvts()
	self:AddClickEvent(self.makeBtn.gameObject,function ()
		if self.curComposeId == nil then
			return
		end

		self:calcMakeMaterial()
		--判断材料是否足够
		local enoughMaterial = self.total - self.need
		--判断是否解锁
		local makeData = BusinessmanMakeProxy.Instance:GetMakeData(self.curComposeId)

		if enoughMaterial < 0 then
			MsgManager.ShowMsgByID(8)
			return
		elseif makeData:IsLock() then
			local composeData = Table_Compose[self.curComposeId]
			if composeData and composeData.MenuID then
				local menuData = Table_Menu[composeData.MenuID]
				if menuData and menuData.sysMsg and menuData.sysMsg.id then
					MsgManager.ShowMsgByID(menuData.sysMsg.id)
				end
			end
			return
		end

		ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_TRADER, self.curComposeId, nil, nil, self.makeTimes)
	end)

	self:AddPressEvent(self.countPlus.gameObject,function (g,b)
		self:PressCountPlus(b)
	end)
	self:AddPressEvent(self.countSubtract.gameObject,function (g,b)
		self:PressCountSubtract(b)
	end)
	EventDelegate.Set(self.makeCount.onChange,function ()
		self:InputOnChange()
	end)
end

function MakeBaseView:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate , self.HandleItemUpdate)
	self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleItemUpdate)
end

function MakeBaseView:InitShow()

	self.isSelfProfession = true
	self.tipData = {}
	self.tipData.funcConfig = {}

	local x,y,z = LuaGameObject.GetLocalPosition(self.makeMaterial.transform)
	normalMaterialPosVec:Set(x, -131, z)
	greatMaterialPosVec:Set(x, -159, z)

	--普通显示产物item cell	
	self.normalCell = BusinessmanMakeItemCell.new(self.normalRoot)
	self.normalCell:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)

	--普通显示产物model	
	self.modelCell = BusinessmanMakeModelCell.new(self.modelRoot)
	self.modelCell:AddEventListener(MouseEvent.MouseClick, self.ClickModelCell, self)

	--暴击显示产物item cell
	local greatNormalRoot = self:FindGO("NormalRoot", self.greatProduct)
	self.greatNormalCell = BusinessmanMakeItemCell.new(greatNormalRoot)
	self.greatNormalCell:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)

	--暴击显示暴击物品item cell
	local greatRoot = self:FindGO("GreatRoot", self.greatProduct)
	self.greatCell = BusinessmanMakeItemCell.new(greatRoot)
	self.greatCell:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)

	local makeMaterialGrid = self.makeMaterial:GetComponent(UIGrid)
	self.makeMatCtl = UIGridListCtrl.new(makeMaterialGrid, BusinessmanMakeMaterialCell, "BusinessmanMakeMaterialCell")
	self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMakeMaterialItem, self)

	self.typeCtl = UIGridListCtrl.new(self.itemTable, BusinessmanMakeTypeCell, "BusinessmanMakeTypeCell")
	self.typeCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)

	BusinessmanMakeProxy.Instance:InitItemList(self.type.Type)

	self:UpdateItemList()
	self:SelectFirst()
	self:ResetMakeCount()
end

function MakeBaseView:ClickCell(cellctl)
	self.tipData.itemdata = cellctl.data

	self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-170,0})
end

function MakeBaseView:ClickModelCell(cellctl)
	self.tipData.itemdata = cellctl.data

	self:ShowItemTip(self.tipData , self.makeBtn , NGUIUtil.AnchorSide.Left, {-220,0})
end

function MakeBaseView:ClickMakeMaterialItem(cellctl)

	self.tipData.itemdata = cellctl.itemData

	self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-220,0})
end

function MakeBaseView:ClickItem(cellctl)
	local data = cellctl.data
	if data then
		if self.lastItemCell then
			self.lastItemCell:SetChoose(false)
		end

		cellctl:SetChoose(true)
		self.lastItemCell = cellctl
		self.curComposeId = data.id

		self:UpdateItem(data)
		self:ResetMakeCount()
	end
end

function MakeBaseView:PressCountPlus(isPressed)
	if isPressed then
		self.countChangeRate = 1
		if self.plusTick == nil then
			self.plusTick = TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
				self:PressCount(1)
			end, self, 1)
		else
			self.plusTick:Restart()
		end
	else
		if self.plusTick then
			self.plusTick:StopTick()
		end
	end
end

function MakeBaseView:PressCountSubtract(isPressed)
	if isPressed then
		self.countChangeRate = 1
		if self.subtractTick == nil then
			self.subtractTick = TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
				self:PressCount(-1)
			end, self, 2)
		else
			self.subtractTick:Restart()
		end
	else
		if self.subtractTick then
			self.subtractTick:StopTick()
		end
	end	
end

function MakeBaseView:PressCount(change)
	self.makeTimes = self.makeTimes + self.countChangeRate * change
	self:UpdateMakeCount()

	if self.countChangeRate <= 3 then
		self.countChangeRate = self.countChangeRate + 1
	end
end

function MakeBaseView:InputOnChange()
	local count = tonumber(self.makeCount.value)

	if count == nil then
		return
	end

	self.makeTimes = count
	self:UpdateMakeCount()
end

function MakeBaseView:UpdateItemList()
	if self.type ~= nil then
		self.typeCtl:ResetDatas(self.type.Category)
	end
end

function MakeBaseView:UpdateMakeMaterial()
	local data = Table_Compose[self.curComposeId]
	local datas = data and data.BeCostItem or {}
	self.makeMatCtl:ResetDatas(datas)
end

function MakeBaseView:UpdateProduceCell(itemData)
	if itemData then
		self.produceCell:SetData(itemData)
	end
	local isShow = itemData ~= nil
	self.produceCell.gameObject:SetActive(isShow)
end

function MakeBaseView:UpdateItem(data)
	local isGreatProduce = data.produceItemData ~= nil 	--是否显示暴击
	local composeData = Table_Compose[self.curComposeId]
	if isGreatProduce then
		self.greatNormalCell:SetData(data.itemData)
		self.greatCell:SetData(data.produceItemData)

		self.greatNormalCell:SetProduceRate(composeData)

		self.greatNormalCell:SetProductNum(data, self.makeTimes)
		self.greatCell:SetProductNum(data, self.makeTimes)

		self.makeMaterial.transform.localPosition = greatMaterialPosVec
	else
		local showType = BusinessmanMakeProxy.Instance:CheckItemType(data.itemData)
		if showType then
			self.modelCell:SetData(data.itemData, showType)
			self.modelCell:SetProduceRate(composeData)
			self.modelCell:SetProductNum(data, self.makeTimes)
		else
			self.normalCell:SetData(data.itemData)
			self.normalCell:SetProduceRate(composeData)
			self.normalCell:SetProductNum(data, self.makeTimes)
		end
		self.normalRoot:SetActive(showType == nil)
		self.modelRoot:SetActive(showType ~= nil)

		self.makeMaterial.transform.localPosition = normalMaterialPosVec
	end
	self.greatProduct:SetActive(isGreatProduce)
	self.normalProduct:SetActive(not isGreatProduce)

	self:UpdateMakeMaterial()
	if(data:IsLock()) then
		self:Hide(self.makeRoot)
		self:Show(self.lockTip.gameObject)
		local composeData = Table_Compose[data.id]
		self.lockTip.text = ZhString.Businessman_Need..Table_Menu[composeData.MenuID].Tip
	else
		self:Show(self.makeRoot)
		self:Hide(self.lockTip.gameObject)
	end
end

function MakeBaseView:UpdateMakeCount()
	if self.maxTimes == 1 then
		self:SetCountSubtract(0.5)
		self:SetCountPlus(0.5)
		self.makeTimes = 1
		self.countChangeRate = 1
	else
		if self.makeTimes <= 1 then
			self:SetCountSubtract(0.5)
			self:SetCountPlus(1)
			self.makeTimes = 1
			self.countChangeRate = 1
		elseif self.makeTimes >= self.maxTimes then
			self:SetCountSubtract(1)
			self:SetCountPlus(0.5)
			self.makeTimes = self.maxTimes
			self.countChangeRate = 1
		else
			self:SetCountSubtract(1)
			self:SetCountPlus(1)
		end
	end

	self.makeCount.value = self.makeTimes

	--更新右侧item cell右下角数量
	local data = BusinessmanMakeProxy.Instance:GetMakeData(self.curComposeId)
	local isGreatProduce = data.produceItemData ~= nil 	--是否显示暴击
	if isGreatProduce then
		self.greatNormalCell:SetProductNum(data, self.makeTimes)
		self.greatCell:SetProductNum(data, self.makeTimes)
	else
		local showType = BusinessmanMakeProxy.Instance:CheckItemType(data.itemData)
		if showType then
			self.modelCell:SetProductNum(data, self.makeTimes)
		else
			self.normalCell:SetProductNum(data, self.makeTimes)
		end
	end

	--更新材料需要总数
	local cells = self.makeMatCtl:GetCells()
	for i=1,#cells do
		local cell = cells[i]
		cell:SetNum(nil, self.makeTimes)
	end
end

function MakeBaseView:HandleItemUpdate()
	local typeList = self.typeCtl:GetCells()
	for i=1,#typeList do
		local typeCell = typeList[i]
		for j=1,#typeCell:GetCombineCellList() do
			local combineCell = typeCell:GetCombineCellList()[j]
			for k=1,#combineCell.childrenObjs do
				local cell = combineCell.childrenObjs[k]
				if cell and cell.data then
					cell:SetCanMakeNum()
				end
			end
		end
	end

	self:UpdateMakeMaterial()
	self:ResetMakeCount()
end

function MakeBaseView:SelectFirst()
	local itemList = self.typeCtl:GetCells()[1]
	if itemList then
		local combineCell = itemList:GetCombineCellList()[1]
		if combineCell then
			local cell = combineCell.childrenObjs[1]
			if cell then
				self:ClickItem(cell)
			end
		end
	end
end

function MakeBaseView:ResetMakeCount()
	--制作次数
	self.makeTimes = 1
	self.maxTimes = BusinessmanMakeData.GetCanMakeTimes(self.curComposeId)
	if self.maxTimes == 0 then
		self.maxTimes = 1
	end

	self:UpdateMakeCount()
end

function MakeBaseView:calcMakeMaterial()
	local cells = self.makeMatCtl:GetCells()
	self.need = #cells
	self.total = 0
	for i=1,self.need do
		local cell = cells[i]
		if cell:IsEnough() then
			self.total = self.total + 1
		end
	end
end

function MakeBaseView:SetCountPlus(alpha)
	if self.countPlusBg.color.a ~= alpha then
		self:SetSpritAlpha(self.countPlusBg,alpha)
		self:SetSpritAlpha(self.countPlus,alpha)
	end
end

function MakeBaseView:SetCountSubtract(alpha)
	if self.countSubtractBg.color.a ~= alpha then
		self:SetSpritAlpha(self.countSubtractBg,alpha)
		self:SetSpritAlpha(self.countSubtract,alpha)
	end
end

function MakeBaseView:SetSpritAlpha(sprit,alpha)
	sprit.color = Color(sprit.color.r,sprit.color.g,sprit.color.b,alpha)
end