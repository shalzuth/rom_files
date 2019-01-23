ClickEffectView = class("ClickEffectView", BaseView)
ClickEffectView.ViewType = UIViewType.TouchLayer

local tempVector3 = LuaVector3.zero

function ClickEffectView:Init()
	self.gameObject.name = "ClickEffectView"
	self.collider = self:FindGO("Collider");
	ClickEffectView.Instance = self
end

function ClickEffectView.ShowClickEffect(  )
	-- body
	local instance = ClickEffectView.getInstance()
	local uiCamera = NGUIUtil:GetCameraByLayername("UI");
	if not uiCamera then
		return
	end
	if(Input.touchCount > 1)then
		printRed(Input.touchCount)
		for i=1,Input.touchCount do
			local single = Input.GetTouch(i-1)
			if(single.phase == TouchPhase.Ended)then
				local x,y = LuaGameObject.GetTouchPosition(i-1,false)
				tempVector3:Set(x,y,0)
				break
			end
		end
	else
		local x,y,z = LuaGameObject.GetMousePosition()
		tempVector3:Set(x,y,z)
	end
	local x,y,z = LuaGameObject.ScreenToWorldPointByVector3(uiCamera,tempVector3);
	tempVector3:Set(x, y, z)
	x,y,z = LuaGameObject.InverseTransformPointByVector3(instance.gameObject.transform,tempVector3)	
	tempVector3:Set(x, y, z)
	instance.lPos = tempVector3
	instance:PlayUIEffect(EffectMap.UI.UIPoint, instance.gameObject, true,instance.resourceLoadSus,instance)
end

function ClickEffectView.resourceLoadSus( eObj,instance )
	-- body
	-- LogUtility.Info("resourceLoadSus")
	eObj.transform.localPosition = instance.lPos
end

function ClickEffectView:OnExit(  )
	-- body
	ClickEffectView.super.OnExit(self)
	ClickEffectView.Instance = nil
end

function ClickEffectView.getInstance()
	-- body
	if(ClickEffectView.Instance == nil)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ClickEffectView})
	end
	return ClickEffectView.Instance
end

function ClickEffectView.close(  )
	-- body
	if(ClickEffectView.Instance ~= nil)then
		ClickEffectView.Instance:CloseSelf()
	end
end


function ClickEffectView:EnterHandUpMode()
	self.collider:SetActive(true);
end

function ClickEffectView:ExitHandUpMode()
	self.collider:SetActive(false);
end