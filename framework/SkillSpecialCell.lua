local baseCell = autoImport("BaseCell")

SkillSpecialCell = class("SkillSpecialCell",baseCell)


function SkillSpecialCell:Init(  )
	self.cellEnable = true
	self:initView()
end

function SkillSpecialCell:initView(  )
	self.selectSP = self:FindChild("SpecialSelect"):GetComponent(UISprite);
	self.tip = self:FindChild("SkillSpecialTip"):GetComponent(UILabel) 
	self.clicksp = self:FindChild("SpecialBg")
	self:SetEvent(self.clicksp,function ()
		if(self.cellEnable) then
			self:PassEvent(MouseEvent.MouseClick, self)
		end
	end)
end


function SkillSpecialCell:SetData( data )
	self.data = data
	self:UnSelect()
	self.tip.text = data.RuneName
end

function SkillSpecialCell:Select()
	self:Show(self.selectSP.gameObject)
end

function SkillSpecialCell:UnSelect()
	self:Hide(self.selectSP.gameObject)
end

function SkillSpecialCell:IsSelect()
	return self.selectSP.gameObject.activeSelf
end

function SkillSpecialCell:SetEnable(v)
	if(self.cellEnable~=v) then
		self.cellEnable = v
		if(v) then
			ColorUtil.BlackLabel(self.tip)
			ColorUtil.WhiteUIWidget(self.selectSP)
		else
			ColorUtil.GrayUIWidget(self.tip)
			ColorUtil.ShaderGrayUIWidget(self.selectSP)
		end
	end
end