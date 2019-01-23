autoImport("GeneralHelp")

TipsView = class("TipsView",BaseView)

TipsView.ViewType = UIViewType.TipLayer

function TipsView.Me()
	if(TipsView.me==nil) then
		GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "TipsView"})
	end
	return TipsView.me
end

function TipsView:Init()
	TipsView.me = self
	self.panel = self.gameObject:GetComponent(UIPanel)
	self.currentTip = nil
	self.currentTipType = nil
end

function TipsView:OnExit()
	TipsView.super.OnExit(self)
	TipsView.me = nil
	self:HideCurrent();
end

function TipsView:ShowStickTip(viewType,data,side,stick,offset,prefabName)
	self:GetTip(viewType,prefabName)
	self:ResetTipContentPanel()
	self.currentTip:SetData(data)
	local pos = NGUIUtil.GetAnchorPoint(self.currentTip,stick,side,offset)
	self.currentTip:SetPos(pos)
	self:ConstrainCurrentTip()
	self.currentTip:OnEnter()
end

function TipsView:ConstrainCurrentTip()
	self.panel:ConstrainTargetToBounds(self.currentTip.gameObject.transform,true)
end

function TipsView:ShowTip(viewType,data,prefabName)
	self:GetTip(viewType,prefabName)
	self:ResetTipContentPanel()
	self.currentTip:SetData(data)
	self.currentTip:OnEnter()
end

function TipsView:ShowGeneralHelp(data, title)
	self:ShowTip(GeneralHelp, data, "GeneralHelp")
	self.currentTip:SetTitle(title)
end

function TipsView:ResetTipContentPanel()
	local panels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.currentTip.gameObject, UIPanel, false);
	if(panels) then
		table.sort(panels, function (a, b)
			return a.depth < b.depth;
		end);
		for i=1,#panels do
			panels[i].depth = self.panel.depth + i
		end
	end
end

function TipsView:GetTip(viewType,prefabName)
	prefabName = prefabName or viewType.__cname
	if self.currentTip == nil or GameObjectUtil.Instance:ObjectIsNULL(self.currentTip.gameObject)then
		self.currentTip = nil
		self.currentTipType = nil
	end
	if(self.currentTipType ~= viewType) then
		self:HideCurrent()
		self.currentTip = viewType.new(prefabName,self.gameObject)
		self.currentTipType = viewType
	end
end

function TipsView:HideTip(viewType)
	if(self.currentTipType == viewType) then
		self:HideCurrent()
	end
end

function TipsView:HideCurrent()
	if(self.currentTip~=nil) then
		if(self.currentTip:OnExit()) then
			self.currentTip:DestroySelf()
		end
	end
	self.currentTip = nil
	self.currentTipType = nil
end

