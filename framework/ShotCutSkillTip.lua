autoImport("SkillTip");
ShotCutSkillTip = class("ShotCutSkillTip",SkillTip)

-- tipType: normalItem, equipInBody, fashionInBody, fashion
function ShotCutSkillTip:Init()
	self.calPropAffect = true
	self.tweenTime = 0.2
	self.tweenDis = 30
	self:FindObjs();
end

function ShotCutSkillTip:FindObjs()
	self.topAnchor = self:FindGO("Top"):GetComponent(UIWidget)
	self.centerBg = self:FindGO("CenterBg"):GetComponent(UIWidget)
	self.scrollView = self:FindGO("ScrollView"):GetComponent(UIPanel)
	self.scroll = self:FindGO("ScrollView"):GetComponent(UIScrollView)
	self:AddToUpdateAnchors(self:FindGO("TopBound"):GetComponent(UIWidget))
	self:AddToUpdateAnchors(self:FindGO("BottomBound"):GetComponent(UIWidget))
	self:AddToUpdateAnchors(self.topAnchor)
	self:AddToUpdateAnchors(self.centerBg)
	self:AddToUpdateAnchors(self.scrollView)
	self:FindTitleUI()
	self:FindCurrentUI()
end

function ShotCutSkillTip:OnEnter()
	self.bg.alpha = 0
	LeanTween.cancel(self.gameObject)
	local startPos = self.gameObject.transform.localPosition
	startPos.y = startPos.y - self.tweenDis
	self.gameObject.transform.localPosition = startPos
	local lt = LeanTween.moveLocalY(self.gameObject,self.pos.y,self.tweenTime)
	lt:setEase(LeanTweenType.easeOutBack)
	LeanTween.value(self.gameObject,function (v)
		self.bg.alpha = v
	end,0,1,self.tweenTime )
end

function ShotCutSkillTip:OnExit()
	LeanTween.cancel(self.gameObject)
	local ldt = LeanTween.value(self.gameObject,function (v)
		self.bg.alpha = v
	end,1,0,self.tweenTime )
	ldt:setOnComplete(function()
		self:DestroySelf()
	end)
	ldt = LeanTween.moveLocalY(self.gameObject,self.pos.y - self.tweenDis,self.tweenTime )
	ldt:setEase(LeanTweenType.easeInBack)
end

function ShotCutSkillTip:SetData(data)
	self.data = data
	self:UpdateCurrentInfo(self.data:GetExtraStaticData())
	self:_HandleSpecials()
	local height = math.max(math.min(self:Layout()+190,SkillTip.MaxHeight),SkillTip.MinHeight)
	self.bg.height = height
	self:UpdateAnchors()
	self.scroll:ResetPosition()
	self.skillInfo = nil
end

function ShotCutSkillTip:HandleRunSpecials(selectID)
	if(selectID==nil) then
		selectID = self.data:GetSpecialID()
	end
	return ShotCutSkillTip.super.HandleRunSpecials(self,selectID)
end