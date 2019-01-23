autoImport("SocialBaseCell")

local baseCell = autoImport("BaseCell")
TutorMatcherCell = class("TutorMatcherCell", SocialBaseCell)
TutorMatcherCell.path = ResourcePathHelper.UICell("TutorMatcherCell")

local studentColor = LuaColor.New(120/255,144/255,244/255)
local tutorColor = LuaColor.New(1,228/255,135/255)

function TutorMatcherCell:Init(parent)
	self:FindObjs()
	self:AddButtonEvt()
end

function TutorMatcherCell:FindObjs()
	TutorMatcherCell.super.FindObjs(self)
	self.typeLabel = self:FindGO("type"):GetComponent(UILabel)
	--todo xde
	self.typeLabel.text = ""
	self.line = self:FindGO("line"):GetComponent(UISprite)
	self.lv  = self:FindGO("Level"):GetComponent(UILabel)
	self.confirm = self:FindGO("Confirm")
	self.professionName = self:FindGO("profession"):GetComponent(UILabel)
end

function TutorMatcherCell:AddButtonEvt()
	TutorMatcherCell.super.InitShow(self)
end

function TutorMatcherCell:SetType(type)
	self.type = type
end

function TutorMatcherCell:CreateSelf(parent)
	if(parent) then
		self.gameObject = self:CreateObj(TutorMatcherCell.path,parent)
		self:FindObjs()
	end
end

function TutorMatcherCell:SetData(data)
	TutorMatcherCell.super.SetData(self, data)
	self.data = data
	if data ~= nil then
		local iconStr = "tab_icon_05"
		if data.findtutor then
			iconStr = "tab_icon_08"
			self.typeLabel.text = ZhString.Tutor_Student
			self.typeLabel.color = studentColor
			self.line.color = studentColor
		else
			self.typeLabel.text = ZhString.Tutor_Title
			self.typeLabel.color = tutorColor
			self.line.color = tutorColor
		end

		local sb = LuaStringBuilder.CreateAsTable()
		sb:Append("Base Lv.")
		sb:Append(data.level)
		self.lv.text = sb:ToString()
		sb:Destroy()

		local prodata = Table_Class[data.profession];
		self.professionName.text = prodata.NameZh

		--todo xde fix ui
		self.typeLabel.enabled = false
		local typeSprite = self:FindGO("type"):AddComponent(UISprite)
		IconManager:SetUIIcon(iconStr,typeSprite)
		typeSprite.width = 60
		typeSprite.height = 60
		typeSprite.depth = 20
		typeSprite.transform.localPosition = Vector3(-200,4,0)
	end
end

function TutorMatcherCell:UpdataStatus(status)
	self.confirm:SetActive(status)
end