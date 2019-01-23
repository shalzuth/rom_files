RealNameCentifyView = class("RealNameCentifyView", BaseView);

RealNameCentifyView.ViewType = UIViewType.PopUpLayer

local ID_LENGTH = 18;

function RealNameCentifyView:Init()
	self:InitView();
	self:MapEvent();
end

function RealNameCentifyView:InitView()
	self.nameInput = self:FindComponent("NameInput", UIInput);
	self.idInput = self:FindComponent("IdInput", UIInput);

	self.waitingMask = self:FindGO("WaitingMask");

	self.confirmButton = self:FindGO("ConfirmButton");
	self:AddClickEvent(self.confirmButton, function (go)
		self:DoConfirm();
	end);

	self.cancelButton = self:FindGO("CancelButton");
	self:AddClickEvent(self.cancelButton, function (go)
		self:DoCancel();
	end);
end

function RealNameCentifyView:DoConfirm()
	if(self.waitting == true)then
		MsgManager.ShowMsgByIDTable(952);
		return;
	end

	local idInput_value = self.idInput.value;
	if(string.len(idInput_value) ~= ID_LENGTH)then
		MsgManager.ShowMsgByIDTable(1075);
		return;
	end
	
	self.waitting = true;
	self:UpdateWaitting();

	local url = FunctionLogin.Me():GetRealNameCentifyUrl( self.nameInput.value, idInput_value);

	local test_address, test_privateMode;
	if(not FunctionLogin.Me():getSdkEnable())then
		test_address = NetConfig.PrivateAuthServerUrl;
		test_privateMode = true;
	end

	FunctionLogin.Me():requestGetUrlHost(url, function ( status,content )
		self:ResponseHandler( status,content );
	end, test_address, test_privateMode);
end

function RealNameCentifyView:ResponseHandler( status, param )
	if(status == FunctionLogin.AuthStatus.OherError)then
		local order = param;

		if(order.IsOverTime)then
			MsgManager.ShowMsgByIDTable(1016);
		end
		
		self.waitting = false;
		self:UpdateWaitting();

		return;
	end

	local content = param;

	local result = nil
	local isCall = pcall( function ()
		result = StringUtil.Json2Lua(content)
		if result == nil then
			if status == NetConfig.ResponseCodeOk then
				result = json.decode(content)
			end
		end
	end)

	if(result and result.data)then
		ServiceLoginUserCmdProxy.Instance:CallRealAuthorizeUserCmd(result.data);
	end
end

function RealNameCentifyView:UpdateWaitting()
	self.waitingMask:SetActive(self.waitting == true);
end

function RealNameCentifyView:DoCancel()
	self:CloseSelf();
end

function RealNameCentifyView:MapEvent()
	self:AddListenEvt(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, self.HandleRealAuthorizeServer);
end

function RealNameCentifyView:HandleRealAuthorizeServer(note)
	if(not self.waitting)then
		return;
	end

	local success = note.body.authorized;

	self.waitting = false;
	self:UpdateWaitting();

	if(success)then
		if(self.callback)then
			self.callback(self.callbackParam);
		end
		self:CloseSelf();
	else
		MsgManager.ShowMsgByIDTable(1077);
	end
end

function RealNameCentifyView:OnEnter()
	RealNameCentifyView.super.OnEnter(self);

	local viewdata = self.viewdata and self.viewdata.viewdata;
	if(viewdata)then
		self.callback = callback;
		self.callbackParam = callbackParam;
	end
end

function RealNameCentifyView:OnExit()
	RealNameCentifyView.super.OnExit(self);
end