SecurityPanel = class("SecurityPanel", ContainerView)
SecurityPanel.ViewType = UIViewType.ConfirmLayer


SecurityPanel.ActionType = {
	Modify = 1,
	Setting = 2,
	Confirm = 3,
}

local tempVector3 = LuaVector3.zero
function SecurityPanel:Init()
	self:initView()
	self:initData()
	self:addViewEventListener()	
	self:addListEventListener()
end

function SecurityPanel:initData( )
	self.actionType = self.viewdata.viewdata and self.viewdata.viewdata.ActionType or 0
	self.data = self.viewdata.viewdata and self.viewdata.viewdata.data or nil
	if(self.actionType == SecurityPanel.ActionType.Modify)then
		self:Show(self.securityCodeInputConfirmCt)
		self:Show(self.originSecurityCodeInputCt)
		self:Hide(self.pwFormatTip.gameObject)
		self.Title.text = ZhString.SecurityPanel_Title_Set
	elseif(self.actionType == SecurityPanel.ActionType.Setting)then
		self:Show(self.securityCodeInputConfirmCt)
		self:Hide(self.originSecurityCodeInputCt)
		self:Show(self.pwFormatTip.gameObject)
		self.Title.text = ZhString.SecurityPanel_Title_Set
	elseif(self.actionType == SecurityPanel.ActionType.Confirm)then
		self:Hide(self.originSecurityCodeInputCt)
		self:Hide(self.securityCodeInputConfirmCt)
		self.Title.text = ZhString.SecurityPanel_Title_Confirm
		self:Hide(self.pwFormatTip.gameObject)
		self:Show(self.unMask.gameObject)
	end
	self.grid:Reposition()

	local bd = NGUIMath.CalculateRelativeWidgetBounds(self.grid.transform,false)
	local height = bd.size.y
	local x,y,z = LuaGameObject.GetLocalPosition(self.grid.transform)

	if(self.actionType == SecurityPanel.ActionType.Setting)then
		tempVector3:Set(0,y - height - 90,0)
		self.bg.height = height + 270
	else
		tempVector3:Set(0,y - height - 50,0)
		self.bg.height = height + 230
	end
	self.confirmBtn.transform.localPosition = tempVector3
	self.isShowPs = false
end

