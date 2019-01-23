ChangeSaveNamePopUp = class("ChangeSaveNamePopUp", ContainerView)
ChangeSaveNamePopUp.ViewType = UIViewType.PopUpLayer

function ChangeSaveNamePopUp:Init()
	self:InitView()
	self:AddEvts()
	self:AddViewEvt()
end

function ChangeSaveNamePopUp:InitView()
	self.input = self:FindGO("NameInput"):GetComponent(UIInput)
	self.name = self:FindGO("Label",self.input.gameObject):GetComponent(UILabel)
	self.name.text = string.format(ZhString.MultiProfession_SaveName,self.viewdata.viewdata.id)
	-- UIUtil.LimitInputCharacter(self.input, 20)

	self.filterType = FunctionMaskWord.MaskWordType.SpecialSymbol | FunctionMaskWord.MaskWordType.NameExclude
end

function ChangeSaveNamePopUp:AddEvts()
	self:AddButtonEvent("ConfirmButton",function ()
		if self.input.value == "" then
			MsgManager.ShowMsgByID(1006)
			return
		end

		local value = self.input.value
		local result = FunctionMaskWord.Me():CheckMaskWord(value, self.filterType)
		if result then

			redlog("2604")
			MsgManager.ShowMsgByIDTable(2604)
			return
		end
		ServiceNUserProxy.Instance:CallChangeRecordNameUserCmd(self.viewdata.viewdata.id, value)
	end)

	self:AddButtonEvent("CancelButton",function ()
		self:CloseSelf()
	end)
end

function ChangeSaveNamePopUp:AddViewEvt()
	self:AddListenEvt(ServiceEvent.NUserChangeRecordNameUserCmd,self.CloseSelf)
end