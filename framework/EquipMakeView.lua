autoImport("MakeMaterialCell")
autoImport("EquipMakeCell")

EquipMakeView = class("EquipMakeView", ContainerView)

EquipMakeView.ViewType = UIViewType.NormalLayer

function EquipMakeView:OnEnter()
	EquipMakeView.super.OnEnter(self)

	if self.npc then
		local viewPort = CameraConfig.HappyShop_ViewPort
		local rotation = CameraConfig.HappyShop_Rotation
		self:CameraFaceTo(self.npc.assetRole.completeTransform,viewPort,rotation)
	end
end

function EquipMakeView:OnExit()
	self:CameraReset()
	self:SetChooseMakeData(false)
	EquipMakeView.super.OnExit(self)
end

function EquipMakeView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EquipMakeView:FindObjs()
	self.silverLabel = self:FindGO("SilverLabel"):GetComponent(UILabel)
	self.selfProfession = self:FindGO("SelfProfession"):GetComponent(UIToggle)
	self.makeTitle = self:FindGO("MakeTitle"):GetComponent(UILabel)
	self.costInfo = self:FindGO("CostInfo")
	self.silverCost = self:FindGO("ZenyCost"):GetComponent(UILabel)
	self.tip = self:FindGO("Tip"):GetComponent(UILabel)
	self.emptyTip = self:FindGO("EmptyTip")
	self.makeBtn = self:FindGO("MakeBtn"):GetComponent(UISprite)
	-- self.makeBtnLabel = self:FindGO("Label" , self.makeBtn.gameObject):GetComponent(UILabel)
end

function EquipMakeView:AddEvts()
	self:AddClickEvent(self.makeBtn.gameObject,function ()
		if self.curComposeId == nil then
			return
		end

		--判断材料是否足够
		local enoughMaterial = self.total - self.need
		--判断金币是否足够
		local data = Table_Compose[self.curComposeId]
		local enoughROB = MyselfProxy.Instance:GetROB() - data.ROB
		--判断是否解锁
		local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)

		if enoughMaterial < 0 then
			--缺失item列表
			local needList = ReusableTable.CreateArray()
			local cells = self.makeMatCtl:GetCells()
			for i=1,#cells do
				local needCount = cells[i]:NeedCount()
				if needCount > 0 then
					local needData = ReusableTable.CreateTable()
					needData.id = cells[i].data.id
					needData.count = needCount
					TableUtility.ArrayPushBack(needList, needData)
				end
			end
			--弹出快速购买界面
			if not QuickBuyProxy.Instance:TryOpenView(needList) then
				MsgManager.ShowMsgByID(8)
			end
			--clear
			for i=1,#needList do
				ReusableTable.DestroyAndClearTable(needList[i])
			end
			ReusableTable.DestroyArray(needList)
			return
		elseif enoughROB < 0 then
			MsgManager.ShowMsgByID(1)
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

		ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_EQUIP, self.curComposeId , self.npc.data.id)
	end)
	EventDelegate.Add(self.selfProfession.onChange, function ()
		if self.isSelfProfession ~= self.selfProfession.value then
			self.isSelfProfession = self.selfProfession.value

			self:UpdateMakeList()
			self.itemWrapHelper:ResetPosition()

			self:SelectFirstMakeCell()
		end
	end)
end

function EquipMakeView:AddViewEvts()
	self:AddListenEvt( MyselfEvent.MyDataChange , self.MyDataChange )
	self:AddListenEvt( ItemEvent.ItemUpdate , self.UpdateItem )
end

function EquipMakeView:InitShow()

	self.isSelfProfession = true
	self.tipData = {}
	self.tipData.funcConfig = {}

	self.npc = self.viewdata.viewdata.npcdata
	EquipMakeProxy.Instance:SetNpcId(self.npc.data.staticData.id)

	local targetCellGO = self:FindGO("TargetCell")
	self.targetCell = BaseItemCell.new(targetCellGO)
	self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)

	local makeMaterialGrid = self:FindGO("MakeMaterialGrid"):GetComponent(UIGrid)
	self.makeMatCtl = UIGridListCtrl.new(makeMaterialGrid, MakeMaterialCell, "MakeMaterialCell")
	self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMakeMaterialItem, self)

	local makeListContainer = self:FindGO("MakeListContainer")
	local wrapConfig = {
		wrapObj = makeListContainer, 
		pfbNum = 6, 
		cellName = "EquipMakeCell", 
		control = EquipMakeCell, 
		dir = 1,
	}
	self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickMakeCell, self)

	local isEmpty = self:UpdateMakeList()
	if isEmpty then
		self.selfProfession.value = false
	end
	self:UpdateCoins()

	--默认选中第一个
	self:SelectFirstMakeCell()
