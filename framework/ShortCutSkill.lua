autoImport("BaseCDCell")
autoImport("ShotCutSkillTip")
autoImport("ConditionCheck")
ShortCutSkill = class("ShortCutSkill",BaseCDCell)
-- ShortCutSkill.INVALIDTIMEID = -1
ShortCutSkill.FitPreCondReason = 1
ShortCutSkill.FitSpecialCost = 2
ShortCutSkill.FitHpCost = 3
ShortCutSkill.FitTargetFilter = 4

function ShortCutSkill:Init()
	-- self.cdTimerID = ShortCutSkill.INVALIDTIMEID
	self.notFitCheck = ConditionCheckWithDirty.new()
	self:SetcdCtl(FunctionCDCommand.Me():GetCDProxy(ShotCutSkillCDRefresher))
	self.container = nil
	self.icon = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "Icon"):GetComponent(UISprite)
	self.bg = self:FindGO("Bg")
	self.clickObj = self:FindGO("Click")
	self.clickObjBtn = self:FindGO("Click"):GetComponent(UIButton)
	self.bgSp = self.bg:GetComponent(UISprite)
	self.cdMask = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "CDMask"):GetComponent(UISprite)
	self.leadMask = self:FindGO("LeadMask"):GetComponent(UISprite)
	self.preCondNotFit = GameObjectUtil.Instance:DeepFindChild(self.gameObject, "PreConditionNotFit"):GetComponent(UISprite)
	self.spNotEnough = self:FindGO("SpNotEnough")
	self.disableMask = self:FindGO("DisableMask")
	self.addSp = self:FindGO("Add")
	self.cannotUseSp = self:FindGO("CannotUse")
	self:ResetCdEffect()
	self:GuideEnd()
	local click = function(obj)
		-- print("click")
		if(self.data:GetID()==0) then
			self:DispatchEvent(MouseEvent.MouseClick, self)
		else
			Game.SkillClickUseManager:ClickSkill(self)
		end
	end
	local press = function(obj,state)
		-- print("客户端时间:"..os.time())
		-- print("skill->"..self.data.id.." state:"..tostring(state))
		if(state and self.data~=nil and self.data.staticData ~=nil) then
			if(ShortCutProxy.Instance:GetUnLockSkillMaxIndex()-self.indexInList < 4) then
				TipsView.Me():ShowStickTip(ShotCutSkillTip,self.data,NGUIUtil.AnchorSide.TopRight,self.bgSp,{-203,-20})
			else
				TipsView.Me():ShowStickTip(ShotCutSkillTip,self.data,NGUIUtil.AnchorSide.TopLeft,self.bgSp,{205,-20})
			end
		else
			TipsView.Me():HideTip(ShotCutSkillTip)
		end
	end
	self.longPress = self.clickObj:GetComponent(UILongPress)
	self.longPress.pressEvent = press
	self:SetEvent(self.clickObj,click)
	EventManager.Me():AddEventListener(MyselfEvent.SpChange,self.CheckSp,self)
	EventManager.Me():AddEventListener(MyselfEvent.HpChange,self.CheckHp,self)
	EventManager.Me():AddEventListener(MyselfEvent.EnableUseSkillStateChange,self.CheckEnableUseSkill,self)
end

function ShortCutSkill:NeedHide(val)
	self.gameObject:SetActive(not val)
end

function ShortCutSkill:ExtendsEmptyShow()
	self:Show(self.cannotUseSp)
	self:Hide(self.addSp)
	self:Hide(self.clickObj)
end

function ShortCutSkill:_FallBackExtendsEmptyShow()
	self:Hide(self.cannotUseSp)
	self:Show(self.addSp)
	self:Show(self.clickObj)
end

