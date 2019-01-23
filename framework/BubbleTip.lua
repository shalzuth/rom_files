autoImport("BaseTip");
BubbleTip = class("BubbleTip" ,BaseTip)

BubbleTip.MaxWidth = 280;

function BubbleTip:ctor(prefabName, stick, side, offset)
	BubbleTip.super.ctor(self, prefabName, stick.gameObject);
	self.parent = stick;
	self.side = side or NGUIUtil.AnchorSide.Top;
	self.offset = offset;

	self:InitTip();
end

function BubbleTip:InitTip()
	self.closeButton = self:FindGO("CloseButton");
	self.upRoot = UIUtil.GetComponentInParents(self.gameObject, UIRoot);
	local upPanel = UIUtil.GetComponentInParents(self.parent.gameObject, UIPanel);
	self.panel = self.gameObject:GetComponent(UIPanel);
	self.panel.depth = upPanel.depth + 5;

	self.leftType = self:FindGO("LeftType");
	self.rightType = self:FindGO("RightType");
	self.leftText = self:FindComponent("BubbleText", UILabel, self.leftType);
	self.rightText = self:FindComponent("BubbleText", UILabel, self.rightType);

	self.leftClose, self.rightClose = self:FindGO("LeftClose"), self:FindGO("RightClose");
	self:AddClickEvent(self.leftClose, function (go)
		if(self.data and self.data.bubbleid)then
			local sdata = Table_BubbleID[self.data.bubbleid];
			if(sdata and sdata.NextID)then
				TipManager.Instance:ShowBubbleTipById(sdata.NextID, 
							self.parent, self.side, self.offset)	
			end
		end
		self:CloseSelf();
	end);
	self:AddClickEvent(self.rightClose, function (go)
		if(self.data and self.data.bubbleid)then
			local sdata = Table_BubbleID[self.data.bubbleid];
			if(sdata and sdata.NextID)then
				TipManager.Instance:ShowBubbleTipById(sdata.NextID, 
							self.parent, self.side, self.offset)	
			end
		end
		self:CloseSelf();
	end);

	-- resize pos
	local pos = NGUIUtil.GetAnchorPoint(nil, self.parent, self.side, self.offset);
	-- self.leftType.transform.localPosition = pos;
	-- self.rightType.transform.localPosition = pos;
	self:SetPos(pos)
	
	self.gameObject:SetActive(true);
end

-- bubbleid text closecallback
function BubbleTip:SetData(data)
	TimeTickManager.Me():ClearTick(self)

	self.data = data;
	if(data)then
		if(data.bubbleid)then
			local sdata = Table_BubbleID[data.bubbleid];
			if(sdata)then
				self.bubbleid = data.bubbleid;

				if(type(sdata.AutoCloseTime)=="number")then
					TimeTickManager.Me():ClearTick(self, 2);
					TimeTickManager.Me():CreateTick(sdata.AutoCloseTime*1000, 33, function (self, deltatime)
						if(sdata.NextID)then
							TipManager.Instance:ShowBubbleTipById(sdata.NextID, 
								self.parent, self.side, self.offset)	
						end
						self:CloseSelf();
					end, self, 2);	
				end
				self.leftText.text = sdata.Text;
			end
		else
			self.leftText.text = data.text;
		end

		self:ResizeTip();

		self.closecallback = data.closecallback;

		self:ActiveCloseButton(true);
	end
end

function BubbleTip:ResizeTip()
	self:Show(self.leftType);
	UIUtil.FitLabelHeight(self.leftText, BubbleTip.MaxWidth);

	local bound = NGUIMath.CalculateAbsoluteWidgetBounds(self.leftType.transform);
	local rootPos = self.upRoot.transform:InverseTransformPoint(bound.max); 
	
	if(rootPos.x>620)then
		self:Show(self.rightType);
		self:Hide(self.leftType);

		self.rightText.text = self.leftText.text;
		UIUtil.FitLabelHeight(self.rightText, BubbleTip.MaxWidth);
		-- self.panel:ConstrainTargetToBounds(self.rightType.transform, true);
	else
		self:Hide(self.rightType);
		-- self.panel:ConstrainTargetToBounds(self.leftType.transform, true);
	end
end

function BubbleTip:ActiveCloseButton(b)
	self.leftClose:SetActive(b);
	self.rightClose:SetActive(b);
end

function BubbleTip:SetActive(b)
	self.gameObject:SetActive(b);
end

function BubbleTip:CloseSelf()
	TipManager.Instance:CloseBubbleTip(self.bubbleid)
end

function BubbleTip:OnEnter()
	BubbleTip.super.OnEnter(self);

	TimeTickManager.Me():CreateTick(0, 33, function (self, deltatime)
		if(self:ObjIsNil(self.gameObject))then
			self:CloseSelf();
		end
	end, self, 1);	
end

function BubbleTip:OnExit()
	TimeTickManager.Me():ClearTick(self)

	if(self.closecallback)then
		self.closecallback();
	end

	if(not self:ObjIsNil(self.gameObject))then
		GameObject.DestroyImmediate(self.gameObject);
	end

	return true
end