end

function EquipMakeView:SelectFirstMakeCell()
	local itemCells = self.itemWrapHelper:GetCellCtls()
	if #itemCells > 0 then
		self:ClickMakeCell(itemCells[1])
	end
end

function EquipMakeView:ClickMakeCell(cellctl)
	local data = cellctl.data
	if data then
		if self.curComposeId and self.curComposeId ~= data then
			self:SetChooseMakeData(false)
			self:SetChooseCell(false)
		end

		self.curComposeId = data

		self:SetChooseMakeData(true)
		cellctl:SetChoose(true)

		self:UpdateTargetCell()
		self:UpdateItem()

		local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
		if makeData and makeData:IsLock() then
			self.tip.gameObject:SetActive(true)
			self.costInfo:SetActive(false)

			self:UpdateTip()
		else
			self.tip.gameObject:SetActive(false)
			self.costInfo:SetActive(true)

			self:UpdateCost()
		end
	end
end

function EquipMakeView:ClickTargetCell(cellctl)

	self.tipData.itemdata = cellctl.data

	self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-170,0})
end

function EquipMakeView:ClickMakeMaterialItem(cellctl)

	self.tipData.itemdata = cellctl.itemData

	self:ShowItemTip(self.tipData , cellctl.icon , NGUIUtil.AnchorSide.Left, {-220,0})
end

function EquipMakeView:UpdateMakeList()
	local data = EquipMakeProxy.Instance:GetMakeList()
	if self.isSelfProfession then
		data = EquipMakeProxy.Instance:GetSelfProfessionMakeList()
	end
	self.itemWrapHelper:UpdateInfo(data)

	local isEmpty = #data == 0	
	if isEmpty then
		self:UpdateEmpty()
	end
	self.emptyTip:SetActive(isEmpty)

	return isEmpty
end

function EquipMakeView:UpdateMakeMaterial()
	local data = Table_Compose[self.curComposeId]
	local datas = data and data.BeCostItem or {}
	self.makeMatCtl:ResetDatas(datas)
end

function EquipMakeView:UpdateTargetCell()
	local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
	if makeData then
		self.targetCell:SetData(makeData.itemData)
	else
		self.targetCell.nameLab.text = ""
		self.targetCell.normalItem:SetActive(false)
	end
end

function EquipMakeView:UpdateMakeTitle()
	local cells = self.makeMatCtl:GetCells()
	self.need = #cells
	self.total = 0
	for i=1,self.need do
		local cell = cells[i]
		if cell:IsEnough() then
			self.total = self.total + 1
		end
	end

	self.makeTitle.text = string.format(ZhString.EquipMake_Title , self.total , self.need)
end

function EquipMakeView:UpdateCost()
	local data = Table_Compose[self.curComposeId]
	self.silverCost.text = data and data.ROB or 0
end

function EquipMakeView:UpdateTip()
	local data = Table_Compose[self.curComposeId]
	self.tip.text = data and data.MenuDes or ""
end

function EquipMakeView:UpdateCoins()
	self.silverLabel.text = MyselfProxy.Instance:GetROB()
end

function EquipMakeView:MyDataChange()
	self:UpdateCoins()
end

function EquipMakeView:UpdateItem()
	self:UpdateMakeMaterial()
	self:UpdateMakeTitle()
end

function EquipMakeView:SetChooseMakeData(isChoose)
	local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
	if makeData then
		makeData:SetChoose(isChoose)
	end	
end

function EquipMakeView:SetChooseCell(isChoose)
	local cells = self.itemWrapHelper:GetCellCtls()
	for i=1,#cells do
		if cells[i].data == self.curComposeId then
			cells[i]:SetChoose(isChoose)
			break
		end
	end
end

function EquipMakeView:UpdateEmpty()
	if self.curComposeId then
		self:SetChooseMakeData(false)
		self:SetChooseCell(false)
	end

	self.curComposeId = nil

	self:UpdateTargetCell()
	self:UpdateItem()

	self.tip.gameObject:SetActive(false)
	self.costInfo:SetActive(true)
	self:UpdateCost()
end