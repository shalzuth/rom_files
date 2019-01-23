local baseCell = autoImport("BaseCell")
PresetTextCell = class("PresetTextCell", baseCell)

function PresetTextCell:Init()
	PresetTextCell.super.Init(self)

	self:FindObjs()
	self:AddCellClickEvent()

	self:SetEvent(self.EditorButton, function ()
		self.textInput.isSelected = true
	end);
	local callback = function(isSelect)
		if isSelect then
			self.collider.enabled = false
			self.textInputCollider.enabled = true
		else
			self.collider.enabled = true
			self.textInputCollider.enabled = false
			self:TextInputOnSubmit()
		end
	end
	self.textInput.callback = callback
end

function PresetTextCell:FindObjs()
	self.collider = self.gameObject:GetComponent(BoxCollider)
    self.textInput = self:FindGO("textInput"):GetComponent(UIInputSelectDelegate)
    self.textInputCollider = self.textInput.gameObject:GetComponent(BoxCollider)
    self.EditorButton = self:FindGO("EditorButton")
	self.EditorButtonLabel=self:FindGO("EditorButtonLabel")
end

function PresetTextCell:SetData(data)
	self.data=data
	if(data)then
		self.gameObject:SetActive(true)

		self.textInput.value = data.msg
	else
		self.gameObject:SetActive(false)
	end

	self.collider.enabled = true
	self.textInputCollider.enabled = false
end

function PresetTextCell:TextInputOnSubmit()
	self.data:SetMsg(self.textInput.value)
	ChatRoomProxy.Instance.isEditorPresetText=true
end