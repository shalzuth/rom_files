autoImport("SocialBaseCell")

local baseCell = autoImport("BaseCell")
TutorApplyCell = class("TutorApplyCell", SocialBaseCell)

function TutorApplyCell:Init()
	self:FindObjs()
	self:AddButtonEvt()
end

function TutorApplyCell:FindObjs()
	TutorApplyCell.super.FindObjs(self)

	self.info = self:FindGO("Info"):GetComponent(UILabel)
end

function TutorApplyCell:AddButtonEvt()
	TutorApplyCell.super.InitShow(self)

	local addBtn = self:FindGO("AddBtn")
	self:AddClickEvent(addBtn,function ()
		self:Add()
	end)

	local ignoreBtn = self:FindGO("IgnoreBtn")
	self:AddClickEvent(ignoreBtn,function ()
		self:Ignore()
	end)
end

function TutorApplyCell:SetData(data)
	TutorApplyCell.super.SetData(self, data)
	
	if data then
		if data:IsTutorApply() then
			self.info.text = ZhString.Tutor_TutorApply
		else
			self.info.text = ZhString.Tutor_StudentApply
		end
	end
end

function TutorApplyCell:Add()
	if self.data then
		local tempArray = ReusableTable.CreateArray()
		tempArray[1] = self.data.guid

		local relation
		if self.data:IsTutorApply() then
			relation = SocialManager.PbRelation.Tutor
		else
			relation = SocialManager.PbRelation.Student
		end
		ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, relation)
		ReusableTable.DestroyArray(tempArray)
	end
end

function TutorApplyCell:Ignore()
	if self.data then
		local relation
		if self.data:IsTutorApply() then
			relation = SocialManager.PbRelation.TutorApply
		else
			relation = SocialManager.PbRelation.StudentApply
		end
		ServiceSessionSocialityProxy.Instance:CallRemoveRelation(self.data.guid, relation)
	end
end