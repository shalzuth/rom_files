local baseCell = autoImport("BaseCell")

ProfessionInfoCell = class("ProfessionInfoCell",baseCell)


function ProfessionInfoCell:Init(  )
	-- body
	self:initView()
end

function ProfessionInfoCell:initView(  )
	-- body
	self.icon = self:FindGO("icon"):GetComponent(UISprite)
	self.name = self:FindGO("name"):GetComponent(UILabel)
	self.level = self:FindGO("level"):GetComponent(UILabel)
	self.expContainer = self:FindGO("expContainer"):GetComponent(UISlider)
	self.Color = self:FindComponent("Color",UISprite)
end


function ProfessionInfoCell:SetData( data )
	-- body
	if(data == nil)then
		IconManager:SetProfessionIcon("",self.icon)
		self.name.text = ""
		self.level.text = ""
		self.expContainer.value = 0;
		self:Hide(self.expContainer.gameObject)
		self:Hide()
	else
		self:Show()
		self:Show(self.expContainer.gameObject)
		local professionData = data.professionData
		--------------------------------------------------------------------------
		local setSuc = IconManager:SetProfessionIcon(professionData.icon,self.icon)
		self.gameObject:SetActive(setSuc);
		--------------------------------------------------------------------------
		self.name.text = professionData.NameZh
		self.level.text = "Lv."..data:GetLevelText()

		local referenceValue = Table_JobLevel[data.level+1];
		if(referenceValue == nil)then
			referenceValue = 1;
		else
			referenceValue = referenceValue.JobExp;
		end

		local colorKey = "CareerIconBg"..professionData.Type;
		self.Color.color = ColorUtil[colorKey];;
		self.expContainer.value = data.exp/referenceValue;
	end
end