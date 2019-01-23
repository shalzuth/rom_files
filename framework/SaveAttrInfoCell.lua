local baseCell = autoImport("BaseCell")
SaveAttrInfoCell = class("SaveAttrInfoCell",baseCell)
function SaveAttrInfoCell:Init()	
	self:initView()
end

function SaveAttrInfoCell:initView(  )
	-- body
	self.name = self:FindGO("name"):GetComponent(UILabel)
	self.value = self:FindGO("value"):GetComponent(UILabel)
end

function SaveAttrInfoCell:SetData( data )
	-- body
	self.name.text = data.name..":"
	self.value.text = "[ff8a00]"..data.value.."[-]"
end