autoImport("AuctionSignUpSelectCell")

AuctionSignUpSelectView = class("AuctionSignUpSelectView", ContainerView)

AuctionSignUpSelectView.ViewType = UIViewType.PopUpLayer

function AuctionSignUpSelectView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function AuctionSignUpSelectView:FindObjs()
	self.confirmBtn = self:FindGO("ConfirmBtn"):GetComponent(UIMultiSprite)
	self.confirmLabel = self:FindGO("Label", self.confirmBtn.gameObject):GetComponent(UILabel)
end

function AuctionSignUpSelectView:AddEvts()
	self:AddClickEvent(self.confirmBtn.gameObject, function ()
		self:Confirm()
	end)	
end

function AuctionSignUpSelectView:AddViewEvts()
	
end

function AuctionSignUpSelectView:InitShow()
	local data = self.viewdata.viewdata
	if data then
		self.tipData = {}
		self.tipData.funcConfig = {}

		local container = self:FindGO("Container")
		self.itemWrapHelper = WrapListCtrl.new(container, AuctionSignUpSelectCell, "AuctionSignUpSelectCell", WrapListCtrl_Dir.Vertical, 4, 97)
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.Select, self)

		self.itemWrapHelper:ResetDatas(data)

		self:UpdateConfirm()
	end
end

function AuctionSignUpSelectView:Select(cell)
	local data = cell.data
	if data then
		if self.lastSelect ~= nil then
			self.lastSelect:SetChoose(false)
		end

		cell:SetChoose(true)
		self.lastSelect = cell

		TipManager.Instance:CloseItemTip()

		self.tipData.itemdata = data
		self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220,0})

		self:UpdateConfirm()
	end
end

function AuctionSignUpSelectView:Confirm()
	if self.lastSelect ~= nil then
		TipManager.Instance:CloseItemTip()
		
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AuctionSignUpDetailView, viewdata = {itemdata = self.lastSelect.data}})
	end
end

function AuctionSignUpSelectView:UpdateConfirm()
	self:SetConfirm(self.lastSelect == nil)
end

function AuctionSignUpSelectView:SetConfirm(isGray)
	if isGray then
		self.confirmBtn.CurrentState = 1
		self.confirmLabel.effectStyle = UILabel.Effect.None
	else
		self.confirmBtn.CurrentState = 0
		self.confirmLabel.effectStyle = UILabel.Effect.Outline
	end
end