local tempVector3 = LuaVector3.zero
autoImport("UICombo")
ComboCtl = class("ComboCtl")

function ComboCtl:ctor()
	if(nil==ComboCtl.Instance)then
		ComboCtl.Instance = self
	end
end

function ComboCtl:ShowCombo(num)
	self.ComboNum=num
	local anchorDown = FloatingPanel.Instance:FindGO("Anchor_Down");
	if(nil==self.ComboEffect)then
		self.ComboEffect = UICombo:PlayUIEffect(EffectMap.UI.PVPCombo,
						anchorDown,
						false,
						ComboCtl.ComboEffectHandle,
						self);
	else
		self.UICombo:PlayAni(self.ComboNum);
	end
end


function ComboCtl.ComboEffectHandle( effectHandle, owner )
	if(owner)then
		local effectGO = effectHandle.gameObject;
		tempVector3:Set(0,659,0)
		effectGO.transform.localPosition = tempVector3
		ComboCtl.Instance.UICombo=UICombo.new(effectGO);
		ComboCtl.Instance.UICombo:PlayAni(ComboCtl.Instance.ComboNum)
	end
end

function ComboCtl:Clear()
	if(self.ComboEffect)then
		self.ComboEffect:Destroy()
		self.ComboEffect=nil
	end
	self.ComboNum=nil
	if(nil~=self.UICombo)then
		self.UICombo=nil
	end
end