function SecurityPanel:initView( )
	-- body
	self.Title = self:FindComponent("Title",UILabel)
	self.bg = self:FindComponent("bg",UISprite)

	self.confirmBtn = self:FindGO("confirm")

	self.grid = self:FindComponent("grid",UIGrid)

	self.securityCodeInput = self:FindComponent("securityCodeInput",UIInput)

	self.securityCodeInputConfirm = self:FindComponent("securityCodeInputConfirm",UIInput)

	self.originSecurityCodeInputInput = self:FindComponent("originSecurityCodeInputInput",UIInput)

	self.securityCodeInputConfirmCt = self:FindGO("securityCodeInputConfirmCt")

	self.originSecurityCodeInputCt = self:FindGO("originSecurityCodeInputCt")
	self.unMask = self:FindComponent("unMask",UISprite)
	self.securityCodeInput.characterLimit = 12;

	UIEventListener.Get(self.securityCodeInput.gameObject).onSelect = {"+=", function ( obj,state)
		local value = self.securityCodeInput.value
		if(self.isShowPs)then
			self.securityCodeInputTip2.text = value
		else
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.securityCodeInputTip2.text = string.rep("*",len-1)..lastCh
			else
				self.securityCodeInputTip2.text = ""
			end
		end
	end}

	EventDelegate.Set(self.securityCodeInput.onChange, function ( result)
		-- body
		local value = self.securityCodeInput.value
		if(self.isShowPs)then
			self.securityCodeInputTip2.text = value
		else
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.securityCodeInputTip2.text = string.rep("*",len-1)..lastCh
			else
				self.securityCodeInputTip2.text = ""
			end
		end
	end)


	UIEventListener.Get(self.securityCodeInputConfirm.gameObject).onSelect = {"+=", function ( obj,state)
		local value = self.securityCodeInputConfirm.value
		if(self.isShowPs)then
			self.securityCodeInputConfirmTip2.text = value
		else
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.securityCodeInputConfirmTip2.text = string.rep("*",len-1)..lastCh
			else
				self.securityCodeInputConfirmTip2.text = ""
			end
		end
	end}

	EventDelegate.Set(self.securityCodeInputConfirm.onChange, function ( result)
		-- body
		local value = self.securityCodeInputConfirm.value
		if(self.isShowPs)then
			self.securityCodeInputConfirmTip2.text = value
		else
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.securityCodeInputConfirmTip2.text = string.rep("*",len-1)..lastCh
			else
				self.securityCodeInputConfirmTip2.text = ""
			end
		end
	end)

	UIEventListener.Get(self.originSecurityCodeInputInput.gameObject).onSelect = {"+=", function ( obj,state)
		local value = self.originSecurityCodeInputInput.value
		if(self.isShowPs)then
			self.originSecurityCodeInputTip2.text = value
		else
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.originSecurityCodeInputTip2.text = string.rep("*",len-1)..lastCh
			else
				self.originSecurityCodeInputTip2.text = ""
			end
		end
	end}

	EventDelegate.Set(self.originSecurityCodeInputInput.onChange, function ( result)
		-- body
		local value = self.originSecurityCodeInputInput.value
		if(self.isShowPs)then
			self.originSecurityCodeInputTip2.text = value
		else
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.originSecurityCodeInputTip2.text = string.rep("*",len-1)..lastCh
			else
				self.originSecurityCodeInputTip2.text = ""
			end
		end
	end)

	
	self:AddClickEvent(self.unMask.gameObject,function (  )
		-- body
		local value = self.securityCodeInput.value
		self.isShowPs = not self.isShowPs
		if(self.isShowPs)then
			self.unMask.spriteName = "com_icon_hide"
			self.securityCodeInputTip2.text = value
		else
			self.unMask.spriteName = "com_icon_show"
			local len = string.len(value)
			if len > 0 then
				local lastCh = string.sub(value,len,len)
				self.securityCodeInputTip2.text = string.rep("*",len-1)..lastCh
			else
				self.securityCodeInputTip2.text = ""
			end
		end
	end)
	local confirmLabel = self:FindComponent("confirmLabel",UILabel)
	confirmLabel.text = ZhString.UniqueConfirmView_Confirm

	self.pwFormatTip = self:FindComponent("pwFormatTip",UILabel)
	self.pwFormatTip.text = ZhString.SecurityPanel_PwFormatTip

	UIUtil.LimitInputCharacter(self.securityCodeInputConfirm, 12, function ( str )
		-- body
		str = string.gsub(str, " ", "")
		local tmp = ""
		for w in string.gmatch(str, "%w") do
			tmp = tmp..tostring(w)
		end
		return tmp
	end)

	UIUtil.LimitInputCharacter(self.originSecurityCodeInputInput, 12, function ( str )
		-- body
		str = string.gsub(str, " ", "")
		local tmp = ""
		for w in string.gmatch(str, "%w") do
			tmp = tmp..tostring(w)
		end
		return tmp
	end)

	local originSecurityCodeInputTip1 = self:FindComponent("originSecurityCodeInputTip1",UILabel)
	self.originSecurityCodeInputTip2 = self:FindComponent("originSecurityCodeInputTip2",UILabel)
	originSecurityCodeInputTip1.text = ZhString.SecurityPanel_CodeInputTipOrigin
	self.originSecurityCodeInputTip2.text = ZhString.SecurityPanel_CodeInputTipType

	local securityCodeInputTip1 = self:FindComponent("securityCodeInputTip1",UILabel)
	self.securityCodeInputTip2 = self:FindComponent("securityCodeInputTip2",UILabel)
	securityCodeInputTip1.text = ZhString.SecurityPanel_CodeInputTip
	self.securityCodeInputTip2.text = ZhString.SecurityPanel_CodeInputTipType

	local securityCodeInputConfirmTip1 = self:FindComponent("securityCodeInputConfirmTip1",UILabel)
	self.securityCodeInputConfirmTip2 = self:FindComponent("securityCodeInputConfirmTip2",UILabel)
	securityCodeInputConfirmTip1.text = ZhString.SecurityPanel_CodeInputTipConfirm
	self.securityCodeInputConfirmTip2.text = ZhString.SecurityPanel_CodeInputTipType
