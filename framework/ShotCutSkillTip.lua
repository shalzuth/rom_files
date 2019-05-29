autoImport("SkillTip")
ShotCutSkillTip = class("ShotCutSkillTip", SkillTip)
local tmpPos = LuaVector3(0, 0, 0)
local MaxHeight = 330
function ShotCutSkillTip:Init()
  self.calPropAffect = true
  self.tweenTime = 0.2
  self.tweenDis = 30
  self:FindObjs()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
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
  self:FindFunc()
end
function ShotCutSkillTip:OnEnter()
  self.bg.alpha = 0
  LeanTween.cancel(self.gameObject)
  local startPos = self.gameObject.transform.localPosition
  startPos.y = startPos.y - self.tweenDis
  self.gameObject.transform.localPosition = startPos
  local lt = LeanTween.moveLocalY(self.gameObject, self.pos.y, self.tweenTime)
  lt:setEase(LeanTweenType.easeOutBack)
  LeanTween.value(self.gameObject, function(v)
    self.bg.alpha = v
  end, 0, 1, self.tweenTime)
end
function ShotCutSkillTip:OnExit()
  LeanTween.cancel(self.gameObject)
  local ldt = LeanTween.value(self.gameObject, function(v)
    self.bg.alpha = v
  end, 1, 0, self.tweenTime)
  ldt:setOnComplete(function()
    self:DestroySelf()
  end)
  ldt = LeanTween.moveLocalY(self.gameObject, self.pos.y - self.tweenDis, self.tweenTime)
  ldt:setEase(LeanTweenType.easeInBack)
  EventManager.Me():RemoveEventListener(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, self.HandleSkillOptionUpdate, self)
end
function ShotCutSkillTip:SetData(data)
  self.data = data
  self:UpdateCurrentInfo(self.data:GetExtraStaticData())
  self:ShowHideFunc()
  local height = math.max(math.min(self:Layout() + 190, MaxHeight), SkillTip.MinHeight)
  self.bg.height = height
  self:UpdateAnchors()
  self.scroll:ResetPosition()
  self.skillInfo = nil
end
function ShotCutSkillTip:UpdateContainer(height)
  tmpPos:Set(0, height - 35, 0)
  self.containerTrans.localPosition = tmpPos
  self.isUpdateContainer = true
end
function ShotCutSkillTip:ClickFuncCheck()
  if ShotCutSkillTip.super.ClickFuncCheck(self) then
    self:_CheckSpecialModified()
  end
end
function ShotCutSkillTip:ClickSpecialCheck()
  if ShotCutSkillTip.super.ClickSpecialCheck(self) then
    self:_CheckSpecialModified()
  end
end
function ShotCutSkillTip:ClickSpecialEffect(cell)
  if ShotCutSkillTip.super.ClickSpecialEffect(self, cell) then
    self:_CheckSpecialModified()
  end
end
function ShotCutSkillTip:ClickSelectOption(cell)
  if ShotCutSkillTip.super.ClickSelectOption(self, cell) then
    self:_CheckSpecialModified()
  end
end
function ShotCutSkillTip:ClickAddSubSkill(cell)
  self:TryInitSubSkill()
  self.closecomp.enabled = false
  self.closecomp.enabled = true
end
