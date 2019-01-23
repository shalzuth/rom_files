local baseCell = autoImport("BaseCell");
RoleEquipStrengthCell = class("RoleEquipStrengthCell",baseCell);

function RoleEquipStrengthCell:Init()
	self:FindObjs()
	self.levelDesc.text = ZhString.RoleEquipStrengthCell_StrengthLv;
	self:AddBtnListener()
end

function RoleEquipStrengthCell:FindObjs()
	self.bg = self.gameObject:GetComponent(UIMultiSprite)
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self.iconName = self:FindGO("IconName"):GetComponent(UILabel)
	self.levelDesc = self:FindGO("LevelDesc"):GetComponent(UILabel)
	self.level = self:FindGO("Level"):GetComponent(UILabel)
	self.effect = self:FindGO("Effect"):GetComponent(UILabel)
	self.quality = self:FindChild("Quality"):GetComponent(GradientUISprite);
end

function RoleEquipStrengthCell:SetIconName(name)
	self.iconName.text = name
end

function RoleEquipStrengthCell:Select()
	self.bg.CurrentState = 1
end

function RoleEquipStrengthCell:UnSelect()
	self.bg.CurrentState = 0
end

function RoleEquipStrengthCell:AddBtnListener()
	self:SetEvent(self.gameObject,function ()
		self:DispatchEvent(MouseEvent.MouseClick)
	end)
end

function RoleEquipStrengthCell:SetData(data)
	self.data = data
	if(not self.data) then
		self:EmptyCell()
	else
		self:UpdataCell()
	end
end

function RoleEquipStrengthCell:EmptyCell()
	self:Hide(self.icon.gameObject)
	self:Hide(self.levelDesc.gameObject)
	self:Hide(self.effect.gameObject)
	self:Hide(self.quality.gameObject)
	self:Show(self.iconName.gameObject)
	self.level.text = ZhString.RoleEquipStrengthCell_NoEquip;
end

function RoleEquipStrengthCell:UpdataCell()
	self:Show(self.icon.gameObject)
	self:Show(self.levelDesc.gameObject)
	self:Show(self.effect.gameObject)
	self:Show(self.quality.gameObject)
	self:Hide(self.iconName.gameObject)
	IconManager:SetItemIcon(self.data.staticData.Icon, self.icon)
	self.icon:MakePixelPerfect()
	self.icon.transform.localScale = Vector3(0.8,0.8,1)
	self:UpdateQuality()
	self:UpdateLevel()
end

function RoleEquipStrengthCell:UpdateQuality()
	local qInt = self.data.staticData.Quality;
	local color = CustomColor.ItemFrameColor[qInt];
	-- self.quality.gameObject:SetActive(false);
	self.quality.gradientTop = color;
end

function RoleEquipStrengthCell:UpdateLevel()
	local curLv = self.data.equipInfo.strengthlv
	local max = BlackSmithProxy.Instance:MaxStrengthLevel(self.data)
	self.level.text = curLv.."/"..max
	self.effect.text = self.data.equipInfo:StrengthInfo()
end