end

function SecurityPanel:checkRegMatch( str )
	if(string.find(str,"^%d+$"))then
		return false
	elseif(string.find(str,"^[A-Za-z]+$"))then
		return false
	else
		return string.len(str) >5 and string.len(str) < 13
	end
end

function SecurityPanel:addViewEventListener(  )
	self:AddButtonEvent("cancel",function (  )
		-- body
		self:sendNotification(SecurityEvent.Close)
		self:CloseSelf()
	end)

	self:AddClickEvent(self.confirmBtn,function (  )
		-- body
		if(self.actionType == SecurityPanel.ActionType.Modify)then
			local psword = self.securityCodeInputConfirm.value;
			local confirm = self.securityCodeInput.value;
			local origin = self.originSecurityCodeInputInput.value;

			if(origin and origin ~= "")then
				if(psword ~= confirm)then
					MsgManager.ShowMsgByIDTable(6001);
				elseif(not self:checkRegMatch(psword))then
					MsgManager.ShowMsgByIDTable(6000);
				elseif(psword and psword ~= "" and psword == confirm)then
					ServiceAuthorizeProxy.Instance:CallSetAuthorizeUserCmd(psword,origin)
					self.userInputPw = psword
				elseif(not psword or psword == "")then
					-- 为空
					MsgManager.ShowMsgByIDTable(6000);	
				end
			else
				MsgManager.ShowMsgByIDTable(6000);				
				-- orign为空
			end
		elseif(self.actionType == SecurityPanel.ActionType.Setting)then
			local psword = self.securityCodeInputConfirm.value;
			local confirm = self.securityCodeInput.value;
			if(psword ~= confirm)then
				MsgManager.ShowMsgByIDTable(6001);
			elseif(not self:checkRegMatch(psword))then
				MsgManager.ShowMsgByIDTable(6000);
			elseif(psword and psword ~= "" and psword == confirm)then
				ServiceAuthorizeProxy.Instance:CallSetAuthorizeUserCmd(psword)
				self.userInputPw = psword
			elseif(not psword or psword == "")then
				-- 为空
				MsgManager.ShowMsgByIDTable(6000);
			end
		elseif(self.actionType == SecurityPanel.ActionType.Confirm)then
			local psword = self.securityCodeInput.value;
			if(psword and psword ~= "")then
				ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(psword)
				self.userInputPw = psword
			else
			-- 为空	
				MsgManager.ShowMsgByIDTable(6000);
			end
		end
	end)
end

function SecurityPanel:HandleRecvAuthorizeInfo(  )
	local myself = FunctionSecurity.Me()
	if(myself.verifySecuriySus)then
		if(self.data)then
			local callback = self.data.callback
			local arg = self.data.arg
			if(callback)then
				callback(arg)
			end
		end
		myself.verifySecuriyCode = self.userInputPw

		if(self.actionType == SecurityPanel.ActionType.Confirm)then
			MsgManager.ShowMsgByIDTable(6011);
		end
	else
		myself.verifySecuriyCode = nil
		if(myself.verifySecuriyhasSet)then
			MsgManager.ShowMsgByIDTable(6012);
			if(self.data and self.data.arg)then
				local fc = self.data.arg.failureAct
				if(fc)then
					fc(arg)
				end
			end
		end
	end
	self:CloseSelf()
end

function SecurityPanel:addListEventListener(  )
	-- body
	self:AddListenEvt(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd,self.HandleRecvAuthorizeInfo)
end