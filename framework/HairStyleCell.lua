local baseCell = autoImport("BaseCell")
HairStyleCell = class("HairStyleCell", baseCell)

local recycleTable = {}

E_Gender = {["None"] = 0, ["Male"] = 1, ["Female"] = 2}

function HairStyleCell:Init()
	self.goIcon = self:FindGO("Icon")
	self.spSelected = self:FindGO("Selected"):GetComponent(UISprite)
	self:CancelSelected()
	self.isSelected = false
	self:AddClickEvent(self.gameObject, function ()
		self:OnClick()
	end)
	if self.headIconCell == nil then
		self.headIconCell = HeadIconCell.new()
		self.headIconCell:CreateSelf(self.goIcon)
		local bc = self.headIconCell.gameObject:GetComponent(BoxCollider)
		if bc ~= nil then
			bc.enabled = false
		end
		self.headIconCell:SetMinDepth(0)
		self.headIconCell:SetScale(0.66)
	end
end

function HairStyleCell:SetData(data)
	local hairStyleID = data.hairStyleID or 0
	local hairColorID = data.hairColorID or 0
	local gender = data.gender or 0
	local bodyID = data.bodyID or 0

	self.data = data
	recycleTable.hairID = data.hairStyleID
	recycleTable.haircolor = data.hairColorID
	if data.gender == E_Gender.Male then
		recycleTable.gender = RoleConfig.Gender.Male
	else
		recycleTable.gender = RoleConfig.Gender.Female
	end
	local classConf = Table_Class[data.classID]
	if classConf ~= nil then
		if data.gender == E_Gender.Male then
			recycleTable.bodyID = classConf.MaleBody
		else
			recycleTable.bodyID = classConf.FemaleBody
		end
	end
	if data.gender == E_Gender.Male then
		recycleTable.eyeID = 1
	elseif data.gender == E_Gender.Female then
		recycleTable.eyeID = 2
	end
	self.headIconCell:SetData(recycleTable)
	TableUtility.TableClear(recycleTable)
end

function HairStyleCell:OnClick()
	self:Notify(CreateRoleViewEvent.HairStyleClick, {isSelected = not self.isSelected, id = self.data.hairStyleID})

	if (self.isSelected) then
		self:CancelSelected()
	else
		self:Selected()
	end
end

function HairStyleCell:Selected()
	self.isSelected = true
	self.spSelected.enabled = true
end

function HairStyleCell:CancelSelected()
	self.isSelected = false
	self.spSelected.enabled = false
end