function ShortCutSkill:SetData(obj)
	self.data = obj
	self:NeedHide(false)
	self:_FallBackExtendsEmptyShow()
	if(self.data==nil) then
		self:ResetCdEffect()
		self:ClickBtnAlpha(1)
	else
		if(self.data.staticData~=nil) then
			IconManager:SetSkillIconByProfess(self.data.staticData.Icon, self.icon,MyselfProxy.Instance:GetMyProfessionType(),true)
			self:ClickBtnAlpha(0)
		else
			self.icon.spriteName = nil
			self:ClickBtnAlpha(1)
		end
		-- self:NeedHide(ShortCutProxy.Instance:SkillIsLocked(self.data.pos))
		self:TryStartCd()
	end
	self:UpdateShadow()
	self:CheckEnableUseSkill()
	self:_CheckCost()
	self:UpdatePreCondition()
	self:CheckTargetValid(Game.Myself:GetLockTarget())
end

function ShortCutSkill:ClickBtnAlpha(a)
	-- body
	self.clickObjBtn.defaultColor = Color(1,1,1,a)
	self.bgSp.alpha = a
end

function ShortCutSkill:UpdateShadow()
	if(self.data and self.data.shadow) then
		ColorUtil.ShaderGrayUIWidget(self.icon)
		self:ResetCdEffect()
	else
		ColorUtil.WhiteUIWidget(self.icon)
		self:TryStartCd()
	end
end

function ShortCutSkill:UpdatePreCondition()
	if(self.data) then
		if(self.data.fitPreCondion) then
			self.notFitCheck:RemoveReason(ShortCutSkill.FitPreCondReason)
		else
			self.notFitCheck:SetReason(ShortCutSkill.FitPreCondReason)
		end
		if(SkillProxy.Instance:HasFitSpecialCost(self.data)) then
			self.notFitCheck:RemoveReason(ShortCutSkill.FitSpecialCost)
		else
			self.notFitCheck:SetReason(ShortCutSkill.FitSpecialCost)
		end
	end
	self.preCondNotFit.gameObject:SetActive(self.data and self.notFitCheck:HasReason())
end

function ShortCutSkill:CheckTargetValid(creature)
	local fitFilterTarget = false
	if(self.data and self.data.staticData) then
		local skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
		if(skillInfo and skillInfo:GetTargetType() == SkillTargetType.Creature) then
			local staticData = self.data.staticData
			if(staticData.TargetFilter and staticData.TargetFilter.classID) then
				if(creature) then
					local classes = staticData.TargetFilter.classID
					local targetClassID = creature.data:GetClassID()
					for i=1,#classes do
						if(classes[i]==targetClassID) then
							fitFilterTarget = true
							break
						end
					end
				else
					fitFilterTarget = true
				end
			end
			if(skillInfo:TargetOnlyTeam()) then
				if(creature) then
					if(not creature:IsInMyTeam()) then
						fitFilterTarget = true
					end
				else
					fitFilterTarget = true
				end
			end
		end
	end
	if(fitFilterTarget) then
		self.notFitCheck:SetReason(ShortCutSkill.FitTargetFilter)
	else
		self.notFitCheck:RemoveReason(ShortCutSkill.FitTargetFilter)
	end
	local reason = self.notFitCheck:HasReason()
	if(self.preCondNotFit.gameObject.activeSelf~=reason) then
		self.preCondNotFit.gameObject:SetActive(reason)
	end
end

function ShortCutSkill:CheckHp(hp)
	if(self.data and self.data.staticData) then
		if(SkillProxy.Instance:HasEnoughHp(self.data:GetID(),hp)) then
			self.notFitCheck:RemoveReason(ShortCutSkill.FitHpCost)
		else
			self.notFitCheck:SetReason(ShortCutSkill.FitHpCost)
		end
		local reason = self.notFitCheck:HasReason()
		if(self.preCondNotFit.gameObject.activeSelf~=reason) then
			self.preCondNotFit.gameObject:SetActive(reason)
		end
	end
end

