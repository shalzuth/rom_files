local baseCell = autoImport("BaseCell")
HeadwearCell = class("HeadwearCell", baseCell)

function HeadwearCell:Init()
	self.sp = self:FindGO("Icon"):GetComponent(UISprite)
	self.spSelected = self:FindGO("Selected"):GetComponent(UISprite)
	self:CancelSelected()
	self.isSelected = false
	self:AddClickEvent(self.gameObject, function ()
		self:OnClick()
	end)
end

function HeadwearCell:SetData(data)
	self.data = data
	IconManager:SetItemIcon(data.icon, self.sp)
	self.sp:MakePixelPerfect()
end

function HeadwearCell:OnClick()
	self:Notify(CreateRoleViewEvent.HeadwearClick, {isSelected = not self.isSelected, id = self.data.id})

	if (self.isSelected) then
		self:CancelSelected()
	else
		self:Selected()
	end
end

function HeadwearCell:Selected()
	self.isSelected = true
	self.spSelected.enabled = true
end

function HeadwearCell:CancelSelected()
	self.isSelected = false
	self.spSelected.enabled = false
end