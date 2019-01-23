local baseCell = autoImport("BaseCell")
ProfessionInfoPanelCell = class("ProfessionInfoPanelCell",baseCell)
function ProfessionInfoPanelCell:Init()	
	self:initView()
end

function ProfessionInfoPanelCell:initView(  )
	-- body
	self.name = self:FindGO("name"):GetComponent(UILabel)
	self.value = self:FindGO("value"):GetComponent(UILabel)
end

function ProfessionInfoPanelCell:SetData( data )
	-- body
	self.name.text = data.name..":"
	self.value.text = "[ff8a00]+"..data.value.."[-]"
end