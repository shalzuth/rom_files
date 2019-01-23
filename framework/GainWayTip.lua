autoImport("BaseTip")
autoImport("GainWayTipCell")
GainWayTip = class("GainWayTip" ,BaseTip)

GainWayTip.CloseGainWay = "GainWayTip_CloseGainWay";

function GainWayTip:ctor(parent)
	GainWayTip.super.ctor(self,"GainWayTip",parent)
end

function GainWayTip:Init()
	self:FindObjs();
	self:InitContentList()
	self.closecomp.callBack = function (go)
		self:OnExit();
	end
	local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
	if(temp)then
		self.panel.depth=temp.depth+1
		self.contentScrollView:GetComponent(UIPanel).depth=self.panel.depth+1
	end
	self.gameObject.transform.localPosition = Vector3.zero;
	self.gameObject:SetActive(false)

	self.closeButton = self:FindGO("CloseButton");
	self:AddClickEvent(self.closeButton, function (go)
		self:OnExit();
	end);
end

function GainWayTip:FindObjs()
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.contentScrollView = self:FindGO("contentScrollView"):GetComponent(UIScrollView)
	self.contentGrid = self:FindGO("contentGrid"):GetComponent(UIGrid)
	self.panel=self.gameObject:GetComponent(UIPanel)
end

function GainWayTip:InitContentList()
	self.contentList = UIGridListCtrl.new(self.contentGrid,GainWayTipCell,"GainWayTipCell")
	self.contentList:AddEventListener(MouseEvent.MouseClick,self.HandleClickItem,self)
	self.contentList:AddEventListener(GainWayTipCell.AddItemTrace,self.SetData,self)
	self.contentList:AddEventListener(ItemEvent.GoTraceItem, self.GoTraceItem, self)
end

function GainWayTip:GoTraceItem(data)
	local id = data.addWayID;
	local gotoMode = Table_AddWay[id] and Table_AddWay[id].GotoMode;
	if(gotoMode)then
		FuncShortCutFunc.Me():CallByID(gotoMode);
	end
	self:PassEvent(ItemEvent.GoTraceItem, self.data);
end

function GainWayTip:HandleClickItem(cellctl)
	local data = cellctl.data;
	local go = cellctl.gameObject;
	self.selectItemData=data
	if(data.isOpen)then
		local tData=Table_AddWay[data.addWayID]
		
	else
		MsgManager.FloatMsgTableParam(nil,ZhString.GainWayTip_notOpen)
	end
end

function GainWayTip:SetData(itemStaticID)
	if(itemStaticID)then
		self.itemStaticID = itemStaticID;
	end
	if(self.itemStaticID)then
		self.data = GainWayTipProxy.Instance:GetDataByStaticID(self.itemStaticID)
		if(self.data)then
			self.contentList:ResetDatas(self.data.datas)
			self.contentScrollView:ResetPosition()
		end
	end
	self.gameObject:SetActive(true)
end

function GainWayTip:OnEnter()
	
end

function GainWayTip:OnExit()
	GainWayTipProxy.Instance.GainWayItemDataDic={}
	GameObject.Destroy(self.gameObject)
	self:PassEvent(GainWayTip.CloseGainWay);
	return true
end

function GainWayTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

local tempV3 = LuaVector3()
function GainWayTip:SetAnchorPos(isright)
	if(isright)then
		tempV3:Set(0,0,0);
	else
		tempV3:Set(-490,0,0);
	end
	self.gameObject.transform.localPosition = tempV3;
end


