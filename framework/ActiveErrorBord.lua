ActiveErrorBord = class("ActiveErrorBord", ContainerView)
ActiveErrorBord.ViewType = UIViewType.PopUpLayer

function ActiveErrorBord:Init()
	self:initView()
	self:addViewEventListener()	
end

function ActiveErrorBord:initView( )
	-- body
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.ActiveErrorBord_ErrorTitle

	local cancel = self:FindComponent("cancelLabel",UILabel)
	cancel.text = ZhString.ActiveErrorBord_Cancel
	local confirm = self:FindComponent("confirmLabel",UILabel)
	confirm.text = ZhString.ActiveErrorBord_Confirm
end

function ActiveErrorBord:addViewEventListener(  )
	-- body
	self:AddButtonEvent("cancelBtn",function (  )
		-- body
		self:CloseSelf()
	end)
	self:AddButtonEvent("confirmBtn",function (  )
		-- body
		local url = GameConfig.GetActiveCodeUrl or ""
		Application.OpenURL(url)
		self:CloseSelf()
	end)
end