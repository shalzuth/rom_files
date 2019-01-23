ActivePanel = class("ActivePanel", ContainerView)
ActivePanel.ViewType = UIViewType.ChatroomLayer

function ActivePanel:Init()
	self:initView()
	self:addViewEventListener()	
	self:addListEventListener()
end

function ActivePanel:initView( )
	-- body
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.ActivePanel_Title

	self.accInput = self:FindComponent("AcInput",UIInput)

	UIUtil.LimitInputCharacter(self.accInput, 8, function ( str )
		-- body
		str = string.gsub(str, " ", "")
		local tmp = ""
		for w in string.gmatch(str, "%w") do
			tmp = tmp..tostring(w)
		end
		return tmp
	end)
end

function ActivePanel:addViewEventListener(  )
	-- body
	self:AddButtonEvent("cancel",function (  )
		-- body
		self:CloseSelf()
		GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
	end)
	self:AddButtonEvent("confirm",function (  )
		-- body
		local acc = self.accInput.value
		if(acc and acc~="")then
			self.accInputValue = acc
			FunctionLogin.Me():StartActive(self.accInputValue,
				function (status,content)
					self:activeCallback(status,content) 
				end)
		else
			MsgManager.ShowMsgByIDTable(1053)
		end		
	end)
end

function ActivePanel:addListEventListener(  )
	-- body
end

function ActivePanel:checkActiveBack( content )
	-- body
	if(content and content ~= "")then
		local result = StringUtil.Json2Lua(content)
		-- stack(string.format("CheckAccTokenValid json:%s",tostring(result)))
		if(result)then
			if(result.message == "ok")then
				return true
			elseif(result.status == 1)then
				return false
			end
		end
	end
end

function ActivePanel:activeCallback( status,content )
	-- body
	LogUtility.InfoFormat("ActivePanel activeCallback status:{0},content:{1}",tostring(status),tostring(content))
	local result = self:checkActiveBack(content)
	if(status == NetConfig.ResponseCodeOk )then
		if (result)then
			MsgManager.ShowMsgByIDTable(1052)
			local sdkType = FunctionLogin.Me():getSdkType()
			if(sdkType == FunctionSDK.E_SDKType.Any)then
				FunctionLogin.Me():LoginDataHandler(status,content,function (  )
					-- body
					-- GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
				end)
			elseif(sdkType == FunctionSDK.E_SDKType.XD)then
				FunctionLogin.Me():startAuthAccessToken(function (  )
						-- body
					-- GameFacade.Instance:sendNotification(NewLoginEvent.EndSdkLogin)
				end)
			end	
			self:CloseSelf()
		else
			-- MsgManager.ShowMsgByIDTable(1051)
			GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "ActiveErrorBord"})
			local msg = string.format(ZhString.Login_ActiveFailure,tostring(status),
				tostring(content),tostring(self.accInputValue))
			-- msg = FunctionLogin.Me():replaceBracket(msg)
			-- errorLog(msg)
		end
	else
		FunctionNetError.Me():ShowErrorById(11)
	end
end
