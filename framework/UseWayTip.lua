autoImport("BaseTip")
UseWayTip = class("UseWayTip" ,BaseTip)

autoImport("UseWayTipCell");

function UseWayTip:ctor(parent)
	UseWayTip.super.ctor(self,"UseWayTip",parent)

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);

	self.panel = self.gameObject:GetComponent(UIPanel)
	self.contentScrollView = self:FindGO("contentScrollView"):GetComponent(UIScrollView)
	local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
	if(temp)then
		self.panel.depth=temp.depth+1
		self.contentScrollView:GetComponent(UIPanel).depth=self.panel.depth+1
	end
	self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero;

	self.closeButton = self:FindGO("CloseButton");
	self:AddClickEvent(self.closeButton, function (go)
		self:OnExit()
	end);
end

function UseWayTip:OnExit()
	if(self.closeCall)then
		self.closeCall(self.closeCallParam)

		self.closeCall = nil;
		self.closeCallParam = nil;
	end
	self:PassEvent(ItemTipEvent.CloseShowGotoUse, self);
	GameObject.Destroy(self.gameObject)
	return true
end

function UseWayTip:Init()
	local grid = self:FindComponent("contentGrid", UIGrid);
	self.contentList = UIGridListCtrl.new(grid, UseWayTipCell, "GainWayTipCell")
	self.contentList:AddEventListener(MouseEvent.MouseClick,self.HandleClickItem,self)
end

function UseWayTip:HandleClickItem(cell)
	self:PassEvent(ItemTipEvent.ClickGotoUse, {self, cell});
end

function UseWayTip:SetData(data)
	local itemData = data;
	local itemid = data.staticData.id;
	local useWayDatas = GainWayTipProxy.Instance:GetItemAccessByItemId(itemid);
	if(useWayDatas)then
		self.contentList:ResetDatas(useWayDatas)
	else
		self.contentList:ResetDatas({})
	end
end

function UseWayTip:SetAnchorPos(isright)
	if(isright)then
		
	else

	end
end

function UseWayTip:SetCloseCall(closeCall, closeCallParam)
	self.closeCall = closeCall;
	self.closeCallParam = closeCallParam;
end

function UseWayTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end
