autoImport("HeadIconCell")

SkillBeingHeadCell = class("SkillBeingHeadCell",HeadIconCell)

function SkillBeingHeadCell:Init()
	self.active = true
	self.state = HeadIconCell.State.StandFace
	self:CreateSelf(self.gameObject)
	SkillBeingHeadCell.super.Init(self)
	self.clickObj.gameObject:AddComponent(UIDragScrollView)
end

function SkillBeingHeadCell:CreateSelf(parent)
	if(parent) then
		self:CreateObj(HeadIconCell.path,parent)
		self:FindObjs()
	end
end

function SkillBeingHeadCell:FindObjs()
	SkillBeingHeadCell.super.FindObjs(self)
	self.clickObj = self:FindGO("HeadIconCell"):GetComponent(UIWidget)
	self.bgColorSp = self:FindGO("BgColor"):GetComponent(UISprite)
	self.selectSp = self:FindGO("SelectSp")

	self:SetEvent(self.clickObj.gameObject,function ()
		self:PassEvent(MouseEvent.MouseClick, self)
	end)
end

function SkillBeingHeadCell:SetActive(val,emojiChange)
	local active = self.active
	SkillBeingHeadCell.super.SetActive(self,val,emojiChange)
	if(active~=val) then
		if(val) then
			if(self.bgColor) then
				self.bgColorSp.color = self.bgColor
			else
				ColorUtil.WhiteUIWidget(self.bgColorSp)
			end
		else
			ColorUtil.ShaderLightGrayUIWidget(self.bgColorSp)
		end
	end
end

function SkillBeingHeadCell:SetSelect(val)
	if(val) then
		self:Show(self.selectSp)
	else
		self:Hide(self.selectSp)
	end
end

function SkillBeingHeadCell:SetBgColor(colorStr)
	local hasC
	hasC,self.bgColor = ColorUtil.TryParseHexString(colorStr)
	if(self.active) then
		self.bgColorSp.color = self.bgColor
	end
end

function SkillBeingHeadCell:SetData(data)
	self.beingData = data
	local headImageData = data.headImageData
	headImageData:TransByBeingInfoData(SkillProxy.Instance:GetBeingNpcInfo(data.id))
	if(headImageData.iconData)then
		if(headImageData.iconData.type == HeadImageIconType.Avatar)then
			SkillBeingHeadCell.super.SetData(self,headImageData.iconData);
		elseif(headImageData.iconData.type == HeadImageIconType.Simple)then
			SkillBeingHeadCell.super.SetSimpleIcon(self,headImageData.iconData.icon);
		end
	end
	if(data.beingData.Color) then
		self:SetBgColor(data.beingData.Color)
	end
	self:SetSelect(data.isSelect)
	self:SetActive(data.isEnabled)
end