function ShortCutSkill:CheckSp(sp)
	if(Game.Myself.data:IsTransformed()) then
		self:Hide(self.spNotEnough)
		return
	end
	if(self.data and self.data.staticData and self.data.shadow == false and SkillProxy.Instance:HasEnoughSp(self.data:GetID(),sp)==false and self.disableMask.activeSelf == false) then
		self:Show(self.spNotEnough)
	else
		self:Hide(self.spNotEnough)
	end
end

function ShortCutSkill:_CheckCost()
	self:CheckSp()
	self:CheckHp()
end

function ShortCutSkill:CheckEnableUseSkill(val)
	if(val == nil or (self.data and val == false and self.data:GetSuperUse()~=nil)) then
		val = Game.Myself:Logic_CheckSkillCanUseByID(self.data:GetID() or 0)
	end
	if(val==nil or val == true) then
		val = not SkillProxy.Instance:ForbitUse(self.data)
	end
	if(self.data and self.data.staticData) then
		--普攻不算技能
		if(Game.Myself.data:GetAttackSkillIDAndLevel() == self.data.staticData.id) then
			val = true
		end
		if(self.data.shadow == false and val==false) then
			self:Show(self.disableMask)
		else
			self:Hide(self.disableMask)
		end
	else
		self:Hide(self.disableMask)
	end
	self:_CheckCost()
end

function ShortCutSkill:TryStartCd()
	if(self.data ~= nil and self.data.staticData~=nil and not self.data.shadow) then
		if(self:GetCD()>0) then
			self.cdCtrl:Add(self)
		else
			self:ResetCdEffect()
		end
	else
		self:ResetCdEffect()
	end
end

function ShortCutSkill:ResetCdEffect()
	self.cdCtrl:Remove(self)
	self.cdMask.fillAmount = 0
end

function ShortCutSkill:CanUseSkill()
	if(self.data ~= nil) then
		return self:GetCD()==0 and not self.data.shadow
	end
end

function ShortCutSkill:OnRemove()
	self:ResetCdEffect()
	EventManager.Me():RemoveEventListener(MyselfEvent.HpChange,self.CheckHp,self)
	EventManager.Me():RemoveEventListener(MyselfEvent.SpChange,self.CheckSp,self)
	EventManager.Me():RemoveEventListener(MyselfEvent.EnableUseSkillStateChange,self.CheckEnableUseSkill,self)
end

function ShortCutSkill:GetCD()
	return CDProxy.Instance:GetSkillItemDataCD(self.data)
end

function ShortCutSkill:GetMaxCD()
	local cdData = CDProxy.Instance:GetSkillInCD(self.data.sortID)
	local communalData = CDProxy.Instance:GetSkillInCD(CDProxy.CommunalSkillCDSortID)
	if(self.data and self.data.staticData and self.data.staticData.id == Game.Myself.data:GetAttackSkillIDAndLevel()) then
		--普攻
		return 1
	elseif(cdData ~=nil and cdData.cdMax) then
		if(communalData==nil) then
			return cdData:GetCdMax()
		end
		return math.max(cdData:GetCdMax(),communalData:GetCdMax())
	elseif(communalData) then
		return communalData:GetCdMax()
	end
	return 1
end

function ShortCutSkill:RefreshCD(f)
	self.cdMask.fillAmount = f
end

function ShortCutSkill:ClearCD(f)
	self:RefreshCD(0)
end

function ShortCutSkill:GuideBegin(skillInfo)
	if(skillInfo==nil) then
		skillInfo = Game.LogicManager_Skill:GetSkillInfo(self.data:GetID())
	end
	local duration = skillInfo:GetCastInfo(Game.Myself)
	LeanTween.value (self.leadMask.gameObject, function (v)
		self.leadMask.fillAmount = v
	end, 1,0,duration ):setDestroyOnComplete (true)
end

function ShortCutSkill:GuideEnd()
	self.leadMask.fillAmount = 0
	LeanTween.cancel(self.leadMask.gameObject)
end