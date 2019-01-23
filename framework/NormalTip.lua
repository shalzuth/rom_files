autoImport("BaseTip");
NormalTip = class("NormalTip" ,BaseTip)

NormalTip.MaxWidth = 230;

function NormalTip:ctor(prefabName, stick, side, offset)
	NormalTip.super.ctor(self, prefabName, stick.gameObject);
	self.gameObject.transform:SetParent(stick.transform, false);

	self.stick = stick;
	self.side = side;
	self.offset = offset;

	self:InitTip();
end

function NormalTip:InitTip()
	self.desc = self:FindComponent("Desc", UILabel);

	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.stick.gameObject, UIPanel);
	self.panel = self.gameObject:GetComponent(UIPanel);
	self.panel.depth = upPanel.depth + 10;

	local pos = NGUIUtil.GetAnchorPoint(nil, self.stick, self.side, self.offset);
	self:SetPos(pos)

	self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace);	
	self.closeComp.callBack = function ()
		TipManager.Instance:CloseNormalTip()
	end
end

function NormalTip:SetData(data)
	self.desc.text = data;
	UIUtil.FitLabelHeight(self.desc, NormalTip.MaxWidth)
end

function NormalTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closeComp)then
		self.closeComp:AddTarget(obj.transform);
	end
end

function NormalTip:RemoveUpdateTick()
	if(self.updateCallTick)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.updateCallTick = nil;
	end

	self.updateCall = nil;
	self.updateCallTick = nil;
end

function NormalTip:SetUpdateSetText(interval, updateCall, updateCallParam)
	self.updateCall = updateCall;
	self.updateCallParam = updateCallParam;

	if(self.updateCallTick == nil)then
		self.updateCallTick = TimeTickManager.Me():CreateTick(0, interval, self._TickUpdateCall, self, 1)
	end
end

function NormalTip:SetCloseCall(closeCall, closeCallParam)
	self.closeCall = closeCall;
	self.closeCallParam = closeCallParam;
end

function NormalTip:_TickUpdateCall()
	if(self.updateCall)then
		local needRemove, text = self.updateCall(self.updateCallParam);
		self:SetData(text);
		
		if(needRemove)then
			self:RemoveUpdateTick();
		end
	end
end

function NormalTip:OnEnter()
	NormalTip.super.OnEnter(self);
end

function NormalTip:DestroySelf()
	if(not self:ObjIsNil(self.gameObject))then
		GameObject.Destroy(self.gameObject)
	end
end

function NormalTip:OnExit()
	self:RemoveUpdateTick();

	if(self.closeCall)then
		self.closeCall(self.closeCallParam);
	end
	return true
end
