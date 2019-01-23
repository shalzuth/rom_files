autoImport("SkillTip");
AdventureSkillTip = class("AdventureSkillTip" ,SkillTip)

function AdventureSkillTip:FindObjs()
	AdventureSkillTip.super.FindObjs(self)
	self:HideUnnecessary()
end

function AdventureSkillTip:HideUnnecessary()
	self:Hide(self.nextInfo)
	self:Hide(self.nextCD)
	self:Hide(self.sperator)
	self:Hide(self.useCount)
end

function AdventureSkillTip:SetData(data)
	self.data = data.data
	local skillData = self.data
	self:UpdateCurrentInfo(skillData)
	self:SetConditionLabel()
	local layoutHeight = self:Layout()
	local height = math.max(math.min(layoutHeight+190,SkillTip.MaxHeight),SkillTip.MinHeight)
	self.bg.height = height
	self:UpdateAnchors()
	self.scroll:ResetPosition()
	self.skillInfo = nil
end

function AdventureSkillTip:SetConditionLabel()
	self.skillConf = self.data
	self.condition.text = ConditionUtil.GetSkillConditionStr(self.skillConf,true,false,ConditionUtil.CostType.AdventureSkillPoint)
end