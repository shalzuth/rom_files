autoImport("RecommendPetTipCell")
RecommendPetTip = class("RecommendPetTip", BaseTip)

function RecommendPetTip:Init()
	self.title=self:FindComponent("title",UILabel)
	self.title.text=ZhString.PetAdventure_RecommendPet
	self.Des=self:FindComponent("desc",UILabel)
	self.Des.text=ZhString.PetAdventure_RecommendPetDes
	self.recommendTable = self:FindComponent("ctl",UITable);
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.scrollview=self:FindComponent("sv",UIScrollView);
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	self:InitView()
	TitleTip.super.Init(self);
	
	--todo xde fix ui
	self.MainWidget = self:FindGO("Main"):GetComponent(UIWidget)
	self.MainWidget.topAnchor.target =  self.Des.gameObject.transform
	self.MainWidget.topAnchor.relative = 0
	self.MainWidget.topAnchor.absolute = -90
	self.MainWidget:UpdateAnchors()

	self.title.width = 310
	self.title.overflowMethod = 3
	self.title.transform.localPosition = Vector3(0,103.8,0)
end

function RecommendPetTip:InitView()
	self.Ctl = UIGridListCtrl.new(self.recommendTable,RecommendPetTipCell,"RecommendPetTipCell");
	self.recommendPetData={}
end

function RecommendPetTip:SetData(data)
	self.callback = data.callback;
	self:ShowTip(data)
end

function RecommendPetTip:ShowTip(data)
	if(data)then
		self.Ctl:ResetDatas(data)
		self.scrollview:ResetPosition()
		self.recommendTable:Reposition()
	end
end

function RecommendPetTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	TipsView.Me():HideCurrent();
end

function RecommendPetTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end




