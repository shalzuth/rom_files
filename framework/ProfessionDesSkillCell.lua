local baseCell = autoImport("BaseCell")

ProfessionDesSkillCell = class("ProfessionDesSkillCell",baseCell)


function ProfessionDesSkillCell:Init(  )
	-- body
	self:initView()
end

function ProfessionDesSkillCell:initView(  )
	-- body
	self.Icon = self:FindChild("Icon"):GetComponent(UISprite);
	self.Name = self:FindChild("Name"):GetComponent(UILabel)
	self.Des = self:FindChild("Des"):GetComponent(UILabel) 
end


function ProfessionDesSkillCell:SetData( data )
	-- body
	local tableData = Table_Skill[tonumber(data)]

	IconManager:SetSkillIconByProfess(tostring(tableData.Icon), self.Icon,MyselfProxy.Instance:GetMyProfessionType())
	self.Name.text = tableData.NameZh
	self.Des.text = self:GetDesc(tableData)
end

function ProfessionDesSkillCell:GetDesc(data)
	local desc = ""
	local config
	for i=1,#data.Desc do
		config = data.Desc[i]
		desc = desc..string.format(Table_SkillDesc[config.id].Desc,unpack(config.params))..(i~=#data.Desc and "\n" or "")
	end
	return desc
end