autoImport('EquipChooseBord')
autoImport('MiyinStrengthen')
autoImport('UIModelMiyinStrengthen')
autoImport('FunctionMiyinStrengthen')

UIViewControllerMiyinStrengthen = class('UIViewControllerMiyinStrengthen', ContainerView)

UIViewControllerMiyinStrengthen.ViewType = UIViewType.NormalLayer

UIViewControllerMiyinStrengthen.instance = nil

function UIViewControllerMiyinStrengthen:Init()
	UIViewControllerMiyinStrengthen.instance = self

	self:GetGameObjects()
	self.goTip:SetActive(false)
	self:RegisterButtonClickEvent()
	self:LoadView()
	self:Listen()
	self:ListenServerResponse()
end

function UIViewControllerMiyinStrengthen:OnEnter()
	UIViewControllerMiyinStrengthen.super.OnEnter(self)

	self:FocusOnNPC()
end

function UIViewControllerMiyinStrengthen:OnExit()
	UIViewControllerMiyinStrengthen.super.OnExit(self)

	self:CancelListen()

	UIViewControllerMiyinStrengthen.instance = nil

	self:CameraReset()
end

function UIViewControllerMiyinStrengthen:GetGameObjects()
	self.goEquipChooseBordParent = self:FindGO('EquipChooseBordParent')
	self.goBTNClose = self:FindGO('BTN_Close')
	self.goZenyBalance = self:FindGO('ZenyBalance')
	self.labZenyBalance = self:FindGO('Lab', self.goZenyBalance):GetComponent(UILabel)
	self.goTip = self:FindGO('Tip')
end

function UIViewControllerMiyinStrengthen:RegisterButtonClickEvent()
	self:AddClickEvent(self.goBTNClose, function (go)
		self:OnClickForButtonClose(go)
	end)
end

function UIViewControllerMiyinStrengthen:Listen()
	
end

function UIViewControllerMiyinStrengthen:ListenServerResponse()
	self:AddListenEvt(MyselfEvent.MyDataChange, self.OnReceiveEventMyDataChange)
end

function UIViewControllerMiyinStrengthen:CancelListen()
	if self.equipChooseBord ~= nil then
		self.equipChooseBord:RemoveEventListener(EquipChooseBord.ChooseItem, self.OnEquipBeSelected, self)
	end
end

function UIViewControllerMiyinStrengthen:LoadView()
	if self.msViewController == nil then
		self.msViewController = self:AddSubView('MiyinStrengthen', MiyinStrengthen)
		self.msViewController:Show()
		self.msViewController:SetEmpty()
	end
	self.msViewController:RefreshSelf()

	self:LoadZenyBalanceView()
end

function UIViewControllerMiyinStrengthen:LoadView_EquipChooseBoard()
	if self.equipChooseBord == nil then
		local func = function ()
			return UIModelMiyinStrengthen.Ins():GetEquipedItems_ValidPart()
		end
		self.equipChooseBord = EquipChooseBord.new(self.goEquipChooseBordParent, func)
		self.equipChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnEquipBeSelected, self)
		local pos = self.equipChooseBord.gameObject.transform.localPosition
		pos.x = 60
		self.equipChooseBord.gameObject.transform.localPosition = pos
	end
	self.equipChooseBord:Show(true)
end

function UIViewControllerMiyinStrengthen:LoadZenyBalanceView()
	local milCommaBalance = FuncZenyShop.FormatMilComma(MyselfProxy.Instance:GetROB())
	if milCommaBalance then
		self.labZenyBalance.text = milCommaBalance
	end
end

function UIViewControllerMiyinStrengthen:OnClickForButtonClose(go)
	self:CloseSelf()
end

function UIViewControllerMiyinStrengthen:OnReceiveEventMyDataChange(data)
	self:LoadZenyBalanceView()
end

function UIViewControllerMiyinStrengthen:OnEquipBeSelected(itemData)
	self.equipChooseBord:Hide()
	self.goTip:SetActive(true)
	self.msViewController:Refresh(itemData)
end

function UIViewControllerMiyinStrengthen:FocusOnNPC()
	local npcCreature = FunctionMiyinStrengthen.Ins():GetNPCCreature()
	if npcCreature ~= nil then
		local viewPort = CameraConfig.SwingMachine_ViewPort
		local rotation = CameraConfig.SwingMachine_Rotation

		local transNPC = npcCreature.assetRole.completeTransform;
		self:CameraFocusAndRotateTo(transNPC, viewPort, rotation)
	end
end