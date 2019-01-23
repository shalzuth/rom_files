autoImport("EquipChooseBord")
autoImport("EquipRecoverCell")

EquipRecoverView = class("EquipRecoverView", ContainerView)

EquipRecoverView.ViewType = UIViewType.NormalLayer

function EquipRecoverView:OnEnter()
	EquipRecoverView.super.OnEnter(self)
	if self.npcdata then
		local npcRootTrans = self.npcdata.assetRole.completeTransform
		if npcRootTrans then
			self:CameraFocusOnNpc(npcRootTrans)
		end
	end
end

function EquipRecoverView:OnExit()
	self:CameraReset()
	EquipRecoverView.super.OnExit(self)
end

function EquipRecoverView:Init()
	local viewdata = self.viewdata.viewdata
	self.npcdata = viewdata and viewdata.npcdata

	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitView()
end

function EquipRecoverView:FindObjs()
	self.addItemButton = self:FindGO("AddItemButton")
	self.left = self:FindGO("LeftBg")
	self.targetBtn = self:FindGO("TargetCell")
	self.totalCost = self:FindGO("TotalCost"):GetComponent(UILabel)
end

local cardids = {}
function EquipRecoverView:AddEvts()
	self:AddClickEvent(self.addItemButton, function (go)
		self:ClickTargetCell()
	end)

	local recoverButton = self:FindGO("RecoverButton")
	self:AddClickEvent(recoverButton , function ()
		if self.nowdata then
			if MyselfProxy.Instance:GetROB() < tonumber(self.totalCost.text) then
				MsgManager.ShowMsgByID(1)
				return
			end

			local cells = self.recoverCtl:GetCells()
			local strength = false
			local enchant = false
			local upgrade = false
			TableUtility.ArrayClear(cardids)
			if #cells > 0 then
				strength = cells[1].toggle.value
				for i=2,3 do
					if cells[i].data ~= EquipRecoverProxy.RecoverType.EmptyCard and cells[i].toggle.value then
						TableUtility.ArrayPushBack(cardids , cells[i].data.id)
					end
				end
				enchant = cells[4].toggle.value
				upgrade = cells[5].toggle.value
			end

			local cardCount = #cardids
			local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.MainBag)
			if bagData:GetSpaceItemNum() < cardCount then
				MsgManager.ShowMsgByID(3101)
				return
			end

			if strength or cardCount > 0 or enchant or upgrade then
				ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.nowdata.id , strength , cardids , enchant, upgrade, strength)
			else

			end
		end
	end)
end

function EquipRecoverView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.ItemRestoreEquipItemCmd , self.HandleRecover)
end

function EquipRecoverView:InitView()
	local chooseContaienr = self:FindGO("ChooseContainer")
	self.chooseBord = EquipChooseBord.new(chooseContaienr, function ()
		return EquipRecoverProxy.Instance:GetRecoverEquips()
	end)
	self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
	self.chooseBord:Hide()

	self.targetCell = BaseItemCell.new(self.targetBtn)
	self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)

	local recoverGrid = self:FindComponent("RecoverGrid", UIGrid)
	self.recoverCtl = UIGridListCtrl.new(recoverGrid, EquipRecoverCell, "EquipRecoverCell")
	self.recoverCtl:AddEventListener(EquipRecoverEvent.Select, self.HandleSelect , self)
end

function EquipRecoverView:ChooseItem(itemData)
	self.nowdata = itemData
	self.targetCell:SetData(itemData)
	self.recoverCtl:ResetDatas(EquipRecoverProxy.Instance:GetRecoverToggle(itemData))

	self.chooseBord:Hide()
	self.targetBtn:SetActive(itemData~=nil)
	self.addItemButton:SetActive(itemData==nil)
end

function EquipRecoverView:ClickTargetCell()
	local equipdatas = EquipRecoverProxy.Instance:GetRecoverEquips()
	if #equipdatas>0 then
		self.chooseBord:ResetDatas(equipdatas, true)
		self.chooseBord:Show(false)
		self.left:SetActive(false)
	else
		MsgManager.ShowMsgByIDTable(390)
		self.chooseBord:Hide()
		self.left:SetActive(true)
	end
end

function EquipRecoverView:HandleSelect(cellctl)
	local totalCost = 0
	local cells = self.recoverCtl:GetCells()
	for i=1,#cells do
		if cells[i].toggle.value then
			totalCost = totalCost + tonumber(cells[i].cost.text)
		end
	end
	self.totalCost.text = totalCost
end

function EquipRecoverView:HandleRecover()
	local equipdatas = EquipRecoverProxy.Instance:GetRecoverEquips()
	self.chooseBord:ResetDatas(equipdatas, true)

	self:ChooseItem()
	self.left:SetActive(true)
end