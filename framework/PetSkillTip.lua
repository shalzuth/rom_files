autoImport("SkillTip");
PetSkillTip = class("PetSkillTip" ,SkillTip)

function PetSkillTip:Init()
	PetSkillTip.super.Init(self);
	self.calPropAffect = false;
end

function PetSkillTip:FindObjs()
	PetSkillTip.super.FindObjs(self)
	self:HideUnnecessary()
end

function PetSkillTip:HideUnnecessary()
	self:Hide(self.nextInfo)
	self:Hide(self.nextCD)
	self:Hide(self.sperator)
	self:Hide(self.useCount)
end

function PetSkillTip:SetData(data)
	self.data = data.data
	local skillData = self.data
	self:UpdateCurrentInfo(skillData.staticData)
	local layoutHeight = self:Layout()
	local height = math.max(math.min(layoutHeight+190,SkillTip.MaxHeight),SkillTip.MinHeight)
	self.bg.height = height
	self:UpdateAnchors()
	self.scroll:ResetPosition()

	self:ShowHideFunc();
	self:SetConditionLabel();
end

function PetSkillTip:SetConditionLabel()
	self.skillConf = self.data;
	self.condition.text = ZhString.PetSkillTip_NoUpgrade;
end

function PetSkillTip:UpdateCurrentInfo(skillData)
	skillData = skillData or self.data.staticData
	IconManager:SetSkillIcon(skillData.Icon, self.icon)
	self.skillName.text = skillData.NameZh
	self.currentInfo.text = self:GetDesc(skillData)
	self.currentCD.text = self:GetCD(skillData)
	self.skillLevel.text = "Lv."..skillData.Level
	self.skillLevel:UpdateAnchors()
	self:Hide(self.useCount.gameObject)
	
	self.skillType.text = GameConfig.SkillType[skillData.SkillType].name
end

function PetSkillTip:GetCD(skillData)
	local strArr = {}
	local str = ""
	local range = self:GetSkillParam(skillData,"Launch_Range",nil,nil,ZhString.SkillTip_LaunchRange)
	if(range) then
		strArr[#strArr+1] = range
	end
	strArr[#strArr+1] = self:GetCastTime(skillData)
	--CD时间
	strArr[#strArr+1] = self:GetSkillParam(skillData,"CD",nil,nil,ZhString.SkillTip_CDTime)
	--公共延迟
	strArr[#strArr+1] = self:GetSkillParam(skillData,"DelayCD",nil,nil,ZhString.SkillTip_DelayCDTime,nil)

	local cost = self:GetCost(skillData)
	if(cost~="") then
		strArr[#strArr+1] = cost
	end
	for i=1,#strArr do
		str = str..strArr[i]..(i~=#strArr and "\n" or "")
	end
	return str
end
